# calculate co-occurrence of wares for each pair of sites

rm(list = ls())

readwd = writewd = "~/data/"

# read slices
slice_Hellenistic = read.csv(paste0(readwd, "slice_aggr_HELLENISTIC.csv"))
colnames(slice_Hellenistic)[1] = "SiteCode"
slice_Roman = read.csv(paste0(readwd, "slice_aggr_ROMAN.csv"))
colnames(slice_Roman)[1] = "SiteCode"

# transform to Presence/Absence
slice_Hellenistic_PA = slice_Hellenistic
slice_Roman_PA = slice_Roman
slice_Hellenistic_PA[,2:6] = slice_Hellenistic_PA[,2:6]>0
slice_Roman_PA[,2:6] = slice_Roman_PA[,2:6]>0

# compute co-occurrence between pairs of sites
## initialize dataset
cooc_Hellenistic = data.frame(matrix(ncol = 3, nrow = 0))
colnames(cooc_Hellenistic) = c("Var1", "Var2", "CO_Hellenistic")
cooc_Roman = cooc_Hellenistic
colnames(cooc_Roman)[3] = "CO_Roman"

## Hellenistic
for (i in 1:(dim(slice_Hellenistic_PA)[1]-1)) {
  for (j in (i+1):dim(slice_Hellenistic_PA)[1]) {
    newline = data.frame("Var1" = slice_Hellenistic_PA$SiteCode[i], 
                         "Var2" = slice_Hellenistic_PA$SiteCode[j], 
                         "CO_Hellenistic" = (sum(slice_Hellenistic_PA[i,2:6] == slice_Hellenistic_PA[j, 2:6]))/5)
    cooc_Hellenistic = rbind.data.frame(cooc_Hellenistic, newline)
  }  
}
## Roman
for (i in 1:(dim(slice_Roman_PA)[1]-1)) {
  for (j in (i+1):dim(slice_Roman_PA)[1]) {
    newline = data.frame("Var1" = slice_Roman_PA$SiteCode[i], 
                         "Var2" = slice_Roman_PA$SiteCode[j], 
                         "CO_Roman" = (sum(slice_Roman_PA[i,2:6] == slice_Roman_PA[j, 2:6]))/5)
    cooc_Roman = rbind.data.frame(cooc_Roman, newline)
  }  
}


# merge co-occurrence data melted
cooc_all = merge(cooc_Hellenistic, cooc_Roman, by = c("Var1", "Var2"))
cooc_all$CO_diff = cooc_all$CO_Hellenistic - cooc_all$CO_Roman

# # save dataset
# write.csv(cooc_all, paste0(writewd, "df_CO_melted.csv"), row.names = F)



