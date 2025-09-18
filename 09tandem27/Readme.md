# gene classification (max proximal distance = 5)

## TD and PD

### TD and PD number stats

#### run quota_Anchor class_gene for 27 grass species

```bash
bash run.class.sh
```

#### merge tandem proximal files(merged.pairs, tandem distance = 5)

```bash
bash merge.tandem.proximal.sh
```

#### Get tandem clusters of 27 species and the genes corresponding to each cluster

```bash
bash run.stats.tandem.sh
```

#### get all tandem genes, len(tandem_cluster) > (13,14,15,16) as a file

```bash
bash get.tandem.sh
```

#### get plot input file (tandem.cluster.number.summary.txt, cluster_number|max_cluster_length|TD&PD gene number)

```bash
python stats.tandem.group.number.27species.py species.txt
```

#### plot TD&PD

```bash
gene_cluster.number.R
specific.length.cluster.number.curve.R
Rscript significant.R
```

### GO for TD and PD

#### interproscan input

```bash
bash get.pre.interproscan.sh
```

#### running interproscan

```bash
bash run.interproscan.sh
```

#### select go column from interproscan result

```bash
bash select.go.column.sh
```

#### get basic go annotation

```bash
bash get.annotation.sh
```

#### go enrichment

```bash
bash sp.27.go.sh
```

#### go dotplot

```bash
bash sp.27.go.dotplot.sh
```

#### poaceae go enrichment and plot(merged)

```bash
find . -type f|grep "go.annotation.txt"|while read f;do cat $f|sed '1d' >> merged.annotation.txt;done
find . -type f|grep "tandem.gene.txt"|while read f;do cat $f >> merged.tandem.txt;done
find . -type f|grep "tandem13.gene.txt"|while read f;do cat $f >> merged.tandem13.txt;done
find . -type f|grep "tandem14.gene.txt"|while read f;do cat $f >> merged.tandem14.txt;done
find . -type f|grep "tandem15.gene.txt"|while read f;do cat $f >> merged.tandem15.txt;done
find . -type f|grep "tandem16.gene.txt"|while read f;do cat $f >> merged.tandem16.txt;done
Rscript poaceae.merged.go.R
```

### GO for WGD

```bash
cd WGD_number_diff_and_curve
```

```bash
WGD_GO_enrichment
```