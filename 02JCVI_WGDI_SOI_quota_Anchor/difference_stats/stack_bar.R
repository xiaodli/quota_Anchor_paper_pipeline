library(ggplot2)
library(reshape2)
setwd("/media/dell/E/Suppmentary_data/02JCVI_WGDI_SOI_quota_Anchor/difference_stats/")
plot_total <- function (file, out_file, x_label){
  # Type1,Type2,group,non-group,singleton
  # maize,dupfinder,25669,7791,6296
  # maize,blast,28135,5325,6296
  # sorghum,dupfinder,20401,4135,9582
  # sorghum,blast,22529,2007,9582
  # oryza,dupfinder,20364,1456,13986
  # oryza,blast,21340,480,13986
  df = read.csv(file, sep = "\t", check.names = FALSE)
  
  df
  # df = melt(df)
  print(head(df))
  colourss = c("#72F0FB")
  custom = c("#F3BDA5", "#FFC0CB", "#B7E4C7","#D8B4E2","#1f77b4", "#F9D68D","#FF847C","#E0E0E0","#7FBEEB", "#B19CD9","#F89CAE","#5FC8D1","#FDFD96","#e377c2","#d62728", "#AED9E0")
  custom_colors = rev(c(shared_gene_pairs = "#B7E4C7", quota_Anchor = "#F3BDA5", quota_align = "#7FBEEB", WGDI ="#D8B4E2", SOI = "#FDFD96"))
  plot = ggplot(df, aes(y=factor(comparison,levels =rev(unique(comparison))), x=number, fill=factor(types,levels = c("SOI", "WGDI", "quota_align", "quota_Anchor","shared_gene_pairs")), )) +
    labs(x=x_label, fill="Type") +  
    scale_x_continuous(expand=expansion(mult = c(0, 0.05))) +
    geom_bar(stat = "identity", width = 0.8)  +
    # geom_text(aes(label = number),
    #           vjust = -0.5,
    #           size = 6.3,
    #           position = position_dodge(width = 1)) +
    # facet_wrap(~Software) +
    # coord_cartesian(ylim = c(0, 15000)) +
    scale_fill_manual(values = custom_colors,  breaks = c("shared_gene_pairs", "quota_Anchor", "quota_align", "WGDI", "SOI")) + 
    theme(axis.title.y=element_blank(),
          panel.background = element_rect(fill = "white"),
          panel.spacing = unit(0.25, "lines"),
          # panel.border = element_blank(),
          panel.border = element_rect(fill=NA,color="black", linewidth=0.15, linetype="solid"),
          # strip.text = element_text(size = 23 ) ,
          # strip.background = element_blank() ,
          axis.ticks = element_line(linewidth = 0.1),
          axis.ticks.length = unit(0.5, "mm"),
          axis.text.y = element_text(size = 22, hjust=0, colour = "black"),
          axis.text.x = element_text(size = 22),
          # axis.text.x = element_text(size = 3),
          axis.line.y = element_line(color = "black", linewidth = 0.15),
          axis.line.x = element_line(color = "black", linewidth = 0.15),
          axis.title.x = element_text(size=30),
          legend.title = element_text(size = 20),
          legend.key.size = unit(3.2, "lines"),
          legend.text = element_text(size = 18),
          legend.position = 'top',
          legend.background = element_blank(),
          # legend.position.inside = c(0.8, 0.21),
          # legend.background = element_rect(linetype = "solid", linewidth = 0.1, colour = "black", fill = NA),
          plot.title = element_text(size = 15, hjust = 0.5))
          
          
  # png(out_file, width=1300, height=987, res=300)
  pdf(out_file, width=18, height=7.5)
  print(plot)
  dev.off()
}
plot_total("./bar_difference_R.txt", "./bar_difference_R.pdf", "Number of collinear gene pairs")

