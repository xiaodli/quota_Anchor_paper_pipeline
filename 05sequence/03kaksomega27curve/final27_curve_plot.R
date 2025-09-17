library(ggplot2)
library(viridis)
library(ggpubr)
plot_total <- function (file, out_file, parameter3, parameter4){

data =read.table(file, header = TRUE, sep=",")
data$Type <- factor(data$Type,  c("Speciation_gene_pairs_same_direction", "Speciation_gene_pairs_inverse_direction"))
print(levels(data$Type))
# custom_colors <- c(NRIGP = "#F8766D", RIGP = "#00BFC4")
custom_colors_light <- c(NRIGP = "#D2E7F2", RIGP = "#B2D8B4")
custom_colors_dark <- c(NRIGP = "#A6CEE3", RIGP = "#7DCA7C")
levels(data$Type) <- c("NRIGP", "RIGP")
plot <- ggplot(data, aes(x=species, y=!!sym(parameter3))) + 
  geom_point(size=4.5, aes(shape=Type, color=Type)) + 
  geom_line(aes(group=Type, color=Type), linewidth=0.5) + 
  labs(y=parameter4, fill="Gene pairs type") +  
  facet_wrap(~method, nrow = 3, strip.position = "right", scales = "free_y") + 
  scale_color_manual(values = custom_colors_dark) +
  theme(axis.title.x=element_blank(),          
        # panel.background = element_rect(fill = "white"),
        panel.background = element_blank(),
        panel.spacing = unit(0.1, "lines"),
        # panel.border = element_blank(),
        panel.border = element_rect(fill=NA,color="black", linewidth=0.1, linetype="solid"),
        # strip.background = element_rect(linewidth = 0.1, linetype="solid"),
        strip.background = element_blank(),
        strip.text = element_text(size = 24) ,
        axis.ticks = element_line(linewidth = unit(0.5, "mm")),
        axis.ticks.length = unit(1, "mm"),
        axis.text.x = element_text(size = 23, angle=90, hjust=0.5, vjust=1, colour = "black", face ="italic"),
        axis.text.y = element_text(size = 22),
        # axis.text.x = element_text(size = 3),
        axis.line.x = element_line(color = "black", linewidth = 0.1),
        axis.line.y = element_line(color = "black", linewidth = 0.1),
        axis.title.y = element_text(size = 23),

        # legend.position = c(0.1, 0.8),
        # legend.position = "inside", 
        # legend.position.inside = c(0.1, 0.8),  
        # legend.background = element_rect(linetype = "solid", linewidth = 0.1, colour = "black", fill = NA),
        legend.position="top",
        legend.box.spacing = unit(0, "cm"),
        legend.key.spacing.x = unit(1.2, "cm"),
        # legend.position = "inside", 
        # legend.position.inside = c(0.1, 0.8),  
        # legend.background = element_rect(linetype = "solid", linewidth = 0, colour = "black", fill = NA),
        legend.background = element_blank(),
        legend.title = element_text(size = 28, margin = margin(r = 0.6, t = 0, b = 0, unit = "cm")),
        legend.key.size = unit(2.7, "lines"),
        legend.text = element_text(size = 25))
        # legend.background = element_rect(linetype = "solid", linewidth = 0.1, colour = "black", fill = NA))
# png(out_file, width=1600, height=987, res=300)
pdf(out_file, width=18, height=12)
print(plot)
dev.off()
}

plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/ka_curve/calculator.ka.csv", "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/ka_curve/calculator.ka.pdf", "ka", "KaKs_Calculator MA ka")
plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/ka_curve/ng86.ka.csv", "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/ka_curve/ng86.ka.pdf", "ka", "NG86 ka")
plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/ka_curve/yn00.ka.csv", "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/ka_curve/yn00.ka.pdf", "ka", "YN00 ka")

plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/ks_curve/calculator.ks.csv", "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/ks_curve/calculator.ks.pdf", "ks","KaKs_Calculator MA ks")
plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/ks_curve/ng86.ks.csv", "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/ks_curve/ng86.ks.pdf", "ks", "NG86 ks")
plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/ks_curve/yn00.ks.csv", "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/ks_curve/yn00.ks.pdf", "ks", "YN00 ks")

plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/omega_curve/calculator.omega.csv", "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/omega_curve/calculator.omega.pdf", "omega", "KaKs_Calculator MA ka/ks")
plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/omega_curve/ng86.omega.csv", "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/omega_curve/ng86.omega.pdf", "omega", "NG86 ka/ks")
plot_total("/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/omega_curve/yn00.omega.csv", "/media/dell/E/Suppmentary_data/05sequence/03kaksomega27curve/omega_curve/yn00.omega.pdf", "omega", "YN00 ka/ks")
