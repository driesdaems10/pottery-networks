# Network comparison (draft)

rm(list = ls())

library(NetworkDistance)

# references
# package manual: https://cran.r-project.org/web/packages/NetworkDistance/NetworkDistance.pdf
# package publication: An introduction to spectral distances in networks (2011)

# check: 'adjacency matrix of mutual information'


readwd = "C:/Users/u0112360/Documents/____/Sagalassos/__PhD/Conferences/ConnectedPast_2023/workdir/Rresults"

load(paste0(readwd, "/", "MIM_time.Rdata"))

listMatrices = MIM_time
rm(MIM_time)

# --- SOS might need to transform the metric ? ---
# the library needs adjacency matrices as input / do these classify as such? ---

# Edge Difference Distance ####
## compute distance matrix
output = nd.edd(listMatrices, out.dist=FALSE)
## visualize
opar = par(no.readonly=TRUE)
par(pty = "s")
image(output$D, main = "Edge Difference Distance", axes = TRUE, col = gray(0:32/32))
par(opar)


# Extremal distance with top-k eigenvalues ####
## compute distance matrix
output = nd.extremal(listMatrices, out.dist = FALSE, k = 2)
## visualize
opar = par(no.readonly=TRUE)
par(pty = "s")
image(output$D, main = "Extremal distance with top-k eigenvalues", col = gray(0:32/32), axes=FALSE)
par(opar)


# Graph Diffusion Distance ####
## compute distance matrix
output = nd.gdd(listMatrices, out.dist=FALSE) # takes some time
## visualize
opar = par(no.readonly = TRUE)
par(pty = "s")
image(output$D, main = "Graph Diffusion Distance", col = gray((0:32)/32), axes = FALSE)
par(opar)


# Hamming Distance ####
## compute distance matrix
output = nd.hamming(listMatrices, out.dist=FALSE)
# for binary data ...
## visualize
opar = par(no.readonly = TRUE)
par(pty = "s")
image(output$D, main = "Hamming Distance", axes = FALSE, col = gray(0:32/32))
par(opar)


# Log Moments Distance ####
## compute distance based on different k's.
out3 = nd.moments(listMatrices, k = 3, out.dist = FALSE)
out5 = nd.moments(listMatrices, k = 5, out.dist = FALSE)
out7 = nd.moments(listMatrices, k = 7, out.dist = FALSE)
out9 = nd.moments(listMatrices, k = 9, out.dist = FALSE)

## visualize
opar = par(no.readonly = TRUE)
par(mfrow = c(2,2), pty = "s")
image(out3$D, col = gray(0:32/32), axes = FALSE, main = "Log Moments Distance, k=3")
image(out5$D, col = gray(0:32/32), axes = FALSE, main = "Log Moments Distance, k=5")
image(out7$D, col = gray(0:32/32), axes = FALSE, main = "Log Moments Distance, k=7")
image(out9$D, col = gray(0:32/32), axes = FALSE, main = "Log Moments Distance, k=9")
par(opar)


# Network Flow Distance ####
# compute two diffusion-based distances and visualize
out1 = nd.gdd(listMatrices, out.dist = FALSE) # takes some time
out2 = nd.nfd(listMatrices, out.dist = FALSE) # takes a lot of time
# visualize
opar = par(no.readonly=TRUE)
par(mfrow = c(1,2), pty = "s")
image(out1$D, col = gray((0:32)/32), main = "Graph Diffusion Distance", axes = FALSE)
image(out2$D, col = gray((0:32)/32), main = "Network Flow Distance", axes = FALSE)
par(opar)


# Distance with Weighted Spectral Distribution #### 
## compute distance matrix
output = nd.wsd(listMatrices, out.dist=FALSE, K=10)
## visualize
opar = par(no.readonly=TRUE)
par(pty="s")
image(output$D, main="Distance with Weighted Spectral Distribution", axes=FALSE, col=gray(0:32/32))
par(opar)

