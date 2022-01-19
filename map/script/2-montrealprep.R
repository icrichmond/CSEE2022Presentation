# credit to Alec Robitaille and WEEL's study-area-figs repo for inspiration/code: https://github.com/wildlifeevoeco/study-area-figs

#### PACKAGES ####
libs <- c('sf', 'osmdata')
lapply(libs, require, character.only = TRUE)


#### DATA #### 
# set up bounding box - order: xmin, ymin, xmax, ymax
bb <- c(xmin = -74.0788,
        ymin = 45.3414,
        xmax = -73.3894,
        ymax = 45.7224)

## Montreal
# Download island boundary in bbox
mtl <- opq(bb) %>%
  add_osm_feature(key = 'place', value = 'island') %>%
  osmdata_sf()
# Grab multipolygons (large islands)
multipolys <- mtl$osm_multipolygons
# Grab polygons (small islands)
polys <- mtl$osm_polygons
polys <- st_cast(polys, "MULTIPOLYGON")
# Combine geometries and cast as sf
allpolys <- st_as_sf(st_union(polys, multipolys))

## Water
water <- opq(bb) %>%
  add_osm_feature(key = 'natural', value = 'water') %>%
  osmdata_sf()
mpols <- water$osm_multipolygons
mpols <- st_cast(mpols, "MULTIPOLYGON")
mpols <- st_as_sf(st_make_valid(mpols))


#### SAVE ####
write_sf(allpolys, 'data/montreal-bounds.gpkg')
write_sf(mpols, 'data/montreal-water.gpkg')
