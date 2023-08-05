############################
### MAS6041 DISSERTATION ###
############################

### NHANES Analysis ###

#----

# Preamble

library(tidyverse)
library(haven)
library(labelled)
library(Hmisc)
library(survey)

# Reading in data

path <- c("insert/path/to/stata/dta/files")
nhanes17 <- read_dta(paste0(path, "nhanes17_cleaned.dta"))

# Converting labels to factors

nhanes17 <- nhanes17 %>% to_factor()
summary(nhanes17)

#----

# Specifying survey design

nhanes_design <- svydesign(data = nhanes17, ids = ~sdmvpsu, strata = ~sdmvstra, weight = ~wtmec2yr, nest = TRUE)

# Specifying models

m0 <- svyglm(formula = decay ~ 1,
             family = "binomial",
             design = nhanes_design,
             subset = inAnalysis == "Yes")

m1 <- update(m0, ~ . + born)
m2 <- update(m0, ~ . + race)
m3 <- update(m0, ~ . + education)
m4 <- update(m0, ~ . + income)
m5 <- update(m0, ~ . + born + race + education + income)

# List of variables and models to loops over

varList <- c("Nativity", "Race", "Education", "Income", "All")
modList <- paste0("m", 1:5)

# Computing PLRT p-values

pvals <- sapply(modList, function(x) anova(m0, get(x), maximal = get(x), method = "LRT")$p)

for (i in 1: length(varList)){
  
  print(paste0(varList[i], " p-value = ", pvals[i]))
  
}

# Computing pseudo-R squared

psrsq(m5, method = "Nagelkerke")