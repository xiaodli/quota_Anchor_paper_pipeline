#!/bin/bash

tablepath=/media/dell/E/Suppmentary_data/05sequence/02table
colpath=/media/dell/E/Suppmentary_data/05sequence
peppath=/media/dell/E/Suppmentary_data/05sequence/02longest
gffpath=/media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data
cat /media/dell/E/Suppmentary_data/05sequence/species.txt |while read f number; do
newname=$(basename "$f")
ref_number_doubled=$(( number * 2 ))
echo $newname
if [[ "$newname" != "Joinvillea.ascendens.pep"  && "$newname" != "" ]]; then
     python 02ucalculator/main.py ks -p $peppath/Joinvillea.ascendens.pep,$peppath/$newname -d $peppath/Joinvillea.ascendens.cds,$peppath/${newname%.pep}.cds -a muscle -i $colpath/${newname%.pep}/Joinvillea.ascendens.${newname%.pep}.collinearity -o $colpath/${newname%.pep}/${newname%.pep}.calculator.ks --add_ks -t 16

fi
done
