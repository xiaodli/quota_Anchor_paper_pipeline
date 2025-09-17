# Get adjacent gene pairs distance(rank distance)

```text
max(abs(query_gene1_rank-query_gene2_rank), abs(ref_gene1_rank - ref_gene2_rank))
```

## get 30 species pairs from 27 species

```bash
python get_30_species_paris_from_27_species.py ../05sequence/01pipeline_raw_data
```

## collinearity

```bash
cd collinearity
bash run.sh
cd ..
```

## distance

```bash
ls collinearity/|grep -v "total"|grep "collinearity"|grep -v "png"|sed s/.collinearity//g|awk '{printf "%s ", $1}'
bash run1.sh
python stats_200_0_10_20.py distance.txt distance.R.txt
Rscript ./distance_stack_bar.R
```
