# Visualize data based on cost, mutual information and co-accourrence

library("ggplot2")
library("GGally")

# read data
df_1 <- read.csv(here(
     "data",
     "df_CO_melted.csv"
)) # co-accourrence
df_2 <- read.csv(here(
     "data",
     "df_MI&Cost_melted.csv"
)) # mutual information & cost

# merge data melted
df_all <- merge(df_1, df_2, by = c("Var1", "Var2"), all.x = TRUE)
df_all$MI_diff <- df_all$MI_Hellenistic - df_all$MI_Roman

# save all data
write.csv(df_all, here("data", "df_all_melted.csv"), row.names = FALSE)


#### Visualization ####

# scatter plots
# Hellenistic ggplot
gg1 <- ggplot(df_all, aes(y = Cost, x = MI_Hellenistic, color = CO_Hellenistic)) +
     geom_point(size = 3, alpha = 1) +
     labs(
          x = "Mutal Information",
          y = "Cost Value"
     ) +
     theme(
          legend.position = "right",
          panel.background = element_rect(
               fill = "white",
               colour = "white",
               size = 0.25, linetype = "solid"
          ),
          panel.grid.major = element_line(
               size = 0.25, linetype = "solid",
               colour = "grey80"
          ),
          panel.grid.minor = element_line(
               size = 0.25, linetype = "solid",
               colour = "grey80"
          ),
          axis.text.x = element_text(
               color = "grey10", size = 12, face = "plain", angle = 0
          ),
          axis.text.y = element_text(
               color = "grey10", size = 12, face = "plain"
          ),
          axis.title.x = element_text(
               color = "grey10", size = 12, face = "plain"
          ),
          axis.title.y = element_text(
               color = "grey10", size = 12, face = "plain"
          ),
          strip.background = element_rect(fill = "black"),
          strip.text = element_text(colour = "white")
     )
# save Figure6
ggsave(
     filename = here("visuals", "Figure6.png"), plot = gg1,
     width = 2600, height = 1600, units = "px"
)

# Roman ggplot
gg2 <- ggplot(df_all, aes(y = Cost, x = MI_Roman, color = CO_Roman)) +
     geom_point(size = 3, alpha = 1) +
     labs(
          x = "Mutal Information",
          y = "Cost Value"
     ) +
     theme(
          legend.position = "right",
          panel.background = element_rect(
               fill = "white",
               colour = "white",
               size = 0.25, linetype = "solid"
          ),
          panel.grid.major = element_line(
               size = 0.25, linetype = "solid",
               colour = "grey80"
          ),
          panel.grid.minor = element_line(
               size = 0.25, linetype = "solid",
               colour = "grey80"
          ),
          axis.text.x = element_text(
               color = "grey10", size = 12, face = "plain", angle = 0
          ),
          axis.text.y = element_text(
               color = "grey10", size = 12, face = "plain"
          ),
          axis.title.x = element_text(
               color = "grey10", size = 12, face = "plain"
          ),
          axis.title.y = element_text(
               color = "grey10", size = 12, face = "plain"
          ),
          strip.background = element_rect(fill = "black"),
          strip.text = element_text(colour = "white")
     )
# save Figure7
ggsave(
     filename = here("visuals", "Figure7.png"), plot = gg2,
     width = 2600, height = 1600, units = "px"
)


# Normalize the data for the parallel coordinates plot (MI and Cost)
df_all_norm <- df_all
df_all_norm[, 6] <- df_all_norm[, 6] / max(df_all_norm[, 6])

# Parallel coordinates plot (uniform color)
gg3 <- ggparcoord(
     data = df_all_norm,
     columns = c(7, 6, 8),
     scale = "globalminmax",
     showPoints = TRUE,
     alphaLines = 0.4,
) +
     labs(
          x = "",
          y = ""
     ) +
     theme(
          legend.position = "none",
          panel.background = element_rect(
               fill = "white",
               colour = "white",
               linewidth = 0.25, linetype = "solid"
          ),
          panel.grid.major = element_line(
               linewidth = 0.25, linetype = "solid",
               colour = "grey80"
          ),
          panel.grid.minor = element_line(
               linewidth = 0.25, linetype = "solid",
               colour = "grey80"
          ),
          strip.text.x = element_text(size = 16, face = "plain"),
          axis.text.x = element_text(
               color = "grey10", size = 16, face = "plain", angle = 0, hjust = 0.5
          ),
          axis.text.y = element_text(
               color = "grey10", size = 16, face = "plain"
          ),
          axis.title.x = element_blank(),
          axis.title.y = element_text(
               color = "grey10", size = 16, face = "plain"
          )
     )
# save Figure8
ggsave(
     filename = here("visuals", "Figure8.png"), plot = gg3,
     width = 2600, height = 2600, units = "px"
)


# parallel coordinates plot (selected color)

# high MI in Hellenistic slice
df_all_norm$selected <- ifelse(df_all_norm$MI_Hellenistic > 0.6, 1, 0)

# order data to help visualization
df_all_norm <- df_all_norm[order(df_all_norm$selected, decreasing = TRUE), ]

gg4 <- ggparcoord(
     data = df_all_norm,
     columns = c(7, 6, 8),
     scale = "globalminmax",
     showPoints = TRUE,
     alphaLines = 0.6,
     groupColumn = "selected"
) +
     labs(
          x = "",
          y = ""
     ) +
     theme(
          legend.position = "none",
          panel.background = element_rect(
               fill = "white",
               colour = "white",
               linewidth = 0.25, linetype = "solid"
          ),
          panel.grid.major = element_line(
               linewidth = 0.25, linetype = "solid",
               colour = "grey80"
          ),
          panel.grid.minor = element_line(
               linewidth = 0.25, linetype = "solid",
               colour = "grey80"
          ),
          strip.text.x = element_text(size = 16, face = "plain"),
          axis.text.x = element_text(color = "grey10", size = 16, face = "plain", angle = 0, hjust = 0.5),
          axis.text.y = element_text(color = "grey10", size = 16, face = "plain"),
          axis.title.x = element_blank(),
          axis.title.y = element_text(color = "grey10", size = 16, face = "plain")
     )
# save Figure9
ggsave(
     filename = here("visuals", "Figure9.png"), plot = gg4,
     width = 2600, height = 2600, units = "px"
)

# METHOD: +/-1.5*IQR
lowB <- as.numeric(
     quantile(df_all_norm$Cost,
          probs = 0.25
     ) - 1.5 * IQR(df_all_norm$Cost)
)
uppB <- as.numeric(
     quantile(df_all_norm$Cost,
          probs = 0.75
     ) + 1.5 * IQR(df_all_norm$Cost)
)
df_all_norm$selected <- ifelse(
     (df_all_norm$Cost < lowB | df_all_norm$Cost > uppB),
     1,
     0
)

# order data to help visualization
df_all_norm <- df_all_norm[order(df_all_norm$selected, decreasing = TRUE), ]

gg5 <- ggparcoord(
     data = df_all_norm,
     columns = c(7, 6, 8),
     scale = "globalminmax",
     showPoints = TRUE,
     alphaLines = 0.6,
     groupColumn = "selected"
) +
     labs(
          x = "",
          y = ""
     ) +
     theme(
          legend.position = "none",
          panel.background = element_rect(
               fill = "white",
               colour = "white",
               linewidth = 0.25, linetype = "solid"
          ),
          panel.grid.major = element_line(
               linewidth = 0.25, linetype = "solid",
               colour = "grey80"
          ),
          panel.grid.minor = element_line(
               linewidth = 0.25, linetype = "solid",
               colour = "grey80"
          ),
          strip.text.x = element_text(size = 16, face = "plain"),
          axis.text.x = element_text(color = "grey10", size = 16, face = "plain", angle = 0, hjust = 0.5),
          axis.text.y = element_text(color = "grey10", size = 16, face = "plain"),
          axis.title.x = element_blank(),
          axis.title.y = element_text(color = "grey10", size = 16, face = "plain")
     )
# save Figure10
ggsave(
     filename = here("visuals", "Figure10.png"), plot = gg5,
     width = 2600, height = 2600, units = "px"
)
