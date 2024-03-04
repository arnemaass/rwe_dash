# RWM Preprocessing

rm(list = ls())
setwd("C:/Users/user/OneDrive/Desktop/WZB/PMK/2024/quarto_dash")

library(tidyverse)
library(sf)

rwm<- readRDS("data/data_kreise.rds") # already merged with district shapefiles


# Create a complete geometry grid for all years
rwm1 <- rwm %>%
  group_by(year, geometry) %>%
  summarise(participants=sum(participants, na.rm = TRUE)+1,
            demo_count= n()+1) %>%
  ungroup()

# get the cross product of years and geometry, add kreise
YG_grid <- crossing(year = unique(rwm$year), geometry = rwm$geometry) %>% left_join(distinct(select(rwm,geometry,kreis)), by = "geometry")


rwm1 <- left_join(YG_grid, rwm1, by = c("year", "geometry"))%>%
  replace_na(list(participants = 1, demo_count = 1)) %>%
  st_as_sf()

saveRDS(rwm1, "data/rwm_shiny.rds")


