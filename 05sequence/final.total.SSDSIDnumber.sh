#!/bin/bash

find . -type f |grep "\.ks$"|grep "calculator"|while read f; do
     dir_name=$(dirname "$f")
     file_name=$(basename "$f")
     python ./04SSDSIDnumber/SSD_SID_number.py ks_diff -W $dir_name/Joinvillea.ascendens.${file_name%calculator.ks}collinearity -o ./04SSDSIDnumber/identity.txt
done
