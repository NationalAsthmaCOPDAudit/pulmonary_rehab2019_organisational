clear
set more off

cd "D:\National Asthma and COPD Audit Programme (NACAP)\2019 Pulmonary Rehabilitation Organisational Audit"


/* create log file */
capture log close
log using build_logs/2019BuildPR_Org, text replace


use stata_data/PR_organisational_2019, clear


//data cleaning

count

//remove PR services with incomplete data (not sure why these were even included)
keep if complete == 1
drop complete   //no longer needed


merge 1:1 hospital using stata_data/PR_org_2019_caseascertainment
drop _merge

//generate staff ratio to patient referrals - done in analysis file
//referrals (1.1)/6?


//export dataset as spreadsheet
export excel outputs/2019_PR_organisational.xlsx, firstrow(varlabels) replace


//remove list variables
drop q3_1whichselfre_entsdoyouofferpr q3_5aifyeswhato_tionsareaccepted q4_3whatisthety_basedprprogramme q4_4howmanysupe_expectedtoattend q4_5cifyeswhati_basedprprogramme q4_5difyeshowma_epatientsoffered q4_9whichmeasur_soutcomemeasures q4_10aifyeshowi_strengthmeasured q4_11areanyofth_uredatassessment q4_11aifphysica_ecthowthisisdone q4_12awhattypeo_ngtheprprogramme q4_13ahowisaero_ainingprescribed q4_14awhatresis_ngtheprprogramme q4_15ahowisresi_ainingprescribed q4_18howiseducationprovided q4_18aifyouoffe_whodeliversthese q4_18bifyouoffe_esesessionscover q4_18bifyouoffe_esesessionscover q5_1whichclinic_sionsyourservice q5_2whattypeofo_videsyourservice q5_3whattypeoff_syourservicehave q6_4whatarethed_ndedtotheservice q7_1awhatdoesth_ngprocedurecover

//drop file within file variables - use individual datasets instead
drop q6_1aifyesfille_ssiongradeandwte q6_2howmanytype_dedfortheservice


//1.2 Referral source
gen q1_2a_refprop_primarycare = q1_2areferralfromprimarycare/q1_1howmanyrefe_018to31march2019
order q1_2a_refprop_primarycare, after(q1_2areferralfromprimarycare)

gen q1_2b_refprop_communitycare = q1_2breferralfromcommunitycare/q1_1howmanyrefe_018to31march2019
order q1_2b_refprop_communitycare, after(q1_2breferralfromcommunitycare)

gen q1_2c_refprop_secondarycare = q1_2creferralfromsecondarycare/q1_1howmanyrefe_018to31march2019
order q1_2c_refprop_secondarycare, after(q1_2creferralfromsecondarycare)

gen q1_2d_refprop_self = q1_2dselfreferral/q1_1howmanyrefe_018to31march2019
order q1_2d_refprop_self, after(q1_2dselfreferral)

gen q1_2e_refprop_other = q1_2ereferralother/q1_1howmanyrefe_018to31march2019
order q1_2e_refprop_other, after(q1_2ereferralother)





compress
save builds/PR_org_2019_final, replace


log close
