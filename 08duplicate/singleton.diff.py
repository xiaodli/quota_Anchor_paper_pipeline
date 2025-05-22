import sys
import pandas as pd


df1 = pd.read_csv(sys.argv[1], header=0, sep="\t", index_col=None)
df1_set = df1["non_coding"]

df2 = pd.read_csv(sys.argv[2], header=0, sep="\t", index_col=None)
df2_set = df2["GeneID"]

df1_set = set(df1_set)
df2_set = set(df2_set)
print(len(df1_set))
print(len(df2_set))
# print(df1_set.intersection(df2_set))
df1_diff_df2_set = df1_set.difference(df2_set)
df2_diff_df1_set = df2_set.difference(df1_set)

print("quota_Anchor_diffDup",len(df1_diff_df2_set))
print("Dup_diff_quota_Anchor",df2_diff_df1_set)

