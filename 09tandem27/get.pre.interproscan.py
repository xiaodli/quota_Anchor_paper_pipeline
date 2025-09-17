import sys
import pandas as pd
from Bio import SeqIO
import GffFile

pep_file = sys.argv[1]
gff_path = sys.argv[2]
output = sys.argv[3]
length_file = sys.argv[4]

pep = SeqIO.to_dict(SeqIO.parse(pep_file, "fasta"))
_, _, geneName_toChr_dict, _ = GffFile.readGff(gff_path)

len_df = pd.read_csv(length_file, sep='\t', header=0, index_col=None)
len_df["chr"] = len_df["chr"].astype(str)
chr_list = len_df["chr"].tolist()

print(output)
sp_list = []
flag =False
for gene in pep.keys():
    chromosome = geneName_toChr_dict[gene]
    if chromosome in chr_list and "*" not in pep[gene].seq:
        sp_list.append(pep[gene])

print(len(sp_list))
SeqIO.write(sp_list, output, "fasta")
