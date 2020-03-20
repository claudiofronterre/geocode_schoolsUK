# Geocoding schools in England

A data set of scools in England was downloaded from the [data.gov.uk website](https://data.gov.uk/dataset/67f809fb-7bfe-4baa-abe4-090d48cfc323/schools-in-england). 
It contains information on all schools in England including local authority maintained schools, 
academies, free schools, studio schools, university technical colleges and independent schools. 
The information includes address, school type and phone number. This information comes from EduBase, 
DfE’s register of schools.

The dataset used here is dated July 2017.

The [GeoConvert](http://geoconvert.mimas.ac.uk/) tool from UK Data Service was
used to geocode schools' postcodes. Not all the schools' postcodes were in the 
census database so geocoding with freely available gazetteers ([opencage](https://opencagedata.com/))
was performed on the un-matched schools.

## Data description 

The final dataset contains a total of 24301 schools, 18279 of which found a match
in census data so also total number of residentes and total number of households
for the school postcode is available. The geographical coordinates are projected
using the OSGB 1936 / British National Grid (EPSG 27700). The dataset is available
as either a csv file ([download from here](https://github.com/claudiofronterre/geocode_schoolsUK/blob/master/data/processed/schools_full_geocoded.csv)) or as a geopackage file 
([download from here](https://github.com/claudiofronterre/geocode_schoolsUK/blob/master/data/processed/geodata/schools_geocoded.gpkg)). 

The most important columns in the dataset are: 

- **X** = x coordinate
- **Y** = y coordinate
- **tot_residents** = total number of residents at postcode level
- **tot_households** = total number of households at postcode level
- **source** = source for coordinates (either GeoConvert census or opencage)

![schools_spatial](https://github.com/claudiofronterre/geocode_schoolsUK/blob/master/figs/schools_distribution.png)