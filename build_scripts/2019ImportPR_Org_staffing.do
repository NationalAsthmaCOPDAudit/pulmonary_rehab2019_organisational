clear
set more off

cd "D:\National Asthma and COPD Audit Programme (NACAP)\2019 Pulmonary Rehabilitation Organisational Audit"


/* create log file */
capture log close
log using build_logs/2019ImportPR_Org_staffing, text replace


import delimited using raw_data/NACAP-PR-Org-Audit-2019-Staff---6.1a-20191014-153707-937.csv, clear


rename org hospital
rename v2 q61a_servicepost


compress
save stata_data/PR_org_2019_staffing_61a, replace



import delimited using raw_data/NACAP-PR-Org-Audit-2019-Staff---6.2-20191014-153735-390.csv, clear


rename org hospital
rename v2 q62_servicepost


compress
save stata_data/PR_org_2019_staffing_62, replace



log close