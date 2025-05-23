#!/bin/bash

tablepath=/media/dell/E/Suppmentary_data/05sequence/02table
colpath=/media/dell/E/Suppmentary_data/05sequence
peppath=/media/dell/E/Suppmentary_data/05sequence/02longest
gffpath=/media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data
cat /media/dell/E/Suppmentary_data/05sequence/species.txt |while read f number; do
newname=$(basename "$f")
if [[ "$newname" != "Joinvillea.ascendens.pep" ]]; then
     quota_Anchor col -i $colpath/${newname%.pep}/Joinvillea.ascendens.${newname%.pep}.table -o $colpath/${newname%.pep}/Joinvillea.ascendens.${newname%.pep}.total.collinearity -s 0 --overwrite -D 25 -a 1 -r $number -q 1 -W 5 -m 500 -I 5
    
fi
done
