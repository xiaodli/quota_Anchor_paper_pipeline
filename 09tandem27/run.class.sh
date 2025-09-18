#!/bin/bash

tablepath=/media/dell/E/Suppmentary_data/05sequence
colpath=/media/dell/E/Suppmentary_data/05sequence
peppath=/media/dell/E/Suppmentary_data/05sequence/02longest
gffpath=/media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data
mkdir -p database
cat /media/dell/E/Suppmentary_data/09tandem27/species.txt |while read f number; do
newname=$(basename "$f")
if [[ "$newname" != "Joinvillea.ascendens.pep"  && "$newname" != "" ]]; then

    quota_Anchor pre_col -a diamond -rs $peppath/$newname -qs $peppath/$newname -db ./database/${newname}.diamond -mts 20 -e 1e-10 -b $colpath/${newname%.pep}/${newname%.pep}.blast -rg $gffpath/${newname%.pep}.gff3 -qg $gffpath/${newname%.pep}.gff3 -o $colpath/${newname%.pep}/${newname%.pep}.table -bs 100 -al 0 -rl $gffpath/${newname%.pep}.length.txt -ql $gffpath/${newname%.pep}.length.txt --overwrite

    quota_Anchor col -i $tablepath/${newname%.pep}/${newname%.pep}.table -o $colpath/${newname%.pep}/${newname%.pep}.collinearity -s 0 --overwrite -D 25 -a 1 -W 5 -m 500

    quota_Anchor class_gene -b $tablepath/${newname%.pep}/${newname%.pep}.blast -g $gffpath/${newname%.pep}.gff3 -q $colpath/${newname%.pep}/${newname%.pep}.collinearity -qr $colpath/${newname%.pep}/Joinvillea.ascendens.${newname%.pep}.total.collinearity -o "${newname%.pep}_class" -p ${newname%.pep} -s 1 -d 5 --overwrite
fi
done


