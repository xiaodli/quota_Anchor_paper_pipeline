# SOI WGDI quota_align quota_Anchor

## Download maize and sorghum genome and annotation data

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

## quota_Anchor result

### quota_Anchor diamond/blastp pep

```bash
quota_Anchor longest_pep -f ./raw_data/zm.fa,./raw_data/sb.fa  -g ./raw_data/zm.gff3,./raw_data/sb.gff3 -p ./quota_Anchor_result/zm.raw.pep,./quota_Anchor_result/sb.raw.pep -l ./quota_Anchor_result/zm.pep,./quota_Anchor_result/sb.pep -t 2 --overwrite
quota_Anchor longest_cds -f ./raw_data/zm.fa,./raw_data/sb.fa  -g ./raw_data/zm.gff3,./raw_data/sb.gff3 -p ./quota_Anchor_result/zm.raw.cds,./quota_Anchor_result/sb.raw.cds -l ./quota_Anchor_result/zm.cds,./quota_Anchor_result/sb.cds -t 2 --overwrite

quota_Anchor get_chr_length -f ./raw_data/zm.fa.fai,./raw_data/sb.fa.fai -g ./raw_data/zm.gff3,./raw_data/sb.gff3 -s "[0-9],chr,Chr:chr,Chr,[0-9]" -o ./quota_Anchor_result/zm.length.txt,./quota_Anchor_result/sb.length.txt --overwrite

quota_Anchor pre_col -a diamond -rs ./quota_Anchor_result/sb.pep -qs ./quota_Anchor_result/zm.pep -db ./quota_Anchor_result/01diamond/sb.database -mts 20 -e 1e-10 -b ./quota_Anchor_result/01diamond/sb.zm.diamond.blastp -rg ./raw_data/sb.gff3 -qg ./raw_data/zm.gff3 -o ./quota_Anchor_result/01diamond/sb_zm.table -bs 100 -al 0 --overwrite -rl ./quota_Anchor_result/sb.length.txt -ql ./quota_Anchor_result/zm.length.txt   
quota_Anchor col -i ./quota_Anchor_result/01diamond/sb_zm.table -o ./quota_Anchor_result/01diamond/sb2_zm1.table.collinearity -m 500 -W 5 -D 25 -I 4 -f 0 -s 0 -t 0 --overwrite -a 0 -r 2 -q 1

quota_Anchor pre_col -a blastp -rs ./quota_Anchor_result/sb.pep -qs ./quota_Anchor_result/zm.pep -db ./quota_Anchor_result/02blastp/sb.database -mts 20 -e 1e-10 -b ./quota_Anchor_result/02blastp/sb.zm.blastp -rg ./raw_data/sb.gff3 -qg ./raw_data/zm.gff3 -o ./quota_Anchor_result/02blastp/sb_zm.table -bs 100 -al 0 --overwrite -rl ./quota_Anchor_result/sb.length.txt -ql ./quota_Anchor_result/zm.length.txt -t 16   
quota_Anchor col -i ./quota_Anchor_result/02blastp/sb_zm.table -o ./quota_Anchor_result/02blastp/sb2_zm1.table.collinearity -m 500 -W 5 -D 25 -I 4 -f 0 -s 0 -t 0 --overwrite -a 0 -r 2 -q 1
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

## WGDI 0.74

```bash
Note: (Here we only focus on the 2:1 alignment depth, so we do not further construct a subgenome tree for subgenome phasing.)
```

```bash
mkdir WGDI_result
cd WGDI_result
cp ../raw_data/sb.gff3 .
cp ../raw_data/zm.gff3 .
python 01.py sb.gff3 sb.new.gff3
python 01.py zm.gff3 zm.new.gff3
python 02.py sb.new.gff3 sb.final.gff3 sb.lens
python 02.py zm.new.gff3 zm.final.gff3 zm.lens
```

### WGDI diamond

```bash
mkdir -p 01diamond
cd 01diamond
cp ../../quota_Anchor_result/01diamond/sb.zm.diamond.blastp .
wgdi -icl icl.conf
cp ../../quota_Anchor_result/sb.cds .
cp ../../quota_Anchor_result/zm.cds .
cp ../../quota_Anchor_result/sb.pep .
cp ../../quota_Anchor_result/zm.pep .
cat sb.cds zm.cds > total.cds
cat zm.pep sb.pep > total.pep
wgdi -ks ks.conf
wgdi -bi blockinfo.conf
wgdi -c corr.conf
wgdi -bk bk.conf
wgdi -km km.conf
```

```bash
wgdi -pc pc.conf
wgdi -a alignment.conf
cd ..
```

### WGDI blastp

```bash
mkdir -p 02blastp
cd 02blastp  
cp ../../quota_Anchor_result/02blastp/sb.zm.blastp .
wgdi -icl icl.conf
cp ../../quota_Anchor_result/sb.cds .
cp ../../quota_Anchor_result/zm.cds .
cp ../../quota_Anchor_result/sb.pep .
cp ../../quota_Anchor_result/zm.pep .
cat sb.cds zm.cds > total.cds
cat zm.pep sb.pep > total.pep
wgdi -ks ks.conf
wgdi -bi blockinfo.conf
wgdi -c corr.conf
wgdi -bk bk.conf
cp ../01diamond/sb.ancestor.txt
wgdi -km km.conf
```

```bash
wgdi -pc pc.conf
wgdi -a alignment.conf
cd ../..
```

```bash
cat ./WGDI_result/01diamond/sb.zm.collinearity.ks.correspondence.pc.alignment.csv|awk -F "," '{OFS="\t"; print $2, $1}'|sort|sed '/^\./d'|sort|awk 'NF>1 {print $0}' > ./WGDI_result/01diamond/sb.zm.collinearity.ks.correspondence.pc.alignment.1.txt
cat ./WGDI_result/01diamond/sb.zm.collinearity.ks.correspondence.pc.alignment.csv|awk -F "," '{OFS="\t"; print $3, $1}'|sort|sed '/^\./d'|sort|sed 's/\r/\t/g'|awk 'NF>1 {print $0}' > ./WGDI_result/01diamond/sb.zm.collinearity.ks.correspondence.pc.alignment.2.txt
cat ./WGDI_result/01diamond/sb.zm.collinearity.ks.correspondence.pc.alignment.1.txt ./WGDI_result/01diamond/sb.zm.collinearity.ks.correspondence.pc.alignment.2.txt > ./WGDI_result/01diamond/sb.zm.collinearity.ks.correspondence.pc.alignment.txt 

cat ./WGDI_result/02blastp/sb.zm.collinearity.ks.correspondence.pc.alignment.csv|awk -F "," '{OFS="\t"; print $2, $1}'|sort|sed '/^\./d'|sort|awk 'NF>1 {print $0}' > ./WGDI_result/02blastp/sb.zm.collinearity.ks.correspondence.pc.alignment.1.txt
cat ./WGDI_result/02blastp/sb.zm.collinearity.ks.correspondence.pc.alignment.csv|awk -F "," '{OFS="\t"; print $3, $1}'|sort|sed '/^\./d'|sort|sed 's/\r/\t/g'|awk 'NF>1 {print $0}' > ./WGDI_result/02blastp/sb.zm.collinearity.ks.correspondence.pc.alignment.2.txt
cat ./WGDI_result/02blastp/sb.zm.collinearity.ks.correspondence.pc.alignment.1.txt ./WGDI_result/02blastp/sb.zm.collinearity.ks.correspondence.pc.alignment.2.txt > ./WGDI_result/02blastp/sb.zm.collinearity.ks.correspondence.pc.alignment.txt
```

## SOI 1.2.8 (20250905)

### SOI example data

```bash
git clone https://github.com/zhangrengang/orthoindex.git
less ./orthoindex/example_data/Populus_trichocarpa-Salix_dunnii.collinearity.ortho|grep -v "#"|awk '{print $1}'|wc -l
less ./orthoindex/example_data/Populus_trichocarpa-Salix_dunnii.collinearity.ortho|grep -v "#"|awk '{print $1}'|sort |uniq |wc -l
```

### create dir

```bash
mkdir -p SOI_result
cd SOI_result
```

### Run OrthoFinder

```bash
mkdir -p orthofinder
cd orthofinder
mkdir -p raw_data
cp ../../quota_Anchor_result/sb.pep ./raw_data
cp ../../quota_Anchor_result/zm.pep ./raw_data
orthofinder -f raw_data -M msa -t 14 -a 4
cd ..
```

### SOI (OrthoFinder + WGDI)

```bash
mkdir -p OrthoFinder_WGDI
cd OrthoFinder_WGDI

cp ../../WGDI_result/02blastp/sb.zm.collinearity .
sed -i 's/gene:/gene_/g' sb.zm.collinearity
sed -E -i 's/([0-9]+)\&([0-9]+)/zm\1\&sb\2/g' sb.zm.collinearity  

cp ../../WGDI_result/sb.final.gff3 .
cp ../../WGDI_result/zm.final.gff3 .
sed -i s/^/sb/g sb.final.gff3 
sed -i s/^/zm/g zm.final.gff3
cat sb.final.gff3 zm.final.gff3 > sb.zm.gff
sed -i 's/gene:/gene_/g' sb.zm.gff
```

```bash
soi dotplot -s sb.zm.collinearity \
        -g sb.zm.gff -c sb.zm.ctl  \
        --xlabel 'Sorghum' --ylabel 'Maize' \
        --ks-hist -o sb.zm.io    \
        --plot-ploidy --gene-axis --number-plots \
        --ofdir ../orthofinder/raw_data/OrthoFinder/Results_Sep05/ --of-color
soi filter -s sb.zm.collinearity -o ../orthofinder/raw_data/OrthoFinder/Results_Sep05/ -c 0.8 > sb.zm.collinearity.ortho
soi dotplot -s sb.zm.collinearity.ortho \
        -g sb.zm.gff -c sb.zm.ctl  \
        --xlabel 'Sorghum' --ylabel 'Maize' \
        --ks-hist -o sb.zm.io    \
        --plot-ploidy --gene-axis --number-plots \
        --ofdir ../orthofinder/raw_data/OrthoFinder/Results_Sep05/ --of-color
cd ../
```

### SOI (OrthoFinder + MCScanX[1.0.0])

#### Run MCScanX

```bash
mkdir -p OrthoFinder_MCScanX
cd OrthoFinder_MCScanX
cp ../OrthoFinder_WGDI/zm.final.gff3 .
cp ../OrthoFinder_WGDI/sb.final.gff3 .
awk '{print $1, $2, $3, $4}' sb.final.gff3 > sb.gff
awk '{print $1, $2, $3, $4}' zm.final.gff3 > zm.gff
sed -i 's/gene://g' sb.gff
sed -i 's/gene://g' zm.gff
cat sb.gff zm.gff > sb_zm.gff
sed -i 's/ /\t/g' sb_zm.gff
cp ../../WGDI_result/02blastp/sb.zm.blastp .
sed -i 's/gene://g' sb.zm.blastp
mv sb.zm.blastp sb_zm.blast
./MCScanX sb_zm
```

#### SOI (OrthoFinder + MCScanX)

```bash
cp ../OrthoFinder_WGDI/sb.zm.ctl .
mv sb.zm.ctl sb_zm.ctl
sed -i 's/SOR/gene_SOR/g' sb_zm.collinearity
sed -i 's/Zm/gene_Zm/g' sb_zm.collinearity
sed -i 's/Zm/gene_Zm/g' sb_zm.gff
sed -i 's/SOR/gene_SOR/g' sb_zm.gff
soi dotplot -s sb_zm.collinearity \
        -g sb_zm.gff -c sb_zm.ctl  \
        --xlabel 'Sorghum' --ylabel 'Maize' \
        --ks-hist -o sb_zm.io    \
        --plot-ploidy --gene-axis --number-plots \
        --ofdir ../orthofinder/raw_data/OrthoFinder/Results_Sep05/ --of-color
soi filter -s sb_zm.collinearity -o ../orthofinder/raw_data/OrthoFinder/Results_Sep05/ -c 0.8 > sb_zm.collinearity.ortho
soi dotplot -s sb_zm.collinearity.ortho \
        -g sb_zm.gff -c sb_zm.ctl  \
        --xlabel 'Sorghum' --ylabel 'Maize' \
        --ks-hist -o sb_zm.io    \
        --plot-ploidy --gene-axis --number-plots \
        --ofdir ../orthofinder/raw_data/OrthoFinder/Results_Sep05/ --of-color
cd ../..
```

```bash
cat ./SOI_result/OrthoFinder_MCScanX/sb_zm.collinearity.ortho|grep -v "#"|awk -F "\t" '{OFS="\t"; print $3, $2}'> ./SOI_result/OrthoFinder_MCScanX/sb_zm.collinearity.ortho.txt
cat ./SOI_result/OrthoFinder_WGDI/sb.zm.collinearity.ortho|grep -v "#"|awk '{OFS="\t"; print $1, $3}' > ./SOI_result/OrthoFinder_WGDI/sb.zm.collinearity.ortho.txt
```

## get 1:1 2:1 other_ratio info(cluster)

```bash
python parse_collinearity_file.py ./JCVI_result/01default/zm.sb.2x1.anchors.txt ./JCVI_result/02diamond/zm.sb.2x1.anchors.txt ./JCVI_result/03blast/zm.sb.2x1.anchors.txt \
    ./quota_Anchor_result/01diamond/sb2_zm1.table.collinearity.txt ./quota_Anchor_result/02blastp/sb2_zm1.table.collinearity.txt \
    ./WGDI_result/01diamond/sb.zm.collinearity.ks.correspondence.pc.alignment.txt ./WGDI_result/02blastp/sb.zm.collinearity.ks.correspondence.pc.alignment.txt \
    ./SOI_result/OrthoFinder_MCScanX/sb_zm.collinearity.ortho.txt ./SOI_result/OrthoFinder_WGDI/sb.zm.collinearity.ortho.txt \
    ./nine_type_bar.txt
```

```bash
Rscript ./stack_bar.R
```

## Supplementary figure

```bash
quota_Anchor col -i ./quota_Anchor_result/01diamond/sb_zm.table -o ./quota_Anchor_result/01diamond/sb_zm.total.collinearity -m 500 -W 1 -D 25 -I 2 -f 0 -s 0 -t 0 --overwrite -a 1
quota_Anchor ks -i ./quota_Anchor_result/01diamond/sb_zm.total.collinearity -a muscle -p ./quota_Anchor_result/sb.pep,./quota_Anchor_result/zm.pep -d ./quota_Anchor_result/sb.cds,./quota_Anchor_result/zm.cds  -o ./quota_Anchor_result/01diamond/sb_zm.ks -t 16 -add_ks 
quota_Anchor dotplot -i ./quota_Anchor_result/01diamond/sb_zm.total.collinearity -o ./quota_Anchor_result/01diamond/sb_zm.total.ks.png -r ./quota_Anchor_result/sb.length.txt -q ./quota_Anchor_result/zm.length.txt -r_label "Sorghum bicolor" -q_label "Zea mays" --overwrite -ks ./quota_Anchor_result/01diamond/sb_zm.ks
```
