library(tidyverse)
library(data.table)
library(ggmap)

sf_trees <-fread('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-28/sf_trees.csv')

#write.csv(sf_trees, file ="sf_trees.csv", row.names = F )
sf_trees <-fread('sf_trees.csv')

sf_trees[, .N, by = species] %>%
    .[order(N, decreasing = T)] %>%
    head(10)


sf_trees[, date := as.Date(date)]

sf_trees[, tree_age := difftime(as.Date(Sys.time()), date, "days")]
sf_trees <- sf_trees[latitude < 40]
map <- get_map(c(left = min(sf_trees$longitude, na.rm = T) - .3, 
                 bottom = min(sf_trees$latitude,  na.rm = T) - .3,
                 right = max(sf_trees$longitude, na.rm = T) + .3,
                 top = max(sf_trees$latitude,  na.rm = T) + .3),
               maptype =  "toner")
# Edit to display toner map

sf_trees[, tree_age := as.numeric(tree_age)]

ggmap(map) +
    geom_point(data = sf_trees, aes(longitude, latitude, color = tree_age))
