#!/bin/bash

table_path=/media/dell/E/Suppmentary_data/09tandem27/Zea.mays_class/02_pairwise_synteny
array=(Zea.mays)
array2=(Zea.mays1)

cd 02_pairwise_synteny


parallel -j $(nproc) "
    query={1}
    ref={2}
    table_path={3}

    if [ "\$query" = "\$ref" ]; then
        exit
    fi

    quota_Anchor col -i \$table_path/\${query}_\${ref}.table -o \$table_path/\${query}_\${ref}.collinearity -s 0 -a 0 -m 0 -W 0 -t 0 --overwrite

" ::: "${array2[@]}" ::: "${array[@]}" ::: "${table_path}" 


        
