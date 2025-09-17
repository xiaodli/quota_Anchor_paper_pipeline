#!/bin/bash

pep_path=/media/dell/E/Suppmentary_data/05sequence/02longest
SpeciesPath=/media/dell/E/Suppmentary_data/09tandem27
fai_path=/media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data


cat /media/dell/E/Suppmentary_data/09tandem27/species.txt |while read f number; do
newname=$(basename "$f")
if [[ "$newname" != "Joinvillea.ascendens.pep"  && "$newname" != "" ]]; then
    python get.pre.interproscan.py $pep_path/$newname $fai_path/${newname%.pep}.gff3 $SpeciesPath/${newname%.pep}_class/${newname%.pep}.species.chr.pep.txt $fai_path/${newname%.pep}.length.txt
fi
done

