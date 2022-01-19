# credit to Alec Robitaille and WEEL's study-area-figs repo for inspiration/code: https://github.com/wildlifeevoeco/study-area-figs

#### PACKAGES ####
libs <- c('sf', 'osmdata', 'rnaturalearth')
lapply(libs, require, character.only = TRUE)

#### DATA ####
# download OSM data 
## Canada boundary
bounds <- ne_download(
  scale = 'large',
  type = 'states',
  category = 'cultural',
  returnclass = 'sf'
)
keepAdmin <- c('United States of America', 'Canada', 'Greenland')
keepb <- bounds[bounds$admin %in% keepAdmin,]

## cities
# code adapted from https://www.supplychaindataanalytics.com/geocoding-with-osmdata-in-r/
cities = as.data.frame(matrix(nrow=7,ncol=3))
colnames(cities) = c("location","lat","long")
cities$location = c("Vancouver, Canada",      #1
                     "Calgary, Canada",    #2
                     "Winnipeg, Canada",     #3
                     "Toronto, Canada",        #4 
                     "Ottawa, Canada", #5
                     "Montreal, Canada", #6
                     "Halifax, Canada"   #7
)
for(i in 1:nrow(cities)){
  coordinates = getbb(cities$location[i])
  cities$long[i] = (coordinates[1,1] + coordinates[1,2])/2
  cities$lat[i] = (coordinates[2,1] + coordinates[2,2])/2
}
cities <- st_as_sf(cities, coords = c("long", "lat"))
cities <- st_set_crs(cities, st_crs(keepb))

#### SAVE ####
write_sf(keepb, 'data/canada-bounds.gpkg')
write_sf(cities, 'data/cities-points.gpkg')
