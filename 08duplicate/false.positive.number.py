import sys
import  GffFile
import pandas as pd
import os

def get_gene_info(gff):
    chr_gene_dict, chr_gene_list, gene_chr_dict, _ = GffFile.readGff(gff)

    gene_index = dict()
    for refChr in chr_gene_list:
        i = 0
        while i < len(chr_gene_list[refChr]):
            gene_index[chr_gene_list[refChr][i].name] = i + 1
            i += 1

    return gene_index, gene_chr_dict

if __name__ == '__main__':
    # szm.gff3
    gene_index, gene_chr_dict = get_gene_info(sys.argv[2])
    false_positive_number_map = dict()
    Dup_Gen_finder_file = sys.argv[1]
    output = sys.argv[3]
    with open(Dup_Gen_finder_file) as f:
        next(f)
        for line in f:
            row_list = line.split()
            gene1_name = row_list[0]
            gene1_chr = gene_chr_dict[gene1_name]
            gene2_name = row_list[2]
            gene2_chr = gene_chr_dict[gene2_name]

            if gene1_chr == gene2_chr:
                gene1_rank = gene_index[gene1_name]
                gene2_rank = gene_index[gene2_name]
                rank_distance = abs(gene1_rank - gene2_rank)
                # if rank_distance < 10:
                if str(rank_distance) in false_positive_number_map:
                    false_positive_number_map[str(rank_distance)] += 1
                else:
                    false_positive_number_map[str(rank_distance)] = 1
    output_handle = open(output, "w")
    output_handle.write("gene1" + "\t" + "gene2" + "\t" + "Rank distance" + "\t" + "Number" + "\n")
    for dis in false_positive_number_map:
        if int(dis) < 10:
            dis_number =  false_positive_number_map[dis]
            output_handle.write(gene1_name + "\t" + gene2_name + "\t" + str(dis) + "\t" + str(dis_number) + "\n")
