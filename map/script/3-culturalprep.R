# credit to Alec Robitaille and WEEL's study-area-figs repo for inspiration/code: https://github.com/wildlifeevoeco/study-area-figs

#### PACKAGES ####
libs <- c('sf', 'osmdata')
lapply(libs, require, character.only = TRUE)


#### DATA #### 
bb <- c(xmin = -74.0788,
        ymin = 45.3414,
        xmax = -73.3894,
        ymax = 45.7224)

## Parks 
# Download island boundary in bbox
parks <- opq(bb) %>%
  add_osm_feature(key = 'leisure', value = 'park') %>%
  osmdata_sf()
# Grab multipolygons (large parks)
mpolys <- parks$osm_multipolygons
mpolys <- st_make_valid(st_cast(mpolys, "POLYGON"))
# Grab polygons (small parks)
polys <- parks$osm_polygons
allpolys <- st_union(polys, mpolys)
# clip parks to Montreal island boundary
mtl <- st_read('data/montreal-bounds.gpkg')
wi <- st_within(allpolys, mtl)
subwi <- vapply(wi, function(x) length(x) >= 1, TRUE)
keepp <- mpolys[subwi, ]

## Neighbourhoods 
hoods <- opq(bb) %>%
  add_osm_feature(key = 'place', value = 'neighbourhood') %>%
  osmdata_sf()
multihoods <- hoods$osm_multipolygons
multihoods <- st_as_sf(multihoods)

#### SAVE ####
write_sf(keepp, 'data/montreal-parks.gpkg')
write_sf(multihoods, "data/montreal-neighbourhoods.gpkg")