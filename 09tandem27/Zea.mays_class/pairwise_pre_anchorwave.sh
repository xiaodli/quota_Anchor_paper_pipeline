#!/bin/bash

blast_path=/media/dell/E/Suppmentary_data/09tandem27/Zea.mays_class/01_pairwise_diamond
data_pwd=/media/dell/E/Suppmentary_data/09tandem27/Zea.mays_class/raw_data
array=(Zea.mays)
array2=(Zea.mays1)

mkdir -p 02_pairwise_synteny
cd 02_pairwise_synteny


# i is query and j is reference
# left is query and right is reference
# for i in "${array[@]}";do
# 	for j in "${array[@]}";do
       
# 		if [ "${i}" = "$j" ];then continue;fi
#               new_query=${i%.AAA}
#               new_query=${new_query%.BBB}
#               new_ref=${j%.AAA}
#               new_ref=${new_ref%.BBB}

#    		quota_Anchor pre_col -b $blast_path/${new_query}_${new_ref}.blast -rg $data_pwd/${new_ref}.gff3 -qg $data_pwd/${new_query}.gff3 -o ${i}_${j}.table -bs 100 -al 0 -rl $data_pwd/${j}_length.txt -ql $data_pwd/${i}_length.txt --skip_blast  --overwrite
		

# 	done
# done

parallel -j $(nproc) "
    query={1}
    ref={2}
    blast_path={3}
    data_pwd={4}
#    if [ "\$query" = "\$ref" ]; then
#        exit
#    fi
    new_query=\${query}
    new_ref=\${ref}

    quota_Anchor pre_col -b \$blast_path/\${new_ref}_\${new_query}.blast -rg \$data_pwd/\${new_ref}.gff3 -qg \$data_pwd/\${new_query}.gff3 -o \${query}_\${ref}.table -bs 0 -al 0 -rl \$data_pwd/\${ref}.length.txt -ql \$data_pwd/\${query}.length.txt --skip_blast  --overwrite

" ::: "${array2[@]}" ::: "${array[@]}" ::: "${blast_path}" ::: "${data_pwd}"
