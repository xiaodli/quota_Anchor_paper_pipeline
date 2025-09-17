library(ggplot2)
# changetoM <- function ( position ){
#   position=position/1000000;
#   paste(position, "M", sep="")
# }
setwd("/media/dell/E/Suppmentary_data/02JCVI_WGDI_SOI_quota_Anchor/difference_WGDI_and_soi/")
plot_total <- function (query_file_path, ref_file_path, software, col_file, fig_file){
  # read fai file. (first and second column)
  
  query_fai <- read.table(query_file_path, header=T)
  # print(query_file_path)
  query_length <- query_fai[, c(1,3)]
  colnames(query_length) <- c("query_chr", "length")
  query_length$query_chr <- as.character(query_length$query_chr)
  query_length$length <- as.integer(query_length$length)
  query_string_vector <- query_length$query_chr
  
  ref_fai <- read.table(ref_file_path, header=T)
  # print(ref_file_path)
  ref_length <- ref_fai[, c(1,3)]
  colnames(ref_length) <- c("ref_chr", "length")
  ref_length$ref_chr <- as.character(ref_length$ref_chr)
  ref_length$length <- as.integer(ref_length$length)
  ref_string_vector <- ref_length$ref_chr
  
  # get blank df
  blank_df <- data.frame(matrix(nrow = 0, ncol = 4))
  
  for (i in 1:nrow(ref_length)) {
    refRowData <- ref_length[i, ]
    ref_chr <- refRowData[1, "ref_chr"]
    ref_chrLength <- refRowData[1, "length"]
    for (j in 1:nrow(query_length)) {
      queryRowData <- query_length[j, ]
      query_chr <- queryRowData[1, "query_chr"]
      query_chrLength <- queryRowData[1, "length"]
      new_row <- c(ref_chr, ref_chrLength, query_chr, query_chrLength)
      new_row_zero <- c(ref_chr, 0, query_chr, 0)
      blank_df <- rbind(blank_df, new_row)
      blank_df <- rbind(blank_df, new_row_zero)
    }
  }
  blank_colnames <- c("ref_chr", "refLength", "query_chr", "queryLength")
  colnames(blank_df) <- blank_colnames
  
  # convert column's class(factor and integer)
  blank_df$refLength <- as.integer(blank_df$refLength)
  blank_df$queryLength <- as.integer(blank_df$queryLength)
  blank_df$ref_chr <- factor(blank_df$ref_chr, levels = ref_string_vector)
  blank_df$query_chr <- factor(blank_df$query_chr, levels = query_string_vector)
  
  # read anchors file generated from AnchorWave.
  data = read.table(col_file, header=T)
  # print(col_file)
  data$ref_chr <- as.character(data$ref_chr)
  data$query_chr <- as.character(data$query_chr)
  data = data[which(data$ref_chr %in% ref_string_vector),]
  data = data[which(data$query_chr %in% query_string_vector),]
  custom = c("#F3BDA5", "#FFC0CB", "#B7E4C7","#D8B4E2","#1f77b4", "#F9D68D","#FF847C","#E0E0E0","#7FBEEB", "#B19CD9","#F89CAE","#5FC8D1","#FDFD96","#e377c2","#d62728", "#AED9E0")
  data$ref_chr = factor(data$ref_chr, levels = ref_string_vector)
  data$query_chr = factor(data$query_chr, levels = query_string_vector)
  
  custom_colors <- c(homo = "#E0E0E0", "#0000FF", quota_Anchor="#FF0000", shared_gene_pairs="#00BA38")
  custom_colors <- setNames(custom_colors, c("homo", software, "quota_Anchor", "shared_gene_pairs"))
  
  custom_alpha <- c(homo = 0.1, 0.5, quota_Anchor=0.5, shared_gene_pairs=0.5)
  custom_alpha <- setNames(custom_alpha, c("homo", software, "quota_Anchor", "shared_gene_pairs"))
  
  custom_size <- c(homo = 0.02, 0.1, quota_Anchor=0.1, shared_gene_pairs=0.1)
  custom_size <- setNames(custom_size, c("homo", software, "quota_Anchor", "shared_gene_pairs"))
  
  custom_zorder <- c(homo = 1, 2, quota_Anchor = 3, shared_gene_pairs = 4)
  custom_zorder <- setNames(custom_zorder, c("homo", software, "quota_Anchor", "shared_gene_pairs"))
  data$Type <- factor(data$Type, levels = names(sort(custom_zorder)))
  
  plot <- ggplot(data=data, aes(x=query_index, y=ref_index))+
    facet_grid(ref_chr~query_chr, scales = "free", space = "free")+
    geom_point(size=0.01, aes(color=Type, alpha = Type, size = Type)) +
    geom_blank(data=blank_df, aes(x=queryLength, y=refLength)) +
    scale_color_manual(values = custom_colors) +
    scale_alpha_manual(values = custom_alpha) +
    theme_grey(base_size = 30) +
    labs(x="Zea mays", y="Sorghum bicolor")+scale_x_continuous(expand=c(0, 0)) + scale_y_continuous(expand=c(0, 0)) +
    theme(axis.line = element_blank(),
          panel.spacing = unit(0, "mm"),
          # strip.background = element_rect(color = "#a0a0a0"),
          strip.background = element_blank(),
          strip.text = element_text(size = 18),
          panel.background = element_blank(),
          panel.border = element_rect(fill=NA,color="black", linewidth=0.5, linetype="solid"),
          # legend.position='none',
          
          legend.title = element_text(size = 25),
          legend.key.size = unit(10, "mm"),
          legend.position="top",
          legend.box.spacing = unit(0, "cm"),
          legend.key.spacing.x = unit(1.5, "cm"),
          # legend.key.height = unit(8, "mm"),
          # legend.key.width = unit(8, "mm"),
          legend.text = element_text(size = 25),
          # legend.position = c(0.1, 0.8),
          # legend.background = element_rect(linetype = "solid", linewidth = 0, colour = "black", fill = NA),
          legend.background = element_blank(),
          
          axis.ticks = element_line(linewidth = 0.5),
          axis.ticks.length = unit(0.5, "mm"),
          axis.title = element_text(size = 27, face = "italic"),
          
          axis.text.y = element_text(size = 10, colour = "black"),
          axis.text.x = element_text(angle=300, hjust=0, vjust=1, colour = "black", size = 10) ) + 
    guides(color = guide_legend(override.aes = list(size = 10)))
  # png(fig_file , width=4000, height=3000, res=300)
  pdf(fig_file, width=16, height=12)
  print(plot)
  dev.off()
}

plot_total("zm.length.txt",
           "sb.length.txt",
           "WGDI",
           "./wgdi.txt",
           "./wgdi_blastp_difference.pdf")
plot_total("zm.length.txt",
           "sb.length.txt",
           "SOI",
           "./soi.txt",
           "./SOI_blastp_difference.pdf")


