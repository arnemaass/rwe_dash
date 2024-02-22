rm(list=ls())

library(tidyverse)
library(arrow)
library(reshape2)
library(readxl)


setwd("C:/Users/user/OneDrive/Desktop/WZB/PMK/2024/quarto_dash")


pmk <- read_excel("data/PMK.xlsx")

pmk$land <- factor(pmk$land, levels= c("Deutschland","Baden-Württemberg","Bayern", "Berlin", 
                                       "Brandenburg", "Bremen", "Hamburg", "Hessen", "Mecklenburg-Vorpommern",
                                       "Niedersachsen", "Nordrhein-Westphalen", "Rheinland-Pfalz", "Saarland",
                                       "Sachsen", "Sachsen-Anhalt", "Schleswig-Hollstein", "Thüringen"))

data <- melt(pmk, id.vars = c("jahr", "land"))
data$ID <- rownames(data)

data2 <- data %>% 
  group_by(jahr, value) %>% 
  mutate(rn = row_number()) %>% 
  ungroup() %>% 
  pivot_wider(names_from = land, values_from = value)

data2$variable <- recode(data2$variable, "rstraf"="Straftaten-rechts",
                         "lstraf"="Straftaten-links",
                         "islstraf"="Straftaten-islamistisch" ,
                         "ausstraf"="Straftaten-ausländisch",
                         "rgewalt"="Gewalttaten-rechts",
                         "lgewalt"="Gewalttaten-links", 
                         "islgewalt"="Gewalttaten-islamistisch",
                         "ausgewalt"="Gewalttaten-ausländisch")

data2 <- subset(data2, data2$variable != "reichsgewalt" & data2$variable !="reichsstraf"& data2$variable != "...13")


write_parquet(data2, "data/PMK_shiny.parquet")

