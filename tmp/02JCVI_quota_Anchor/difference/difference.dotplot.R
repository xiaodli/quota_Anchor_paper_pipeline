library(ggplot2)
# changetoM <- function ( position ){
#   position=position/1000000;
#   paste(position, "M", sep="")
# }
plot_total <- function (query_file_path, ref_file_path, col_file, fig_file){
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
  custom_colors <- c(homo = "#E0E0E0", quota_align = "#0000FF", quota_Anchor="#FF0000", shared_gene_pairs="#00BA38")
  custom_alpha <- c(homo = 0.1, quota_align =0.5, quota_Anchor=0.5, shared_gene_pairs=0.25)
  custom_size <- c(homo = 0.02, quota_align = 0.1, quota_Anchor=0.1, shared_gene_pairs=0.1)
  
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

plot_total("../quota_Anchor_result/zm.length.txt",
           "../quota_Anchor_result/sb.length.txt",
           "./difference.txt",
           "./diamond_default_difference.pdf")
# plot_total("../quota_Anchor_result/zm.length.txt",
#            "../quota_Anchor_result/sb.length.txt",
#            "./diamond_difference.txt",
#            "./diamond_difference.pdf")
# plot_total("../quota_Anchor_result/zm.length.txt",
#            "../quota_Anchor_result/sb.length.txt",
#            "./blast_difference.txt",
#            "./blast_difference.pdf")

# plot maize chr4 and sorghum 7
plot_total1 <- function (query_file_path, ref_file_path, col_file, fig_file){
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
  
  data = read.table(col_file, header=T)
  # print(col_file)
  data$ref_chr <- as.character(data$ref_chr)
  data$query_chr <- as.character(data$query_chr)
  data = data[which(data$ref_chr %in% ref_string_vector),]
  data = data[which(data$query_chr %in% query_string_vector),]
  custom = c("#F3BDA5", "#FFC0CB", "#B7E4C7","#D8B4E2","#1f77b4", "#F9D68D","#FF847C","#E0E0E0","#7FBEEB", "#B19CD9","#F89CAE","#5FC8D1","#FDFD96","#e377c2","#d62728", "#AED9E0")
  data$ref_chr = factor(data$ref_chr, levels = ref_string_vector)
  data$query_chr = factor(data$query_chr, levels = query_string_vector)
  custom_colors <- c(quota_align = "#0000FF", quota_Anchor="#FF0000",  shared_gene_pairs="#00BA38")
  custom_alpha <- c(quota_align =0.5, quota_Anchor=0.5,  shared_gene_pairs=0.25)
  custom_size <- c(quota_align = 0.1, quota_Anchor=0.1,  shared_gene_pairs=0.1)
  
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
          strip.text = element_text(size = 35),
          panel.background = element_blank(),
          panel.border = element_rect(fill=NA,color="black", linewidth=1, linetype="solid"),
          # legend.position='none',
          
          legend.title = element_text(size = 35, margin = margin(r = 0.75, unit = "cm")),
          legend.key.size = unit(17, "mm"),
          legend.text = element_text(size = 35),
          # legend.direction = "horizontal",
          legend.position="top",
          legend.box.spacing = unit(0, "cm"),
          legend.key.spacing.x = unit(1.5, "cm"),
          # legend.position = "inside", 
          # legend.position.inside = c(0.1, 0.8),  
          # legend.background = element_rect(linetype = "solid", linewidth = 0, colour = "black", fill = NA),
          legend.background = element_blank(),
          
          # legend.title = element_text(size = 30),
          # legend.key.size = unit(10, "mm"),
          # legend.key.height = unit(8, "mm"),
          # legend.key.width = unit(8, "mm"),
          # legend.text = element_text(size = 25),
          # legend.position = c(0.15, 0.8),
          # legend.background = element_rect(linetype = "solid", linewidth = 0, colour = "black", fill = NA),
          
          axis.ticks = element_line(linewidth = 0.1),
          axis.ticks.length = unit(0.2, "mm"),
          axis.title = element_text(size = 50, margin = margin(t = 2, l =2,  unit = "cm"), face = "italic"),
          
          # axis.text.y = element_text(size = 17, colour = "black"),
          axis.text = element_blank()) +
          # axis.text.x = element_text(angle=300, hjust=0, vjust=1, colour = "black", size = 17) ) + 
    guides(color = guide_legend(override.aes = list(size = 6)))
  # png(fig_file , width=1350, height=890, res=75)
  pdf(fig_file, width=16, height=12)
  print(plot)
  dev.off()
}
plot_total1("./zm.length.txt",
           "./sb.length.txt",
           "./difference.maize4.sorghum7_5.txt",
           "./diamond_default_difference.maize4.sorghum7_5.pdf")

