************************
*** MSc Dissertation ***
************************

local path "insert/path/to/stata/dta/files"
use "`path'/nhanes17.dta", clear

****************************************************************************************************

*** SECTION 1: DATA CLEANING ***

* Country of birth
generate born = 0 if(dmdborn4 == 1)
replace born = 1 if(dmdborn4 == 2)

label define born_lab 0 "US" 1 "Non-US"
label values born born_lab

* Age
generate age = ridageyr if(ridageyr >= 2 & ridageyr <= 11)

* Sex
generate sex = 1 if(riagendr == 1)
replace sex = 2 if(riagendr == 2)

label define sex_lab 1 "Male" 2 "Female" 
label values sex sex_lab

* Ethnicity
generate race = 1 if(ridreth3 == 3)
replace race = 2 if(ridreth3 == 4)
replace race = 3 if(ridreth3 == 1 | ridreth3 == 2)
replace race = 4 if(ridreth3 == 6)
replace race = 5 if(ridreth3 == 7)

label define race_lab 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian" 5 "Other"
label values race race_lab

* Education (household reference person)
generate education = 1 if(dmdhredz == 1)
replace education = 2 if(dmdhredz == 2)
replace education = 3 if(dmdhredz == 3)

label define educ_lab 1 "Below high" 2 "High school" 3 "College grad"
label values education educ_lab

* Income
generate income = indfmpir if(indfmpir != .)

****************************************************************************************************

*** SECTION 2: DENTAL CARIES ***

* Complete exam
generate examined = 1 if(ohdexsts == 1)

* Num. of teeth
forvalues i = 02/31 {
	if inlist(`i', 16, 17) continue
	local I : di %02.0f `i'
	foreach var of varlist ohx`I'tc {
			generate ohx`I'pres = 1 if(`var' == 1 | `var' == 2)
			recode ohx`I'pres(. = 0)
	}
}

egen teeth = rowtotal(ohx02pres-ohx31pres)

* Decayed teeth
forvalues i = 02/31 {
	if inlist(`i', 16, 17) continue
	local I : di %02.0f `i'
	foreach var of varlist ohx`I'ctc {
			generate ohx`I'decay = 1 if(`var' == "K" | `var' == "Z")
			recode ohx`I'decay(. = 0)
	}
}

* Summing number of decayed teeth
egen total_decay = rowtotal(ohx02decay-ohx31decay)

* Presence or absence of decayed teeth
generate decay = 1 if(total_decay > 0)
replace decay = 0 if(total_decay == 0)

label define decay_lab 0 "Absent" 1 "Present"
label values decay decay_lab

****************************************************************************************************

*** SECTION 3: EXPLORATORY DATA ANALYSIS ***

* Keeping necessary variables

keep born-examined teeth decay wtmec2yr sdmvpsu sdmvstra

* Specifying included individuals

generate inAnalysis = 1

replace inAnalysis = 0 if missing(age)
replace inAnalysis = 0 if missing(examined)
replace inAnalysis = 0 if teeth == 0

replace inAnalysis = 0 if missing(sex)
replace inAnalysis = 0 if missing(race)
replace inAnalysis = 0 if missing(education)
replace inAnalysis = 0 if missing(income)
replace inAnalysis = 0 if missing(born)

label define analysis_lab 0 "No" 1 "Yes"
label values inAnalysis analysis_lab

* Saving dataset

save "`path'/nhanes17_cleaned.dta", replace
use "`path'/nhanes17_cleaned.dta", clear

* Specifying survey design

svyset [w = wtmec2yr], psu(sdmvpsu) strata(sdmvstra)

* Summary statistics (overall)

tab inAnalysis
svy, subpop(if inAnalysis == 1): tabulate inAnalysis, count format(%11.3g)
svy, subpop(if inAnalysis == 1): proportion inAnalysis, percent

foreach var of varlist born sex race education {
	tab `var' if(inAnalysis == 1)	
	svy, subpop(if inAnalysis == 1): tabulate `var', count format(%11.3g)
	quietly: svy, subpop(if inAnalysis == 1): proportion `var', percent
	estat effects
}

foreach var of varlist age income {
	
	quietly: svy, subpop(if inAnalysis == 1): mean `var'
	estat effects
}

* Summary statistics (by caries status)

svyset [w = wtmec2yr], psu(sdmvpsu) strata(sdmvstra)

tab decay if(inAnalysis == 1)
quietly: svy, subpop(if inAnalysis == 1): proportion decay, percent
estat effects

foreach var of varlist born sex race education {
	tab `var' decay if(inAnalysis == 1)	
	quietly: svy, subpop(if inAnalysis == 1): proportion `var', over(decay) percent
	estat effects
	svy, subpop(if inAnalysis == 1): tabulate decay `var', pearson
}

foreach var of varlist age income {
	
	quietly: svy, subpop(if inAnalysis == 1): mean `var', over(decay)
	lincom _b[c.`var'@0bn.decay] - _b[c.`var'@1.decay]
	estat effects
}

* Counting missing data

generate inMissing = 1
replace inMissing = 0 if missing(age)
replace inMissing = 0 if missing(examined)
replace inMissing = 0 if teeth == 0

missings report if inMissing

****************************************************************************************************

*** SECTION 4: MODEL FITTING ***

* Specifying survey design

svyset [w = wtmec2yr], psu(sdmvpsu) strata(sdmvstra) vce(linearized)

* Initial multivariable model + Wald tests

svy, subpop(if inAnalysis == 1): logistic decay i.born i.race i.education income

testparm i.born
testparm i.race
testparm i.education
testparm income

estat effects

* Univariable models + Wald tests

svy, subpop(if inAnalysis == 1): logistic decay i.born
testparm i.born

svy, subpop(if inAnalysis == 1): logistic decay i.race
testparm i.race

svy, subpop(if inAnalysis == 1): logistic decay i.education
testparm i.education

svy, subpop(if inAnalysis == 1): logistic decay income
testparm income

****************************************************************************************************

*** SECTION 5: GOODNESS OF FIT ***

* Area under the curve

svyset [w = wtmec2yr], psu(sdmvpsu) strata(sdmvstra) vce(linearized)
quietly: svy, subpop(if inAnalysis == 1): logistic decay i.born i.race i.education income
predict phat
somersd decay phat [pweight = wtmec2yr] if inAnalysis == 1, tr(c)

****************************************************************************************************