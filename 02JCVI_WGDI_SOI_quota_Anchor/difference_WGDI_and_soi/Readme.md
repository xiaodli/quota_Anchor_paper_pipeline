# difference (quota_Anchor vs SOI, WGDI)

## blastp  vs blastp (quota_Anchor vs WGDI)

```bash
python difference_quota_Anchor_table_WGDI_SOI.py ../raw_data/sb.gff3 ../raw_data/zm.gff3 ../quota_Anchor_result/02blastp/sb_zm.table ../quota_Anchor_result/02blastp/sb2_zm1.table.collinearity ../WGDI_result/02blastp/sb.zm.collinearity.ks.correspondence.pc.alignment.txt ./blastp_difference.txt "WGDI"
```

## quota_Anchor vs SOI

```bash
sed s/gene_/gene:/g ../SOI_result/OrthoFinder_MCScanX/sb_zm.collinearity.ortho.txt > sb.zm.collinearity.ortho.txt
python difference_quota_Anchor_table_WGDI_SOI.py ../raw_data/sb.gff3 ../raw_data/zm.gff3 ../quota_Anchor_result/02blastp/sb_zm.table ../quota_Anchor_result/02blastp/sb2_zm1.table.collinearity sb.zm.collinearity.ortho.txt ./soi_difference.txt "SOI"
```

## plot

```bash
cp ../quota_Anchor_result/sb.length.txt .
cp ../quota_Anchor_result/zm.length.txt .
```

## PLOT

```bash
python sort.py blastp_difference.txt "WGDI" wgdi.txt
python sort.py soi_difference.txt "SOI" soi.txt
Rscript ./difference.dotplot.R
```
