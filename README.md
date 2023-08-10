# MSc-Dissertation
Code for my MSc in Statistics dissertation at The University of Sheffield.

#### Authors
Nasir Zeeshan Bashir

#### Dissertation Supervisor
Bryony Moody                                       

### Lay Summary

Dental caries (a.k.a. "tooth decay" or "cavities") is the most common chronic disease affecting children in the United States (US). There are many major risk factors which influence oral health and, given the shifting political landscape, one risk factor which has been bought to the spotlight in recent times is immigration. This is particularly relevant to the US for two reasons: (i) it has the most migrants of any country in the world, (ii) immigration policy is currently a political hotbed. Despite this, there is a lack of robust research investigating how immigration is associated with dental caries amongst children in America.

In this work, we use data from the 2017–2018 National Health and Nutrition Examination Survey (NHANES), which is a study that is carried out in two-year cycles, with the aim of obtaining nationally representative statistics for the US population. We analysed data for children aged 2 to 11 years to assess how immigration is related to the risk of dental caries. Some of the key factors which confound the relationship between immigration and health outcomes are the sociodemographic characteristics of the individuals, hence we fit models which controlled for these variables. Namely, we accounted for race/ethnicity, the level of education in the household to which the children belong, and household income. In addition, NHANES uses a complex sampling design; we account for this survey design in order to ensure the findings can be generalised to the US population as a whole, as well as discussing some of the mathematical nuances which must be taken into consideration when analysing data of this nature.

The included sample comprised 1,502 individuals, which was representative of 36 million children in the US population for the period 2017–2018. It was found that being an immigrant is associated with a 140% increase in the risk of having dental caries, even after accounting for the sociodemographic characteristics. Other factors associated with a significant change in the risk of dental caries were: being of Non-Hispanic Asian descent, coming from a household with a college (i.e., university) educated background, and household income.

Overall, we identified a substantial increase in risk of disease amongst immigrant children, which ties in with the existing evidence that social determinants have an acute impact on oral health. Future researchers may be motivated to further explore this highly complex and multifactorial relationship, and these findings may also guide policy makers with regards to allocation of healthcare resources.

### Analysis

The Stata code is separated into two files: (i) merging together the raw SAS .XPT files and converting them into .dta format, (ii) the subsequent cleaning and statistical analysis of the merged file. The R code is separated into three files (i) creating the simulation Figure 2.1, (ii) all analyses of the artificial data in Table 2.1, (iii) carrying out the PLRTs. LaTeX code for compiling the dissertation from source is also provided - MiKTeX was the distribution of choice.

The NHANES data and artificial blood pressure data are located in the `data` directory.

The final compiled version of the dissertation is named `Bashir-NZ.pdf`.

**Stata v17.0**\
**R v4.3.1**\
**MiKTeX Console v4.9**
