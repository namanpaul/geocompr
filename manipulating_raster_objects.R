#manipulating raster objects
library(sf)
library(raster)
library(sp)
library(dplyr)
library(spData)

elev = raster(nrows = 6, ncols = 6, res = 0.5,
              xmn = -1.5, xmx = 1.5, ymn = -1.5, ymx = 1.5,
              vals = 1:36)

#raster objects can contain values of class numeric, integer, logical or factor, but not character
grain_order = c("clay", "silt", "sand")
grain_char = sample(grain_order, 36, replace = TRUE)
grain_fact = factor(grain_char, levels = grain_order)
grain = raster(nrows = 6, ncols = 6, res = 0.5, 
               xmn = -1.5, xmx = 1.5, ymn = -1.5, ymx = 1.5,
               vals = grain_fact)

#ratify
levels(grain)[[1]] = cbind(levels(grain)[[1]], wetness = c("wet", "moist", "dry"))
levels(grain)
ratify(grain)

#retrieve value of ids 1,11,35
factorValues(grain, grain[c(1, 11, 35)])
