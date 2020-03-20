# LOAD REQUIRED PACKAGES AND FUNCTIONS -----------------------------------------
if (!require("pacman")) install.packages("pacman")
pkgs = c("opencage", "sf") # package names
pacman::p_load(pkgs, character.only = T)

# LOAD DATA --------------------------------------------------------------------
schools <- readr::read_csv("data/processed/schools_to_geocode.csv")

# GEOCODING -------------------------------------------------------------

# Generate full schools addresses
addresses <- paste(schools$`Establishment name`,
                   schools$Street,
                   schools$`Local authority (name)`,
                   schools$Town,
                   schools$Postcode,
                   "United Kingdom",
                   sep = ", ")

# Geocoding using opencage libraries (OpenCage Geocoder).

Sys.setenv(OPENCAGE_KEY = "d8bad6132bc947208d9621c6f80bf466")

### Set up an empty 3 col dataframe to populate with coord and town name from OC

col.names <- c("lat", "long", "town", "address")
geocodes_opencage <- matrix(nrow = length(addresses), ncol = 4)
colnames(geocodes_opencage) <- col.names

### Bulk1: Geocode by village, country

for(i in 5018:nrow(geocodes_opencage)) {
  res <- opencage_forward(placename = addresses[i], # LongName
                          countrycode = "GB", # ISO2 code
                          min_confidence = 5,
                          no_annotations = TRUE,
                          no_dedupe = TRUE)
  
  # check paratemeters available at opencage_forward()
    
  a <- ifelse(is.null(res$results$geometry.lat[1]), NA, res$results$geometry.lat[1])
  # Retrieve latitude from best guess based on Opencage
  b <- ifelse(is.null(res$results$geometry.lng[1]), NA, res$results$geometry.lng[1])
  # Retrieve longitude from best guess based on Opencage
  c <- ifelse(is.null(res$results$confidence[1]), NA, as.character(res$results$confidence[1]))
  # Retrieve location name matched from search
  d <- ifelse(is.null(res$results$formatted[1]),NA,as.character(res$results$formatted[1]))
  # Retrieve more detailed address from location
  
  # Extract long and lat and town from the output list corresponding to the first search of the list.
  
  geocodes_opencage[i,1] <- a
  geocodes_opencage[i,2] <- b
  geocodes_opencage[i,3] <- c
  geocodes_opencage[i,4] <- d
  print(i)
}

geocodes_opencage <- as.data.frame(geocodes_opencage)
df <- cbind(addresses, geocodes_opencage)
df$town <- NULL
names(df) <- c("input_address", "lat", "long", "output_address")
readr::write_csv(df, "output/geocoded_schools.csv")

df <- readr::read_csv("output/geocoded_schools.csv")

id_na <- which(is.na(df[, c("X", "Y")]), arr.ind = T)
View(df[id_na, ])
View(schools[id_na, ])

df[id_na[1], "lat"] <- 51.485178
df[id_na[1], "long"] <- -0.170088

df[id_na[2], "lat"] <- 53.526760
df[id_na[2], "long"] <- -2.171607

df[id_na[3], "lat"] <- 54.208303
df[id_na[3], "long"] <- -3.268257

df[id_na[4], "lat"] <- 52.828011 
df[id_na[4], "long"] <- -1.425838

df[id_na[5], "lat"] <- 50.923564
df[id_na[5], "long"] <- -0435038

df[id_na[6], "lat"] <- 54.486515
df[id_na[6], "long"] <- -1.704126

df[id_na[7], "lat"] <- 53.750817
df[id_na[7], "long"] <- -2.741861

# Convert to british CRS 27700

df %>% 
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>% 
  st_transform(crs = 27700) %>% 
  st_coordinates() %>%
  as.data.frame() %>% 
  readr::write_csv("output/geocoded_schools.csv")
