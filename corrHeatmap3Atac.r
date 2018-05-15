args <- commandArgs(trailingOnly = TRUE)
intab <- args[1]

#normalize data first => filter all zero, add min, log2?, quantile?
data=read.table(intab, sep="\t", header=TRUE, row.names=1)
#remove any constant rows (at least 1 value must be different
#data=data[apply(data, 1, var, na.rm=TRUE) != 0,]

c=cor(data, method="spearman") #pearson is default, use spearman to match ENCODE
data=as.matrix(data)
data=as.numeric(data)

#change the clustering functions
#dist options: euclidean (default), maximum, canberra, binary, minkowski, manhattan
#distance=(dist(c, method="euclidean"))
#distance=function(x) as.dist(1-t(x))

#hclust options: "ward.D", "ward.D2", "single", "complete"(default), "average" (= UPGMA), "mcquitty" (= WPGMA), "median" (= WPGMC) or "centroid" (= UPGMC)
#cluster = hclust(distance, method = "ward.D")
#cluster = hclust(distance, method = "complete")

cr=round(c, digits=2)
library("gplots")
library("RColorBrewer")
#my_palette <- colorRampPalette(c("white", "white", "red"))(n = 29)
#reverse rainbow and stop short of red wrap around
#my_palette <- rev(rainbow(27, s=1, v=1, start=0, end=11/15))
#manually set color to change at .84 to pink
#run once printing auto colors then adjust and hardcode
#my_palette <- colorRampPalette(c("white", "white", "red"))(n = 15)
#my_palette
#my_palette <- c("#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFFFFF", "#FFDADA", "#FFB6B6", "#FF9191", "#FF6D6D", "#FF4848", "#FF2424", "#FF0000", "#FF0000", "#FF0000")
#manual rainbow
#my_palette <- c("#0800FFFF","#0055FFFF","#00E1FFFF","#00FFBFFF","#00FF62FF","#00FF04FF","#59FF00FF","#B7FF00FF","#E6FF00FF","#FFEA00FF","#FFBB00FF","#FF8C00FF","#FF5E00FF","#FF2F00FF","#FF0000FF")
#my_palette <- c("#1000FFFF","#0047FFFF","#00C8FFFF","#00FFE0FF","#00FF89FF","#00FF33FF","#99FF00FF","#AFFF00FF","#D0FF00FF","#FFD800FF","#FFAD00FF","#FF8100FF","#FF5600FF","#FF2B00FF","#FF0000FF")
my_palette <- c("#1000FFFF","#0047FFFF","#00C8FFFF","#00FFE0FF","#00FF89FF","#00FF33FF","#99FF00FF","#AFFF00FF","#FFD800FF","#FFB800FF","#FFAD00FF","#FF8100FF","#FF5600FF","#FF2B00FF","#FF0000FF")

#breaks = c(seq(.7,.8,length=10),seq(.81,1,length=20))
#breaks for RNA
#breaks = c(seq(.7,1,.02))
#breaks for ATAC (larger range)
breaks = c(seq(-.1,1,length=16))
length(breaks)
breaks
length(my_palette)
#heatmap.2(c, dendrogram="row", Rowv=as.dendrogram(cluster), col=my_palette, breaks=breaks, trace="none", cellnote=cr, notecol="black", revC=TRUE, notecex=.5, symm=TRUE, distfun=distance)
dist.pear <- function(x) as.dist(1-x)
#heatmap.2(c, dendrogram="row", col=my_palette, breaks=breaks, trace="none", cellnote=cr, notecol="black", revC=TRUE, notecex=.5, symm=TRUE, distfun=dist.pear)
heatmap.2(c, dendrogram="row", col=my_palette, breaks=breaks, trace="none", cellnote=cr, notecol="black", revC=TRUE, notecex=.5, symm=TRUE, distfun=dist.pear, symkey=FALSE)

q()
