clear all
set more off

cd "D:\National Asthma and COPD Audit Programme (NACAP)\2019 Pulmonary Rehabilitation Organisational Audit"


/* create log file */
capture log close
log using analysis_logs/2019PR_Org_England, smcl replace


//English PR Services

use builds/PR_org_2019_final, clear

keep if country == 1
tab country, missing

do analysis_scripts/2019PR_Org


log close
translate analysis_logs/2019PR_Org_England.smcl outputs/2019_PR_organisational_England.pdf