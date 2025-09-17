library(ggplot2)
library(reshape2)
library(ggh4x)

df = read.csv("/media/dell/E/Suppmentary_data/08duplicate/diff.txt")
custom_colors_light <- c(DupGen_finder = "#D2E7F2", quota_Anchor = "#B2D8B4")

df = melt(df)                    
df$Type1 <- factor(df$Type1,  c("wgd.genes", "tandem.genes", "proximal.genes", "transposed.genes", "dispersed.genes", "singleton.genes"))                  

p = ggplot(df, aes(x=factor(Tool,levels =unique(Tool)), y=value, fill=Tool))+
  labs(x="",  y="Gene count")
plot = p +  geom_bar(position=position_dodge(width = 1),width=1,stat="identity")  +
  facet_nested(~Type1, switch="x") +
  scale_y_continuous(expand=c(0, 0)) +
  scale_fill_manual(values = custom_colors_light) +
  annotate("segment", x = 1.5, xend = 1.5, y = 0, yend = -50, colour = "black", linewidth = 0.11)+
  theme(panel.background = element_blank(),
        
        legend.title = element_text(size = 30, margin = margin(r = 0.75, b=0.1, t =0, unit = "cm")),
        legend.key.size = unit(1.5, "lines"),
        legend.text = element_text(size = 30),
        legend.box.spacing = unit(0, "cm"),
        legend.key.spacing.y = unit(1.25, "cm"),
        legend.position = "inside", 
        legend.position.inside = c(0.75, 0.88), 
        # legend.background = element_rect(linetype = "solid", linewidth = 0, colour = "black", fill = NA),
        legend.background = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 30),
        axis.title.y = element_text(size=35),
        axis.ticks = element_line(linewidth = 0.2),
        axis.ticks.x = element_blank(),
        axis.line.x = element_line(color = "black", linewidth = 0.5),
        axis.line.y = element_line(color = "black", linewidth = 0.5),
        strip.background = element_blank(),
        strip.placement = "outside", 
        strip.clip="off",
        strip.text = element_text(size = 30, angle=70, margin = margin(c(0,0,0,0)), colour = "black"))
# png("/media/dell/E/Suppmentary_data/08duplicate/diff.pdf", width=1216, height=825, res=100)
pdf("/media/dell/E/Suppmentary_data/08duplicate/diff.pdf", width=18, height=12)
print(plot)
dev.off()

