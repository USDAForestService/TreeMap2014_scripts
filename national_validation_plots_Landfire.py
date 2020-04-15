# tree list validation: compare plot center pixel to Landfire data there
# written by Karin Riley, 10/28/19

import arcpy
from arcpy import env
from arcpy.sa import *
arcpy.CheckOutExtension("Spatial")

# mosaic input data into national layer
layers = ["canopy_cover.tif", "canopy_height.tif", "EVT_GP.tif"]
zonenums = [1,2,3,4,5,6,7,8,9,10,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,98,99]
for layer in layers:
    print "mosaic", layer
    for k in range(0,len(zonenums)):
        input_raster = "F:\\Tree_List_c2014\\target_data\\final\\z" + str(zonenums[k]) + "\\" + layer
        if (k==0):
            input_raster_list = input_raster + ";"
        if (k>0):
            input_raster_list = input_raster_list + input_raster + ";"
        if (k==len(zonenums)):
            input_raster_list = input_raster_list + input_raster             
    output_location = "F:\\Tree_List_c2014"
    outraster = layer
    coord_sys = input_raster
    pixel_type = "8_BIT_UNSIGNED"
    number_of_bands = 1
    arcpy.MosaicToNewRaster_management(input_raster_list, output_location, outraster,
                                   coord_sys, pixel_type, "", number_of_bands, "", "")

# do the same for the non-reclassfied EVGs
layer = "EVG_forest.tif"
for k in range(0,len(zonenums)):
    input_raster = "F:\\Tree_List_c2014\\z" + str(zonenums[k]) + "\\not_reclassified\\z" + str(zonenums[k]) + "_" + layer
    if (k==0):
        input_raster_list = input_raster + ";"
    if (k>0):
        input_raster_list = input_raster_list + input_raster + ";"
    if (k==len(zonenums)):
        input_raster_list = input_raster_list + input_raster             
output_location = "F:\\Tree_List_c2014"
outraster = layer
coord_sys = input_raster
pixel_type = "16_BIT_SIGNED"
number_of_bands = 1
arcpy.MosaicToNewRaster_management(input_raster_list, output_location, outraster,
                                   coord_sys, pixel_type, "", number_of_bands, "", "")
    

# extract characteristics of Landfire data at plot locations
layers = ["canopy_cover", "canopy_height", "EVG_forest"]
layers = ["EVG_forest"]
for layer in layers:
    print "extracting", layer
    inPointFeatures = "F:\\Tree_List_c2014\\X_table_INVYR2014.shp"
    inRaster = "F:\\Tree_List_c2014\\" + layer + ".tif"
    outPointFeatures = "F:\\Tree_List_c2014\\X_table_INVYR2014_" + layer + ".shp"
    ExtractValuesToPoints(inPointFeatures, inRaster, outPointFeatures, "NONE", "ALL")

# extract characteristics of Landfire data within plot footprint
layers = ["canopy_cover", "canopy_height", "EVG_forest"]
for layer in layers:
    print "combining imputed raster & ", layer
    inRaster1 = "F:\\Tree_List_c2014\\X_table_INVYR2014_35m.tif"
    inRaster2 = "F:\\Tree_List_c2014\\" + layer + ".tif"
    outRaster = "F:\\Tree_List_c2014\\X_table_" + layer + "_buffer35m_combine.tif"
    outCombine = Combine([inRaster1, inRaster2])
    outCombine.save(outRaster)


