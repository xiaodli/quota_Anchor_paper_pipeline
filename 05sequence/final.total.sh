#!/bin/bash

column1=("ks_NG86" "ka_NG86" "omega_NG86" "ks_YN00" "ka_YN00" "omega_YN00")
column2=("ks" "ka" "omega" "ks" "ka" "omega")
column3=("ng86" "ng86" "ng86" "yn00" "yn00" "yn00")
column_thres=(3 40 40 3 40 40)
for folder_index in "${!column1[@]}"; do {
      column_1=${column1[folder_index]}
      column_2=${column2[folder_index]}
      column_3=${column3[folder_index]}
      threshold=${column_thres[folder_index]}
      suffix=${column_3}.${column_2}.csv
      find . -type f |grep "\.ks$"|grep -v "calculator"|while read f; do
           dir_name=$(dirname "$f")
           file_name=$(basename "$f")
           python diff_ks_strand_for_boxplot.py ks_diff -W $dir_name/Joinvillea.ascendens.${file_name%ks}collinearity -ks $f -o ${f%ks}${suffix}  -c1 $column_1 -c2 $column_2 -t $threshold
      done
}&
done
wait

column4=("ks" "ka" "omega")
column5=("ks" "ka" "omega")
column6=("calculator" "calculator" "calculator")

for folder_index in "${!column4[@]}"; do {
      column_4=${column4[folder_index]}
      column_5=${column5[folder_index]}
      column_6=${column6[folder_index]}
      suffix=${column_6}.${column_5}.csv
      find . -type f |grep "\.ks$"|grep "calculator"|while read f; do
           dir_name=$(dirname "$f")
           file_name=$(basename "$f")
           python diff_ks_strand_for_boxplot.py ks_diff -W $dir_name/Joinvillea.ascendens.${file_name%calculator.ks}collinearity -ks $f -o ${f%ks}${suffix}  -c1 $column_4 -c2 $column_5
      done
}&
done
wait

