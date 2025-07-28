# Transform cost value paths to matrix format

library("here")
library("corrplot")

# read filtering data
df_filter_sites <- read.csv(here("data", "ANEE__sites_filtered.csv"))
head(df_filter_sites)
df_filter_wares <- read.csv(here("data", "ware_names.csv"))
head(df_filter_wares)
# filter sites
subset_sites <- sort(as.character(df_filter_sites$id))

# create empty matrix
costM <- matrix(
  data = NA,
  nrow = length(subset_sites),
  ncol = length(subset_sites)
)
colnames(costM) <- rownames(costM) <- subset_sites

# read cost value list
df <- read.csv(here("data", "costMatrix_ANEE-LCP.csv"))

# fill in the matrix
for (i in 1:dim(df)[1]) {
  ci <- df[i, 1]
  cj <- df[i, 2]
  val <- df[i, 3]

  ciidx <- which(colnames(costM) == ci)
  cjidx <- which(colnames(costM) == cj)

  costM[ciidx, cjidx] <- costM[cjidx, ciidx] <- val
}

# save matrix
write.csv(costM, here("data", "cost_matrix.csv"), row.names = TRUE)

# visualize cost matrix
png(here("visuals", "Figure3.png"), width = 1562, height = 1562, units = "px")
corrplot(costM, col = COL2("BrBG", 20), bg = "white",
  title = "", type = "lower", method = "color",
  tl.offset = 0.5, tl.col = "black", tl.srt = 0, tl.cex = 0.8,
  is.corr = FALSE, diag = TRUE, cl.cex = 0.8,
  addCoef.col = "white", number.cex = 0.65, outline = FALSE, mar = c(1, 1, 1, 1)
)
dev.off()
