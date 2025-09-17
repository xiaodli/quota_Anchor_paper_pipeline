import sys


output_handle = open(sys.argv[2], "w")
out_dict = {}
with open(sys.argv[1]) as f:
    for line in f:
        row_list = line.split("\t")
        chr_ = row_list[0]
        if chr_ not in out_dict:
            out_dict[chr_] = line
        else:
            out_dict[chr_] += line

for i in out_dict:
    output_handle.write(out_dict[i] + "###\n")