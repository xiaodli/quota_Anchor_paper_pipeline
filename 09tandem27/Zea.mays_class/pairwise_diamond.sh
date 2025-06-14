#!/bin/bash

data_pwd=/media/dell/E/Suppmentary_data/09tandem27/Zea.mays_class/output_dir/01longest
array=(Zea.mays)
array2=(Zea.mays1)

mkdir -p 01_pairwise_diamond
cd 01_pairwise_diamond

for i in "${array[@]}";do
#   diamond makedb --db $i --in $data_pwd/$i.longest.pep
    makeblastdb -in $data_pwd/$i.longest.pep -dbtype prot -out $i
done

# i is query and j is reference
# left is query and right is reference
for i in "${array[@]}";do
	for j in "${array2[@]}";do
		echo "${i}_${j}"
#   		diamond blastp --db $j -q $data_pwd/$i.longest.pep -o "$i"_"$j".blast -k 20 -e 1e-10
        blastp -query $data_pwd/$j.longest.pep -out "$i"_"$j".blast -evalue 1e-10 -db $i -num_threads 16 -max_target_seqs 50 -outfmt 6
      wait
	done
done
