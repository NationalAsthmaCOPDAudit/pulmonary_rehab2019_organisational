clear all
set more off

cd "D:\National Asthma and COPD Audit Programme (NACAP)\2019 Pulmonary Rehabilitation Organisational Audit"


/* create log file */
capture log close
log using build_logs/2019ImportPR_Org_case, text replace


import excel "raw_data/NACAP-PR-Org-Audit-2020 - FINAL EXPORT 250620_LIVE_For Imperial.xlsx", firstrow case(lower)

drop havean2019organisationalaudi updated

rename complete case_complete

rename e q11_referrals
rename f q11a_assessment
rename g q11b_started
rename h q11_completed
rename i q12a_pc_referral
rename j q12b_com_referral
rename k q12c_sc_referral
rename l q12d_self_referral
rename m q12e_other_referral
rename n q21_eligible
rename o q22_consent_ask
rename p q23_consent_yes


compress
save stata_data/PR_org_2019_caseascertainment, replace


log close