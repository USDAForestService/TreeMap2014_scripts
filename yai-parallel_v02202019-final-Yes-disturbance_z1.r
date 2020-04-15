# Perform random forests imputation of FIA plot data
# written by Isaac Grenfell

library(yaImpute)
library(raster)
library(rgdal)
library(foreign)
library(parallel)
library(foreach)
library(doParallel)


###Change this to match current directory and path
cur.zone <- "z1"
outfolder <- cur.zone

setwd("F:\\Tree_List_c2012\\FIA\\working_KLR")
meters.db <- read.dbf("FIA_LFRDB_Albers.dbf")

###Change this to match current directory and path
setwd(paste("F:\\Tree_List_c2014\\target_data\\final\\", outfolder, sep=""))
list.files()

cwd <- getwd()
flist.tif <- Sys.glob("*.tif")

# Create raster stack of input target grids
raster.stack <- stack(flist.tif)
p4s.albers <- proj4string(raster.stack)
raster.list <- vector("list", length(flist.tif))
nrasters <- length(flist.tif)
for(i in 1:length(flist.tif))  
{
  raster.list[[i]] <- raster()  
}

###Extract values about training points
nfiles.raster <- length(flist.tif)

# Read in x table of reference data
allplot <- read.table("F:\\Tree_List_c2014\\x_table\\x_table_final_EVG_Karin_reclass_plus_loblolly_manual.txt", header=T, sep=",")
remap <- read.table(paste("F:\\Tree_List_c2014\\target_data\\working_KLR\\EVG_remap\\", cur.zone, "_EVG_remap.txt", sep=""), sep=":")

#Limit allplot to just the veg types in the zone remap table
plot.df <- allplot[allplot$EVT_GP %in% remap$V1,]
dim(plot.df)

###Change this to match current directory and path
dir.create(paste("F:\\Tree_List_c2014\\outputs\\", cur.zone, "_disturb", sep=""))
plot.df$CN <- factor(plot.df$CN)
write.csv(plot.df, paste("F:\\Tree_List_c2014\\outputs\\", cur.zone, "_disturb\\", cur.zone, "_x_table_allplots_reclass.txt", sep=""), row.names = F)

merge.df <- merge(plot.df, meters.db, by = "CN")

##Build X predictor matrix
evg.fac <- as.factor(plot.df$EVT_GP)
dc.code.fac <- as.factor(plot.df$disturb_code)
dc.year.fac <- as.factor(plot.df$disturb_year)
dc.year.num <- as.numeric(plot.df$disturb_year)


lev.dc <- levels(dc.code.fac)
lev.year <- levels(dc.year.fac)

plot.df[,18] <- evg.fac


##Build Y response matrix
plot.df$POINT_X <- merge.df$POINT_X
plot.df$POINT_Y <- merge.df$POINT_Y


###Change this to match current directory and path
setwd(paste("F:\\Tree_List_c2014\\target_data\\final\\", outfolder, sep=""))

####Reclass evgs
evg.reclass <- remap
n.evgs <- dim(evg.reclass)[1]

evg.out <- rep(0, dim(plot.df)[1])
evg.vec <- plot.df$"EVT_GP"
for(i in 1:n.evgs)  
{  
  cur.evg <- evg.reclass[i, 1]  
  sub.ind <- evg.vec == cur.evg  
  evg.out[sub.ind] <- i  
}	
evg.in <- as.factor(evg.out)

plot.df$"EVT_GP" <- as.factor(evg.out)
plot.df$disturb_code <- as.factor(plot.df$disturb_code)

#Create X Table
X.df <- plot.df[,5:20]

aspect.temp <- X.df$ASPECT
rad.temp <- (pi/180)*aspect.temp
northing.temp <- cos(rad.temp)
easting.temp <- sin(rad.temp)
X.df <- X.df[,-2]
X.df$NORTHING <- northing.temp
X.df$EASTING <- 	easting.temp

rownames(X.df) <- plot.df$ID
id.table <-  plot.df$ID
Y.df <- data.frame(plot.df[,16:18])
rownames(Y.df) <- plot.df$ID
#X.df <- X.df[,-c(9, 10)]

# build the random forests model (X=all predictors, Y=EVG, EVC, EVH)
set.seed(56789)
yai.treelist <- yai(X.df, Y.df, method = "randomForest", ntree = 249)

yai.treelist

# build dataframes from the raster data
raster.coords <- coordinates(raster.stack)
asp.raster <- raster.stack[[1]]
dem.raster <- raster.stack[[2]]

currow.vals <- cellFromRow(dem.raster, 1500)
coords.currow <- raster.coords[currow.vals,]

extract.currow <- extract(raster.stack, coords.currow)
p4s.latlong <- CRS("+proj=longlat +datum=NAD83") 

maxrow <- max(as.numeric(rownames(X.df)))

nrows.out <- dim(raster.stack)[1]
ncols.out <- dim(raster.stack)[2]

rs2 <- raster.stack
coords.all <- raster.coords

x.vec <- coords.all[,1]
x.mat <- matrix(x.vec, nrow=nrows.out)

x.raster.out <- raster(x.mat)
x.raster.out@extent <-dem.raster@extent
x.raster.out@crs <-dem.raster@crs

y.vec <- coords.all[,2]
y.mat <- matrix(y.vec, nrow=nrows.out)

y.raster.out <- raster(y.mat)
y.raster.out@extent <-dem.raster@extent
y.raster.out@crs <-dem.raster@crs

# Perform imputation
impute.row <- function(currow)  
{  
  library(yaImpute) 
  library(raster) 
  library(rgdal)
  currow.vals <- cellFromRow(dem.raster, currow)
  coords.currow <- raster.coords[currow.vals,]  
  
  # get data from each row of rasters (coordinates)
  sp.currow <- SpatialPoints(coords.currow, CRS(p4s.albers)) 
  extract.currow <- extract(rs2,   sp.currow)
  
  colseq <- 1:length(extract.currow[,1])
  valid.cols <- colseq[as.logical(1-is.na(extract.currow[,1]))]
  ncols.df <- dim(extract.currow)[2]
  extract.currow <- data.frame(extract.currow)
  extract.currow$"POINT_X" <- sp.currow$x
  extract.currow$"POINT_Y" <-sp.currow$y
  extract.currow <- na.exclude(extract.currow)
  X.df.temp <- data.frame(extract.currow)
  nrow.temp <- dim(X.df.temp)[1]
  
  aspect.temp <- X.df.temp$ASPECT  
  rad.temp <- (pi/180)*aspect.temp  
  northing.temp <- cos(rad.temp)  
  easting.temp <- sin(rad.temp)
  
  X.df.temp <- X.df.temp[,-1]  
  X.df.temp$NORTHING <- northing.temp  
  X.df.temp$EASTING <- 	easting.temp  
  temp.evg <- X.df.temp$'EVT_GP'
  
  #get nonappearing evgs   
  evg.orig <- 1:n.evgs 
  evg.val <- evg.orig  
  evg.val.temp <- X.df.temp$'EVT_GP'  
  n.evgs.orig <- length(sort(unique(evg.orig)))  
  evg.orig.seq <- 1:n.evgs.orig  
  
  nonappearing.evgs <- evg.val[-sort(unique(as.numeric(as.character(evg.val.temp))))]  
  n.dummy.rows <- length(nonappearing.evgs)  
  X.df.temp.old <- X.df.temp

  if(n.dummy.rows > 0)    
  {    
    dummy.rows <- X.df.temp[1:n.dummy.rows,]    
    tempchar <- as.character(X.df.temp$'EVT_GP')    
    X.df.temp$'EVT_GP' <- tempchar    
    dummy.rows$'EVT_GP' <- as.character(nonappearing.evgs)    
    X.df.temp <- rbind(X.df.temp, dummy.rows)    
  }
  
  n.rows.orig <- dim(extract.currow)[1]	  
  temp.fac <- factor(X.df.temp$'EVT_GP', levels = levels(evg.in))  
  dc.code.fac.temp <- factor( X.df.temp$disturb_code, levels=lev.dc)  
  
  X.df.temp$'EVT_GP' <- as.factor(temp.fac)  
  X.df.temp$disturb_code <- dc.code.fac.temp   
  nrow.temp <- dim(X.df.temp)[1]  
  impute.out <- rep(-1, nrow.temp)  
  
  nc.orig <- dim(coords.currow)[1]  
  impute.out <- rep(NA,nc.orig)  
  nrows.orig <- dim(extract.currow)[1]  
  if(nrow.temp > 0)    
  {    
    colseq.out <- 1:dim(X.df.temp)[1]    
    rownames.all <- colseq.out+maxrow    
    rownames(X.df.temp) <- paste("T-", rownames.all)    
    
    # take object from formed random forests model and use X.df.temp dataframe to make predictions    
    temp.newtargs <- newtargets(yai.treelist, newdata = X.df.temp)    
    temp.xall <- temp.newtargs$xall    
    out.neiIds <- temp.newtargs$neiIdsTrgs    
    out.trgrows <- temp.newtargs$trgRows    
    yrows <- as.numeric(out.neiIds[,1])    
    id.out <- id.table[yrows]    
    impute.out[valid.cols] <- yrows[1:nrows.orig]    
  }
  
  return(impute.out)  
}

cl <- makeCluster(20, port="10187")
registerDoParallel(cl)

mout <- foreach(m = 1:nrows.out, .packages = c("raster", "rgdal", "yaImpute"), .combine="rbind") %dopar%   impute.row(m)

stopCluster(cl)
closeAllConnections()

###this will return a matrix, all thats left is to write it out as a raster

m.raster <-dem.raster

m.raster.out <- raster(mout)
m.raster.out@extent <-dem.raster@extent
m.raster.out@crs <-dem.raster@crs

###Change this!
setwd(paste("F:\\Tree_List_c2014\\outputs\\", cur.zone, "_disturb", sep=""))
fout <- paste(cur.zone, "_index-yes-disturb.tif", sep="")
writeRaster(m.raster.out, fout, overwrite=TRUE)
