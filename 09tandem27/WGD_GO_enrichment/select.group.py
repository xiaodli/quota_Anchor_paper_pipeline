import sys
import pandas as pd

group_tsv = sys.argv[1]
group_name_number_wgd_ratio = sys.argv[2]
wgd_ratio = float(sys.argv[3])
top_number= int(sys.argv[4])
output = sys.argv[5]
group_wgd_gene_number= int(sys.argv[6])

output_handle = open(output, "w")

## determine group name
df_stats = pd.read_csv(group_name_number_wgd_ratio, header=0, index_col=None, sep="\t")
df_stats = df_stats[df_stats["wgd_gene_ratio"] >= wgd_ratio]
df_stats = df_stats[df_stats["group_gene_number"] >= group_wgd_gene_number]
df_stats = df_stats.sort_values(by=["group_gene_number"], ascending=False)[:top_number]
group_name_list = df_stats["group_name"].to_list()

## read group tsv
df_group = pd.read_csv(group_tsv, header=0, index_col="Orthogroup", sep="\t", dtype=str)
df_group = df_group.fillna("0")
for i in group_name_list:
    row_series = df_group.loc[i]
    for sp in row_series:
        if sp and sp != "0":
            gene_list = [gene.strip() for gene in sp.split(",")]
            for _gn in gene_list:
                output_handle.write(_gn + "\n")
output_handle.close()
