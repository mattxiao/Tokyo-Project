

shape <- readOGR("population.shp")

bins <- c(0, 50000, 80000, 150000, 250000, 400000, 600000, 700000, Inf)
pal <- colorBin("YlOrRd", domain = shape$JINKO, bins = bins)

labels <- sprintf(
  "<strong>%s</strong><br/>%g people",
  shape$CITYNAME, shape$JINKO
) %>% lapply(htmltools::HTML)





m <- leaflet(shape) %>% 
  
  addProviderTiles("CartoDB.Positron")   %>% 
  
  addPolygons(
    fillColor = ~pal(JINKO),
    weight = 2,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.7,
    
    highlight = highlightOptions(
      weight = 5,
      color = "#666",
      dashArray = "",
      fillOpacity = 0.7,
      bringToFront = TRUE),
    
    label = labels,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "15px",
      direction = "auto")) %>% 
  
  addLegend(pal = pal, values = ~JINKO, opacity = 0.7, title = NULL,
                position = "bottomright")

m 




