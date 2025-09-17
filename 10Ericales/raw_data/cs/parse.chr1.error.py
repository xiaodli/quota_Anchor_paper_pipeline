import sys

from Bio import SeqIO
chr1 = ""
for seq_record in SeqIO.parse(sys.argv[2], "fasta"):
    if seq_record.id == "chr6":
        print(seq_record.id)
        chr1 = str(seq_record.seq)
        print(len(seq_record))

flag = False
with open(sys.argv[1]) as f:
    for line in f:
        row_list = line.split("\t")
        # print(row_list)
        start = int(row_list[3])
        end = int(row_list[4])

        if row_list[2] == "mRNA":
            flag = True
            continue
        if row_list[2] == "CDS":
            if flag:
                # print(start)
                # print(chr1[0])
                if chr1[start-1: start+2]  != "ATG":
                    print(start, end="\t")
                    print(end, end="\t")
                    print(chr1[start+1: start+4])
                flag = False
