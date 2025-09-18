import sys

quota_Anchor = sys.argv[1]
wgdi = sys.argv[2]
MCScanX = sys.argv[3]
out_file = sys.argv[4]

def get_pairs(file, number):
    pair_set = set()
    with open(file) as f:
        for line in f:
            row_list = line.split()
            left_gene = row_list[0][number:]
            right_gene = row_list[1][number:]
            pair_name = left_gene + "\t" + right_gene
            pair_set.add(pair_name)
    return pair_set

def compare_set(left_set, right_set, _left_label, _right_label):
    left_tool_specific = left_set - right_set
    right_tool_specific = right_set - left_set
    shared_gene_pairs = left_set & right_set

    left_tool_specific_number = len(left_tool_specific)
    right_tool_specific_number = len(right_tool_specific)
    shared_gene_pairs_number = len(shared_gene_pairs)

    total_number = left_tool_specific_number + right_tool_specific_number + shared_gene_pairs_number
    left_tool_specific_ratio = left_tool_specific_number / total_number * 100
    right_tool_specific_ratio = right_tool_specific_number / total_number * 100
    shared_gene_pairs_ratio = shared_gene_pairs_number / total_number * 100

    with open(out_file, "a+") as f:
        f.write(str(_left_label) + " vs " + str(_right_label) + "\t" + str(_left_label) + "\t" + str(left_tool_specific_number)
                + "\t" + f"{left_tool_specific_ratio:.2f}" +"\n")
        f.write(str(_left_label) + " vs " + str(_right_label) + "\t" + str(_right_label) + "\t" + str(right_tool_specific_number)
                + "\t" + f"{right_tool_specific_ratio:.2f}" +"\n")
        f.write(str(_left_label) + " vs " + str(_right_label) + "\t" + str("shared_gene_pairs") + "\t" + str(shared_gene_pairs_number)
                + "\t" + f"{shared_gene_pairs_ratio:.2f}" +"\n")


quota_Anchor_set = get_pairs(quota_Anchor, 5)
WGDI_set = get_pairs(wgdi, 5)
MCScanX_set = get_pairs(MCScanX, 5)

with open(out_file, "w") as f:
    f.write("comparison" + "\t" + "types" + "\t" + "number" + "\t" + "ratio" "\n")

compare_set(quota_Anchor_set, WGDI_set, "quota_Anchor", "WGDI")
compare_set(quota_Anchor_set, MCScanX_set, "quota_Anchor", "MCScanX")
compare_set(WGDI_set, MCScanX_set, "WGDI", "MCScanX")
