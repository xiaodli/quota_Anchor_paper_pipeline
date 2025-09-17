library(ggplot2)
library(viridis)
library(ggpubr)
library(ggh4x)
library(grid)

plot_total <- function (file, out_file, parameter3, parameter4, parameter5, position_y, annota_par, tip_len=0.005){

my_comparisons <- list( c("NRIGP", "RIGP"))
data =read.table(file, header = TRUE, sep=",")
data$Type <- factor(data$Type,  c("Speciation_gene_pairs_same_direction", "Speciation_gene_pairs_inverse_direction"))
# print(levels(data$Type))
custom_colors <- c(NRIGP = "#F8766D", RIGP = "#00BFC4")
custom_colors_light <- c(NRIGP = "#D2E7F2", RIGP = "#B2D8B4")
custom_colors_dark <- c(NRIGP = "#A6CEE3", RIGP = "#7DCA7C")
levels(data$Type) <- c("NRIGP", "RIGP")
plot <- ggplot(data, aes(x=Type, y=!!sym(parameter4), fill=Type, color=Type)) + 
  facet_nested(~Species, switch="x") +
  # geom_violin(width=1, alpha=0.5, linewidth=0.1) +
  # color="#FF66FF"
  geom_boxplot(position = position_dodge(width = 1),width=1, alpha=1, size=0.5, outliers = FALSE,  staplewidth = 0.3) +
  geom_hline(yintercept = 0, color = "black", linewidth = 0.1, linetype = "solid") +
  stat_compare_means(label = "p.signif", size=5.5, comparisons=my_comparisons,  inherit.aes =TRUE,
                     bracket.size = 0.01, step.increase = 0, hide.ns = FALSE, 
                     label.y = position_y,  tip.length = tip_len, 
                     method = "wilcox.test", method.args = list(alternative = "two.sided"))  + 
  # scale_fill_viridis(discrete = TRUE) +
  scale_fill_manual(values = custom_colors_light) +
  scale_color_manual(values = custom_colors_dark) +
  scale_y_continuous(expand=c(0, 0)) +
  annotate("segment", x = 1.5, xend = 1.5, y = 0, yend = -annota_par, colour = "black", linewidth = 0.05)+
  theme(axis.title.x=element_blank(),          
        # panel.background = element_rect(fill = "white"),
        panel.background = element_blank(),
        panel.spacing = unit(0, "lines"),
        panel.border = element_blank(),
        # panel.border = element_rect(fill=NA,color="black", linewidth=0.1, linetype="solid"),
        
        legend.title = element_text(size = 25, margin = margin(r = 0.6, unit = "cm")),
        legend.key.size = unit(2.5, "lines"),
        legend.text = element_text(size = 25),
        # legend.position = c(0.1, 0.8),
        # legend.position = "inside", 
        # legend.position.inside = c(0.1, 0.8),  
        # legend.background = element_rect(linetype = "solid", linewidth = 0.1, colour = "black", fill = NA),
        legend.position="top",
        legend.box.spacing = unit(0, "cm"),
        legend.key.spacing.x = unit(1, "cm"),
        # legend.position = "inside", 
        # legend.position.inside = c(0.1, 0.8),  
        # legend.background = element_rect(linetype = "solid", linewidth = 0, colour = "black", fill = NA),
        legend.background = element_blank(),
        
        
        # strip.background = element_rect(linewidth = 0, linetype="solid"),
        strip.background = element_blank(),
        strip.placement = "outside", 
        strip.clip="off",
        strip.text = element_text(size = 25, angle=90, margin = margin(c(0,0,0,0)), colour = "black", face ="italic") ,
        axis.ticks = element_line(linewidth = unit(0.5, "mm")),
        axis.ticks.length = unit(1, "mm"),
        axis.ticks.x = element_blank(),
        # axis.text.x = element_text(size = 4, angle=300, hjust=0, vjust=1, colour = "black"),
        axis.text.y = element_text(size = 25),
        axis.text.x = element_blank(),
        axis.line.x = element_blank(),
        axis.line.y = element_line(color = "black", linewidth = 0.1),
        axis.title.y = element_text(size = 28)) +
        # legend.position = 'none') +
  labs(y = parameter3) + 
  coord_cartesian(ylim = c(-annota_par, parameter5))
# png(out_file, width=1600, height=987, res=300)
pdf(out_file, width=18, height=12)
print(plot)
dev.off()
}



plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/ka/calculator.ka.csv", 
           "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/ka/calculator.ka.pdf", 
           "KaKs_Calculator MA ka", 
           "ka", 
           0.7, position_y=0.55, annota_par=0.002)
plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/ka/ng86.ka.csv", 
           "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/ka/ng86.ka.pdf", 
           "NG86 ka", 
           "ka", 
           0.7, position_y=0.55, annota_par=0.002)
plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/ka/yn00.ka.csv", 
           "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/ka/yn00.ka.pdf", 
           "YN00 ka", 
           "ka",
           0.7, position_y=0.55, annota_par=0.002)





plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/ks/calculator.ks.csv", 
           "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/ks/calculator.ks.pdf", 
           "KaKs_Calculator MA ks", 
           "ks", 
           3.3, position_y=3, annota_par=0.008)
plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/ks/ng86.ks.csv", 
           "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/ks/ng86.ks.pdf", 
           "NG86 ks", 
           "ks", 
           2.3, position_y=2, annota_par=0.008)
plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/ks/yn00.ks.csv", 
           "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/ks/yn00.ks.pdf", 
           "YN00 ks", 
           "ks", 
           3.3, position_y=3, annota_par=0.008)


plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/omega/yn00.omega.csv", 
           "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/omega/yn00.omega.pdf", 
           "YN00 ka/ks", 
           "omega", 
           0.6, position_y=0.3, annota_par=0.002, 0.001)
plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/omega/ng86.omega.csv", 
           "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/omega/ng86.omega.pdf", 
           "NG86 ka/ks", 
           "omega", 
           0.7, position_y=0.4, annota_par=0.002, 0.001)
plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/omega/calculator.omega.csv", 
           "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27/omega/calculator.omega.pdf", 
           "KaKs_Calculator MA ka/ks", 
           "omega",
           0.55, position_y=0.4, annota_par=0.002, 0.004)

