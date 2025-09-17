#!/bin/bash

# blast or diamond local alignment
pep_path=/media/dell/E/Suppmentary_data/10Ericales/raw_data/dl/output_dir/01longest
raw_data_path=/media/dell/E/Suppmentary_data/10Ericales/raw_data/dl/raw_data
array_ref=(dl)
array_query=(dl)


for i in "${array_ref[@]}";do
     diamond makedb --db "$i" --in $pep_path/"$i".longest.pep
done


for qry in "${array_query[@]}";do
	for ref in "${array_ref[@]}";do
		echo "${qry}_${ref}"
   		diamond blastp --db "$ref" -q $pep_path/"$qry".longest.pep -o "$qry"_"$ref".blast -k 50 -e 1e-5
      wait
	done
done


parallel -j "$(nproc)" "
    query={1}
    ref={2}
    raw_data_path={3}
    new_query=\${query}
    new_ref=\${ref}

    quota_Anchor pre_col -b \${new_query}_\${new_ref}.blast -qg \$raw_data_path/\${new_query}.gff3 -rg \$raw_data_path/\${new_ref}.gff3 -o \${query}_\${ref}.table -bs 0 -al 0 -rl \$raw_data_path/\${ref}.length.txt -ql \$raw_data_path/\${query}.length.txt --skip_blast  --overwrite

" ::: "${array_query[@]}" ::: "${array_ref[@]}" ::: "${raw_data_path}"


parallel -j "$(nproc)" "
    query={1}
    ref={2}
    raw_data_path={3}
#    if [ "\$query\" = \"\$ref" ]; then
#        exit
#    fi

    quota_Anchor col -i \${query}_\${ref}.table -o \${query}_\${ref}.collinearity -s 0 -a 1 -m 500 -W 0 -t 0 -E -0.005 --overwrite
    quota_Anchor dotplot -i \${query}_\${ref}.table -o \${query}_\${ref}.table.png -r \$raw_data_path/\${ref}.length.txt -q \$raw_data_path/\${query}.length.txt -r_label "dl" -q_label "dl" --overwrite
    quota_Anchor dotplot -i \${query}_\${ref}.collinearity -o \${query}_\${ref}.collinearity.png -r \$raw_data_path/\${ref}.length.txt -q \$raw_data_path/\${query}.length.txt -r_label "dl" -q_label "dl" --overwrite
" ::: "${array_query[@]}" ::: "${array_ref[@]}" ::: "${raw_data_path}"
