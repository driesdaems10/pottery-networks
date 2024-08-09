# visualize and cluster pairs of sites, based on MI, CO, and LCP

rm(list = ls())

readwd = writewd = "~/data/"

# read data
df_1 = read.csv(paste0(readwd, "df_CO_melted.csv"))
df_2 = read.csv(paste0(readwd, "df_MI&Cost_melted.csv"))

# merge data melted 
df_all = merge(df_1, df_2, by = c("Var1", "Var2"), all.x = T)
df_all$MI_diff = df_all$MI_Hellenistic - df_all$MI_Roman

# # save all data
# write.csv(df_all, paste0(writewd, "df_all_melted.csv"), row.names = F)


#### Visualization ####

# scatter plot 
# for Hellenistic slice
plot(df_all[,c("MI_Hellenistic", "Cost")], col = as.factor(df_all$CO_Hellenistic), pch = 19)
# for Roman slice
plot(df_all[,c("MI_Roman", "Cost")], col = as.factor(df_all$CO_Roman), pch = 19)

# Hellenistic ggplot
ggplot(df_all, aes(y = Cost, x = MI_Hellenistic, color = CO_Hellenistic)) +
  geom_point(size = 3, alpha = 1) +
  labs(x = "Mutal Information",
       y = "Cost Value") +
  theme(legend.position = "right",
        panel.background = element_rect(fill = "white",
                                        colour = "white",
                                        size = 0.25, linetype = "solid"),
        panel.grid.major = element_line(size = 0.25, linetype = 'solid',
                                        colour = "grey80"),
        panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                        colour = "grey80"),
        axis.text.x = element_text(color = "grey10", size = 12, face = "plain", angle = 0),
        axis.text.y = element_text(color = "grey10", size = 12, face = "plain"),
        axis.title.x = element_text(color = "grey10", size = 12, face = "plain"),
        axis.title.y = element_text(color = "grey10", size = 12, face = "plain"),
        strip.background = element_rect(fill = "black"),
        strip.text = element_text(colour = 'white'))

# Roman ggplot
ggplot(df_all, aes(y = Cost, x = MI_Roman, color = CO_Roman)) + #
  geom_point(size = 3, alpha = 1) + 
  labs(x = "Mutal Information",
       y = "Cost Value") +
  theme(legend.position = "right",
        panel.background = element_rect(fill = "white",
                                        colour = "white",
                                        size = 0.25, linetype = "solid"),
        panel.grid.major = element_line(size = 0.25, linetype = 'solid',
                                        colour = "grey80"),
        panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
                                        colour = "grey80"),
        axis.text.x = element_text(color = "grey10", size = 12, face = "plain", angle = 0),
        axis.text.y = element_text(color = "grey10", size = 12, face = "plain"),
        axis.title.x = element_text(color = "grey10", size = 12, face = "plain"),
        axis.title.y = element_text(color = "grey10", size = 12, face = "plain"),
        strip.background = element_rect(fill = "black"),
        strip.text = element_text(colour = 'white'))


# Normalize the data for the parallel coordinates plot (MI and Cost)
df_all_norm = df_all
df_all_norm[,6] = df_all_norm[,6]/max(df_all_norm[,6])

# Parallel coordinates plot (uniform color)
ggparcoord(data = df_all_norm,
           columns = c(7, 6, 8),
           scale = "globalminmax", 
           showPoints = TRUE,
           alphaLines = 0.4,
) +
  labs(x = "",
       y = "") +
  theme(legend.position = "none",
        panel.background = element_rect(fill = "white",
                                        colour = "white",
                                        linewidth = 0.25, linetype = "solid"),
        panel.grid.major = element_line(linewidth = 0.25, linetype = 'solid',
                                        colour = "grey80"),
        panel.grid.minor = element_line(linewidth = 0.25, linetype = 'solid',
                                        colour = "grey80"),
        strip.text.x = element_text(size = 16, face = "plain"),
        axis.text.x = element_text(color = "grey10", size = 16, face = "plain", angle = 0, hjust = 0.5),
        axis.text.y = element_text(color = "grey10", size = 16, face = "plain"),
        axis.title.x = element_blank(),
        axis.title.y = element_text(color = "grey10", size = 16, face = "plain"))

# parallel coordinates plot (selected color)
# # MI_Hell high
# df_all_norm$selected = ifelse(df_all_norm$MI_Hellenistic > 0.6, 1, 0)
# METHOD: +/-1.5*IQR
lowB = as.numeric(quantile(df_all_norm$Cost, probs = 0.25) - 1.5*IQR(df_all_norm$Cost))
uppB = as.numeric(quantile(df_all_norm$Cost, probs = 0.75) + 1.5*IQR(df_all_norm$Cost))
df_all_norm$selected = ifelse((df_all_norm$Cost < lowB | df_all_norm$Cost > uppB), 1, 0)
# # METHOD: Hampel filter
# lowBmad = median(df_all_norm$Cost) - 3*mad(df_all_norm$Cost)
# uppBmad = median(df_all_norm$Cost) + 3*mad(df_all_norm$Cost)
# df_all_norm$selected = ifelse((df_all_norm$Cost < lowBmad | df_all_norm$Cost > uppBmad), 1, 0)

# order data to help visualization
df_all_norm = df_all_norm[order(df_all_norm$selected, decreasing = T),]

ggp = ggparcoord(data = df_all_norm,
           columns = c(7, 6, 8),
           scale = "globalminmax", 
           showPoints = TRUE,
           alphaLines = 0.6,
           groupColumn = "selected"
) +
  labs(x = "",
       y = "") +
  theme(legend.position = "none",
        panel.background = element_rect(fill = "white",
                                        colour = "white",
                                        linewidth = 0.25, linetype = "solid"),
        panel.grid.major = element_line(linewidth = 0.25, linetype = 'solid',
                                        colour = "grey80"),
        panel.grid.minor = element_line(linewidth = 0.25, linetype = 'solid',
                                        colour = "grey80"),
        strip.text.x = element_text(size = 16, face = "plain"),
        axis.text.x = element_text(color = "grey10", size = 16, face = "plain", angle = 0, hjust = 0.5),
        axis.text.y = element_text(color = "grey10", size = 16, face = "plain"),
        axis.title.x = element_blank(),
        axis.title.y = element_text(color = "grey10", size = 16, face = "plain"))
ggp 