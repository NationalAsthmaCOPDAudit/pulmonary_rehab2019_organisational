clear all
set more off

cd "D:\National Asthma and COPD Audit Programme (NACAP)\2019 Pulmonary Rehabilitation Organisational Audit"


/* create log file */
capture log close
log using build_logs/2019ImportPR_Org, text replace


import excel "raw_data/Org-Audit-2019---All-Data-20191223-132546-203 - UPDATE 150620.xlsx", sheet("Sheet2") firstrow

rename Hospital hospital
rename Service service
rename C country

drop service

save stata_data/org_countries, replace


import delimited using raw_data/NACAP-PR-Org-Audit-2019-All-Data-20191014-153505-781a.csv, varnames(nonames) rowrange(1:1) clear


//clean up and replace the var names
foreach var of varlist _all {
	
	//clean variable names
	replace `var' = trim(itrim(ustrto(ustrnormalize(`var', "nfd"), "ascii", 2)))
	
	replace `var' = subinstr(`var', " ", "", .)
	replace `var' = subinstr(`var', "?", "", .)
	replace `var' = subinstr(`var', "#", "", .)
	replace `var' = subinstr(`var', ":", "", .)
	replace `var' = subinstr(`var', "%", "", .)
	replace `var' = subinstr(`var', "/", "", .)
	replace `var' = subinstr(`var', "=", "", .)
	replace `var' = subinstr(`var', "-", "", .)
	replace `var' = subinstr(`var', "(", "", .)
	replace `var' = subinstr(`var', ")", "", .)
	replace `var' = subinstr(`var', ",", "", .)
	replace `var' = subinstr(`var', ";", "", .)
	replace `var' = subinstr(`var', "'", "", .)
	replace `var' = subinstr(`var', ".", "_", .)
	
	//prefix a "q" to variables that start with a number
	if real(substr(`var', 1, 1)) != . {
	
		replace `var' = "q"+`var'
	}
	
	//shrink variable names (keep beginning and end)
	if strlen(`var') > 32 {
		
		replace `var' = substr(`var', 1, 15) + "_" + substr(`var', -16, .)
	}
	
	//fix variable names that are identical when shortened
	if "`var'" == "v120" {
		
		replace `var' = "q4_18EduProvided_CD"
	}
	else if "`var'" == "v121" {
	
		replace `var' = "q4_18EduProvided_DVD"
	}
	
	local name = lower(`var')
	rename `var' `name'
}

describe, varlist
local varnames = r(varlist)

import delimited using raw_data/NACAP-PR-Org-Audit-2019-All-Data-20191014-153505-781a.csv, asdouble clear
rename (_all) (`varnames')


foreach var of varlist _all {
	
	capture confirm string variable `var'
	if !_rc {
	
		//clean strings with non-ASCII characters
		replace `var' = trim(itrim(ustrto(ustrnormalize(`var', "nfd"), "ascii", 2)))
	}
}


merge 1:1 hospital using stata_data/org_countries
drop if _merge == 2
drop _merge
encode country, gen(cntry)
drop country
rename cntry country
order country, after(service)


//Yes/No variables
local ynvars "complete q3_2doyouofferp_recurrentsmokers q3_4doyouofferp_tionofcopdaecopd q3_5doyouaccept_ntoyourprservice q4_5doyouoffera_basedprprogramme q4_5aifyesarepa_hargeassessments q4_5bifyesarepa_ionsintheirhomes q4_6doyousendpa_itialappointment q4_7doyourunref_waitingaprcourse q4_8istransportfundedforpatients q4_10ismusclest_uredatassessment q4_12isaerobict_ngtheprprogramme q4_13isaerobict_duallyprescribed q4_14isresistan_ngtheprprogramme q4_15isresistan_duallyprescribed q4_16arepatient_theirprprogramme q4_19doyourouti_rcisemaintenance q6_1bifyesdoest_eveloptheservice q6_5isthereauditsupportprovided q7_1doyouhaveas_inglocalpolicies"
label define yn 0 "No" 1 "Yes"
foreach ynvar of local ynvars {
	
	replace `ynvar' = "0" if lower(`ynvar') == "no"
	replace `ynvar' = "1" if lower(`ynvar') == "yes"
	destring `ynvar', replace
	label values `ynvar' yn
}


//3.3 Do you offer PR to COPD patients who have previously completed a PR programme?
local var1 "q3_3doyouofferp_etedaprprogramme"
replace `var1' = "0" if `var1' == "No"
replace `var1' = "1" if `var1' == "Yes if within a year of completing PR"
replace `var1' = "2" if `var1' == "Yes if completed over one year ago"
replace `var1' = "3" if `var1' == "Yes if completed over three years ago"
destring `var1', replace

label define pr_prev 0 "No" ///
					 1 "Yes - if within a year of completing PR" ///
					 2 "Yes - if completed over one year ago" ///
					 3 "Yes - if completed over three years ago"
label values `var1' pr_prev


//3.5 Do you accept patients with long-term conditions other than COPD into your PR service?
//follow up questions should be blank if 'no' answered
foreach var of varlist q3_5aifyeswhato_reacceptedasthma - q3_5aifyeswhato_tthoracicsurgery {
	
	replace `var' = . if q3_5doyouaccept_ntoyourprservice != 1
}


//3.5b If ‘Yes’, do patients with other long-term conditions enrol on the same programme as those with COPD?
local var2 "q3_5bifyesdopat_easthosewithcopd"
replace `var2' = "1" if `var2' == "Yes - all patients undertake the same programme"
replace `var2' = "2" if `var2' == "No - at least one specialised programme offered"
replace `var2' = "3" if `var2' == "No - all patients undertake a programme specific to the disease"
destring `var2', replace

label define sameprog 1 "Yes - all patients undertake the same programme" ///
					  2 "No - at least one specialised programme offered" ///
					  3 "No - all patients undertake a programme specific to the disease"
label values `var2' sameprog


//3.5c Is your service funded to provide PR to non-COPD patients?
local var3 "q3_5cisyourserv_ononcopdpatients"
replace `var3' = "0" if `var3' == "No"
replace `var3' = "1" if `var3' == "Yes - all conditions recorded at question 3.5a are funded"
replace `var3' = "2" if `var3' == "Yes - at least one condition recorded at 3.5a is funded"
destring `var3', replace

label define funded 0 "No" ///
					1 "Yes - all conditions recorded at question 3.5a are funded" ///
					2 "Yes - at least one condition recorded at 3.5a is funded"
label values `var3' funded


//Yes/No/NA
local ynna_vars "q4_2doyourasses_atdifferentsites"
label define ynna 0 "No" 1 "Yes" 2 "N/A"
foreach ynnavar of local ynna_vars {
	
	replace `ynnavar' = "0" if `ynnavar' == "No"
	replace `ynnavar' = "1" if `ynnavar' == "Yes"
	replace `ynnavar' = "2" if `ynnavar' == "N/A"
	destring `ynnavar', replace
	label values `ynnavar' ynna
}


//4.5c/d - make blank if 4.5b != yes
foreach var of varlist q4_5cifyeswhati_melessthan4weeks - q4_5cifyeswhati_memorethan8weeks q4_5difyeshowma_patientsoffered1 - q4_5difyeshowma_offeredmorethan3 {
	
	replace `var' = . if q4_5bifyesarepa_ionsintheirhomes != 1
}


order q4_9whichmeasur_nutewalktest6mwt, after(q4_9whichmeasur_essittostand5sts)


//4.9a If ‘6MWT’, how many of your sites use a 30-metre course?
local var0 "q4_9aif6mwthowm_sea30metrecourse"

replace `var0' = "0" if `var0' == "No sites use a 30m course"
replace `var0' = "1" if `var0' == "At least 1 site uses a 30m course"
replace `var0' = "2" if `var0' == "All sites use a 30m course"
destring `var0', replace

label define sites 0 "No sites use a 30m course" ///
				   1 "At least 1 site uses a 30m course" ///
				   2 "All sites use a 30m course"
label values `var0' sites


order q4_11areanyofth_physicalactivity, after(q4_11areanyofth_atientexperience)


//4.10a - clear if 4.10 != yes
foreach var of varlist q4_10aifyeshowi_sureddynamometer - q4_10aifyeshowi_edsittostand5sts {
	
	replace `var' = . if q4_10ismusclest_uredatassessment != 1
}


//4.11a - separate list
gen byte q4_11aifphysica_thisisdone_dev   = 0
gen byte q4_11aifphysica_thisisdone_quest = 0

replace q4_11aifphysica_thisisdone_dev   = 1 if strpos(q4_11aifphysica_ecthowthisisdone, "Device")
replace q4_11aifphysica_thisisdone_quest = 1 if strpos(q4_11aifphysica_ecthowthisisdone, "Questionnaire")

replace q4_11aifphysica_thisisdone_dev   = . if q4_11areanyofth_physicalactivity == 0
replace q4_11aifphysica_thisisdone_quest = . if q4_11areanyofth_physicalactivity == 0

order q4_11aifphysica_thisisdone_dev q4_11aifphysica_thisisdone_quest, after(q4_11aifphysica_ecthowthisisdone)


//4.12a - clear if 4.12 != yes
foreach var of varlist q4_12aisaerobic_programmecycling - q4_12aisaerobic_prprogrammeother {
	
	replace `var' = . if q4_12isaerobict_ngtheprprogramme != 1
}


//4.13a - clear if 4.13 != yes
foreach var of varlist q4_13ahowisaero_edexertionscores - q4_13ahowisaero_ttlewalktestiswt {
	
	replace `var' = . if q4_13isaerobict_duallyprescribed != 1
}


//4.13b What intensity of aerobic exercise prescription is used?
local var4 "q4_13bwhatinten_escriptionisused"

replace `var4' = "1" if `var4' == "<65%"
replace `var4' = "2" if `var4' == "65 - <75%"
replace `var4' = "3" if `var4' == "75 - 85%"
replace `var4' = "4" if `var4' == ">85%"
destring `var4', replace

label define exintensity 1 "<65%" 2 "65% - <75%" 3 "75% - 85%" 4 ">85%" 99 "No data"
label values `var4' exintensity

//data cleaning required
replace `var4' = 99 if `var4' == . & (q4_13ahowisaero_swtlevelfromiswt == 1 | ///
									q4_13ahowisaero_nutewalktest6mwt == 1 | ///
									q4_13ahowisaero_ttlewalktestiswt == 1)
replace `var4' = . if q4_13ahowisaero_edexertionscores == 1 & ///
						q4_13ahowisaero_swtlevelfromiswt == 0 & ///
						q4_13ahowisaero_nutewalktest6mwt == 0 & ///
						q4_13ahowisaero_ttlewalktestiswt == 0


//4.15a - clear if 4.15 != yes
foreach var of varlist q4_15ahowisresi_edexertionscores - q4_15ahowisresi_gprescribedother {
	
	replace `var' = . if q4_15isresistan_duallyprescribed != 1
}


order q4_18howiseduca_ghtgroupsessions, after(q4_18eduprovided_dvd)


//6.1 Is there a named clinical lead for the service?
local var5 "q6_1isthereanam_eadfortheservice"
replace `var5' = "0" if `var5' == "No"
replace `var5' = "1" if `var5' == "Yes - filled"
replace `var5' = "2" if `var5' == "Yes - currently unfilled"
destring `var5', replace

label define clinicallead 0 "No" ///
						  1 "Yes - filled" ///
						  2 "Yes - currently unfilled"
label values `var5' clinicallead


//6.1a and 6.2 require long to wide conversion and linkage from separate files


//6.4 might need to add a 'NA' coloumn


//7.1a - clear if 7.1 != yes
foreach var of varlist q7_1awhatdoesth_veraccessibility - q7_1awhatdoesth_erwhistleblowing {
	
	replace `var' = . if q7_1doyouhaveas_inglocalpolicies != 1
}


gsort hospital

compress
save stata_data/PR_organisational_2019, replace

log close
