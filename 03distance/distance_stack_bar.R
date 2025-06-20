library(ggplot2)
library(reshape2)

df = read.table("/media/dell/E/Suppmentary_data/03distance/distance.R.txt", header = TRUE, check.names = FALSE)
head(df)
df = melt(df)                    
df   
custom = c("#F3BDA5", "#FFC0CB", "#B7E4C7","#D8B4E2","#1f77b4", "#F9D68D","#FF847C","#E0E0E0","#7FBEEB", "#B19CD9","#F89CAE","#5FC8D1","#FDFD96","#e377c2","#d62728", "#AED9E0")
custom_colors = c(`10-20` =  "#F3BDA5", `>20` = "#B7E4C7")
df$species_pair <- factor(df$species_pair,  c("os_sb", "os_zm", "sb_zm", "ta_os", "ta_sb", "ta_zm"))
print(levels(df$species_pair))
levels(df$species_pair) <- c("rice vs sorghum", "rice vs maize", "sorghum vs maize", "wheat vs rice", "wheat vs sorghum", "wheat vs maize")
plot = ggplot(df, aes(x=species_pair, y=value, fill=factor(variable,levels = unique(variable)), )) +
  labs(x="", y="Number of adjacent gene pairs with intergenic \ndistances between 10 and 20, or greater than 20", fill="Distance range") +  
  scale_y_continuous(expand=expansion(mult = c(0, 0.1))) + 
  geom_bar(position="stack",stat="identity")  + 
  scale_fill_manual(values = custom_colors) + 
  theme(axis.title.x=element_blank(),          
        panel.background = element_rect(fill = "white"),
        panel.spacing = unit(0.05, "lines"),
        # panel.border = element_blank(),
        panel.border = element_rect(fill=NA,color="black", linewidth=0.15, linetype="solid"),
        strip.text = element_text(size = 7 ) ,
        axis.ticks = element_line(linewidth = 0.1),
        axis.ticks.length = unit(0.5, "mm"),
        # axis.text.x = element_text(size = 9, angle=315, hjust=0.5, vjust=1, colour = "black", face = "italic"),
        axis.text.x = element_text(size = 9, angle=315, hjust=0.5, vjust=1, colour = "black"),
        axis.text.y = element_text(size = 8),
        # axis.text.x = element_text(size = 3),
        axis.line.x = element_line(color = "black", linewidth = 0.15),
        axis.line.y = element_line(color = "black", linewidth = 0.15),
        axis.title.y = element_text(size=10),
        legend.title = element_text(size = 10),
        legend.key.size = unit(1.4, "lines"),
        legend.text = element_text(size = 10),
        # legend.position = c(0.1, 0.8),
        legend.position = "inside", 
        legend.position.inside = c(0.13, 0.8),  
        legend.background = element_rect(linetype = "solid", linewidth = 0.1, colour = "black", fill = NA),
        plot.title = element_text(size = 11, hjust = 0.5))
png("/media/dell/E/Suppmentary_data/03distance/distance.R.png", width=1600, height=1200, res=300)
print(plot)
dev.off()



