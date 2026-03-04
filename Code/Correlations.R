library(tidyverse)
library(brms)
library(parallel)
library(DHARMa.helpers)
library(ggpubr)
library(bayestestR)

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

#### CORRELATIONS OF HORMONE PAIRS #####

# Load data
hormones_geno <- read.csv("Cleaned_Data/clean_hormone_genotypes_diet.csv")

sites.to.drop <- c("Stern Grove", "Sunset Reservoir") # remove scats collected in non-established territories

# create data frame
cor.data <- hormones_geno %>%
filter(!Territory %in% sites.to.drop) # drop sites

# Construct models: include individual ID and Territory as random effects
my.cores <- detectCores()

mod.corr.GC.T3 <- brm(logGC ~ logT3 + (1 |Individual) + (1|Territory), data = cor.data,
                      warmup = 2000,iter = 6000, thin=2,
                      chains = 4, 
                      seed = 666,
                      cores  = my.cores,
                      control = list(adapt_delta = 0.99, max_treedepth = 15))

mod.corr.GC.T4 <- brm(logGC ~ logT4 + (1 |Individual) + (1|Territory), data = cor.data,
                      warmup = 2000,iter = 6000, thin=2,
                      chains = 4, 
                      seed = 666,
                      cores  = my.cores,
                      control = list(adapt_delta = 0.99, max_treedepth = 15))

mod.corr.T4.T3 <- brm(logT4 ~ logT3 + (1 |Individual) + (1|Territory), data = cor.data,
                      warmup = 2000,iter = 6000, thin=2,
                      chains = 4, 
                      seed = 666,
                      cores  = my.cores,
                      control = list(adapt_delta = 0.99, max_treedepth = 15))

saveRDS(mod.corr.GC.T3, "Model_Output/mod.corr.GC.T3.rds")
saveRDS(mod.corr.GC.T4, "Model_Output/mod.corr.GC.T4.rds")
saveRDS(mod.corr.T4.T3, "Model_Output/mod.corr.T4.T3.rds")

mod.corr.GC.T3 <- readRDS("Model_Output/mod.corr.GC.T3.rds")
mod.corr.GC.T4 <- readRDS("Model_Output/mod.corr.GC.T4.rds")
mod.corr.T4.T3 <- readRDS("Model_Output/mod.corr.T4.T3.rds")

# Check model fit
pp_check(mod.corr.GC.T3, ndraws = 100)
pp_check(mod.corr.GC.T4, ndraws = 100)
pp_check(mod.corr.T4.T3, ndraws = 100)

dh_check_brms(mod.corr.GC.T3)
dh_check_brms(mod.corr.GC.T4)
dh_check_brms(mod.corr.T4.T3)

# r2 values
r2_GC.T3 <- performance::r2_bayes(mod.corr.GC.T3)
r2_GC.T4 <- performance::r2_bayes(mod.corr.GC.T4)
r2_T4.T3 <- performance::r2_bayes(mod.corr.T4.T3)

# Extract model results
models_corr <- list(
  mod.corr.GC.T3 = mod.corr.GC.T3,
  mod.corr.GC.T4 = mod.corr.GC.T4,
  mod.corr.T4.T3 = mod.corr.T4.T3)

# Function to summarize posterior estimates
summarize_posteriors <- function(model, model_name) {
  posterior_estimates <- posterior_samples(model) 
  posterior_estimates <- posterior_estimates[, 1:4]
  
  do.call(rbind, lapply(names(posterior_estimates), function(param) {
    values <- posterior_estimates[[param]]
    ci_vals <- bci(values, ci = 0.95) 
    data.frame(
      Model = model_name,
      Effect = param,
      Estimate = round(mean(values), 2),
      lower = round(ci_vals$CI_low, 2),
      upper = round(ci_vals$CI_high, 2)
    )
  }))
}

# Loop through all models and combine results
corr_results <- do.call(rbind, lapply(names(models_corr), function(model_name) {
  summarize_posteriors(models_corr[[model_name]], model_name)
}))

# Format and pivot results
corr_results_clean <- corr_results %>% 
  mutate(est_ci = sprintf("%.2f [%.2f, %.2f]", Estimate, lower, upper)) %>% 
  select(Model, Effect, est_ci) %>% 
  pivot_wider(names_from = Model, values_from = est_ci)

# Define order for the parameter column
order <- c(
  "b_Intercept",
  "b_logT3",
  "b_logT4",
  "sd_Individual__Intercept",
  "sd_Territory__Intercept")  

final_corr_results <- corr_results_clean %>% 
  mutate(Effect = factor(Effect, levels = order)) %>%
  arrange(Effect)

View(final_corr_results)

# Extract slope and r2 values for figures
value_slope.GC.T3 <- bquote(italic(β) == .(final_corr_results$mod.corr.GC.T3[2]))
value_r2.GC.T3 <- bquote("Marginal" ~ R^2 == .(round(r2_GC.T3$R2_Bayes_marginal, 3)))

value_slope.GC.T4 <- bquote(italic(β) == .(final_corr_results$mod.corr.GC.T4[3]))
value_r2.GC.T4 <- bquote("Marginal" ~ R^2 == .(round(r2_GC.T4$R2_Bayes_marginal, 3)))

value_slope.T4.T3 <- bquote(italic(β) == .(final_corr_results$mod.corr.T4.T3[2]))
value_r2.T4.T3 <- bquote("Marginal" ~ R^2 == .(round(r2_T4.T3$R2_Bayes_marginal, 3)))


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
  
  geom_point(data = cor.data, aes(x = logT3, y = logGC), color = "#2D2926", alpha = 0.3, size=1) +
  
  # Common graphics
  xlab("Log Triiodothyronine (ng/g)") +
  ylab("Log Glucocorticoids (ng/g)") +
  theme_custom() +
  scale_y_continuous(limits = c(1.5, 7.5), breaks = c(2, 3, 4, 5, 6, 7))+
  scale_x_continuous(limits = c(1.5, 7.5), breaks = c(2, 3, 4, 5, 6, 7),
                     expand = c(0, 0))+
  
  # Add annotation
  annotate("text", x = 1.8, y = 7.4, label = value_slope.GC.T3, hjust = 0, size = 2.5) +
  annotate("text", x = 1.8, y = 7.0, label = value_r2.GC.T3, hjust = 0, size = 2.5)

p.corr.GC.T4 <- ggplot() +
  
  geom_ribbon(data = cond_GC_T4, aes(x = logT4, ymin = lower__, ymax = upper__), alpha = 0.5, fill = "#8C8076") +
  
  geom_line(data = cond_GC_T4, aes(x = logT4, y = (estimate__)), color = "#2D2926", size = 1, linetype="dashed") +
  
  geom_point(data = cor.data, aes(x = logT4, y = logGC), color = "#2D2926", alpha = 0.3, size=1) +
  
  # Common graphics
  xlab("Log Thyroxine (ng/g)") +
  ylab("Log Glucocorticoids (ng/g)") +
  theme_custom() +
  scale_y_continuous(limits = c(1.5, 7.5), breaks = c(2, 3, 4, 5, 6, 7))+
  scale_x_continuous(limits = c(1.5, 7.5), breaks = c(2, 3, 4, 5, 6, 7),
                     expand = c(0, 0))+
  
  # Add annotation
  annotate("text", x = 1.8, y = 7.4, label = value_slope.GC.T4, hjust = 0, size = 2.5) +
  annotate("text", x = 1.8, y = 7.0, label = value_r2.GC.T4, hjust = 0, size = 2.5)

p.corr.T4.T3 <- ggplot() +
  
  geom_ribbon(data = cond_T4_T3, aes(x = logT3, ymin = lower__, ymax = upper__), alpha = 0.5, fill = "#8C8076") +
  
  geom_line(data = cond_T4_T3, aes(x = logT3, y = (estimate__)), color = "#2D2926", size = 1) +
  
  geom_point(data = cor.data, aes(x = logT3, y = logGC), color = "#2D2926", alpha = 0.3, size=1) +
  
  # Common graphics
  xlab("Log Triiodothyronine (ng/g)") +
  ylab("Log Thyroxine (ng/g)") +
  theme_custom() +
  scale_y_continuous(limits = c(1.5, 7.5), breaks = c(2, 3, 4, 5, 6, 7))+
  scale_x_continuous(limits = c(1.5, 7.5), breaks = c(2, 3, 4, 5, 6, 7),
                     expand = c(0, 0))+
  
  # Add annotation
  annotate("text", x = 1.8, y = 7.4, label = value_slope.T4.T3, hjust = 0, size = 2.5) +
  annotate("text", x = 1.8, y = 7.0, label = value_r2.T4.T3, hjust = 0, size = 2.5)

# Arrange figure
ggarrange(p.corr.GC.T3, p.corr.GC.T4, p.corr.T4.T3, nrow=1)

# ggsave("Figures/hormone_correlation_plots.png", dpi=600, height=2.5, width=8)


