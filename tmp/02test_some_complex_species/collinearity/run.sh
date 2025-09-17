#!/bin/sh


gff_length_dir="/media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data"
pepdir="/media/dell/E/Suppmentary_data/05sequence/02longest"
ref_array=("Cenchrus.macrourus" "Echinochloa.colona" "Eragrostis.tef" "Saccharum.spontaneum" "Saccharum.spontaneum" "Avena.sativa.ot3098" "Saccharum.spontaneum")
query_array=("Panicum.hallii" "Panicum.hallii" "Panicum.hallii" "Panicum.hallii" "Cenchrus.macrourus" "Setaria.italica" "Echinochloa.colona")
r_value_array=("1" "1" "1" "1" "2" "1" "3")
q_value_array=("2" "3" "2" "4" "4" "3" "4")
#ref_array=("Saccharum.spontaneum" "Avena.sativa.ot3098" "Saccharum.spontaneum")
#query_array=("Cenchrus.macrourus" "Setaria.italica" "Echinochloa.colona")
#r_value_array=("2" "1" "3")
#q_value_array=("4" "3" "4")
#ref_array=("Avena.sativa.ot3098")
#query_array=("Setaria.italica")
#r_value_array=("1")
#q_value_array=("3")

for array_index in "${!ref_array[@]}"; do {
          ref_species=${ref_array[array_index]}
          query_species=${query_array[array_index]}
          r_value=${r_value_array[array_index]}
          q_value=${q_value_array[array_index]}
    mkdir -p ${ref_species}_${query_species}

#    quota_Anchor pre_col -a diamond -rs $pepdir/${ref_species}.pep -qs $pepdir/${query_species}.pep -db ./${ref_species}_${query_species}/${ref_species}.database -mts 20 -e 1e-10 -b ${ref_species}_${query_species}.blastp -rg $gff_length_dir/${ref_species}.gff3 -qg $gff_length_dir/${query_species}.gff3 -o ${ref_species}_${query_species}.table -bs 0 -al 0  -rl $gff_length_dir/${ref_species}.length.txt -ql $gff_length_dir/${query_species}.length.txt -t 16
#
#    quota_Anchor col -i ${ref_species}_${query_species}.table -o ${ref_species}${r_value}_${query_species}${q_value}.collinearity -m 500 -W 0 -D 30 -I 2 -f 0 -s 0 -t 0 -a 0 -r ${r_value} -q ${q_value}
#    quota_Anchor col -i ${ref_species}_${query_species}.table -o ${ref_species}_${query_species}.total.collinearity -m 500 -W 0 -D 30 -I 2 -f 0 -s 0 -t 0 -a 1

#    quota_Anchor ks -i ${ref_species}_${query_species}.total.collinearity -a muscle -p $pepdir/${ref_species}.pep,$pepdir/${query_species}.pep -d $pepdir/${ref_species}.cds,$pepdir/${query_species}.cds -o ${ref_species}_${query_species}.collinearity.ks -t 14 --debug ${ref_species}_${query_species}.collinearity.ks.debug1.txt -add_ks
#    quota_Anchor ks -i ${ref_species}${r_value}_${query_species}${q_value}.collinearity -a muscle -p $pepdir/${ref_species}.pep,$pepdir/${query_species}.pep -d $pepdir/${ref_species}.cds,$pepdir/${query_species}.cds -o ${ref_species}_${query_species}.collinearity.ks -t 14 -add_ks --debug ${ref_species}_${query_species}.collinearity.ks.debug2.txt
#
#    quota_Anchor dotplot -i ${ref_species}${r_value}_${query_species}${q_value}.collinearity -o ${ref_species}${r_value}_${query_species}${q_value}.collinearity.png -r $gff_length_dir/${ref_species}.length.txt -q $gff_length_dir/${query_species}.length.txt -r_label ${ref_species} -q_label ${query_species} -rm "Chr,chr" -ks ${ref_species}_${query_species}.collinearity.ks --overwrite -t base
#
#    quota_Anchor dotplot -i ${ref_species}_${query_species}.total.collinearity -o ${ref_species}_${query_species}.total.collinearity.png -r $gff_length_dir/${ref_species}.length.txt -q $gff_length_dir/${query_species}.length.txt -r_label ${ref_species} -q_label ${query_species} -rm "Chr,chr" -ks ${ref_species}_${query_species}.collinearity.ks --overwrite -t base

    quota_Anchor dotplot -i ${ref_species}_${query_species}.table -o ${ref_species}_${query_species}.table.png -r $gff_length_dir/${ref_species}.length.txt -q $gff_length_dir/${query_species}.length.txt -r_label ${ref_species} -q_label ${query_species} -rm "Chr,chr" -t base --overwrite
}&
done
wait
