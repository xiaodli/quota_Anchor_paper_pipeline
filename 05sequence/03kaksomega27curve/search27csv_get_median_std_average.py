import re
import os
import sys

import pandas as pd

# path:./
# 1. folders 27 species not startswith . _ lower/isupper
# 2.
# 3.


abs_input_dir = "./"
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
            species_name_column_name = "species"
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
                # calculator
                if "calculator" in every_csv:
                    if "ks" in every_csv:
                        result = csv_df.groupby('Type').agg({'ks': ['mean', 'median', 'std']})
                        new_result = result.stack(future_stack=True)
                        new_result_reset = new_result.reset_index()
                        new_result_reset[species_name_column_name] = [species_name_column_content] * len(new_result_reset)
                        new_result_reset.columns = ['Type', 'method', 'ks', "species"]
                        ma_ks_list.append(new_result_reset)
                    elif "ka" in every_csv:
                        result = csv_df.groupby('Type').agg({'ka': ['mean', 'median', 'std']})
                        new_result = result.stack(future_stack=True)
                        new_result_reset = new_result.reset_index()
                        new_result_reset[species_name_column_name] = [species_name_column_content] * len(
                            new_result_reset)
                        new_result_reset.columns = ['Type', 'method', 'ka', "species"]
                        ma_ka_list.append(new_result_reset)
                    else:
                        result = csv_df.groupby('Type').agg({'omega': ['mean', 'median', 'std']})
                        new_result = result.stack(future_stack=True)
                        new_result_reset = new_result.reset_index()
                        new_result_reset[species_name_column_name] = [species_name_column_content] * len(
                            new_result_reset)
                        new_result_reset.columns = ['Type', 'method', 'omega', "species"]
                        ma_omega_list.append(new_result_reset)
                # yn00
                elif "yn00" in every_csv:
                    if "ks" in every_csv:
                        result = csv_df.groupby('Type').agg({'ks': ['mean', 'median', 'std']})
                        new_result = result.stack(future_stack=True)
                        new_result_reset = new_result.reset_index()
                        new_result_reset[species_name_column_name] = [species_name_column_content] * len(
                            new_result_reset)
                        new_result_reset.columns = ['Type', 'method', 'ks', "species"]
                        yn00_ks_list.append(new_result_reset)
                    elif "ka" in every_csv:
                        result = csv_df.groupby('Type').agg({'ka': ['mean', 'median', 'std']})
                        new_result = result.stack(future_stack=True)
                        new_result_reset = new_result.reset_index()
                        new_result_reset[species_name_column_name] = [species_name_column_content] * len(
                            new_result_reset)
                        new_result_reset.columns = ['Type', 'method', 'ka', "species"]
                        yn00_ka_list.append(new_result_reset)
                    else:
                        result = csv_df.groupby('Type').agg({'omega': ['mean', 'median', 'std']})
                        new_result = result.stack(future_stack=True)
                        new_result_reset = new_result.reset_index()
                        new_result_reset[species_name_column_name] = [species_name_column_content] * len(
                            new_result_reset)
                        new_result_reset.columns = ['Type', 'method', 'omega', "species"]
                        yn00_omega_list.append(new_result_reset)
                # ng86
                else:
                    if "ks" in every_csv:
                        result = csv_df.groupby('Type').agg({'ks': ['mean', 'median', 'std']})
                        new_result = result.stack(future_stack=True)
                        new_result_reset = new_result.reset_index()
                        new_result_reset[species_name_column_name] = [species_name_column_content] * len(
                            new_result_reset)
                        new_result_reset.columns = ['Type', 'method', 'ks', "species"]
                        ng86_ks_list.append(new_result_reset)
                    elif "ka" in every_csv:
                        result = csv_df.groupby('Type').agg({'ka': ['mean', 'median', 'std']})
                        new_result = result.stack(future_stack=True)
                        new_result_reset = new_result.reset_index()
                        new_result_reset[species_name_column_name] = [species_name_column_content] * len(
                            new_result_reset)
                        new_result_reset.columns = ['Type', 'method', 'ka', "species"]
                        ng86_ka_list.append(new_result_reset)
                    else:
                        result = csv_df.groupby('Type').agg({'omega': ['mean', 'median', 'std']})
                        new_result = result.stack(future_stack=True)
                        new_result_reset = new_result.reset_index()
                        new_result_reset[species_name_column_name] = [species_name_column_content] * len(
                            new_result_reset)
                        new_result_reset.columns = ['Type', 'method', 'omega', "species"]
                        ng86_omega_list.append(new_result_reset)

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
calculator_ks_df.to_csv("./03kaksomega27curve/ks_curve/calculator.ks.csv", index=False)
calculator_ka_df = pd.concat(ma_ka_list)
calculator_ka_df.to_csv("./03kaksomega27curve/ka_curve/calculator.ka.csv", index=False)
calculator_omega_df = pd.concat(ma_omega_list)
calculator_omega_df.to_csv("./03kaksomega27curve/omega_curve/calculator.omega.csv", index=False)

yn00_ks_df = pd.concat(yn00_ks_list)
yn00_ks_df.to_csv("./03kaksomega27curve/ks_curve/yn00.ks.csv", index=False)
yn00_ka_df = pd.concat(yn00_ka_list)
yn00_ka_df.to_csv("./03kaksomega27curve/ka_curve/yn00.ka.csv", index=False)
yn00_omega_df = pd.concat(yn00_omega_list)
yn00_omega_df.to_csv("./03kaksomega27curve/omega_curve/yn00.omega.csv", index=False)

ng86_ks_df = pd.concat(ng86_ks_list)
ng86_ks_df.to_csv("./03kaksomega27curve/ks_curve/ng86.ks.csv", index=False)
ng86_ka_df = pd.concat(ng86_ka_list)
ng86_ka_df.to_csv("./03kaksomega27curve/ka_curve/ng86.ka.csv", index=False)
ng86_omega_df = pd.concat(ng86_omega_list)
ng86_omega_df.to_csv("./03kaksomega27curve/omega_curve/ng86.omega.csv", index=False)
