# Load required libraries -------------------------------------------------

library(limma)
library("gplots")
library(ggplot2)
library(RColorBrewer)
library(colorspace)

create_heatmaps<-function(my_bed4_file, big_wig_directory, correlation_type="spearman", figure_name, alter_name){

# Read in bed4 file -------------------------------------------------------

  my_bed4_file<-as.data.frame(read.table(my_bed4_file, sep = "\t", header = FALSE)) #load file from script labeled concatenatedBedFile_SORT.bed4
  head(my_bed4_file) #view table to ensure it has 4 columns
  print("I loaded my merge file!\n")


# Append samples to table ---------------------------------------------------

  for(x in list.files(big_wig_directory, pattern = "\\.bed$")){ #perform the following 2 steps for every ".bed" file created with the script
    print(paste("Appending ", x, " to table"))
    sample_data<-read.table(paste(big_wig_directory, x, sep = ""), sep="\t")[,5] #open the .bed file and take only the 5th column (contains the peak score)
    my_bed4_file<-cbind(my_bed4_file, sample_data) #add the 5th column to concatenatedBedFile_SORT.bed4 table within R
  }
  print("I created my concatenated file!\n")
  
# Add sample names to the table -------------------------------------------
  sample_names<-list.files(big_wig_directory) #make a list of each ".bed" file name
  sample_names<-gsub(alter_name, "", sample_names) #remove the boring ending from each file name
  colnames(my_bed4_file)<-c("chrom", "start", "stop", "name", sample_names) # add column names to each column in your table

# Normalize data and write out table --------------------------------------

  my_palette <- c("#1000FFFF","#0047FFFF","#00C8FFFF","#00FFE0FF","#00FF89FF","#00FF33FF","#99FF00FF","#AFFF00FF","#FFD800FF","#FFB800FF","#FFAD00FF","#FF8100FF","#FF5600FF","#FF2B00FF","#FF0000FF") #make color palette
  breaks=c(seq(0,1, length=16))  #define the spacing you want in the heatmap

  all_samples_normalized=normalizeQuantiles(my_bed4_file[,5:ncol(my_bed4_file)])
  all_samples_normalized=round(all_samples_normalized, digits=8) #round to 8 digits
  newdata<-all_samples_normalized #save object under new name so the original doesn't get messed up
  c=cor(newdata, method=correlation_type) #correlate data using the spearman method
  newdata=as.matrix(newdata) #convert the data to a matrix
  newdata=as.numeric(newdata) #ensure that the data is in a numeric format
  cr=round(c,digits=2) #round to 2 ditigs
  dist.pear<-function(x) as.dist(1-x) #define a distance function

# Make heatmap using all samples ------------------------------------------

  print("Here comes a picture!")
  plot_title<-paste(figure_name, "_", correlation_type, sep="")
  png(paste(plot_title, ".png", sep=""), width=800, height=800)
  heatmap.2(c, dendrogram="row", col=my_palette, breaks=breaks, trace="none", cellnote=cr, notecol="black", revC=TRUE, notecex=1, symm=TRUE, symkey=FALSE, margins = c(16,16), main=plot_title) #create the heatmap
  dev.off()
}


create_heatmaps("atac_concatMERGE.bed4", "./", correlation_type="spearman", figure_name = "atac", alter_name = "mm10.bed")
setwd("../temphold/")


bed4<-read.table("atac_concatMERGE.bed4", sep = "\t")
dim(bed4)
# 



# Try again …20171004 -----------------------------------------------------


setwd("../NancyAtac/")
my_bed4_file<-as.data.frame(read.table("DBA_ATAC_merge.bed4", sep = "\t", header = FALSE)) #load file from script labeled concatenatedBedFile_SORT.bed4
head(my_bed4_file) #view table to ensure it has 4 columns
print("I loaded my merge file!\n")
for(x in list.files("bigWigAverageOverBed/", pattern = "\\.bed$")){ #perform the following 2 steps for every ".bed" file created with the script
  sample_data<-read.table(paste("bigWigAverageOverBed/", x, sep = ""), sep="\t")[,5] #open the .bed file and take only the 5th column (contains the peak score)
  my_bed4_file<-cbind(my_bed4_file, sample_data) #add the 5th column to concatenatedBedFile_SORT.bed4 table within R
}
  
head(my_bed4_file)
sample_names<-list.files("bigWigAverageOverBed/") #make a list of each ".bed" file name
sample_names<-gsub("_MACS2_SPMR_treat_pileupSORT.bw.bed", "", sample_names) #remove the boring ending from each file name
sample_names<-gsub("235_P", "CD235+", sample_names) #make sample names easier to read
sample_names<-gsub("235_N", "CD235-", sample_names) #make sample names easier to read
colnames(my_bed4_file)<-c("chrom", "start", "stop", "name", sample_names) # add column names to each column in your table
head(my_bed4_file) # look at the newly modified table and make sure it has the correct number of columns and that each column has a 

trimmed_merge_file<-my_bed4_file[,5:14]
N<-q00
trimmed_merge_file=trimmed_merge_file[apply(trimmed_merge_file, 1, var, na.rm=TRUE) != 0,]


head(trimmed_merge_file)


DNA_matrix<-data.matrix(trimmed_merge_file)
DBA_variance<-apply(DNA_matrix, 1, var)
DBA_top_variable_gens<-names(sort(DBA_variance)[1:N])
primary_DBA_variance_top_variable_genes<-DNA_matrix[DBA_top_variable_gens,]
s=quantile(primary_DBA_variance_top_variable_genes, c(.25))
e=quantile(primary_DBA_variance_top_variable_genes, c(.75))
cnt=30
step = (e - s)/cnt
breaks = c(seq(s,e,by=step))

heatmap.2(primary_DBA_variance_top_variable_genes, dendrogram="both", scale="none", trace="none", breaks=breaks, col=diverge_hcl, symkey = FALSE, labRow="", key.title = "", margins = c(16,16))
png(paste("DBA-HM.png", sep = ""), width = 1251, height = 954)
heatmap.2(primary_DBA_variance_top_variable_genes, dendrogram="both", scale="none", trace="none", breaks=breaks, col=diverge_hcl, symkey = FALSE, labRow="", key.title = "", main = atac_table)
dev.off()




head(trimmed_merge_file)
z.mat <- t(scale(t(trimmed_merge_file), center=TRUE, scale=TRUE )) 
#Z-transform--the scale function transforms column values, but we want to transform our rows, hence the double transpositions

s=quantile(z.mat, c(.10))
e=quantile(z.mat, c(.90))
cnt=30
step = (e - s)/cnt
breaks = c(seq(s,e,by=step))
#my_palette <- c("#1000FFFF","#0047FFFF","#00C8FFFF","#00FFE0FF","#00FF89FF","#00FF33FF","#99FF00FF","#AFFF00FF","#FFD800FF","#FFB800FF","#FFAD00FF","#FF8100FF","#FF5600FF","#FF2B00FF","#FF0000FF")
#breaks = c(seq(-4,4,length=76))
dist.pear <- function(x) as.dist(1-x)
library(colorspace)

##creates heatmap of gene expression vs cell type
heatmap.2(z.mat, dendrogram="both", scale="none", trace="none", breaks=breaks, col=diverge_hcl, symkey = FALSE, labRow="", key.title = "", main = RNA_table)

png(paste(RNA_table,"-HM.png", sep = ""), width = 1251, height = 954)
heatmap.2(z.mat, dendrogram="both", scale="none", trace="none", breaks=breaks, col=diverge_hcl, symkey = FALSE, labRow="", key.title = "", main = RNA_table)
dev.off()




# 20171129 ----------------------------------------------------------------

setwd("../Lab Stuff/NancyAtac/")
my_bed4_file<-as.data.frame(read.table("DBA_ATAC_merge.bed4", sep = "\t", header = FALSE)) #load file from script labeled concatenatedBedFile_SORT.bed4
head(my_bed4_file) #view table to ensure it has 4 columns
print("I loaded my merge file!\n")
for(x in list.files("usethese/", pattern = "\\.bed$")){ #perform the following 2 steps for every ".bed" file created with the script
  sample_data<-read.table(paste("usethese/", x, sep = ""), sep="\t")[,5] #open the .bed file and take only the 5th column (contains the peak score)
  my_bed4_file<-cbind(my_bed4_file, sample_data) #add the 5th column to concatenatedBedFile_SORT.bed4 table within R
}
  
head(my_bed4_file)
sample_names<-list.files("bigWigAverageOverBed/") #make a list of each ".bed" file name
sample_names<-gsub("_MACS2_SPMR_treat_pileupSORT.bw.bed", "", sample_names) #remove the boring ending from each file name
sample_names<-gsub("235_P", "CD235+", sample_names) #make sample names easier to read
sample_names<-gsub("235_N", "CD235-", sample_names) #make sample names easier to read
colnames(my_bed4_file)<-c("chrom", "start", "stop", "name", "502_CD235+", "632_CD235+", "CTRL4_CD235+") # add column names to each column in your table
head(my_bed4_file) # look at the newly modified table and make sure it has the correct number of columns and that each column has a 

trimmed_merge_file<-my_bed4_file[,5:7]
N<-100
trimmed_merge_file=trimmed_merge_file[apply(trimmed_merge_file, 1, var, na.rm=TRUE) != 0,]


head(trimmed_merge_file)


DNA_matrix<-data.matrix(trimmed_merge_file)
DBA_variance<-apply(DNA_matrix, 1, var)
DBA_top_variable_gens<-names(sort(DBA_variance)[1:N])
head(DBA_top_variable_gens)
primary_DBA_variance_top_variable_genes<-DNA_matrix[DBA_top_variable_gens,]
s=quantile(primary_DBA_variance_top_variable_genes, c(.25))
e=quantile(primary_DBA_variance_top_variable_genes, c(.75))
cnt=30
step = (e - s)/cnt
breaks = c(seq(s,e,by=step))

heatmap.2(primary_DBA_variance_top_variable_genes, dendrogram="both", scale="none", trace="none", breaks=breaks, col=diverge_hcl, symkey = FALSE, labRow="", key.title = "", margins = c(16,16))
png(paste("DBA-HM.png", sep = ""), width = 1251, height = 954)
heatmap.2(primary_DBA_variance_top_variable_genes, dendrogram="both", scale="none", trace="none", breaks=breaks, col=diverge_hcl, symkey = FALSE, labRow="", key.title = "", main = atac_table)
dev.off()



head(primary_DBA_variance_top_variable_genes)

head(trimmed_merge_file)
z.mat <- t(scale(t(trimmed_merge_file), center=TRUE, scale=TRUE )) 
#Z-transform--the scale function transforms column values, but we want to transform our rows, hence the double transpositions

s=quantile(z.mat, c(.10))
e=quantile(z.mat, c(.90))
cnt=30
step = (e - s)/cnt
breaks = c(seq(s,e,by=step))
#my_palette <- c("#1000FFFF","#0047FFFF","#00C8FFFF","#00FFE0FF","#00FF89FF","#00FF33FF","#99FF00FF","#AFFF00FF","#FFD800FF","#FFB800FF","#FFAD00FF","#FF8100FF","#FF5600FF","#FF2B00FF","#FF0000FF")
#breaks = c(seq(-4,4,length=76))
dist.pear <- function(x) as.dist(1-x)
library(colorspace)

##creates heatmap of gene expression vs cell type
heatmap.2(z.mat, dendrogram="both", scale="none", trace="none", breaks=breaks, col=diverge_hcl, symkey = FALSE, labRow="", key.title = "", main = RNA_table)

png(paste(RNA_table,"-HM.png", sep = ""), width = 1251, height = 954)
heatmap.2(z.mat, dendrogram="both", scale="none", trace="none", breaks=breaks, col=diverge_hcl, symkey = FALSE, labRow="", key.title = "", main = RNA_table)
dev.off()


typeof(my_bed4_file)
thedataframe<-as.data.frame(my_bed4_file)
head(thedataframe)
george<-subset(thedataframe, subset=thedataframe[,4] %in% DBA_top_variable_gens)
write.table(george, file="AtacSubset_top100VarGenes.txt", quote = FALSE, row.names = FALSE, col.names = TRUE)



# 20171129: Redo bigwigaverageoverbed -------------------------------------

setwd("sampleSubset/")
my_bed4_file<-as.data.frame(read.table("concatenatedBedFileMERGE.bed4", sep = "\t", header = FALSE)) #load file from script labeled concatenatedBedFile_SORT.bed4
head(my_bed4_file) #view table to ensure it has 4 columns
print("I loaded my merge file!\n")
for(x in list.files("./", pattern = "\\.bed$")){ #perform the following 2 steps for every ".bed" file created with the script
  print(x)
  sample_data<-read.table(paste("./", x, sep = ""), sep="\t")[,5] #open the .bed file and take only the 5th column (contains the peak score)
  my_bed4_file<-cbind(my_bed4_file, sample_data) #add the 5th column to concatenatedBedFile_SORT.bed4 table within R
}
  
head(my_bed4_file)
sample_names<-list.files("bigWigAverageOverBed/") #make a list of each ".bed" file name
sample_names<-gsub("_MACS2_SPMR_treat_pileupSORT.bw.bed", "", sample_names) #remove the boring ending from each file name
sample_names<-gsub("235_P", "CD235+", sample_names) #make sample names easier to read
sample_names<-gsub("235_N", "CD235-", sample_names) #make sample names easier to read
colnames(my_bed4_file)<-c("chrom", "start", "stop", "name", "502_CD235+", "632_CD235+", "CTRL4_CD235+") # add column names to each column in your table
head(my_bed4_file) # look at the newly modified table and make sure it has the correct number of columns and that each column has a 

trimmed_merge_file<-my_bed4_file[,5:7]
N<-1000
trimmed_merge_file=trimmed_merge_file[apply(trimmed_merge_file, 1, var, na.rm=TRUE) != 0,]


head(trimmed_merge_file)


DNA_matrix<-data.matrix(trimmed_merge_file)
DBA_variance<-apply(DNA_matrix, 1, var)
#DBA_variance<-as.data.frame(DBA_variance)
head(sort(DBA_variance[,1]))
max(DBA_variance[,1])
min(DBA_variance[,1])
tempgeorge<-as.data.frame(sort(DBA_variance))
head(tempgeorge)
names<-rownames(tempgeorge)
tempgeorge<-cbind(names, tempgeorge)
tail(tempgeorge)
library(ggplot2)


sum(tempgeorge[,2] < 0.05)

dim(tempgeorge)
plot(tempgeorge[1:100000,2])



tempgeorge[20000,]
length(tempgeorge[,2]<=0.05)
DBA_top_variable_gens<-names(sort(DBA_variance)[1:N])


head(DBA_top_variable_gens)



primary_DBA_variance_top_variable_genes<-DNA_matrix[DBA_top_variable_gens,]
head(DBA_top_variable_gens)
s=quantile(primary_DBA_variance_top_variable_genes, c(.25))
e=quantile(primary_DBA_variance_top_variable_genes, c(.75))
cnt=30
step = (e - s)/cnt
breaks = c(seq(s,e,by=step))

heatmap.2(primary_DBA_variance_top_variable_genes, dendrogram="both", scale="none", trace="none", breaks=breaks, col=diverge_hcl, symkey = FALSE, labRow="", key.title = "", margins = c(16,16))
png(paste("DBA-HM.png", sep = ""), width = 1251, height = 954)
heatmap.2(primary_DBA_variance_top_variable_genes, dendrogram="both", scale="none", trace="none", breaks=breaks, col=diverge_hcl, symkey = FALSE, labRow="", key.title = "", main = atac_table)
dev.off()



head(primary_DBA_variance_top_variable_genes)

head(trimmed_merge_file)
z.mat <- t(scale(t(trimmed_merge_file), center=TRUE, scale=TRUE )) 
#Z-transform--the scale function transforms column values, but we want to transform our rows, hence the double transpositions

s=quantile(z.mat, c(.10))
e=quantile(z.mat, c(.90))
cnt=30
step = (e - s)/cnt
breaks = c(seq(s,e,by=step))
#my_palette <- c("#1000FFFF","#0047FFFF","#00C8FFFF","#00FFE0FF","#00FF89FF","#00FF33FF","#99FF00FF","#AFFF00FF","#FFD800FF","#FFB800FF","#FFAD00FF","#FF8100FF","#FF5600FF","#FF2B00FF","#FF0000FF")
#breaks = c(seq(-4,4,length=76))
dist.pear <- function(x) as.dist(1-x)
library(colorspace)

##creates heatmap of gene expression vs cell type
heatmap.2(z.mat, dendrogram="both", scale="none", trace="none", breaks=breaks, col=diverge_hcl, symkey = FALSE, labRow="", key.title = "", main = RNA_table)

png(paste(RNA_table,"-HM.png", sep = ""), width = 1251, height = 954)
heatmap.2(z.mat, dendrogram="both", scale="none", trace="none", breaks=breaks, col=diverge_hcl, symkey = FALSE, labRow="", key.title = "", main = RNA_table)
dev.off()


typeof(my_bed4_file)
thedataframe<-as.data.frame(my_bed4_file)
head(thedataframe)
george<-subset(thedataframe, subset=thedataframe[,4] %in% DBA_top_variable_gens)
write.table(george, file="AtacSubset_top100VarGenes.txt", quote = FALSE, row.names = FALSE, col.names = TRUE)



