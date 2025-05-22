#!/bin/sh



ref_array=("zgc" "zgc" "zgc" "os" "os" "sb")
query_array=("os" "zm" "sb" "zm" "sb" "zm")
r_value_array=("1" "2" "1" "2" "1" "2")
q_value_array=("3" "3" "3" "1" "1" "1")

for array_index in "${!ref_array[@]}"; do {
          ref_species=${ref_array[array_index]}
          query_species=${query_array[array_index]}
          r_value=${r_value_array[array_index]}
          q_value=${q_value_array[array_index]}
    quota_Anchor pre_col -a diamond -rs ${ref_species}.pep -qs ${query_species}.pep -db ${ref_species}.database -mts 20 -e 1e-10 -b ${ref_species}_${query_species}.blastp -rg ${ref_species}.gff3 -qg ${query_species}.gff3 -o ${ref_species}_${query_species}.table -bs 100 -al 0 --overwrite -rl ${ref_species}.length.txt -ql ${query_species}.length.txt -t 16
    quota_Anchor col -i ${ref_species}_${query_species}.table -o ${ref_species}${r_value}_${query_species}${q_value}.collinearity -m 500 -W 5 -D 25 -I 2 -f 0 -s 0 -t 0 --overwrite -a 0 -r ${r_value} -q ${q_value}
    quota_Anchor col -i ${ref_species}_${query_species}.table -o ${ref_species}_${query_species}.total.collinearity -m 500 -W 5 -D 25 -I 2 -f 0 -s 0 -t 0 --overwrite -a 1
    quota_Anchor dotplot -i ${ref_species}${r_value}_${query_species}${q_value}.collinearity -o ${ref_species}${r_value}_${query_species}${q_value}.collinearity.png -r ${ref_species}.length.txt -q ${query_species}.length.txt -r_label ${ref_species} -q_label ${query_species} --overwrite -rm "Chr,chr"
}&
done
wait
