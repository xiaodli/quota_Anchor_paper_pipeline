# parallel plot

## pairwise alignment(10)

```bash
bash 11col.sh
```

## visualization

```bash
cd collinearity
cp /media/dell/E/Suppmentary_data/05sequence/01pipeline_raw_data/*length* .
quota_Anchor line -i Brachypodium.distachyon_Bromus.tectorum.collinearity,Bromus.tectorum_Eragrostis.tef.collinearity,Eragrostis.tef_Leersia.perrieri.collinearity,Leersia.perrieri_Oryza.sativa.collinearity,Oryza.sativa_Panicum.hallii.collinearity,Panicum.hallii_Poa.annua.collinearity,Poa.annua_Secale.cereale.collinearity,Secale.cereale_Setaria.viridis.collinearity,Setaria.viridis_Sorghum.bicolor.collinearity,Sorghum.bicolor_Zea.mays.collinearity -l Brachypodium.distachyon.length.txt,Bromus.tectorum.length.txt,Eragrostis.tef.length.txt,Leersia.perrieri.length.txt,Oryza.sativa.length.txt,Panicum.hallii.length.txt,Poa.annua.length.txt,Secale.cereale.length.txt,Setaria.viridis.length.txt,Sorghum.bicolor.length.txt,Zea.mays.length.txt -n "Brachypodium.distachyon,Bromus.tectorum,Eragrostis.tef,Leersia.perrieri,Oryza.sativa,Panicum.hallii,Poa.annua,Secale.cereale,Setaria.viridis,Sorghum.bicolor,Zea.mays" -sc "red" -cs "four_colors" -it -rm "Bt,Pa" -o line10.png --overwrite -sf 12
```

