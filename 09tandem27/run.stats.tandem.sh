#!/bin/bash

SpeciesPath=/media/dell/E/Suppmentary_data/09tandem27
cat /media/dell/E/Suppmentary_data/09tandem27/species.txt |while read f number; do
newname=$(basename "$f")
if [[ "$newname" != "Joinvillea.ascendens.pep"  && "$newname" != "" ]]; then
   awk '{print $1, $3}' $SpeciesPath/${newname%.pep}_class/${newname%.pep}.merged.pairs|sed '1d' > $SpeciesPath/${newname%.pep}_class/${newname%.pep}.merged.pairs.txt
fi
done

cat /media/dell/E/Suppmentary_data/09tandem27/species.txt |while read f number; do
newname=$(basename "$f")
if [[ "$newname" != "Joinvillea.ascendens.pep"  && "$newname" != "" ]]; then
    python stats.tandem.py $SpeciesPath/${newname%.pep}_class/${newname%.pep}.merged.pairs $SpeciesPath/${newname%.pep}_class/${newname%.pep}.tandem.genes.stats
fi
done
