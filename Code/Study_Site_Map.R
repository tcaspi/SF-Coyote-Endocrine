########### SAMPLE COLLECTION MAP ###########

library(tidyverse)
library(ggmap)
library(ggspatial)

# load data (n = 423 total samples)
hormones_diet <- read.csv("Cleaned_Data/clean_hormone_all_diet.csv") %>% 
  mutate(Territory = 
           if_else(Territory %in% c("Stern Grove", "Sunset Res"), NA_character_, Territory))

# Make custom theme
theme_custom <- function() {
  theme_classic()+
    theme(panel.grid.minor = element_blank(),
          strip.text = element_text(size = 12, face = "bold"),
          plot.background = element_rect(fill = "white", color = NA),
          plot.title = element_text(size = 7),
          strip.background = element_blank(),
          axis.text.y = element_text(size=6),
          axis.text.x = element_text(size=6),
          axis.title.y = element_text(size=10),
          axis.title.x = element_text(size=10))}

# Set colors for each territory
colors <- c("#C8BFE7", "#2E2585", "#7E2954", "#94CBEC", "#DCCD7D", "#FDB462FF", "blue", "#C26A77",  "#5DA899", "#337538", "pink", "black")

family_colors <- c("Bernal" = colors[1],
                   "Coit" = colors[2],
                   "Corona" = colors[3],
                   "GGP - West" = colors[4],
                   "GGP - East" = colors[5],
                   "Glen" = colors[6],
                   "Land's End" = colors[7],
                   "McLaren" = colors[8],
                   "Merced" = colors[9],
                   "Presidio" = colors[10],
                   "St. Francis" = colors[11],
                   "NA" = colors[12])


# Make Study Site Map
register_google(key = "YOUR_KEY_HERE")
register_stadiamaps("YOUR_KEY_HERE", write = TRUE)

bbox <- c(left = -122.52, right = -122.355, bottom = 37.695, top = 37.82)

get_stadiamap(bbox, zoom = 14, maptype = "stamen_terrain", scale=2) %>% ggmap()+
  geom_point(data = hormones_diet, aes(x = Long, y = Lat, fill = Territory), 
             shape = 21, size = 2.5, alpha=0.7, position=position_jitter(width=.002, height = .002),
             color="black") +
  scale_fill_manual(values=family_colors)+
  theme_minimal()+
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        legend.title = element_blank(),
        legend.position = c(0.9, 0.16),
        legend.background = element_rect(fill = "white", color = "black", linewidth = 0.5), 
        legend.box.background = element_rect(fill = "white", color = "black"),
        legend.text = element_text(size = 6),  # Make legend text smaller
        legend.key.size = unit(0.2, "cm"),  # Reduce legend key (color box) size
        legend.spacing.y = unit(0.05, "cm"),
        legend.key.height = unit(0.25, "cm"))+
  annotation_scale(location = "bl", width_hint = 0.2) + 
  coord_sf(crs = 4326)

# ggsave("Figures/FigureS1.png", dpi=600, height=5, width=5)

##########################################################################

# Inset for California with SF County highlighted

library(usmap)

# Define counties to highlight
highlight_counties <- c("San Francisco County")

# Get county-level data for California
county_data <- us_map(regions = "counties") %>%
  filter(full == "California") %>%
  mutate(fill_color = ifelse(county %in% highlight_counties, "#F57E77", "#595959"))

# Plot
ggplot() +
  geom_sf(data = county_data, aes(fill = fill_color), color = NA) +  # Remove county borders
  scale_fill_identity() + 
  theme_void() +
  theme(panel.background = element_rect(fill = "#CCD9E6", color = NA))
