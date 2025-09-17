import pandas as pd
import numpy as np
import process_file
import corr_analysis


# step(1) min block length
# step(2) calculate the distance between the gene pair and the edge of the block
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


def read_three_file(col_file1, length, query_expr_dict, ref_expr_dict, bootstrap, size, method, corr):
    df_list = []

    _, recent_info = read_collinearity(col_file1, length)
    recent_df = pd.DataFrame(recent_info)
    recent_df.columns = ["ref_name", "ref_chr", "ref_order", "ref_start", "ref_end",
                                             "query_name", "query_chr", "query_order", "query_start", "query_end",
                                             "same_or_inverse", "score"]
    recent_df = recent_df[["query_name", "ref_name", "same_or_inverse"]]

    same, inv = process_file.split_inv_normal_to_pair(recent_df)

    same_list_ele_tuple = process_file.get_corr_data(query_expr_dict, ref_expr_dict, same, bootstrap, size)
    same_dict_corr = corr_analysis.size_corr(same_list_ele_tuple, method)
    corr_df1 = pd.DataFrame(list(same_dict_corr.items()), columns=["Index1", "Corr_Value1"])
    df_list.append(corr_df1)

    inv_list_ele_tuple = process_file.get_corr_data(query_expr_dict, ref_expr_dict, inv, bootstrap, size)
    inv_dict_corr = corr_analysis.size_corr(inv_list_ele_tuple, method)
    corr_df2 = pd.DataFrame(list(inv_dict_corr.items()), columns=["Index2", "Corr_Value2"])
    df_list.append(corr_df2)

    corr_df = pd.concat(df_list, axis=1, ignore_index=False)
    # df_no_na = corr_df.replace({pd.NA: ''})
    df_no_na = corr_df.fillna('')
    df_no_na.to_csv(corr, header=True, index=False)

def read_expression_matrix_xlsx(file, bool_log, sheet_suffix, sheet_prefix):
    query_prefix = sheet_prefix.split("_")[0]
    ref_prefix = sheet_prefix.split("_")[1]

    query = pd.read_excel(file, header=0, sheet_name = query_prefix + "_" + sheet_suffix)
    query.iloc[:, 0] = query.iloc[:, 0].astype(str)
    if bool_log == "T":
        numeric_columns = query.select_dtypes(include=np.number).columns
        query[numeric_columns] = np.log2(query[numeric_columns] + 1)
    query.columns.values[0] = "gene_name"

    Ref = pd.read_excel(file, header=0, sheet_name = ref_prefix + "_"+ sheet_suffix)
    Ref.iloc[:, 0] = Ref.iloc[:, 0].astype(str)
    if bool_log == "T":
        numeric_columns = Ref.select_dtypes(include=np.number).columns
        Ref[numeric_columns] = np.log2(Ref[numeric_columns] + 1)
    Ref.columns.values[0] = "gene_name"

    return Ref, query
