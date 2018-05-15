#library(heatmap3)
library(gplots)
library(pheatmap)
library("RColorBrewer")
my_palette <- colorRampPalette(c("lightblue", "yellow", "red"))(n = 100)

peaks = read.table("atacVisionTableEH.filtered.norm.txt", header = TRUE, sep = "\t", row.names = 1)
#select numeric columns to use
xx=peaks[apply(peaks, 1, var, na.rm=TRUE) != 0,]
#change to numeric
zz = apply(xx, 2, as.numeric)
#cluster rows
km = kmeans(zz, 11, iter.max = 50)
or = order(km$cluster)
#plot
#use 5% and 95% quantiles for max range to plot
qtatact=quantile(zz, c(.05,.95))
qtatact
pairs.breaks=seq(qtatact[[1]],qtatact[[2]],length.out=101)
#set below 5% same as 5, above 95% same as 95
pairs.breaks[1]=min(zz)
pairs.breaks[101]=max(zz)

#png(file="atacHeatmapEH.png", units="in", width=8, height=12, res=90)
#heatmap3(zz[or,],col=my_palette,showColDendro=T,showRowDendro=F,labRow=FALSE,symm=FALSE,Colv=TRUE,Rowv=NA,breaks=pairs.breaks, main="ATAC heatmap" )
jpeg(file="atacHeatmapEH.jpg", units="in", width=6, height=20, res=75)
pheatmap(zz[or,], color=my_palette, breaks=pairs.breaks, cluster_rows = FALSE, trace="none");

dev.off()
q()

# ATAC PCA ----------------------------------------------------------------

data=read.table("atacVisionTableEH.filtered.norm.rev.txt", sep="\t", row.names=1)
pca=prcomp(data, scale=FALSE)
library(ggplot2)
scores=data.frame(pca$x)
cols=ncol(scores)
cells=gsub("_.*", "", rownames(scores))
scores=data.frame(scores,cells)
colnames(scores)[cols+1]="cell"

cells
#[1] "LSK"        "LSK"        "CMP"        "CMP"        "GMP"
#[6] "GMP"        "MEP"        "MEP"        "CFU.E"      "CFU.E"
#[11] "ery"        "ery"        "CFU.Mk"     "CFU.Mk"     "megs"
#[16] "megs"       "neutrophil" "neutrophil" "Mono"       "Mono"

#all=c("#228b22", "#ff7f00", "#ee7600", "#cd6600", "#ee6363", "#cd5555",
          #"#ff3030", "#ee2c2c", "#ff0000", "#8b7355", "#8b5a2b", "#844513",
          #"#008b8b", "#9370db", "#1874cd", "#4f94cd", "#8b1c62", "#8b008b",
          #"#7a378b", "#68228b")
mycolor=c("LSK"="#228b22", "CMP"="#ee7600", "GMP"="#008b8b", 
	  "MEP"="#cd6600", "CFU.E"="#ff3030", "ery"="#ff0000",
          "CFU.Mk"="#8b7355", "megs"="#8b5a2b", "neutrophil"="#4f94cd",
          "Mono"="#1874cd", "#1874cd")

pdf("pcaEH.pdf")
ggplot(scores, aes(x=PC1, y=PC2))+geom_point(aes(color=cell), size=6)+geom_text(aes(label=rownames(scores), hjust=-.2), size=3)+scale_colour_manual(values = mycolor)

ggplot(scores, aes(x=PC2, y=PC3))+geom_point(aes(color=cell), size=6)+geom_text(aes(label=rownames(scores), hjust=-.2), size=3)+scale_colour_manual(values = mycolor)

ggplot(scores, aes(x=PC3, y=PC4))+geom_point(aes(color=cell), size=6)+geom_text(aes(label=rownames(scores), hjust=-.2), size=3)+scale_colour_manual(values = mycolor)

#variance plot
#http://strata.uga.edu/6370/lecturenotes/principalComponents.html
sd=pca$sdev
var=sd^2
var.percent=var/sum(var) * 100
barplot(var.percent, xlab="PC", ylab="Percent Variance", names.arg=1:length(var.percent), las=1, ylim=c(0,max(var.percent)), col="blue")
abline(h=1/ncol(pca)*100, col="red")

dev.off()

