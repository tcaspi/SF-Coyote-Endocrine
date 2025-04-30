library(tidyverse)
library(brms)
library(parallel)
library(DHARMa.helpers)
library(ggpubr)

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

#### CORRELATIONS OF HORMONE PAIRS - ALL SAMPLES #####

# load data (n = 423 total samples)
hormones_diet <- read.csv("Cleaned_Data/clean_hormone_all_diet.csv")

nrow(hormones_diet)

# Correlation test
cor.GC.T3 <- cor.test(hormones_diet$logGC, hormones_diet$logT3)
cor.GC.T4 <- cor.test(hormones_diet$logGC, hormones_diet$logT4)
cor.T4.T3 <- cor.test(hormones_diet$logT3, hormones_diet$logT4)

cor.GC.T3
cor.GC.T4
cor.T4.T3

# Construct models
my.cores <- detectCores()

mod.corr.GC.T3 <- brm(logGC ~ logT3, data = hormones_diet,
                      warmup = 1000,iter = 5000, thin=2,
                      chains = 4, 
                      seed = 666,
                      cores  = my.cores)

mod.corr.GC.T4 <- brm(logGC ~ logT4, data = hormones_diet,
                      warmup = 1000,iter = 5000, thin=2,
                      chains = 4, 
                      seed = 666,
                      cores  = my.cores)

mod.corr.T4.T3 <- brm(logT4 ~ logT3, data = hormones_diet,
                      warmup = 1000,iter = 5000, thin=2,
                      chains = 4, 
                      seed = 666,
                      cores  = my.cores)

# Check fit
pp_check(mod.corr.GC.T3, ndraws = 100)
pp_check(mod.corr.GC.T4, ndraws = 100)
pp_check(mod.corr.T4.T3, ndraws = 100)

dh_check_brms(mod.corr.GC.T3)
dh_check_brms(mod.corr.GC.T4)
dh_check_brms(mod.corr.T4.T3)

# Model results
summary(mod.corr.GC.T3)
summary(mod.corr.GC.T4)
summary(mod.corr.T4.T3)

# Extract r and p values for figures
value_cor.GC.T3 <- bquote(italic(r) == .(round(cor.GC.T3$estimate, 2)))
value_p.GC.T3 <- expression(italic(p) < 0.001)
value_cor.GC.T4 <- bquote(italic(r) == .(round(cor.GC.T4$estimate, 2)))
value_p.GC.T4   <- bquote(italic(p) == .(round(cor.GC.T4$p.value, 2)))
value_cor.T4.T3 <- bquote(italic(r) == .(round(cor.T4.T3$estimate, 2)))
value_p.T4.T3   <- expression(italic(p) < 0.001)

# Extract conditional effects
cond_GC_T3 <- conditional_effects(mod.corr.GC.T3)
cond_GC_T4 <- conditional_effects(mod.corr.GC.T4)
cond_T4_T3 <- conditional_effects(mod.corr.T4.T3)

cond_GC_T3 <- data.frame(cond_GC_T3$logT3)
cond_GC_T4 <- data.frame(cond_GC_T4$logT4)
cond_T4_T3 <- data.frame(cond_T4_T3$logT3)

# Make plots
p.corr.GC.T3 <- ggplot() +
  
  geom_ribbon(data = cond_GC_T3, aes(x = logT3, ymin = lower__, ymax = upper__), alpha = 0.5, fill = "#8C8076") +
  
  geom_line(data = cond_GC_T3, aes(x = logT3, y = (estimate__)), color = "#2D2926", size = 1) +
  
  geom_point(data = hormones_diet, aes(x = logT3, y = logGC), color = "#2D2926", alpha = 0.3, size=1) +
  
  # Common graphics
  xlab("Log Triiodothyronine (ng/g)") +
  ylab("Log Glucocorticoids (ng/g)") +
  theme_custom() +
  scale_y_continuous(limits = c(1.5, 7.5), breaks = c(2, 3, 4, 5, 6, 7))+
  scale_x_continuous(limits = c(1.5, 7.5), breaks = c(2, 3, 4, 5, 6, 7),
                     expand = c(0, 0))+
  
  # Add annotation
  annotate("text", x = 1.8, y = 7.4, label = value_cor.GC.T3, hjust = 0, size = 3) +
  annotate("text", x = 1.8, y = 7.0, label = value_p.GC.T3, hjust = 0, size = 3)

p.corr.GC.T4 <- ggplot() +
  
  geom_ribbon(data = cond_GC_T4, aes(x = logT4, ymin = lower__, ymax = upper__), alpha = 0.5, fill = "#8C8076") +
  
  geom_line(data = cond_GC_T4, aes(x = logT4, y = (estimate__)), color = "#2D2926", size = 1) +
  
  geom_point(data = hormones_diet, aes(x = logT4, y = logGC), color = "#2D2926", alpha = 0.3, size=1) +
  
  # Common graphics
  xlab("Log Thyroxine (ng/g)") +
  ylab("Log Glucocorticoids (ng/g)") +
  theme_custom() +
  scale_y_continuous(limits = c(1.5, 7.5), breaks = c(2, 3, 4, 5, 6, 7))+
  scale_x_continuous(limits = c(1.5, 7.5), breaks = c(2, 3, 4, 5, 6, 7),
                     expand = c(0, 0))+
  
  # Add annotation
  annotate("text", x = 1.8, y = 7.4, label = value_cor.GC.T4, hjust = 0, size = 3) +
  annotate("text", x = 1.8, y = 7.0, label = value_p.GC.T4, hjust = 0, size = 3)

p.corr.T4.T3 <- ggplot() +
  
  geom_ribbon(data = cond_T4_T3, aes(x = logT3, ymin = lower__, ymax = upper__), alpha = 0.5, fill = "#8C8076") +
  
  geom_line(data = cond_T4_T3, aes(x = logT3, y = (estimate__)), color = "#2D2926", size = 1) +
  
  geom_point(data = hormones_diet, aes(x = logT3, y = logGC), color = "#2D2926", alpha = 0.3, size=1) +
  
  # Common graphics
  xlab("Log Triiodothyronine (ng/g)") +
  ylab("Log Thyroxine (ng/g)") +
  theme_custom() +
  scale_y_continuous(limits = c(1.5, 7.5), breaks = c(2, 3, 4, 5, 6, 7))+
  scale_x_continuous(limits = c(1.5, 7.5), breaks = c(2, 3, 4, 5, 6, 7),
                     expand = c(0, 0))+
  
  # Add annotation
  annotate("text", x = 1.8, y = 7.4, label = value_cor.T4.T3, hjust = 0, size = 3) +
  annotate("text", x = 1.8, y = 7.0, label = value_p.T4.T3, hjust = 0, size = 3)

# Arrange figure
ggarrange(p.corr.GC.T3, p.corr.GC.T4, p.corr.T4.T3, nrow=1)

# ggsave("Figures/Figure1.png", dpi=600, height=2.5, width=8)
