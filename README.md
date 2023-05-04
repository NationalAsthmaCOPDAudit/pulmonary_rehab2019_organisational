# 2019 Pulmonary Rehabilitation Organisational Audit

## Run order

### [`/build_scripts/`](/build_scripts/)
1. `2019ImportPR_Org[...].do` (one import script for each raw data file, run order is unimportant, they just need to be run first)
2. [`2019BuildPR_Org.do`](/build_scripts/2019BuildPR_Org.do)

### [`/analysis_scripts/`](/analysis_scripts/)
- Any order; each file with a region suffix calls [`2019PR_Org.do`](analysis_scripts/2019PR_Org.do) after restricting to the required region

## Published report
Available from [nacap.org.uk](https://nacap.org.uk/nacap/welcome.nsf/vwFiles/PR-Reports-2020b/$File/NACAP_PR_Organisational_Audit_2019_Dec20.pdf) or [hqip.org.uk](https://www.hqip.org.uk/resource/pulmonary-rehabilitation-clinical-and-organisational-audits-2019/).
