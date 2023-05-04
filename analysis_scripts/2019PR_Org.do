//REQUIRES STATA 16 AND ABOVE

//1.1 Referrals, assessments, starting PR and discharge assessments
summarize q1_1howmanyrefe_018to31march2019 q1_1apatientsat_018to31march2019 q1_1bhowmanypat_018to31march2019 q1_1chowmanypat_018to31march2019, detail


//1.2 Referral source
quietly {
	
	total(q1_1howmanyrefe_018to31march2019)
	local refdenom = e(b)[1,1]
	noisily display "Total referrals: "`refdenom'
}

total(q1_2areferralfromprimarycare q1_2breferralfromcommunitycare q1_2creferralfromsecondarycare q1_2dselfreferral q1_2ereferralother)

quietly {

	matrix list e(b)
	matrix refprop = (e(b)/`refdenom')*100
	matrix list refprop

	noisily display "1.2a % referred from primary care: "refprop[1,1]
	noisily display "1.2b % referred from community care: "refprop[1,2]
	noisily display "1.2c % referred from secondary care: "refprop[1,3]
	noisily display "1.2d % self-referred: "refprop[1,4]
	noisily display "1.2e % other referral: "refprop[1,5]
}


//2.1 Eligibility for audit data
total(q2_1eligiblefor_treportingperiod q2_2eligiblepat_ndaskedtoconsent q2_3eligiblepat_on2_2gaveconsent)

quietly {

	matrix eligibility = e(b)
	matrix list eligibility
	noisily display "2.1 No. eligible for aduit: "eligibility[1,1]

	matrix asked_prop = (eligibility/eligibility[1,1])*100
	matrix list asked_prop
	noisily display "2.2 No. approached for consent: "eligibility[1,2] " ("asked_prop[1,2] "% of eligible)"

	matrix consented_prop = (eligibility/eligibility[1,2])*100
	matrix list consented_prop
	noisily display "2.3 No. consented: "eligibility[1,3] " ("asked_prop[1,3] "% of eligible)("consented_prop[1,3] "% of asked)"

	noisily display in red "2.4 No. included: OBTAIN DATA FROM CLINICAL AUDIT"
}


//3.1 To which self-reported MRC graded COPD patients do you offer PR?
tab1 q3_1whichselfre_youofferprgrade1 q3_1whichselfre_youofferprgrade2 q3_1whichselfre_youofferprgrade3 q3_1whichselfre_youofferprgrade4 q3_1whichselfre_youofferprgrade5 q3_1whichselfre_ferprnotrecorded


//3.2 Do you offer PR to COPD patients who are current smokers?
tab q3_2doyouofferp_recurrentsmokers


//3.3 Do you offer PR to COPD patients who have previously completed a PR programme?
tab q3_3doyouofferp_etedaprprogramme


//3.4 Do you offer early post-discharge  PR tofor patients discharged from hospital with a diagnosis of acute exacerbation of COPD (AECOPD)?
tab q3_4doyouofferp_tionofcopdaecopd


//3.5 Do you accept patients with long-term conditions other than COPD to your programme?
tab q3_5doyouaccept_ntoyourprservice

tab1 q3_5aifyeswhato_reacceptedasthma q3_5aifyeswhato_allungdiseaseild q3_5aifyeswhato_cfbronchiectasis q3_5aifyeswhato_piratorydiseases q3_5aifyeswhato_onicheartfailure q3_5aifyeswhato_tthoracicsurgery

tab q3_5bifyesdopat_easthosewithcopd

tab q3_5cisyourserv_ononcopdpatients


//4.1 At how many sites do you currently offer assessments/centre-based PR?
summarize q4_1athowmanysi_ntscentrebasedpr, detail


//4.2 Do your assessments/centre-based PR programmes run differently at different sites?
tab q4_2doyourasses_atdifferentsites


//4.3 Centre-based PR structure
tab1 q4_3whatisthety_melessthan4weeks q4_3whatisthety_rprogramme4weeks q4_3whatisthety_rprogramme5weeks q4_3whatisthety_rprogramme6weeks q4_3whatisthety_rprogramme7weeks q4_3whatisthety_rprogramme8weeks q4_3whatisthety_memorethan8weeks

tab1 q4_4howmanysupe_xpectedtoattend1 q4_4howmanysupe_xpectedtoattend2 q4_4howmanysupe_xpectedtoattend3 q4_4howmanysupe_oattendmorethan3

tab q4_5doyouoffera_basedprprogramme

tab q4_5aifyesarepa_hargeassessments

tab q4_5bifyesarepa_ionsintheirhomes

tab1 q4_5cifyeswhati_melessthan4weeks q4_5cifyeswhati_rprogramme4weeks q4_5cifyeswhati_rprogramme5weeks q4_5cifyeswhati_rprogramme6weeks q4_5cifyeswhati_rprogramme7weeks q4_5cifyeswhati_rprogramme8weeks q4_5cifyeswhati_memorethan8weeks

tab1 q4_5difyeshowma_patientsoffered1 q4_5difyeshowma_patientsoffered2 q4_5difyeshowma_patientsoffered3 q4_5difyeshowma_offeredmorethan3

tab q4_6doyousendpa_itialappointment

tab q4_7doyourunref_waitingaprcourse

tab q4_8istransportfundedforpatients

tab1 q4_9whichmeasur_ttlewalktesteswt q4_9whichmeasur_ttlewalktestiswt q4_9whichmeasur_essittostand5sts q4_9whichmeasur_nutewalktest6mwt 

tab q4_9aif6mwthowm_sea30metrecourse

tab q4_10ismusclest_uredatassessment

tab1 q4_10aifyeshowi_sureddynamometer q4_10aifyeshowi_suredstraingauge q4_10aifyeshowi_epetitionmaximum q4_10aifyeshowi_ngthmeasured10rm q4_10aifyeshowi_edsittostand5sts

tab1 q4_11areanyofth_dailylivingscale q4_11areanyofth_depressionscores q4_11areanyofth_dduringeducation q4_11areanyofth_icalstatusscores q4_11areanyofth_ientsatisfaction q4_11areanyofth_atientexperience q4_11areanyofth_physicalactivity q4_11areanyofth_edatassessmentno 

//4.11a If ‘Physical activity’ is measured, please select how this is is done?
tab1 q4_11aifphysica_thisisdone_dev q4_11aifphysica_thisisdone_quest


//Aerobic training
tab q4_12isaerobict_ngtheprprogramme

tab1 q4_12aisaerobic_programmecycling q4_12aisaerobic_programmewalking q4_12aisaerobic_prprogrammeother

tab q4_13isaerobict_duallyprescribed

tab1 q4_13ahowisaero_edexertionscores q4_13ahowisaero_swtlevelfromiswt q4_13ahowisaero_nutewalktest6mwt q4_13ahowisaero_ttlewalktestiswt
//no 'other' category

tab q4_13bwhatinten_escriptionisused


//Resistance training
tab q4_14isresistan_ngtheprprogramme

tab1 q4_14awhatresis_rammefreeweights q4_14awhatresis_eresistancebands q4_14awhatresis_meweightmachines q4_14awhatresis_prprogrammeother

tab q4_15isresistan_duallyprescribed

tab1 q4_15ahowisresi_edexertionscores q4_15ahowisresi_tof1rmorstrength q4_15ahowisresi_gprescribedother

tab q4_16arepatient_theirprprogramme


//Structure and Content of Programme: Education 
//How many hours of education are scheduled during a complete centre-based PR programme?
summarize q4_17howmanyhou_basedprprogramme, detail

tab1 q4_18eduprovided_cd q4_18eduprovided_dvd q4_18howiseduca_ghtgroupsessions q4_18howiseduca_dedicatedwebsite q4_18howiseduca_erremotedelivery q4_18howiseduca_dwrittenhandouts q4_18howiseducationprovidedother

//Who delivers face-to-face sessions?
tab1 q4_18aifyouoffe_icalpsychologist q4_18aifyouoffe_rsthesedietician q4_18aifyouoffe_cisephysiologist q4_18aifyouoffe_itnessinstructor q4_18aifyouoffe_odeliversthesegp q4_18aifyouoffe_therapyassistant q4_18aifyouoffe_althpsychologist q4_18aifyouoffe_ationaltherapist q4_18aifyouoffe_sthesepharmacist q4_18aifyouoffe_ephysiotherapist q4_18aifyouoffe_eregisterednurse q4_18aifyouoffe_iratoryphysician q4_18aifyouoffe_toryphysiologist q4_18aifyouoffe_hesesocialworker q4_18aifyouoffe_hnicalinstructor q4_18aifyouoffe_rsthesevolunteer q4_18aifyouoffe_liverstheseother

//What do face-to-face session cover? (includes final 'other' category)
tab1 q4_18bifyouoffe_dvancedirectives q4_18bifyouoffe_spiratorydisease q4_18bifyouoffe_entandrelaxation q4_18bifyouoffe_andwelfarerights q4_18bifyouoffe_arancetechniques q4_18bifyouoffe_ndselfmanagement q4_18bifyouoffe_ymptommanagement q4_18bifyouoffe_nservationpacing q4_18bifyouoffe_backsandrelapses q4_18bifyouoffe_ettingandrewards q4_18bifyouoffe_elatedbehaviours q4_18bifyouoffe_onshipssexuality q4_18bifyouoffe_ermanagingtravel q4_18bifyouoffe_ingoxygentherapy q4_18bifyouoffe_utritionaladvice q4_18bifyouoffe_ryrehabilitation q4_18bifyouoffe_entsupportgroups q4_18bifyouoffe_scoverrelaxation q4_18bifyouoffe_smokingcessation q4_18bifyouoffe_physicalexercise q4_18bifyouoffe_fmanagementplans q4_18bifyouoffe_ssionscoverother 

tab q4_19doyourouti_rcisemaintenance


//What type of organisation provides your service?
tab1 q5_2whattypeofo_urservicecharity q5_2whattypeofo_terestcompanycic q5_2whattypeofo_urservicecouncil q5_2whattypeofo_vicegpfederation q5_2whattypeofo_organisationsico q5_2whattypeofo_icenhsacutetrust q5_2whattypeofo_cenhshealthboard q5_2whattypeofo_orcommunitytrust q5_2whattypeofo_althcareprovider

tab1 q5_3whattypeoff_icehavefixedterm q5_3whattypeoff_havenonfixedterm

//If ‘Fixed-term’, how many years’ future funding does the service have?
summarize q5_3aiffixedter_estheservicehave if q5_3whattypeoff_icehavefixedterm == 1, detail


//STAFFING

//Is there funding for a named clinical lead for the service?
tab q6_1isthereanam_eadfortheservice

//Number and type of filled clinical lead posts in PR services
frame create staffing61a
frame change staffing61a

use stata_data/PR_org_2019_staffing_61a

//Link staffing data to primary data set
frlink m:1 hospital, frame(default hospital)

//remove results that aren't matched (programme removed in cleaning or different country)
drop if default == .

//check correct countries included
frget country, from(default)
tab country, missing

tab q61a_servicepost

summarize wte if q61a_servicepost == "Doctor", detail
summarize wte if q61a_servicepost == "Exercise practitioner", detail
summarize wte if q61a_servicepost == "Qualified nurse", detail
summarize wte if q61a_servicepost == "Qualified occupational therapist", detail
summarize wte if q61a_servicepost == "Qualified physiotherapist", detail

tab band if q61a_servicepost == "Doctor"
tab band if q61a_servicepost == "Exercise practitioner"
tab band if q61a_servicepost == "Qualified nurse"
tab band if q61a_servicepost == "Qualified occupational therapist"
tab band if q61a_servicepost == "Qualified physiotherapist"

frame change default

//Does the clinical lead receive management time to coordinate and manage/develop the service?
tab q6_1bifyesdoest_eveloptheservice

//How many types of posts are funded for the service?
frame create staffing62
frame change staffing62

use stata_data/PR_org_2019_staffing_62

//Link staffing data to primary data set
frlink m:1 hospital, frame(default hospital)

//remove results that aren't matched (programme removed in cleaning or different country)
drop if default == .

//check correct countries included
frget country, from(default)
tab country, missing

tab q62_servicepost

summarize wte if q62_servicepost == "Admin and clerical", detail
summarize wte if q62_servicepost == "Dietician/Nutritionist", detail
summarize wte if q62_servicepost == "Exercise practitioner", detail
summarize wte if q62_servicepost == "Healthcare support worker", detail
summarize wte if q62_servicepost == "Pharmacist", detail
summarize wte if q62_servicepost == "Psychologist", detail
summarize wte if q62_servicepost == "Qualified nurse", detail
summarize wte if q62_servicepost == "Qualified occupational therapist", detail
summarize wte if q62_servicepost == "Qualified physiotherapist", detail
summarize wte if q62_servicepost == "Therapy assistant", detail

tab band if q62_servicepost == "Admin and clerical"
tab band if q62_servicepost == "Dietician/Nutritionist"
tab band if q62_servicepost == "Exercise practitioner"
tab band if q62_servicepost == "Healthcare support worker"
tab band if q62_servicepost == "Pharmacist"
tab band if q62_servicepost == "Psychologist"
tab band if q62_servicepost == "Qualified nurse"
tab band if q62_servicepost == "Qualified occupational therapist"
tab band if q62_servicepost == "Qualified physiotherapist"
tab band if q62_servicepost == "Therapy assistant"

frame change default

//What is the current WTE of staff vacancies at the service?
summarize q6_3whatisthecu_ciesattheservice, detail

//What are the designations of the staff who contribute, but are non-funded, to the service?
tab1 q6_4whatarethed_adminandclerical q6_4whatarethed_erciseinstructor q6_4whatarethed_ciannutritionist q6_4whatarethed_cisepractitioner q6_4whatarethed_aresupportworker q6_4whatarethed_ntrepresentative q6_4whatarethed_ervicepharmacist q6_4whatarethed_servicephysician q6_4whatarethed_vicepsychologist q6_4whatarethed_cequalifiednurse q6_4whatarethed_dphysiotherapist q6_4whatarethed_ationaltherapist q6_4whatarethed_vicesocialworker q6_4whatarethed_therapyassistant

//Is there audit support provided?
tab q6_5isthereauditsupportprovided

//How many WTE of audit support are provided?
summarize q6_5aifyeshowma_pportareprovided, detail

//Staff ratio to patient referrals
//see end of analysis


//RECORD KEEPING

//Do you have a Standard Operating Procedure (SOP) detailing local policies?
tab q7_1doyouhaveas_inglocalpolicies

//What does the SOP cover?
tab1 q7_1awhatdoesth_veraccessibility q7_1awhatdoesth_urecovercapacity q7_1awhatdoesth_verdnamanagement q7_1awhatdoesth_skitandequipment q7_1awhatdoesth_ignityandrespect q7_1awhatdoesth_gingwaitingtimes q7_1awhatdoesth_exerciseoutcomes q7_1awhatdoesth_cationmanagement q7_1awhatdoesth_umstaffinglevels q7_1awhatdoesth_sfactionfeedback q7_1awhatdoesth_ntsneedingoxygen q7_1awhatdoesth_verpatientsafety q7_1awhatdoesth_rpatientsecurity q7_1awhatdoesth_rriskassessments q7_1awhatdoesth_mentandwellbeing q7_1awhatdoesth_ertransitioncare q7_1awhatdoesth_useofitequipment q7_1awhatdoesth_erwhistleblowing



//NEW (June to November 2019) CASE DATA
display ""
display "JUNE to NOVEMBER 2019 DATA..."
display ""

//1.1 Referrals, assessments, starting PR and discharge assessments
summarize q11_referrals q11a_assessment q11b_started q11_completed, detail

total(q11_referrals q11a_assessment q11b_started q11_completed)


//1.2 Referral source - NOT NEEDED?
quietly {
	
	total(q11_referrals)
	local refdenom19 = e(b)[1,1]
	noisily display "Total referrals (June to November 2019): "`refdenom19'
}

total(q12a_pc_referral q12b_com_referral q12c_sc_referral q12d_self_referral q12e_other_referral)

quietly {

	matrix list e(b)
	matrix refprop19 = (e(b)/`refdenom19')*100
	matrix list refprop19

	noisily display "1.2a % referred from primary care: "refprop19[1,1]
	noisily display "1.2b % referred from community care: "refprop19[1,2]
	noisily display "1.2c % referred from secondary care: "refprop19[1,3]
	noisily display "1.2d % self-referred: "refprop19[1,4]
	noisily display "1.2e % other referral: "refprop19[1,5]
}


//2.1 Eligibility for audit data
total(q21_eligible q22_consent_ask q23_consent_yes)

quietly {

	matrix eligibility19 = e(b)
	matrix list eligibility19
	noisily display "2.1 No. eligible for aduit: "eligibility19[1,1]

	matrix asked_prop19 = (eligibility19/eligibility19[1,1])*100
	matrix list asked_prop19
	noisily display "2.2 No. approached for consent: "eligibility19[1,2] " ("asked_prop19[1,2] "% of eligible)"

	matrix consented_prop19 = (eligibility19/eligibility19[1,2])*100
	matrix list consented_prop19
	noisily display "2.3 No. consented: "eligibility19[1,3] " ("asked_prop19[1,3] "% of eligible)("consented_prop19[1,3] "% of asked)"

	noisily display in red "2.4 No. included: OBTAIN DATA FROM CLINICAL AUDIT"
}


frame change staffing62

collapse (sum) wte, by(hospital q62_servicepost)

frlink m:1 hospital, frame(default hospital)
frget q11_referrals, from(default)
gen ref_staff_ratio = q11_referrals/wte
/*
keep if q62_servicepost == "Qualified nurse" | ///
		q62_servicepost == "Qualified physiotherapist" | ///
		q62_servicepost == "Qualified occupational therapist"
*/
bysort q62_servicepost: summarize ref_staff_ratio, detail