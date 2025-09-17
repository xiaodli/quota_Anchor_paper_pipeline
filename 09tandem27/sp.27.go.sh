#!/bin/bash

SpeciesPath=/media/dell/E/Suppmentary_data/09tandem27


cat /media/dell/E/Suppmentary_data/09tandem27/species.txt |while read f number; do
newname=$(basename "$f")
if [[ "$newname" != "Joinvillea.ascendens.pep"  && "$newname" != "" ]]; then
   Rscript GO.R $SpeciesPath/${newname%.pep}_class/${newname%.pep}.go.annotation.txt $SpeciesPath/${newname%.pep}_class/${newname%.pep}.tandem.gene.txt $SpeciesPath/${newname%.pep}_class/${newname%.pep}.tandem.gene.enricher.result.txt
fi
done
