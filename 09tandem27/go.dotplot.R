library(ggplot2)
library(scales) 
plot_total <- function (enricher_result, out_file){
  data = read.table(enricher_result, header=T, sep = "\t", quote = "")
  data = data[1:20,]
  data$GeneRatioNum <- sapply(strsplit(data$GeneRatio, "/"), function(x) 
    as.numeric(x[1]) / as.numeric(x[2]))
  data_sorted <- data[order(data$GeneRatioNum), ]
  if (any(nchar(as.character(data_sorted$Description)) > 70)) {
    img_width <- 2000
  } else {
    img_width <- 1500
  }
  plot = ggplot(data_sorted, aes(x=GeneRatioNum, y= reorder(Description, GeneRatioNum)))+
    geom_point(aes(color=p.adjust, size = Count))+
    theme_grey(base_size = 30) +
    labs(x="GeneRatio")+
    scale_colour_gradient(low="blue",high="red",labels = scientific_format())+
    scale_size(range = c(0.5, 2), name = "Count") +
    theme(axis.line = element_blank(),
          panel.background = element_blank(),
          panel.border = element_rect(fill=NA,color="black", linewidth=0.3, linetype="solid"),
          
          legend.title = element_text(size =7, margin = margin(b = 0.2, l = 0.2, unit = "cm")),
          legend.key.size = unit(0.3, "lines"),
          legend.key.height = unit(0.2, "cm"),
          legend.text = element_text(size = 4),
          
          legend.position="right",
          legend.spacing.y = unit(1.5, "cm"),
          legend.box.spacing = unit(-0.2, "cm"),
          legend.background = element_rect(linetype = "solid", linewidth = 0, colour = "black", fill = NA),
          
          axis.text.y = element_text(size = 7),
          axis.text.x = element_text(size = 6),
          
          axis.ticks = element_line(linewidth = 0.1),
          axis.ticks.length = unit(0.2, "mm"),
          axis.ticks.x = element_blank(),
          
          axis.line.x = element_line(color = "black", linewidth = 0.1),
          axis.line.y = element_line(color = "black", linewidth = 0.1),
          
          axis.title.x = element_text(size=8),
          axis.title.y = element_blank()) 
  png(out_file, width=img_width, height=1607, res=300)
  print(plot)
  dev.off()
}
args <- commandArgs(trailingOnly = TRUE)

enricher_result <- args[1]

out_file <- args[2]
plot_total(enricher_result, out_file)