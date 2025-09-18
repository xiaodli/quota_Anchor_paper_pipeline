#!/bin/bash

SpeciesPath=/media/dell/E/Suppmentary_data/09tandem27
fai_path=/media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data

cat /media/dell/E/Suppmentary_data/09tandem27/species.txt |while read f number; do
newname=$(basename "$f")
if [[ "$newname" != "Joinvillea.ascendens.pep"  && "$newname" != "" ]]; then
    awk '{print $1}' $SpeciesPath/${newname%.pep}_class/${newname%.pep}.wgd.genes|sed '1d' > $SpeciesPath/${newname%.pep}_class/${newname%.pep}.wgd.genes.txt
fi
done



