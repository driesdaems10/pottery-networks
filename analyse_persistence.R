# persistence analysis: every pair of nodes (wares) through time
# all combinations in the y-axis and the time in the x-axis

rm(list = ls())

library(igraph)

readwd = writewd = "C:/Users/u0112360/Documents/____/Sagalassos/__PhD/Conferences/ConnectedPast_2023/workdir/Rresults"

load(paste0(readwd, "/", "MIM_time.Rdata"))
# listMatrices = MIM_time

# exclude self loops
# diag_list = list()
for (i in 1:length(MIM_time)) {
  # diag_i = diag(MIM_time[[i]])
  # diag_list[[i]] = diag_i
  diag(MIM_time[[i]]) = 0
}

# define cutoff value
cutoff = 0.02

# name wares
data_names = read.csv("C:/Users/u0112360/Documents/____/Sagalassos/__PhD/Conferences/ConnectedPast_2023/workdir/Rresults/ware_names.csv")
data_names$Fabric_ID = paste0('X', data_names$Fabric_ID)
data_colnames = as.data.frame(colnames(MIM_time[[1]]))
names(data_colnames) = 'Fabric_ID'
data_colnames$order = 1:dim(data_colnames)[1]
data_wares = merge(data_colnames, data_names, by = 'Fabric_ID')
data_wares = data_wares[order(as.numeric(data_wares$order), decreasing = FALSE), ]

# transform data to binary
listMatrices = list()
for (i in 1:length(MIM_time)) { 
  slice_i = MIM_time[[i]]
  colnames(slice_i) = rownames(slice_i) = data_wares$Fabric
  listMatrices[[i]] = slice_i > cutoff
}
rm(MIM_time)


# plot one graph
i = 34
ex_graph = graph_from_adjacency_matrix(listMatrices[[i]],
                                       mode = "undirected",
                                       weighted = TRUE, # NULL
                                       diag = TRUE,
                                       add.colnames = NULL,
                                       add.rownames = NA)
par(mfrow = c(1,1))
plot(ex_graph, vertex.size = 12, label.cex = 0.5, layout = layout_in_circle)

timelength = length(listMatrices)
nodeslength = dim(listMatrices[[1]])[1]

# list of unique links through time
nlinks = (dim(listMatrices[[1]])[1]*(dim(listMatrices[[1]])[1]-1))/2 # number of unique links = 561
k = 0
df_links_persistence = matrix(nrow = nlinks, ncol = timelength, 0)
df_links_persistence_labels = matrix(nrow = nlinks, ncol = 1, "")
for (i in 1:(nodeslength-1)) {
  for (j in (i+1):nodeslength) {
    k = k + 1
    df_links_persistence_labels[k] = paste0(rownames(listMatrices[[1]])[i], "--", rownames(listMatrices[[1]])[j])
    for (t in 1:length(listMatrices)) {
      mat_i = listMatrices[[t]]
      if(mat_i[i,j] == 1) {df_links_persistence[k, t] = 1}
    }
    # print(j)
  }
  print(i)
}

# # save data
df_data = cbind(df_links_persistence_labels, df_links_persistence)
dim(df_data)
# write.csv(df_data, paste0(writewd, "/", "df_links_persistence_20230905.csv"), row.names = FALSE)


# unique links between i and j
df_unique_links = apply(df_links_persistence, 1, sum)
plot(df_unique_links, main = 'amount of links for each pair of nodes')
summary(df_unique_links)
#   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# 0.000   0.000   2.000   3.194   5.000  33.000 


# Numerical persistence: Birth and Death data
diff_links_all = apply(df_links_persistence, 1, diff)
diff_links_all = apply(diff_links_all, 1, sum)
plot(diff_links_all, main = 'difference in number of links through time',
     xlab = 'Time-slice', ylab = 'difference in number of links',
     pch = 19) 
lines(diff_links_all)

# Numerical persistence data
df.persistence = data.frame("index" = 1:dim(df_links_persistence)[1],  
                            "link" = df_links_persistence_labels,
                            "connection.occurrence" = NA,
                            "maximum.connection.length" = NA,
                            "maximum.connection.length.occurrence" = NA,
                            "maximum.connection.start.time" = NA,
                            "maximum.connection.end.time" = NA,
                            "birth.min" = NA,
                            "death.max" = NA,
                            "activity.length" = NA)
list_ConnLength = list()

for (k in 1:(dim(df_links_persistence)[1])) {
  df.persistence.rle.i = rle(as.numeric(df_links_persistence[k,]))
  df.persistence.rle.i = as.data.frame(lapply(df.persistence.rle.i, unlist))
  df.persistence.rle.i$cumlength = cumsum(df.persistence.rle.i$lengths)
  df_connections = subset(df.persistence.rle.i, df.persistence.rle.i$values == 1)
  list_ConnLength[[k]] = list(df_connections$lengths)
  connection.occurrence = dim(df_connections)[1] # number of times links appears
  maximum.connection.length = df_connections$lengths[which.max(df_connections$lengths)] # the maximum amount of time the link is present
  maximum.connection.length.occurrence = sum(df_connections$lengths == maximum.connection.length) # number of times this maximum length occurs
  maximum.connection.start.time = df.persistence.rle.i$cumlength[as.numeric(rownames(df_connections)[which.max(df_connections$lengths)])-1] # maximum connection start time
  maximum.connection.end.time = df.persistence.rle.i$cumlength[as.numeric(rownames(df_connections)[which.max(df_connections$lengths)])] # maximum connection end time
  
  df.persistence$connection.occurrence[k] = connection.occurrence
  df.persistence$maximum.connection.length[k] = ifelse(length(maximum.connection.length) > 0, maximum.connection.length, 0)
  df.persistence$maximum.connection.length.occurrence[k] = maximum.connection.length.occurrence
  df.persistence$maximum.connection.start.time[k] = ifelse(length(maximum.connection.start.time) > 0, maximum.connection.start.time, 0)
  df.persistence$maximum.connection.end.time[k] = ifelse(length(maximum.connection.end.time) > 0, maximum.connection.end.time, 0)
  
  # for every pair of nodes compute what is the first and the last time of connection and the activity length
  if (sum(df_links_persistence[k,]) == 0) {
    df.persistence$birth.min[k] = df.persistence$death.max[k] = df.persistence$activity.length[k] = 0
  } else {
    birth_min = min(which(df_links_persistence[k,] == 1))
    death_max = sum(birth_min, -1, max(which(df_links_persistence[k, birth_min:dim(df_links_persistence)[2]] == 0)))
    if (is.infinite(death_max)) {death_max = dim(df_links_persistence)[2]}
    df.persistence$birth.min[k] = birth_min
    df.persistence$death.max[k] = death_max
    df.persistence$activity.length[k] = death_max - birth_min
  }
  
  print(k)
  
}

# plot the df.persistence variables
par(mfrow = c(2,3))
plot(df.persistence$connection.occurrence, ylab = "connection occurrence", cex.lab = 1.5, pch = 20, col = rgb(red = 0, green = 0, blue = 0, alpha = 0.5))
plot(df.persistence$maximum.connection.length, ylab = "maximum connection length", cex.lab = 1.5, pch = 20, col = rgb(red = 0, green = 0, blue = 0, alpha = 0.5))
plot(df.persistence$maximum.connection.length.occurrence, ylab = "maximum connection length occurrence", cex.lab = 1.5, pch = 20, col = rgb(red = 0, green = 0, blue = 0, alpha = 0.5))
plot(df.persistence$maximum.connection.start.time, ylab = "maximum connection start time", cex.lab = 1.5, pch = 20, col = rgb(red = 0, green = 0, blue = 0, alpha = 0.5))
plot(df.persistence$maximum.connection.end.time, ylab = "maximum connection end time", cex.lab = 1.5, pch = 20, col = rgb(red = 0, green = 0, blue = 0, alpha = 0.5))
plot(df.persistence$activity.length, ylab = "link activity", cex.lab = 1.5, pch = 20, col = rgb(red = 0, green = 0, blue = 0, alpha = 0.5))



layout(mat = matrix(c(1, 2), nrow = 1, ncol = 2), widths = c(4, 1))
par(mar = c(5, 4, 2, 0))
plot(df.persistence$connection.occurrence, ylab = "connection occurrence", cex.lab = 1.5, pch = 20, col = rgb(red = 0, green = 0, blue = 0, alpha = 0.5))
par(mar = c(5, 0, 2, 0))
boxplot(df.persistence$connection.occurrence, ylab = "", xlab = "", frame = F, yaxt = "n")

layout(mat = matrix(c(1, 2), nrow = 1, ncol = 2), widths = c(4, 1))
par(mar = c(5, 4, 2, 0))
plot(df.persistence$maximum.connection.length, ylab = "maximum connection length", cex.lab = 1.5, pch = 20, col = rgb(red = 0, green = 0, blue = 0, alpha = 0.5))
par(mar = c(5, 0, 2, 0))
boxplot(df.persistence$maximum.connection.length, ylab = "", xlab = "", frame = F, yaxt = "n")

layout(mat = matrix(c(1, 2), nrow = 1, ncol = 2), widths = c(4, 1))
par(mar = c(5, 4, 2, 0))
plot(df.persistence$maximum.connection.length.occurrence, ylab = "maximum connection length occurrence", cex.lab = 1.5, pch = 20, col = rgb(red = 0, green = 0, blue = 0, alpha = 0.5))
par(mar = c(5, 0, 2, 0))
boxplot(df.persistence$maximum.connection.length.occurrence, ylab = "", xlab = "", frame = F, yaxt = "n")

layout(mat = matrix(c(1, 2), nrow = 1, ncol = 2), widths = c(4, 1))
par(mar = c(5, 4, 2, 0))
plot(df.persistence$maximum.connection.start.time, ylab = "maximum connection start time", cex.lab = 1.5, pch = 20, col = rgb(red = 0, green = 0, blue = 0, alpha = 0.5))
par(mar = c(5, 0, 2, 0))
boxplot(df.persistence$maximum.connection.start.time, ylab = "", xlab = "", frame = F, yaxt = "n")

layout(mat = matrix(c(1, 2), nrow = 1, ncol = 2), widths = c(4, 1))
par(mar = c(5, 4, 2, 0))
plot(df.persistence$maximum.connection.end.time, ylab = "maximum connection end time", cex.lab = 1.5, pch = 20, col = rgb(red = 0, green = 0, blue = 0, alpha = 0.5))
par(mar = c(5, 0, 2, 0))
boxplot(df.persistence$maximum.connection.end.time, ylab = "", xlab = "", frame = F, yaxt = "n")

layout(mat = matrix(c(1, 2), nrow = 1, ncol = 2), widths = c(4, 1))
par(mar = c(5, 4, 2, 0))
plot(df.persistence$activity.length, ylab = "link activity", cex.lab = 1.5, pch = 20, col = rgb(red = 0, green = 0, blue = 0, alpha = 0.5))
par(mar = c(5, 0, 2, 0))
boxplot(df.persistence$activity.length, ylab = "", xlab = "", frame = F, yaxt = "n")


# put in a list all lengths of connections per link
# then, plot birth and death of link connections in a scatter plot

list.z.L = data.frame(matrix(nrow = length(list_ConnLength), ncol = 1, NA))
for (z in 1:length(list_ConnLength)) {
  list.z.L[z] = length(unlist(list_ConnLength[[z]]))
}
max(list.z.L)

df_all_ConnLength = data.frame(matrix(nrow = length(list_ConnLength), ncol = max(list.z.L), NA))
for (z in 1:length(list_ConnLength)) {
  list.z = unlist(list_ConnLength[[z]])
  L = length(list.z)
  if (L>0) {df_all_ConnLength[z,1:L] = list.z}
}

# plot all connection lengths
library(reshape2)
df_all_ConnLength_melted = melt(df_all_ConnLength)
head(df_all_ConnLength_melted)
df_all_ConnLength_melted$variableNum = as.numeric(gsub("X", "", df_all_ConnLength_melted$variable))
head(df_all_ConnLength_melted)
par(mfrow = c(1,1))
plot(df_all_ConnLength_melted$variableNum, df_all_ConnLength_melted$value, ylab = "link length", xlab = "index", cex.lab = 1.5, pch = 20, col = rgb(red = 0, green = 0, blue = 0, alpha = 0.5))

df_all_ConnLength.mod = df_all_ConnLength
df_all_ConnLength.mod[is.na(df_all_ConnLength)] = 0
sum(rowSums(df_all_ConnLength.mod) == 0) # the number of unique links that never occur; 214 / 359

hist(df_all_ConnLength_melted$value, breaks = 1000)
freqTable = table(df_all_ConnLength_melted$value)
plot(freqTable[as.numeric(names(freqTable)) < 11])
freqTable[freqTable > 10]


# plot persistence diagram as a heatmap
library(reshape2)
df_data_plot = df_data[,-1]
rownames(df_data_plot) = df_data[,1]

# # remove pairs without connections
# df_data_plot = df_data_plot[colSums(as.matrix(df_data_plot)) > 0, ]

# melt data
xx = melt(as.matrix(df_data_plot))
head(xx)

# remove pairs without connections
xx_noNAs = xx[xx$value > 0, ] # (Remove legend from plot)


# keep only ware on interest
head(xx_noNAs)
xx_noNAs$ware1 = NA
xx_noNAs$ware2 = NA
for (i in 1:dim(xx_noNAs)[1]) {
  splt = strsplit(as.character(xx_noNAs$Var1[i]), split = '--')
  xx_noNAs$ware1[i] = splt[[1]][1] 
  xx_noNAs$ware2[i] = splt[[1]][2]
}
head(xx_noNAs)
keep_rows = which((xx_noNAs$ware1  == 'ESA') | (xx_noNAs$ware2 == 'ESA'))
xx_noNAs = xx_noNAs[keep_rows, ]


library(ggplot2)
# ggplot(xx, aes(x = Var1, y = Var2, fill = value)) + 
ggplot(xx_noNAs, aes(x = Var1, y = Var2, fill = value)) + 
  geom_tile() +
  labs(y = "Time",
       x = "Unique pairs") + #,
       # title = "Persistence plot") +
  theme(legend.position = "none", # "bottom"
        legend.direction = "horizontal",
        legend.text=element_text(size = 18, face = "italic"),
        legend.title = element_blank(),
        legend.background = element_blank(),
        legend.box.background = element_rect(colour = "grey10"),
        legend.key.width = unit(1.2,"cm"),
        panel.background = element_rect(fill = "white",
                                        colour = "white",
                                        linewidth = 0.25, linetype = "solid"),
        panel.grid.major = element_blank(), # element_line(size = 0.25, linetype = 'solid',
        #              colour = "grey80"),
        panel.grid.minor = element_blank(), # element_line(size = 0.25, linetype = 'solid',
        #            colour = "grey80"),
        strip.text.x = element_text(size = 18, face = "plain"),
        strip.text.y = element_text(size = 18, face = "plain"),
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(color = "grey10", size = 10, face = "plain", angle = 90, hjust = 0.5),
        axis.text.y = element_text(color = "grey10", size = 10, face = "plain", angle = 90, hjust = 0.5),
        axis.title.x = element_text(color = "grey10", size = 16, face = "plain", angle = 180),
        axis.title.y = element_text(color = "grey10", size = 16, face = "plain"),
        plot.title = element_text(colour = "black", size = 18, face = "italic", hjust = 0.5)) + 
  scale_fill_manual(values = c("#f2bc94","#00154f")) + 
  scale_y_continuous(breaks = round(seq(min(xx$Var2), max(xx$Var2), by = 1), 1)) # +
  # xlim(0, 50)

# persistence plot with different colors per cutoff value, included as facet ----

# rotate persistence plot

# include names of wares in x-axis


dim(df_data_plot)
for (i in 1:50) {
print(paste('timeslice', i, ':', sum(as.numeric(df_data_plot[,i]))))
}
# time slices with zero links: 1-4

plot(df.persistence$maximum.connection.start.time, df.persistence$maximum.connection.end.time)
abline(a = 1, b = 2)


# zoom-in ESA (Fabric_ID = 46)





