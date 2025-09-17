# difference

## quota_Anchor vs WGDI (ss [vs] cm ec ph)

```bash
python difference_quota_Anchor_table_WGDI_SOI.py ../WGDI_result/Saccharum.spontaneum.gff3 ../WGDI_result/Panicum.hallii.gff3 ../quota_Anchor_result/Saccharum.spontaneum_Panicum.hallii.table ../quota_Anchor_result/Saccharum.spontaneum1_Panicum.hallii4.collinearity ../WGDI_result/Saccharum.spontaneum_Panicum.hallii/Saccharum.spontaneum_Panicum.hallii.collinearity.ks.correspondence.pc.alignment.txt ./WGDI_Panicum_diamond_difference.txt "WGDI"

awk '{OFS="\t"; print $2, $1}' ../WGDI_result/Saccharum.spontaneum_Cenchrus.macrourus/Saccharum.spontaneum_Cenchrus.macrourus.collinearity.txt > inverse.Saccharum.spontaneum_Cenchrus.macrourus.collinearity.txt
python difference_quota_Anchor_table_WGDI_SOI.py ../WGDI_result/Saccharum.spontaneum.gff3 ../WGDI_result/Cenchrus.macrourus.gff3 ../quota_Anchor_result/Saccharum.spontaneum_Cenchrus.macrourus.table ../quota_Anchor_result/Saccharum.spontaneum2_Cenchrus.macrourus4.collinearity inverse.Saccharum.spontaneum_Cenchrus.macrourus.collinearity.txt ./WGDI_Cenchrus_diamond_difference.txt "WGDI"

awk '{OFS="\t"; print $2, $1}' ../WGDI_result/Saccharum.spontaneum_Echinochloa.colona/Saccharum.spontaneum_Echinochloa.colona.collinearity.txt > inverse.Saccharum.spontaneum_Echinochloa.colona.collinearity.txt
python difference_quota_Anchor_table_WGDI_SOI.py ../WGDI_result/Saccharum.spontaneum.gff3 ../WGDI_result/Echinochloa.colona.gff3 ../quota_Anchor_result/Saccharum.spontaneum_Echinochloa.colona.table ../quota_Anchor_result/Saccharum.spontaneum3_Echinochloa.colona4.collinearity inverse.Saccharum.spontaneum_Echinochloa.colona.collinearity.txt  ./WGDI_Echinochloa_diamond_difference.txt "WGDI"
```

## quota_Anchor vs SOI (ss [vs] cm ec ph)

```bash
python difference_quota_Anchor_table_WGDI_SOI.py ../WGDI_result/Saccharum.spontaneum.gff3 ../WGDI_result/Panicum.hallii.gff3 ../quota_Anchor_result/Saccharum.spontaneum_Panicum.hallii.table ../quota_Anchor_result/Saccharum.spontaneum1_Panicum.hallii4.collinearity ../SOI_result/orthofinder_Panicum/ss_ph.collinearity.ortho.txt ./soi_Panicum_difference.txt "SOI"

python difference_quota_Anchor_table_WGDI_SOI.py ../WGDI_result/Saccharum.spontaneum.gff3 ../WGDI_result/Cenchrus.macrourus.gff3 ../quota_Anchor_result/Saccharum.spontaneum_Cenchrus.macrourus.table ../quota_Anchor_result/Saccharum.spontaneum2_Cenchrus.macrourus4.collinearity ../SOI_result/orthofinder_Cenchrus/ss_cm.collinearity.ortho.txt ./soi_Cenchrus_difference.txt "SOI"

python difference_quota_Anchor_table_WGDI_SOI.py ../WGDI_result/Saccharum.spontaneum.gff3 ../WGDI_result/Echinochloa.colona.gff3 ../quota_Anchor_result/Saccharum.spontaneum_Echinochloa.colona.table ../quota_Anchor_result/Saccharum.spontaneum3_Echinochloa.colona4.collinearity  ../SOI_result/orthofinder_Echinochloa/ss_ec.collinearity.ortho.txt ./soi_Echinochloa_difference.txt "SOI"
```

## sort dotplot [shared > other > quota_Anchor > homo(zorder)]

```bash
python sort.py ./WGDI_Panicum_diamond_difference.txt "WGDI" WGDI_Panicum.txt
python sort.py ./WGDI_Cenchrus_diamond_difference.txt "WGDI" WGDI_Cenchrus.txt
python sort.py ./WGDI_Echinochloa_diamond_difference.txt "WGDI" WGDI_Echinochloa.txt

python sort.py ./soi_Panicum_difference.txt "SOI" soi_Panicum.txt
python sort.py ./soi_Cenchrus_difference.txt "SOI" soi_Cenchrus.txt
python sort.py ./soi_Echinochloa_difference.txt "SOI" soi_Echinochloa.txt
less soi_Cenchrus.txt|sed 's/GWHBWDX000000//g'>rm_GWHBWDX000000_soi_Cenchrus.txt
less WGDI_Cenchrus.txt|sed 's/GWHBWDX000000//g'>rm_GWHBWDX000000_WGDI_Cenchrus.txt
```

## plot

```bash
Rscript ./difference.dotplot.R
```
