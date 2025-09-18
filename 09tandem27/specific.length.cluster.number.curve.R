library(ggplot2)
library(reshape2)
library(ggh4x)
library(grid)
library(ggpattern)
df = read.table("/media/dell/E/Suppmentary_data/09tandem27/curve.txt", header = TRUE, check.names = FALSE, sep = "\t")
head(df)
custom = c("#F3BDA5", "#FFC0CB", "#B7E4C7","#D8B4E2","#1f77b4", "#F9D68D","#FF847C","#E0E0E0","#7FBEEB", "#B19CD9","#F89CAE","#5FC8D1","#FDFD96","#e377c2","#d62728", "#AED9E0")
custom_colors = c(`1` = "#F3BDA5", `2` =  "#B19CD9", `3` ="#B7E4C7", `4` = "#5FC8D1")
df$Species <- factor(df$Species, levels = unique(df$Species))
df$Depth <- factor(df$Depth)


plot = ggplot(df, aes(x=Cluster_length, y=Cluster_number, color = Depth)) +
  labs(x="Cluster length (max proximal distance = 5)", y="Cluster number", color="Depth") +  
  scale_y_continuous(expand=c(0, 0)) +
  scale_x_continuous(expand=c(0, 0)) +
  
  geom_line(aes(x = Cluster_length, y = Cluster_number, group = Species), linewidth = 0.3, alpha = 1) +
  scale_color_manual(values = custom_colors)+
  theme(    
        panel.background = element_blank(),
        panel.spacing = unit(0.05, "lines"),
        panel.border = element_blank(),
        
        strip.text = element_text(size = 21, angle=90, margin = margin(c(0,0,0,0)), colour = "black", face ="italic") ,
        strip.placement = "outside", 
        
        axis.ticks = element_line(linewidth = 0.1),
        axis.ticks.length = unit(0.5, "mm"),
        axis.text.x = element_text(size = 21, angle=90, hjust=0),
        axis.text.y = element_text(size = 21),
        axis.line.x = element_line(color = "black", linewidth = 0.15),
        axis.line.y = element_line(color = "black", linewidth = 0.15),
        axis.title.y = element_text(size=28),
        axis.title.x = element_text(size=28),
       
        
        legend.title = element_text(size = 25),
        legend.text = element_text(size = 21),
        legend.box.spacing = unit(0, "cm"),
        legend.key.spacing.y = unit(1.2, "cm"),
        legend.key.size = unit(2.9, "lines"),
        legend.background = element_rect(fill = "white"),
        plot.title = element_text(size = 30, hjust = 0.5))
# png("/media/dell/E/Suppmentary_data/09tandem27/curve.pdf", width=1800, height=1100, res=300)
pdf("/media/dell/E/Suppmentary_data/09tandem27/curve.pdf", width=18, height=11)
print(plot)
dev.off()


