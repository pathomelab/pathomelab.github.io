library(lubridate)
library(janitor)
library(tidyverse)
library(magrittr)
library(Matrix)

library(OpenStreetMap)
library(ggplot2)
library(gridExtra)
library(plotly)

library(adehabitatLT)
library(adehabitatHR)
library(sp)
library(sf)


# Pull in data ------------------------------------------------------------

tractive = 
  bind_rows(
    read_csv("C:/Users/dksewell/OneDrive - University of Iowa/pathome/projects/data_management/pathome_data/curated_data_for_aphrc/tractive_infants_overall_filtered.csv"),
    read_csv("C:/Users/dksewell/OneDrive - University of Iowa/pathome/projects/data_management/pathome_data/curated_data_for_aphrc/tractive_animals_overall_filtered.csv")
  )

tractive %<>%
  mutate(city = ifelse(grepl("nairobi",
                             tolower(id_city)),
                       "Nairobi",
                       "Kisumu"))

tractive %$%
  table(species,city)

range_by_animal = 
  tractive %>% 
  filter(city == "Kisumu") %>% 
  group_by(species) %>% 
  summarize(high = max(lat),
            low = min(lat),
            left = min(lon),
            right = max(lon))
range_by_animal = 
  matrix(as.matrix(range_by_animal[,-1]),5,4,
         dimnames = list(tolower(range_by_animal$species),
                         colnames(range_by_animal)[-1]))

for(j in 1:nrow(range_by_animal)){
  range_by_animal[j,1:2] = 
    range_by_animal[j,1:2] + 
    c(1,-1) * abs(diff(range_by_animal[j,1:2])) * 0.05
  range_by_animal[j,2 + 1:2] = 
    range_by_animal[j,2 + 1:2] + 
    c(-1,1) * abs(diff(range_by_animal[j,2 + 1:2])) * 0.05
}



# Humans ------------------------------------------------------------------

humans = 
  tractive %>% 
  filter(city == "Kisumu",
         species == "human")


c(range_by_animal["human","high"],
  range_by_animal["human","left"])
c(range_by_animal["human","low"],
  range_by_animal["human","right"]) # There's an outlier here...
lat_eps = 0.042
lon_eps = 0.034

humans = 
  humans %>% 
  filter(id_city != humans$id_city[which.min(humans$lat)])

human_map = 
  openmap(upperLeft = c(median(humans$lat) + lat_eps,
                        median(humans$lon) - lon_eps),
          lowerRight = c(median(humans$lat) - lat_eps,
                         median(humans$lon) + lon_eps),
          type = "esri-imagery") %>%
  openproj()
par(mfrow=c(2,1))
plot(human_map)
for(i in unique(humans$id_city)){
  print(i)
  temp =
    humans %>%
    filter(id_city == i)
  lines(temp$lon,
        temp$lat,
        col = "skyblue")
}


geosphere::distHaversine(c(-0.0991,
                           34.7672),
                         c(c(-0.0991 + 0.0015,
                             34.7672) )) # 137
geosphere::distHaversine(c(-0.0991,
                           34.7672),
                         c(c(-0.0991,
                             34.7672 + 0.0015) )) # 167

set.seed(2024)
humans_deid = 
  humans %>% 
  group_by(id_city) %>% 
  mutate(lat = lat + rnorm(1,sd = 0.0015),
         lon = lon + rnorm(1,sd = 0.0015))
plot(human_map)
for(i in unique(humans$id_city)){
  print(i)
  temp =
    humans_deid %>%
    filter(id_city == i)
  lines(temp$lon,
        temp$lat,
        col = "skyblue")
}

human_map_gg = 
  human_map %>% 
  autoplot()


# human_map_plotly =
#   human_map_gg +
#   geom_bin2d(data = humans_deid,
#              aes(x = lon,
#                  y = lat),
#              alpha = 0,
#              bins = 125) +
#   geom_path(data =
#               humans_deid %>%
#               arrange(datetime),
#             aes(x = lon,
#                 y = lat,
#                 group = id_city),
#             alpha = 1,
#             colour = "goldenrod1") + 
#   scale_fill_gradientn(colours = RColorBrewer::brewer.pal(9,"Reds")) +
#   ylab("") +
#   xlab("")+
#   theme_minimal() +
#   theme(axis.ticks = element_blank(),
#         axis.text = element_blank(),
#         legend.position = "none",
#         panel.grid.major = element_blank(), 
#         panel.grid.minor = element_blank(), 
#         plot.margin = unit(c(0,0,0,0),"cm")) +
#   theme(plot.margin = unit(c(0,0,0,0),"cm"))

human_map_plotly =
  human_map_gg +
  geom_point(data =
              humans_deid[1:10,] %>%
              arrange(datetime),
            aes(x = lon,
                y = lat),
            alpha = 0,
            size = 0) + 
  geom_path(data =
              humans_deid %>%
              arrange(datetime),
            aes(x = lon,
                y = lat,
                group = id_city),
            alpha = 0.75,
            colour = "goldenrod1") + 
  ylab("") +
  xlab("") +
  theme_minimal() +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank(),
        legend.position = "none",
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        plot.margin = unit(c(0,0,0,0),"cm"))


human_map_plotly %<>%
  ggplotly(tooltip = NULL)

htmlwidgets::saveWidget(human_map_plotly, 
                        "C:/Users/dksewell/Documents/pathomelab.github.io/deidentified_map-humans.html")



# Animals -----------------------------------------------------------------

animals_deid = 
  tractive %>% 
  filter(city == "Kisumu",
         species != "human") %>% 
  mutate(lat = lat + rnorm(1,sd = 0.0015),
         lon = lon + rnorm(1,sd = 0.0015))
  

animal_map_plotly =
  human_map_gg +
  geom_point(data =
               animals_deid[1:10,] %>%
               arrange(datetime),
             aes(x = lon,
                 y = lat),
             alpha = 0,
             size = 0) + 
  geom_path(data =
              animals_deid %>%
              arrange(datetime),
            aes(x = lon,
                y = lat,
                group = id_city,
                colour = species),
            alpha = 0.75) + 
  ylab("") +
  xlab("") +
  theme_minimal() +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank(),
        legend.position = "none",#"right",
        panel.grid.major = element_blank(),  
        panel.grid.minor = element_blank(),  
        plot.margin = unit(c(0,0,0,0),"cm")) +
    labs(color = "Species") +
    guides(color = guide_legend(override.aes = list(linewidth = 5))) 

animal_map_plotly

# test = 
#   ggplot_build(animal_map_plotly)

animal_map_plotly %<>%
  ggplotly(tooltip = NULL) #%>% 
  # layout(legend = list(
  #   font = list(size = 15),  # Adjust the font size
  #   x = test$layout$panel_params[[1]]$x.range[1],  # Adjust the x position
  #   y = test$layout$panel_params[[1]]$y.range[1]  # Adjust the y position
  # ))

htmlwidgets::saveWidget(animal_map_plotly, 
                        "C:/Users/dksewell/Documents/pathomelab.github.io/deidentified_map-animals.html")


