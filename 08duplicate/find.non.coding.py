import sys
import re

output_handle = open(sys.argv[2], "w")

non_coding = set()
with open(sys.argv[1]) as f:
    for line in f:
        if not line.startswith("#"):
            m = re.search(r'^(\S+)\t(\S+)\tgene\t(\d+)\t+(\d+)\t+(\S+)\t+(\S+)\t+(\S+)\t+ID=([\s\S]+?);(\S+)', line)
            if m is not None:
                gn_name = m.group(8)
                flag = True
                continue
            else:
                m = re.search(r'^(\S+)\t(\S+)\ttranscript\t(\d+)\t+(\d+)\t+(\S+)\t+(\S+)\t+(\S+)\t+ID=([\s\S]+?);(\S+)',
                              line)
                if m is not None:
                    non_coding.add(gn_name)

output_handle.write("non_coding\n")
for i in non_coding:
    output_handle.write(i + "\n")

output_handle.close()