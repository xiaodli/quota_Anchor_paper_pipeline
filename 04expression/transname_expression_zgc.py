import sys
import re
import pandas as pd


tran_dict = {}
with open(sys.argv[1], 'r') as f:
    for line in f:
        m = re.search(r'^(\S+)\t(\S+)\tgene\t(\d+)\t+(\d+)\t+(\S+)\t+(\S+)\t+(\S+)\t+.*ID=(\w+?);[\s\S]*previous_id=(\w+?);', line)
        if m is not None:
            gene_name = m.group(8)
            expression_file_gene_name = m.group(9)
            tran_dict[expression_file_gene_name] = gene_name
        if m is None:
            m = re.search(
                r'^(\S+)\t(\S+)\tgene\t(\d+)\t+(\d+)\t+(\S+)\t+(\S+)\t+(\S+)\t+.*ID=(\w+?);[\s\S]*previous_id=(\w+?)$',line)
            if m is not None:
                gene_name = m.group(8)
                expression_file_gene_name = m.group(9)
                tran_dict[expression_file_gene_name] = gene_name

zgc_shoot = pd.read_excel(sys.argv[2], header=0, sheet_name="ZGC_shoot")
zgc_shoot["sample"] = zgc_shoot["sample"].map(tran_dict).fillna(zgc_shoot["sample"])
zgc_shoot.to_excel(sys.argv[3], sheet_name="ZGC_shoot", index=False)

zgc_root = pd.read_excel(sys.argv[2], header=0, sheet_name="ZGC_root")
zgc_root["sample"] = zgc_root["sample"].map(tran_dict).fillna(zgc_root["sample"])
zgc_root.to_excel(sys.argv[4], sheet_name="ZGC_root", index=False)

