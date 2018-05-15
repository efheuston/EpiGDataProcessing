# Load required libraries -------------------------------------------------

library(limma)
library("gplots")
library(RColorBrewer)

# Import data table -------------------------------------------------------

data<-read.table("atac/atacVisionTable3.filtered.tab", sep="\t", header=TRUE, row.names = 4)

# Normalize data and write out table --------------------------------------

limmares=normalizeQuantiles(data[,4:ncol(data)]) #normalize data
limmares=round(limmares, digits=8) #round to 8 digits
write.table(limmares, "limmares.txt", row.names = TRUE, col.names = TRUE, quote = FALSE, sep="\t") #write out a table called "limmares.txt" to the current directory
newdata<-limmares #save object under new name so the original doesn't get messed up
c=cor(newdata, method="spearman") #correlate data using the spearman method
newdata=as.matrix(newdata) #convert the data to a matrix
newdata=as.numeric(newdata) #ensure that the data is in a numeric format
cr=round(c,digits=2) #round to 2 ditigs
dist.pear<-function(x) as.dist(1-x) #define a distance function


# Create heatmap ----------------------------------------------------------

my_palette <- c("#1000FFFF","#0047FFFF","#00C8FFFF","#00FFE0FF","#00FF89FF","#00FF33FF","#99FF00FF","#AFFF00FF","#FFD800FF","#FFB800FF","#FFAD00FF","#FF8100FF","#FF5600FF","#FF2B00FF","#FF0000FF") #creates a pallet of colors to use; see https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/colorPaletteCheatsheet.pdf for more details

breaks=c(seq(-.1,1, length=16))  #define the spacing you want in the heatmap
length(breaks) #confirm that you have enough spaces
heatmap.2(c, dendrogram="row", col=my_palette, breaks=breaks, trace="none", cellnote=cr, notecol="black", revC=TRUE, notecex=.5, symm=TRUE, distfun=dist.pear, symkey=FALSE) #create the heatmap; see ??heatmap.2() for definitions of each parameter
