#!/bin/bash

tablepath=/media/dell/E/Suppmentary_data/05sequence/02table
colpath=/media/dell/E/Suppmentary_data/05sequence
peppath=/media/dell/E/Suppmentary_data/05sequence/02longest
gffpath=/media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data
cat /media/dell/E/Suppmentary_data/05sequence/species.txt |while read f number; do
newname=$(basename "$f")
ref_number_doubled=$(( number * 2 ))
if [[ "$newname" != "Joinvillea.ascendens.pep"  && "$newname" != "" ]]; then

     quota_Anchor col -i $colpath/${newname%.pep}/Joinvillea.ascendens.${newname%.pep}.table -o $colpath/${newname%.pep}/Joinvillea.ascendens.${newname%.pep}.total.collinearity -s 0 -D 25 -a 1 -r $ref_number_doubled -W 1 -I 5 --overwrite
     quota_Anchor ks -i $colpath/${newname%.pep}/Joinvillea.ascendens.${newname%.pep}.total.collinearity -a muscle -p $peppath/Joinvillea.ascendens.pep,$peppath/$newname -d $peppath/Joinvillea.ascendens.cds,$peppath/${newname%.pep}.cds  -o $colpath/${newname%.pep}/${newname%.pep}.ks -t 16 --add_ks
     quota_Anchor dotplot -i $colpath/${newname%.pep}/Joinvillea.ascendens.${newname%.pep}.total.collinearity -o $colpath/${newname%.pep}/Joinvillea.ascendens.${newname%.pep}.total.collinearity.png -r $gffpath/Joinvillea.ascendens.length.txt -q $gffpath/${newname%.pep}.length.txt -ks $colpath/${newname%.pep}/${newname%.pep}.ks -r_label Joinvillea.ascendens -q_label ${newname%.pep} --overwrite
    
fi
done
