***************************************************************************************
* Program: 2_Data_Construction.do
* Author: Gabriel Tourek
* Created: 30 Oct 2023
* Modified: 		
* Purpose: Clean, combines, and assembles datasets for analysis
***************************************************************************************

clear
set more off

********************************************************************************
********************** DATASET CONSTRUCTION FOR ANALYSIS ***********************
********************************************************************************

**************
* RAFIT Data *
**************

cap cd "${repldir}/Data/01_base/rafit_data"


* 3_Staff_metrics

import excel using "3_Staff_metrics.xlsx",clear first sheet("Staff strength levels")

ren A country
ren B staffNstartyr2018
ren C staffNstartyr2019
ren D staffNstartyr2020

drop E-AB
drop if _n<=6
drop if country==""

sa "coded_3_sheet1_staffN.dta",replace

import excel using "3_Staff_metrics.xlsx",clear first sheet("Staff academic qualifications")

ren A country
ren E staffwBA2018
ren F staffwBA2019
ren G staffwBA2020

drop B C D H-AB
drop if _n<=6
drop if country==""

sa "coded_3_sheet1_staffacad.dta",replace

u coded_3_sheet1_staffN.dta,clear
merge 1:1 country using coded_3_sheet1_staffacad.dta
assert _merge==3
drop _merge
sa "coded_3_STAFF.dta",replace

* 7_Operating_metrics_audit_criminal_ (Dispute resolution number, Tax crime investigation, Audit and verification)

import excel using "7_Operating_metrics_audit_criminal_.xlsx",clear first sheet("Audit and verification")

ren A country
	drop if country=="D"
ren B auditverifN2018
ren C auditverifN2019
ren D auditverifN2020
ren E auditverifwassN2018
ren F auditverifwassN2019
ren G auditverifwassN2020

drop H-AB
drop if _n<=6
drop if country==""

sa "coded_7_sheet1_adutiverif.dta",replace

import excel using "7_Operating_metrics_audit_criminal_.xlsx",clear first sheet("Tax crime investigation")

ren A country
	drop if _n>174
	drop if country=="D"
ren B TArespinvestig2018
ren C TArespinvestig2019
ren D TArespinvestig2020
ren K taxcrimeinvestN2018
ren L taxcrimeinvestN2019
ren M taxcrimeinvestN2020

drop E-J N-AB
drop if _n<=6
drop if country==""

sa "coded_7_sheet4_investig.dta",replace

u coded_7_sheet1_adutiverif.dta,clear
merge 1:1 country using coded_7_sheet4_investig.dta
assert _merge==3
drop _merge
sa "coded_7_AUDIT.dta",replace

* 8_Stakeholder_interactions_registra(Total returns (to check against taxpayers N))

import excel using "8_Stakeholder_interactions_registra.xlsx",clear first sheet("Total number of returns receive")

ren A country
	drop if country=="D"
ren B returnsNCIT2018
ren C returnsNCIT2019
ren D returnsNCIT2020
ren E returnsNPIT2018
ren F returnsNPIT2019
ren G returnsNPIT2020
ren H returnsNVAT2018
ren I returnsNVAT2019
ren J returnsNVAT2020

drop K-AB
drop if _n<=6
drop if country==""

sa "coded_8_sheet6_returns.dta",replace

sa "coded_8_RETURNS.dta",replace

* 10_Indicators (summary tax information 2018-2020 and staff info)

import excel using "10_Derived_indicators_revenue_and_r.xlsx",clear first sheet("External variables")

ren A country
ren B country_code
ren C gdp2018_loccurr
ren D gdp2019_loccurr
ren E gdp2020_loccurr
ren F labforce2018
ren G labforce2019
ren H labforce2020
ren I totgovrev2018_loccurr
ren J totgovrev2019_loccurr
ren K totgovrev2020_loccurr
ren L pop2018
ren M pop2019
ren N pop2020

drop O-AB
drop if _n<=6
drop if country==""

sa "coded_10_sheet1_taxtotals.dta",replace

import excel using "10_Derived_indicators_revenue_and_r.xlsx",clear first sheet("Revenue related ratios")

ren A country
ren B rev2totgovrev2018
ren C rev2totgovrev2019
ren D rev2totgovrev2020
ren E rev2gdp2018
ren F rev2gdp2019
ren G rev2gdp2020
ren H taxssc2gdp2018
ren I taxssc2gdp2019
ren J taxssc2gdp2020
ren K taxnossc2gdp2018
ren L taxnossc2gdp2019
ren M taxnossc2gdp2020
ren N nontaxrev2totrev2018
ren O nontaxrev2totrev2019
ren P nontaxrev2totrev2020

drop Q-AB
drop if _n<=6
drop if country==""|strmatch(country,"*Please*")|strmatch(country,"*Formula*")

sa "coded_10_sheet2_taxratios.dta",replace

import excel using "10_Derived_indicators_revenue_and_r.xlsx",clear first sheet("Resource ratios")

ren A country
ren B popfte2018
ren C popfte2019
ren D popfte2020
ren E labforcefte2018
ren F labforcefte2019
ren G labforcefte2020
ren H recruit_costcoll2018
ren I recruitcost_coll2019
ren J recruitcost_coll2020
ren K salcost_opexp2018
ren L salcost_opexp2019
ren M salcost_opexp2020
ren N ictopcost_opexp2018
ren O ictopcost_opexp2019
ren P ictopcost_opexp2020

drop Q-AB
drop if _n<=5
drop if country==""|strmatch(country,"*Please*")|strmatch(country,"*Formula*")

sa "coded_10_sheet4_resourceratios.dta",replace

import excel using "10_Derived_indicators_revenue_and_r.xlsx",clear first sheet("Staff allocation by function an")

ren A country
ren B pct_staff_regservpay2018
ren C pct_staff_regservpay2019
ren D pct_staff_regservpay2020
ren E pct_staff_auditinvestig2018
ren F pct_staff_auditinvestig2019
ren G pct_staff_auditinvestig2020
ren H pct_staff_debtcoll2018
ren I pct_staff_debtcoll2019
ren J pct_staff_debtcoll2020
ren K pct_staff_othfunc2018
ren L pct_staff_othfunc2019
ren M pct_staff_othfunc2020
ren N pct_staff_headqtrs2018
ren O pct_staff_headqtrs2019
ren P pct_staff_headqtrs2020

drop Q-AB
drop if _n<=5
drop if country==""|strmatch(country,"*Please*")|strmatch(country,"*Formula*")

sa "coded_10_sheet5_staffalloc.dta",replace

u coded_10_sheet1_taxtotals.dta,clear
merge 1:1 country using coded_10_sheet2_taxratios.dta
assert _merge==3
drop _merge
merge 1:1 country using coded_10_sheet4_resourceratios.dta
assert _merge==3
drop _merge
merge 1:1 country using coded_10_sheet5_staffalloc.dta
assert _merge==3
drop _merge

sa "coded_10_TAXINDICATORS.dta",replace

* 11_Derived_indicators_segmentation_ (registration to potential base)

import excel using "11_Derived_indicators_segmentation_.xlsx",clear first sheet("Registration of personal income")

ren A country
ren B pctactivePIT2labforce2018
ren C pctactivePIT2labforce2019
ren D pctactivePIT2labforce2020
ren E pctactivePIT2pop2018
ren F pctactivePIT2pop2019
ren G pctactivePIT2pop2020

drop H-AB
drop if _n<=5
drop if country==""|strmatch(country,"*Please*")|strmatch(country,"*Formula*")

sa "coded_11_sheet2_pitreg.dta",replace

sa "coded_11_REGISTRATION.dta",replace

* 5_Operating_metrics_registration_an (number sheets)

import excel using "5_Operating_metrics_registration_an.xlsx",clear first sheet("Number of taxpayers for PIT and")

ren A country
ren B taxpayerNregPIT2018
ren C taxpayerNregPIT2019
ren D taxpayerNregPIT2020
ren E taxpayerNactivePIT2018
ren F taxpayerNactivePIT2019
ren G taxpayerNactivePIT2020
ren H taxpayerNregCIT2018
ren I taxpayerNregCIT2019
ren J taxpayerNregCIT2020
ren K taxpayerNactiveCIT2018
ren L taxpayerNactiveCIT2019
ren M taxpayerNactiveCIT2020

drop N-AB
drop if _n<=7
drop if country==""|country=="D"

sa "coded_5_sheet1_nPITCIT.dta",replace

import excel using "5_Operating_metrics_registration_an.xlsx",clear first sheet("Number of taxpayers for withhol")

ren A country
ren B taxpayerNreg_empl2018
ren C taxpayerNreg_empl2019
ren D taxpayerNreg_empl2020
ren E taxpayerNactive_empl2018
ren F taxpayerNactive_empl2019
ren G taxpayerNactive_empl2020
ren H taxpayerNreg_VAT2018
ren I taxpayerNreg_VAT2019
ren J taxpayerNreg_VAT2020
ren K taxpayerNactive_VAT2018
ren L taxpayerNactive_VAT2019
ren M taxpayerNactive_VAT2020
ren N taxpayerNreg_excis2018
ren O taxpayerNreg_excis2019
ren P taxpayerNreg_excis2020
ren Q taxpayerNactive_excis2018
ren R taxpayerNactive_excis2019
ren S taxpayerNactive_excis2020

drop T-AB
drop if _n<=7
drop if country==""|country=="D"

sa "coded_5_sheet2_ntaxpayertype.dta",replace

u coded_5_sheet1_nPITCIT.dta,clear
merge 1:1 country using coded_5_sheet2_ntaxpayertype.dta
assert _merge==3
drop _merge

sa "coded_5_TAXPAYERS.dta",replace

* 12_Derived_indicators_payment_arrea (almost all)

import excel using "12_Derived_indicators_payment_arrea.xlsx",clear first sheet("Electronic payment proportions ")

ren A country
ren B pct_elecpay_byN2018
ren C pct_elecpay_byN2019
ren D pct_elecpay_byN2020
ren E pct_elecpay_byVal2018
ren F pct_elecpay_byVal2019
ren G pct_elecpay_byVal2020
ren H pct_PITwheldpaid2018
ren I pct_PITwheldpaid2019
ren J pct_PITwheldpaid2020

drop K-AB
drop if _n<=5
drop if country==""|strmatch(country,"*Please*")|strmatch(country,"*Formula*")

sa "coded_12_sheet2_elecpay.dta",replace

import excel using "12_Derived_indicators_payment_arrea.xlsx",clear first sheet("Arrears closing stock total and")

ren A country
ren B arrears_pcttotrev2018
ren C arrears_pcttotrev2019
ren D arrears_pcttotrev2020
ren E collarrears_pctarrears2018
ren F collarrears_pctarrears2019
ren G collarrears_pctarrears2020
ren H SOEarrears_pctarrears2018
ren I SOEarrears_pctarrears2019
ren J SOEarrears_pctarrears2020
ren K collSOEarrears_pctarrears2018
ren L collSOEarrears_pctarrears2019
ren M collSOEarrears_pctarrears2020

drop N-AB
drop if _n<=5
drop if country==""|strmatch(country,"*Please*")|strmatch(country,"*Formula*")

sa "coded_12_sheet3_arrears.dta",replace

import excel using "12_Derived_indicators_payment_arrea.xlsx",clear first sheet("Audits hit rate and additional ")

ren A country
ren B audithitrate2018
ren C audithitrate2019
ren D audithitrate2020

drop E-AB
drop if _n<=5
drop if country==""|strmatch(country,"*Please*")|strmatch(country,"*Formula*")

sa "coded_12_sheet6_audits.dta",replace

u coded_12_sheet2_elecpay.dta,clear
merge 1:1 country using coded_12_sheet3_arrears.dta
assert _merge==3
drop _merge
merge 1:1 country using coded_12_sheet6_audits.dta
assert _merge==3
drop _merge

sa "coded_12_PAYARREARS.dta",replace

* Append all data

u coded_3_STAFF.dta,clear
drop if country=="D"
merge 1:1 country using coded_5_TAXPAYERS.dta
assert _merge==3
drop _merge
merge 1:1 country using coded_7_AUDIT.dta
assert _merge==3
drop _merge
merge 1:1 country using coded_8_RETURNS.dta
assert _merge==3
drop _merge
merge 1:1 country using coded_10_TAXINDICATORS.dta
assert _merge==3
drop _merge
merge 1:1 country using coded_11_REGISTRATION.dta
assert _merge==3
drop _merge
merge 1:1 country using coded_12_PAYARREARS.dta
assert _merge==3
drop _merge

* Merge in WB classes
preserve
import excel using "WB_CountryClass.xlsx",clear first
ren Economy country
ren Code country_code
tempfile WB_class
sa `WB_class'
restore
drop if country_code==""
replace country_code="XKX" if country=="Kosovo, Republic of"
merge 1:1 country_code using `WB_class'
*drop if _merge==2
ren _merge _merge_WDI_to_RAFIT

g Inc_id = 1 if Income=="Low income"
replace Inc_id = 2 if Income=="Lower middle income"
replace Inc_id = 3 if Income=="Upper middle income"
replace Inc_id = 4 if Income=="High income"

lab def Inc_id 1 "Low income" 2 "Lower middle income" 3 "Upper middle income" 4 "High income"
lab val Inc_id Inc_id

	foreach var in PIT CIT _empl _VAT _excis{
		cap replace taxpayerNactive`var'2018 = "" if taxpayerNactive`var'2018=="D"
		cap replace taxpayerNreg`var'2018 = "" if taxpayerNreg`var'2018=="D"
		cap destring taxpayerNactive`var'2018 taxpayerNreg`var'2018,replace
		g returns_actVSreg_`var'2018 = taxpayerNactive`var'2018/taxpayerNreg`var'2018
	}

sa "${repldir}/Data/02_clean_combined/rafit_coded.dta",replace

*******************
* Tax Tech Data *
*******************

cap cd "${repldir}/Data/01_base/taxtech_data"

*************
* Import code
*************

* Digital identity
import excel using "DI1.xlsx",clear first
ren Inv country
ren B req_digID
ren C DI_provby_taxauth
ren D DI_provby_govt
ren E DI_provby_priv
ren F DIs_interoperable
ren G DI_taxauth_use_govt
ren H DI_taxauth_use_priv
ren I DI_pctuse_0to20
ren J DI_pctuse_21to40
ren K DI_pctuse_41to60
ren L DI_pctuse_61to80
ren M DI_pctuse_81to100

drop if _n<=12
drop N-V
drop if country==""
replace country = trim(country)
sa "coded_DI1.dta",replace

import excel using "DI3.xlsx",clear first
ren Inv country
ren B DI_built_existsys
ren J DI_mindta_uniqID
ren O DI_mindta_govtissdoc
ren P DI_mindta_biometric

replace DI_built_existsys = "Yes" if DI_built_existsys=="E"|DI_built_existsys=="E "|DI_built_existsys=="E/N"
replace DI_built_existsys = "No" if DI_built_existsys=="N"

foreach var in DI_mindta_uniqID DI_mindta_govtissdoc DI_mindta_biometric{
			replace `var' = "No" if `var'==""
		}

drop if _n<=12
drop C-I K-N Q-AC
drop if country==""
replace country = trim(country)
sa "coded_DI3.dta",replace

* Taxpayer touchpoints
import excel using "TT1.xlsx",clear first
ren Inv country
ren B reg_onlineserv_PIT
ren C reg_partbroad_PIT
ren D reg_getautoresp_PIT
ren E file_onlineserv_PIT
ren F file_autoproc_PIT
ren G pay_onlineserv_PIT
ren H pay_partportal_PIT
ren I pay_autoproc_PIT
ren J reqext_onlineserv_PIT
ren K reqext_getautoresp_PIT
ren L askpayarr_onlineserv_PIT
ren M askpayarr_getautoresp_PIT
ren N inquir_onlineserv_PIT
ren O fileobj_onlineserv_PIT
ren P corr_onlineserv_PIT
ren Q uploaddta_onlineserv_PIT

foreach var in reg_onlineserv_PIT	reg_partbroad_PIT	reg_getautoresp_PIT	file_onlineserv_PIT	file_autoproc_PIT	pay_onlineserv_PIT	pay_partportal_PIT	pay_autoproc_PIT	reqext_onlineserv_PIT	reqext_getautoresp_PIT	askpayarr_onlineserv_PIT	askpayarr_getautoresp_PIT	inquir_onlineserv_PIT	fileobj_onlineserv_PIT	corr_onlineserv_PIT	uploaddta_onlineserv_PIT{
	replace `var' = "o" if `var'==""
}

drop if _n<=12
drop R-S
drop if country==""
replace country = trim(country)
sa "coded_TT1.dta",replace

import excel using "TT2.xlsx",clear first
ren Inv country
ren B reg_onlineserv_CIT
ren C reg_partbroad_CIT
ren D reg_getautoresp_CIT
ren E file_onlineserv_CIT
ren F file_autoproc_CIT
ren G pay_onlineserv_CIT
ren H pay_partportal_CIT
ren I pay_autoproc_CIT
ren J reqext_onlineserv_CIT
ren K reqext_getautoresp_CIT
ren L askpayarr_onlineserv_CIT
ren M askpayarr_getautoresp_CIT
ren N inquir_onlineserv_CIT
ren O fileobj_onlineserv_CIT
ren P corr_onlineserv_CIT
ren Q uploaddta_onlineserv_CIT

foreach var in reg_onlineserv_CIT	reg_partbroad_CIT	reg_getautoresp_CIT	file_onlineserv_CIT	file_autoproc_CIT	pay_onlineserv_CIT	pay_partportal_CIT	pay_autoproc_CIT	reqext_onlineserv_CIT	reqext_getautoresp_CIT	askpayarr_onlineserv_CIT	askpayarr_getautoresp_CIT	inquir_onlineserv_CIT	fileobj_onlineserv_CIT	corr_onlineserv_CIT	uploaddta_onlineserv_CIT{
	replace `var' = "o" if `var'==""
}

drop if _n<=12
drop R-Z
drop if country==""
replace country = trim(country)
sa "coded_TT2.dta",replace

import excel using "TT3.xlsx",clear first
ren Inv country
ren B reg_onlineserv_VAT
ren C reg_partbroad_VAT
ren D reg_getautoresp_VAT
ren E file_onlineserv_VAT
ren F file_autoproc_VAT
ren G pay_onlineserv_VAT
ren H pay_partportal_VAT
ren I pay_autoproc_VAT
ren J reqext_onlineserv_VAT
ren K reqext_getautoresp_VAT
ren L askpayarr_onlineserv_VAT
ren M askpayarr_getautoresp_VAT
ren N inquir_onlineserv_VAT
ren O fileobj_onlineserv_VAT
ren P corr_onlineserv_VAT
ren Q uploaddta_onlineserv_VAT

foreach var in reg_onlineserv_VAT	reg_partbroad_VAT	reg_getautoresp_VAT	file_onlineserv_VAT	file_autoproc_VAT	pay_onlineserv_VAT	pay_partportal_VAT	pay_autoproc_VAT	reqext_onlineserv_VAT	reqext_getautoresp_VAT	askpayarr_onlineserv_VAT	askpayarr_getautoresp_VAT	inquir_onlineserv_VAT	fileobj_onlineserv_VAT	corr_onlineserv_VAT	uploaddta_onlineserv_VAT{
	replace `var' = "o" if `var'==""
}

drop if _n<=12
drop R-Z
drop if country==""
replace country = trim(country)
sa "coded_TT3.dta",replace

import excel using "TT4.xlsx",clear first
ren Inv country
ren B accessopt_noonline
ren C accessopt_disabil

drop if _n<=12
drop D-N
drop if country==""
replace country = trim(country)
sa "coded_TT4.dta",replace

import excel using "TT5.xlsx",clear first
ren Inv country
ren B virtualassist
ren C virtualassist_rule
ren D virtualassist_AI
ren F taxinteract_AI

drop if _n<=12
drop E G-P
drop if country==""
replace country = trim(country)
sa "coded_TT5.dta",replace

* Data management
import excel using "DM1.xlsx",clear first
ren Inv country
ren B taxauth_reqstds_dtaexchg
ren C taxauth_reqstds_reckeep
ren D taxauth_recdta_taxpayers
ren E taxauth_taxpayerdta_mach
ren F taxauth_taxpayerdta_manupl
ren G taxauth_recdta_3rdparty
ren H taxauth_3rdpartydta_mach
ren I taxauth_3rdpartydta_manupl
ren J taxauth_accessdta_taxpayersys
ren K sometaxpayers_req_einvoice
ren L sometaxpayers_req_onlinecashreg

drop if _n<=12
drop M-U
drop if country==""
replace country = trim(country)
sa "coded_DM1.dta",replace

import excel using "DM2.xlsx",clear first
ren Inv country
ren B prefill_incinfo_PIT
ren C prefill_expinfo_PIT
ren D prefill_no_PIT
ren E prefill_incinfo_CIT
ren F prefill_expinfo_CIT
ren G prefill_no_CIT
ren H prefill_incinfo_VAT
ren I prefill_expinfo_VAT
ren J prefill_no_VAT
ren K prefill_fully
ren P prefilldta_onlinemkts
ren Q prefilldta_onlineother
ren R prefilldta_taxpayeraccsys
ren S prefilldta_einvoicesys
ren T prefilldta_onlinecashreg
ren U prefilldta_othergovtent
ren V prefilldta_privateent
ren W prefilldta_otherjuris

drop if _n<=12
drop L-O X-AG
drop if country==""
replace country = trim(country)
sa "coded_DM2.dta",replace

import excel using "DM3.xlsx",clear first
ren Inv country
ren B dtashare_interal
ren C dtashare_givegovt
ren D dtashare_receivegovt
ren E common_dtabase_yesno
ren F common_dtabase_popreg
ren G common_dtabase_propreg
ren H common_dtabase_busreg
ren I common_dtabase_motvehreg
ren K dtashare_w_empl
ren L dtashare_w_empl_auto
ren M dtashare_w_empl_taxp
ren N dtashare_w_wwhol
ren O dtashare_w_wwhol_auto
ren P dtashare_w_wwhol_taxp
ren Q dtashare_w_taxint
ren R dtashare_w_taxint_auto
ren S dtashare_w_taxint_taxp
ren T dtashare_w_finins
ren U dtashare_w_finins_auto
ren V dtashare_w_finins_taxp
ren W dtashare_w_oth
ren X dtashare_w_oth_auto
ren Y dtashare_w_oth_taxp
ren Z dtashare_3rdparty

drop if _n<=12
drop AA-AI J
drop if country==""
replace country = trim(country)
sa "coded_DM3.dta",replace

* TRM
import excel using "TRM3.xlsx",clear first
ren Inv country
ren B useAI_yesno
ren C useAI_persinfo
ren D useAI_virtass
ren E useAI_riskassess_PIT
ren F useAI_riskassess_CIT
ren G useAI_riskassess_VAT
ren H useAI_detectevasion
ren I useAI_assistadmin
ren J useAI_reccactions
ren K useAI_makefinaladmindec
ren L useAI_disputeres_PIT
ren M useAI_disputeres_CIT
ren N useAI_disputeres_VAT
ren O useAI_ensureinteg


drop if _n<=12
drop P-Z A*
drop if country==""
replace country = trim(country)
sa "coded_TRM3.dta",replace

* General elements
import excel using "SG3.xlsx",clear first
ren Inv country
ren B digtrans_plan
ren I digtrans_collab_impstaffskills
ren J digtrans_collab_recpool


drop if _n<=12
drop C-H K-S
drop if country==""
replace country = trim(country)
sa "coded_SG3.dta",replace


* Append all data

u coded_DI1.dta,clear
foreach name in DI3 TT1 TT2 TT3 TT4 TT5 DM1 DM2 DM3 TRM3 SG3{
merge 1:1 country using "coded_`name'.dta"
assert _merge==3
drop _merge
}

sa TAXTECH_COMBINED.dta,replace

* Merge RAFIT_COMBINED
preserve
u "${repldir}/Data/02_clean_combined/rafit_coded.dta",clear
* Keep 2018 (pre-COVID year, 2019 filing/payment affected by COVID)
keep country *2018* Inc*
replace country = "Laos" if strmatch(country,"*Lao*")
tempfile RAFIT_COMBINED
sa `RAFIT_COMBINED'
restore

replace country = "Armenia, Republic of" if country=="Armenia"
replace country = "China, P.R.: Mainland" if country=="China (People's Republic of)"
replace country = "Taiwan" if country=="Chinese Taipei"
replace country = "China, P.R.: Hong Kong" if country=="Hong Kong (China)"
replace country = "Kyrgyz Republic" if country=="Kyrgyzstan"
replace country = "Laos" if strmatch(country,"*Lao*")
replace country = "China, P.R.: Macau" if country=="Macau (China)"
replace country = "Turkey" if country=="Türkiye"
replace country = "Vietnam" if country=="Viet Nam"
replace country = "Macao SAR, China" if country=="China, P.R.: Macau"
drop if country=="n" | country=="o"

merge 1:1 country using `RAFIT_COMBINED'
assert _merge!=1
drop _merge //Tuvalu, Turkmenistan, Macau don't merge from TAXTECH side

* Fill in more revenue
preserve
use "${repldir}/Data/01_base/unuwider_data/UNUWIDERGRD_2022_Merged (Oct).dta",clear
keep if year==2018
keep country rev_ex_gr_ex_sc tax_income vat tax_corp
br country rev_ex_gr_ex_sc tax_income vat tax_corp
ren tax_income tax_income18
ren vat vat18
ren rev_ex_gr_ex_sc rev_ex_gr_ex_sc18
/*replace country = "Türkiye" if country=="Turkey"
replace country ="Hong Kong (China)" if country == "Hong Kong, China"*/
replace country ="China, P.R.: Mainland"  if country == "China"
replace country = "Congo, DR" if strmatch(country,"*Congo, Democratic R*")
replace country = "Congo Rep" if strmatch(country,"*Congo, Republic*")
replace country = "Czech Republic" if country=="Czechia"
replace country="China, P.R.: Hong Kong" if country=="Hong Kong, China"
replace country = "Laos" if strmatch(country,"*Lao*")
replace country = "Macao SAR, China" if strmatch(country,"*Macao, China*")
replace country = "Micronesia" if strmatch(country,"*Micronesia*")

/*replace country ="Viet Nam"  if country=="Vietnam"
replace country ="Slovak Republic"  if country == "Slovakia"
replace country ="Macau (China)" if country == "Macao, China"*/
tempfile unu
sa `unu'
restore

replace country = "Afghanistan" if strmatch(country,"*Afghanistan*")
replace country = "Armenia" if strmatch(country,"*Armenia*")
replace country = "Azerbaijan" if strmatch(country,"*Azerbaijan*")
replace country = "Cape Verde" if strmatch(country,"*Cabo Verde*")
replace country = "Congo, DR" if strmatch(country,"*Congo, Democratic R*")
replace country = "Congo Rep" if strmatch(country,"*Congo, Republic*")
replace country = "Yemen" if strmatch(country,"*Yemen*")
replace country = "Venezuela" if strmatch(country,"*Venezuela*")
replace country = "Timor-Leste" if strmatch(country,"*Timor-Leste*")
replace country = "Sao Tome and Principe" if strmatch(country,"*São Tomé and Príncipe*")
replace country = "Slovakia" if strmatch(country,"*Slovak*")
replace country = "Serbia" if strmatch(country,"*Serb*")

replace country = "Saint Lucia" if strmatch(country,"*St. Lucia*")
replace country = "Saint Vincent and the Grenadines" if strmatch(country,"*St. Vincent*")
replace country = "Saint Kitts and Nevis" if strmatch(country,"*St. Kitts*")
replace country = "Egypt" if strmatch(country,"*Egypt*")
replace country = "Guinea-Bissau" if strmatch(country,"*Guinea Bissau*")
replace country = "Iran" if strmatch(country,"*Iran*")
replace country = "Kosovo" if strmatch(country,"*Kosovo*")
replace country = "Kyrgyzstan" if strmatch(country,"*Kyrgyz*")
replace country = "Laos" if strmatch(country,"*Lao*")
replace country = "Micronesia" if strmatch(country,"*Micronesia*")
replace country = "Marshall Islands" if strmatch(country,"*Marshall Islands*")
replace country = "Cote d'Ivoire" if strmatch(country,"*Ivoire*")
replace country = "North Macedonia" if strmatch(country,"*North Macedonia*")

merge 1:1 country using `unu'
drop if _merge==2
drop _merge

***********
* Variables
***********
	
	foreach var in PIT CIT _empl _VAT _excis{
		cap replace taxpayerNactive`var'2018 = "" if taxpayerNactive`var'2018=="D"
		cap replace taxpayerNreg`var'2018 = "" if taxpayerNreg`var'2018=="D"
		cap destring taxpayerNactive`var'2018 taxpayerNreg`var'2018,replace
		cap g returns_actVSreg_`var'2018 = taxpayerNactive`var'2018/taxpayerNreg`var'2018
	}
	
	* For index of tax technology:
	#delimit ;
	global tech_index_vars = "taxauth_recdta_taxpayers
	taxauth_recdta_3rdparty
	sometaxpayers_req_einvoice
	sometaxpayers_req_onlinecashreg
	dtashare_receivegovt
	common_dtabase_yesno
	common_dtabase_popreg
	common_dtabase_propreg
	common_dtabase_busreg
	common_dtabase_motvehreg
	req_digID
	DI_built_existsys
	DI_mindta_uniqID
	DI_mindta_govtissdoc
	DI_mindta_biometric
	reg_onlineserv_PIT
	reg_onlineserv_CIT
	reg_onlineserv_VAT
	file_onlineserv_PIT
	file_onlineserv_CIT
	file_onlineserv_VAT
	pay_onlineserv_PIT
	pay_onlineserv_CIT
	pay_onlineserv_VAT
	reqext_onlineserv_PIT
	reqext_onlineserv_CIT
	reqext_onlineserv_VAT
	askpayarr_onlineserv_PIT
	askpayarr_onlineserv_CIT
	askpayarr_onlineserv_VAT
	useAI_yesno
	useAI_persinfo
	useAI_riskassess_PIT
	useAI_riskassess_CIT
	useAI_riskassess_VAT
	useAI_detectevasion
	digtrans_plan
	digtrans_collab_impstaffskills
	digtrans_collab_recpool";
	#delimit cr
		
		foreach var in $tech_index_vars{
			ta `var'
			cap replace `var' = "Yes" if `var'=="n"
			cap replace `var' = "No" if `var'=="o"
		}
		
		global fix_vars = "prefill_incinfo_PIT prefill_expinfo_PIT prefill_incinfo_CIT prefill_expinfo_CIT prefill_incinfo_VAT prefill_expinfo_VAT reg_onlineserv_VAT pay_onlineserv_VAT pay_onlineserv_CIT reg_onlineserv_CIT pay_onlineserv_PIT reg_onlineserv_PIT"
		
		replace prefill_incinfo_PIT = "No" if prefill_no_PIT=="n"
		replace prefill_expinfo_PIT = "No" if prefill_no_PIT=="n"
		replace prefill_incinfo_CIT = "No" if prefill_no_CIT=="n"
		replace prefill_expinfo_CIT = "No" if prefill_no_CIT=="n"
		replace prefill_incinfo_VAT = "No" if prefill_no_VAT=="n"
		replace prefill_expinfo_VAT = "No" if prefill_no_VAT=="n"
		
		replace sometaxpayers_req_onlinecashreg = "0" if sometaxpayers_req_onlinecashreg=="no"
		replace digtrans_plan = "1" if strmatch(digtrans_plan,"*Yes*")
		
		foreach var in $tech_index_vars{
			replace `var' = "1" if `var'=="Yes"
			replace `var' = "0" if `var'=="No"
			destring `var',replace
			ta `var'
		}
		
		* Create combined vars for some indices
		
		egen reg_onlineserv_any = rowmax(reg_onlineserv_PIT reg_onlineserv_CIT reg_onlineserv_VAT)
		g reg_onlineserv_all = 1 if reg_onlineserv_PIT==1 & reg_onlineserv_CIT==1 & reg_onlineserv_VAT==1
		replace reg_onlineserv_all = 0 if reg_onlineserv_PIT!=. & reg_onlineserv_CIT!=. & reg_onlineserv_VAT!=.
		
		egen file_onlineserv_any = rowmax(file_onlineserv_PIT file_onlineserv_CIT file_onlineserv_VAT)
		g file_onlineserv_all = 1 if file_onlineserv_PIT==1 & file_onlineserv_CIT==1 & file_onlineserv_VAT==1
		replace file_onlineserv_all = 0 if file_onlineserv_PIT!=. & file_onlineserv_CIT!=. & file_onlineserv_VAT!=.
		
		egen pay_onlineserv_any = rowmax(pay_onlineserv_PIT pay_onlineserv_CIT pay_onlineserv_VAT)
		g pay_onlineserv_all = 1 if pay_onlineserv_PIT==1 & pay_onlineserv_CIT==1 & pay_onlineserv_VAT==1
		replace pay_onlineserv_all = 0 if pay_onlineserv_PIT!=. & pay_onlineserv_CIT!=. & pay_onlineserv_VAT!=.

		egen reqext_onlineserv_any = rowmax(reqext_onlineserv_PIT reqext_onlineserv_CIT reqext_onlineserv_VAT)
		g reqext_onlineserv_all = 1 if reqext_onlineserv_PIT==1 & reqext_onlineserv_CIT==1 & reqext_onlineserv_VAT==1
		replace reqext_onlineserv_all = 0 if reqext_onlineserv_PIT!=. & reqext_onlineserv_CIT!=. & reqext_onlineserv_VAT!=.

		egen askpayarr_onlineserv_any = rowmax(askpayarr_onlineserv_PIT askpayarr_onlineserv_CIT askpayarr_onlineserv_VAT)
		g askpayarr_onlineserv_all = 1 if askpayarr_onlineserv_PIT==1 & askpayarr_onlineserv_CIT==1 & askpayarr_onlineserv_VAT==1
		replace askpayarr_onlineserv_all = 0 if askpayarr_onlineserv_PIT!=. & askpayarr_onlineserv_CIT!=. & askpayarr_onlineserv_VAT!=.
		
		egen useAI_riskassess_any = rowmax(useAI_riskassess_PIT useAI_riskassess_CIT useAI_riskassess_VAT)
		g useAI_riskassess_all = 1 if useAI_riskassess_PIT==1 & useAI_riskassess_CIT==1 & useAI_riskassess_VAT==1
		replace useAI_riskassess_all = 0 if useAI_riskassess_PIT!=. & useAI_riskassess_CIT!=. & useAI_riskassess_VAT!=.
		
		*********OO: AI variables wrongly coded (no 0s, only missings)
		replace useAI_riskassess_any=0 if useAI_riskassess_any==.
		replace useAI_riskassess_any=. if taxauth_recdta_taxpayers ==.
		
		replace useAI_detectevasion=0 if useAI_detectevasion==.
		replace useAI_detectevasion=. if taxauth_recdta_taxpayers ==.
		
		* combined Digital Identity var
		egen DI_mindta_any = rowmax(DI_mindta_uniqID DI_mindta_govtissdoc DI_mindta_biometric)
		
	sa "${repldir}/Data/02_clean_combined/taxtech_coded.dta",replace
