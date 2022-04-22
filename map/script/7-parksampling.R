
# Packages ----------------------------------------------------------------

libs <- c('stars', 'sf')
lapply(libs, require, character.only = TRUE)

# Data --------------------------------------------------------------------

parks <- read_sf("data/studyparks.gpkg")
cc <- rast("data/66023_IndiceCanopee_2019.tif")


# Cleaning ----------------------------------------------------------------
parks <- st_transform(parks, st_crs(cc))

jd <- subset(parks, ParkOfficial == "Jean-Drapeau")

cc.jd <- st_crop(cc, jd)

# Sample  -----------------------------------------------------------------

# make 0.04 ha (400 m2) grids
gr <- st_make_grid(jd, cellsize = 20)

# extract percent canopy cover for each grid cell 
cc.gr <- aggregate(cc.jd, gr, FUN = )
st_as_sf(x)