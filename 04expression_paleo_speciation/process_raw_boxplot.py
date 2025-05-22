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
            if str_number == "3":
                list_6 = ["Speciation_gene_pairs"] * length
                df["Speciation_gene_pairs"] = list_6
                df3 = df.loc[:, ["Speciation_gene_pairs", "Corr_Value3"]]
                df3.columns = columns_list
                df_list.append(df3)
            if str_number == "4":
                list_8 = ["Paleo_gene_pairs"] * length
                df["Paleo_gene_pairs"] = list_8
                df4 = df.loc[:, ["Paleo_gene_pairs", "Corr_Value4"]]
                df4.columns = columns_list
                df_list.append(df4)
            if str_number == "5":
                list_10 = ["Homologous_gene_pairs"] * length
                df["Homologous_gene_pairs"] = list_10
                df5 = df.loc[:, ["Homologous_gene_pairs", "Corr_Value5"]]
                df5.columns = columns_list
                df_list.append(df5)

    merged_df1 = pd.concat(df_list)
    merged_df1 = merged_df1.dropna(subset=['Corr_Value'])
    merged_df1.to_csv(output_file, header=True, index=False)
