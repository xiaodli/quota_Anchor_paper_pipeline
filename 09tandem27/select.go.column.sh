#!/bin/bash

SpeciesPath=/media/dell/E/Suppmentary_data/09tandem27

cat /media/dell/E/Suppmentary_data/09tandem27/species.txt |while read f number; do
newname=$(basename "$f")
if [[ "$newname" != "Joinvillea.ascendens.pep"  && "$newname" != "" ]]; then
   cat $SpeciesPath/${newname%.pep}_class/${newname%.pep}.go.tsv |cut -f1,14 |grep "GO"|sed "s/|/,/g" > $SpeciesPath/${newname%.pep}_class/${newname%.pep}.go.txt
fi
done
