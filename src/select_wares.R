# filter and merge wares of interest

# The following wares have no chronological information:
# 47, 50, 75, 79, 81, 82, 90, 91
# Therefore, the selected Fabric IDs (from ware_names.csv) are:
subset_wares_ESA <- paste0("X", as.character(46))
subset_wares_ESB <- paste0("X", as.character(c(182, 48, 49)))
subset_wares_ESC <- paste0("X", as.character(c(51:52)))
subset_wares_ESD <- paste0("X", as.character(53))
subset_wares_ITS <- paste0("X", as.character(c(70:74, 76:78, 80, 83:89)))
