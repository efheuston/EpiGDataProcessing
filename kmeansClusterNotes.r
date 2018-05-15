#library not installed by default at BX, needed for colorpanel
library('gplots')
library('heatmap3')
#table with chrom position and several numerical values for each position
xx = read.table('rsem.genes.de.txt.normalized_data_matrix.fdr.05.names.txt', header=TRUE, row.names=1, sep="\t")
#select numeric columns to use
yy = xx
#change to numeric
zz = apply(yy, 2, as.numeric)
#too many outliers need to normalize before kmeans
min=min(zz[zz>0])
zz=log10(zz+min)
#column scale
zz=scale(zz)
summary(zz)
#determine k to use for kmeans???
# Determine number of clusters from (http://www.statmethods.net/advstats/cluster.html)
wss <- (nrow(zz)-1)*sum(apply(zz,2,var))
pdf(file="NumOfClusters.pdf")
for (i in 2:15) wss[i] <- sum(kmeans(zz, centers=i, iter.max = 50)$withinss)
plot(1:15, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares")
dev.off()
#look for bend in plot
# K-Means Cluster Analysis
w = kmeans(zz, 8, iter.max = 50)
or = order(w$cluster)
#make an alternating color bar to match clusters
cluBar=vector()
for (i in 1:nrow(zz)) {
   if (w$cluster[i] %% 2 == 0) { cluBar[i] = "blue"; }
   else { cluBar[i] = "gray"; }
}
print("Done kmeans clustering")
#plot
#use 5% and 95% quantiles for max range to plot
qt=quantile(zz, c(.05,.95))
pairs.breaks=seq(qt[[1]],qt[[2]],length.out=101)
#set below 5% same as 5, above 95% same as 95
pairs.breaks[1]=min(zz)
pairs.breaks[101]=max(zz)
print("Ready to plot heatmap")
pdf(file="diffExpHeatmap3.pdf")
heatmap3(zz[or,],col=colorpanel(100,low="lightblue",mid="yellow",high="red"),showColDendro=T,showRowDendro=F,labRow=FALSE,symm=FALSE,Colv=TRUE,Rowv=NA,breaks=pairs.breaks, RowSideColors=cluBar[or], RowSideLab="clusters")
#heatmap.2(zz[or,],trace="none",col=colorpanel(100,low="lightblue",mid="yellow",high="red"),key=TRUE,dendrogram="none",labRow=FALSE,symm=FALSE,Colv=NA,Rowv=NA,breaks=pairs.breaks, RowSideColors=cluBar[or])
dev.off()

#print clusters
pd=cbind(xx, w$cluster)
pd=pd[or,]
write.table(pd, file="geneClusters.txt", sep="\t")
q()
