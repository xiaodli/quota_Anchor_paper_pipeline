#!/bin/bash

find . -type f |grep "\.ks$"|grep "calculator"|while read f; do
     dir_name=$(dirname "$f")
     file_name=$(basename "$f")
     python ./06speciation_paleo_SSD_SID/determine_speciation_paleo_ssd_sid_pairs.py diff -W $dir_name/Joinvillea.ascendens.${file_name%calculator.ks}collinearity -W1 $dir_name/Joinvillea.ascendens.${file_name%calculator.ks}total.collinearity -o ./06speciation_paleo_SSD_SID/speciation.paleo.ssd.sid.R.txt
done
