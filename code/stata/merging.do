local path_xpt "insert/path/to/sas/xpt/files"
local path_dta "insert/path/to/stata/dta/files"

* Importing data from XPT

import sasxport5 "`path_xpt'/DEMO_J.XPT", clear
save "`path_dta'/demographics.dta", replace

import sasxport5 "`path_xpt'/HIQ_J.XPT", clear
save "`path_dta'/insurance.dta", replace

import sasxport5 "`path_xpt'/OHQ_J.XPT", clear
save "`path_dta'/oral_qns.dta", replace

import sasxport5 "`path_xpt'/OHXDEN_J.XPT", clear
save "`path_dta'/oral_exam.dta", replace

* Merging data into combined DTA

use "`path_dta'/demographics.dta", clear

merge 1:1 seqn using "`path_dta'/insurance.dta"
drop _merge

merge 1:1 seqn using "`path_dta'/oral_qns.dta"
drop _merge

merge 1:1 seqn using "`path_dta'/oral_exam.dta"
drop _merge

save "`path_dta'/nhanes17.dta", replace