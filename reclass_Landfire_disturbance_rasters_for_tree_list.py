# reclassify Landfire disturbance rasters for tree list application
# written by Karin Riley, 2/13/2018
# updated for c2014 tree list by Karin Riley, 2/5/2019

import arcpy
from arcpy import env
from arcpy.sa import *
arcpy.CheckOutExtension("Spatial")

# set snap raster
arcpy.env.snapRaster = "E:\\Spatial_Data\\Landfire\\disturbance\\Refresh\\US_DIST2001\\grid1\\us_dist2001"


# reclass to unique code for fire and insects/disease for each year (all other disturbances are considered NoData)

# 2013: fire=20131, insect/disease=20132, neither="NoData"
inRaster = "E:\\Tree_List_c2014\\Spatial_data\\Landfire\\disturbance_grids\\US_DIST2013_10312018\\Grid\\us_dist2013"
##outReclass2 = Reclassify(inRaster, "VALUE", RemapRange([[-10000,1,"NODATA"],[10,234,20131], [410,464,"NODATA"], [470,504,20131],[520,534,"NODATA"], [540,564,20132], [570,584,"NODATA"],[600,764,"NODATA"], [770,804,20131], [810,815,"NODATA"],[820,834,"NODATA"], [840,854,20132], [870,884,"NODATA"], [910,962,"NODATA"], [970,1002,20131], [1010,1032,"NODATA"], [1040,1062,20132], [1070,1133,"NODATA"]]))
##outReclass2.save("E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\us_dist2013_reclass.tif")

# 2014: fire=20141, insect/disease=20142, neither="NoData"
inRaster = "E:\\Tree_List_c2014\\Spatial_data\\Landfire\\disturbance_grids\\US_DIST2014_10312018\\Grid\\us_dist2014"
outReclass2 = Reclassify(inRaster, "VALUE", RemapRange([[-10000,1,"NODATA"],[10,234,20141], [410,464,"NODATA"], [470,504,20141],[520,534,"NODATA"], [540,564,20142], [570,584,"NODATA"],[600,764,"NODATA"], [770,804,20141], [810,815,"NODATA"],[820,834,"NODATA"], [840,854,20142], [870,884,"NODATA"], [910,962,"NODATA"], [970,1002,20141], [1010,1032,"NODATA"], [1040,1062,20142], [1070,1133,"NODATA"]]))
outReclass2.save("E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\us_dist2014_reclass.tif")

# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# to follow the same logic that was used with the FIA plots, if an area burned,
#  it's assigned the most recent burn year. If it hasn't burned, the most recent
# year of insect/disease is assigned (where applicable). In other words,
# burning takes priority over a more recent insect infestation (disturbance data onl
# only goes back about 11 years).

# Therefore, we need rasters with only the burn info (all other pixels "No Data")
# (This has already been done for 1999-2012)

# 2013: fire=20131, other="NoData"
inRaster = "E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\us_dist2013_reclass.tif"
outReclass1 = Reclassify(inRaster, "VALUE", RemapRange([[20131,20131,20131],[20132,20132,"NODATA"], [-33000,0,"NODATA"]]))
outReclass1.save("E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\us_dist2013_fire.tif")

# 2014: fire=20141, other="NoData"
inRaster = "E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\us_dist2014_reclass.tif"
outReclass1 = Reclassify(inRaster, "VALUE", RemapRange([[20141,20141,20141],[20142,20142,"NODATA"], [-33000,0,"NODATA"]]))
outReclass1.save("E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\us_dist2014_fire.tif")

# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# we also need rasters with only the insect/diease info (all other pixels "No Data")

# 2013: insect/disease=20132, other="NoData"
inRaster = "E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\us_dist2013_reclass.tif"
outReclass1 = Reclassify(inRaster, "VALUE", RemapRange([[20131,20131,"NODATA"],[20132,20132,20132], [-33000,0,"NODATA"]]))
outReclass1.save("E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\us_dist2013_insectdisease.tif")

# 2014: insect/disease=20142, other="NoData"
inRaster = "E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\us_dist2014_reclass.tif"
outReclass1 = Reclassify(inRaster, "VALUE", RemapRange([[20141,20141,"NODATA"],[20142,20142,20142], [-33000,0,"NODATA"]]))
outReclass1.save("E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\us_dist2014_insectdisease.tif")

# ---------------------------------------------------------------------------------------------------------------------------------------------------
# mosaic all fire rasters, with most recent year taking precedence
inRasters = "E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist1999_fire.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2000_fire.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2001_fire.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2002_fire.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2003_fire.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2004_fire.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2005_fire.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2006_fire.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2007_fire.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2008_fire.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2009_fire.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2010_fire.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2011_fire.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2012_fire.tif;E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\us_dist2013_fire.tif;E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\us_dist2014_fire.tif"
outputLocation = "E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance"
outRaster = "disturbance_fire_most_recent_1999_2014.tif"
coordsys = arcpy.Describe("E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2001_reclass.tif").spatialReference
pixelType = "16_BIT_SIGNED"
cellsize = "30"
mosaic_method = "LAST"
arcpy.MosaicToNewRaster_management(inRasters, outputLocation, outRaster, coordsys, pixelType, cellsize, "1", "LAST", "#")

# ---------------------------------------------------------------------------------------------------------------------------------------------------
# mosaic all insect and disease rasters, with most recent year taking precedence
inRasters = "E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist1999_insectdisease.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2000_insectdisease.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2001_insectdisease.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2002_insectdisease.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2003_insectdisease.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2004_insectdisease.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2005_insectdisease.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2006_insectdisease.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2007_insectdisease.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2008_insectdisease.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2009_insectdisease.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2010_insectdisease.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2011_insectdisease.tif;E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2012_insectdisease.tif;E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\us_dist2013_insectdisease.tif;E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\us_dist2014_insectdisease.tif"
outputLocation = "E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance"
outRaster = "disturbance_insectdisease_most_recent_1999_2014.tif"
coordsys = arcpy.Describe("E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2001_reclass.tif").spatialReference
pixelType = "16_BIT_SIGNED"
cellsize = "30"
mosaic_method = "LAST"
arcpy.MosaicToNewRaster_management(inRasters, outputLocation, outRaster, coordsys, pixelType, cellsize, "1", "LAST", "#")

# ---------------------------------------------------------------------------------------------------------------------------------------------------
# mosaic all fires and all insect/disease rasters, with fire taking priority
inRasters = "E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\disturbance_insectdisease_most_recent_1999_2014.tif;E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\disturbance_fire_most_recent_1999_2014.tif"
outputLocation = "E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance"
outRaster = "disturbance_insect_disease_fire_most_recent_2000_2014.tif"
coordsys = arcpy.Describe("E:\\Tree_List_c2012\\Spatial_data\\Landfire\\disturbance_reclass_KLR\\us_dist2001_reclass.tif").spatialReference
pixelType = "16_BIT_SIGNED"
cellsize = "30"
mosaic_method = "LAST"
arcpy.MosaicToNewRaster_management(inRasters, outputLocation, outRaster, coordsys, pixelType, cellsize, "1", "LAST", "#")

# ---------------------------------------------------------------------------------------------------------------------------------------------------
# reclass to disturbance type
inRaster = "E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\disturbance_insect_disease_fire_most_recent_1999_2014.tif"
outReclass1 = Reclassify(inRaster, "VALUE", RemapValue([[32767,0], [19991,1], [19992,2], [20001,1], [20002,2], [20011,1], [20012,2], [20021,1], [20022,2], [20031,1], [20032,2], [20041,1], [20042,2], [20051,1], [20052,2], [20061,1], [20062,2], [20071,1], [20072,2], [20081,1], [20082,2], [20091,1], [20092,2], [20101,1], [20102,2], [20111,1], [20112,2], [20121,1], [20122,2], [20131,1], [20132,2], [20141,1], [20142,2]]))
outReclass1.save("E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\disturbance_code_1999_2014.tif")


# ---------------------------------------------------------------------------------------------------------------------------------------------------
# reclass to disturbance years before measurement
inRaster = "E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\disturbance_insect_disease_fire_most_recent_1999_2014.tif"
outReclass1 = Reclassify(inRaster, "VALUE", RemapRange([[32767,32768,99], [19991,19993,15], [20001,20003,14], [20011,20013,13], [20021,20023,12], [20031,20033,11], [20041,20043,10], [20051,20053,9], [20061,20063,8], [20071,20073,7], [20081,20083,6], [20091,20093,5], [20101,20103,4], [20111,20113,3], [20121,20123,2], [20131,20133,1], [20141,20143,0]]))
outReclass1.save("E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\disturbance_year_1999_2014.tif")


#--------------------------------------------------------------------------------------------------------
# "NoData" values need to have a value (in case they fall on a forested pixel)
# disturbance code
inRaster = "E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\disturbance_code_1999_2014.tif"
outReclass1 = Reclassify(inRaster, "VALUE", RemapValue([["NODATA",0],[1,1], [2,2]]))
outReclass1.save("E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\disturbance_code_1999_2014_nodata.tif")
# disturbance year
inRaster = "E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\disturbance_year_1999_2014.tif"
outReclass1 = Reclassify(inRaster, "VALUE", RemapValue([["NODATA",99],[1,1], [2,2], [3,3], [4,4], [5,5], [6,6], [7,7], [8,8], [9,9], [10,10], [11,11], [12,12], [13,13], [14,14], [15,15]]))
outReclass1.save("E:\\Tree_List_c2014\\target_data\\working_KLR\\disturbance\\disturbance_year_1999_2014_nodata.tif")
# had trouble getting this to work so did it manually in ArcGIS.
# did similar for disturbance code, setting "NODATA" values to 99

