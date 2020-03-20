# LOAD REQUIRED PACKAGES AND FUNCTIONS -----------------------------------------
if (!require("pacman")) install.packages("pacman")
pkgs = c("dplyr") # package names
pacman::p_load(pkgs, character.only = T)

# LOAD DATA --------------------------------------------------------------------
schools <- readr::read_csv("data/original/EduBase_Schools_July_2017.csv")

# DATA PREPARATION -------------------------------------------------------------

# The geoconvert toool needs a one column csv file with the postcode
schools %>% 
  select(Postcode) %>% 
  readr::write_csv("data/processed/schools_input_geoconvert.csv")

# MERGE OUTPUT OF GEOCONVERT TOOL ----------------------------------------------

# The following steps require that the input file schools_to_geocode.csv
# is passed to the GeoConvert tool http://geoconvert.mimas.ac.uk/ and 
# the output stored in the output folder

# Load the schools that matched in census the data
match <- readr::read_csv("output/18262828_matched.csv")

# Add 4 new columns 
schools$X <- NA
schools$Y <- NA
schools$tot_residents <- NA
schools$tot_households <- NA

# Add these new info for the matched schools
schools[match$input_row, c("X", "Y", "tot_residents", "tot_households")] <- match[, c(5, 6, 3, 4)]

# Add the data source
schools$source <- NA
schools$source[match$input_row] <- "geoconvert_census" 

# Load the schools that did not match with the census data
nomatch <- readr::read_csv("output/18262828_unmatched.csv")

# Save them for further geocoding
readr::write_csv(schools[nomatch$input_row, ], "data/processed/schools_to_geocode.csv") 

# Now run script 2 then come back with the geocoded_schools

# Load the geocoded schools
geocoded_schools <- readr::read_csv("output/geocoded_schools.csv")


schools[nomatch$input_row, c("X", "Y")] <- geocoded_schools

schools$source[nomatch$input_row] <- "geocoded_opencage"

schools <- filter(schools, !is.na(X))

table(schools$source)

readr::write_csv(schools, "data/processed/schools_full_geocoded.csv")
