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
    identity = parameter.collinearity_file
    output = parameter.output_file

    _, info = read_collinearity(collinearity)
    df = pd.DataFrame(info)
    df.columns = ["ref_name", "ref_chr", "ref_order", "ref_start", "ref_end",
                         "query_name", "query_chr", "query_order", "query_start", "query_end",
                         "same_or_inverse", "score"]
    df = df[["query_name", "ref_name", "same_or_inverse"]]
    same, inv= split_inv_normal_to_pair(df)

    same_len = len(same)
    inv_len = len(inv)
    total_len = len(same) + len(inv)

    inv_len_ratio = round((inv_len / total_len) * 100, 2)
    same_len_ratio = round(100.00 - inv_len_ratio, 2)

    collinearity = os.path.basename(collinearity)
    species_name = re.sub(r'Joinvillea.ascendens.', '', collinearity)
    species_name = re.sub(r'.collinearity', '', species_name)
    species_name = re.sub(r'[-_]', '.', species_name)
    first_sub_str = True
    for sub_str in species_name.split("."):
        if first_sub_str:
            species_name = sub_str[0] + "." + " "
            first_sub_str = False
        else:
            species_name += sub_str + "."
    species_name = species_name[:-1]

    with open (output, "a+") as f:
        if os.path.getsize(output) == 0:
            f.write("Species,Type,Number,Ratio\n")
        f.write(str(species_name) + "," + "SSD" + "," + str(same_len) + "," + f"{same_len_ratio:.2f}" + "\n" )
        f.write(str(species_name) + "," + "SID" + "," + str(inv_len) + "," + f"{inv_len_ratio:.2f}" + "\n")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Identity difference based on syntenic gene pairs')

    subparsers1 = parser.add_subparsers(title='ks difference', dest='ks_diff')
    parser_sub1 = subparsers1.add_parser('ks_diff', help='ks difference based on syntenic gene pairs')
    parser_sub1.add_argument("-W", "--collinearity", dest="collinearity_file", type=str, default="", help="collinearity file by quota_Anchor")
    parser_sub1.add_argument("-o", "--output", dest="output_file", type=str, default="", help="output file")
    parser_sub1.set_defaults(func=main)

    args = parser.parse_args()
    if hasattr(args, 'func'):
        if args.ks_diff == "ks_diff":
            args.func(args)
    else:
        parser.print_help()
