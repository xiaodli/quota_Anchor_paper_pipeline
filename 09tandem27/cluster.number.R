library(ggplot2)
library(reshape2)
library(ggh4x)
library(grid)
library(ggpattern)


df = read.table("/media/dell/E/Suppmentary_data/09tandem27/tandem.cluster.number.summary.txt", header = TRUE, check.names = FALSE, sep = "\t")
head(df)

custom_colors = c(`1` = "#F3BDA5", `2` = "#FFC0CB", `3` ="#B7E4C7", `4` = "#AED9E0")
custom_alpha = c(`1` = 0.5, `2` = 0.5, `3` = 0.5, `4` = 0.5)

df$Species <- factor(df$Species, levels = unique(df$Species))
df$Depth <- factor(df$Depth)

max_cluster_num <- max(df$Cluster_number)
max_tandem_length <- max(df$Cluster_length_max)
scale_factor <- max_cluster_num / max_tandem_length

plot = ggplot(df, aes(x=Species, y=Cluster_number)) +
  labs(x="", y="Clusters number(Depth)") +  
  scale_y_continuous(expand=c(0, 0), sec.axis = sec_axis(~ . / scale_factor, name="Max cluster length(Depth)")) +

  geom_bar(data = df, aes(x = Species, y = Cluster_number, fill = Depth, alpha = Depth), position="identity",stat="identity")  + 
  
  geom_line(aes(x = Species, y = Cluster_length_max * scale_factor, color = Depth, group = Depth), linewidth = 0.3, alpha = 0.5) +
  geom_point(aes(x = Species, y = Cluster_length_max * scale_factor, color = Depth, group = Depth), size = 0.5, alpha = 0.5) +

  scale_fill_manual(values = custom_colors) +
  scale_alpha_manual(values = custom_alpha) +
  scale_color_manual(values = custom_colors)+
  
  guides(
    fill = guide_legend(title = "Clusters number(Depth)", override.aes = list(alpha = NA, color = NA), order = 1),
    color = guide_legend(title = "Max cluster length(Depth)", override.aes = list(alpha = NA), order = 2),
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
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(size = 9, angle=300, hjust=0, vjust=1, colour = "black", face ="italic"),
        axis.text.y = element_text(size = 9),
        axis.line.x = element_line(color = "black", linewidth = 0.15),
        axis.line.y = element_line(color = "black", linewidth = 0.15),
        axis.title.y = element_text(size=11),
        
        legend.title = element_text(size = 8.5, hjust=0.5),
        legend.text = element_text(size = 7.5, hjust=0.5),
        legend.box.spacing = unit(0, "cm"),
        legend.key.spacing.x = unit(1.2, "cm"),
        legend.background = element_rect(fill = "white"),
        
        plot.title = element_text(size = 12, hjust = 0.5)) + 
coord_cartesian(ylim = c(0, 6000))
png("/media/dell/E/Suppmentary_data/09tandem27/tandem.cluster.number.summary.png", width=2000, height=1400, res=300)
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
custom_alpha = c(`1` = 0.5, `2` = 0.5, `3` = 0.5, `4` = 0.5)

df$Species <- factor(df$Species, levels = unique(df$Species))
df$Depth <- factor(df$Depth)


plot = ggplot(df, aes(x=Species, y=Cluster_number)) +
  labs(x="", y="Number of TD and PD genes per species\n(max proximal distance = 5)") +  
  scale_y_continuous(expand=c(0, 0)) +
  
  geom_line(aes(x = Species, y = tandem_total_number, color = Depth, group = Depth), linewidth = 0.3, alpha = 0.5) +
  geom_point(aes(x = Species, y = tandem_total_number, color = Depth, group = Depth), size = 0.5, alpha = 0.5) +
  
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
        axis.text.x = element_text(size = 7, angle=300, hjust=0, vjust=1, colour = "black", face ="italic"),
        axis.text.y = element_text(size = 7),
        axis.line.x = element_line(color = "black", linewidth = 0.15),
        axis.line.y = element_line(color = "black", linewidth = 0.15),
        axis.title.y = element_text(size=9),
        
        legend.title = element_text(size = 7, hjust=0.5),
        legend.text = element_text(size = 6.5, hjust=0.5),
        legend.box.spacing = unit(0, "cm"),
        legend.key.spacing.x = unit(1.2, "cm"),
        legend.background = element_rect(fill = "white"),
        
        plot.title = element_text(size = 12, hjust = 0.5)) + 
  coord_cartesian(ylim = c(0, 16000))
png("/media/dell/E/Suppmentary_data/09tandem27/tandem.number.summary.png", width=2000, height=1400, res=300)
print(plot)
dev.off()
# scale_pattern_manual(values = c(`1` = "crosshatch", `2` = "stripe", `3` = "circle", `4` = "none")) +

# guides(
#   fill = guide_legend(title = "Depth", override.aes = list(pattern = c("crosshatch", "stripe", "circle", "none"))),
#   pattern = guide_legend(title = "Depth", override.aes = list(fill = custom_colors, color = NA)),
#   color = guide_legend(title = "Gene Count")
# )+

# geom_bar_pattern(data = df,
#                  aes(x = Species, y = Cluster_number, pattern = Depth, alpha = Depth),
#                  stat = "identity", 
#                  position ="identity",
#                  pattern_density = 0.2,
#                  pattern_spacing = 0.03,
#                  pattern_fill = "grey", 
#                  pattern_angle = 20,
#                  pattern_alpha = 0.5,
#                  pattern_colour = "black",
#                  pattern_size = 0.05,
#                  width = 0.6,
#                  pattern_key_scale_factor = 0.5) +