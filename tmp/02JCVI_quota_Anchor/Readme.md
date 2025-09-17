# networkx are dependencies

## Download maize and sorghum genome and annotation data (JCVI vs quota_Anchor)

```bash
mkdir -p raw_data
cd raw_data
mwget -n 16 https://ftp.ensemblgenomes.ebi.ac.uk/pub/current/plants/fasta/zea_mays/dna/Zea_mays.Zm-B73-REFERENCE-NAM-5.0.dna.toplevel.fa.gz -f ./zm.fa.gz
mwget -n 16 https://ftp.ensemblgenomes.ebi.ac.uk/pub/current/plants/gff3/zea_mays/Zea_mays.Zm-B73-REFERENCE-NAM-5.0.60.chr.gff3.gz -f ./zm.gff3.gz 
mwget -n 16 https://ftp.ensemblgenomes.ebi.ac.uk/pub/current/plants/fasta/sorghum_bicolor/dna/Sorghum_bicolor.Sorghum_bicolor_NCBIv3.dna.toplevel.fa.gz -f ./sb.fa.gz
mwget -n 16 https://ftp.ensemblgenomes.ebi.ac.uk/pub/current/plants/gff3/sorghum_bicolor/Sorghum_bicolor.Sorghum_bicolor_NCBIv3.60.chr.gff3.gz -f ./sb.gff3.gz
gunzip *gz
cd ..
```

## quota_Anchor diamond/blastp pep

```bash
quota_Anchor longest_pep -f ./raw_data/zm.fa,./raw_data/sb.fa  -g ./raw_data/zm.gff3,./raw_data/sb.gff3 -p ./quota_Anchor_result/zm.raw.pep,./quota_Anchor_result/sb.raw.pep -l ./quota_Anchor_result/zm.pep,./quota_Anchor_result/sb.pep -t 2 --overwrite
quota_Anchor longest_cds -f ./raw_data/zm.fa,./raw_data/sb.fa  -g ./raw_data/zm.gff3,./raw_data/sb.gff3 -p ./quota_Anchor_result/zm.raw.cds,./quota_Anchor_result/sb.raw.cds -l ./quota_Anchor_result/zm.cds,./quota_Anchor_result/sb.cds -t 2 --overwrite

quota_Anchor get_chr_length -f ./raw_data/zm.fa.fai,./raw_data/sb.fa.fai -g ./raw_data/zm.gff3,./raw_data/sb.gff3 -s "[0-9],chr,Chr:chr,Chr,[0-9]" -o ./quota_Anchor_result/zm.length.txt,./quota_Anchor_result/sb.length.txt --overwrite

quota_Anchor pre_col -a diamond -rs ./quota_Anchor_result/sb.pep -qs ./quota_Anchor_result/zm.pep -db ./quota_Anchor_result/01diamond/sb.database -mts 20 -e 1e-10 -b ./quota_Anchor_result/01diamond/sb.zm.diamond.blastp -rg ./raw_data/sb.gff3 -qg ./raw_data/zm.gff3 -o ./quota_Anchor_result/01diamond/sb_zm.table -bs 100 -al 0 --overwrite -rl ./quota_Anchor_result/sb.length.txt -ql ./quota_Anchor_result/zm.length.txt   
quota_Anchor col -i ./quota_Anchor_result/01diamond/sb_zm.table -o ./quota_Anchor_result/01diamond/sb2_zm1.table.collinearity -m 500 -W 5 -D 25 -I 2 -f 0 -s 0 -t 0 --overwrite -a 0 -r 2 -q 1

quota_Anchor pre_col -a blastp -rs ./quota_Anchor_result/sb.pep -qs ./quota_Anchor_result/zm.pep -db ./quota_Anchor_result/02blastp/sb.database -mts 20 -e 1e-10 -b ./quota_Anchor_result/02blastp/sb.zm.blastp -rg ./raw_data/sb.gff3 -qg ./raw_data/zm.gff3 -o ./quota_Anchor_result/02blastp/sb_zm.table -bs 100 -al 0 --overwrite -rl ./quota_Anchor_result/sb.length.txt -ql ./quota_Anchor_result/zm.length.txt -t 16   
quota_Anchor col -i ./quota_Anchor_result/02blastp/sb_zm.table -o ./quota_Anchor_result/02blastp/sb2_zm1.table.collinearity -m 500 -W 5 -D 25 -I 2 -f 0 -s 0 -t 0 --overwrite -a 0 -r 2 -q 1
```

## JCVI 1.4.25

```bash
mkdir JCVI_result
cd JCVI_result
```

### JCVI  default (lastal, remove tandem, cds)

```bash
mkdir -p 01default
cd 01default
python -m jcvi.formats.gff bed ../../raw_data/zm.gff3 -o zm.raw.bed
sed '/^scaf/d' zm.raw.bed > zm.bed
python -m jcvi.formats.gff bed ../../raw_data/sb.gff3 -o sb.raw.bed
sed '/^super/d' sb.raw.bed > sb.bed
cp ../../quota_Anchor_result/sb.cds .
cp ../../quota_Anchor_result/zm.cds .
python -m jcvi.compara.catalog ortholog zm sb --notex
python -m jcvi.compara.quota zm.sb.anchors --qbed zm.bed --sbed sb.bed --quota 2:1 --screen
python -m jcvi.graphics.dotplot --notex zm.sb.2x1.anchors
cd ..
```

### JCVI (diamond, remove tandem, pep)

```bash
mkdir -p 02diamond
cd 02diamond
python -m jcvi.formats.gff bed ../../raw_data/zm.gff3 -o zm.raw.bed
sed '/^scaf/d' zm.raw.bed > zm.bed
python -m jcvi.formats.gff bed ../../raw_data/sb.gff3 -o sb.raw.bed
sed '/^super/d' sb.raw.bed > sb.bed
cp ../../quota_Anchor_result/sb.pep .
cp ../../quota_Anchor_result/zm.pep .
python -m jcvi.compara.catalog ortholog zm sb --notex --dbtype prot --align_soft diamond_blastp
python -m jcvi.compara.quota zm.sb.anchors --qbed zm.bed --sbed sb.bed --quota 2:1 --screen
python -m jcvi.graphics.dotplot --notex zm.sb.2x1.anchors
cd ..
```

### JCVI (blast, remove tandem, pep)

```bash
mkdir -p 03blast
cd 03blast
python -m jcvi.formats.gff bed ../../raw_data/zm.gff3 -o zm.raw.bed
sed '/^scaf/d' zm.raw.bed > zm.bed
python -m jcvi.formats.gff bed ../../raw_data/sb.gff3 -o sb.raw.bed
sed '/^super/d' sb.raw.bed > sb.bed
cp ../../quota_Anchor_result/sb.pep .
cp ../../quota_Anchor_result/zm.pep .
python -m jcvi.compara.catalog ortholog zm sb --notex --dbtype prot --align_soft blast
python -m jcvi.compara.quota zm.sb.anchors --qbed zm.bed --sbed sb.bed --quota 2:1 --screen
python -m jcvi.graphics.dotplot --notex zm.sb.2x1.anchors
cd ../..
```

```bash
cat ./JCVI_result/01default/zm.sb.2x1.anchors|grep -v "#"|awk '{OFS="\t"; print $1, $2}'>./JCVI_result/01default/zm.sb.2x1.anchors.txt
cat ./JCVI_result/02diamond/zm.sb.2x1.anchors|grep -v "#"|awk '{OFS="\t"; print $1, $2}'>./JCVI_result/02diamond/zm.sb.2x1.anchors.txt
cat ./JCVI_result/03blast/zm.sb.2x1.anchors|grep -v "#"|awk '{OFS="\t"; print $1, $2}'>./JCVI_result/03blast/zm.sb.2x1.anchors.txt

cat ./quota_Anchor_result/01diamond/sb2_zm1.table.collinearity|grep -v "#"|awk '{OFS="\t"; print $6, $1}'|sed '1d'> ./quota_Anchor_result/01diamond/sb2_zm1.table.collinearity.txt
cat ./quota_Anchor_result/02blastp/sb2_zm1.table.collinearity|grep -v "#"|awk '{OFS="\t"; print $6, $1}'|sed '1d'> ./quota_Anchor_result/02blastp/sb2_zm1.table.collinearity.txt
```

## get 1:1 2:1 other_ratio info(cluster)

```bash
python parse_collinearity_file.py ./JCVI_result/01default/zm.sb.2x1.anchors.txt ./JCVI_result/02diamond/zm.sb.2x1.anchors.txt ./JCVI_result/03blast/zm.sb.2x1.anchors.txt ./quota_Anchor_result/01diamond/sb2_zm1.table.collinearity.txt ./quota_Anchor_result/02blastp/sb2_zm1.table.collinearity.txt five_type_bar.txt
```

## get 1:1 2:1 other_ratio info(gene pairs)

```bash
python parse_collinearity_file_gene_pairs.py ./JCVI_result/01default/zm.sb.2x1.anchors.txt ./JCVI_result/02diamond/zm.sb.2x1.anchors.txt ./JCVI_result/03blast/zm.sb.2x1.anchors.txt ./quota_Anchor_result/01diamond/sb2_zm1.table.collinearity.txt ./quota_Anchor_result/02blastp/sb2_zm1.table.collinearity.txt venn.txt five_type_bar_gene_pairs.txt
```

```bash
Rscript ./stack_bar.R
```

## Supplementary figure

```bash
quota_Anchor col -i ./quota_Anchor_result/01diamond/sb_zm.table -o ./quota_Anchor_result/01diamond/sb_zm.total.collinearity -m 500 -W 5 -D 25 -I 2 -f 0 -s 0 -t 0 --overwrite -a 1
quota_Anchor ks -i ./quota_Anchor_result/01diamond/sb_zm.total.collinearity -a muscle -p ./quota_Anchor_result/sb.pep,./quota_Anchor_result/zm.pep -d ./quota_Anchor_result/sb.cds,./quota_Anchor_result/zm.cds  -o ./quota_Anchor_result/01diamond/sb_zm.ks -t 16 -add_ks 
quota_Anchor dotplot -i ./quota_Anchor_result/01diamond/sb_zm.total.collinearity -o ./quota_Anchor_result/01diamond/sb_zm.total.ks.png -r ./quota_Anchor_result/sb.length.txt -q ./quota_Anchor_result/zm.length.txt -r_label "Sorghum bicolor" -q_label "Zea mays" --overwrite -ks ./quota_Anchor_result/01diamond/sb_zm.ks
```
