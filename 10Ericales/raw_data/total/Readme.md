# Position camellia sinensis's recent wgd relative species divergence

## get longest pep and trios info

```bash
python ./scripts/longest_pipeline.py -i total_raw_data -o output_dir --overwrite
quota_Anchor trios -n "((((do, dl), (cs, (ar, rd))), cc), vv);" -ot ortholog_trios_cs.csv -op species_pairs.csv -t tree.txt --overwrite -k "cs"
```

## get chromosome info

```bash
quota_Anchor get_chr_length -f "$(find ./raw_data/*fai |awk '{printf "%s,", $1}')" -g "$(find ./raw_data/*gff3 |awk '{printf "%s,", $1}')" -s DL,PN,CP,ch,Ch:DL,PN,CP,ch,Ch:DL,PN,CP,ch,Ch:DL,PN,CP,ch,Ch:DL,PN,CP,ch,Ch:DL,PN,CP,ch,Ch:DL,PN,CP,ch,Ch -o "$(find ./raw_data/*gff3 |awk '{printf "%s,", $1}'|sed s/gff3/length\.txt/g)" --overwrite
python ./scripts/ks_pipeline.py -i raw_data -o output_dir -s species_pairs.csv -a diamond -l raw_data
```

## Adjust divergence peaks to the focal species level for comparison in mixed ks-plots(You can learn about the correction principle from [1] and [2])

```bash
quota_Anchor correct -k "./output_dir/02synteny/cs_ar0.ks,./output_dir/02synteny/cs_do0.ks,./output_dir/02synteny/ar_do0.ks,./output_dir/02synteny/cs_dl0.ks,./output_dir/02synteny/ar_dl0.ks,./output_dir/02synteny/cs_cc0.ks,./output_dir/02synteny/ar_cc0.ks,./output_dir/02synteny/cs_vv0.ks,./output_dir/02synteny/ar_vv0.ks,./output_dir/02synteny/cs_rd0.ks,./output_dir/02synteny/rd_do0.ks,./output_dir/02synteny/rd_dl0.ks,./output_dir/02synteny/rd_cc0.ks,./output_dir/02synteny/rd_vv0.ks,./output_dir/02synteny/do_cc0.ks,./output_dir/02synteny/do_vv0.ks,./output_dir/02synteny/dl_cc0.ks,./output_dir/02synteny/dl_vv0.ks,./output_dir/02synteny/cc_vv0.ks" -col "./output_dir/02synteny/cs_ar0.collinearity,./output_dir/02synteny/cs_do0.collinearity,./output_dir/02synteny/ar_do0.collinearity,./output_dir/02synteny/cs_dl0.collinearity,./output_dir/02synteny/ar_dl0.collinearity,./output_dir/02synteny/cs_cc0.collinearity,./output_dir/02synteny/ar_cc0.collinearity,./output_dir/02synteny/cs_vv0.collinearity,./output_dir/02synteny/ar_vv0.collinearity,./output_dir/02synteny/cs_rd0.collinearity,./output_dir/02synteny/rd_do0.collinearity,./output_dir/02synteny/rd_dl0.collinearity,./output_dir/02synteny/rd_cc0.collinearity,./output_dir/02synteny/rd_vv0.collinearity,./output_dir/02synteny/do_cc0.collinearity,./output_dir/02synteny/do_vv0.collinearity,./output_dir/02synteny/dl_cc0.collinearity,./output_dir/02synteny/dl_vv0.collinearity,./output_dir/02synteny/cc_vv0.collinearity" -s species_pairs.csv -t ortholog_trios_cs.csv -kr 0,3 -ot outfile_divergent_peaks.csv --overwrite
```

## focal species(self vs self)

```bash
quota_Anchor pre_col -a diamond -rs ./output_dir/01longest/cs.longest.pep -qs ./output_dir/01longest/cs.longest.pep -db ./cs/cs.database.diamond -mts 20 -e 1e-10 -b ./cs/cs.cs.diamond -rg ./raw_data/cs.gff3 -qg ./raw_data/cs.gff3 -o ./cs/cs_cs.table -bs 100 -al 0 --overwrite -rl ./raw_data/cs.length.txt -ql ./raw_data/cs.length.txt
quota_Anchor dotplot -i ./cs/cs_cs.table -o ./cs/cs.cs.png -r ./raw_data/cs.length.txt -q ./raw_data/cs.length.txt -r_label cs -q_label cs -use_identity --overwrite
quota_Anchor col -i ./cs/cs_cs.table -o ./cs/cs_cs.collinearity -r 6 -q 6 -m 500 -W 1 -D 25 -I 4 -E -0.005 -f 0 --overwrite
quota_Anchor dotplot -i ./cs/cs_cs.collinearity -o ./cs/cs.cs.collinearity.png -r ./raw_data/cs.length.txt -q ./raw_data/cs.length.txt -r_label cs -q_label cs -use_identity --overwrite
quota_Anchor ks -i ./cs/cs_cs.collinearity -a mafft -p ./output_dir/01longest/cs.longest.pep -d ./output_dir/01longest/cs.longest.cds -o ./cs/cs.cs.ks -t 16  --add_ks --debug debug.txt
quota_Anchor dotplot -i ./cs/cs_cs.collinearity -o ./cs/cs.cs.collinearity.ks.png -r ./raw_data/cs.length.txt -q ./raw_data/cs.length.txt -r_label cs -q_label cs --overwrite -ks ./cs/cs.cs.ks
```

## position wgd relative to species speciation events

```bash
quota_Anchor kde -i ./cs/cs_cs.collinearity -r./raw_data/cs.length.txt -q ./raw_data/cs.length.txt -o ./cs/cs.cs.kde.png -k ./cs/cs.cs.ks --overwrite
quota_Anchor kf -i ./cs/cs_cs.collinearity -r./raw_data/cs.length.txt -q ./raw_data/cs.length.txt -o ./cs/cs.cs.kf.png -k ./cs/cs.cs.ks -f cs -components 2 -kr 0,3 --overwrite
quota_Anchor kf -i ./cs/cs_cs.collinearity -r ./raw_data/cs.length.txt -q ./raw_data/cs.length.txt -o ./cs/cs.cs.png -k ./cs/cs.cs.ks -components 2 -f cs -correct_file outfile_divergent_peaks.csv -kr 0,3 --overwrite -latin_names "cs: Camellia sinensis, vv: Vitis vinifera, dl: Diospyros lotus, do: Diospyros oleifera, ar: Actinidia reticulata, rd: Rhododendron delavayi, cc: Coffea canephora" -s "13.5,9"
```

```text
((((Diospyros oleifera,Diospyros lotus),(Camellia sinensis,(Actinidia reticulata,Rhododendron delavayi))),Coffea canephora),Vitis vinifera)
```

```text
Reference:
[1] Sensalari C, Maere S, Lohaus R. ksrates: positioning whole-genome duplications relative to speciation events in KS distributions. Bioinformatics 2022;38:530-532.
[2] https://oup.silverchair-cdn.com/oup/backfile/Content_public/Journal/bioinformatics/38/2/10.1093_bioinformatics_btab602/2/btab602_supplementary_data.pdf?Expires=1744820940&Signature=r3MRM6iNqRUsE7Pj6TjFoN4n2ttwIG1PJ~VaxAfqNab4DyfHZlO4gJY8g8cSLjkoWZpOX~oHgFEopWS~JtaQZdbMCGTDZ1qQIYxZnm8E9O5IuL4dFUW0oVGVvJ5GZ33qW7myGwu0V3hif7w-xCc9Vo7ffet02HP~Fp9gh8O6caYMR~Z5DrqF1gaxs9MC-FVvD3g5nT9GgttXXwkecce8B~0NK7Ain1DAtxQzaetUg6bVo8PWZnEr7aSqgYaWc8DFluRUQrKrFAonK5o-mVv3-XdNF9nKuLVhWlTmFzFhJ0hRAF0i0Z70~r-sIsken1JIaceEFFhg2C4SNwpglJCEXQ__&Key-Pair-Id=APKAIE5G5CRDK6RD3PGA
```
