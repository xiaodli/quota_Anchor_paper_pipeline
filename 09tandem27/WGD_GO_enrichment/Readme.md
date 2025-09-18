# wgd gene go enrichment

## 27 poaceae wgd.genes

```bash
bash get.wgd.gene.sh
find .. -type f|grep "wgd.genes.txt"|while read f;do cat $f >> merged.wgd.txt;done
```

## Get 27 Poaceae species and Joinvillea ascendens Orthogroups(version 2.5.5)

```bash
orthofinder -f 01longest -o final_orthofinder_remove_non_chr_gene -t 117 -M msa -T raxml-ng -a 117
scp lixd@172.16.30.21:my_data/desktop/poaceae_gene_family/pipeline/final_orthofinder_remove_non_chr_gene/Results_Sep15/Orthogroups/Orthogroups.GeneCount.tsv ./ 
scp lixd@172.16.30.21:my_data/desktop/poaceae_gene_family/pipeline/final_orthofinder_remove_non_chr_gene/Results_Sep15/Orthogroups/Orthogroups.tsv ./        
```

## Get Orthogroup size and wgd gene ratio (remove Joinvillea ascendens gene in the stats process)

```bash
sed -i 's/:/_/g' merged.wgd.txt
python read.group_wgd.gene.py Orthogroups.tsv merged.wgd.txt group.stats.txt
python select.group.py Orthogroups.tsv group.stats.txt 90 100000 orthogroup_wgd.gene.txt 40
```

## plot

```bash
poaceae.merged.go.R
```
