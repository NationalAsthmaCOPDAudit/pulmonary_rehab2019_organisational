# 2019 Pulmonary Rehabilitation Organisational Audit
## Run order
### [`/build_scripts/`](/build_scripts/)
1. `2019ImportPR_Org[...].do` (one import script for each raw data file, run order is unimportant, they just need to be run first)
2. [`2019BuildPR_Org.do`](/build_scripts/2019BuildPR_Org.do)
### [`/analysis_scripts/`](/analysis_scripts/)
- Any order; each file with a region suffix calls [`2019PR_Org.do`](analysis_scripts/2019PR_Org.do) after restricting to the required region
