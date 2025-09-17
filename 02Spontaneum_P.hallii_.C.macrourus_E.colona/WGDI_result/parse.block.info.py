import pandas as pd
import sys


def get_position_name_map(final_gff3):
    map_chr_id_name = dict()
    with open(final_gff3) as f:
        for line in f:
            line_list = line.split("\t")
            chr_ = line_list[0]
            order= line_list[5]
            gene_name = line_list[1]
            if chr_ not in map_chr_id_name:
                map_chr_id_name[chr_] = dict()
                map_chr_id_name[chr_][order] =  gene_name
            else:
                map_chr_id_name[chr_][order] = gene_name

    return map_chr_id_name

def read_csv_corr(corr_csv, map_chr_id_gene, sa_map_chr_id_gene, output_file):
    out_handler = open(output_file, 'w')
    df = pd.read_csv(corr_csv, sep=',', header=0, index_col=None)
    print(df.columns)
    df['chr1'] = df['chr1'].astype(str)
    df['chr2'] = df['chr2'].astype(str)
    df['block1'] = df['block1'].astype(str)
    df['block2'] = df['block2'].astype(str)
    for i, row in df.iterrows():
        qry_chr = row['chr1']
        ref_chr = row['chr2']
        e_c_qry = row['block1']
        sa_ref = row['block2']
        E_C_qry_position = e_c_qry.split("_")
        Sa_ref_position = sa_ref.split("_")
        pair_position = zip(E_C_qry_position, Sa_ref_position)
        for qry_posi, ref_posi in  pair_position:
            name1 = map_chr_id_gene[qry_chr][qry_posi]
            name2 = sa_map_chr_id_gene[ref_chr][ref_posi]
            out_handler.write(name1 + "\t" + name2 + "\n")
    out_handler.close()


if __name__ == '__main__':
    corr_csv = sys.argv[1]
    final_gff3 = sys.argv[2]
    sa_final_gff3 = sys.argv[3]
    output_file = sys.argv[4]
    map_chr_id_gene_ = get_position_name_map(final_gff3)
    sa_map_chr_id_gene_ = get_position_name_map(sa_final_gff3)
    read_csv_corr(corr_csv, map_chr_id_gene_, sa_map_chr_id_gene_, output_file)