import sys
import pandas as pd


def sort_key(col):
    return col.str.split("-").map(lambda x: (x[1], int(x[2])))


with open(sys.argv[1], 'r') as tandem:
    tandem_lines = tandem.read()

with open(sys.argv[2], 'r') as proximal:
    proximal_lines = proximal.readlines()[1:]

with open(sys.argv[3], 'w') as output_file:
    output_file.write(tandem_lines)
    output_file.writelines(proximal_lines)

df = pd.read_csv(sys.argv[3], sep='\t', header=0, index_col=None)
df.drop_duplicates(inplace=True)
df.sort_values(by=[df.columns[1], df.columns[3]], inplace=True, key=sort_key)
df.to_csv(sys.argv[3], sep='\t', index=False, header=True)