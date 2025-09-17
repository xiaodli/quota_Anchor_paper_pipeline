import sys
import os


def read_collinearity(file, min_block_length):
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


import pandas as pd
import random
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


sb_zm = sys.argv[1]
zgc_sb = sys.argv[2]
zgc_zm = sys.argv[3]
output = sys.argv[4]
file_lists = [zgc_sb, sb_zm, zgc_zm]

flag = 0
for file in file_lists:
    _, recent_info = read_collinearity(file, 5)
    recent_df = pd.DataFrame(recent_info)
    recent_df.columns = ["ref_name", "ref_chr", "ref_order", "ref_start", "ref_end",
                                             "query_name", "query_chr", "query_order", "query_start", "query_end",
                                             "same_or_inverse", "score"]
    recent_df = recent_df[["query_name", "ref_name", "same_or_inverse"]]

    same, inv = split_inv_normal_to_pair(recent_df)

    speciation_ssd_number = len(same)
    speciation_sid_number = len(inv)
    speciation = speciation_sid_number + speciation_ssd_number

    speciation_ssd_number_ratio = round((speciation_ssd_number / speciation) * 100, 2)
    speciation_sid_number_ratio =  round(100.00 - speciation_ssd_number_ratio, 2)
    species_name = ""
    if flag == 0:
        species_name = "sorghum vs wheat"
    elif flag == 1:
        species_name = "sorghum vs maize"
    else:
        species_name = "maize vs wheat"
    with open (output, "a+") as f:
        if os.path.getsize(output) == 0:
            f.write("Species,Type,Number,Ratio\n")
        f.write(str(species_name) + "," + "SSD" + "," + str(speciation_ssd_number) + "," + f"{speciation_ssd_number_ratio:.2f}" + "\n" )
        f.write(str(species_name) + "," + "SID" + "," + str(speciation_sid_number) + "," + f"{speciation_sid_number_ratio:.2f}" + "\n")
    flag += 1
