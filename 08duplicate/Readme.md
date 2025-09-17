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
