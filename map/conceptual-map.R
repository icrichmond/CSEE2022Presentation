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

keepAdmin <- 'Canada'

keepb <- bounds[bounds$admin %in% keepAdmin,]




cities <- opq(bbox = 'canada') %>%
  add_osm_feature(key = 'place', value = 'city', name = 'Vancouver') %>%
  osmdata_sf()

## cities
# code adapted from https://www.supplychaindataanalytics.com/geocoding-with-osmdata-in-r/
data_df = as.data.frame(matrix(nrow=7,ncol=3))
colnames(data_df) = c("location","lat","long")
data_df$location = c("Vancouver, Canada",      #1
                     "Calgary, Canada",    #2
                     "Winnipeg, Canada",     #3
                     "Toronto, Canada",        #4 
                     "Ottawa, Canada", #5
                     "Montreal, Canada", #6
                     "Halifax, Canada"   #7
)
for(i in 1:nrow(data_df)){
  coordinates = getbb(data_df$location[i])
  data_df$long[i] = (coordinates[1,1] + coordinates[1,2])/2
  data_df$lat[i] = (coordinates[2,1] + coordinates[2,2])/2
}
data_df <- st_as_sf(data_df, coords = c("long", "lat"))
