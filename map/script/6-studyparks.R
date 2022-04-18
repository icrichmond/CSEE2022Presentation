# credit to Alec Robitaille and WEEL's study-area-figs repo for inspiration/code: https://github.com/wildlifeevoeco/study-area-figs


# Packages ----------------------------------------------------------------
libs <- c('ggplot2', 'ggspatial', 'sf', 'dplyr')
lapply(libs, require, character.only = TRUE)


# Data --------------------------------------------------------------------
mtl <- st_read('data/montreal-bounds.gpkg')
water <- st_read('data/montreal-water.gpkg')
parks <- st_read('data/montreal-parks.gpkg')
studyparks <- read.csv('data/studyparks.csv')

# CRS
mtlcrs <- st_crs(3347)
mtl <- st_transform(mtl, mtlcrs)
parks <- st_transform(parks, mtlcrs)
water <- st_transform(water, mtlcrs)

# Montreal Parks  ---------------------------------------------------------
download_shp <- function(url, dest){
  p <- c("downloader","sf", "bit64")
  lapply(p, library, character.only = T)
  
  temp <- tempfile()
  
  download.file(url, dest, mode = "wb")
  
  shp <- st_read(file.path("/vsizip", dest))
  
  View(shp)
  
}

download_shp("https://data.montreal.ca/dataset/2e9e4d2f-173a-4c3d-a5e3-565d79baa27d/resource/c57baaf4-0fa8-4aa4-9358-61eb7457b650/download/shapefile.zip",
             "data/mon_park_raw.zip")

mtlparks <- st_read(file.path("/vsizip", "data/mon_park_raw.zip"))

mtlparks <- st_transform(mtlparks, mtlcrs)

# Study Parks -------------------------------------------------------------
# join study parks based on name to City shapefile 
gpo <- studyparks %>% 
  rename(Nom = ParkOfficial) %>% 
  inner_join(., mtlparks, by = c("Nom", "OBJECTID"))
gpo <- gpo[, c(1:5, 15)]
gpo <- rename(gpo, ParkOfficial = Nom)

mp <- studyparks %>% 
  rename(Nom = ParkOfficial) %>% 
  filter(Nom != "Grand parc de l'Ouest") %>% 
  left_join(., mtlparks, by = "Nom")
mp <- st_as_sf(mp)
mp <- mp[-c(55:57), c(1:5, 16)]
mp <- rename(mp, ParkOfficial = Nom,
              OBJECTID = OBJECTID.x)

bdup <- studyparks %>% 
  filter(ParkOfficial == "Parc Fritz" | 
           ParkOfficial == "Allan's Hill Park" | 
           ParkOfficial == "Parc Beaconsfield") %>% 
  rename(name = ParkOfficial) %>%
  left_join(., parks, by = 'name')
bdup <- st_as_sf(bdup)
bdup <- st_cast(bdup, "POLYGON")
bdup <- bdup[c(34,69,104), c(1:5, 99)]
bdup <- rename(bdup, ParkOfficial = name,
               geometry = geom)

studyparks <- st_as_sf(rbind(gpo, mp, bdup))

# Theme -------------------------------------------------------------------
## Colors
source('script/0-palette.R')

## inset 
thememtl <- theme(panel.border = element_rect(size = 1, fill = NA),
                    panel.background = element_rect(fill = canadacol, colour = "#e7e5cc"),
                    panel.grid = element_line(color = gridcol2, size = 0.2),
                    axis.text = element_text(size = 11, color = 'black'),
                    axis.title = element_blank(), 
                    plot.background = element_rect(fill = "#e7e5cc", colour = "#e7e5cc"),
                    legend.background = element_rect(fill = NA)
                    )


# Map ---------------------------------------------------------------------

bbi <- st_bbox(mtl)
crs_string = "+proj=omerc +lat_0=45.65 +lonc=-73.80 +alpha=0 +k_0=.7 +datum=WGS84 +units=m +no_defs +gamma=40"

ggplot() +
  geom_sf(fill = montrealcol, data = mtl) + 
  geom_sf(aes(fill = PastLandUse), colour = NA, data = studyparks) +
  scale_fill_manual(values = p) +
  geom_sf(fill = watercol, data = water) + 
  coord_sf(crs = crs_string, 
           xlim = c(-19000, 17268),
           ylim = c(-20859, -750)) +
  labs(fill = "") +
  annotation_north_arrow(height = unit(1, "cm"), 
                         width = unit(1, "cm"), 
                         location = 'br',
                         which_north = 'true') +
  thememtl

ggsave("studyparks.png", dpi = 450)

