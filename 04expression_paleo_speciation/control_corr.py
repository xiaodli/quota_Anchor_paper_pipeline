import read_file_shuffle as read_file
import process_file
import pandas as pd
import corr_analysis


def block_total_corr(parameter):
    expression_file = parameter.expression
    table_file=parameter.table_file
    collinearity = parameter.collinearity
    collinearity_total = parameter.collinearity_total
    corr = parameter.corr
    method = parameter.method
    column = parameter.column
    bool_log = parameter.bool_log
    length = parameter.Block_min
    sheet_suffix = parameter.sheet_name
    bootstrap = parameter.bootstrap
    size = parameter.sample_size
    sheet_prefix=parameter.sheet_prefix

    # left is sorghum(ref) and right is maize(query)
    ref_expr_df, query_expr_df = read_file.read_expression_matrix_xlsx(expression_file, bool_log, sheet_suffix, sheet_prefix)

    ref_df_columns = ref_expr_df.columns.copy()
    query_expr_dict, ref_expr_dict = process_file.get_expr_dict(query_expr_df, ref_expr_df, column, ref_df_columns)

    if collinearity != "":
        read_file.read_three_file(table_file, collinearity, collinearity_total, length, query_expr_dict, ref_expr_dict, bootstrap, size, method, corr)
