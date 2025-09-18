# quota_Anchor and DupGen_finder pipeline

## quota_Anchor

### prepare maize data

```bash
cp /media/dell/E/Suppmentary_data/03distance/collinearity/raw_data/zm.cds .
cp /media/dell/E/Suppmentary_data/03distance/collinearity/raw_data/zm.gff3 .
cp /media/dell/E/Suppmentary_data/03distance/collinearity/raw_data/zm.length.txt .
cp /media/dell/E/Suppmentary_data/03distance/collinearity/raw_data/zm.pep .
```

### maize self vs self(quota_Anchor)

```bash
quota_Anchor pre_col -a blastp -rs zm.pep -qs zm.pep -db maize.database.blastp -mts 5 -e 1e-10 -b maize.maize.blast -rg zm.gff3 -qg zm.gff3 -o zm_zm.table -bs 100 -al 0 -rl zm.length.txt -ql zm.length.txt --overwrite
quota_Anchor col -i zm_zm.table -o zm_zm.collinearity -s 0 -m 500 -W 5 -E -0.005 -D 25 -a 1 --overwrite
```

### banana B

```bash
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/004/837/865/GCA_004837865.1_BananaB_V1/GCA_004837865.1_BananaB_V1_genomic.gff.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/004/837/865/GCA_004837865.1_BananaB_V1/GCA_004837865.1_BananaB_V1_genomic.fna.gz
gunzip *gz
mv GCA_004837865.1_BananaB_V1_genomic.fna banana.B.fa
mv GCA_004837865.1_BananaB_V1_genomic.gff banana.B.gff
```

### maize vs banana.B

```bash
quota_Anchor longest_pep -f banana.B.fa -g banana.B.gff -p B.p.pep -l banana.B.pep -t 1 --overwrite
quota_Anchor get_chr_length -f banana.B.fa.fai -g banana.B.gff -s CM01 -o banana.B.length.txt --overwrite
quota_Anchor pre_col -a diamond -rs banana.B.pep -qs zm.pep -db banana.B.database.diamond -mts 20 -e 1e-10 -b banana.B.maize.diamond -rg banana.B.gff -qg zm.gff3 -o bananaB_zm.table -bs 100 -al 0 -rl banana.B.length.txt -ql zm.length.txt --overwrite
quota_Anchor col -i bananaB_zm.table -o bananaB_zm.collinearity -s 0 --overwrite -D 25 -a 1
```

### class_gene

```bash
quota_Anchor class_gene -b maize.maize.blast -g zm.gff3 -q zm_zm.collinearity -qr bananaB_zm.collinearity -o maize_classify_dir -p maize -s 1 -d 10 --overwrite -u
quota_Anchor class_gene -b maize.maize.blast -g zm.gff3 -q zm_zm.collinearity -qr bananaB_zm.collinearity -o maize_classify_dir -p maize -s 1 -d 10 --overwrite
```

## DupGen_finder

### prepare data

```bash
mkdir -p input
cp banana.B.maize.diamond ./input
cp maize.maize.blast ./input
cp banana.B.gff ./input
cp zm.gff3 ./input
```

### data format

```bash
cd input
mv banana.B.maize.diamond zm_ba.blast
mv maize.maize.blast zm.blast
mv banana.B.gff ba.gff
mv zm.gff3 zm.gff

awk '$3 == "gene" {print $1, $4, $5, $9}' ba.gff| awk -F "ID=" '{print $1. $2}'|awk -F ";Name=" '{print $1}'|awk -v OFS="\t" '{print $1, $4, $2, $3}'|sed s/^/ba-/g> ba.dup.gff
awk '$3 == "gene" {print $1, $4, $5, $9}' zm.gff|awk -F "ID=" '{print $1, $2}'|awk -F ";biotype" '{print $1}'|awk -F ";Name=" '{print $1}'|awk -v OFS="\t" '{print $1, $4, $2, $3}'|sed s/^/zm-/g> zm.dup.gff
mv zm.dup.gff zm.gff
mv ba.dup.gff zm_ba.gff
cat zm.gff >> zm_ba.gff
rm ba.gff
cd ..
```

## Run DupGen_finder

```bash
DupGen_finder-unique.pl -i input -t zm -c ba -o output -a 1
DupGen_finder.pl -i input -t zm -c ba -o output -a 1
```

## dispersed difference due to proximal difference

```bash
python somedot.py
```

## number stats

```bahs
python diff.py maize_classify_dir/maize-unique.stats output diff.txt
plot.R
```

## singleton

```bash
python find.non.coding.py zm.gff3 non_coding.txt
```

## singleton vis

```bash
venn.R
```

## DupGen_finder false positive example

```bash
python false.positive.number.py ./output/zm.dispersed.pairs ./zm.gff3 false.positive.txt
specific.distance.number.curve.R
```

## wgd gene pairs difference (MCScanX vs quota_Anchor)

```bash
mkdir -p wgd_comparison
cd wgd_comparison
```

### quota_Anchor_

```bash
quota_Anchor pre_col -a diamond -rs ../zm.pep -qs ../zm.pep -db maize.database.blastp -mts 50 -e 1e-5 -b maize.maize.blast -rg ../zm.gff3 -qg ../zm.gff3 -o zm_zm.table -bs 100 -al 0 -rl ../zm.length.txt -ql ../zm.length.txt --overwrite
quota_Anchor col -i zm_zm.table -o zm_zm.collinearity -s 0 -m 500 -W 0 -E -0.005 -D 25 -a 1 --overwrite -I 3.5
```

### MCScanX

```bash
mkdir -p MCScanX
cd MCScanX
cp ../maize.maize.blast .
mv maize.maize.blast zm_zm.blast
cp ../../input/zm.gff .
./MCScanX zm_zm
cd ..
```

### WGDI

```bash
mkdir -p WGDI
cd WGDI
cp ../../../02JCVI_WGDI_SOI_quota_Anchor/WGDI_result/zm.final.gff3 .
cp ../../../02JCVI_WGDI_SOI_quota_Anchor/WGDI_result/zm.lens .
wgdi -icl icl.conf
cd ..
```

```bash
python parse.wgdi.py ./WGDI/zm_zm.collinearity ./WGDI/zm_zm.rm.diagonal.500.collinearity
python difference_quota_Anchor_MCScanX.py ../zm.gff3 ../zm.gff3 ../zm_zm.table zm_zm.collinearity ./MCScanX/zm_zm.collinearity ./difference.quota_Anchor.MCScanX.txt "quota_Anchor" "MCScanX"
python sort.py ./difference.quota_Anchor.MCScanX.txt  "MCScanX" difference.quota_Anchor.MCScanX.sorted.txt "quota_Anchor"

python difference_quota_Anchor_MCScanX.py ../zm.gff3 ../zm.gff3 ../zm_zm.table zm_zm.collinearity ./WGDI/zm_zm.rm.diagonal.500.collinearity ./difference.quota_Anchor.WGDI.txt "quota_Anchor" "WGDI"
python sort.py ./difference.quota_Anchor.WGDI.txt "WGDI" difference.quota_Anchor.WGDI.sorted.txt "quota_Anchor"

python difference_quota_Anchor_MCScanX.py ../zm.gff3 ../zm.gff3 ../zm_zm.table ./WGDI/zm_zm.rm.diagonal.500.collinearity ./MCScanX/zm_zm.collinearity ./difference.WGDI.MCScanX.txt "WGDI" "MCScanX"
python sort.py ./difference.WGDI.MCScanX.txt "MCScanX" ./difference.WGDI.MCScanX.sorted.txt "WGDI"
```

### difference dotplot

```bash
Rscript difference.dotplot.R
```

### bar difference

```bash
cat zm_zm.collinearity|grep -v "#"|awk '{OFS="\t"; print $6, $1}'|sed '1d'> zm_zm.collinearity.quota_Anchor.txt
cat zm_zm.collinearity|grep -v "#"|awk '{OFS="\t"; print $1, $6}'|sed '1d'>> zm_zm.collinearity.quota_Anchor.txt
less zm_zm.collinearity.quota_Anchor.txt|sort|uniq > zm_zm.collinearity.quota_Anchor.two.txt

cat ./WGDI/zm_zm.rm.diagonal.500.collinearity|grep -v "#"|awk '{OFS="\t"; print $1, $3}'> zm_zm.collinearity.WGDI.txt
cat ./WGDI/zm_zm.rm.diagonal.500.collinearity|grep -v "#"|awk '{OFS="\t"; print $3, $1}'>> zm_zm.collinearity.WGDI.txt
less zm_zm.collinearity.WGDI.txt|sort|uniq > zm_zm.collinearity.WGDI.two.txt

cat ./MCScanX/zm_zm.collinearity|grep -v "#"|awk -F "\t" '{OFS="\t"; print $2, $3}'> zm_zm.collinearity.MCScanX.txt
cat ./MCScanX/zm_zm.collinearity|grep -v "#"|awk -F "\t" '{OFS="\t"; print $3, $2}'>> zm_zm.collinearity.MCScanX.txt
less zm_zm.collinearity.MCScanX.txt|sort|uniq > zm_zm.collinearity.MCScanX.two.txt
```

```bash
python get_bar_difference_R.py zm_zm.collinearity.quota_Anchor.two.txt \
                                zm_zm.collinearity.WGDI.two.txt \
                                zm_zm.collinearity.MCScanX.two.txt \
                                bar_difference_R.txt
```

```bash
pie.R
stack_bar.R
```
