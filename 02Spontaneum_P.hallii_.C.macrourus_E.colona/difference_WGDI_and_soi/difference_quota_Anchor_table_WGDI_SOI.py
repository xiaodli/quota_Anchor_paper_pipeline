import sys
import  GffFile
import pandas as pd
import os

def get_gene_info(ref_gff, query_gff):
    ref_chr_gene_dict, ref_chr_gene_list, ref_gene_chr_dict, _ = GffFile.readGff(ref_gff)
    query_chr_gene_dict, query_chr_gene_list, query_gene_chr_dict, _ = GffFile.readGff(query_gff)

    ref_gene_index = dict()
    for refChr in ref_chr_gene_list:
        i = 0
        while i < len(ref_chr_gene_list[refChr]):
            ref_gene_index[ref_chr_gene_list[refChr][i].name] = i + 1
            i += 1

    query_gene_index = dict()
    for queryChr in query_chr_gene_list:
        i = 0
        while i < len(query_chr_gene_list[queryChr]):
            query_gene_index[query_chr_gene_list[queryChr][i].name] = i + 1
            i += 1

    return ref_gene_chr_dict, query_gene_chr_dict, ref_gene_index, query_gene_index

# parse /media/dell/E/analysis/02JCVI_quota_Anchor/plot_countstyle/zm.sb.last.filtered
def get_table_info(file, ref_gene_chr_dict, query_gene_chr_dict, ref_gene_index, query_gene_index):

    last_df = pd.read_csv(file, sep="\t", header=None, index_col=None, comment="#")
    # last_df = last_df[last_df[1].map(ref_gene_chr_dict) == "7"]
    query_gene_list = list(last_df[6])
    ref_gene_list = list(last_df[0])

    query_chr_list = last_df[6].map(query_gene_chr_dict)
    ref_chr_list = last_df[0].map(ref_gene_chr_dict)

    query_index_list = last_df[6].map(query_gene_index)
    ref_index_list = last_df[0].map(ref_gene_index)
    plot_df = pd.DataFrame({"query_gene": query_gene_list, "ref_gene": ref_gene_list, "query_chr": query_chr_list, "ref_chr": ref_chr_list, "query_index": query_index_list, "ref_index": ref_index_list})
    return plot_df

def get_pairs(file):
    sub_df = pd.read_csv(file, index_col=None, header=None, sep="\t", comment="#")
    pair_map = {}
    for i, row in sub_df.iterrows():
        pair_map[row[5] + "\t" + row[0]] = "shared_gene_pairs"
    return pair_map

def wgdi_soi_get_pairs(file):
    sub_df = pd.read_csv(file, index_col=None, header=None, sep="\t", comment="#")
    pair_map = {}
    for i, row in sub_df.iterrows():
        pair_map[row[1] + "\t" + row[0]] = "shared_gene_pairs"
    return pair_map


if __name__ == '__main__':
    # sb.gff3 zm.gff3
    software = sys.argv[7]
    ref_gene_chr_dict, query_gene_chr_dict, ref_gene_index, query_gene_index = get_gene_info(sys.argv[1], sys.argv[2])

    blast_df = get_table_info(sys.argv[3], ref_gene_chr_dict, query_gene_chr_dict, ref_gene_index, query_gene_index)

    blast_df["Type"] = "homo"
    quota_anchor_map = get_pairs(sys.argv[4])
    quota_anchor_keys = quota_anchor_map.keys()

    wgdi_soi_pairs_map = wgdi_soi_get_pairs(sys.argv[5])
    wgdi_soi_keys = wgdi_soi_pairs_map.keys()

    total_map = {**quota_anchor_map, **wgdi_soi_pairs_map}

    quota_Anchor_minus_wgdi_soi = list(set(quota_anchor_keys) - set(wgdi_soi_keys))
    for i in quota_Anchor_minus_wgdi_soi:
        total_map[i] = "quota_Anchor"

    wgdi_soi_minus_quota_Anchor = list(set(wgdi_soi_keys) - set(quota_anchor_keys))
    for j in wgdi_soi_minus_quota_Anchor:
        total_map[j] = software

    ## add new dot
    new_rows = []
    blast_keys = (blast_df["query_gene"] + "\t" + blast_df["ref_gene"]).tolist()
    for i in total_map.keys():
        if i not in blast_keys:
            query_gene = i.split("\t")[0]
            ref_gene = i.split("\t")[1]
            if ref_gene.startswith("ref"):
                continue
            query_chr = query_gene_chr_dict[query_gene]
            ref_chr = ref_gene_chr_dict[ref_gene]
            query_id = query_gene_index[query_gene]
            ref_id = ref_gene_index[ref_gene]
            new_rows.append({
                "query_gene": query_gene,
                "ref_gene": ref_gene,
                "query_chr": query_chr,
                "ref_chr": ref_chr,
                "query_index": query_id,
                "ref_index": ref_id
            })
    if new_rows:
        new_df = pd.DataFrame(new_rows)
        blast_df = pd.concat([blast_df, new_df], ignore_index=True)

    blast_df["Type"] = blast_df.apply(
        lambda row: total_map.get(f"{row['query_gene']}\t{row['ref_gene']}", row["Type"]),
        axis=1
    )

    blast_df.to_csv(sys.argv[6], sep="\t", index=False)
