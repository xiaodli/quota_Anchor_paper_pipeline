library(cowplot)
library(VennDiagram)
dup =read.table("/media/dell/E/Suppmentary_data/08duplicate/output/zm.singletons",
                  header = TRUE, sep="\t")
quota =read.table("/media/dell/E/Suppmentary_data/08duplicate/maize_classify_dir/maize.singleton.genes",header = TRUE, sep="\t")
non_coding = read.table("/media/dell/E/Suppmentary_data/08duplicate/non_coding.txt",header = TRUE, sep="\t")
maize_dup <- unique(na.omit(dup$GeneID))
maize_quota <- unique(na.omit(quota$GeneId))
maize_non_coding <- unique(na.omit(non_coding$non_coding))
maize <- list(DupGen_finder=maize_dup, quota_Anchor=maize_quota, Non_coding=maize_non_coding)

# maize <- venn.diagram(x=maize, filename = NULL, alpha=c(0.6, 0.6), 
#                        euler.d=T, scaled=T, fill=c("#0073C2FF",colors()[468]),
#                        lwd=c(1,1),cex=1,
#                        cat.pos=c(0,0),
#                        resolution = 500,
#                        cat.dist=c(-0.05, -0.02),
#                        cat.cex=1)
venn.diagram(x=maize, filename = "/media/dell/E/Suppmentary_data/08duplicate/venn.png", alpha=c(0.6, 0.6, 0.1), 
                      euler.d=T, scaled=T, fill=c("#FFDEAD", "#40E0D0", colors()[468]),
                      lwd=c(1,1,1),cex=1,
                      cat.pos=c(0,0,180),
                      resolution = 500,
                      cat.dist=c(-0.1, -0.05,-0.05),
                      cat.cex=1)



