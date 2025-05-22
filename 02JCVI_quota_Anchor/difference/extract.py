import pandas as pd
import sys


df = pd.read_csv(sys.argv[1], header=0, index_col=None, sep="\t")
df["ref_chr"] = df["ref_chr"].astype(str)
df["query_chr"] = df["query_chr"].astype(str)

# maize chr4 vs sorghum 7
new_df = df[(df["query_chr"].isin(["1", "2", "4", "6", "10"])) & (df["ref_chr"].isin(["4", "5", "7"]))]
new_df = new_df[new_df["Type"] != "homo"]
# print(new_df)
new_df.to_csv(sys.argv[2], sep="\t", index=False)