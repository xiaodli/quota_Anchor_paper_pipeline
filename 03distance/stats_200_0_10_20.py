import pandas as pd
import sys


distance_file = sys.argv[1]
distance_file_R_format = open(sys.argv[2], "w")
distance_file_R_format.write("species_pair" + "\t" + "10-20" + "\t" + ">20" + "\n")

df = pd.read_csv(distance_file, header=None, index_col=None, sep='\t')
df.columns = ['species_pair', 'query_distance', "ref_distance", "block_length"]
df = df[df["block_length"] >= 200]

for i, group in df.groupby("species_pair"):
    species_pair = i
    # [1,10) [10,20) [20, )
    one_ten = 0
    ten_twenty = 0
    twenty_ = 0
    for j, row in  group.iterrows():
        if 10 < row["query_distance"] < 20 or 10 < row["ref_distance"] < 20:
            ten_twenty += 1
        if row["query_distance"] > 20 or row["ref_distance"] > 20:
            twenty_ += 1
    distance_file_R_format.write(species_pair + "\t" + str(ten_twenty) + "\t" + str(twenty_) + "\n")

distance_file_R_format.close()
