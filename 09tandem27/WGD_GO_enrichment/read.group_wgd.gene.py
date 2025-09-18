import sys
import pandas as pd

group_tsv = sys.argv[1]
wgd_gene_file = sys.argv[2]
group_stats = sys.argv[3]

# output_file
group_stats_handle = open(group_stats, 'w')
group_stats_handle.write("group_name" + "\t" + "group_gene_number" + "\t" + "wgd_gene_ratio" + "\n")

# get wgd gene
df = pd.read_csv(wgd_gene_file, sep='\t', header=None, index_col=None)
wgd_set = set(df[df.columns[0]])

# get wgd ratio
with open(group_tsv, 'r') as f:
    next(f)
    for line in f:
        every_group_gene_number = 0
        every_group_wgd_gene_number = 0
        row_list = line.split('\t')
        for i in range(1,29):
            if i == 19:
                # remove outgroup gene (Joinvillea.ascendens)
                continue
            else:
                every_species_gene_list = row_list[i].split(',')
                if every_species_gene_list:
                    for gene in every_species_gene_list:
                        gn = gene.strip()
                        every_group_gene_number += 1
                        if gn in wgd_set:
                            every_group_wgd_gene_number += 1
        wgd_gene_ratio = round((every_group_wgd_gene_number / every_group_gene_number) * 100, 2)
        group_stats_handle.write(row_list[0] + '\t' + str(every_group_gene_number) + '\t' + str(wgd_gene_ratio) + '\n')
group_stats_handle.close()

