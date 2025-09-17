library(ggplot2)
library(viridis)
library(ggpubr)
library(ggh4x)
library(grid)
plot_total <- function (file, out_file, parameter3){

custom_colors_dark1111 <- c(SGP = "#B43665", PGP = "#8560AF", NGP="#6FA6CF")
custom_colors_light1111 <- c(SGP = "#D84179", PGP = "#A073D2", NGP="#85C7F8")
custom_colors_dark <- c(SGP = "#C29784", PGP = "#92B69F", NGP="#6698BC")
custom_colors_light <- c(SGP = "#F3BDA5", PGP = "#B7E4C7", NGP="#7FBEEB")
my_comparisons <- list( c("SGP", "PGP"), c("SGP", "NGP"), c("PGP", "NGP"))
data =read.table(file, header = TRUE, sep=",")
data$tissue_time <- gsub("shoot_u1", "shoot_d1", data$tissue_time)
data$tissue_time <- gsub("shoot_u2", "shoot_d2", data$tissue_time)
data$tissue_time <- gsub("shoot_u3", "shoot_d3", data$tissue_time)
data$Type <- factor(data$Type,  c("Speciation_gene_pairs", "Paleo_gene_pairs", "Homologous_gene_pairs"))
levels(data$Type)
levels(data$Type) <- c("SGP", "PGP", "NGP")
plot <- ggplot(data, aes(x=Type, y=Corr_Value, fill=Type, color=Type)) + 
  facet_nested(~species_pair+tissue_time, switch="x") +
  # geom_violin(width=0.4, alpha=0.8, linewidth=0.1) +
  geom_boxplot(position = position_dodge(width = 0.1),width=1, alpha=1, size=0.5, outliers = FALSE,  staplewidth = 0.3) +
  # stat_compare_means(label = "p.format", size=0.5, comparisons=my_comparisons,  tip.length = 0.01, bracket.size = 0.04, step.increase = 0.09, hide.ns = FALSE, method = "wilcox.test")  +
  # scale_fill_viridis(discrete = TRUE) +
  scale_fill_manual(values = custom_colors_light) +
  scale_color_manual(values = custom_colors_dark) +
  scale_y_continuous(expand=c(0, 0)) +
  annotate("segment", x = 2, xend = 2, y = 0.25, yend = 0.255, colour = "black", linewidth = 0.1)+
  theme(axis.title.x=element_blank(),          
        # panel.background = element_rect(fill = "white"),
        panel.background = element_blank(),
        panel.spacing = unit(0, "lines"),
        panel.border = element_blank(),
        # panel.border = element_rect(fill=NA,color="black", linewidth=0.1, linetype="solid"),
        # strip.background = element_rect(linewidth = 0.1, linetype="solid"),
        strip.background = element_blank(),
        strip.placement = "outside", 
        strip.text = element_text(size = 20, angle=75, margin = margin(c(0,0,0,0))) ,
        
        legend.title = element_text(size = 25, margin = margin(r = 0.75, b=0.1, t =0, unit = "cm")),
        legend.key.size = unit(2.9, "lines"),
        legend.text = element_text(size = 22),
        legend.box.spacing = unit(0, "cm"),
        legend.key.spacing.x = unit(0.75, "cm"),
        # legend.position = c(0.1, 0.8),
        legend.position = "top",
        # legend.position.inside = c(0.1, 0.8),  
        # legend.background = element_rect(linetype = "solid", linewidth = 0, colour = "black", fill = NA),
        legend.background = element_blank(),
        axis.ticks = element_line(linewidth = 0.1),
        axis.ticks.length = unit(0.2, "mm"),
        axis.ticks.length.x = unit(0, "mm"),
        # axis.text.x = element_text(size = 4, angle=300, hjust=0, vjust=1, colour = "black"),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 19),
        # axis.text.x = element_text(size = 3),
        axis.line.x = element_line(color = "black", linewidth = 0.1),
        axis.line.y = element_line(color = "black", linewidth = 0.1),
        axis.title.y = element_text(size=28)) +
        # legend.position = 'none') +
  labs(y = if(grepl(parameter3, file, ignore.case = TRUE)) "Pearson Correlation coefficient" else "Spearman Correlation coefficient") + 
  coord_cartesian(ylim = c(0.25, 1))
# png(out_file, width=1200, height=742, res=300)
pdf(out_file, width=18, height=12)
print(plot)
dev.off()
}

plot_total("/media/dell/E/Suppmentary_data/04expression_paleo_speciation/pearson_correlation_log.csv", "/media/dell/E/Suppmentary_data/04expression_paleo_speciation/pearson_correlation_log.pdf", "pearson")
plot_total("/media/dell/E/Suppmentary_data/04expression_paleo_speciation/spearman_correlation.csv", "/media/dell/E/Suppmentary_data/04expression_paleo_speciation/spearman_correlation.pdf", "pearson")

