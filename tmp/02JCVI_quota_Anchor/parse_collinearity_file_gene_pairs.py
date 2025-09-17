import pandas as pd
import networkx as nx
import sys

def get_gene_pair(file):
    df = pd.read_csv(file, header=None, index_col=None, sep="\t")
    pair_list = list(df[0] + "_" + df[1])
    return pair_list

def split_two_part(file):
    # step one
    df = pd.read_csv(file, header=None, index_col=None, sep="\t")
    df.set_index(df.columns[0], inplace=True)
    query_ref = df[1].to_dict()

    # step two
    part1 = []
    part2 = []
    part3 = []
    G = nx.read_edgelist(file)
    clusters = list(nx.connected_components(G))

    query_number = 0
    ref_number = 0
    anchors_dict = {}
    three_big_cluster = {"1_1": [], "2_1": [], "other_ratio": []}
    for cluster_id, cluster in enumerate(clusters):
        for node in cluster:
            if node.startswith('gene:Z'):
                query_number += 1
            if node.startswith('gene:S'):
                ref_number += 1
        if str(query_number) + "_" + str(ref_number) not in anchors_dict:
            anchors_dict[str(query_number) + "_" + str(ref_number)] = 1
        else:
            anchors_dict[str(query_number) + "_" + str(ref_number)] += 1

        # get 1_1, 2_1 and other_ratio big cluster
        if str(query_number) + "_" + str(ref_number) == "1_1":
            for node in cluster:
                three_big_cluster["1_1"].append(node)
        elif str(query_number) + "_" + str(ref_number) == "2_1":
            for node in cluster:
                three_big_cluster["2_1"].append(node)
        else:
            for node in cluster:
                three_big_cluster["other_ratio"].append(node)
        query_number = 0
        ref_number = 0

    # step three
    final_dict = {"other_ratio": 0}
    for ratio in anchors_dict:
        if ratio == "1_1" or ratio == "2_1":
            final_dict[ratio] = anchors_dict[ratio]
        else:
            final_dict["other_ratio"] += anchors_dict[ratio]

    # step four
    for key, value in query_ref.items():
        if key in three_big_cluster["1_1"]:
            assert value in three_big_cluster["1_1"]
            part1.append(key + "_" + value)
            continue
        if key in three_big_cluster["2_1"]:
            part2.append(key + "_" + value)
            assert value in three_big_cluster["2_1"]
            continue
        if key in three_big_cluster["other_ratio"]:
            part3.append(key + "_" + value)
            assert value in three_big_cluster["other_ratio"]
            continue

    return part1, part2, part3

if  __name__ == "__main__":
    jcvi_default_file = sys.argv[1]
    jcvi_diamond_file = sys.argv[2]
    jcvi_blast_file = sys.argv[3]
    quota_Anchor_diamond_file = sys.argv[4]
    quota_Anchor_blast_file = sys.argv[5]
    output_file1 = sys.argv[6]
    output_file2 = sys.argv[7]

    jcvi_default_file_list= get_gene_pair(jcvi_default_file)
    jcvi_diamond_file_list = get_gene_pair(jcvi_diamond_file)
    jcvi_blast_file_list = get_gene_pair(jcvi_blast_file)
    quota_Anchor_diamond_file_list = get_gene_pair(quota_Anchor_diamond_file)
    quota_Anchor_blast_file_list = get_gene_pair(quota_Anchor_blast_file)

    jcvi_default_file_list_part1, jcvi_default_file_list_part2, jcvi_default_file_list_part3 = split_two_part(jcvi_default_file)
    jcvi_diamond_file_list_part1, jcvi_diamond_file_list_part2, jcvi_diamond_file_list_part3 = split_two_part(jcvi_diamond_file)
    jcvi_blast_file_list_part1, jcvi_blast_file_list_part2, jcvi_blast_file_list_part3 = split_two_part(jcvi_blast_file)
    quota_Anchor_diamond_file_list_part1, quota_Anchor_diamond_file_list_part2, quota_Anchor_diamond_file_list_part3 = split_two_part(quota_Anchor_diamond_file)
    quota_Anchor_blast_file_list_part1, quota_Anchor_blast_file_list_part2, quota_Anchor_blast_file_list_part3 = split_two_part(quota_Anchor_blast_file)

    df = pd.DataFrame({"jcvi_default":pd.Series(jcvi_default_file_list),
                       "jcvi_diamond":pd.Series(jcvi_diamond_file_list),
                       "jcvi_blast":pd.Series(jcvi_blast_file_list),
                       "quota_Anchor_diamond":pd.Series(quota_Anchor_diamond_file_list),
                       "quota_Anchor_blast":pd.Series(quota_Anchor_blast_file_list),
                       "jcvi_default_part1":pd.Series(jcvi_default_file_list_part1),
                       "jcvi_default_part2":pd.Series(jcvi_default_file_list_part2),
                       "jcvi_default_part3": pd.Series(jcvi_default_file_list_part3),
                       "jcvi_diamond_part1": pd.Series(jcvi_diamond_file_list_part1),
                       "jcvi_diamond_part2": pd.Series(jcvi_diamond_file_list_part2),
                       "jcvi_diamond_part3": pd.Series(jcvi_diamond_file_list_part3),
                       "jcvi_blast_part1": pd.Series(jcvi_blast_file_list_part1),
                       "jcvi_blast_part2": pd.Series(jcvi_blast_file_list_part2),
                       "jcvi_blast_part3": pd.Series(jcvi_blast_file_list_part3)
                      })
    df.to_csv(output_file1, sep="\t", index=False)

    with open(output_file2, "w") as f:
        f.write("Software" + "\t" + "X_variable" +  "\t" + "number" + "\n")

        f.write("quota_align default" + "\t" + str("1:1")  + "\t" +  str(len(jcvi_default_file_list_part1)) + "\n")
        f.write("quota_align default" + "\t" + str("2:1") + "\t" + str(len(jcvi_default_file_list_part2)) + "\n")
        f.write("quota_align default" + "\t" + str("other_ratio") + "\t"+ str(len(jcvi_default_file_list_part3)) + "\n")

        f.write("quota_align diamond" + "\t" + str("1:1")  + "\t" +  str(len(jcvi_diamond_file_list_part1)) + "\n")
        f.write("quota_align diamond" + "\t" + str("2:1") + "\t" + str(len(jcvi_diamond_file_list_part2)) + "\n")
        f.write("quota_align diamond" + "\t" + str("other_ratio") + "\t"+ str(len(jcvi_diamond_file_list_part3)) + "\n")

        f.write("quota_align blastp" + "\t" + str("1:1")  + "\t" +  str(len(jcvi_blast_file_list_part1)) + "\n")
        f.write("quota_align blastp" + "\t" + str("2:1") + "\t" + str(len(jcvi_blast_file_list_part2)) + "\n")
        f.write("quota_align blastp" + "\t" + str("other_ratio") + "\t"+ str(len(jcvi_blast_file_list_part3)) + "\n")

        f.write("quota_Anchor diamond" + "\t" + str("1:1") + "\t" + str(len(quota_Anchor_diamond_file_list_part1)) + "\n")
        f.write("quota_Anchor diamond" + "\t" + str("2:1") + "\t"+ str(len(quota_Anchor_diamond_file_list_part2)) + "\n")
        f.write("quota_Anchor diamond" + "\t" + str("other_ratio") + "\t" + str(len(quota_Anchor_diamond_file_list_part3)) + "\n")

        f.write("quota_Anchor blastp" + "\t" + str("1:1") + "\t" + str(len(quota_Anchor_blast_file_list_part1)) + "\n")
        f.write("quota_Anchor blastp" + "\t" + str("2:1") + "\t"+ str(len(quota_Anchor_blast_file_list_part2)) + "\n")
        f.write("quota_Anchor blastp" + "\t" + str("other_ratio") + "\t" + str(len(quota_Anchor_blast_file_list_part3)) + "\n")
