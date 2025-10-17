#!/bin/sh


gff_length_dir="/media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data"
pepdir="/media/dell/E/Suppmentary_data/05sequence/02longest"
ref_array=("Aegilops.searsii" "Aegilops.searsii" "Aegilops.searsii" "Saccharum.spontaneum" "Chloris.virgata" "Oryza.sativa" "Eragrostis.tef" "Echinochloa.colona" "Brachypodium.distachyon" "Coix.lacryma.jobi" "Achnatherum.splendens" "Avena.sativa.ot3098" "Triticum.monococcum" "Chloris.virgata" "Setaria.italica" "Cenchrus.macrourus" "Secale.cereale" "Setaria.viridis" "Saccharum.spontaneum" "Sorghum.bicolor" "Setaria.italica" "Leersia.perrieri" "Echinochloa.colona" "Achnatherum.splendens" "Saccharum.spontaneum" "Hordeum.marinum" "Poa.annua" "Saccharum.spontaneum" "Setaria.italica" "Setaria.viridis")
query_array=("Coix.lacryma.jobi" "Oryza.sativa" "Cenchrus.macrourus" "Setaria.viridis" "Thinopyrum.elongatum" "Triticum.monococcum" "Panicum.hallii" "Sorghum.bicolor" "Oryza.sativa" "Thinopyrum.elongatum" "Cenchrus.macrourus" "Bromus.tectorum" "Zea.mays" "Setaria.italica" "Avena.sativa.ot3098" "Panicum.hallii" "Setaria.viridis" "Sorghum.bicolor" "Cenchrus.macrourus" "Lolium.perenne" "Panicum.hallii" "Triticum.monococcum" "Panicum.hallii" "Thinopyrum.elongatum" "Thinopyrum.elongatum" "Cenchrus.macrourus" "Setaria.italica" "Panicum.hallii" "Leersia.perrieri" "Panicum.hallii")
r_value_array=("1" "1" "2" "1" "1" "1" "1" "1" "1" "1" "2" "1" "2" "1" "3" "1" "1" "1" "2" "1" "1" "1" "1" "1" "1" "2" "1" "1" "1" "1")
q_value_array=("1" "1" "1" "4" "1" "1" "2" "3" "1" "1" "2" "3" "1" "1" "1" "2" "1" "1" "4" "1" "1" "1" "3" "2" "4" "1" "2" "4" "1" "1" )

for array_index in "${!ref_array[@]}"; do {
          ref_species=${ref_array[array_index]}
          query_species=${query_array[array_index]}
          r_value=${r_value_array[array_index]}
          q_value=${q_value_array[array_index]}
    mkdir -p ${ref_species}_${query_species}
    quota_Anchor pre_col -a diamond -rs $pepdir/${ref_species}.pep -qs $pepdir/${query_species}.pep -db ./${ref_species}_${query_species}/${ref_species}.database -mts 20 -e 1e-10 -b ${ref_species}_${query_species}.blastp -rg $gff_length_dir/${ref_species}.gff3 -qg $gff_length_dir/${query_species}.gff3 -o ${ref_species}_${query_species}.table -bs 100 -al 0  -rl $gff_length_dir/${ref_species}.length.txt -ql $gff_length_dir/${query_species}.length.txt -t 16
    quota_Anchor col -i ${ref_species}_${query_species}.table -o ${ref_species}${r_value}_${query_species}${q_value}.collinearity -m 500 -W 0 -D 25 -I 2 -f 0 -s 0 -t 0 -a 0 -r ${r_value} -q ${q_value} --overwrite
    quota_Anchor col -i ${ref_species}_${query_species}.table -o ${ref_species}_${query_species}.total.collinearity -m 500 -W 0 -D 25 -I 2 -f 0 -s 0 -t 0 -a 1 --overwrite
    quota_Anchor dotplot -i ${ref_species}${r_value}_${query_species}${q_value}.collinearity -o ${ref_species}${r_value}_${query_species}${q_value}.collinearity.png -r $gff_length_dir/${ref_species}.length.txt -q $gff_length_dir/${query_species}.length.txt -r_label ${ref_species} -q_label ${query_species} -rm "Chr,chr" --overwrite
    quota_Anchor dotplot -i ${ref_species}_${query_species}.total.collinearity -o ${ref_species}_${query_species}.total.collinearity.png -r $gff_length_dir/${ref_species}.length.txt -q $gff_length_dir/${query_species}.length.txt -r_label ${ref_species} -q_label ${query_species} -rm "Chr,chr" --overwrite
    quota_Anchor dotplot -i ${ref_species}_${query_species}.table -o ${ref_species}_${query_species}.table.png -r $gff_length_dir/${ref_species}.length.txt -q $gff_length_dir/${query_species}.length.txt -r_label ${ref_species} -q_label ${query_species} -rm "Chr,chr"
}&
done
wait
