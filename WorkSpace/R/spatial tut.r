library(rgdal)
library(sp)
library(leaflet)
library(ggmap)
library(dplyr)
library(foregin)

## https://app.dominodatalab.com/u/hanyki/spatial-analysis/compare-revisions/ReadMe.md?baseCommitId=41a27dc1cd743751fff4fd74bb5feec5c8a40245&targetCommitId=3cef18b77db34b31c74852ea649a1140bee70ed1

## https://www.youtube.com/watch?v=hDy0y-H_HRQ
## 18:45


shapeData <- readOGR("h27ka13.shp")

shape <- readOGR("population.shp")
#shapeData <- spTransform(shapeData, CRS("+proj=longlat +datum=WGS84 +no_defs"))


#ogrInfo(".",'myGIS')

map <- leaflet()  %>%
  addProviderTiles("CartoDB.Positron") %>% 
  
  addPolygons(data=shapeData , weight = 1,col = 'red', 
              popup = ~paste(
                "<h3 style = 'color: Black' >" , shapeData$S_NAME, "</h3>", 
                "<b>Ward:</b>", shapeData$CITY_NAME, "<br>",
                "<b>t:</b>", shapeData$GST_NAME,
                
                sep = " ")) %>% 
  
  setView(lat  = 35.671, lng  = 139.755, zoom = 12)



map <- leaflet()  %>%
  addProviderTiles("CartoDB.Positron") %>% 
  
  addPolygons(data=shape , weight = 1,col = 'red', 
              popup = ~paste(
                "<h3 style = 'color: Black' >" , shape$CITYNAME, "</h3>", 
                "<b>Population:</b>", shape$JINKO, "<br>",
                "<b>Area</b>", shape$MENSEKI,
                
                sep = " ")) %>% 
  
  setView(lat  = 35.671, lng  = 139.755, zoom = 12)

map






################### tut of shp


crime_df <- subset(crime)

# structure 
str(crime_df)
head(crime_df , n = 5)
summary(crime_df)


crime_df <- data.frame(crime_df) %>% 
  filter(lon != "NA")

# factorize
crime_df$offense <- as.factor(crime_df$offense)
crime_df$month <- as.factor(crime_df$month)
crime_df$day <- as.factor(crime_df$day)


# cleaning it 
crime_df <- data.frame(crime_df) %>% 
  completeFun(c("lon", "lat"))

completeFun <- function(data, desiredCols) {
  completeVec <- complete.cases(data[, desiredCols])
  return(data[completeVec, ])
}



# convert to spital one 
coords <- SpatialPoints(crime_df[, c("lon", "lat")])
crime_spatial_df <- SpatialPointsDataFrame(coords, crime_df)
proj4string(crime_spatial_df) <- CRS("+proj=longlat +ellps=WGS84")

  

