# analysis for national c2014 tree list
# written by Karin Riley, 4/10/2019

options("scipen"= 100, digits=8)

xtable <- read.table("F:\\Tree_List_c2014\\x_table.txt", header=T, sep=",")

# find accuracy at national level 
# cover -----------------------------------------------------------------------------------------------
zonenums = c(1,2,3,4,5,6,7,8,9,10,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,98,99)
allmat <- matrix(data=0, nrow=10, ncol=10)
  
for (j in 1:length(zonenums))
{
  covcm <- read.table(paste("F:\\Tree_List_c2014\\outputs\\z", zonenums[j], "_disturb\\z", zonenums[j], "_EVC_confusion_matrix.txt", sep=""), header=T)
  allmat <- allmat + covcm
}
allmat2 <- allmat[-10,-10]
sum(allmat2)
evcvec <- c(15, 25, 35, 45, 55, 65, 75, 85, 95)
row.names(allmat2) <- evcvec
colnames(allmat2) <- evcvec
accuracy3 <- as.numeric()
accuracy4 <- as.numeric()
for(i in 1:length(evcvec))
{
  accuracy3[i] <- allmat2[i,i]/sum(allmat2[i,])
  accuracy4[i] <- allmat2[i,i]/sum(allmat2[,i])
}
allmat3 <- cbind(allmat2, accuracy3)
allmat3 <- rbind(allmat3, c(accuracy4, -99))
row.names(allmat3) <- c(row.names(allmat2), "accuracy")
colnames(allmat3) <- c(colnames(allmat2), "accuracy")
# calculate overall accuracy = 96% ! 
allmat3[dim(allmat3)[[1]], dim(allmat3)[[2]]]  <- (allmat3[1,1] + allmat3[2,2] + allmat3[3,3] + allmat3[4,4] + allmat3[5,5] + allmat3[6,6] + allmat3[7,7] + allmat3[8,8] + allmat3[9,9])/sum(allmat2)
write.table(allmat3, "F:\\Tree_List_c2014\\outputs\\national\\EVC_confusion_matrix.txt")
# bar chart
fiacovvec <- as.numeric()
for (j in 1:length(evcvec))
{
  fiacovvec[j] <- length(which(xtable$canopy_cover==evcvec[j]))
}
sum(fiacovvec)==dim(xtable)[[1]]
fiapercvec <- fiacovvec/dim(xtable)[[1]]
sum(fiapercvec)
evcplottotals <- c(sum(allmat2[,1]), sum(allmat2[,2]), sum(allmat2[,3]), sum(allmat2[,4]), sum(allmat2[,5]), sum(allmat2[,6]), sum(allmat2[,7]), sum(allmat2[,8]), sum(allmat2[,9]))
sum(evcplottotals)
evcplotperc <- evcplottotals/sum(allmat2)
sum(evcplotperc)
evcpolytotals <- c(sum(allmat2[1,]), sum(allmat2[2,]), sum(allmat2[3,]), sum(allmat2[4,]), sum(allmat2[5,]), sum(allmat2[6,]), sum(allmat2[7,]), sum(allmat2[8,]), sum(allmat2[9,]))
sum(evcpolytotals)
evcpolyperc <- evcpolytotals/sum(allmat2)
sum(evcpolyperc)
evcmat3 <- rbind(evcpolyperc, evcplotperc, fiapercvec)
row.names(evcmat3) <- c("imputed", "LANDFIRE (target)", "FIA (reference)")
colnames(evcmat3) <- evcvec
tiff(file="F:\\Tree_List_c2014\\manuscript\\publication_draft\\figures\\EVC_comparison_barplot.tif", height=300, width=600)
barplot(evcmat3, col=c("aquamarine3", "chartreuse4", "aquamarine4"), beside=TRUE, xlab="Cover class (midpoint)", ylab="Proportion", legend=rownames(evcmat3), args.legend=list(x="topleft"))
box()
dev.off()
canopycovvec <- sort(unique(xtable$canopy_cover))
canopycovcount <- as.numeric()
for (j in 1:length(canopycovvec))
{
  canopycovcount[j] <- length(which(xtable$canopy_cover==canopycovvec[j]))
}
sum(canopycovcount)==dim(xtable)[[1]]
tiff(file="F:\\Tree_List_c2014\\manuscript\\publication_draft\\figures\\EVC_accuracy_by_plotcount.tif", height=400, width=400)
plot(canopycovcount, accuracy4, xlab="Count of plots in canopy cover class", ylab="Accuracy", pch=19)
dev.off()
canopyacc <- cbind(canopycovvec, canopycovcount, accuracy4)
write.table(canopyacc, "F:\\Tree_List_c2014\\outputs\\national\\EVC_plotcount_vs_accuracy.txt")

# height
allmat <- matrix(data=0, nrow=5, ncol=5)
for (j in 1:length(zonenums))
{
  heightcm <- read.table(paste("F:\\Tree_List_c2014\\outputs\\z", zonenums[j], "_disturb\\z", zonenums[j], "_EVH_confusion_matrix.txt", sep=""), header=T)
  allmat <- allmat + heightcm
}
allmat2 <- allmat[-6,-6]
sum(allmat2)

evhvec <- c(3, 8, 18, 38, 70)
row.names(allmat2) <- evhvec
colnames(allmat2) <- evhvec
accuracy3 <- as.numeric()
accuracy4 <- as.numeric()
for(i in 1:length(evhvec))
{
  accuracy3[i] <- allmat2[i,i]/sum(allmat2[i,])
  accuracy4[i] <- allmat2[i,i]/sum(allmat2[,i])
}
allmat3 <- cbind(allmat2, accuracy3)
allmat3 <- rbind(allmat3, c(accuracy4, -99))
row.names(allmat3) <- c(row.names(allmat2), "accuracy")
colnames(allmat3) <- c(colnames(allmat2), "accuracy")
# calculate overall accuracy = 99.2% 
allmat3[dim(allmat3)[[1]], dim(allmat3)[[2]]]  <- (allmat3[1,1] + allmat3[2,2] + allmat3[3,3] + allmat3[4,4] + allmat3[5,5])/sum(allmat2)
write.table(allmat3, "F:\\Tree_List_c2014\\outputs\\national\\EVH_confusion_matrix.txt")
# bar chart
evhplottotals <- c(sum(allmat2[,1]), sum(allmat2[,2]), sum(allmat2[,3]), sum(allmat2[,4]), sum(allmat2[,5]))
sum(evhplottotals)
evhplotperc <- evhplottotals/sum(evhplottotals)
sum(evhplotperc)
evhpolytotals <- c(sum(allmat2[1,]), sum(allmat2[2,]), sum(allmat2[3,]), sum(allmat2[4,]), sum(allmat2[5,]))
sum(evhpolytotals)
evhpolyperc <- evhpolytotals/sum(evhpolytotals)
sum(evhpolyperc)
canopyhtvec <- evhvec
canopyhtcount <- as.numeric()
for (j in 1:length(canopyhtvec))
{
  canopyhtcount[j] <- length(which(xtable$canopy_height==canopyhtvec[j]))
}
sum(canopyhtcount)==dim(xtable)[[1]]
canopyhtperc <- canopyhtcount/dim(xtable)[[1]]
sum(canopyhtperc)
evhmat3 <- rbind(evhpolyperc, evhplotperc, canopyhtperc)
row.names(evhmat3) <- c("imputed", "reference", "FIA")
colnames(evhmat3) <- evhvec
tiff(file="F:\\Tree_List_c2014\\manuscript\\publication_draft\\figures\\EVH_comparison_barplot.tif", height=400, width=600)
barplot(evhmat3, col=c("aquamarine3", "chartreuse4", "aquamarine4"), beside=TRUE, names.arg=c("0-5m", "5-10m", "10-25m", "25-50m", ">50m"), xlab="Height class", ylab="Proportion", legend=c("imputed", "LANDFIRE (target)", "FIA (reference)"))
box()
dev.off()
tiff(file="F:\\Tree_List_c2014\\manuscript\\publication_draft\\figures\\EVH_accuracy_by_plotcount.tif", height=400, width=400)
plot(canopyhtcount, accuracy4, xlab="Count of plots in canopy height class", ylab="Accuracy", pch=19)
dev.off()
canopyacc2 <- cbind(canopyhtvec, canopyhtcount, accuracy4)
write.table(canopyacc2, "F:\\Tree_List_c2014\\outputs\\national\\EVH_plotcount_vs_accuracy.txt")


# EVG --------------------------------------------------------------------------------------------
library(foreign)
evgtargetvec <- as.numeric()
for (j in 1:length(zonenums))
{
  evgcm <- read.dbf(paste("F:\\Tree_List_c2014\\target_data\\final\\z", zonenums[j], "\\not_reclassified\\z", zonenums[j], "_EVG_forest.tif.vat.dbf", sep=""))
  evgtargetvec <- c(evgtargetvec, evgcm$VALUE)
}
evgtargetvec <- sort(unique(evgtargetvec))
# EVGs in target data are the same as in the output, but x table had a few additional (won't include these in the analysis)
evgvec <- as.numeric()
for (j in 1:length(zonenums))
{
  evgcm <- read.table(paste("F:\\Tree_List_c2014\\outputs\\z", zonenums[j], "_disturb\\z", zonenums[j], "_EVG_confusion_matrix.txt", sep=""), header=T)
  evgvec <- c(evgvec, rownames(evgcm))
}
evgvec <- sort(unique(evgvec))
evgvec <- as.numeric(evgvec[-1])
allmat <- matrix(data=0, nrow=length(evgvec), ncol=length(evgvec))
rownames(allmat) <- evgvec
colnames(allmat) <- evgvec
for (j in 1:length(zonenums))
{
  evgcm <- read.table(paste("F:\\Tree_List_c2014\\outputs\\z", zonenums[j], "_disturb\\z", zonenums[j], "_EVG_confusion_matrix.txt", sep=""), header=T)
  for (k in 1:length(rownames(evgcm)))
  {
    for (m in 1:length(colnames(evgcm)))
    {
      currow <- which(evgvec==rownames(evgcm)[k])
      evgcol <- strsplit(colnames(evgcm)[m], "X")
      curcol <- which(evgvec==evgcol[[1]][2])
      allmat[currow, curcol] <- allmat[currow, curcol] + evgcm[k,m]
    }
  }
}
sum(allmat)

accuracy3 <- as.numeric()
accuracy4 <- as.numeric()
for(i in 1:length(evgvec))
{
  accuracy3[i] <- allmat[i,i]/sum(allmat[i,])
  accuracy4[i] <- allmat[i,i]/sum(allmat[,i])
}
allmat3 <- cbind(allmat, accuracy3)
allmat3 <- rbind(allmat3, c(accuracy4, -99))
row.names(allmat3) <- c(evgvec, "accuracy")
colnames(allmat3) <- c(evgvec, "accuracy")
# calculate overall accuracy = 93.0% 
sumcorrect <- 0
for (j in 1:dim(allmat)[[1]])
{
  sumcorrect <- sumcorrect + allmat[j,j]
}
allmat3[dim(allmat3)[[1]], dim(allmat3)[[2]]]  <- sumcorrect/sum(allmat)
write.table(allmat3, "F:\\Tree_List_c2014\\outputs\\national\\EVG_confusion_matrix.txt")
# bar chart
evgplottotals <- as.numeric()
for(i in 1:length(evgvec))
{
  evgplottotals[i] <- sum(allmat[,i]) 
}
sum(evgplottotals)
evgplotperc <- evgplottotals/sum(evgplottotals)
sum(evgplotperc)
evgpolytotals <- as.numeric()
for(i in 1:length(evgvec))
{
  evgpolytotals[i] <- sum(allmat[i,]) 
}
sum(evgpolytotals)
evgpolyperc <- evgpolytotals/sum(evgpolytotals)
sum(evgpolyperc)
evgcount <- as.numeric()
for (j in 1:length(evgvec))
{
  evgcount[j] <- length(which(xtable$EVT_GP==evgvec[j]))
}
sum(evgcount)==dim(xtable)[[1]] # these don't match because x table had some additional EVGs that weren't in the target data
evgperc <- evgcount/sum(evgcount)
sum(evgperc)
evgmat3 <- rbind(evgpolyperc, evgplotperc, evgperc)
row.names(evgmat3) <- c("imputed", "reference", "FIA")
colnames(evgmat3) <- evgvec
# panel EVG barplot for readability
tiff(file="F:\\Tree_List_c2014\\manuscript\\publication_draft\\figures\\EVG_comparison_barplot1.tif", height=300, width=600)
barplot(evgmat3[,1:15], col=c("aquamarine3", "chartreuse4", "aquamarine4"), beside=TRUE, args.legend=list(x="topleft"), ylim=c(0,0.11), xlab="Existing Vegetation Group (EVG)", ylab="Proportion", legend=c("imputed", "LANDFIRE (target)", "FIA (reference)"))
box()
dev.off()
tiff(file="F:\\Tree_List_c2014\\manuscript\\publication_draft\\figures\\EVG_comparison_barplot2.tif", height=300, width=600)
barplot(evgmat3[,16:30], col=c("aquamarine3", "chartreuse4", "aquamarine4"), beside=TRUE, args.legend=list(x="topright"), ylim=c(0,0.11), xlab="Existing Vegetation Group (EVG)", ylab="Proportion", legend=c("imputed", "LANDFIRE (target)", "FIA (reference)"))
box()
dev.off()
tiff(file="F:\\Tree_List_c2014\\manuscript\\publication_draft\\figures\\EVG_comparison_barplot3.tif", height=300, width=600)
barplot(evgmat3[,31:45], col=c("aquamarine3", "chartreuse4", "aquamarine4"), beside=TRUE, args.legend=list(x="topright"), ylim=c(0,0.11), xlab="Existing Vegetation Group (EVG)", ylab="Proportion", legend=c("imputed", "LANDFIRE (target)", "FIA (reference)"))
box()
dev.off()
tiff(file="F:\\Tree_List_c2014\\manuscript\\publication_draft\\figures\\EVG_comparison_barplot4.tif", height=300, width=600)
barplot(evgmat3[,46:60], col=c("aquamarine3", "chartreuse4", "aquamarine4"), beside=TRUE, args.legend=list(x="topleft"), ylim=c(0,0.11), xlab="Existing Vegetation Group (EVG)", ylab="Proportion", legend=c("imputed", "LANDFIRE (target)", "FIA (reference)"))
box()
dev.off()
tiff(file="F:\\Tree_List_c2014\\manuscript\\publication_draft\\figures\\EVG_comparison_barplot5.tif", height=300, width=700)
barplot(evgmat3[,61:76], col=c("aquamarine3", "chartreuse4", "aquamarine4"), beside=TRUE, args.legend=list(x="topleft"), ylim=c(0,0.11), xlab="Existing Vegetation Group (EVG)", ylab="Proportion", legend=c("imputed", "LANDFIRE (target)", "FIA (reference)"))
box()
dev.off()
percdiff1 <- evgplotperc - evgperc
percdiff2 <- evgpolyperc - evgperc
percdiff3 <- evgpolyperc - evgplotperc
rawdiff <- evgplottotals - evgpolytotals
evgmat4 <- cbind(evgvec, evgpolyperc, evgplotperc, evgperc, evgpolytotals, evgplottotals, evgcount, percdiff1, percdiff2, percdiff3, rawdiff)
write.table(evgmat4, "F:\\Tree_List_c2014\\outputs\\national\\EVG_counts_and_differences.txt")
evgvec[which(percdiff1>0.01 | percdiff1<(-0.01))]
evgvec[which((percdiff2>0.01) | percdiff2<(-0.01))]
evgvec[which((percdiff3>0.01) | percdiff3<(-0.01))]
evgvec[which(rawdiff>5000000 | rawdiff<(-5000000))]
tiff(file="F:\\Tree_List_c2014\\manuscript\\publication_draft\\figures\\EVG_accuracy_by_plotcount.tif", height=400, width=400)
plot(evgcount, accuracy4, xlab="Count of plots in vegetation class", ylab="Accuracy", pch=19)
dev.off()
length(which(evgcount<1000)) # 58 of 76 EVGs had fewer than 1000 plots available for imputation
length(which(evgcount<500)) # 46 of 76 EVGs had fewer than 500 plots available for imputation
canopyacc2 <- cbind(evgvec, evgcount, accuracy4)
write.table(canopyacc2, "F:\\Tree_List_c2014\\outputs\\national\\EVG_plotcount_vs_accuracy.txt")
# how many EVGs had accuracy >=90%
allmat3 <- read.table("F:\\Tree_List_c2014\\outputs\\national\\EVG_confusion_matrix.txt")
length(which(allmat3[,77]>0.9))
length(which(allmat3[77,]>0.9))

# disturbance code --------------------------------------------------------------------------------------------
allmat <- matrix(data=0, nrow=3, ncol=3)

for (j in 1:length(zonenums))
{
  covcm <- read.table(paste("F:\\Tree_List_c2014\\outputs\\z", zonenums[j], "_disturb\\z", zonenums[j], "_disturb_code_confusion_matrix.txt", sep=""), header=T)
  allmat <- allmat + covcm
}
allmat2 <- allmat[-4,-4]
sum(allmat2)
dcvec <- c("no disturbance", "fire", "insect/disease")
row.names(allmat2) <- dcvec
colnames(allmat2) <- dcvec
accuracy3 <- as.numeric()
accuracy4 <- as.numeric()
for(i in 1:length(dcvec))
{
  accuracy3[i] <- allmat2[i,i]/sum(allmat2[i,])
  accuracy4[i] <- allmat2[i,i]/sum(allmat2[,i])
}
allmat3 <- cbind(allmat2, accuracy3)
allmat3 <- rbind(allmat3, c(accuracy4, -99))
row.names(allmat3) <- c(row.names(allmat2), "accuracy")
colnames(allmat3) <- c(colnames(allmat2), "accuracy")
# calculate overall accuracy = 96% ! 
allmat3[dim(allmat3)[[1]], dim(allmat3)[[2]]]  <- (allmat3[1,1] + allmat3[2,2] + allmat3[3,3])/sum(allmat2)
write.table(allmat3, "F:\\Tree_List_c2014\\outputs\\national\\disturb_code_confusion_matrix.txt")
# bar chart
dcplottotals <- c(sum(allmat2[,1]), sum(allmat2[,2]), sum(allmat2[,3]))
sum(dcplottotals)
dcplotperc <- dcplottotals/sum(dcplottotals)
sum(dcplotperc)
dcpolytotals <- c(sum(allmat2[1,]), sum(allmat2[2,]), sum(allmat2[3,]))
sum(dcpolytotals)
dcpolyperc <- dcpolytotals/sum(dcpolytotals)
sum(dcpolyperc)
dccount <- as.numeric()
dcvec2 <- c(0,1,2)
for (j in 1:length(dcvec))
{
  dccount[j] <- length(which(xtable$disturb_code==dcvec2[j]))
}
sum(dccount)==dim(xtable)[[1]]
dcperc <- dccount/dim(xtable)[[1]]
sum(dcperc)
dcmat3 <- rbind(dcpolyperc, dcplotperc, dcperc)
row.names(dcmat3) <- c("imputed", "reference", "FIA")
colnames(dcmat3) <- dcvec
tiff(file="F:\\Tree_List_c2014\\manuscript\\publication_draft\\figures\\disturbance_code_comparison_barplot.tif", height=300, width=400)
barplot(dcmat3, col=c("aquamarine3", "chartreuse4", "aquamarine4"), beside=TRUE, xlab="Existing Vegetation Group (EVG)", ylab="Proportion", legend=c("imputed", "LANDFIRE (target)", "FIA (reference)"))
box()
dev.off()
tiff(file="F:\\Tree_List_c2014\\manuscript\\publication_draft\\figures\\disturbance_code_accuracy_by_plotcount.tif", height=300, width=300)
plot(dccount, accuracy4, xlab="Count of plots in disturbance class", ylab="Accuracy", pch=19)
dev.off()
canopyacc2 <- cbind(dcvec, dccount, accuracy4)
write.table(canopyacc2, "F:\\Tree_List_c2014\\outputs\\national\\disturb_code_plotcount_vs_accuracy.txt")



# disturbance year --------------------------------------------------------------------------------------------
allmat <- matrix(data=0, nrow=18, ncol=18)
for (j in 1:length(zonenums))
{
  covcm <- read.table(paste("F:\\Tree_List_c2014\\outputs\\z", zonenums[j], "_disturb\\z", zonenums[j], "_disturb_year_confusion_matrix.txt", sep=""), header=T)
  allmat <- allmat + covcm
}
allmat2 <- allmat[-18,-18]
sum(allmat2)
dcvec <- row.names(allmat)[-18]
row.names(allmat2) <- dcvec
colnames(allmat2) <- dcvec
accuracy3 <- as.numeric()
accuracy4 <- as.numeric()
for(i in 1:length(dcvec))
{
  accuracy3[i] <- allmat2[i,i]/sum(allmat2[i,])
  accuracy4[i] <- allmat2[i,i]/sum(allmat2[,i])
}
allmat3 <- cbind(allmat2, accuracy3)
allmat3 <- rbind(allmat3, c(accuracy4, -99))
row.names(allmat3) <- c(row.names(allmat2), "accuracy")
colnames(allmat3) <- c(colnames(allmat2), "accuracy")
# calculate overall accuracy = 96% ! 
allmat3[dim(allmat3)[[1]], dim(allmat3)[[2]]]  <- (allmat2[1,1] + allmat2[2,2] + allmat2[3,3] + allmat2[4,4] + allmat2[5,5] + allmat2[6,6] + allmat2[7,7] + allmat2[8,8] + allmat2[9,9] + allmat2[10,10] + allmat2[11,11] + allmat2[12,12] + allmat2[13,13] + allmat2[14,14] + allmat2[15,15] + allmat2[16,16] + allmat2[17,17])/sum(allmat2)
write.table(allmat3, "F:\\Tree_List_c2014\\outputs\\national\\disturb_year_confusion_matrix.txt")
# bar chart
dyplottotals <- c(sum(allmat2[,1]), sum(allmat2[,2]), sum(allmat2[,3]), sum(allmat2[,4]), sum(allmat2[,5]), sum(allmat2[,6]), sum(allmat2[,7]), sum(allmat2[,8]), sum(allmat2[,9]), sum(allmat2[,10]), sum(allmat2[,11]), sum(allmat2[,12]), sum(allmat2[,13]), sum(allmat2[,14]), sum(allmat2[,15]), sum(allmat2[,16]), sum(allmat2[,17]))
sum(dyplottotals)
dyplotperc <- dyplottotals/sum(dyplottotals)
sum(dyplotperc)
dypolytotals <- c(sum(allmat2[1,]), sum(allmat2[2,]), sum(allmat2[3,]), sum(allmat2[4,]), sum(allmat2[5,]), sum(allmat2[6,]), sum(allmat2[7,]), sum(allmat2[8,]), sum(allmat2[9,]), sum(allmat2[10,]), sum(allmat2[11,]), sum(allmat2[12,]), sum(allmat2[13,]), sum(allmat2[14,]), sum(allmat2[15,]), sum(allmat2[16,]), sum(allmat2[17,]))
sum(dypolytotals)
dypolyperc <- dypolytotals/sum(dypolytotals)
sum(dypolyperc)
dycount <- as.numeric()
for (j in 1:length(dcvec))
{
  dycount[j] <- length(which(xtable$disturb_year==dcvec[j]))
}
sum(dycount)==dim(xtable)[[1]]
dyperc <- dycount/dim(xtable)[[1]]
sum(dyperc)
dymat3 <- rbind(dypolyperc, dyplotperc, dyperc)
row.names(dymat3) <- c("imputed", "reference", "FIA")
colnames(dymat3) <- dcvec
barplot(dymat3, col=c("aquamarine3", "chartreuse4", "aquamarine4"), beside=TRUE, legend=rownames(dymat3))
box()
plot(dycount, accuracy4, xlab="Count of plots in disturbance year", ylab="Accuracy")
canopyacc2 <- cbind(dcvec, dycount, accuracy4)
write.table(canopyacc2, "F:\\Tree_List_c2014\\outputs\\national\\disturb_year_plotcount_vs_accuracy.txt")
