#!/bin/bash

SpeciesPath=/media/dell/E/Suppmentary_data/09tandem27

cat /media/dell/E/Suppmentary_data/09tandem27/species.txt |while read f number; do
newname=$(basename "$f")
if [[ "$newname" != "Joinvillea.ascendens.pep"  && "$newname" != "" ]]; then
    python merge.tandem.proximal.py $SpeciesPath/${newname%.pep}_class/${newname%.pep}.tandem.pairs $SpeciesPath/${newname%.pep}_class/${newname%.pep}.proximal.pairs $SpeciesPath/${newname%.pep}_class/${newname%.pep}.merged.pairs
fi
done