############################
### MAS6041 DISSERTATION ###
############################

### Simulated SRS variance ###

#----

# Preamble

library(tidyverse)

path <- c("insert/path/to/store/figure/")
set.seed(1234)

#----

# Simulating SRS vs CSS variance

## Specifying sample sizes
sample_size <- seq(1, 5000, 1)
## Defining function to compute SE
compute_se <- function(x){ return( sd(x) / sqrt(length(x)) ) }
## Creating vector to store results
std_errors <- c()

## Looping over sample sizes
for (size in sample_size) {
  
  # Sampling from N(0,1)
  mu_hat <- rnorm(n = size, mean = 0, sd = 5)
  # Computing SE
  mu_se <- compute_se(mu_hat)
  # Storing SE in results vector
  std_errors <- append(std_errors, mu_se)
  
}

## Putting results in dataframe
var_data <- data.frame(size = sample_size,
                       se = std_errors)

#----

# Plotting results

ggplot(data = var_data, aes(x = size, y = se)) +
  geom_smooth(method = "loess", color = "black", se = FALSE) +
  theme_bw() +
  labs(title = "",
       x = "Sample size",
       y = "Standard error") +
  scale_x_continuous(limits = c(0, 5000), breaks = seq(0, 5000, by = 500)) +
  scale_y_continuous(limits = c(0, 0.4), breaks = seq(0, 0.4, by = 0.1)) +
  theme(axis.title = element_text(size = 11),
        axis.text = element_text(size = 11)) +
  geom_segment(aes(x = 250, y = 0.2), xend = 250, yend = 0.125,
               arrow = arrow(length = unit(0.4, "cm"))) +
  geom_segment(aes(x = 1500, y = 0.2), xend = 1500, yend = 0.275,
               arrow = arrow(length = unit(0.4, "cm"))) +
  geom_segment(aes(x = 2500, y = 0.2), xend = 2500, yend = 0.275,
               arrow = arrow(length = unit(0.4, "cm"))) +
  geom_text(x = 250, y = 0.115, label = "Stratification", size = 4, color = "seagreen") +
  geom_text(x = 1500, y = 0.285, label = "Clustering", size = 4, color = "red2") +
  geom_text(x = 2500, y = 0.285, label = "Weighting", size = 4, color = "red2")

# Saving plot as 600dpi PNG

ggsave(paste0(path, "srs_se.png"), units = "cm", width = 20, height = 14, device = "tiff", dpi = 600)

