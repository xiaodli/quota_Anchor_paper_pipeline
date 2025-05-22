import networkx as nx
import sys

def get_three_type(file):
    G = nx.read_edgelist(file)
    clusters = list(nx.connected_components(G))
    query_number = 0
    ref_number = 0
    anchors_dict = {}
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
        query_number = 0
        ref_number = 0

    final_dict = {"other_ratio": 0}
    for ratio in anchors_dict:
        if ratio == "1_1" or ratio == "2_1":
            final_dict[ratio] = anchors_dict[ratio]
        else:
            final_dict["other_ratio"] += anchors_dict[ratio]
    return final_dict

if  __name__ == "__main__":
    jcvi_default_file = sys.argv[1]
    jcvi_diamond_file = sys.argv[2]
    jcvi_blast_file = sys.argv[3]
    quota_Anchor_diamond_file = sys.argv[4]
    quota_Anchor_blast_file = sys.argv[5]
    output_file = sys.argv[6]

    jcvi_default_dict = get_three_type(jcvi_default_file)
    jcvi_diamond_dict = get_three_type(jcvi_diamond_file)
    jcvi_blast_dict = get_three_type(jcvi_blast_file)
    quota_Anchor_diamond_dict = get_three_type(quota_Anchor_diamond_file)
    quota_Anchor_blast_dict = get_three_type(quota_Anchor_blast_file)

    with open(output_file, "w") as f:
        f.write("Software" + "\t" + "X_variable" +  "\t" + "number" + "\n")

        f.write("quota_align default" + "\t" + str("1:1")  + "\t" +  str(jcvi_default_dict["1_1"]) + "\n")
        f.write("quota_align default" + "\t" + str("2:1") + "\t" + str(jcvi_default_dict["2_1"]) + "\n")
        f.write("quota_align default" + "\t" + str("other_ratio") + "\t"+ str(jcvi_default_dict["other_ratio"]) + "\n")

        f.write("quota_align diamond" + "\t" + str("1:1")  + "\t" +  str(jcvi_diamond_dict["1_1"]) + "\n")
        f.write("quota_align diamond" + "\t" + str("2:1") + "\t" + str(jcvi_diamond_dict["2_1"]) + "\n")
        f.write("quota_align diamond" + "\t" + str("other_ratio") + "\t"+ str(jcvi_diamond_dict["other_ratio"]) + "\n")

        f.write("quota_align blastp" + "\t" + str("1:1")  + "\t" +  str(jcvi_blast_dict["1_1"]) + "\n")
        f.write("quota_align blastp" + "\t" + str("2:1") + "\t" + str(jcvi_blast_dict["2_1"]) + "\n")
        f.write("quota_align blastp" + "\t" + str("other_ratio") + "\t"+ str(jcvi_blast_dict["other_ratio"]) + "\n")

        f.write("quota_Anchor diamond" + "\t" + str("1:1") + "\t" + str(quota_Anchor_diamond_dict["1_1"]) + "\n")
        f.write("quota_Anchor diamond" + "\t" + str("2:1") + "\t"+ str(quota_Anchor_diamond_dict["2_1"]) + "\n")
        f.write("quota_Anchor diamond" + "\t" + str("other_ratio") + "\t" + str(quota_Anchor_diamond_dict["other_ratio"]) + "\n")

        f.write("quota_Anchor blastp" + "\t" + str("1:1") + "\t" + str(quota_Anchor_blast_dict["1_1"]) + "\n")
        f.write("quota_Anchor blastp" + "\t" + str("2:1") + "\t"+ str(quota_Anchor_blast_dict["2_1"]) + "\n")
        f.write("quota_Anchor blastp" + "\t" + str("other_ratio") + "\t" + str(quota_Anchor_blast_dict["other_ratio"]) + "\n")
