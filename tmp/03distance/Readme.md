# Get adjacent gene pairs distance(rank distance)

```text
max(abs(query-query_previous), abs(ref - ref_previous))
```

## get chinese spring wheat genome and gff file according to ../Suppementary_file/genome_info.xlsx

```bash
mkdir -p collinearity/raw_data
cd collinearity/raw_data
mwget -n 16 https://urgi.versailles.inra.fr/download/iwgsc/IWGSC_RefSeq_Assemblies/v2.1/iwgsc_refseqv2.1_assembly.fa.zip
mwget -n 16 https://urgi.versailles.inra.fr/download/iwgsc/IWGSC_RefSeq_Annotations/v2.1/iwgsc_refseqv2.1_gene_annotation_200916.zip
cp ../../../02JCVI_quota_Anchor/quota_Anchor_result/*.* .
cp ../../../02JCVI_quota_Anchor/raw_data/*gff3 .
mwget -n 16 https://ftp.ensemblgenomes.ebi.ac.uk/pub/current/plants/fasta/oryza_sativa/dna/Oryza_sativa.IRGSP-1.0.dna.toplevel.fa.gz -f os.fa.gz
mwget -n 16 https://ftp.ensemblgenomes.ebi.ac.uk/pub/current/plants/gff3/oryza_sativa/Oryza_sativa.IRGSP-1.0.60.chr.gff3.gz -f os.gff3.gz
gunzip *gz
mv ./iwgsc_refseqv2.1_gene_annotation_200916/iwgsc_refseqv2.1_annotation_200916_HC.gff3 ./zgc.gff3
mv iwgsc_refseqv2.1_assembly.fa zgc.fa
```

## collinearity

```bash
quota_Anchor longest_pep -f ./zgc.fa,./os.fa  -g ./zgc.gff3,./os.gff3  -p zgc.raw.pep,os.raw.pep -l zgc.pep,os.pep -t 2 --overwrite
quota_Anchor longest_cds -f ./zgc.fa,./os.fa -g ./zgc.gff3,./os.gff3  -p zgc.raw.cds,os.raw.cds -l zgc.cds,os.cds -t 2 --overwrite
quota_Anchor get_chr_length -f zgc.fa.fai,os.fa.fai -g zgc.gff3,os.gff3 -s "Chr:[0-9]" -o zgc.length.txt,os.length.txt --overwrite
sed -i '23d' zgc.length.txt
bash run.sh
cd ../..
```

## distance

```bash
bash run1.sh
python stats_200_0_10_20.py distance.txt distance.R.txt
Rscript ./distance_stack_bar.R
```
