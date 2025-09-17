# ks_fitting

## raw_data directory and tree topology

```tetx
├── A.elata.fa
├── A.elata.gff3
├── C.asiatica.fa
├── C.asiatica.gff3
├── D.carota.fa
├── D.carota.gff3
├── E.breviscapus.fa
├── E.breviscapus.gff3
├── E.senticosus.fa
├── E.senticosus.gff3
├── N.incisum.fa
├── N.incisum.gff3
├── P.notoginseng.fa
├── P.notoginseng.gff3
├── V.vinifera.fa
└── V.vinifera.length.txt

            /-C.asiatica
         /-|
        |  |   /-N.incisum
        |   \-|
      /-|      \-D.carota
     |  |
     |  |      /-A.elata
     |  |   /-|
   /-|   \-|   \-P.notoginseng
  |  |     |
  |  |      \-E.senticosus
--|  |
  |   \-E.breviscapus
  |
   \-V.vinifera
```

## get longest pep

```bash
python ./scripts/longest_pipeline.py -i raw_data -o output_dir
```

## get chromosome info

```bash
head -n 24 ./raw_data/E.senticosus.fa.fai > ./raw_data/E.senticosus.fa.new.fai
mv ./raw_data/E.senticosus.fa.new.fai ./raw_data/E.senticosus.fa.fai
head -n 12 ./raw_data/P.notoginseng.fa.fai > ./raw_data/P.notoginseng.fa.new.fai
mv ./raw_data/P.notoginseng.fa.new.fai ./raw_data/P.notoginseng.fa.fai
quota_Anchor get_chr_length -f "$(find ./raw_data/*fai |awk '{printf "%s,", $1}')" -g "$(find ./raw_data/*gff3 |awk '{printf "%s,", $1}')" -s Ae:0-9:Dc:Chr:0-9:Ni:0-9:0-9 -o "$(find ./raw_data/*gff3 |awk '{printf "%s,", $1}'|sed s/gff3/length\.txt/g)" --overwrite
```

## get trios info

```bash
quota_Anchor trios -n "(((((N.incisum, D.carota), C.asiatica), ((A.elata, P.notoginseng),E.senticosus)), E.breviscapus), V.vinifera);" -k "C.asiatica" -ot ortholog_trios_C.asiatica.csv -op species_pairs.csv -t tree.txt --overwrite
python ./scripts/ks_pipeline.py -i raw_data -o output_dir -s species_pairs.csv  -a diamond -l raw_data --overwrite -plot_table -plot_collinearity
```

## Adjust divergence peaks to the focal species level for comparison in mixed ks-plots(You can learn about the correction principle from [1] and [2])

```bash
python get_parameter.py species_pairs.csv
quota_Anchor correct -k "./output_dir/02synteny/C.asiatica_N.incisum0.ks,./output_dir/02synteny/C.asiatica_A.elata0.ks,./output_dir/02synteny/N.incisum_A.elata0.ks,./output_dir/02synteny/C.asiatica_P.notoginseng0.ks,./output_dir/02synteny/N.incisum_P.notoginseng0.ks,./output_dir/02synteny/C.asiatica_E.senticosus0.ks,./output_dir/02synteny/N.incisum_E.senticosus0.ks,./output_dir/02synteny/C.asiatica_E.breviscapus0.ks,./output_dir/02synteny/N.incisum_E.breviscapus0.ks,./output_dir/02synteny/C.asiatica_D.carota0.ks,./output_dir/02synteny/D.carota_A.elata0.ks,./output_dir/02synteny/D.carota_P.notoginseng0.ks,./output_dir/02synteny/D.carota_E.senticosus0.ks,./output_dir/02synteny/D.carota_E.breviscapus0.ks,./output_dir/02synteny/A.elata_E.breviscapus0.ks,./output_dir/02synteny/C.asiatica_V.vinifera0.ks,./output_dir/02synteny/A.elata_V.vinifera0.ks,./output_dir/02synteny/P.notoginseng_E.breviscapus0.ks,./output_dir/02synteny/P.notoginseng_V.vinifera0.ks,./output_dir/02synteny/E.senticosus_E.breviscapus0.ks,./output_dir/02synteny/E.senticosus_V.vinifera0.ks,./output_dir/02synteny/E.breviscapus_V.vinifera0.ks," -col "./output_dir/02synteny/C.asiatica_N.incisum0.collinearity,./output_dir/02synteny/C.asiatica_A.elata0.collinearity,./output_dir/02synteny/N.incisum_A.elata0.collinearity,./output_dir/02synteny/C.asiatica_P.notoginseng0.collinearity,./output_dir/02synteny/N.incisum_P.notoginseng0.collinearity,./output_dir/02synteny/C.asiatica_E.senticosus0.collinearity,./output_dir/02synteny/N.incisum_E.senticosus0.collinearity,./output_dir/02synteny/C.asiatica_E.breviscapus0.collinearity,./output_dir/02synteny/N.incisum_E.breviscapus0.collinearity,./output_dir/02synteny/C.asiatica_D.carota0.collinearity,./output_dir/02synteny/D.carota_A.elata0.collinearity,./output_dir/02synteny/D.carota_P.notoginseng0.collinearity,./output_dir/02synteny/D.carota_E.senticosus0.collinearity,./output_dir/02synteny/D.carota_E.breviscapus0.collinearity,./output_dir/02synteny/A.elata_E.breviscapus0.collinearity,./output_dir/02synteny/C.asiatica_V.vinifera0.collinearity,./output_dir/02synteny/A.elata_V.vinifera0.collinearity,./output_dir/02synteny/P.notoginseng_E.breviscapus0.collinearity,./output_dir/02synteny/P.notoginseng_V.vinifera0.collinearity,./output_dir/02synteny/E.senticosus_E.breviscapus0.collinearity,./output_dir/02synteny/E.senticosus_V.vinifera0.collinearity,./output_dir/02synteny/E.breviscapus_V.vinifera0.collinearity," -s species_pairs.csv -t ortholog_trios_C.asiatica.csv -kr 0,5 -ot outfile_divergent_peaks.csv --overwrite
```

## focal species(C.asiatica self vs self)

```bash
quota_Anchor pre_col -a diamond -rs ./output_dir/01longest/C.asiatica.longest.pep -qs ./output_dir/01longest/C.asiatica.longest.pep -db ./C.asiatica/C.asiatica.database.diamond -mts 20 -e 1e-10 -b ./C.asiatica/C.asiatica.maize.diamond -rg ./raw_data/C.asiatica.gff3 -qg ./raw_data/C.asiatica.gff3 -o ./C.asiatica/C.asiatica.table -bs 100 -al 0 --overwrite
quota_Anchor dotplot -i ./C.asiatica/C.asiatica.table -o ./C.asiatica/C.asiatica.png -r ./raw_data/C.asiatica.length.txt -q ./raw_data/C.asiatica.length.txt -r_label C.asiatica -q_label C.asiatica -use_identity --overwrite
quota_Anchor col -i ./C.asiatica/C.asiatica.table -o ./C.asiatica/C.asiatica.collinearity -r 5 -q 5 -m 500 -W 1 -D 50 -I 4 -E -0.005 -f 0 -s 1 --overwrite
quota_Anchor dotplot -i ./C.asiatica/C.asiatica.collinearity -o ./C.asiatica/C.asiatica.C.asiatica.collinearity.png -r ./raw_data/C.asiatica.length.txt -q ./raw_data/C.asiatica.length.txt -r_label C.asiatica -q_label C.asiatica -use_identity --overwrite
quota_Anchor ks -i ./C.asiatica/C.asiatica.collinearity -a muscle -p ./output_dir/01longest/C.asiatica.longest.pep -d ./output_dir/01longest/C.asiatica.longest.cds -o ./C.asiatica/C.asiatica.C.asiatica.ks -t 16  --add_ks
quota_Anchor dotplot -i ./C.asiatica/C.asiatica.collinearity -o ./C.asiatica/C.asiatica.C.asiatica.collinearity.ks.png -r ./raw_data/C.asiatica.length.txt -q ./raw_data/C.asiatica.length.txt -r_label C.asiatica -q_label C.asiatica --overwrite -ks ./C.asiatica/C.asiatica.C.asiatica.ks
```

## position wgd relative to species speciation events

```bash
quota_Anchor kde -i ./C.asiatica/C.asiatica.collinearity -r./raw_data/C.asiatica.length.txt -q ./raw_data/C.asiatica.length.txt -o ./C.asiatica/C.asiatica.C.asiatica.kde.png -k ./C.asiatica/C.asiatica.C.asiatica.ks --overwrite
quota_Anchor kf -i ./C.asiatica/C.asiatica.collinearity -r ./raw_data/C.asiatica.length.txt -q ./raw_data/C.asiatica.length.txt -o ./C.asiatica/C.asiatica.C.asiatica.kf.png -k ./C.asiatica/C.asiatica.C.asiatica.ks -f C.asiatica -components 2 -kr 0,3 --overwrite --latin_names "C.asiatica:C. asiatica,A.elata:A. elata,D.carota: D. carota,E.senticosus:E. senticosus,E.breviscapus:E. breviscapus,P.notoginseng:P. notoginseng,N.incisum:N. incisum"
quota_Anchor kf -i ./C.asiatica/C.asiatica.collinearity -r ./raw_data/C.asiatica.length.txt -q ./raw_data/C.asiatica.length.txt -o ./C.asiatica/C.asiatica.C.asiatica.0.3.png -k ./C.asiatica/C.asiatica.C.asiatica.ks -components 2 -f C.asiatica -correct_file outfile_divergent_peaks.csv -kr 0,3 --overwrite --latin_names "C.asiatica:C. asiatica,A.elata:A. elata,D.carota: D. carota,E.senticosus:E. senticosus,E.breviscapus:E. breviscapus,P.notoginseng:P. notoginseng,N.incisum:N. incisum"
quota_Anchor kf -i ./C.asiatica/C.asiatica.collinearity -r ./raw_data/C.asiatica.length.txt -q ./raw_data/C.asiatica.length.txt -o ./C.asiatica/C.asiatica.C.asiatica.0.5.png -k ./C.asiatica/C.asiatica.C.asiatica.ks -components 2 -f C.asiatica -correct_file outfile_divergent_peaks.csv -kr 0,5 --overwrite --latin_names "C.asiatica:C. asiatica,A.elata:A. elata,D.carota: D. carota,E.senticosus:E. senticosus,E.breviscapus:E. breviscapus,P.notoginseng:P. notoginseng,N.incisum:N. incisum"
```

```text
Reference:
[1] Sensalari C, Maere S, Lohaus R. ksrates: positioning whole-genome duplications relative to speciation events in KS distributions. Bioinformatics 2022;38:530-532.
[2] https://oup.silverchair-cdn.com/oup/backfile/Content_public/Journal/bioinformatics/38/2/10.1093_bioinformatics_btab602/2/btab602_supplementary_data.pdf?Expires=1744820940&Signature=r3MRM6iNqRUsE7Pj6TjFoN4n2ttwIG1PJ~VaxAfqNab4DyfHZlO4gJY8g8cSLjkoWZpOX~oHgFEopWS~JtaQZdbMCGTDZ1qQIYxZnm8E9O5IuL4dFUW0oVGVvJ5GZ33qW7myGwu0V3hif7w-xCc9Vo7ffet02HP~Fp9gh8O6caYMR~Z5DrqF1gaxs9MC-FVvD3g5nT9GgttXXwkecce8B~0NK7Ain1DAtxQzaetUg6bVo8PWZnEr7aSqgYaWc8DFluRUQrKrFAonK5o-mVv3-XdNF9nKuLVhWlTmFzFhJ0hRAF0i0Z70~r-sIsken1JIaceEFFhg2C4SNwpglJCEXQ__&Key-Pair-Id=APKAIE5G5CRDK6RD3PGA
```
