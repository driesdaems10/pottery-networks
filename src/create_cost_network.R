# transform cost value paths to matrix format

rm(list = ls())

readwd = writewd = "C:/Users/u0112360/Documents/____/Sagalassos/__PhD/Articles/__MI-Article/results/"

# read filtering data
df_filter_sites = read.csv(paste0(writewd, "/JAS_sites_filtered.csv"))
head(df_filter_sites)
df_filter_wares = read.csv("C:/Users/u0112360/Documents/____/Sagalassos/__PhD/Conferences/ConnectedPast_2023/workdir/Rresults/ware_names.csv")
head(df_filter_wares)
# filter sites
subset_sites = sort(as.character(df_filter_sites$id))

# create empty matrix
costM = matrix(data = NA, nrow = length(subset_sites), ncol = length(subset_sites))
colnames(costM) = rownames(costM) = subset_sites

# read cost value list
df = read.csv(paste0(readwd, "costMatrix_JAS-LCP.csv"))

# fill in the matrix
for (i in 1:dim(df)[1]){
  ci = df[i,1]
  cj = df[i,2]
  val = df[i,3]
  
  ciidx = which(colnames(costM) == ci)
  cjidx = which(colnames(costM) == cj)
  
  costM[ciidx, cjidx] = costM[cjidx, ciidx] = val
}

# # save matrix
# write.csv(costM, paste0(writewd, "cost_matrix.csv"), row.names = T)

summary(df[,3])
hist(df[,3], breaks = 40)

# visualize cost matrix

corrplot(costM, col = COL2('BrBG', 20), bg = "white", title = "", type = "lower", method = 'color',
         tl.offset = 0.5, tl.col = "black", tl.srt = 0, tl.cex = 0.8, is.corr = FALSE, diag = TRUE, cl.cex = 0.8,
         addCoef.col = 'white', number.cex = 0.65, outline = FALSE, mar = c(1, 1, 1, 1))



