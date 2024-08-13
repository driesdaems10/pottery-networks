# ancient_routes_paper

The repository contains material supportive to publication **_(Include Reference)_** _Unravelling the Threads of Connectivity: A Mutual Information Approach to Tracing Material Networks in the Late Hellenistic and Early Roman Mediterranean_. Initial discussion of the methodology and preliminary results were preseneted in _Connected Past 2023_ **_(Include Reference)_**.

## Repository structure

### ./data/
The folder contains data files created from two public data sources using scripts. 
The original data sources are [Orbis](https://orbis.stanford.edu/) and [Icrates](https://archaeologydataservice.ac.uk/archives/view/icrates_lt_2018/) which provide the basis to create the processed least cost path (CO) and mutual information (MI) data. The files used in the scripts provided in this repository are listed below.

|  data file        | source script             |
|-------------------|---------------------------|
| MIM_site.Rdata    |   ......                  |
| df_all_melted.csv |  transfrom_MI&Cost_dta.R  |
| df_CO_melted.csv  |  compute_coocurrence.R    |

> consider making a selection of the processed data incuded in this repositry? 

### ./GIS/
> this process comes before the files at /data/. Shouldn't we also refer to the process followed for ICRATES?

The folder contains shapefiles to reconstruct the least-cost path networks used in the paper and a workflow document that allows others to reproduce our analysis.

|  data file                 | description                                                             |
|----------------------------|-------------------------------------------------------------------------|
| ICRATES_Sites.shp          | Sites filtered from Icrates dataset                                     |
| LCP_Network.shp            | LCP network                                                             |
| ORBIS.shp                  | ORBIS geospatial network data                                           |
| ORBIS_ShortestDistance.shp | Shortest distances between filtered sites using the ORBIS network model |


### ./src/
| script                   | purpose                                            |
|--------------------------|----------------------------------------------------|
| analyse_pairs-of-sites.R | visualize pairs of sites, based on MI and CO |
| compare_matrices.R       | compare cost and mutual information matrices       |
| create_MI_networks.R     |  Create mutual information matrices (MIM) eiether per (1) time slice or (2) site |
| network_of_sites.R       | plot MIM networks of sites |
| analyse_persistence.R    | persistence analysis for every pair of nodes (wares) through time (Connected Past 2023) |
| compute_coocurrence.R    | calculate co-occurrence of wares for each pair of sites |
| create_time-slices.R     | ICRATES time slices per fabric and location (**exclude script and refer to other repo ?**) |
| transform_MI&Cost_data.R | process data to create a dataframe |
| choose_MI_cutoff.R       | histogram of MI and natural cutoff values |
| create_cost_network.R    | transform cost value paths to matrix format |