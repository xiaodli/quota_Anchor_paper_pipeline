# difference 

## diamond vs default , diamond vs diamond and blastp  vs blastp
```
python difference_quota_Anchor_table_21_jcvi21.py ../raw_data/sb.gff3 ../raw_data/zm.gff3 ../quota_Anchor_result/02blastp/sb_zm.table ../quota_Anchor_result/01diamond/sb2_zm1.table.collinearity ../JCVI_result/01default/zm.sb.2x1.anchors ./diamond_default_difference.txt
python difference_quota_Anchor_table_21_jcvi21.py ../raw_data/sb.gff3 ../raw_data/zm.gff3 ../quota_Anchor_result/02blastp/sb_zm.table ../quota_Anchor_result/02blastp/sb2_zm1.table.collinearity ../JCVI_result/03blast/zm.sb.2x1.anchors ./blast_difference.txt
python difference_quota_Anchor_table_21_jcvi21.py ../raw_data/sb.gff3 ../raw_data/zm.gff3 ../quota_Anchor_result/02blastp/sb_zm.table ../quota_Anchor_result/01diamond/sb2_zm1.table.collinearity ../JCVI_result/02diamond/zm.sb.2x1.anchors ./diamond_difference.txt
```
## extract maize chr1 chr4 chr6 chr10 vs sorghum 4 5 7 from diamond_default_difference.txt
```
python extract.py diamond_default_difference.txt diamond_default_difference.maize4.sorghum7_5.txt
```
## plot
```
cp ../quota_Anchor_result/sb.length.txt .
cp ../quota_Anchor_result/zm.length.txt .
```
## retain "1", "2", "4", "6", "10(maize) and 4 5 7(sorghum)
```
Rscript ./difference.dotplot.R
```
