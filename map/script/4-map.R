# credit to Alec Robitaille and WEEL's study-area-figs repo for inspiration/code: https://github.com/wildlifeevoeco/study-area-figs

#### PACKAGES ####
libs <- c('ggplot2', 'sf', 'patchwork')
lapply(libs, require, character.only = TRUE)


#### DATA ####
bounds <- st_read('data/canada-bounds.gpkg')
cities <- st_read('data/cities-points.gpkg')
mtl <- st_read('data/montreal-bounds.gpkg')
parks <- st_read('data/montreal-parks.gpkg')
nhoods <- st_read('data/montreal-neighbourhoods.gpkg')
nhoods <- nhoods[c(1,5,10, 15, 20, 35, 40, 49),] # subset
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
                    panel.background = element_rect(fill = canadacol),
                    panel.grid = element_line(color = gridcol2, size = 0.2),
                    axis.text = element_text(size = 11, color = 'black'),
                    axis.title = element_blank(), 
                    plot.background = element_rect(fill = "#e7e5cc", colour = "#e7e5cc"))



#### LARGE PLOT ####
# bbox for larger Canada map 
can <- bounds[bounds$admin == 'Canada',]
bb <- st_bbox(st_buffer(can, 2.5))


main <- ggplot() +
  geom_sf(fill = canadacol, color = 'grey32', size = 0.1, data = bounds) +
  geom_sf(color = citycol, size = 3, data = cities) +
  coord_sf(xlim = c(bb['xmin'], bb['xmax'] + 2.5),
           ylim = c(bb['ymin'], bb['ymax'])) +
  #geom_rect(aes(xmin = -74.0788, xmax = -73.3894, ymin = 45.3414), ymax = 45.7224, 
  #          fill = NA, colour = "black", size = 0.5)  + 
  labs(subtitle = "Chapter 1") +
  thememain


#### MTL INSET ####
mtl <- st_transform(mtl, mtlcrs)
parks <- st_transform(parks, mtlcrs)
nhoods <- st_transform(nhoods, mtlcrs)
water <- st_transform(water, mtlcrs)

bbi <- st_bbox(st_buffer(mtl, 2.5))

inset <- ggplot() +
  geom_sf(fill = montrealcol, data = mtl) + 
  geom_sf(fill = parkcol, col = NA, data = parks) +
  geom_sf(fill = nhoodcol, col = "gray40", data = nhoods) + 
  geom_sf(fill = watercol, data = water) + 
  coord_sf(xlim = c(bbi['xmin'], bbi['xmax']),
           ylim = c(bbi['ymin'], bbi['ymax'])) +
  labs(subtitle = "Chapters 2 & 3") +
  themeinset

#### FULL #### 
main | inset

#### SAVE ####
ggsave(
  'study-system.png',
  width = 12,
  height = 7,
  dpi = 450
)
