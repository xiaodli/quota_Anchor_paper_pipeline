#!/bin/bash

species=("os_sb" "os_zm" "sb_zm" "ta_os" "ta_sb" "ta_zm")
collinearity=("os1_sb1"  "os2_zm1"  "sb2_zm1"  "zgc1_os3"  "zgc1_sb3"  "zgc2_zm3")

for folder_index in "${!species[@]}"; do {
        collinearity_file=${collinearity[$folder_index]}
        python distance.py collinearity/raw_data/"${collinearity_file}".collinearity "distance.txt" "${species[$folder_index]}"
}&
done
wait
