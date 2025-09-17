import sys
import os
import pandas as pd

# 1. folders ZM_ZGC SB_ZM SB_ZGC
# 2. folders result/four_software_root_d1 d2 d3 result/four_software_shoot_u1 u2 u3
# 3. folders block_10
# one spearman and not log
# two pearson and log

abs_input_dir = os.getcwd()
pearson_list = []
spearman_list = []
files_and_folders = os.listdir(abs_input_dir)
for name in files_and_folders:
    # SB_ZM SB_ZGC ZM_ZGC
    if not name.startswith(".") and not name.startswith("_") and os.path.isdir(os.path.join(abs_input_dir, name)):
        if name.endswith("ZGC"):
            species_pairs_column_name = "species_pair"
            species_pairs_column_content = name.split("_")[0].capitalize() + "_Ta"
        else:
            species_pairs_column_name = "species_pair"
            species_pairs_column_content = name.split("_")[0].capitalize() + "_" + name.split("_")[1].capitalize()
        abs_path = os.path.join(abs_input_dir, name, "result")
        for sub_dir in os.listdir(abs_path):
            four_software_path = os.path.join(abs_path, sub_dir, "block_10")
            shoot_root_time_column_name = "tissue_time"
            shoot_root_time_column_content = sub_dir.split("_")[2] + "_" + sub_dir.split("_")[3]
            for file in os.listdir(four_software_path):
                # pearson and log
                if os.path.isfile(os.path.join(four_software_path, file)) and file.endswith("pearson_correlation_log.R.csv"):
                    csv_df = pd.read_csv(os.path.join(four_software_path, file), header=0, index_col=None)
                    csv_df[species_pairs_column_name] = [species_pairs_column_content] * len(csv_df)
                    csv_df[shoot_root_time_column_name] = [shoot_root_time_column_content] * len(csv_df)
                    pearson_list.append(csv_df)
                # spearman and not log
                if os.path.isfile(os.path.join(four_software_path, file)) and file.endswith("spearman_correlation.R.csv"):
                    csv_df = pd.read_csv(os.path.join(four_software_path, file), header=0, index_col=None)
                    csv_df[species_pairs_column_name] = [species_pairs_column_content] * len(csv_df)
                    csv_df[shoot_root_time_column_name] = [shoot_root_time_column_content] * len(csv_df)
                    spearman_list.append(csv_df)

pearson_df = pd.concat(pearson_list)
spearman_df = pd.concat(spearman_list)

pearson_df.to_csv("pearson_correlation_log.csv", index=False)
spearman_df.to_csv("spearman_correlation.csv", index=False)
