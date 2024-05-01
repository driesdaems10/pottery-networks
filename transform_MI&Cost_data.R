# transform MI and Cost to dataset

rm(list = ls())

readwd = writewd = "C:/Users/u0112360/Documents/____/Sagalassos/__PhD/Articles/__MI-Article/results"

library(reshape2)
library(GGally)

# read cost matrix
costM = as.matrix(read.csv(paste0(readwd, "/cost_matrix.csv"), row.names = 1))

# read MIM matrix
MIM_Hellensitic = as.matrix(read.csv(paste0(readwd, "/MIM_Sites_HELLENISTIC.csv"), row.names = 1))
MIM_Roman = as.matrix(read.csv(paste0(readwd, "/MIM_Sites_ROMAN.csv"), row.names = 1))

# exclude self-loops
diag(MIM_Hellensitic) = NA
diag(MIM_Roman) = NA

# rename columns
colnames(costM) = rownames(costM)
colnames(MIM_Hellensitic) = rownames(MIM_Hellensitic)
colnames(MIM_Roman) = rownames(MIM_Roman)

# melt data
costM_melt = melt(costM)
MIM_Hellensitic_melt = melt(MIM_Hellensitic)
MIM_Roman_melt = melt(MIM_Roman)

# exclude NAS
MIM_Hellensitic_melt = na.omit(MIM_Hellensitic_melt)
MIM_Roman_melt = na.omit(MIM_Roman_melt)

# rename column value
colnames(costM_melt)[3] = "Cost"
colnames(MIM_Hellensitic_melt)[3] = "MI_Hellenistic"
colnames(MIM_Roman_melt)[3] = "MI_Roman"

# merge data
df_all = merge(costM_melt, MIM_Hellensitic_melt, by = c("Var1", "Var2"))
df_all = merge(df_all, MIM_Roman_melt, by = c("Var1", "Var2"))
head(df_all)

# # save the dataset
# write.csv(df_all, paste0(writewd, "/df_MI&Cost_melted.csv"), row.names = F)




