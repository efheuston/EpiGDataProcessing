args <- commandArgs(trailingOnly = TRUE)
intab <- args[1]
outtab <- args[2]
data <- read.table(intab, sep="\t", header=TRUE, row.names=4)
#quantile
library(limma)
#name removed from column count
limmaRes = normalizeQuantiles(data[,4:ncol(data)])
#keep 8 digits get from bigWigAve
limmaRes = round(limmaRes, digits=8)
write.table(limmaRes, file=outtab, row.names = TRUE ,col.names = TRUE,quote = FALSE, sep="\t")

