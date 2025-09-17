# bar difference(pairwise comparison)

```bash
awk '{OFS="\t";print $2,$1}' ../WGDI_result/Saccharum.spontaneum_Panicum.hallii/Saccharum.spontaneum_Panicum.hallii.collinearity.ks.correspondence.pc.alignment.txt > qry_ref_Saccharum.spontaneum_Panicum.hallii.collinearity.ks.correspondence.pc.alignment.txt
awk '{OFS="\t";print $2,$1}' ../SOI_result/orthofinder_Panicum/ss_ph.collinearity.ortho.txt > soi.ph.txt
python get_bar_difference_R.py ../quota_Anchor_result/Saccharum.spontaneum_Panicum.hallii.collinearity.txt \
                                ../JCVI_result/Panicum.Saccharum.1x4.anchors.txt \
                                qry_ref_Saccharum.spontaneum_Panicum.hallii.collinearity.ks.correspondence.pc.alignment.txt \
                                soi.ph.txt \
                                ph.bar_difference_R.txt

awk '{OFS="\t";print $2,$1}' ../SOI_result/orthofinder_Cenchrus/ss_cm.collinearity.ortho.txt > soi.cm.txt
python get_bar_difference_R.py ../quota_Anchor_result/Saccharum.spontaneum_Cenchrus.macrourus.collinearity.txt \
                                ../JCVI_result/Cenchrus.Saccharum.2x4.anchors.txt \
                                ../WGDI_result/Saccharum.spontaneum_Cenchrus.macrourus/Saccharum.spontaneum_Cenchrus.macrourus.collinearity.txt \
                                soi.cm.txt \
                                cm.bar_difference_R.txt
                                
awk '{OFS="\t";print $2,$1}' ../SOI_result/orthofinder_Echinochloa/ss_ec.collinearity.ortho.txt > soi.ec.txt
python get_bar_difference_R.py ../quota_Anchor_result/Saccharum.spontaneum_Echinochloa.colona.collinearity.txt \
                                ../JCVI_result/Echinochloa.Saccharum.3x4.anchors.txt \
                                ../WGDI_result/Saccharum.spontaneum_Echinochloa.colona/Saccharum.spontaneum_Echinochloa.colona.collinearity.txt \
                                soi.ec.txt \
                                ec.bar_difference_R.txt
```
