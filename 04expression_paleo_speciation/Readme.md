# This is different from 04expression
# seaborn matplotlib scipy and pandas numpy are dependencies

## correlation coefficient
```
cp ../03distance/collinearity/raw_data/sb2_zm1.collinearity .
cp ../03distance/collinearity/raw_data/zgc1_sb3.collinearity .
cp ../03distance/collinearity/raw_data/zgc2_zm3.collinearity .

cp ../03distance/collinearity/raw_data/sb_zm.total.collinearity .
cp ../03distance/collinearity/raw_data/zgc_sb.total.collinearity .
cp ../03distance/collinearity/raw_data/zgc_zm.total.collinearity .

cp ../03distance/collinearity/raw_data/sb_zm.table .
cp ../03distance/collinearity/raw_data/zgc_sb.table .
cp ../03distance/collinearity/raw_data/zgc_zm.table .
```
```
bash run.sh
python merge_csv_add_species_pairs_and_root_shoot.py
```
## plot boxplot (3 * 6 facet)
```
final_plot.R
```
