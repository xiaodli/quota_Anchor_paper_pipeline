#!/bin/bash
input_dir="./"
folder_name=("SB_ZM" "SB_ZGC" "ZM_ZGC")
constant1="/result/four_software_"

table_array=("sb_zm.table" "zgc_sb.table" "zgc_zm.table")
collinearity_array=("sb2_zm1.collinearity" "zgc1_sb3.collinearity" "zgc2_zm3.collinearity")
collinearity_total_array=("sb_zm.total.collinearity" "zgc_sb.total.collinearity" "zgc_zm.total.collinearity")
sheet_prefix_array=("YM_GL" "GL_ZGC" "YM_ZGC")

folder_array=("shoot_u1" "shoot_u2" "shoot_u3" "root_d1" "root_d2" "root_d3")
shoot_or_root_array=("shoot" "shoot" "shoot" "root" "root" "root")
column_array=("u1" "u2" "u3" "d1" "d2" "d3")

# loop three species pair
for sheet_prefix_index in "${!sheet_prefix_array[@]}"; do {
  # loop (root shoot) * (time1 time2 time3)
  for folder_index in "${!folder_array[@]}"; do {

          column=${column_array[folder_index]}

          shoot_or_root=${shoot_or_root_array[folder_index]}

          sheet_prefix=${sheet_prefix_array[sheet_prefix_index]}

          table_file=${table_array[sheet_prefix_index]}
          collinearity=${collinearity_array[sheet_prefix_index]}
          collinearity_total=${collinearity_total_array[sheet_prefix_index]}

          constant=${folder_name[sheet_prefix_index]}$constant1

          out_path1=${input_dir}${constant}${folder_array[folder_index]}/block_10/raw
          mkdir -p "$out_path1"

          out_path2=${input_dir}${constant}${folder_array[folder_index]}/block_10

          python main.py bootstrap_corr -W "$collinearity" -W1 "$collinearity_total" -t "$table_file" -e all_special_tpm.xlsx -m pearson -c "${column}" -b T -B 5 -s "$shoot_or_root" -boot 50000 -sample_size 30 -co ${out_path1}/${column}_pearson_correlation_log.csv -sheet_prefix $sheet_prefix
          python main.py process -i ${out_path1}/${column}_pearson_correlation_log.csv -o ${out_path2}/${column}_pearson_correlation_log.R.csv

          python main.py bootstrap_corr -W "$collinearity" -W1 "$collinearity_total" -t "$table_file" -e all_special_tpm.xlsx -m spearman -c "${column}" -b T -B 5 -s "$shoot_or_root" -boot 50000 -sample_size 30 -co ${out_path1}/${column}_spearman_correlation_log.csv -sheet_prefix $sheet_prefix
          python main.py process -i ${out_path1}/${column}_spearman_correlation_log.csv -o ${out_path2}/${column}_spearman_correlation_log.R.csv

          python main.py bootstrap_corr -W "$collinearity" -W1 "$collinearity_total" -t "$table_file" -e all_special_tpm.xlsx -m pearson -c "${column}" -b F -B 5 -s "$shoot_or_root" -boot 50000 -sample_size 30 -co ${out_path1}/${column}_pearson_correlation.csv -sheet_prefix $sheet_prefix
          python main.py process -i ${out_path1}/${column}_pearson_correlation.csv -o ${out_path2}/${column}_pearson_correlation.R.csv

          python main.py bootstrap_corr -W "$collinearity" -W1 "$collinearity_total" -t "$table_file" -e all_special_tpm.xlsx -m spearman -c "${column}" -b F -B 5 -s "$shoot_or_root" -boot 50000 -sample_size 30 -co ${out_path1}/${column}_spearman_correlation.csv -sheet_prefix $sheet_prefix
          python main.py process -i ${out_path1}/${column}_spearman_correlation.csv -o ${out_path2}/${column}_spearman_correlation.R.csv
  }&
  done
}
done
wait
