# histogram of MI and natural cutoff values
rm(list = ls())

readwd = "~/data/"
load(paste0(readwd, "MIM_site.Rdata"))

# exclude self loops in the matrices and inspect values ----
diag_list = list()
for (i in 1:length(MIM_site)) {
  diag_i = diag(MIM_site[[i]])
  diag_list[[i]] = diag_i
  diag(MIM_site[[i]]) = 0
}
# save diag_list.RData and analyse separately.

# un-list MI matrix
MIM_vec = unlist(MIM_site)

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


# --- which pairs have MI between 0.005 - max (about 0.20) ----
colnames(MIM_site[[1]])

odd <- function(x) x%%2 != 0
even <- function(x) x%%2 == 0

df_pairs = data.frame("df_i" = NA, "df_j" = NA, "slice" = NA) # "val_i" = NA,
for (i in 1:length(MIM_site)) {
  data_i = MIM_site[[i]]
  data_i[upper.tri(MIM_site[[i]])] = 0
  ind_match = which(data_i > 0.005, arr.ind = T)
  # rangeIDs = rownames(ind_match)
  # odd_ind = odd(1:length(rownames(ind_match)))
  # even_ind = even(1:length(rownames(ind_match)))
  df_i = colnames(data_i)[ind_match[,1]] # rangeIDs[odd_ind]
  df_j = colnames(data_i)[ind_match[,2]] # rangeIDs[even_ind]
  # val_i = MIM_site[[i]][df_i[,1], df_i[,2]]
  # these have duplicate values, structure is wrong
  if(!is.null(length(df_i)) && (dim(as.data.frame(df_i))[1] != 0) ) {
    slice = i
    df_pairs_i = cbind.data.frame(df_i, df_j, slice)
    df_pairs = rbind(df_pairs, df_pairs_i)
  } 
}
df_pairs = na.omit(df_pairs)
head(df_pairs)
# --> make network of this data set for the number of occurrences in MI above cutoff. 
# weight = number of occurrences..

# histogram of log values
hist(log(MIM_vec), breaks = 100)
median(MIM_vec) + 3*sd(MIM_vec)
median(MIM_vec) - 3*sd(MIM_vec)
median(MIM_vec) + 6*sd(MIM_vec)

