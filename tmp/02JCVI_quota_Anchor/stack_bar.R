library(ggplot2)
library(reshape2)

plot_total <- function (file, out_file, y_label){
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
  head(df)
  colourss = c("#72F0FB")
  custom = c("#F3BDA5", "#FFC0CB", "#B7E4C7","#D8B4E2","#1f77b4", "#F9D68D","#FF847C","#E0E0E0","#7FBEEB", "#B19CD9","#F89CAE","#5FC8D1","#FDFD96","#e377c2","#d62728", "#AED9E0")
  custom_colors = c(`1:1` = "#F3BDA5", `2:1` = "#B7E4C7", `other_ratio` = "#7FBEEB")
  plot = ggplot(df, aes(x=factor(X_variable,levels =unique(X_variable)), y=number, fill=factor(X_variable,levels = unique(X_variable)), )) +
    labs(y=y_label, fill="Type") +  
    scale_y_continuous(expand=expansion(mult = c(0, 0.1))) +
    geom_bar(stat = "identity", width = 1)  +
    geom_text(aes(label = number),
              vjust = -0.5,   
              size = 6.3,
              position = position_dodge(width = 1)) +  
    facet_wrap(~Software) +
    coord_cartesian(ylim = c(0, 15000)) +
    scale_fill_manual(values = custom_colors) + 
    theme(axis.title.x=element_blank(),
          panel.background = element_rect(fill = "white"),
          panel.spacing = unit(0.25, "lines"),
          # panel.border = element_blank(),
          panel.border = element_rect(fill=NA,color="black", linewidth=0.15, linetype="solid"),
          strip.text = element_text(size = 23 ) ,
          strip.background = element_blank() ,
          axis.ticks = element_line(linewidth = 0.1),
          axis.ticks.length = unit(0.5, "mm"),
          axis.text.x = element_text(size = 22, angle=300, hjust=0, vjust=1, colour = "black"),
          axis.text.y = element_text(size = 22),
          # axis.text.x = element_text(size = 3),
          axis.line.x = element_line(color = "black", linewidth = 0.15),
          axis.line.y = element_line(color = "black", linewidth = 0.15),
          axis.title.y = element_text(size=30),
          legend.title = element_text(size = 20),
          legend.key.size = unit(3.2, "lines"),
          legend.text = element_text(size = 18),
          legend.position = c(0.82, 0.21),
          # legend.position.inside = c(0.8, 0.21),
          legend.background = element_rect(linetype = "solid", linewidth = 0.1, colour = "black", fill = NA),
          plot.title = element_text(size = 15, hjust = 0.5))
          
          
  # png(out_file, width=1300, height=987, res=300)
  pdf(out_file, width=16, height=12)
  print(plot)
  dev.off()
}
plot_total("./five_type_bar.txt", "./five_type_bar.pdf", "Number of clusters")
# plot_total("./five_type_bar_gene_pairs.txt", "./five_type_bar_gene_pairs.png", "Number of gene pairs")

