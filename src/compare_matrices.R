# Compare matrices of cost and mutual information

library("corrplot")

# network of cost values
costM <- read.csv(here("data", "cost_matrix.csv"), row.names = 1)

# networks of MI values
MIM_Roman <- read.csv(here("data", "MIM_Sites_ROMAN.csv"), row.names = 1)
MIM_Hellenistic <- read.csv(here("data", "MIM_Sites_HELLENISTIC.csv"), row.names = 1)

# ratio difference
diff_Hellenistic <- as.matrix(MIM_Hellenistic / costM)
colnames(diff_Hellenistic) <- rownames(diff_Hellenistic)

diff_Roman <- as.matrix(MIM_Roman / costM)
colnames(diff_Roman) <- rownames(diff_Roman)

diff_Hellenistic[is.infinite(diff_Hellenistic)] <- NA
diff_Roman[is.infinite(diff_Roman)] <- NA

# save data
write.csv(diff_Hellenistic,
    here("data", "diff_Hellenistic.csv"),
    row.names = TRUE
)
write.csv(diff_Roman,
    here("data", "diff_Roman.csv"),
    row.names = TRUE
)

# visualize difference
png(here("visuals", "Figure4.png"), width = 1562, height = 1562, units = "px")
corrplot(diff_Hellenistic,
    col = COL2("BrBG", 20), bg = "white",
    title = "", type = "lower", method = "color",
    tl.offset = 0.5, tl.col = "black", tl.srt = 0, tl.cex = 0.8,
    is.corr = FALSE, diag = TRUE, cl.cex = 0.8, addCoef.col = "white",
    number.cex = 0.65, outline = FALSE, mar = c(1, 1, 1, 1)
)
dev.off()

png(here("visuals", "Figure5.png"), width = 1562, height = 1562, units = "px")
corrplot(diff_Roman,
    col = COL2("BrBG", 20), bg = "white",
    title = "", type = "lower", method = "color",
    tl.offset = 0.5, tl.col = "black", tl.srt = 0, tl.cex = 0.8,
    is.corr = FALSE, diag = TRUE, cl.cex = 0.8, addCoef.col = "white",
    number.cex = 0.65, outline = FALSE, mar = c(1, 1, 1, 1)
)
dev.off()
