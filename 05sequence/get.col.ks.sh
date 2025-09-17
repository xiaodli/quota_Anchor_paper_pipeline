#!/bin/bash

tablepath=/media/dell/E/Suppmentary_data/05sequence/02table
colpath=/media/dell/E/Suppmentary_data/05sequence
peppath=/media/dell/E/Suppmentary_data/05sequence/02longest
gffpath=/media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data
cat /media/dell/E/Suppmentary_data/05sequence/species.txt |while read f number; do
newname=$(basename "$f")
ref_number_doubled=$(( number * 2 ))
if [[ "$newname" != "Joinvillea.ascendens.pep"  && "$newname" != "" ]]; then
     quota_Anchor pre_col -a diamond -rs $peppath/Joinvillea.ascendens.pep -qs $peppath/$newname -db Joinvillea.ascendens.diamond -mts 20 -e 1e-5 -b $colpath/${newname%.pep}/Joinvillea.ascendens.${newname%.pep}.blast -rg $gffpath/Joinvillea.ascendens.gff3 -qg $gffpath/${newname%.pep}.gff3 -o $colpath/${newname%.pep}/Joinvillea.ascendens.${newname%.pep}.table -bs 100 -al 0 -rl $gffpath/Joinvillea.ascendens.length.txt -ql $gffpath/${newname%.pep}.length.txt --overwrite
     quota_Anchor col -i $colpath/${newname%.pep}/Joinvillea.ascendens.${newname%.pep}.table -o $colpath/${newname%.pep}/Joinvillea.ascendens.${newname%.pep}.collinearity -s 0 --overwrite -D 25 -a 0 -r $ref_number_doubled -q 1 -W 1 -I 5
     quota_Anchor ks -i $colpath/${newname%.pep}/Joinvillea.ascendens.${newname%.pep}.collinearity -a muscle -p $peppath/Joinvillea.ascendens.pep,$peppath/$newname -d $peppath/Joinvillea.ascendens.cds,$peppath/${newname%.pep}.cds  -o $colpath/${newname%.pep}/${newname%.pep}.ks -t 16 --add_ks
fi
done

