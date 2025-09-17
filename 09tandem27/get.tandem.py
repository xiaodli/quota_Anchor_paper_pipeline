import sys
import pandas as pd
from Bio import SeqIO


input_ = sys.argv[1]
gene_list_file = sys.argv[2]
length_file = sys.argv[3]
length_threshold = int(sys.argv[4])

gene_list_file_handle = open(gene_list_file, "w")

len_df = pd.read_csv(length_file, sep='\t', header=0, index_col=None)
len_df["chr"] = len_df["chr"].astype(str)
chr_list = len_df["chr"].tolist()

flag =False
print(gene_list_file)
with open(input_, 'r') as f:
    for line in f:
        row_list = line.split()
        chromosome = str(row_list[1])
        length = len(row_list) - 2
        if length >= length_threshold:
            flag= True
        else:
            flag = False
        gene_list = row_list[2:]
        if chromosome in chr_list and flag:
            for i in gene_list:
                gene_list_file_handle.write(str(i) + "\n")
