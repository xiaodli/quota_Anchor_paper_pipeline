# seaborn matplotlib scipy and pandas numpy biopython alive_progress are dependencies

## get longest pep and cds (27 + Joinvillea.ascendens)

```text
Please delete the non-chromosomal information in the gff file and genome file
```

```bash
find ./01pipeline_raw_data/*gff3|awk '{printf "%s,", $1}'|sed s/gff3/raw.pep/g
find ./01pipeline_raw_data/*fa |awk '{printf "%s,", $1}'
find ./01pipeline_raw_data/*gff3|awk '{printf "%s,", $1}'
find ./01pipeline_raw_data/*gff3|awk '{printf "%s,", $1}' |awk '{printf "%s,", $1}'| sed s/01pipeline_raw_data/02longest/g |sed s/gff3/pep/g
bash get.longest.sh
```

## get collinearity and ks file

```bash
cd 01pipeline_raw_data
sed  -i '8,$d' Aegilops.searsii.fa.fai
sed  -i '15,$d' Cenchrus.macrourus.fa.fai
sed  -i '11,$d' Coix.lacryma.jobi.fa.fai
sed  -i '8,$d' Hordeum.marinum.fa.fai
sed  -i '20,$d' Miscanthus.lutarioriparius.fa.fai
sed  -i '8,$d' Thinopyrum.elongatum.fa.fai
sed  -i '8,$d' Triticum.monococcum.fa.fai
sed  -i '18,$d' Zizania.latifolia.fa.fai
quota_Anchor get_chr_length -f "$(find ./*fai |awk '{printf "%s,", $1}')" -g "$(find ./*gff3 |awk '{printf "%s,", $1}')" -s "GWH:GWH:chr:[0-9]:[0-9]:Bt:GWH:[0-9]:GWH:DL,EL,FL:[0-9]:GWH:Chr:[0-9]:NC:CAJ:[0-9]:[0-9]:Pa:[0-9]:[0-9]:I,V:[0-9]:[0-9]:GWH:GWH:[0-9]:GWH" -o "$(find ./*gff3 |awk '{printf "%s,", $1}'|sed s/gff3/length\.txt/g)" --overwrite
cd ..
```

```bash
bash get.col.ks.sh
```

## KaKscalculator

```bash
cd ./02ucalculator
bash get.calculator.ks.sh
```

## SSD SID number

```bash
bash final.total.SSDSIDnumber.sh
```

## split same and inv

```bash
bash final.total.sh
```

## plot 27 boxplot

```bash
mkdir -p ./03kaksomega27/ka
mkdir -p ./03kaksomega27/ks
mkdir -p ./03kaksomega27/omega
python ./03kaksomega27/search27csv_add_species.py
./03kaksomega27/final27_plot.R
```

## plot 27 curve

```bash
mkdir -p ./03kaksomega27curve/ka_curve
mkdir -p ./03kaksomega27curve/ks_curve
mkdir -p ./03kaksomega27curve/omega_curve
python ./03kaksomega27curve/search27csv_get_median_std_average.py
./03kaksomega27curve/final27_curve_plot.R
```

## speciation paleo ssd sid number

```bash
bash get.col.total.sh
bash speciation.paleo.ssdsid.sh
distance_stack_bar.R
```
