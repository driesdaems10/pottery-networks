# Create mutual information matrices (MIM) per time slice and site

library("infotheo")

# get all slice names
slice_names <- c("slice_HELLENISTIC.csv", "slice_ROMAN.csv")

# read filtering data
df_filter_sites <- read.csv(here("data", "ANEE__sites_filtered.csv"))
head(df_filter_sites)

# filter sites
subset_sites <- as.character(df_filter_sites$id)

# read all slice data and arrange in a list
all_slices_original <- list()
for (i in seq_along(slice_names)) {
  slice_i <- read.csv(here("data", slice_names[i]), row.names = 1)
  # ESA
  slice_ESA <- as.data.frame(
    slice_i[
      rownames(slice_i) %in% subset_sites,
      colnames(slice_i) %in% subset_wares_ESA
    ]
  )
  colnames(slice_ESA) <- "ESA"
  # ESB
  slice_ESB <- as.data.frame(rowSums(
    slice_i[
      rownames(slice_i) %in% subset_sites,
      colnames(slice_i) %in% subset_wares_ESB
    ]
  ))
  colnames(slice_ESB) <- "ESB"
  # ESC
  slice_ESC <- as.data.frame(rowSums(
    slice_i[
      rownames(slice_i) %in% subset_sites,
      colnames(slice_i) %in% subset_wares_ESC
    ]
  ))
  colnames(slice_ESC) <- "ESC"
  # ESD
  slice_ESD <- as.data.frame(
    slice_i[
      rownames(slice_i) %in% subset_sites,
      colnames(slice_i) %in% subset_wares_ESD
    ]
  )
  colnames(slice_ESD) <- "ESD"
  # ITS
  slice_ITS <- as.data.frame(rowSums(
    slice_i[
      rownames(slice_i) %in% subset_sites,
      colnames(slice_i) %in% subset_wares_ITS
    ]
  ))
  colnames(slice_ITS) <- "ITS"
  # combine
  slice_i <- cbind(slice_ESA, slice_ESB, slice_ESC, slice_ESD, slice_ITS)
  # save in list
  all_slices_original[[i]] <- slice_i
}


# transform data to binary
all_slices_occurrence <- list()
for (i in seq_along(slice_names)) {
  slice_i <- all_slices_original[[i]]
  all_slices_occurrence[[i]] <- as.data.frame(t(slice_i) > 0)
}

# compute MIM for each time slice
MIM_site <- list()
for (i in seq_along(all_slices_occurrence)) {
  MIM_site[[i]] <- mutinformation(all_slices_occurrence[[i]], method = "emp")
}

# save data
save(MIM_site, file = here("data", "MIM_site.Rdata"))
write.csv(MIM_site[[1]],
  here("data", "MIM_Sites_HELLENISTIC.csv"),
  row.names = TRUE
)
write.csv(MIM_site[[2]],
  here("data", "MIM_Sites_ROMAN.csv"),
  row.names = TRUE
)
write.csv(all_slices_original[[1]],
  here("data", "slice_aggr_HELLENISTIC.csv"),
  row.names = TRUE
) # this is Table 1 of the paper
write.csv(all_slices_original[[2]],
  here("data", "slice_aggr_ROMAN.csv"),
  row.names = TRUE
) # this is Table 2 of the paper


# manual calculation of MI_site to cross-check computation -----
i <- 1
# compute MI between two sites
MIM_site[[i]][1, 3]
df_manual <- cbind(
  as.numeric(all_slices_occurrence[[i]][, 1]),
  as.numeric(all_slices_occurrence[[i]][, 3])
)
colnames(df_manual) <- c("site1", "site2")
colSums(df_manual)
nobs <- dim(df_manual)[1]

# occurrence table
ot <- as.matrix(xtabs(~ site1 + site2, df_manual))
# probability table
pt <- ot / nobs # divide with nobs
pt
# compute MI manually
# The log in the MI function is the natural logarithm with
# base = exp(1) but another base could be used
mi_val <- sum(pt[1, 1] * log(pt[1, 1] / (sum(pt[, 1]) * sum(pt[1, ]))),
  pt[2, 1] * log(pt[2, 1] / (sum(pt[, 1]) * sum(pt[2, ]))),
  pt[1, 2] * log(pt[1, 2] / (sum(pt[, 2]) * sum(pt[1, ]))),
  pt[2, 2] * log(pt[2, 2] / (sum(pt[, 2]) * sum(pt[2, ]))),
  na.rm = TRUE
)
# following test is TRUE so calculation is as expected
round(mi_val, 3) == round(MIM_site[[i]][1, 3], 3)


# self-loops
i <- 1
MIM_site[[i]][1, 1]
df_manual <- cbind(
  as.numeric(all_slices_occurrence[[i]][, 1]),
  as.numeric(all_slices_occurrence[[i]][, 1])
)
colnames(df_manual) <- c("site1_i", "site1_j")
colSums(df_manual)
nobs <- dim(df_manual)[1]
# occurrence table
ot <- as.matrix(xtabs(~ site1_i + site1_j, df_manual))
# probability table
pt <- ot / nobs # divide with nobs
pt
# compute MI manually
# The log in the MI function is the natural logarithm with
# base = exp(1) but another base could be used
mi_val <- sum(pt[1, 1] * log(pt[1, 1] / (sum(pt[, 1]) * sum(pt[1, ]))),
  pt[2, 1] * log(pt[2, 1] / (sum(pt[, 1]) * sum(pt[2, ]))),
  pt[1, 2] * log(pt[1, 2] / (sum(pt[, 2]) * sum(pt[1, ]))),
  pt[2, 2] * log(pt[2, 2] / (sum(pt[, 2]) * sum(pt[2, ]))),
  na.rm = TRUE
)
# following test is TRUE so calculation is as expected
round(mi_val, 3) == round(MIM_site[[i]][1, 1], 3)
