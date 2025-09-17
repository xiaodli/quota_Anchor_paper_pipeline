import sys
from argparse import ArgumentParser
import pandas as pd
import re


## term : replaced_by 1:1
def get_replaced_by_id(obo_file):
    flag = False
    id_name_map = dict()
    id_replaceby = dict()
    with open(obo_file) as f:
        for line in f:
            if line.startswith('[Term]'):
                term_id = ""
                term_name = ""
                flag = True
                continue
            if flag:
                # record info
                line = line.strip()
                if line:
                    line_list = line.split(': ')
                    key_ = line_list[0].strip()
                    value_ = line_list[1].strip()
                    if key_ == 'id':
                        term_id = value_
                        id_name_map[term_id] = ''
                    if key_ == 'name':
                        term_name = value_
                        id_name_map[term_id] = term_name
                    if key_ == 'replaced_by':
                        replaced_by_id = value_
                        id_replaceby[term_id] = replaced_by_id
                else:
                    # new term
                    flag = False
                    continue
    obsolete_id = id_replaceby.keys()
    return obsolete_id, id_name_map, id_replaceby

def read_tsv_1_14_column(tsv_file, obsolete_id, id_name_map, id_replaceby):
    go_gene_map = dict()
    with open(tsv_file) as f:
        for line in f:
            line_list = line.split()
            gene_name = line_list[0]
            go_id = line_list[1]
            go_id = re.sub(r'\(.*?\)', '', go_id)
            go_term = go_id.split(",")
            for go_ in go_term:
                if go_ not in go_gene_map:
                    go_gene_map[go_] = {gene_name}
                else:
                    go_gene_map[go_].add(gene_name)
    
    species_go_list = list(go_gene_map.keys())
    for id_ in species_go_list:
        if id_ in obsolete_id:
            # print("species_obselete_term", id_)
            # print("species_obselete_term_name", id_name_map[id_])
            # print("replaceby_id", id_replaceby[id_])    
            # print("replaceby_name", id_name_map[id_replaceby[id_]])
            
            # print("obsolete", go_gene_map[id_])
            # print(go_gene_map.get(id_replaceby[id_], "species replaceby_term don't includes genes"))
            # print()
            replaced_by_id = id_replaceby[id_]
            if replaced_by_id not in go_gene_map:
                go_gene_map[replaced_by_id] = go_gene_map[id_]
            else:
                go_gene_map[replaced_by_id] = go_gene_map[replaced_by_id].union(go_gene_map[id_])
            del go_gene_map[id_]
    
    go_gene_map = {go_id: ",".join(genes) for go_id, genes in go_gene_map.items()}

    data = []

    for go_id, genes in go_gene_map.items():
        go_name = id_name_map.get(go_id, "Unknown")
        for gene in genes.split(","):
            data.append([go_id, gene, go_name])

    df = pd.DataFrame(data, columns=["GO_ID", "Genes", "GO_Name"])

    df.to_csv(annotation, sep="\t", index=False, header=True)

    
    
    
if __name__ == '__main__':
    parser = ArgumentParser(description='Input: obo file; interproscan all analysis result file(1,14 column). Output: annotation file')
    parser.add_argument("-i", "--input1",
                        dest="obofile",
                        type=str,
                        default="",
                        help="obo file from gene ontology basic.obo")
    parser.add_argument("-t", "--tsvfile",
                        dest="tsvfile",
                        type=str,
                        default="",
                        help="interproscan all analysis result file(1,14 column)")
    parser.add_argument("-o", "--annotation",
                        dest="annotation",
                        type=str,
                        default="",
                        help="annotation file for enricher function")


    args = parser.parse_args()

    if args.obofile == "":
        print("Error: please specify --obofile", file=sys.stderr)
        parser.print_help()
        sys.exit(1)

    if args.tsvfile == "":
        print("Error: please specify --tsvfile", file=sys.stderr)
        parser.print_help()
        sys.exit(1)

    if args.annotation == "":
        print("Error: please specify --annotation", file=sys.stderr)
        parser.print_help()
        sys.exit(1)

    obofile = args.obofile
    tsvfile = args.tsvfile
    annotation = args.annotation
    
    # get id which is obsolete(replaced_by)
    obsolete_id, id_name_map, id_replaceby = get_replaced_by_id(obofile)
    read_tsv_1_14_column(tsvfile, obsolete_id, id_name_map, id_replaceby)
