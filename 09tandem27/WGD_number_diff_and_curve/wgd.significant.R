library(ggplot2)
library(viridis)
library(ggpubr)
library(ggh4x)
library(grid)
library(dplyr)
library(rlang)

get_plot <- function (input_path, out_file, varib, y_axis, y_lab) {
# process this file get dataframe to plot significant boxplot
data =read.table(input_path, header = TRUE, sep="\t")
data[, "Depth"] <- as.character(data[, "Depth"])
summary(data)

data <- data %>%
  mutate(Depth = ifelse(Depth != 1, ">1", as.character(Depth)))
custom_colors_light <- c("1" = "#D2E7F2", ">1" = "#B2D8B4")
custom_colors_dark <- c("1" = "#A6CEE3", ">1" = "#7DCA7C")
my_comparisons <- list( c("1", ">1"))
data$Depth <- factor(data$Depth,  c("1", ">1"))
print(data$Depth)
plot1 <- ggplot(data, aes(x=Depth, y=!!sym(varib), fill=Depth, color=Depth)) + 
  # facet_nested(~ species_pair + tissue_time, switch = "x") +
  # facet_grid(~species_pair+tissue_time, scales = "free", space = "free") +
  # geom_violin(width=0.4, alpha=0.8, linewidth=0.1) +
  geom_boxplot(position = position_dodge(width = 0.01),width=0.75, alpha=1, size=0.5, outliers = FALSE,  staplewidth = 0.3) +
  geom_jitter(size= 3)+
  stat_compare_means(label = "p.signif", size=10, comparisons=my_comparisons,  tip.length = 0.03, bracket.size = 0.07, step.increase = 0.08, hide.ns = FALSE, method = "wilcox.test", method.args = list(alternative = "less"))  + 
  # scale_fill_viridis(discrete = TRUE) +
  scale_fill_manual(values = custom_colors_light) +
  scale_color_manual(values = custom_colors_dark) +
  scale_y_continuous(expand=c(0, 0)) +
  # annotate("segment", x = 1.5, xend = 1.5, y = 0.25, yend = 0.255, colour = "black", linewidth = 0.1)+
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
        strip.text = element_text(size = 21, angle=75, margin = margin(c(0,0,0,0))) ,
        # strip.placement = "bottom",
        
        legend.title = element_text(size = 25, margin = margin(r = 0.75, b=0.1, t =0, unit = "cm")),
        legend.key.size = unit(2.9, "lines"),
        legend.text = element_text(size = 21),
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
        axis.ticks.length.x = unit(0.2, "mm"),
        axis.text.y = element_text(size = 22),
        axis.text.x = element_text(size = 35),
        axis.line.x = element_line(color = "black", linewidth = 0.1),
        axis.line.y = element_line(color = "black", linewidth = 0.1),
        axis.title.y = element_text(size=30)) +
  # legend.position = 'none') +
  labs(y = y_lab) + 
  coord_cartesian(ylim = c(0, y_axis))
# png(out_file, width=700, height=760, res=300)
pdf(out_file, width=13, height=12)
print(plot1)
dev.off()
}
get_plot("/media/dell/E/Suppmentary_data/09tandem27/WGD_number_diff_and_curve/wgd.gene.number.summary.txt", 
         "/media/dell/E/Suppmentary_data/09tandem27/WGD_number_diff_and_curve/wgd.gene.number.significant.pdf", "wgd_gene_number", 80000, "WGD gene number")
