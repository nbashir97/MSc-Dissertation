############################
### MAS6041 DISSERTATION ###
############################

### Artificial data analysis ###

#----

# Preamble

library(tidyverse)
library(survey)

path <- c("insert/path/to/bp/data/")

#----

# Reading in data

bp_data <- read.csv(file = paste0(path, "bp_data.csv"))

# Specifying key quantities

t_quantile <- 0.975
num_obs <- length(bp_data$BP)
num_clusters <- max(bp_data$cluster)
num_strata <- max(bp_data$stratum)

#----

# Computing SRS statistics

srs_mean <- mean(bp_data$BP)
srs_se <- sqrt( var(bp_data$BP) / length(bp_data$BP) )
srs_lci <- srs_mean - qt(p = t_quantile, df = num_obs - 1) * srs_se
srs_uci <- srs_mean + qt(p = t_quantile, df = num_obs - 1) * srs_se

print(paste("Mean:", srs_mean))
print(paste("SE:", srs_se))
print(paste("95% CI:", c(srs_lci, srs_uci)))

#----

# Computing clustered statistics

clust_only <- svydesign(data = bp_data, ids = ~cluster)
svymean(x = ~BP, design = clust_only, deff = "replace")

clus_mean <- svymean(x = ~BP, design = clust_only)[1]
clus_se <- SE(svymean(x = ~BP, design = clust_only))[1]
clus_lci <- clus_mean - qt(p = t_quantile, df = num_clusters - 1) * clus_se
clus_uci <- clus_mean + qt(p = t_quantile, df = num_clusters - 1) * clus_se
clus_deff <- deff(svymean(x = ~BP, design = clust_only, deff = "replace"))

print(paste("Mean:", clus_mean))
print(paste("SE:", clus_se))
print(paste("95% CI:", c(clus_lci, clus_uci)))
print(paste("Design effect (replacement): ", clus_deff))
print(paste("Design effect (empirical): ", (clus_se/srs_se)^2))

#----

# Computing stratified statistics

strat_only <- svydesign(data = bp_data, ids = ~0, strata = ~stratum)
svymean(x = ~BP, design = strat_only, deff = "replace")

strat_mean <- svymean(x = ~BP, design = strat_only)[1]
strat_se <- SE(svymean(x = ~BP, design = strat_only))[1]
strat_lci <- strat_mean - qt(p = t_quantile, df = num_strata - 1) * strat_se
strat_uci <- strat_mean + qt(p = t_quantile, df = num_strata - 1) * strat_se
strat_deff <- deff(svymean(x = ~BP, design = strat_only, deff = "replace"))

print(paste("Mean:", strat_mean))
print(paste("SE:", strat_se))
print(paste("95% CI:", c(strat_lci, strat_uci)))
print(paste("Design effect (replacement): ", strat_deff))
print(paste("Design effect (empirical): ", (strat_se/srs_se)^2))

#----

# Computing weighted statistics

wt_only <- svydesign(data = bp_data, ids = ~0, weights = ~weight)
svymean(x = ~BP, design = wt_only, deff = "replace")

wt_mean <- svymean(x = ~BP, design = wt_only)[1]
wt_se <- SE(svymean(x = ~BP, design = wt_only))[1]
wt_df <- ( sum(bp_data$weight) ^ 2 ) / ( sum(bp_data$weight ^ 2) )
wt_lci <- wt_mean - qt(p = t_quantile, df = wt_df - 1) * wt_se
wt_uci <- wt_mean + qt(p = t_quantile, df = wt_df - 1) * wt_se
wt_deff <- deff(svymean(x = ~BP, design = wt_only, deff = "replace"))

print(paste("Mean:", wt_mean))
print(paste("SE:", wt_se))
print(paste("95% CI:", c(wt_lci, wt_uci)))
print(paste("Design effect (replacement): ", wt_deff))
print(paste("Design effect (empirical): ", (wt_se/srs_se)^2))

#----

# Combining survey design variables

## Clustering + stratification
clus_strat <- svydesign(data = bp_data, ids = ~cluster, strata = ~stratum) 
svymean(x = ~BP, design = clus_strat, deff = "replace")

( SE(svymean(x = ~BP, design = clus_strat))[1] / srs_se ) ^ 2

## Clustering + weighting
clus_wt <- svydesign(data = bp_data, ids = ~cluster, weight = ~weight) 
svymean(x = ~BP, design = clus_wt, deff = "replace")

( SE(svymean(x = ~BP, design = clus_wt))[1] / srs_se ) ^ 2

## Stratification + weighting
strat_wt <- svydesign(data = bp_data, ids = ~0, strata = ~stratum, weight = ~weight) 
svymean(x = ~BP, design = strat_wt, deff = "replace")

( SE(svymean(x = ~BP, design = strat_wt))[1] / srs_se ) ^ 2

## All
full_design <- svydesign(data = bp_data, ids = ~cluster, strata = ~stratum, weight = ~weight)
svymean(x = ~BP, design = full_design, deff = "replace")

( SE(svymean(x = ~BP, design = full_design))[1] / srs_se ) ^ 2

#----

# Computing effective sample sizes

deffs <- c(1.00, 3.08, 0.19, 1.19, 0.43, 3.22, 0.35, 0.39)
neffs <- ceiling(num_obs / deffs)
print(neffs)
