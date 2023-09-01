#load libraries
require(pacman)
pacman::p_load(terra,automap,fs,sp,sf,tidyverse,rgeos,stringr,glue,RColorBrewer,cptcity)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

#load data
library(readr)
new_datos <- read_csv("D:/GEOESPACIO/r_studio/new_datos.csv")
#change the names of columns
colnames(new_datos)[5:6] <- c('x','y')
#import raster
#install.packages("raster")
library(raster)
dem <- raster("D:/GEOESPACIO/r_studio/raster_camana.tif")
plot(dem)
#read shapefile
mapa <- st_read("D:/GEOESPACIO/r_studio/cuenca_camana.shp")
ggplot() + geom_sf(data = mapa) 
#apply mask
mascara <- mask(dem, mapa)
plot(mascara)
#idw
idw <- gstat(id = 'pp_media_anual', formula = pp_media_anual ~ 1, locations = ~ x + y, data = new_datos, nmax = 7, set= list(idp = .5))
idw <- terra::interpolate(mascara, idw)
idw <- terra::crop(idw, mapa)
idw <- terra::mask(idw, mapa)
plot(idw, main= "Módelo de interpolación IDW de la precipitación media anual\n de la cuenca Camana")



