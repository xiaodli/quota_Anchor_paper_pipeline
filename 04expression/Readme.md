# seaborn matplotlib scipy and pandas are dependencies

## correlation coefficient

```bash
cp ../03distance/collinearity/raw_data/sb2_zm1.collinearity .
cp ../03distance/collinearity/raw_data/zgc1_sb3.collinearity .
cp ../03distance/collinearity/raw_data/zgc2_zm3.collinearity .
bash run.sh
python merge_csv_add_species_pairs_and_root_shoot.py
```

## plot boxplot (3 * 6 facet)

```bash
final_plot.R
```
