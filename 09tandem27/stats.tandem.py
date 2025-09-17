import networkx as nx
import sys
import pandas as pd


merged_pair_file = sys.argv[1]
nx_input = str(merged_pair_file) + ".txt"
out_put = sys.argv[2]
out_put_handle = open(out_put, "w")
# get position info
df = pd.read_csv(merged_pair_file, sep='\t', header=0, index_col=None)
df["Duplicate1"] = df["Duplicate1"].astype(str)
df["Duplicate2"] = df["Duplicate2"].astype(str)
gene_position_map = {}
gene_chr_map = {}
for index, row in df.iterrows():
    split_cols1 = row['Location1'].split('-')
    chr1 = split_cols1[1]
    rank1 = split_cols1[2]
    if row["Duplicate1"] not in gene_position_map:
        gene_position_map[row["Duplicate1"]] = rank1
        gene_chr_map[row["Duplicate1"]] = chr1
    split_cols2 = row['Location2'].split('-')
    chr2 = split_cols2[1]
    rank2 = split_cols2[2]
    if row["Duplicate2"] not in gene_position_map:
        gene_position_map[row["Duplicate2"]] = rank2
        gene_chr_map[row["Duplicate2"]] = chr2


final_cluster = []
G = nx.read_edgelist(nx_input)
clusters = list(nx.connected_components(G))
for cluster_id, cluster in enumerate(clusters):
    cluster_list = list(cluster)
    sorted_cluster = sorted(cluster_list, key=lambda x: (gene_chr_map[x], int(gene_position_map[x])))
    result = []
    current_sub_cluster = [sorted_cluster[0]]

    for i in range(1, len(sorted_cluster)):
        prev_gene = sorted_cluster[i - 1]
        curr_gene = sorted_cluster[i]

        if int(gene_position_map[curr_gene]) - int(gene_position_map[prev_gene]) > 5 or gene_chr_map[curr_gene] != gene_chr_map[prev_gene]:
            result.append(current_sub_cluster)
            current_sub_cluster = [curr_gene]
        else:
            current_sub_cluster.append(curr_gene)
    result.append(current_sub_cluster)
    for i in result:
        final_cluster.append(i)
sorted_list = sorted(final_cluster, key=lambda x: (gene_chr_map[x[0]], int(gene_position_map[x[0]])))

for idx, cluster in enumerate(sorted_list):
    tandem_cluster_name = "tandem" + str(idx+1).zfill(5)
    out_put_handle.write(tandem_cluster_name + "\t" + str(gene_chr_map[cluster[0]]) + "\t" + "\t".join(cluster) + "\n")
