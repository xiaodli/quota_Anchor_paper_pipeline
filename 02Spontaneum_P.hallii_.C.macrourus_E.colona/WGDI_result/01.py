import pandas as pd
import sys
data = pd.read_csv(sys.argv[1], header=None, sep="\t", comment="#")
data = data[(data[2] == 'mRNA') | (data[2] =='V_gene_segment')]
data = data.loc[:, [0, 8, 3, 4, 6]]
print(data[8])
if "Echinochloa.colona" in sys.argv[1]:
    data[8], data[1] = data[8].str.split('=|;', expand=True)[5], data[8].str.split(';|=', expand=True)[3]
elif "Cenchrus.macrourus" in sys.argv[1]:
    data[8], data[1] = data[8].str.split('=|;', expand=True)[5], data[8].str.split(';|=', expand=True)[1]
else:
    data[8], data[1] = data[8].str.split('=|;', expand=True)[3], data[8].str.split(';|=', expand=True)[1]
data.to_csv(sys.argv[2], sep="\t", header=None, index=False)

