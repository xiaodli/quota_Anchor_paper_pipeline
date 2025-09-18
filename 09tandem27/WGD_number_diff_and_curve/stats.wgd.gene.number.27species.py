import sys
import pandas as pd



def wgd_gene_number(species_file, _summary_file):
    # write a summary header
    output_file_handle = open(_summary_file, 'w')
    output_file_handle.write("Depth" + "\t" + "Species" + "\t" + "wgd_gene_number" + "\n")

    # loop 27 species
    df = pd.read_csv(species_file, sep=r"\s+", header=None, index_col=None)
    df.columns = ["Species", "Depth"]
    for index, row in df.iterrows():
        species = row["Species"][:-4]
        if species == "Joinvillea.ascendens":
            continue
        depth = row["Depth"]

        # parse class_gene result stats file to get wgd gene number
        stats_path = "../" + species + "_class" + "/" + species + ".stats"
        stats_df = pd.read_csv(stats_path, sep='\t', header=0, index_col="Type")
        wgd_gn_number = stats_df.loc['wgd.genes', 'Number']

        # species name
        new_species_name = ""
        first_sub_str = True
        for sub_str in species.split("."):
            if first_sub_str:
                new_species_name = sub_str[0] + "." + " "
                first_sub_str = False
            else:
                new_species_name += sub_str + "."
        species = new_species_name[:-1]

        # out every species' wgd gene number
        output_file_handle.write(str(depth) + "\t" + str(species) + "\t"+ str(wgd_gn_number) + "\n")
    output_file_handle.close()

    df = pd.read_csv(_summary_file, sep='\t', header=0, index_col=None)
    df.sort_values(by=df.columns[0], inplace=True)
    df.to_csv(_summary_file, sep='\t', index=False, header=True)

    return


species_file = sys.argv[1]
output_file = sys.argv[2]
wgd_gene_number(species_file, output_file)
