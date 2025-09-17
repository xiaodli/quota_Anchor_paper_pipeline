library(ggplot2)
library(reshape2)
library(ggh4x)
library(grid)
library(ggpattern)
df = read.table("/media/dell/E/Suppmentary_data/05sequence/06speciation_paleo_SSD_SID/speciation.paleo.ssd.sid.R.txt", header = TRUE, check.names = FALSE, sep = ",")
head(df)

custom = c("#F3BDA5", "#FFC0CB", "#B7E4C7","#D8B4E2","#1f77b4", "#F9D68D","#FF847C","#E0E0E0","#7FBEEB", "#B19CD9","#F89CAE","#5FC8D1","#FDFD96","#e377c2","#d62728", "#AED9E0")
custom_colors = c(`Speciation` =  "#F3BDA5", `Paleo` = "#B7E4C7")

df$Species <- factor(df$Species)
df$Stage <- factor(df$Stage,levels = c("Speciation", "Paleo"))
df$Type <- factor(df$Type, levels = c("SSD", "SID"))
levels(df$Type) <- c("NRIGP", "RIGP")
plot = ggplot(df, aes(x=Stage, y=Ratio, fill = Stage)) +
  facet_nested(~Species, switch="x") +
  labs(x="", y="Ratios of NRIGP and RIGP in paleo-WGD-derived \nand speciation-derived collinear gene pairs(%)", fill="Different stages") +  
  scale_y_continuous(expand=c(0, 0)) +
  geom_bar_pattern(data = df,
                   aes(x = Stage, y = Ratio, pattern = Type),
                   stat = "identity", 
                   position ="stack",
                   pattern_density = 0.03, 
                   pattern_spacing = 0.1,
                   pattern_fill = NA, 
                   pattern_angle = 35,
                   pattern_alpha = 0.51,
                   pattern_colour = "black",
                   pattern_size = 0.2,
                   width = 1,
                   pattern_key_scale_factor = 0.1) +
  scale_pattern_manual(values = c(`RIGP` = "stripe", `NRIGP` = NA)) +
  scale_fill_manual(values = custom_colors) + 
  guides(
    fill = guide_legend(override.aes = list(pattern = "none")),
    pattern = guide_legend(
      title = "Type",
      override.aes = list(fill = "white")
    )
  )+
  theme(axis.title.x=element_blank(),          
        panel.background = element_blank(),
        panel.spacing = unit(0.05, "lines"),
        panel.border = element_blank(),
        strip.background = element_blank(),
        strip.text = element_text(size = 21, angle=90, margin = margin(c(0,0,0,0)), colour = "black", face ="italic") ,
        axis.ticks = element_line(linewidth = 0.1),
        strip.placement = "outside", 
        axis.ticks.length = unit(1.5, "mm"),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 22),
        axis.line.x = element_line(color = "black", linewidth = 0.15),
        axis.line.y = element_line(color = "black", linewidth = 0.15),
        axis.title.y = element_text(size=28),
        
        legend.title = element_text(size =30, margin = margin(b = 1.0, l = 0.5, unit = "cm")),
        legend.spacing.y = unit(2.5, "cm"),
        legend.text = element_text(size = 30),
        legend.box.spacing = unit(1, "cm"),
        legend.key.spacing.y = unit(0.5, "cm"),
        legend.key.size = unit(3.3, "lines"),
        legend.background = element_rect(fill = "white"),
        
        plot.title = element_text(size = 25, hjust = 0.5)) +
  coord_cartesian(ylim = c(0, 101))
# png("/media/dell/E/Suppmentary_data/05sequence/06speciation_paleo_SSD_SID/speciation.paleo.ssd.sid.R.pdf", width=1800, height=1100, res=300)
pdf("/media/dell/E/Suppmentary_data/05sequence/06speciation_paleo_SSD_SID/speciation.paleo.ssd.sid.R.pdf", width=18, height=12)
print(plot)
dev.off()



