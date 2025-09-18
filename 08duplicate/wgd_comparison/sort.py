import pandas as pd
import sys

label_ = sys.argv[2]
right_label = sys.argv[4]
df = pd.read_csv(sys.argv[1], sep="\t", header=0,index_col=None)
last_col = df.columns[-1]
order = {"shared_gene_pairs": 3, label_: 2, right_label: 1, "homo": 0}

df_sorted = df.sort_values(by=last_col, key=lambda x: x.map(order))
df_sorted.to_csv(sys.argv[3], sep="\t", header=True, index=False)

