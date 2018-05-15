# Create ATAC table from BWAOB _ tab files --------------------------------------------

setwd("~/Desktop/Histones/atac/atacRAW/")
bedFiles<-list.files("./", pattern=".tab$")
head(read.table(bedFiles[1], sep = "\t", colClasses = c("NULL", "NULL", "NULL", "NULL", NA, "NULL")))
peaks<-read.table(bedFiles[1], sep = "\t", colClasses = c(NA, NA, NA, "NULL", "NULL","NULL"))

head(peaks)
bedFiles
length(bedFiles)
for(i in 1:length(bedFiles)){
  bedFiles[i]
  peaks<-cbind(peaks, read.table(bedFiles[i], sep = "\t", colClasses = c("NULL", "NULL", "NULL", "NULL", NA)))
  # peaks<-cbind(peaks, read.table(bedFiles[i], sep = "\t"))
}

head(peaks)
peaks<-peaks[4:23]
colnames(peaks)<-gsub(".mm10.tab", "", bedFiles)
head(peaks)
write.table(peaks, "~/Desktop/Histones/ClusteringAnalysesInR/ATAC_myeloidOnly.txt", quote = FALSE, sep = "\t", row.names = TRUE, col.names = TRUE)

# Create ATAC table from BWAOB _ bed files --------------------------------------------

bedFiles<-list.files("./", pattern="mm10.bed$")
head(read.table(bedFiles[1], sep = "\t"))
peaks<-read.table(bedFiles[1], sep = "\t", colClasses = c(NA, NA, NA, NA, "NULL"), col.names = c("Chrom", "Start", "Stop", "PeakNum", "BWScore"))
head(peaks)

bedFiles
length(bedFiles)
for(i in 1:length(bedFiles)){
  bedFiles[i]
  peaks<-cbind(peaks, read.table(bedFiles[i], sep = "\t", colClasses = c("NULL", "NULL", "NULL", "NULL", NA)))
  # peaks<-cbind(peaks, read.table(bedFiles[i], sep = "\t"))
}

head(peaks)
# peaks<-peaks[4:23]
colnames(peaks)<-gsub(".mm10.tab", "", bedFiles)
head(peaks)

write.table(peaks, "~/Desktop/Histones/ClusteringAnalysesInR/20180313_ATACTable.txt", quote = FALSE, sep = "\t", row.names = TRUE, col.names = TRUE)

tail(peaks[,1:4])
unique(peaks[,1])

yesnoPeaks<-read.table("20180222_ATACTable_yesNoPeaks.txt", header = TRUE)
head(yesnoPeaks)
colnames(yesnoPeaks)
colnames(yesnoPeaks)<-gsub("atac_concatMERGE_.u_", "", colnames(yesnoPeaks))
colnames(yesnoPeaks)<-gsub(".homer.bed", "_peak", colnames(yesnoPeaks))
colnames(yesnoPeaks)

fullAtacTable<-cbind(peaks, yesnoPeaks[,4])
fullAtacTable<-cbind(fullAtacTable, yesnoPeaks[,6:ncol(fullAtacTable)])
colnames(fullAtacTable)
testSet<-fullAtacTable %>% filter() 
head(cbind(peaks, fullAtacTable[,4]))

