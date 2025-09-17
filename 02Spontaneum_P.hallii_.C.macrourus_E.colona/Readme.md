# Cenchrus.macrourus Setaria.italica Echinochloa.colona vs Saccharum.spontaneum (reference)

## quota_Anchor result

```bash
mkdir -p quota_Anchor_result
cd quota_Anchor_result
bash run.sh
cat Saccharum.spontaneum1_Panicum.hallii4.collinearity|grep -v "#"|awk '{OFS="\t"; print $6, $1}'|sed '1d'> Saccharum.spontaneum_Panicum.hallii.collinearity.txt
cat Saccharum.spontaneum2_Cenchrus.macrourus4.collinearity|grep -v "#"|awk '{OFS="\t"; print $6, $1}'|sed '1d'> Saccharum.spontaneum_Cenchrus.macrourus.collinearity.txt
cat Saccharum.spontaneum3_Echinochloa.colona4.collinearity|grep -v "#"|awk '{OFS="\t"; print $6, $1}'|sed '1d'> Saccharum.spontaneum_Echinochloa.colona.collinearity.txt
cd ..
```

## JCVI  default (1.4.25 lastal, cds)

```bash
mkdir -p JCVI_result
cd JCVI_result
python -m jcvi.formats.gff bed /media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data/Saccharum.spontaneum.gff3 -o Saccharum.bed
python -m jcvi.formats.gff bed /media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data/Cenchrus.macrourus.gff3 -o Cenchrus.bed
python -m jcvi.formats.gff bed /media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data/Panicum.hallii.gff3 -o Panicum.bed
python -m jcvi.formats.gff bed /media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data/Echinochloa.colona.gff3 -o Echinochloa.bed
sed -i '/^ptg/d' Echinochloa.bed
sed -i '/^GWHBWDX00000015.1/d' Cenchrus.bed
sed -i '/^GWHBWDX00000018.1/d' Cenchrus.bed
sed -i '/^GWHBWDX00000019.1/d' Cenchrus.bed
sed -i '/^GWHBWDX00000020.1/d' Cenchrus.bed
sed -i '/^GWHBWDX00000021.1/d' Cenchrus.bed
sed -i '/^GWHBWDX00000022.1/d' Cenchrus.bed
sed -i '/^GWHBWDX00000023.1/d' Cenchrus.bed
sed -i '/^GWHBWDX00000024.1/d' Cenchrus.bed
sed -i '/^GWHBWDX00000026.1/d' Cenchrus.bed
sed -i '/^GWHBWDX00000083.1/d' Cenchrus.bed

cp /media/dell/E/Suppmentary_data/05sequence/02longest/Saccharum.spontaneum.pep .
cp /media/dell/E/Suppmentary_data/05sequence/02longest/Cenchrus.macrourus.pep .
cp /media/dell/E/Suppmentary_data/05sequence/02longest/Panicum.hallii.pep .
cp /media/dell/E/Suppmentary_data/05sequence/02longest/Echinochloa.colona.pep .

mv Saccharum.spontaneum.pep Saccharum.pep
mv Cenchrus.macrourus.pep Cenchrus.pep
mv Panicum.hallii.pep Panicum.pep
mv Echinochloa.colona.pep Echinochloa.pep

python -m jcvi.compara.catalog ortholog Cenchrus Saccharum --notex --dbtype prot --align_soft diamond_blastp
python -m jcvi.compara.catalog ortholog Panicum Saccharum --notex --dbtype prot --align_soft diamond_blastp
python -m jcvi.compara.catalog ortholog Echinochloa Saccharum --notex --dbtype prot --align_soft diamond_blastp

python -m jcvi.compara.quota Cenchrus.Saccharum.anchors --qbed Cenchrus.bed --sbed Saccharum.bed --quota 2:4 --screen
python -m jcvi.compara.quota Panicum.Saccharum.anchors --qbed Panicum.bed --sbed Saccharum.bed --quota 1:4 --screen
python -m jcvi.compara.quota Echinochloa.Saccharum.anchors --qbed Echinochloa.bed --sbed Saccharum.bed --quota 3:4 --screen

python -m jcvi.graphics.dotplot --notex Cenchrus.Saccharum.2x4.anchors
python -m jcvi.graphics.dotplot --notex Panicum.Saccharum.1x4.anchors
python -m jcvi.graphics.dotplot --notex Echinochloa.Saccharum.3x4.anchors

cat Cenchrus.Saccharum.2x4.anchors|grep -v "#"|awk '{OFS="\t"; print $1, $2}'>Cenchrus.Saccharum.2x4.anchors.txt
cat Panicum.Saccharum.1x4.anchors|grep -v "#"|awk '{OFS="\t"; print $1, $2}'>Panicum.Saccharum.1x4.anchors.txt
cat Echinochloa.Saccharum.3x4.anchors|grep -v "#"|awk '{OFS="\t"; print $1, $2}'>Echinochloa.Saccharum.3x4.anchors.txt

cd ..
```

## WGDI 0.74

```bash
Note: (Here we only focus on the 2:1 alignment depth, so we do not further construct a subgenome tree for subgenome phasing.)
```

```bash
mkdir -p WGDI_result
cd WGDI_result

cp /media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data/Saccharum.spontaneum.gff3 .
cp /media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data/Cenchrus.macrourus.gff3 .
cp /media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data/Panicum.hallii.gff3 .
cp /media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data/Echinochloa.colona.gff3 .

python 01.py Saccharum.spontaneum.gff3 Saccharum.spontaneum.new.gff3
python 01.py Cenchrus.macrourus.gff3 Cenchrus.macrourus.new.gff3
python 01.py Panicum.hallii.gff3 Panicum.hallii.new.gff3
python 01.py Echinochloa.colona.gff3 Echinochloa.colona.new.gff3

sed -i '/^ptg/d' Echinochloa.colona.new.gff3
sed -i '/^GWHBWDX00000015.1/d' Cenchrus.macrourus.new.gff3
sed -i '/^GWHBWDX00000018.1/d' Cenchrus.macrourus.new.gff3
sed -i '/^GWHBWDX00000019.1/d' Cenchrus.macrourus.new.gff3
sed -i '/^GWHBWDX00000020.1/d' Cenchrus.macrourus.new.gff3
sed -i '/^GWHBWDX00000021.1/d' Cenchrus.macrourus.new.gff3
sed -i '/^GWHBWDX00000022.1/d' Cenchrus.macrourus.new.gff3
sed -i '/^GWHBWDX00000023.1/d' Cenchrus.macrourus.new.gff3
sed -i '/^GWHBWDX00000024.1/d' Cenchrus.macrourus.new.gff3
sed -i '/^GWHBWDX00000026.1/d' Cenchrus.macrourus.new.gff3
sed -i '/^GWHBWDX00000083.1/d' Cenchrus.macrourus.new.gff3
python 02.py Saccharum.spontaneum.new.gff3 Saccharum.spontaneum.final.gff3 Saccharum.spontaneum.lens
python 02.py Cenchrus.macrourus.new.gff3 Cenchrus.macrourus.final.gff3 Cenchrus.macrourus.lens
python 02.py Panicum.hallii.new.gff3 Panicum.hallii.final.gff3 Panicum.hallii.lens
python 02.py Echinochloa.colona.new.gff3 Echinochloa.colona.final.gff3 Echinochloa.colona.lens

cp /media/dell/E/Suppmentary_data/05sequence/02longest/Saccharum.spontaneum.pep .
cp /media/dell/E/Suppmentary_data/05sequence/02longest/Cenchrus.macrourus.pep .
cp /media/dell/E/Suppmentary_data/05sequence/02longest/Panicum.hallii.pep .
cp /media/dell/E/Suppmentary_data/05sequence/02longest/Echinochloa.colona.pep .
cp /media/dell/E/Suppmentary_data/05sequence/02longest/Saccharum.spontaneum.cds .
cp /media/dell/E/Suppmentary_data/05sequence/02longest/Cenchrus.macrourus.cds .
cp /media/dell/E/Suppmentary_data/05sequence/02longest/Panicum.hallii.cds .
cp /media/dell/E/Suppmentary_data/05sequence/02longest/Echinochloa.colona.cds .

cp ../quota_Anchor_result/Saccharum.spontaneum_Cenchrus.macrourus.blastp ../quota_Anchor_result/Saccharum.spontaneum_Echinochloa.colona.blastp ../quota_Anchor_result/Saccharum.spontaneum_Panicum.hallii.blastp .
```

### WGDI Saccharum.spontaneum vs Panicum.hallii

```bash
mkdir -p Saccharum.spontaneum_Panicum.hallii
cd Saccharum.spontaneum_Panicum.hallii
cat ../Panicum.hallii.cds ../Saccharum.spontaneum.cds > total.cds
cat ../Panicum.hallii.pep ../Saccharum.spontaneum.pep > total.pep
awk '{OFS="\t";print $1,$2,$3,$4,$6,$7}' ../../quota_Anchor_result/Saccharum.spontaneum_Panicum.hallii.collinearity.ks > Saccharum.spontaneum_Panicum.hallii.collinearity.ks 

wgdi -icl icl.conf
wgdi -ks ks.conf
wgdi -bi blockinfo.conf
wgdi -c corr.conf
wgdi -bk bk.conf
wgdi -km km.conf
```

```bash
wgdi -pc pc.conf
wgdi -a alignment.conf
cat Saccharum.spontaneum_Panicum.hallii.collinearity.ks.correspondence.pc.alignment.csv|awk -F "," '{OFS="\t"; print $2, $1}'|sort|sed '/^\./d'|sort|awk 'NF>1 {print $0}' > Saccharum.spontaneum_Panicum.hallii.collinearity.ks.correspondence.pc.alignment.1.txt
cat Saccharum.spontaneum_Panicum.hallii.collinearity.ks.correspondence.pc.alignment.csv|awk -F "," '{OFS="\t"; print $3, $1}'|sort|sed '/^\./d'|sort|awk 'NF>1 {print $0}' > Saccharum.spontaneum_Panicum.hallii.collinearity.ks.correspondence.pc.alignment.2.txt
cat Saccharum.spontaneum_Panicum.hallii.collinearity.ks.correspondence.pc.alignment.csv|awk -F "," '{OFS="\t"; print $4, $1}'|sort|sed '/^\./d'|sort|awk 'NF>1 {print $0}' > Saccharum.spontaneum_Panicum.hallii.collinearity.ks.correspondence.pc.alignment.3.txt
cat Saccharum.spontaneum_Panicum.hallii.collinearity.ks.correspondence.pc.alignment.csv|awk -F "," '{OFS="\t"; print $5, $1}'|sort|sed '/^\./d'|sort|awk 'NF>1 {print $0}' > Saccharum.spontaneum_Panicum.hallii.collinearity.ks.correspondence.pc.alignment.4.txt
cat Saccharum.spontaneum_Panicum.hallii.collinearity.ks.correspondence.pc.alignment.1.txt Saccharum.spontaneum_Panicum.hallii.collinearity.ks.correspondence.pc.alignment.2.txt Saccharum.spontaneum_Panicum.hallii.collinearity.ks.correspondence.pc.alignment.3.txt Saccharum.spontaneum_Panicum.hallii.collinearity.ks.correspondence.pc.alignment.4.txt > Saccharum.spontaneum_Panicum.hallii.collinearity.ks.correspondence.pc.alignment.txt
cd ..
```

### WGDI Saccharum.spontaneum vs Cenchrus.macrourus

```bash
mkdir -p Saccharum.spontaneum_Cenchrus.macrourus
cd Saccharum.spontaneum_Cenchrus.macrourus
cat ../Cenchrus.macrourus.cds ../Saccharum.spontaneum.cds > total.cds
cat ../Cenchrus.macrourus.pep ../Saccharum.spontaneum.pep > total.pep
awk '{OFS="\t";print $1,$2,$3,$4,$6,$7}' ../../quota_Anchor_result/Saccharum.spontaneum_Cenchrus.macrourus.collinearity.ks > Saccharum.spontaneum_Cenchrus.macrourus.collinearity.ks 
```

```bash
wgdi -icl icl.conf
wgdi -ks ks.conf
wgdi -bi blockinfo.conf
wgdi -c corr.conf
wgdi -bk bk.conf
cd ..
python parse.block.info.py ./Saccharum.spontaneum_Cenchrus.macrourus/Saccharum.spontaneum_Cenchrus.macrourus.collinearity.ks.correspondence.csv Cenchrus.macrourus.final.gff3 Saccharum.spontaneum.final.gff3 ./Saccharum.spontaneum_Cenchrus.macrourus/Saccharum.spontaneum_Cenchrus.macrourus.collinearity.txt
```

### WGDI Saccharum.spontaneum vs Echinochloa.colona

```bash
mkdir -p Saccharum.spontaneum_Echinochloa.colona
cd Saccharum.spontaneum_Echinochloa.colona
cat ../Echinochloa.colona.cds ../Saccharum.spontaneum.cds > total.cds
cat ../Echinochloa.colona.pep ../Saccharum.spontaneum.pep > total.pep
awk '{OFS="\t";print $1,$2,$3,$4,$6,$7}' ../../quota_Anchor_result/Saccharum.spontaneum_Echinochloa.colona.collinearity.ks > Saccharum.spontaneum_Echinochloa.colona.collinearity.ks 
```

```bash
wgdi -icl icl.conf
wgdi -ks ks.conf
wgdi -bi blockinfo.conf
wgdi -c corr.conf
wgdi -bk bk.conf
cd ..
python parse.block.info.py ./Saccharum.spontaneum_Echinochloa.colona/Saccharum.spontaneum_Echinochloa.colona.collinearity.ks.correspondence.csv Echinochloa.colona.final.gff3 Saccharum.spontaneum.final.gff3 ./Saccharum.spontaneum_Echinochloa.colona/Saccharum.spontaneum_Echinochloa.colona.collinearity.txt
cd ..
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
mkdir -p orthofinder_Panicum
cp ../WGDI_result/Saccharum.spontaneum.pep ../WGDI_result/Panicum.hallii.pep ./orthofinder_Panicum
orthofinder -f orthofinder_Panicum -M msa -t 14 -a 4

mkdir -p orthofinder_Cenchrus
cp ../WGDI_result/Saccharum.spontaneum.pep ../WGDI_result/Cenchrus.macrourus.pep ./orthofinder_Cenchrus
orthofinder -f orthofinder_Cenchrus -M msa -t 7 -a 2

mkdir -p orthofinder_Echinochloa
cp ../WGDI_result/Saccharum.spontaneum.pep ../WGDI_result/Echinochloa.colona.pep ./orthofinder_Echinochloa
orthofinder -f orthofinder_Echinochloa -M msa -t 7 -a 2

cd ..
```

### Run MCScanX (1.0.0)

```bash
cd orthofinder_Panicum
mkdir -p MCScanX
cd MCScanX
cp ../../../WGDI_result/Panicum.hallii.final.gff3 ../../../WGDI_result/Saccharum.spontaneum.final.gff3 .
sed -i s/^/ph/g Panicum.hallii.final.gff3
sed -i s/^/ss/g Saccharum.spontaneum.final.gff3
awk '{print $1, $2, $3, $4}' Panicum.hallii.final.gff3 > ph.gff
awk '{print $1, $2, $3, $4}' Saccharum.spontaneum.final.gff3 > ss.gff
sed -i 's/gene://g' ph.gff
sed -i 's/gene://g' ss.gff
cat ph.gff ss.gff > ss_ph.gff
sed -i 's/ /\t/g' ss_ph.gff
cp ../../../WGDI_result/Saccharum.spontaneum_Panicum.hallii.blastp .
sed -i 's/gene://g' Saccharum.spontaneum_Panicum.hallii.blastp
mv Saccharum.spontaneum_Panicum.hallii.blastp ss_ph.blast
../../../../02JCVI_WGDI_SOI_quota_Anchor/SOI_result/OrthoFinder_MCScanX/MCScanX ss_ph
cd ../..
```

```bash
cd orthofinder_Cenchrus
mkdir -p MCScanX
cd MCScanX
cp ../../../WGDI_result/Cenchrus.macrourus.final.gff3 ../../../WGDI_result/Saccharum.spontaneum.final.gff3 .
sed -i s/^/cm/g Cenchrus.macrourus.final.gff3
sed -i s/^/ss/g Saccharum.spontaneum.final.gff3
awk '{print $1, $2, $3, $4}' Cenchrus.macrourus.final.gff3 > cm.gff
awk '{print $1, $2, $3, $4}' Saccharum.spontaneum.final.gff3 > ss.gff
sed -i 's/gene://g' ss.gff
cat cm.gff ss.gff > ss_cm.gff
sed -i 's/ /\t/g' ss_cm.gff
cp ../../../WGDI_result/Saccharum.spontaneum_Cenchrus.macrourus.blastp .
sed -i 's/gene://g' Saccharum.spontaneum_Cenchrus.macrourus.blastp
mv Saccharum.spontaneum_Cenchrus.macrourus.blastp ss_cm.blast
../../../../02JCVI_WGDI_SOI_quota_Anchor/SOI_result/OrthoFinder_MCScanX/MCScanX ss_cm
cd ../..
```

```bash
cd orthofinder_Echinochloa
mkdir -p MCScanX
cd MCScanX
cp ../../../WGDI_result/Echinochloa.colona.final.gff3 ../../../WGDI_result/Saccharum.spontaneum.final.gff3 .
sed -i s/^/ec/g Echinochloa.colona.final.gff3
sed -i s/^/ss/g Saccharum.spontaneum.final.gff3
awk '{print $1, $2, $3, $4}' Echinochloa.colona.final.gff3 > ec.gff
awk '{print $1, $2, $3, $4}' Saccharum.spontaneum.final.gff3 > ss.gff
sed -i 's/gene://g' ss.gff
cat ec.gff ss.gff > ss_ec.gff
sed -i 's/ /\t/g' ss_ec.gff
cp ../../../WGDI_result/Saccharum.spontaneum_Echinochloa.colona.blastp .
sed -i 's/gene://g' Saccharum.spontaneum_Echinochloa.colona.blastp
mv Saccharum.spontaneum_Echinochloa.colona.blastp ss_ec.blast
../../../../02JCVI_WGDI_SOI_quota_Anchor/SOI_result/OrthoFinder_MCScanX/MCScanX ss_ec
cd ../..
```

### SOI (OrthoFinder + MCScanX)

```bash
cd orthofinder_Panicum
sed -i 's/Sspon/gene_Sspon/g' MCScanX/ss_ph.gff
sed -i 's/Sspon/gene_Sspon/g' MCScanX/ss_ph.collinearity
sed -i 's/PAHAL/gene_PAHAL/g' MCScanX/ss_ph.gff
sed -i 's/PAHAL/gene_PAHAL/g' MCScanX/ss_ph.collinearity
soi dotplot -s MCScanX/ss_ph.collinearity \
        -g MCScanX/ss_ph.gff -c ss_ph.ctl  \
        --xlabel 'Saccharum.spontaneum' --ylabel 'Panicum.hallii' \
        --ks-hist -o ss_ph.raw.io    \
        --plot-ploidy --gene-axis --number-plots \
        --ofdir ./OrthoFinder/Results_Sep09/ --of-color
soi filter -s MCScanX/ss_ph.collinearity -o ./OrthoFinder/Results_Sep09/ -c 0.49 > ss_ph.collinearity.ortho
soi dotplot -s ss_ph.collinearity.ortho \
        -g MCScanX/ss_ph.gff -c ss_ph.ctl  \
        --xlabel 'Saccharum.spontaneum' --ylabel 'Panicum.hallii' \
        --ks-hist -o ss_ph.io    \
        --plot-ploidy --gene-axis --number-plots \
        --ofdir ./OrthoFinder/Results_Sep09/ --of-color
cat ss_ph.collinearity.ortho|grep -v "#"|awk -F "\t" '{OFS="\t"; print $3, $2}'> ss_ph.collinearity.ortho.txt
sed -i 's/gene_/gene:/g' ss_ph.collinearity.ortho.txt
cd ..
```

```bash
cd orthofinder_Cenchrus/
sed -i 's/Sspon/gene_Sspon/g' MCScanX/ss_cm.gff
sed -i 's/Sspon/gene_Sspon/g' MCScanX/ss_cm.collinearity
soi dotplot -s MCScanX/ss_cm.collinearity \
        -g MCScanX/ss_cm.gff -c ss_cm.ctl  \
        --xlabel 'Saccharum.spontaneum' --ylabel 'Cenchrus.macrourus' \
        --ks-hist -o ss_cm.raw.io    \
        --plot-ploidy --gene-axis --number-plots \
        --ofdir ./OrthoFinder/Results_Sep09/ --of-color
soi filter -s MCScanX/ss_cm.collinearity -o ./OrthoFinder/Results_Sep09/ -c 0.35 > ss_cm.collinearity.ortho
soi dotplot -s ss_cm.collinearity.ortho \
        -g MCScanX/ss_cm.gff -c ss_cm.ctl  \
        --xlabel 'Saccharum.spontaneum' --ylabel 'Cenchrus.macrourus' \
        --ks-hist -o ss_cm.io    \
        --plot-ploidy --gene-axis --number-plots \
        --ofdir ./OrthoFinder/Results_Sep09/ --of-color
cat ss_cm.collinearity.ortho|grep -v "#"|awk -F "\t" '{OFS="\t"; print $3, $2}'> ss_cm.collinearity.ortho.txt
sed -i 's/gene_/gene:/g' ss_cm.collinearity.ortho.txt
cd ..
```

```bash
cd orthofinder_Echinochloa/
sed -i 's/Sspon/gene_Sspon/g' MCScanX/ss_ec.gff
sed -i 's/Sspon/gene_Sspon/g' MCScanX/ss_ec.collinearity
soi dotplot -s MCScanX/ss_ec.collinearity \
        -g MCScanX/ss_ec.gff -c ss_ec.ctl  \
        --xlabel 'Saccharum.spontaneum' --ylabel 'Echinochloa.colona' \
        --ks-hist -o ss_ec.raw.io    \
        --plot-ploidy --gene-axis --number-plots \
        --ofdir ./OrthoFinder/Results_Sep09/ --of-color
soi filter -s MCScanX/ss_ec.collinearity -o ./OrthoFinder/Results_Sep09/ -c 0.31 > ss_ec.collinearity.ortho
soi dotplot -s ss_ec.collinearity.ortho \
        -g MCScanX/ss_ec.gff -c ss_ec.ctl  \
        --xlabel 'Saccharum.spontaneum' --ylabel 'Echinochloa.colona' \
        --ks-hist -o ss_ec.io    \
        --plot-ploidy --gene-axis --number-plots \
        --ofdir ./OrthoFinder/Results_Sep09/ --of-color
cat ss_ec.collinearity.ortho|grep -v "#"|awk -F "\t" '{OFS="\t"; print $3, $2}'> ss_ec.collinearity.ortho.txt
sed -i 's/gene_/gene:/g' ss_ec.collinearity.ortho.txt
cd ..
```
