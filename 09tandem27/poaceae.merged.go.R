library(stringr)
library(clusterProfiler)
library(ggplot2)
library(scales)
library(ggtext)


enrich_func <- function (all_input, tandem_list_file, enricher_result){
go_anno<-read.table(all_input,sep="\t",header=F, quote = "")
names(go_anno)
go2gene <- go_anno[, c(1, 2)]
go2name <- go_anno[, c(1, 3)]

data <- read.table(tandem_list_file,header=F)
genes <- as.character(data$V1)

ego <- enricher(genes, TERM2GENE = go2gene, TERM2NAME = go2name, pAdjustMethod = "BH",pvalueCutoff  = 0.01, qvalueCutoff  = 0.01)
write.table(as.data.frame(ego),enricher_result,sep="\t",row.names =F,quote=F)
ego_df <- as.data.frame(ego)
print(ego_df$Description)
}

plot_go_result <- function (enricher_result, out_file, tandem_title=""){
  data = read.table(enricher_result, header=T, sep = "\t", quote = "")
  if (nrow(data) > 20) {
    data = data[1:20,]
  }
  if (nrow(data) <5) {
    img_width <- 12
  } else if (nrow(data) <8){
    img_width <- 13
  } else{
    img_width <- 18.5
  }
  color_label_seed_development_and_hormonal_regulation <- c("methyl indole-3-acetate esterase activity",
                                                            "seed development")
  color_label_redox_homeostasis_and_abiotic_stress_response <- c("aldo-keto reductase (NADPH) activity",
                                                                 "methyl salicylate esterase activity",
                                                                 "methyl jasmonate esterase activity",
                                                                 "alcohol dehydrogenase (NAD+) activity",
                                                                 "formaldehyde catabolic process",
                                                                 "S-(hydroxymethyl)glutathione dehydrogenase [NAD(P)+] activity",
                                                                 "systemic acquired resistance",
                                                                 "ammonia-lyase activity",
                                                                 "salicylic acid metabolic process",
                                                                 "detoxification")
  color_label_nitrogen_transport_and_iron_homeostasis <- c("nitrate transmembrane transporter activity",
                                                           "iron-nicotianamine transmembrane transporter activity",
                                                           "response to iron ion")
  color_label_carbohydrate_metabolism_and_sugar_related_pathways  <- c("glucan catabolic process",  
                                                                       "aldose 1-epimerase activity",
                                                                       "galactose catabolic process via UDP-galactose, Leloir pathway")
  color_label_nucleic_acid_metabolism_and_epigenetic_regulation <- c("rRNA (uridine-N3-)-methyltransferase activity",
                                                                     "DNA catabolic process")

  
  
  data$GeneRatioNum <- sapply(strsplit(data$GeneRatio, "/"), function(x)
    as.numeric(x[1]) / as.numeric(x[2]))
  data_sorted <- data[order(data$GeneRatioNum), ]
  data_sorted$Description_colored <- sapply(data_sorted$Description, function(desc) {
    if (desc %in% color_label_seed_development_and_hormonal_regulation) {
      paste0("<span style='color:#EF2C2B;'>", desc, "</span>")
    } else if (desc %in% color_label_redox_homeostasis_and_abiotic_stress_response) {
      paste0("<span style='color:#23B2E0;'>", desc, "</span>")
    } else if (desc %in% color_label_carbohydrate_metabolism_and_sugar_related_pathways) {
      paste0("<span style='color:#A5CC5B;'>", desc, "</span>")
    } else if (desc %in% color_label_nucleic_acid_metabolism_and_epigenetic_regulation) {
      paste0("<span style='color:#EEBEC0;'>", desc, "</span>")
    } else if (desc %in% color_label_seed_development_and_hormonal_regulation) {
      paste0("<span style='color:#000000;'>", desc, "</span>")
    } else {
      desc
    }
  })

  plot = ggplot(data_sorted, aes(x=GeneRatioNum, y= reorder(Description, GeneRatioNum)))+
    geom_point(aes(color=p.adjust, size = Count))+
    # theme_grey(base_size = 30) +
    (if (!is.null(tandem_title) && nchar(tandem_title) > 0) {
      labs(x = "GeneRatio", title = tandem_title)
    } else {
      labs(x = "GeneRatio")
    }) + 
    scale_colour_gradient(low="blue",high="red",labels = scientific_format())+
    scale_size(range = c(2, 6), name = "Count") +
    theme(axis.line = element_blank(),
          panel.background = element_blank(),
          panel.border = element_rect(fill=NA,color="black", linewidth=0.3, linetype="solid"),
          
          legend.title = element_text(size =25, margin = margin(b = 1.0, l = 0.5, unit = "cm")),
          legend.key.size = unit(1.3, "lines"),
          legend.key.height = unit(1.5, "cm"),
          legend.text = element_text(size = 25),
          
          legend.position="right",
          legend.spacing.y = unit(2.5, "cm"),
          legend.box.spacing = unit(0.5, "cm"),
          # legend.background = element_rect(linetype = "solid", linewidth = 0, colour = "black", fill = NA),
          legend.background = element_blank(),
          axis.text.y = ggtext::element_markdown(size = 28), 
          axis.text.x = element_text(size = 25, angle=300, hjust=0, vjust=1, colour = "black"),
          
          axis.ticks = element_line(linewidth = 0.15),
          axis.ticks.length = unit(0.4, "mm"),
          # axis.ticks.x = element_blank(),
          
          axis.line.x = element_line(color = "black", linewidth = 0.1),
          axis.line.y = element_line(color = "black", linewidth = 0.1),
          
          plot.title = element_text(size = 28, hjust = 0.5),
          
          axis.title.x = element_text(size=25),
          axis.title.y = element_blank()) +
    scale_y_discrete(labels = data_sorted$Description_colored)
  # png(out_file, width=img_width, height=1400, res=300)
  pdf(out_file, width=img_width, height=12)
  print(plot)
  dev.off()
}

plot_go_result_longer <- function (enricher_result, out_file, tandem_title=""){
data = read.table(enricher_result, header=T, sep = "\t", quote = "")
if (nrow(data) > 20) {
  data = data[1:20,]
}
if (nrow(data) <5) {
  img_width <- 14
} else if (nrow(data) <8){
  img_width <- 15
} else{
  img_width <- 19
}

data$GeneRatioNum <- sapply(strsplit(data$GeneRatio, "/"), function(x)
  as.numeric(x[1]) / as.numeric(x[2]))
data_sorted <- data[order(data$GeneRatioNum), ]
plot = ggplot(data_sorted, aes(x=GeneRatioNum, y= reorder(Description, GeneRatioNum)))+
  geom_point(aes(color=p.adjust, size = Count))+
  # theme_grey(base_size = 30) +
  (if (!is.null(tandem_title) && nchar(tandem_title) > 0) {
    labs(x = "GeneRatio", title = tandem_title)
  } else {
    labs(x = "GeneRatio")
  }) + 
  scale_colour_gradient(low="blue",high="red",labels = scientific_format())+
  scale_size(range = c(2, 6), name = "Count") +
  theme(axis.line = element_blank(),
        panel.background = element_blank(),
        panel.border = element_rect(fill=NA,color="black", linewidth=0.3, linetype="solid"),
        
        legend.title = element_text(size =24, margin = margin(b = 1.2, l = 0.2, unit = "cm")),
        legend.key.size = unit(2.1, "lines"),
        legend.key.height = unit(2.0, "cm"),
        legend.text = element_text(size = 18),
        
        legend.position="right",
        legend.spacing.y = unit(2.0, "cm"),
        legend.box.spacing = unit(0.4, "cm"),
        # legend.background = element_rect(linetype = "solid", linewidth = 0, colour = "black", fill = NA),
        legend.background = element_blank(),
        axis.text.y = element_text(size = 25),
        axis.text.x = element_text(size = 20, angle=300, hjust=0, vjust=1, colour = "black"),
        
        axis.ticks = element_line(linewidth = 0.15),
        axis.ticks.length = unit(1.4, "mm"),
        # axis.ticks.x = element_blank(),
        
        axis.line.x = element_line(color = "black", linewidth = 0.1),
        axis.line.y = element_line(color = "black", linewidth = 0.1),
        
        plot.title = element_text(size = 25, hjust = 0.5),
        
        axis.title.x = element_text(size=24),
        axis.title.y = element_blank()) 
# png(out_file, width=img_width, height=1400, res=300)
pdf(out_file, width=img_width, height=14)
print(plot)
dev.off()
}

## all tandem
all_input="/media/dell/E/Suppmentary_data/09tandem27/merged.annotation.txt"
tandem_list_file="/media/dell/E/Suppmentary_data/09tandem27/merged.tandem.txt"
enricher_result="/media/dell/E/Suppmentary_data/09tandem27/merged.tandem.enricher.result.txt"
out_file="/media/dell/E/Suppmentary_data/09tandem27/merged.tandem.enricher.result.pdf"
enrich_func(all_input, tandem_list_file, enricher_result)
plot_go_result(enricher_result, out_file, "GO enrichment for tandem genes")

## tandem length >= 13
all_input="/media/dell/E/Suppmentary_data/09tandem27/merged.annotation.txt"
tandem_list_file="/media/dell/E/Suppmentary_data/09tandem27/merged.tandem13.txt"
enricher_result="/media/dell/E/Suppmentary_data/09tandem27/merged.tandem13.enricher.result.txt"
out_file="/media/dell/E/Suppmentary_data/09tandem27/merged.tandem13.enricher.result.pdf"
enrich_func(all_input, tandem_list_file, enricher_result)
plot_go_result_longer(enricher_result, out_file, "GO enrichment for gene clusters with length ≥ 13")

## tandem length >= 14
all_input="/media/dell/E/Suppmentary_data/09tandem27/merged.annotation.txt"
tandem_list_file="/media/dell/E/Suppmentary_data/09tandem27/merged.tandem14.txt"
enricher_result="/media/dell/E/Suppmentary_data/09tandem27/merged.tandem14.enricher.result.txt"
out_file="/media/dell/E/Suppmentary_data/09tandem27/merged.tandem14.enricher.result.pdf"
enrich_func(all_input, tandem_list_file, enricher_result)
plot_go_result_longer(enricher_result, out_file, "GO enrichment for gene clusters with length ≥ 14")
    
## tandem length >= 15
all_input="/media/dell/E/Suppmentary_data/09tandem27/merged.annotation.txt"
tandem_list_file="/media/dell/E/Suppmentary_data/09tandem27/merged.tandem15.txt"
enricher_result="/media/dell/E/Suppmentary_data/09tandem27/merged.tandem15.enricher.result.txt"
out_file="/media/dell/E/Suppmentary_data/09tandem27/merged.tandem15.enricher.result.pdf"
enrich_func(all_input, tandem_list_file, enricher_result)
plot_go_result_longer(enricher_result, out_file, "GO enrichment for gene clusters with length ≥ 15")
    
## tandem length >= 16
all_input="/media/dell/E/Suppmentary_data/09tandem27/merged.annotation.txt"
tandem_list_file="/media/dell/E/Suppmentary_data/09tandem27/merged.tandem16.txt"
enricher_result="/media/dell/E/Suppmentary_data/09tandem27/merged.tandem16.enricher.result.txt"
out_file="/media/dell/E/Suppmentary_data/09tandem27/merged.tandem16.enricher.result.pdf"
enrich_func(all_input, tandem_list_file, enricher_result)
plot_go_result_longer(enricher_result, out_file, "GO enrichment for gene clusters with length ≥ 16")



