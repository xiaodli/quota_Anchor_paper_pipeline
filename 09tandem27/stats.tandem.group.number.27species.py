import sys
import pandas as pd
import json


def cluster_number():
    json_dict = {}
    max_length = []
    sp_depth_map = {}
    summary_file = "tandem.cluster.number.summary.txt"
    output_file_handle = open(summary_file, 'w')
    output_file_handle.write("Depth" + "\t" + "Species" + "\t" + "Cluster_number" + "\t" + "Cluster_length_max" + "\t" + "tandem_total_number" + "\n")
    species_file = sys.argv[1]
    df = pd.read_csv(species_file, sep=r"\s+", header=None, index_col=None)
    df.columns = ["Species", "Depth"]
    for index, row in df.iterrows():
        species = row["Species"][:-4]

        if species == "Joinvillea.ascendens":
            continue
        depth = row["Depth"]
        input_file_path = "./" + species + "_class" + "/" + species + ".tandem.genes.stats"
        tandem_gene_number_path = "./" + species + "_class" + "/" + species + ".tandem.gene.txt"
        tandem_gene_number = len(pd.read_csv(tandem_gene_number_path, sep='\t', header=None, index_col=None))
        cluster_info = {}
        cluster_length_max = 0
        with open(input_file_path) as f:
            for line in f:
                row_list = line.split("\t")
                cluster_name = row_list[0]
                cluster_length = len(row_list) - 2
                cluster_length_max = max(cluster_length_max, cluster_length)
                cluster_length = str(cluster_length)
                if cluster_length not in cluster_info:
                    cluster_info[cluster_length] = 1
                else:
                    cluster_info[cluster_length] += 1
        cluster_info = {k: cluster_info[k] for k in sorted(cluster_info.keys(), key=lambda x: int(x))}
        cluster_number = sum(cluster_info.values())
        max_length.append(cluster_length_max)
        new_species_name = ""
        first_sub_str = True
        for sub_str in species.split("."):
            if first_sub_str:
                new_species_name = sub_str[0] + "." + " "
                first_sub_str = False
            else:
                new_species_name += sub_str + "."
        species = new_species_name[:-1]
        sp_depth_map[species] = depth
        json_dict[species] = cluster_info
        output_file_handle.write(str(depth) + "\t" + str(species) + "\t" + str(cluster_number) + "\t" + str(cluster_length_max) + "\t"+ str(tandem_gene_number) + "\n")
    output_file_handle.close()

    df = pd.read_csv(summary_file, sep='\t', header=0, index_col=None)
    df.sort_values(by=df.columns[0], inplace=True)
    df.to_csv(summary_file, sep='\t', index=False, header=True)

    return max_length, json_dict, sp_depth_map

def curve_plot(length_list, sp_dict, sp_depth_map):
    out_file = "curve.txt"
    out_handle = open(out_file, 'w')
    out_handle.write("Depth" + "\t" + "Species" + "\t" + "Cluster_length" + "\t" + "Cluster_number" + "\n")
    x_axis_length = max(length_list)
    for sp in sp_dict:
        depth = str(sp_depth_map[sp])
        length_dict = sp_dict[sp]
        for i in range(2, x_axis_length + 1):
            if str(i) not in length_dict:
                length_dict[str(i)] = 0
            out_handle.write(str(depth) + "\t" + sp + "\t" + str(i) + "\t" + str(length_dict[str(i)]) + "\n")

    df = pd.read_csv(out_file, sep='\t', header=0, index_col=None)
    df.sort_values(by=["Depth", "Species", "Cluster_length"], inplace=True)
    df.to_csv(out_file, sep='\t', index=False, header=True)

    return

max_length, json_dict, sp_depth_map = cluster_number()
with open("data.json", "w", encoding="utf-8") as json_file:
    json.dump(json_dict, json_file, indent=4, ensure_ascii=False)
curve_plot(max_length, json_dict, sp_depth_map)