# compare matrices of cost and mutual information

rm(list = ls())

library(corrplot)

readwd = writewd = "C:/Users/u0112360/Documents/____/Sagalassos/__PhD/Articles/__MI-Article/results/"

# network of cost values
costM = read.csv(paste0(readwd, "cost_matrix.csv"), row.names = 1)
# costM = costM/max(costM)

# networks of MI values
MIM_Roman = read.csv(paste0(readwd, "MIM_Sites_ROMAN.csv"), row.names = 1)
# MIM_Roman = MIM_Roman/max(MIM_Roman)
MIM_Hellenistic = read.csv(paste0(readwd, "MIM_Sites_HELLENISTIC.csv"), row.names = 1)
# MIM_Hellenistic = MIM_Hellenistic/max(MIM_Hellenistic)

# # absolute difference
# diff_Hellenistic = as.matrix(costM - MIM_Hellenistic)
# colnames(diff_Hellenistic) = rownames(diff_Hellenistic)
# 
# diff_Roman = as.matrix(costM - MIM_Roman)
# colnames(diff_Roman) = rownames(diff_Roman)


# ratio
diff_Hellenistic = as.matrix(MIM_Hellenistic/costM)
colnames(diff_Hellenistic) = rownames(diff_Hellenistic)

diff_Roman = as.matrix(MIM_Roman/costM)
colnames(diff_Roman) = rownames(diff_Roman)

diff_Hellenistic[is.infinite(diff_Hellenistic)] = NA
diff_Roman[is.infinite(diff_Roman)] = NA

# visualize difference
corrplot(diff_Hellenistic, col = COL2('BrBG', 20), bg = "white", title = "", type = "lower", method = 'color',
         tl.offset = 0.5, tl.col = "black", tl.srt = 0, tl.cex = 0.8, is.corr = FALSE, diag = TRUE, cl.cex = 0.8,
         addCoef.col = 'white', number.cex = 0.65, outline = FALSE, mar = c(1, 1, 1, 1))


corrplot(diff_Roman, col = COL2('BrBG', 20), bg = "white", title = "", type = "lower", method = 'color',
         tl.offset = 0.5, tl.col = "black", tl.srt = 0, tl.cex = 0.8, is.corr = FALSE, diag = TRUE, cl.cex = 0.8,
         addCoef.col = 'white', number.cex = 0.65, outline = FALSE, mar = c(1, 1, 1, 1))

# # save data 
# write.csv(diff_Roman, paste0(writewd, "diff_Roman.csv"), row.names = T)
# write.csv(diff_Hellenistic, paste0(writewd, "diff_Hellenistic.csv"), row.names = T)



# as a next step we can identify clusters according to the differences between cost and MI






