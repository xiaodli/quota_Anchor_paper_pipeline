#!/bin/bash

SpeciesPath=/media/dell/E/Suppmentary_data/09tandem27
fai_path=/media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data


cat /media/dell/E/Suppmentary_data/09tandem27/species.txt |while read f number; do
newname=$(basename "$f")
if [[ "$newname" != "Joinvillea.ascendens.pep"  && "$newname" != "" ]]; then
    python get.tandem.py $SpeciesPath/${newname%.pep}_class/${newname%.pep}.tandem.genes.stats $SpeciesPath/${newname%.pep}_class/${newname%.pep}.tandem.gene.txt $fai_path/${newname%.pep}.length.txt 2
    python get.tandem.py $SpeciesPath/${newname%.pep}_class/${newname%.pep}.tandem.genes.stats $SpeciesPath/${newname%.pep}_class/${newname%.pep}.tandem13.gene.txt $fai_path/${newname%.pep}.length.txt 13
    python get.tandem.py $SpeciesPath/${newname%.pep}_class/${newname%.pep}.tandem.genes.stats $SpeciesPath/${newname%.pep}_class/${newname%.pep}.tandem14.gene.txt $fai_path/${newname%.pep}.length.txt 14
    python get.tandem.py $SpeciesPath/${newname%.pep}_class/${newname%.pep}.tandem.genes.stats $SpeciesPath/${newname%.pep}_class/${newname%.pep}.tandem15.gene.txt $fai_path/${newname%.pep}.length.txt 15
    python get.tandem.py $SpeciesPath/${newname%.pep}_class/${newname%.pep}.tandem.genes.stats $SpeciesPath/${newname%.pep}_class/${newname%.pep}.tandem16.gene.txt $fai_path/${newname%.pep}.length.txt 16
fi
done



