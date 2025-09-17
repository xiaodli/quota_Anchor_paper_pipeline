import random
import pandas as pd
import argparse
import numpy as np
import os, re


def read_collinearity(file, min_block_length=0):
    total_info = []
    block_info = []
    total_pre_df_core_record_list = []
    flag = True
    with open(file) as f:
        next(f)
        next(f)
        for line in f:
            if line.startswith('#'):
                # append recent block_info
                if block_info:
                    total_info.append(block_info)
                    block_info = []

                header_record_list = line.split()
                # get block length
                block_length = int(header_record_list[2].split("=")[1])
                if block_length < int(min_block_length):
                    flag = False
                    continue
                else:
                    flag = True
                    # get block direction
                    block_direction = header_record_list[5]
                    if block_direction == "POSITIVE":
                        block_direction = "+"
                    if block_direction == "NEGATIVE":
                        block_direction = "-"
                    block_info.append(block_direction)
                    block_info.append(block_length)
            else:
                # length >= min_block_length
                if flag:
                    new_core_record_list = line.split()
                    if new_core_record_list[-2] == block_direction:
                        judge_direction = "same"
                    else:
                        judge_direction = "inverse"
                    new_core_record_list[-2] = judge_direction
                    total_pre_df_core_record_list.append(tuple(new_core_record_list))

        if block_info:
            total_info.append(block_info)
    return total_info, set(total_pre_df_core_record_list)


def split_inv_normal_to_pair(df):
    same_direction_short_groups = df.query('`same_or_inverse` == "same"')
    same_query = same_direction_short_groups.loc[:, "query_name"].to_list()
    same_ref = same_direction_short_groups.loc[:, "ref_name"].to_list()
    same = list(zip(same_query, same_ref))

    inv_direction = df.query('`same_or_inverse` == "inverse"')
    inv_query = inv_direction.loc[:, "query_name"].to_list()
    inv_ref = inv_direction.loc[:, "ref_name"].to_list()
    inv = list(zip(inv_query, inv_ref))
    random.shuffle(same)
    random.shuffle(inv)
    return same, inv

def gaussian_approximate_fuc(x, head, center, fake_sd):
    y = np.zeros_like(x) + head * np.exp(-((x - center)/fake_sd)**2)
    return y

def main(parameter):
    collinearity = parameter.collinearity_file
    total_collinearity = parameter.total_collinearity
    output = parameter.output_file

    ssd_map = dict()
    sid_map = dict()

    # get speciation event syntenic gene pairs
    _, recent_info = read_collinearity(collinearity)
    recent_df = pd.DataFrame(recent_info)
    recent_df.columns = ["ref_name", "ref_chr", "ref_order", "ref_start", "ref_end",
                         "query_name", "query_chr", "query_order", "query_start", "query_end",
                         "same_or_inverse", "score"]
    recent_df = recent_df[["query_name", "ref_name", "same_or_inverse"]]
    same, inv = split_inv_normal_to_pair(recent_df)
    speciation = list(set(same) | set(inv))

    # get paleo syntenic gene pairs
    _, total_info = read_collinearity(total_collinearity)
    total_df = pd.DataFrame(total_info)
    total_df.columns = ["ref_name", "ref_chr", "ref_order", "ref_start", "ref_end",
                        "query_name", "query_chr", "query_order", "query_start", "query_end",
                        "same_or_inverse", "score"]
    total_df = total_df[["query_name", "ref_name", "same_or_inverse"]]
    total_same, total_inv = split_inv_normal_to_pair(total_df)
    total = list(set(total_same) | set(total_inv))
    # Note: This is a rough division
    paleo = list(set(total) - set(speciation))

    speciation_ssd_number = len(same)
    speciation_sid_number = len(inv)
    print(speciation_ssd_number)
    print(speciation_sid_number)
    paleo_ssd_number = 0
    paleo_sid_number = 0
    for i in paleo:
        if i in total_same:
            paleo_ssd_number += 1
        if i in total_inv:
            paleo_sid_number += 1

    collinearity = os.path.basename(collinearity)
    species_name = re.sub(r'.collinearity', '', collinearity)
    species_name_map = {"zgc1_sb3": "sorghum vs wheat", "sb2_zm1": "sorghum vs maize", "zgc2_zm3": "maize vs wheat"}
    species_name = species_name_map[species_name]
    speciation_ssd_number_ratio = round((speciation_ssd_number / len(speciation)) * 100, 2)
    speciation_sid_number_ratio =  round(100.00 - speciation_ssd_number_ratio, 2)
    paleo_ssd_number_ratio = round((paleo_ssd_number / len(paleo)) * 100, 2)
    paleo_sid_number_ratio = round(100.00 - paleo_ssd_number_ratio, 2)

    with open (output, "a+") as f:
        if os.path.getsize(output) == 0:
            f.write("Species,Stage, Type,Ratio\n")
        f.write(str(species_name) + "," + "Speciation" + "," + "SSD" + "," + f"{speciation_ssd_number_ratio:.2f}" + "\n" )
        f.write(str(species_name) + "," + "Speciation" + "," + "SID" + "," + f"{speciation_sid_number_ratio:.2f}" + "\n")
        f.write(str(species_name) + "," + "Paleo" + "," + "SSD" + "," + f"{paleo_ssd_number_ratio:.2f}" + "\n")
        f.write(str(species_name) + "," + "Paleo" + "," + "SID" + "," + f"{paleo_sid_number_ratio:.2f}" + "\n")
        # f.write(str(species_name) + "," + "Speciation" + "," + "SSD" + "," + str(speciation_ssd_number) + "\n" )
        # f.write(str(species_name) + "," + "Speciation" + "," + "SID" + "," + str(speciation_sid_number) + "\n")
        # f.write(str(species_name) + "," + "Paleo" + "," + "SSD" + "," + str(paleo_ssd_number) + "\n")
        # f.write(str(species_name) + "," + "Paleo" + "," + "SID" + "," + str(paleo_sid_number) + "\n")
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='SSD and SID determination based on syntenic gene pairs and different ratio across different stages')

    subparsers1 = parser.add_subparsers(title='difference', dest='diff')
    parser_sub1 = subparsers1.add_parser('diff', help='SSD and SID difference based on syntenic gene pairs')
    parser_sub1.add_argument("-W", "--collinearity", dest="collinearity_file", type=str, default="", help="collinearity file by quota_Anchor")
    parser_sub1.add_argument("-W1", "--total_collinearity", dest="total_collinearity", type=str, default="",
                             help="total collinearity file by quota_Anchor")
    parser_sub1.add_argument("-o", "--output", dest="output_file", type=str, default="", help="output file")
    parser_sub1.set_defaults(func=main)

    args = parser.parse_args()
    if hasattr(args, 'func'):
        if args.diff == "diff":
            args.func(args)
    else:
        parser.print_help()
