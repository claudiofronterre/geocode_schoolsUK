# LOAD REQUIRED PACKAGES AND FUNCTIONS -----------------------------------------
if (!require("pacman")) install.packages("pacman")
pkgs = c("sf", "tmap") # package names
pacman::p_load(pkgs, character.only = T)

# LOAD DATA --------------------------------------------------------------------
schools <- readr::read_csv("data/processed/schools_full_geocoded.csv")
schools_sp <- schools %>% 
  st_as_sf(coords = c("X", "Y"), crs = 27700)

UK <- st_read("data/original/geodata/gadm36_GBR.gpkg", layer = "gadm36_GBR_1")
england <- UK %>% 
  filter(NAME_1 == "England") %>% 
  st_transform(crs = 27700)

# MAPS -------------------------------------------------------------------------
tm_shape(england) +
  tm_borders() +
tm_shape(schools_sp) +
  tm_symbols(size = .00001, shape = 19, col = "black") +
tm_compass(position = c("right", "top")) +
tm_scale_bar() + 
tm_layout(frame = F, title = "Spatial distribution of schools in England",
          outer.margins = 0, asp = 0, title.size = 0.95)

tmap_save(filename = "figs/schools_distribution.pdf")
tmap_save(filename = "figs/schools_distribution.png")

# SAVE SCHOOLS AS GEOPACKAGE ---------------------------------------------------
st_write(schools_sp, "data/processed/geodata/schools_geocoded.gpkg")
