# gene classification (focus on tandem and tandem distance = 5)

## run class_gene for 27 grass species

```bash
bash run.class.sh
```

## merge tandem proximal files(get tandem distance = 5)

```bash
bash merge.tandem.proximal.sh
```

## get tandem cluster number for 27 species

```bash
bash run.stats.tandem.sh
```

## get plot input file

```bash
python stats.tandem.group.number.27species.py species.txt
```

## plot

```bash
cluster.number.R
specific.length.cluster.number.curve.R
```

```bash
Rscript significant.R
```

## GO for tandem

### interproscan input

```bash
bash get.pre.interproscan.sh
```

### running interproscan

```bash
bash run.interproscan.sh
```

### get tandem list

```bash
bash get.tandem.sh
```

### select go column from interproscan result

```bash
bash select.go.column.sh
```

### get basic go annotation

```bash
bash get.annotation.sh
```

### go enrichment

```bash
bash sp.27.go.sh
```

### go dotplot

```bash
bash sp.27.go.dotplot.sh
```

### poaceae go enrichment and plot(merged)

```bash
find . -type f|grep "go.annotation.txt"|while read f;do cat $f|sed '1d' >> merged.annotation.txt;done
find . -type f|grep "tandem.gene.txt"|while read f;do cat $f >> merged.tandem.txt;done
find . -type f|grep "tandem13.gene.txt"|while read f;do cat $f >> merged.tandem13.txt;done
find . -type f|grep "tandem14.gene.txt"|while read f;do cat $f >> merged.tandem14.txt;done
find . -type f|grep "tandem15.gene.txt"|while read f;do cat $f >> merged.tandem15.txt;done
find . -type f|grep "tandem16.gene.txt"|while read f;do cat $f >> merged.tandem16.txt;done
Rscript poaceae.merged.go.R
```
