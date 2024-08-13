# Create mutual information matrices (MIM) per (1) time slice and (2) site
rm(list = ls())

readwd = writewd = "~/data/"

library(infotheo)
library(tidyr)

# read all slice names
slice_names = list.files(readwd)

# # order names of slices in chronological order
# slice_names = as.data.frame(slice_names)
# names(slice_names) = 'file'
# slice_names$original = slice_names$file
# slice_names = slice_names %>% tidyr::separate(file, into = c("i", "s", "n", "r", "dates"), sep = "_") 
# slice_names$dates = substr(slice_names$dates, 1, nchar(slice_names$dates)-4)
# slice_names$n = as.numeric(slice_names$n)
# orderid = order(slice_names$n)
# slice_names = slice_names[orderid,]


# read filtering data
df_filter_sites = read.csv(paste0(writewd, "JAS_sites_filtered.csv"))
head(df_filter_sites)
df_filter_wares = read.csv(paste0(readwd, "ware_names.csv"))
head(df_filter_wares)
# filter sites
subset_sites = as.character(df_filter_sites$id)
# filter wares
# # wares: 47, 50, 75, 79, 81, 82, 90, 91 ? --> No chronological information
# subset_wares_ESA = paste0("X", as.character(c(46:47)))
# subset_wares_ESB = paste0("X", as.character(c(182,48,49,50)))
# subset_wares_ESC = paste0("X", as.character(c(51:52)))
# subset_wares_ESD = paste0("X", as.character(53))
# subset_wares_ITS = paste0("X", as.character(c(70:91)))
subset_wares_ESA = paste0("X", as.character(46))
subset_wares_ESB = paste0("X", as.character(c(182,48,49)))
subset_wares_ESC = paste0("X", as.character(c(51:52)))
subset_wares_ESD = paste0("X", as.character(53))
subset_wares_ITS = paste0("X", as.character(c(70:74, 76:78, 80, 83:89)))


# read all data and arrange in a list
all_slices_original = list()
for (i in 1:length(slice_names)) {
  slice_i = read.csv(paste0(readwd, "/", slice_names[i]), row.names = 1)
  slice_ESA = as.data.frame(slice_i[rownames(slice_i) %in% subset_sites, colnames(slice_i) %in% subset_wares_ESA])
  colnames(slice_ESA) = "ESA"
  slice_ESB = as.data.frame(rowSums(slice_i[rownames(slice_i) %in% subset_sites, colnames(slice_i) %in% subset_wares_ESB]))  
  colnames(slice_ESB) = "ESB"
  slice_ESC = as.data.frame(rowSums(slice_i[rownames(slice_i) %in% subset_sites,colnames(slice_i) %in% subset_wares_ESC]))  
  colnames(slice_ESC) = "ESC"
  slice_ESD = as.data.frame(slice_i[rownames(slice_i) %in% subset_sites,colnames(slice_i) %in% subset_wares_ESD])
  colnames(slice_ESD) = "ESD"  
  slice_ITS = as.data.frame(rowSums(slice_i[rownames(slice_i) %in% subset_sites,colnames(slice_i) %in% subset_wares_ITS]))
  colnames(slice_ITS) = "ITS"
  slice_i = cbind(slice_ESA, slice_ESB, slice_ESC, slice_ESD, slice_ITS)
  all_slices_original[[i]] = slice_i
}


# transform data to binary
all_slices_occurrence = list()
for (i in 1:length(slice_names)) { 
  slice_i = all_slices_original[[i]]
  all_slices_occurrence[[i]] = as.data.frame(t(slice_i) > 0)  
}

# compute MIM for each time slice
MIM_site = list()
for (i in 1:length(all_slices_occurrence)) {
  MIM_site[[i]] = mutinformation(all_slices_occurrence[[i]], method = "emp")
}

# # save data
# save(MIM_site, file = paste0(writewd, "/", "MIM_site.Rdata"))
# write.csv(MIM_site[[1]], paste0(writewd, "/", "MIM_Sites_HELLENISTIC.csv"), row.names = T)
# write.csv(MIM_site[[2]], paste0(writewd, "/", "MIM_Sites_ROMAN.csv"), row.names = T)
write.csv(all_slices_original[[1]], paste0(writewd, "/", "slice_aggr_HELLENISTIC.csv"), row.names = T)
write.csv(all_slices_original[[2]], paste0(writewd, "/", "slice_aggr_ROMAN.csv"), row.names = T)



# manual calculation of MI_site -----
# check youTube video 'Mutual Information, Clearly Explained' from StatQuest.
?mutinformation
i = 1
all_slices_occurrence[[i]]
MIM_site[[i]]
# compute MI between site 1 and 100
MIM_site[[i]][1,3]
df_manual = cbind(as.numeric(all_slices_occurrence[[i]][,1]), as.numeric(all_slices_occurrence[[i]][,3]))
colnames(df_manual) = c("site1", "site2")
colSums(df_manual)
nobs = dim(df_manual)[1]

# occurrence table
ot = as.matrix(xtabs(~ site1 + site2, df_manual))
# probability table
pt = ot/nobs # divide with nobs
pt
# compute MI manually
# The log in the MI function is the natural logarithm with base = exp(1) but another base could be used
mi_val = sum(pt[1,1]*log(pt[1,1]/(sum(pt[,1])*sum(pt[1,]))),
             pt[2,1]*log(pt[2,1]/(sum(pt[,1])*sum(pt[2,]))),
             pt[1,2]*log(pt[1,2]/(sum(pt[,2])*sum(pt[1,]))),
             pt[2,2]*log(pt[2,2]/(sum(pt[,2])*sum(pt[2,]))),
             na.rm = TRUE)
mi_val
MIM_site[[i]][1,3]


# self-loops
i = 1
MIM_site[[i]][1,1]
df_manual = cbind(as.numeric(all_slices_occurrence[[i]][,1]), as.numeric(all_slices_occurrence[[i]][,1]))
colnames(df_manual) = c("site1_i", "site1_j")
colSums(df_manual)
nobs = dim(df_manual)[1]
# occurrence table
ot = as.matrix(xtabs(~ site1_i + site1_j, df_manual))
# probability table
pt = ot/nobs # divide with nobs
pt
# compute MI manually
# The log in the MI function is the natural logarithm with base = exp(1) but another base could be used
mi_val = sum(pt[1,1]*log(pt[1,1]/(sum(pt[,1])*sum(pt[1,]))),
             pt[2,1]*log(pt[2,1]/(sum(pt[,1])*sum(pt[2,]))),
             pt[1,2]*log(pt[1,2]/(sum(pt[,2])*sum(pt[1,]))),
             pt[2,2]*log(pt[2,2]/(sum(pt[,2])*sum(pt[2,]))),
             na.rm = TRUE)
mi_val
MIM_site[[i]][1,1]


