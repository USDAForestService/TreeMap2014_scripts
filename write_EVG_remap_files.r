# write EVG remap files
# written by Karin Riley 2/15/2019

library(foreign)

zones <- c(seq(1,10),seq(12,66),98,99)
for (j in 1:length(zones))
{
  curtable <- paste("E:\\Tree_List_c2014\\target_data\\draft\\z", zones[j], "\\z", zones[j], "_EVG_forest.tif.vat.dbf", sep="")
  vat <- read.dbf(curtable)
  evgseq <- seq(1:dim(vat)[[1]])
  outtable <- data.frame()
  for (k in 1:dim(vat)[[1]])
  {
    outtable[k,1] <- paste(vat[k,1],":",evgseq[k], sep="")
  }
  outfile <- paste("E:\\Tree_List_c2014\\target_data\\working_KLR\\EVG_remap\\z", zones[j], "_EVG_remap.txt", sep="")
  write.table(outtable, outfile, row.names=FALSE, col.names=FALSE, quote=FALSE)
}

