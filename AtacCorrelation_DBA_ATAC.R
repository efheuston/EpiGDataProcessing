# Load required libraries -------------------------------------------------

library(limma)
library("gplots")
library(ggplot2)
library(RColorBrewer)

# Import data tables -------------------------------------------------------
setwd("/Users/heustonef/Desktop/NancyAtac/")

create_ATAC_heatmaps<-function(){
  my_merge_file<-as.data.frame(read.table("/Users/heustonef/Desktop/NancyAtac/DBA_ATAC_merge.bed4", sep = "\t", header = FALSE))
  head(my_merge_file)
  
  
  for(x in list.files("/Users/heustonef/Desktop/NancyAtac/bigWigAverageOverBed/")){
    sample_data<-read.table(paste("bigWigAverageOverBed/", x, sep = ""), sep="\t")[,5]
    my_merge_file<-cbind(my_merge_file, sample_data)
  }
  head(my_merge_file)
  
  sample_names<-list.files("bigWigAverageOverBed/")
  sample_names<-gsub("_MACS2_SPMR_treat_pileupSORT.bw.bed", "", sample_names)
  sample_names<-gsub("235_P", "CD235+", sample_names)
  sample_names<-gsub("235_N", "CD235-", sample_names)
  
  colnames(my_merge_file)<-c("chrom", "start", "stop", "name", sample_names)
  head(my_merge_file)
  
  
  # Normalize data and write out table --------------------------------------
  limmares_all=normalizeQuantiles(my_merge_file[,5:ncol(my_merge_file)])
  limmares_posOnly=normalizeQuantiles(my_merge_file[,c(5,7,9,10,12,14)]) #normalize data (CD235+ only)
  limmares_negOnly=normalizeQuantiles(my_merge_file[,c(6,8,11,13)]) #normalize data (CD235- only)
  
  head(my_merge_file[,5:ncol(my_merge_file)])
  limmares=round(limmares, digits=8) #round to 8 digits
  # write.table(limmares, "DBA_ATAC_limmaNormalized.txt", row.names = TRUE, col.names = TRUE, quote = FALSE, sep="\t") #write out a table called "limmares.txt" to the current directory
  newdata<-limmares #save object under new name so the original doesn't get messed up
  c=cor(newdata, method="spearman") #correlate data using the spearman method
  newdata=as.matrix(newdata) #convert the data to a matrix
  newdata=as.numeric(newdata) #ensure that the data is in a numeric format
  cr=round(c,digits=2) #round to 2 ditigs
  dist.pear<-function(x) as.dist(1-x) #define a distance function
  
  
  # Create heatmap ----------------------------------------------------------
  
  my_palette <- c("#1000FFFF","#0047FFFF","#00C8FFFF","#00FFE0FF","#00FF89FF","#00FF33FF","#99FF00FF","#AFFF00FF","#FFD800FF","#FFB800FF","#FFAD00FF","#FF8100FF","#FF5600FF","#FF2B00FF","#FF0000FF") #creates a pallet of colors to use; see https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/colorPaletteCheatsheet.pdf for more details
  
  breaks=c(seq(0,1, length=16))  #define the spacing you want in the heatmap
  # length(breaks) #confirm that you have enough spaces
  
  heatmap.2(c, dendrogram="row", col=my_palette, breaks=breaks, trace="none", cellnote=cr, notecol="black", revC=TRUE, notecex=1, symm=TRUE, symkey=FALSE, margins = c(16,16)) #create the heatmap; see ??heatmap.2() for definitions of each parameter
  
  heatmap.2(c, dendrogram="row", col=my_palette, breaks=breaks, trace="none", cellnote=cr, notecol="black", revC=TRUE, notecex=1, symm=TRUE, distfun=dist.pear, symkey=FALSE, margins = c(12,12)) #create the heatmap; see ??heatmap.2() for definitions of each parameter
  

}




