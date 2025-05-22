#!/bin/bash

tablepath=/media/dell/E/Suppmentary_data/07vis/table
colpath=/media/dell/E/Suppmentary_data/07vis/collinearity
peppath=/media/dell/E/Suppmentary_data/05sequence/02longest
gffpath=/media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data
ref_species=(Brachypodium.distachyon Bromus.tectorum Eragrostis.tef Leersia.perrieri Oryza.sativa Panicum.hallii Poa.annua Secale.cereale Setaria.viridis Sorghum.bicolor)
query_species=(Bromus.tectorum Eragrostis.tef Leersia.perrieri Oryza.sativa Panicum.hallii Poa.annua Secale.cereale Setaria.viridis Sorghum.bicolor Zea.mays)
Q=("1" "1" "2" "2" "1" "1" "2" "1" "1" "1")
R=("1" "2" "2" "1" "1" "2" "1" "1" "1" "2")
for folder_index in "${!query_species[@]}"; do {
     query=${query_species[$folder_index]}
     ref=${ref_species[$folder_index]}
     q=${Q[$folder_index]}
     r=${R[$folder_index]}
     quota_Anchor pre_col -a diamond -rs ${peppath}/${ref}.pep -qs ${peppath}/${query}.pep -db ${ref}.diamond -mts 20 -e 1e-10 -b ${tablepath}/${ref}_${query}.blast -rg ${gffpath}/${ref}.gff3 -qg ${gffpath}/${query}.gff3 -o ${tablepath}/${ref}_${query}.table -bs 100 -al 0 -rl ${gffpath}/${ref}.length.txt -ql ${gffpath}/${query}.length.txt --overwrite
     quota_Anchor col -i ${tablepath}/${ref}_${query}.table -o ${colpath}/${ref}_${query}.collinearity -s 0 --overwrite -D 25 -a 0 -r $r -q $q -W 5 -m 500 -I 5
}&
done
wait
