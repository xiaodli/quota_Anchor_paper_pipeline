
i_vals <- seq(1, 9, by = 2)  # 1, 3, 5, 7, 9
x <- c()
y <- c()

for (i in i_vals) {
  for (j in i_vals) {
    if (j > i) {
      x <- c(x, i)
      y <- c(y, j)
    }
  }
}

df <- data.frame(x = x, y = y)

highlight_points <- data.frame(
  x = c(1, 3, 5, 7),
  y = c(3, 5, 7, 9)
)


df$highlight <- ifelse(
  paste(df$x, df$y) %in% paste(highlight_points$x, highlight_points$y),
  "highlight", "normal"
)

library(ggplot2)

p <- ggplot(df, aes(x = x, y = y)) +
  geom_point(aes(color = highlight, shape = highlight), size = 6) +
  scale_color_manual(values = c("highlight" = "#5FC8D1", "normal" = "#FFC0CB"), guide = FALSE) +
  scale_shape_manual(values = c("highlight" = 16, "normal" = 4), guide = FALSE) +
  
  scale_x_continuous(
    limits = c(0, 10),
    breaks = seq(0, 9, by = 1),
    name = "Gene rank",
    expand = expansion(mult = 0)
  ) +
  scale_y_continuous(
    limits = c(0, 10),
    breaks = seq(0, 9, by = 1),
    name = "Gene rank",
    expand = expansion(mult = 0)
  ) +
  
  theme_minimal() +
  theme(
    axis.title = element_text(size = 25),
    axis.text = element_text(size = 20, color = "black"),
    axis.line.x = element_line(color = "black", linewidth = 0.4),
    axis.line.y = element_line(color = "black", linewidth = 0.4),
    panel.grid.major = element_line(linewidth = 0.2, color = "gray"),
    panel.grid.minor = element_blank(),
    plot.margin = margin(1, 1, 1, 1, "cm"),
    
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.4)
  ) +
  
  coord_fixed(ratio = 1)

ggsave('class_dot.pdf', plot = p, width = 10, height = 10, dpi = 300)
print(p)
