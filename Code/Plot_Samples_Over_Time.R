library(tidyverse)

# Make custom theme
theme_custom <- function() {
  theme_default() +
    theme(panel.grid.minor = element_blank(),
          plot.background = element_rect(fill = "white", color = NA),
          plot.title = element_text(size = 7),
          strip.background = element_rect(fill = "grey80", color = NA),
          axis.text.y = element_text(size=10),
          axis.text.x = element_text(size=10),
          axis.title.y = element_text(size=10),
          axis.title.x = element_text(size=10),
          legend.background = element_rect(fill = "white", color = NA))}

# Load data frames
hormones_geno <- read.csv("Cleaned_Data/clean_hormone_genotypes_diet.csv")

# Remove scats collected in non-established territories
sites.to.drop <- c("Stern Grove", "Sunset Res")

# Create data frame for DHGLM models (5 or more samples per individual)
dhglm_df <- hormones_geno %>% 
  mutate(Breeder = if_else(Breeder == "", "No", Breeder))%>% 
  filter(!Territory %in% sites.to.drop) %>% 
  group_by(Individual) %>% 
  add_count %>% 
  ungroup() %>% 
  filter(n >= 5) %>%  # only keep individuals with 5 or more samples 
  filter(Individual != "SFCoy31") %>% # remove SFCoy31 with bad sapmple representation
  # select relevant covs
  select(SampleID, GC, T3, T4, Year, Month, Day, Biol.Season, Territory, Condition,
         Individual, Sex, Breeder, Anthropogenic, n)

# create data frame for GC without the NA values from the outlier sample
dhglm_df_GC <- dhglm_df %>% filter(SampleID != "S21_0009")

# Format date for plotting
dhglm_df$Date <- as.Date(paste(dhglm_df$Year, dhglm_df$Month, dhglm_df$Day, sep = "-"))

df_date <- dhglm_df
df_date <- df_date[order(df_date$Date), ]

dhglm_df_GC$Date <- as.Date(paste(dhglm_df_GC$Year, dhglm_df_GC$Month, dhglm_df_GC$Day, sep = "-"))

df_date_GC <- dhglm_df_GC
df_date_GC <- dhglm_df_GC[order(dhglm_df_GC$Date), ]

# Plot
ggplot(dhglm_df_GC, aes(x = Date, y = log(GC))) +
  geom_point(size=2, alpha=0.5, fill="#A4193D", color="black", shape=21) +  
  geom_line(linewidth=0.6, alpha=0.8) +  
  facet_wrap(~Individual, ncol=5)+
  labs(x = "Date",
       y = "Glucocorticoids (ng/g)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  scale_x_date(date_breaks = "3 month")+
scale_y_continuous(limits=c(1.5,7.5),
                   breaks=c(2,3,4,5,6,7))

# ggsave("Figures/FigureS3.png", height = 6, width = 10, dpi=600)

ggplot(df_date, aes(x = Date, y = log(T3))) +
  geom_point(size=2, alpha=0.5, fill="#FF7522", color="black", shape=21) +  
  geom_line(linewidth=0.6, alpha=0.8) +  
  facet_wrap(~Individual, ncol=5)+
  labs(x = "Date",
       y = "Triiodothyronine (ng/g)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  scale_x_date(date_breaks = "3 month")+
scale_y_continuous(limits=c(1.5,7.5),
                   breaks=c(2,3,4,5,6,7))

# ggsave("Figures/FigureS4.png", height = 6, width = 10, dpi=600)

ggplot(df_date, aes(x = Date, y = log(T4))) +
  geom_point(size=2, alpha=0.5, fill="#2D661C", color="black", shape=21) +  
  geom_line(linewidth=0.6, alpha=0.8) +  
  facet_wrap(~Individual, ncol=5)+
  labs(x = "Date",
       y = "Thyroxine (ng/g)") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  scale_x_date(date_breaks = "3 month")+
scale_y_continuous(limits=c(1.5,7.5),
                   breaks=c(2,3,4,5,6,7))

# ggsave("Figures/FigureS5.png", height = 6, width = 10, dpi=600)
