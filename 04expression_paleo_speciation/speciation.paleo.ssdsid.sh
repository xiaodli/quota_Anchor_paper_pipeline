#!/bin/bash

total_array=("zgc_sb.total.collinearity" "sb_zm.total.collinearity" "zgc_zm.total.collinearity")
speciation_array=("zgc1_sb3.collinearity" "sb2_zm1.collinearity" "zgc2_zm3.collinearity")
for file_index in {0..2}; do
     total_collinearity="${total_array[$file_index]}"
     speciation_collinearity="${speciation_array[$file_index]}"
     python determine_speciation_paleo_ssd_sid_pairs.py diff -W $speciation_collinearity -W1 $total_collinearity -o speciation.paleo.ssd.sid.R.txt
done
