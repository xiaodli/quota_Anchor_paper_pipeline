import pandas as pd
import sys
import os

def count_lines_with_readlines(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()
    return len(lines)


outfile = open(sys.argv[3], 'w')
df1 = pd.read_csv(sys.argv[1], header=0, sep="\t", index_col="Type")
df1["Number"] = df1["Number"].astype(str)
outfile.write("Type1,Tool,Number" + "\n" +
              "wgd.genes,quota_Anchor," + df1.loc['wgd.genes', "Number"] + "\n" +
              "tandem.genes,quota_Anchor," + df1.loc['tandem.genes', "Number"] + "\n" +
              "proximal.genes,quota_Anchor," + df1.loc['proximal.genes', "Number"] + "\n" +
              "transposed.genes,quota_Anchor," + df1.loc['transposed.genes', "Number"] + "\n" +
              "dispersed.genes,quota_Anchor," + df1.loc['dispersed.genes', "Number"] + "\n" +
              "singleton.genes,quota_Anchor," + df1.loc['singleton.genes', "Number"] + "\n")

dup_dir = sys.argv[2]
for i in ["wgd.genes", "tandem.genes", "proximal.genes", "transposed.genes", "dispersed.genes"]:
    filename = "zm." + i + "-unique"
    file_path = os.path.join(dup_dir, filename)
    number = count_lines_with_readlines(file_path) - 1
    outfile.write(i + "," + "DupGen_finder," + str(number) + "\n")

singleton_number = count_lines_with_readlines(os.path.join(dup_dir, "zm.singletons")) - 1
outfile.write("singleton.genes," + "DupGen_finder," + str(singleton_number) + "\n")