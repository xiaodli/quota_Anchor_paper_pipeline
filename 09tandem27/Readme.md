# gene classification (focus on tandem and tandem distance = 5)

## run class_gene for 27 grass species
```
bash run.class.sh
```

## merge tandem proximal files(get tandem distance = 5)
```
bash merge.tandem.proximal.sh
```

## get tandem cluster number for 27 species
```
bash run.stats.tandem.sh
```

## get plot input file
```
python stats.tandem.group.number.27species.py species.txt
```

## plot
```
cluster.number.R
specific.length.cluster.number.curve.R
```
```
Rscript significant.R
```



## GO for tandem

### interproscan input
```
bash get.pre.interproscan.sh
```

### running interproscan
```
bash run.interproscan.sh
```

### get tandem list
```
bash get.tandem.sh
```

### select go column from interproscan result
```
bash select.go.column.sh
```

### get basic go annotation
```
bash get.annotation.sh
```
    
### go enrichment
```
bash sp.27.go.sh
```
### go dotplot
```
bash sp.27.go.dotplot.sh
```

### poaceae go enrichment and plot(merged)
```
find . -type f|grep "go.annotation.txt"|while read f;do cat $f|sed '1d' >> merged.annotation.txt;done
find . -type f|grep "tandem.gene.txt"|while read f;do cat $f >> merged.tandem.txt;done
find . -type f|grep "tandem13.gene.txt"|while read f;do cat $f >> merged.tandem13.txt;done
find . -type f|grep "tandem14.gene.txt"|while read f;do cat $f >> merged.tandem14.txt;done
find . -type f|grep "tandem15.gene.txt"|while read f;do cat $f >> merged.tandem15.txt;done
find . -type f|grep "tandem16.gene.txt"|while read f;do cat $f >> merged.tandem16.txt;done
Rscript poaceae.merged.go.R
```


