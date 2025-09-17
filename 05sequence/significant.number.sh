#!/bin/bash

column1=("ks_NG86")
column2=("ks")
column3=("ng86")
column_thres=(2)
for folder_index in "${!column1[@]}"; do {
      column_1=${column1[folder_index]}
      column_2=${column2[folder_index]}
      column_3=${column3[folder_index]}
      threshold=${column_thres[folder_index]}
      suffix=${column_3}.${column_2}.txt
      find . -type f |grep "\.ks$"|grep -v "calculator"|while read f; do
           dir_name=$(dirname "$f")
           file_name=$(basename "$f")
           python ./05kssignificant/sigificant.py ks_sign -W $dir_name/Joinvillea.ascendens.${file_name%ks}collinearity -ks $f -o ./05kssignificant/${suffix}  -c1 $column_1 -c2 $column_2 -t $threshold
      done
}&
done
wait

column4=("ks_YN00")
column5=("ks")
column6=("yn00")
column_thres=(3)
for folder_index in "${!column1[@]}"; do {
      column_4=${column4[folder_index]}
      column_5=${column5[folder_index]}
      column_6=${column6[folder_index]}
      threshold=${column_thres[folder_index]}
      suffix=${column_6}.${column_5}.txt
      find . -type f |grep "\.ks$"|grep -v "calculator"|while read f; do
           dir_name=$(dirname "$f")
           file_name=$(basename "$f")
           python ./05kssignificant/sigificant.py ks_sign -W $dir_name/Joinvillea.ascendens.${file_name%ks}collinearity -ks $f -o ./05kssignificant/${suffix}  -c1 $column_4 -c2 $column_5 -t $threshold
      done
}&
done
wait

column7=("ks")
column8=("ks")
column9=("calculator")

for folder_index in "${!column4[@]}"; do {
      column_7=${column7[folder_index]}
      column_8=${column8[folder_index]}
      column_9=${column9[folder_index]}
      suffix=${column_9}.${column_8}.txt
      find . -type f |grep "\.ks$"|grep "calculator"|while read f; do
           dir_name=$(dirname "$f")
           file_name=$(basename "$f")
           python ./05kssignificant/sigificant.py ks_sign -W $dir_name/Joinvillea.ascendens.${file_name%calculator.ks}collinearity -ks $f -o ./05kssignificant/${suffix}  -c1 $column_7 -c2 $column_8
      done
}&
done
wait

