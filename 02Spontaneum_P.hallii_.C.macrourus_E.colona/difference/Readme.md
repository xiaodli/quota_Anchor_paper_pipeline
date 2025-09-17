# difference

## quota_Anchor vs quota_align (ss [vs] cm ec ph)

```bash
python difference_quota_Anchor_table_21_jcvi21.py ../WGDI_result/Saccharum.spontaneum.gff3 ../WGDI_result/Panicum.hallii.gff3 ../quota_Anchor_result/Saccharum.spontaneum_Panicum.hallii.table ../quota_Anchor_result/Saccharum.spontaneum1_Panicum.hallii4.collinearity ../JCVI_result/Panicum.Saccharum.1x4.anchors ./quota_align_Panicum.hallii_diamond_difference.txt
python difference_quota_Anchor_table_21_jcvi21.py ../WGDI_result/Saccharum.spontaneum.gff3 ../WGDI_result/Cenchrus.macrourus.gff3 ../quota_Anchor_result/Saccharum.spontaneum_Cenchrus.macrourus.table ../quota_Anchor_result/Saccharum.spontaneum2_Cenchrus.macrourus4.collinearity ../JCVI_result/Cenchrus.Saccharum.2x4.anchors ./quota_align_Cenchrus.macrourus_diamond_difference.txt
python difference_quota_Anchor_table_21_jcvi21.py ../WGDI_result/Saccharum.spontaneum.gff3 ../WGDI_result/Echinochloa.colona.gff3 ../quota_Anchor_result/Saccharum.spontaneum_Echinochloa.colona.table ../quota_Anchor_result/Saccharum.spontaneum3_Echinochloa.colona4.collinearity ../JCVI_result/Echinochloa.Saccharum.3x4.anchors ./quota_align_Echinochloa.colona_diamond_difference.txt
```

## sort dotplot [shared > other > quota_Anchor > homo (zorder)]

```bash
python sort.py ./quota_align_Panicum.hallii_diamond_difference.txt "quota_align" quota_align_Panicum.txt
python sort.py ./quota_align_Cenchrus.macrourus_diamond_difference.txt "quota_align" quota_align_Cenchrus.txt
python sort.py ./quota_align_Echinochloa.colona_diamond_difference.txt "quota_align" quota_align_Echinochloa.txt
less quota_align_Cenchrus.txt|sed 's/GWHBWDX000000//g' >rm_GWHBWDX000000_quota_align_Cenchrus.txt
```

## plot

```bash
Rscript ./difference.dotplot.R
```
