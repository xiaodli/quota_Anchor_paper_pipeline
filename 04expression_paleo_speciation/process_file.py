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


def get_expr_dict(query_df, ref_df, column, ref_df_columns):
    # delete GL(two letters) prefix for columns
    headers = [column_name[2:] if not column_name.startswith("g") else column_name for column_name in ref_df_columns]
    query_df.columns = headers
    ref_df.columns = headers

    new_column_list = ["gene_name", "R1-" + column, "R2-" + column, "R3-" + column]
    mean_list_column = ["R1-" + column, "R2-" + column, "R3-" + column]

    query_df = query_df.loc[:, new_column_list]
    query_df[column] = query_df[mean_list_column].mean(axis=1)
    query_df = query_df.loc[:, ["gene_name", column]]
    query_df.set_index("gene_name", inplace=True)
    query_dict = query_df[column].to_dict()

    ref_df = ref_df.loc[:, new_column_list]
    ref_df[column] = ref_df[mean_list_column].mean(axis=1)
    ref_df = ref_df.loc[:, ["gene_name", column]]
    ref_df.set_index("gene_name", inplace=True)
    ref_dict = ref_df[column].to_dict()

    query_dict = {k: v for k, v in query_dict.items() if v != 0}
    ref_dict = {k: v for k, v in ref_dict.items() if v != 0}
    return query_dict, ref_dict


def get_corr_data(query_expr_dict, ref_expr_dict, same_or_inv, bootstrap, size):
    new_same_or_inv_expr_list = []
    for query, ref in same_or_inv:
        if query.startswith("gene"):
            query = query[5:]
        if ref.startswith("gene"):
            ref = ref[5:]
        if query not in query_expr_dict or ref not in ref_expr_dict:
            continue
        else:
            query_expr_value = query_expr_dict[query]
            ref_expr_value = ref_expr_dict[ref]
            new_same_or_inv_expr_list.append((query_expr_value, ref_expr_value))
    total_info = [random.sample(new_same_or_inv_expr_list, size) for _ in range(bootstrap)]
    return total_info


def tuple_ele_list_to_two_list(sub_list):
    query_list = []
    ref_list = []
    for query, ref in sub_list:
        query_list.append(query)
        ref_list.append(ref)
    return query_list, ref_list
