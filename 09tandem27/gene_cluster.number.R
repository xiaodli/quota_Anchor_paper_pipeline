library(ggplot2)
library(reshape2)
library(ggh4x)
library(grid)
library(ggpattern)


df = read.table("/media/dell/E/Suppmentary_data/09tandem27/tandem.cluster.number.summary.txt", header = TRUE, check.names = FALSE, sep = "\t")
head(df)

custom_colors = c(`1` = "#F3BDA5", `2` = "#FFC0CB", `3` ="#B7E4C7", `4` = "#AED9E0")
custom_alpha = c(`1` = 1, `2` = 1, `3` = 1, `4` = 1)

df$Species <- factor(df$Species, levels = unique(df$Species))
df$Depth <- factor(df$Depth)


plot = ggplot(df, aes(x=Species, y=Cluster_number)) +
  labs(x="", y="Number of TD and PD genes per species\n(max proximal distance = 5)") +  
  scale_y_continuous(expand=c(0, 0)) +
  
  geom_line(aes(x = Species, y = tandem_total_number, color = Depth, group = Depth), linewidth = 1, alpha = 1) +
  geom_point(aes(x = Species, y = tandem_total_number, color = Depth, group = Depth), size = 3, alpha = 1) +
  
  scale_alpha_manual(values = custom_alpha) +
  scale_color_manual(values = custom_colors)+
  
  guides(
    color = guide_legend(title = "Gene count(Depth)", override.aes = list(alpha = NA), order = 2),
    alpha = "none"
  )+
  
  theme(axis.title.x=element_blank(),          
        panel.background = element_blank(),
        panel.spacing = unit(0.05, "lines"),
        panel.border = element_blank(),
        
        strip.background = element_blank(),
        strip.text = element_blank(),
        strip.placement = "outside", 
        
        axis.ticks.length = unit(0.5, "mm"),
        axis.ticks = element_line(linewidth = 0.1),
        # axis.ticks.x = element_blank(),
        axis.text.x = element_text(size = 20, angle=300, hjust=0, vjust=1, colour = "black", face ="italic"),
        axis.text.y = element_text(size = 20),
        axis.line.x = element_line(color = "black", linewidth = 0.15),
        axis.line.y = element_line(color = "black", linewidth = 0.15),
        axis.title.y = element_text(size=26),
        
        legend.title = element_text(size = 25, hjust=0.5),
        legend.text = element_text(size = 22, hjust=0.5),
        legend.box.spacing = unit(0, "cm"),
        legend.key.spacing.y = unit(2.2, "cm"),
        legend.key.size = unit(3.3, "lines"),
        legend.background = element_rect(fill = "white"),
        
        plot.title = element_text(size = 23, hjust = 0.5)) + 
  coord_cartesian(ylim = c(0, 16100))
# png("/media/dell/E/Suppmentary_data/09tandem27/tandem.number.summary.png", width=2000, height=1400, res=300)
pdf("/media/dell/E/Suppmentary_data/09tandem27/tandem.number.summary.pdf", width=17, height=12)
print(plot)
dev.off()




library(ggplot2)
library(reshape2)
library(ggh4x)
library(grid)
library(ggpattern)


df = read.table("/media/dell/E/Suppmentary_data/09tandem27/tandem.cluster.number.summary.txt", header = TRUE, check.names = FALSE, sep = "\t")
head(df)

custom_colors = c(`1` = "#F3BDA5", `2` = "#FFC0CB", `3` ="#B7E4C7", `4` = "#AED9E0")
custom_alpha = c(`1` = 1, `2` = 1, `3` = 1, `4` = 1)

df$Species <- factor(df$Species, levels = unique(df$Species))
df$Depth <- factor(df$Depth)


plot = ggplot(df, aes(x=Species, y=Cluster_number)) +
  labs(x="", y="Cluster number \n(max proximal distance = 5)") +  
  scale_y_continuous(expand=c(0, 0)) +
  
  geom_line(aes(x = Species, y = Cluster_number, color = Depth, group = Depth), linewidth = 1, alpha = 1) +
  geom_point(aes(x = Species, y = Cluster_number, color = Depth, group = Depth), size = 3, alpha = 1) +
  
  scale_alpha_manual(values = custom_alpha) +
  scale_color_manual(values = custom_colors)+
  
  guides(
    color = guide_legend(title = "Cluster number (Depth)", override.aes = list(alpha = NA), order = 2),
    alpha = "none"
  )+
  
  theme(axis.title.x=element_blank(),          
        panel.background = element_blank(),
        panel.spacing = unit(0.05, "lines"),
        panel.border = element_blank(),
        
        strip.background = element_blank(),
        strip.text = element_blank(),
        strip.placement = "outside", 
        
        axis.ticks.length = unit(0.5, "mm"),
        axis.ticks = element_line(linewidth = 0.1),
        # axis.ticks.x = element_blank(),
        axis.text.x = element_text(size = 20, angle=300, hjust=0, vjust=1, colour = "black", face ="italic"),
        axis.text.y = element_text(size = 20),
        axis.line.x = element_line(color = "black", linewidth = 0.15),
        axis.line.y = element_line(color = "black", linewidth = 0.15),
        axis.title.y = element_text(size=26),
        
        legend.title = element_text(size = 25, hjust=0.5),
        legend.text = element_text(size = 22, hjust=0.5),
        legend.box.spacing = unit(0, "cm"),
        legend.key.spacing.y = unit(2.2, "cm"),
        legend.key.size = unit(3.3, "lines"),
        legend.background = element_rect(fill = "white"),
        
        plot.title = element_text(size = 23, hjust = 0.5)) + 
  coord_cartesian(ylim = c(0, 6100))
# png("/media/dell/E/Suppmentary_data/09tandem27/tandem.number.summary.png", width=2000, height=1400, res=300)
pdf("/media/dell/E/Suppmentary_data/09tandem27/tandem.cluster.number.summary.pdf", width=17, height=12)
print(plot)
dev.off()
