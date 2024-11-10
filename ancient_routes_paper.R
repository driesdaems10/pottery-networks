# This script combines all R components into our workflow

library("here")

# Create list of ware names and save
data_catalogue <- read.csv(
    here("data/ICRATES", "ICRATES_CATALOGUE.csv"),
    header = TRUE, sep = ","
)
data_catalogue <- data_catalogue[, c("Fabric_ID", "Fabric")]
data_catalogue <- data_catalogue[!duplicated(data_catalogue), ]
write.csv(data_catalogue, here("data", "ware_names.csv"), row.names = FALSE)

# Transform least cost value paths to matrix format
source(here("src", "create_cost_network.R"))

# Create ICRATES time slices per fabric and location
source(here("src", "create_time-slices.R"))

# Filter and merge wares of interest: ESA, ESB, ESC, ESD, ITS
source(here("src", "select_wares.R"))

# Create mutual information matrices (MIM) per time slice and site
source(here("src", "create_MI_networks.R"))

# Calculate co-occurrence of wares for each pair of sites
source(here("src", "compute_coocurrence.R"))

# Transform MI and Cost to dataset
source(here("src", "transform_MI&Cost_data.R"))

# Compare matrices of cost and mutual information
source(here("src", "compare_matrices.R"))

# Visualize data based on cost, mutual information and co-accourrence
source(here("src", "analyse_pairs-of-sites.R"))
