library(ggplot2)
library(viridis)
library(ggpubr)


plot_total <- function (file, out_file, parameter3, parameter4, parameter5=3.3){

custom = c("#F3BDA5", "#FFC0CB", "#B7E4C7","#D8B4E2","#1f77b4", "#F9D68D","#FF847C","#E0E0E0","#7FBEEB", "#B19CD9","#F89CAE","#5FC8D1","#FDFD96","#e377c2","#d62728", "#AED9E0")

data =read.table(file, header = TRUE, sep = ",")
data$Type <- factor(data$Type)
print(levels(data$Type))
custom_colors <- c(Significant = "#F8766D", `Non-significant` = "#00BFC4")
custom_colors_light <- c(Significant = "#D2E7F2", `Non-significant` = "#B2D8B4")
custom_colors_dark <- c(Significant = "#A6CEE3", `Non-significant` = "#7DCA7C")
print(data)


plot <- ggplot(data, aes(x="", y=Ratio, fill=Type, color=Type)) + 
  facet_wrap(~Species, nrow = 3, ncol = 9, scales = "fixed",
             shrink = FALSE, as.table = TRUE, drop = TRUE) +
  geom_bar(width = 0.01, stat = "identity", linewidth=0.1) +
  coord_polar("y", start = 0)+
  geom_text(aes(label=paste0(Number, "\n", "(",  Ratio, "%)")), position=position_stack(vjust=0.5), size = 1, color="#F8766D")+
  # geom_text(aes(y = lab.ypos, label = prop), color = "white")+
  # scale_fill_manual(values = custom_colors_dark) +
  # theme_void()

  # scale_fill_viridis(discrete = TRUE) +
  scale_fill_manual(values = custom_colors_light) +
  scale_color_manual(values = custom_colors_dark) +
  theme(axis.title.x=element_blank(),
        # panel.background = element_rect(fill = "white"),
        panel.background = element_blank(),
        panel.spacing = unit(0.05, "lines"),
        # panel.border = element_blank(),
        panel.border = element_rect(fill=NA,color="black", linewidth=0.1, linetype="solid"),

        legend.title = element_text(size = 7, margin = margin(r = 0.6, unit = "cm")),
        legend.key.size = unit(0.5, "lines"),
        legend.text = element_text(size = 5),
        # legend.position = c(0.1, 0.8),
        # legend.position = "inside",
        # legend.position.inside = c(0.1, 0.8),
        # legend.background = element_rect(linetype = "solid", linewidth = 0.1, colour = "black", fill = NA),
        legend.position="bottom",
        legend.box.spacing = unit(0, "cm"),
        legend.key.spacing.x = unit(1, "cm"),
        # legend.position = "inside",
        # legend.position.inside = c(0.1, 0.8),
        legend.background = element_rect(linetype = "solid", linewidth = 0, colour = "black", fill = NA),

        # strip.background = element_rect(linewidth = 0.1, linetype="solid"),
        strip.background = element_blank(),
        strip.text = element_text(size = 6.2, face = "italic"),
        # axis.ticks = element_line(linewidth = 0.1),
        axis.ticks = element_blank(),
        # axis.ticks.length = unit(0.2, "mm"),
        # axis.ticks.x = element_blank(),
        # axis.text.x = element_text(size = 4, angle=300, hjust=0, vjust=1, colour = "black"),
        # axis.text.y = element_text(size = 6),
        axis.text = element_blank(),
        axis.line.x = element_line(color = "black", linewidth = 0.1),
        axis.line.y = element_line(color = "black", linewidth = 0.1),
        axis.title = element_blank())
        # legend.position = 'none') +
  # labs(y = parameter3)
  # coord_cartesian(ylim = c(0, parameter5))
png(out_file, width=1800, height=1000, res=300)
print(plot)
dev.off()
}

plot_total("/media/dell/E/Suppmentary_data/05sequence/05kssignificant/calculator.ks.txt", "/media/dell/E/Suppmentary_data/05sequence/05kssignificant/calculator.ks.png", "KaKs_calculator MA method", "useless")
plot_total("/media/dell/E/Suppmentary_data/05sequence/05kssignificant/ng86.ks.txt", "/media/dell/E/Suppmentary_data/05sequence/05kssignificant/ng86.ks.png", "NG86  method", "useless")
plot_total("/media/dell/E/Suppmentary_data/05sequence/05kssignificant/yn00.ks.txt", "/media/dell/E/Suppmentary_data/05sequence/05kssignificant/yn00.ks.png", "YN00  method", "useless")



