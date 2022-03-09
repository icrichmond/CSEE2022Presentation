# credit to Alec Robitaille and WEEL's study-area-figs repo for inspiration/code: https://github.com/wildlifeevoeco/study-area-figs

#### PACKAGES ####
libs <- c('ggplot2', 'sf')
lapply(libs, require, character.only = TRUE)


#### DATA ####
bounds <- st_read('data/canada-bounds.gpkg')
cities <- st_read('data/cities-points.gpkg')
mtl <- st_read('data/montreal-bounds.gpkg')
parks <- st_read('data/montreal-parks.gpkg')
nhoods <- st_read('data/montreal-neighbourhoods.gpkg')
water <- st_read('data/montreal-water.gpkg')


# CRS
mtlcrs <- st_crs(3347)


#### THEME ####
## Colors
source('script/0-palette.R')

## main map
thememain <- theme(panel.border = element_rect(size = 1, fill = NA),
                   panel.background = element_rect(fill = watercol),
                   panel.grid = element_line(color = gridcol1, size = 0.2),
                   axis.text = element_text(size = 11, color = 'black'),
                   axis.title = element_blank(), 
                   plot.background = element_rect(fill = "#e7e5cc", colour = "#e7e5cc"))

## inset 
themeinset <- theme(panel.border = element_rect(size = 1, fill = NA),
                    panel.background = element_rect(fill = canadacol, colour = "#e7e5cc"),
                    panel.grid = element_line(color = gridcol2, size = 0.2),
                    axis.text = element_text(size = 11, color = 'black'),
                    axis.title = element_blank(), 
                    plot.background = element_rect(fill = "#e7e5cc", colour = "#e7e5cc"))



#### CHAPTER 1 ####
# bbox for larger Canada map 
can <- bounds[bounds$admin == 'Canada',]
bb <- st_bbox(st_buffer(can, 2.5))


ggplot() +
  geom_sf(fill = canadacol, color = 'grey32', size = 0.1, data = bounds) +
  geom_sf(color = citycol, size = 3, data = cities) +
  coord_sf(xlim = c(bb['xmin'], bb['xmax'] + 2.5),
           ylim = c(bb['ymin'], bb['ymax'])) +
  thememain
ggsave("chapter-1.png", dpi = 450)

#### CHAPTER 2 ####
mtl <- st_transform(mtl, mtlcrs)
parks <- st_transform(parks, mtlcrs)
nhoods <- st_transform(nhoods, mtlcrs)
water <- st_transform(water, mtlcrs)

bbi <- st_bbox(st_buffer(mtl, 2.5))

ggplot() +
  geom_sf(fill = montrealcol, data = mtl) + 
  geom_sf(fill = parkcol, col = NA, data = parks) +
  geom_sf(fill = watercol, data = water) + 
  coord_sf(xlim = c(bbi['xmin'], bbi['xmax']),
           ylim = c(bbi['ymin'], bbi['ymax'])) +
  themeinset
ggsave("chapter-2.png", dpi = 450)

#### CHAPTER 3 ####
ggplot() +
  geom_sf(fill = montrealcol, data = mtl) + 
  geom_sf(fill = nhoodcol, col = "gray31", data = nhoods) + 
  geom_sf(fill = watercol, data = water) + 
  coord_sf(xlim = c(bbi['xmin'], bbi['xmax']),
           ylim = c(bbi['ymin'], bbi['ymax'])) +
  themeinset
ggsave("chapter-3.png", dpi = 450)
