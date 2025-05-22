import pandas as pd


def process(parameter):
    input_file = parameter.input
    output_file = parameter.output

    df = pd.read_csv(input_file, header=0, sep=",")
    columns_list = ["Type", "Corr_Value"]

    df_list = []
    length = len(df)
    column = df.columns
    width = len(column)

    for i in range(width):
        if i % 2 == 0:
            a = column[i]
            str_number = str(a)[-1]
            if str_number == "1":
                list_2 = ["Speciation_gene_pairs_same_direction"] * length
                df["Speciation_gene_pairs_same_direction"] = list_2
                df1 = df.loc[:, ["Speciation_gene_pairs_same_direction", "Corr_Value1"]]
                df1.columns = columns_list
                df_list.append(df1)
            if str_number == "2":
                list_4 = ["Speciation_gene_pairs_inverse_direction"] * length
                df["Speciation_gene_pairs_inverse_direction"] = list_4
                df2 = df.loc[:, ["Speciation_gene_pairs_inverse_direction", "Corr_Value2"]]
                df2.columns = columns_list
                df_list.append(df2)

    merged_df1 = pd.concat(df_list)
    merged_df1 = merged_df1.dropna(subset=['Corr_Value'])
    merged_df1.to_csv(output_file, header=True, index=False)
