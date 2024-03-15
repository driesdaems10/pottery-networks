# histogram of MI and natural cutoff values
rm(list = ls())

readwd = "C:/Users/u0112360/Documents/____/Sagalassos/__PhD/Conferences/ConnectedPast_2023/workdir/Rresults"
load(paste0(readwd, "/", "MIM_time.Rdata"))

# exclude self loops in the matrices and inspect values ----
diag_list = list()
for (i in 1:length(MIM_time)) {
  diag_i = diag(MIM_time[[i]])
  diag_list[[i]] = diag_i
  diag(MIM_time[[i]]) = 0
}
# save diag_list.RData and analyse separately.

# un-list MI matrix
MIM_vec = unlist(MIM_time)

# exclude zeros
MIM_vec = MIM_vec[MIM_vec > 0]

# histogram
hist(MIM_vec, breaks = 200)
lines(x = rep(0.02, 11), y = seq(0, 1000, 100), col = 'red')

# histogram of log-values
hist(log(MIM_vec), breaks = 200, col = '#1D8DB0', xlab = 'log(Mutual Information)', main = 'Histogram of MI values across all time slices')
lines(x = rep(log(0.001), 11), y = seq(0, 200, 20), col = '#871717', lwd = 2)
text('0.001', x = log(0.001), y = 210)
lines(x = rep(log(0.01), 11), y = seq(0, 200, 20), col = '#871717', lwd = 2)
text('0.01', x = log(0.01), y = 210)
lines(x = rep(max(log(MIM_vec)), 11), y = seq(0, 200, 20), col = '#871717', lwd = 2)
text(round(max(MIM_vec),3), x = max(log(MIM_vec)), y = 210)
lines(x = rep(min(log(MIM_vec)), 11), y = seq(0, 200, 20), col = '#871717', lwd = 2)
text(expression(8%*%10^-6), x = min(log(MIM_vec)), y = 210)


# density plot
MIM_vec_den = density(MIM_vec)
plot(MIM_vec_den$x, MIM_vec_den$y, type = 'l')
summary(MIM_vec)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.000   0.000   0.005   0.013   0.015   0.195


# --- which pairs have MI between 0.005 - max (about 0.20) ----
colnames(MIM_time[[1]])

odd <- function(x) x%%2 != 0
even <- function(x) x%%2 == 0

df_pairs = data.frame("df_i" = NA, "df_j" = NA, "slice" = NA) # "val_i" = NA,
for (i in 1:length(MIM_time)) {
  data_i = MIM_time[[i]]
  data_i[upper.tri(MIM_time[[i]])] = 0
  ind_match = which(data_i > 0.005, arr.ind = T)
  # rangeIDs = rownames(ind_match)
  # odd_ind = odd(1:length(rownames(ind_match)))
  # even_ind = even(1:length(rownames(ind_match)))
  df_i = colnames(data_i)[ind_match[,1]] # rangeIDs[odd_ind]
  df_j = colnames(data_i)[ind_match[,2]] # rangeIDs[even_ind]
  # val_i = MIM_time[[i]][df_i[,1], df_i[,2]]
  # these have duplicate values, structure is wrong
  if(!is.null(length(df_i)) && (dim(as.data.frame(df_i))[1] != 0) ) {
    slice = i
    df_pairs_i = cbind.data.frame(df_i, df_j, slice)
    df_pairs = rbind(df_pairs, df_pairs_i)
  } 
}
df_pairs = na.omit(df_pairs)
head(df_pairs) # 911 links
# --> make network of this data set for the number of occurrences in MI above cutoff. 
# weight = number of occurrences..

# histogram of log values
hist(log(MIM_vec), breaks = 100)

# Make clusters of 'small', 'medium', 'large' MI value?
# what is a large value for Mutual Information?
# Does 0.5 show the most dependence?

# Determine large based on outlier detection methods?
# see f.i. VM_results_20201201.R: 
# Histogram's gap
# 6sd or mad away from mean or median
# IQR rule?

median(MIM_vec) + 3*sd(MIM_vec) # 0.2805724
median(MIM_vec) - 3*sd(MIM_vec) # -0.267474
median(MIM_vec) + 6*sd(MIM_vec) # 0.5545956

# SOS - exclude self-loops (it seems that 0.28 is only self loops)
# if self-loops are meaningful then include self-loops in the persistence plot



