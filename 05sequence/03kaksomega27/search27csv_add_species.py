import re
import os
import pandas as pd

# path:./
# 1. folders 27 species not startswith . _ lower/isupper

abs_input_dir = "./"
identity_list = []
ng86_ks_list = []
ng86_ka_list = []
ng86_omega_list = []
yn00_ks_list = []
yn00_ka_list = []
yn00_omega_list = []
ma_ks_list = []
ma_ka_list = []
ma_omega_list = []

files_and_folders = os.listdir(abs_input_dir)
for name in files_and_folders:
    if os.path.isdir(os.path.join(abs_input_dir, name)) and not name.startswith(".") and not name.startswith("_") and name[0].isupper():
        abs_path = os.path.join(abs_input_dir, name)
        for every_csv in os.listdir(abs_path):
            species_name_column_name = "Species"
            species_name_column_content = re.sub(r'[-_]', '.', name)
            first_sub_str = True
            for sub_str in species_name_column_content.split("."):
                if first_sub_str:
                    new_species_name_column_content = sub_str[0] + "." + " "
                    first_sub_str = False
                else:
                    new_species_name_column_content += sub_str + "."
            species_name_column_content = new_species_name_column_content[:-1]
            if os.path.isfile(os.path.join(abs_path, every_csv)) and every_csv.endswith("csv"):
                csv_df = pd.read_csv(os.path.join(abs_path, every_csv), header=0, index_col=None)
                csv_df[species_name_column_name] = [species_name_column_content] * len(csv_df)

                # calculator
                if "calculator" in every_csv:
                    if "ks" in every_csv:
                        ma_ks_list.append(csv_df)
                    elif "ka" in every_csv:
                        ma_ka_list.append(csv_df)
                    else:
                        ma_omega_list.append(csv_df)
                # yn00
                elif "yn00" in every_csv:
                    if "ks" in every_csv:
                        yn00_ks_list.append(csv_df)
                    elif "ka" in every_csv:
                        yn00_ka_list.append(csv_df)
                    else:
                        yn00_omega_list.append(csv_df)
                # ng86
                else:
                    if "ks" in every_csv:
                        ng86_ks_list.append(csv_df)
                    elif "ka" in every_csv:
                        ng86_ka_list.append(csv_df)
                    else:
                        ng86_omega_list.append(csv_df)

print(len(ng86_ks_list))
print(len(ng86_ka_list))
print(len(ng86_omega_list))
print(len(yn00_ks_list))
print(len(yn00_ka_list))
print(len(yn00_omega_list))
print(len(ma_ks_list))
print(len(ma_ka_list))
print(len(ma_omega_list))


calculator_ks_df = pd.concat(ma_ks_list)
calculator_ks_df.to_csv("./03kaksomega27/ks/calculator.ks.csv", index=False)
calculator_ka_df = pd.concat(ma_ka_list)
calculator_ka_df.to_csv("./03kaksomega27/ka/calculator.ka.csv", index=False)
calculator_omega_df = pd.concat(ma_omega_list)
calculator_omega_df.to_csv("./03kaksomega27/omega/calculator.omega.csv", index=False)

yn00_ks_df = pd.concat(yn00_ks_list)
yn00_ks_df.to_csv("./03kaksomega27/ks/yn00.ks.csv", index=False)
yn00_ka_df = pd.concat(yn00_ka_list)
yn00_ka_df.to_csv("./03kaksomega27/ka/yn00.ka.csv", index=False)
yn00_omega_df = pd.concat(yn00_omega_list)
yn00_omega_df.to_csv("./03kaksomega27/omega/yn00.omega.csv", index=False)

ng86_ks_df = pd.concat(ng86_ks_list)
ng86_ks_df.to_csv("./03kaksomega27/ks/ng86.ks.csv", index=False)
ng86_ka_df = pd.concat(ng86_ka_list)
ng86_ka_df.to_csv("./03kaksomega27/ka/ng86.ka.csv", index=False)
ng86_omega_df = pd.concat(ng86_omega_list)
ng86_omega_df.to_csv("./03kaksomega27/omega/ng86.omega.csv", index=False)
