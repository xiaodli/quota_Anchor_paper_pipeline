#!/bin/bash

SpeciesPath=/media/dell/E/Suppmentary_data/09tandem27


cat /media/dell/E/Suppmentary_data/09tandem27/species.txt |while read f number; do
newname=$(basename "$f")
if [[ "$newname" != "Joinvillea.ascendens.pep"  && "$newname" != "" ]]; then
    python read.obo.tsv.py -i go-basic.obo -t $SpeciesPath/${newname%.pep}_class/${newname%.pep}.go.txt -o $SpeciesPath/${newname%.pep}_class/${newname%.pep}.go.annotation.txt
fi
done
