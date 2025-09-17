#!/bin/bash

SpeciesPath=/media/dell/E/Suppmentary_data/09tandem27

export JAVA_HOME=/home/dell/.sdkman/candidates/java/11.0.27-amzn
export PATH=$JAVA_HOME/bin:$PATH

cat /media/dell/E/Suppmentary_data/09tandem27/species.txt |while read f number; do
newname=$(basename "$f")
if [[ "$newname" != "Joinvillea.ascendens.pep"  && "$newname" != "" ]]; then
    interproscan.sh -f TSV -i $SpeciesPath/${newname%.pep}_class/${newname%.pep}.species.chr.pep.txt -o $SpeciesPath/${newname%.pep}_class/${newname%.pep}.go.tsv -goterms -cpu 14 -pa -dp -hm
fi
done



