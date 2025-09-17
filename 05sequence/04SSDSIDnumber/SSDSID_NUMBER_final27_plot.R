library(ggplot2)
library(viridis)
library(ggpubr)


plot_total_pdf <- function (file, out_file, parameter3, parameter4, parameter5=3.3){

custom = c("#F3BDA5", "#FFC0CB", "#B7E4C7","#D8B4E2","#1f77b4", "#F9D68D","#FF847C","#E0E0E0","#7FBEEB", "#B19CD9","#F89CAE","#5FC8D1","#FDFD96","#e377c2","#d62728", "#AED9E0")

data =read.table(file, header = TRUE, sep = ",")
data$Type <- factor(data$Type)

levels(data$Type) <- c("RIGP", "NRIGP")
custom_colors <- c(RIGP = "#F8766D", NRIGP = "#00BFC4")
custom_colors_light <- c(NRIGP = "#D2E7F2", RIGP = "#B2D8B4")
custom_colors_dark <- c(NRIGP = "#A6CEE3", RIGP = "#7DCA7C")
print(data)


plot <- ggplot(data, aes(x="", y=Ratio, fill=Type, color=Type)) + 
  facet_wrap(~Species, nrow = 3, ncol = 9, scales = "fixed",
             shrink = FALSE, as.table = TRUE, drop = TRUE) +
  geom_bar(width = 0.01, stat = "identity", linewidth=0.1) +
  coord_polar("y", start = 0)+
  geom_text(aes(label=paste0(Number, "\n", "(",  Ratio, "%)")), position=position_stack(vjust=0.5), size = 3.5, color="#F8766D")+
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

        legend.title = element_text(size = 25, margin = margin(r = 0.6, unit = "cm")),
        legend.key.size = unit(2.5, "lines"),
        legend.text = element_text(size = 20),
        # legend.position = c(0.1, 0.8),
        # legend.position = "inside",
        # legend.position.inside = c(0.1, 0.8),
        # legend.background = element_rect(linetype = "solid", linewidth = 0.1, colour = "black", fill = NA),
        legend.position="bottom",
        legend.box.spacing = unit(0, "cm"),
        legend.key.spacing.x = unit(1, "cm"),
        # legend.position = "inside",
        # legend.position.inside = c(0.1, 0.8),
        legend.background = element_blank(),


        # strip.background = element_rect(linewidth = 0.1, linetype="solid"),
        strip.background = element_blank(),
        strip.text = element_text(size = 17, face = "italic"),
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
# png(out_file, width=1800, height=1200, res=300)
pdf(out_file, width=16, height=12)
print(plot)
dev.off()
}

plot_total_pdf("/media/dell/E/Suppmentary_data/05sequence/04SSDSIDnumber/identity.txt", "/media/dell/E/Suppmentary_data/05sequence/04SSDSIDnumber/identity.pdf", "Identity", "identity", 1.3)
