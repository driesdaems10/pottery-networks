# plot MIM networks of sites

rm(list = ls())

library(igraph)
library(qgraph)

readwd = writewd = "~/data/"

load(paste0(readwd, "MIM_site.Rdata"))

# exclude self loops
for (i in 1:length(MIM_site)) {
  diag(MIM_site[[i]]) = 0
}

# define cutoff value
cutoff = 0 

# transform data to binary
listMatrices = list()
for (i in 1:length(MIM_site)) { 
  slice_i = MIM_site[[i]]
  listMatrices[[i]] = slice_i # > cutoff
}
rm(MIM_site)


# plot one network
wares_graph = graph_from_adjacency_matrix(listMatrices[[1]], # 213
                                          mode = "undirected",
                                          weighted = TRUE, # NULL
                                          diag = TRUE,
                                          add.colnames = NULL,
                                          add.rownames = NA)

plot(wares_graph, vertex.size = 12, label.cex = 0.5, layout = layout_with_fr)


# save data and Dries inspects



#----------------



# # name wares
# data_names = read.csv("C:/Users/u0112360/Documents/____/Sagalassos/__PhD/Conferences/ConnectedPast_2023/workdir/Rresults/ware_names.csv")
# data_names$Fabric_ID = paste0('X', data_names$Fabric_ID)
# data_colnames = as.data.frame(colnames(listMatrices[[1]]))
# names(data_colnames) = 'Fabric_ID'
# data_colnames$order = 1:dim(data_colnames)[1]
# data_wares = merge(data_colnames, data_names, by = 'Fabric_ID')
# data_wares = data_wares[order(as.numeric(data_wares$order), decreasing = FALSE), ]


# # create new network matrix
# network_wares = matrix(data = 0, nrow = dim(data_wares)[1], ncol = dim(data_wares)[1])
# colnames(network_wares) = rownames(network_wares) = data_wares$Fabric
# for (i in 1:length(listMatrices)) {
#   network_wares = network_wares + as.numeric(listMatrices[[i]])
# }

# # plot network of wares
# wares_graph = graph_from_adjacency_matrix(network_wares,
#                                           mode = "undirected",
#                                           weighted = TRUE, # NULL
#                                           diag = TRUE,
#                                           add.colnames = NULL,
#                                           add.rownames = NA)
# par(mfrow = c(1,1))
# plot(wares_graph, vertex.size = 12, label.cex = 0.5, layout = layout_in_circle)
# plot(wares_graph, vertex.size = 12, label.cex = 0.5, layout = layout_with_fr)

# # net_layout = layout_with_fr(wares_graph)
# # net_layout = norm_coords(net_layout, ymin=-1, ymax=1, xmin=-1, xmax=1)

# edges_wares = get.edgelist(wares_graph, names = FALSE)
# set.seed(1120)
# custom_layout = qgraph.layout.fruchtermanreingold(edges_wares, 
#                                                   # weights = E(wares_graph)$weight,
#                                                   vcount = vcount(wares_graph),
#                                                   area = 20*(vcount(wares_graph)^2),
#                                                   repulse.rad = (vcount(wares_graph)^3.6))
# plot(wares_graph, vertex.shape = "none", 
#      vertex.label.font = 2, vertex.label.color="gray10",
#      vertex.label.cex = 0.7, edge.color="#1D8DB080",
#      edge.width = E(wares_graph)$weight,
#      layout = custom_layout)
# # layout = layout_with_fr)