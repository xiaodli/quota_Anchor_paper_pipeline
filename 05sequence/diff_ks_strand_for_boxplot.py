import random
import pandas as pd
import argparse
import numpy as np


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
    ks = parameter.ks_file
    output = parameter.output_file
    column1 = parameter.column1
    column2 = parameter.column2
    threshold = parameter.threshold

    ##get ks dict
    ks_df = pd.read_csv(ks, sep="\t", index_col=None, header=0)
    if threshold > 50:
        pass
    else:
        ks_df = ks_df[(ks_df[column1] >= 0) & (ks_df[column1] <= threshold)]
    ks_df["new_key"] = ks_df["id1"].astype(str) + "_" + ks_df["id2"].astype(str)
    dict_df = ks_df.loc[:, ["new_key", column1]]
    dit = dict_df.set_index("new_key")[column1].to_dict()

    _, info = read_collinearity(collinearity)
    df = pd.DataFrame(info)
    df.columns = ["ref_name", "ref_chr", "ref_order", "ref_start", "ref_end",
                         "query_name", "query_chr", "query_order", "query_start", "query_end",
                         "same_or_inverse", "score"]
    df = df[["query_name", "ref_name", "same_or_inverse"]]
    same, inv= split_inv_normal_to_pair(df)
    # same = random.choices(same, k=50000)
    # inv = random.choices(inv, k=10000)


    recent_same_ks = []
    recent_inv_ks = []

    for zm, sb in same:
        if zm + "_" + sb in dit:
            recent_same_ks.append(dit[zm + "_" + sb])
    for zm, sb in inv:
        if zm + "_" + sb in dit:
            recent_inv_ks.append(dit[zm + "_" + sb])

    recent_same_column = ["Speciation_gene_pairs_same_direction"] * len(recent_same_ks)
    recent_inv_column = ["Speciation_gene_pairs_inverse_direction"] * len(recent_inv_ks)

    recent_same_df = pd.DataFrame({"Type":recent_same_column, column2: recent_same_ks})
    recent_inv_df = pd.DataFrame({"Type":recent_inv_column, column2: recent_inv_ks})
    print(len(recent_same_ks), len(recent_inv_ks))
    print("average")
    # if np.average(recent_same_ks) - np.average(recent_inv_ks) > 0:
    #     print(output)
    print(np.average(recent_same_ks) - np.average(recent_inv_ks))
    print("median")
    print(np.median(recent_same_ks)- np.median(recent_inv_ks))
    # if np.median(recent_same_ks) - np.median(recent_inv_ks) > 0:
    #     print(output)
    print("std")
    # if np.std(recent_same_ks) - np.std(recent_inv_ks) > 0:
    #     print(output)
    print(np.std(recent_same_ks) - np.std(recent_inv_ks))
    print()

    merged_df = pd.concat([recent_same_df, recent_inv_df])
    merged_df.to_csv(output, header=True, index=None)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='ks,ka,omega difference based on syntenic gene pairs')

    subparsers1 = parser.add_subparsers(title='ks difference', dest='ks_diff')
    parser_sub1 = subparsers1.add_parser('ks_diff', help='ks difference based on syntenic gene pairs')
    parser_sub1.add_argument("-W", "--collinearity", dest="collinearity_file", type=str, default="", help="collinearity file by quota_Anchor")
    parser_sub1.add_argument("-ks", "--ks", dest="ks_file", type=str, default="", help="ks file")
    parser_sub1.add_argument("-c1", "--column1", dest="column1", type=str, default="", help="ks_NG86, ks_YN00, ks")
    parser_sub1.add_argument("-c2", "--column2", dest="column2", type=str, default="", help="ks , ka ,omega")
    parser_sub1.add_argument("-t", "--threshold", dest="threshold", type=float, default=3, help="threshold")
    parser_sub1.add_argument("-o", "--output", dest="output_file", type=str, default="", help="output file")
    parser_sub1.set_defaults(func=main)


    args = parser.parse_args()
    if hasattr(args, 'func'):
        if args.ks_diff == "ks_diff":
            args.func(args)
    else:
        parser.print_help()
