
# Packages ----------------------------------------------------------------

libs <- c('stars', 'raster', 'sf', 'ggplot2')
lapply(libs, require, character.only = TRUE)

# Data --------------------------------------------------------------------

parks <- read_sf("data/studyparks.gpkg")
cc <- read_stars("data/66023_IndiceCanopee_2019.tif")


# Cleaning ----------------------------------------------------------------
parks <- st_transform(parks, st_crs(cc))

jd <- subset(parks, ParkOfficial == "Jean-Drapeau")

cc.jd <- st_crop(cc, jd)

# Sample  -----------------------------------------------------------------

# make 0.04 ha (400 m2) grids
gr <- st_make_grid(jd, cellsize = 20)

# extract percent canopy cover for each grid cell 
# TO-DO: don't need this right now
#cc.gr <- aggregate(cc.jd, gr, FUN = )

# randomly sample 9 points
cent <- sample(st_centroid(gr), 9)


# Plot --------------------------------------------------------------------
crs_string = "+proj=omerc +lat_0=45.513 +lonc=-73.534 +alpha=0 +k_0=.7 +datum=WGS84 +units=m +no_defs +gamma=90"

cc.jd.t <- st_transform(cc.jd, crs=crs_string)
cent.t <- st_transform(cent, crs_string)
gr.t <- st_transform(gr, crs_string)

myCol <- c("darkgrey", "darkslategrey", "lightgreen", "darkgreen", "cadetblue")

par(bg="#e7e5cc")
plot(cc.jd.t, 
     col = myCol, 
     main=NULL)
plot(cent.t, pch = 16, col = "black", add = T)
plot(gr.t, border = "darkgrey", add = T)
