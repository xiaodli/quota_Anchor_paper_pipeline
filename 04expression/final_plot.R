library(ggplot2)
library(viridis)
library(ggpubr)
library(ggh4x)
library(grid)
plot_total <- function (file, out_file, parameter3){
custom_colors_light <- c(NRIGP = "#D2E7F2", RIGP = "#B2D8B4")
custom_colors_dark <- c(NRIGP = "#A6CEE3", RIGP = "#7DCA7C")
my_comparisons <- list( c("NRIGP", "RIGP"))
data =read.table(file, header = TRUE, sep=",")
data$tissue_time <- gsub("shoot_u1", "shoot_d1", data$tissue_time)
data$tissue_time <- gsub("shoot_u2", "shoot_d2", data$tissue_time)
data$tissue_time <- gsub("shoot_u3", "shoot_d3", data$tissue_time)
data$Type <- factor(data$Type,  c("Speciation_gene_pairs_same_direction", "Speciation_gene_pairs_inverse_direction"))
levels(data$Type)
levels(data$Type) <- c("NRIGP", "RIGP")
plot <- ggplot(data, aes(x=Type, y=Corr_Value, fill=Type, color=Type)) + 
  facet_nested(~ species_pair + tissue_time, switch = "x") +
  # facet_grid(~species_pair+tissue_time, scales = "free", space = "free") +
  # geom_violin(width=0.4, alpha=0.8, linewidth=0.1) +
  geom_boxplot(position = position_dodge(width = 0.01),width=1, alpha=1, size=0.5, outliers = FALSE,  staplewidth = 0.3) +
  stat_compare_means(label = "p.signif", size=3.5, comparisons=my_comparisons,  tip.length = 0.01, bracket.size = 0.04, step.increase = 0.08, hide.ns = FALSE, method = "wilcox.test", method.args = list(alternative = "greater"))  + 
  # scale_fill_viridis(discrete = TRUE) +
  scale_fill_manual(values = custom_colors_light) +
  scale_color_manual(values = custom_colors_dark) +
  scale_y_continuous(expand=c(0, 0)) +
  annotate("segment", x = 1.5, xend = 1.5, y = 0.25, yend = 0.255, colour = "black", linewidth = 0.1)+
  theme(axis.title.x=element_blank(),          
        # panel.background = element_rect(fill = "white"),
        panel.background = element_blank(),
        panel.spacing = unit(0, "lines"),
        # panel.grid.major = element_blank(),
        panel.border = element_blank(),
        # panel.border = element_rect(fill=NA,color="black", linewidth=0.1, linetype="solid"),
        # strip.background = element_rect(linewidth = 0.1, linetype="solid"),
        strip.background = element_blank(),
        strip.placement = "outside", 
        strip.text = element_text(size = 25, angle=75, margin = margin(c(0,0,0,0))) ,
        # strip.placement = "bottom",
        
        legend.title = element_text(size = 25, margin = margin(r = 0.75, b=0.1, t =0, unit = "cm")),
        legend.key.size = unit(2.9, "lines"),
        legend.text = element_text(size = 20),
        # legend.direction = "horizontal",
        legend.position="top",
        legend.box.spacing = unit(0, "cm"),
        legend.key.spacing.x = unit(0.75, "cm"),
        # legend.position = "inside", 
        # legend.position.inside = c(0.1, 0.8),  
        # legend.background = element_rect(linetype = "solid", linewidth = 0, colour = "black", fill = NA),
        legend.background = element_blank(),
        axis.ticks = element_line(linewidth = 0.1),
        axis.ticks.length = unit(0.2, "mm"),
        axis.ticks.length.x = unit(0, "mm"),
        # axis.text.x = element_text(size = 4, angle=300, hjust=0, vjust=1, colour = "black"),
        axis.text.x = element_blank(),
        
        axis.text.y = element_text(size = 20),
        # axis.text.x = element_text(size = 3),
        axis.line.x = element_line(color = "black", linewidth = 0.1),
        axis.line.y = element_line(color = "black", linewidth = 0.1),
        axis.title.y = element_text(size=28)) +
        # legend.position = 'none') +
  labs(y = if(grepl(parameter3, file, ignore.case = TRUE)) "Pearson Correlation coefficient" else "Spearman Correlation coefficient") + 
  coord_cartesian(ylim = c(0.25, 1.1))


# png(out_file, width=1200, height=760, res=300)
pdf(out_file, width=16, height=12)
print(plot)
dev.off()
}

plot_total("/media/dell/E/Suppmentary_data/04expression/pearson_correlation_log.csv", "/media/dell/E/Suppmentary_data/04expression/pearson_correlation_log.pdf", "pearson")
plot_total("/media/dell/E/Suppmentary_data/04expression/spearman_correlation.csv", "/media/dell/E/Suppmentary_data/04expression/spearman_correlation.pdf", "pearson")

