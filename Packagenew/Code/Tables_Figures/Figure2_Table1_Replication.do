clear
set more off

* Import data
u "${repldir}/Data/02_clean_combined/taxtech_coded.dta",clear


		
* Generate indices
		
		global index_detection = "taxauth_recdta_taxpayers taxauth_recdta_3rdparty sometaxpayers_req_einvoice sometaxpayers_req_onlinecashreg dtashare_receivegovt common_dtabase_yesno useAI_riskassess_any useAI_detectevasion" //old index_3rdpartyinfo + AI detect vars from index_innovation
		
		global index_identcap = "req_digID DI_built_existsys DI_mindta_any reg_onlineserv_any" // old index_identification + register online from index_taxpayerserv
		
		global index_collection = "askpayarr_onlineserv_any  reqext_onlineserv_any  pay_onlineserv_any  file_onlineserv_any" // old index_taxpayerserv - register online + useAI_persinfo from index_innovation
		
		global index_full_new = "taxauth_recdta_taxpayers taxauth_recdta_3rdparty sometaxpayers_req_einvoice sometaxpayers_req_onlinecashreg dtashare_receivegovt common_dtabase_yesno useAI_riskassess_any useAI_detectevasion req_digID DI_built_existsys DI_mindta_any reg_onlineserv_any askpayarr_onlineserv_any  reqext_onlineserv_any  pay_onlineserv_any  file_onlineserv_any"
		
		
		foreach index in index_detection index_identcap index_collection index_full_new{ 
		egen `index' = rowtotal($`index'), missing
		sum `index'
		g `index'_orig = `index'
		replace `index' = (`index' -`r(mean)')/(`r(sd)')  //standardize index
		}

		foreach var in index_detection index_identcap index_collection index_full_new{ 
		sum `var', d
		g `var'_norm = (`var'-`r(min)')/(`r(max)'-`r(min)') //normalize variables
		}
		
		* For online appendix
		sum index_*_orig
		
******************
* Figure and Table
******************

* Revenue/GDP to ICT cost operating expenditure
replace rev2gdp2018 = "" if rev2gdp2018=="D"
replace ictopcost_opexp2018 = "" if ictopcost_opexp2018=="D"
destring rev2gdp2018 ictopcost_opexp2018,replace

replace rev2gdp2018 = rev_ex_gr_ex_sc18 if rev2gdp2018==.

replace rev2gdp2018 = . if country=="Tuvalu"

replace rev_ex_gr_ex_sc18 = rev2gdp2018 if rev_ex_gr_ex_sc18==.

* Revenue/GDP to indices

* Figure 2
preserve

replace country = "China" if country=="China, P.R.: Mainland"
g country_lab = country ///
	if country=="United States" | ///
	 country=="United Kingdom" | ///
	 country=="Sweden" | ///
	 country=="Denmark" | ///
	 country=="Pakistan" | ///
	 country=="Brazil" | ///
	 country=="Canada" | ///
	 country=="Saudi Arabia" | ///
	 country=="Switzerland" | ///
	 country=="Rwanda" | ///
	 country=="Zambia" | ///
	 country=="India" | ///
	 country=="Indonesia" | ///
	 country=="China"

drop if Inc_id==.
drop if index_full_new<-1.7
drop if index_full_new>2
tw (scatter rev2gdp2018 index_full_new if Inc_id==4 & country!="Switzerland" & country!="United States",mlab(country_lab) mlabsize(vsmall) m(circle) mc(black) mlabpos(3)) ///
(scatter rev2gdp2018 index_full_new if Inc_id==3,mlab(country_lab) mlabsize(vsmall) m(square) mc(gray)) ///
(scatter rev2gdp2018 index_full_new if Inc_id==2 & country!="Indonesia",mlab(country_lab) mlabsize(vsmall) m(diamond) mc(midblue*0.5)) ///
(scatter rev2gdp2018 index_full_new if Inc_id==1 & country!="Rwanda",mlab(country_lab) mlabsize(vsmall) mlabpos(2) m(triangle) mc(green*0.5)) (lfit rev2gdp2018 index_full_new if Inc_id!=.,lc(navy)) ///
(scatter rev2gdp2018 index_full_new if Inc_id==4 & inlist(country_lab,"Switzerland","United States"),mlab(country_lab) mlabsize(vsmall) m(circle) mc(black) mlabpos(5)) ///
(scatter rev2gdp2018 index_full_new if Inc_id==2 & inlist(country_lab,"Indonesia","United States"),mlab(country_lab) mlabsize(vsmall) m(diamond) mc(midblue*0.5) mlabpos(2)) ///
(scatter rev2gdp2018 index_full_new if Inc_id==1 & country=="Rwanda",mlab(country_lab) mlabsize(vsmall) mlabpos(1) m(triangle) mc(green*0.5)), ///
legend(order(4 3 2 1) label(1 "High-income") label(2 "Upper-middle-income") label(3 "Lower-middle-income") label(4 "Low-income") pos(6) rows(1)) ///
xtitle("Index of Taxation Technology",size(small)) ytitle("Tax Revenue as a Share of GDP",size(small)) xscale(range(-1.75 1.75)) xlab(-1(1)1) xtick(-1.75(0.25)1.75) ttext(25 1.4 "Slope = 2.32 (se = 1.10)", size(vsmall) col(gs4))
graph export "${reploutdir}/Figure2.pdf",replace
restore

reg rev2gdp2018 index_full_new if Inc_id!=.,robust //slope for graph
reg rev2gdp2018 index_full_new if Inc_id==1|Inc_id==2,robust
reg rev2gdp2018 index_full_new if Inc_id==3|Inc_id==4,robust

* Summary statistics for appendix
sum index_identcap_orig index_detection_orig index_collection_orig index_full_new_orig if Inc_id!=. & rev2gdp2018!=.


* Indicators for income level
cap drop I_*
g I_high_income = 1 if Inc_id==4
replace I_high_income = 0 if Inc_id!=. & Inc_id!=4
g I_upmid_income = 1 if Inc_id==3
replace I_upmid_income = 0 if Inc_id!=. & Inc_id!=3
g I_lomid_income = 1 if Inc_id==2
replace I_lomid_income = 0 if Inc_id!=. & Inc_id!=2


* Regression Table 1: For tech indices only
preserve
drop if Inc_id==.
eststo clear
eststo: reg rev2gdp2018 index_full_new i.Inc_id,robust
	estadd scalar Observations = `e(N)'
eststo: reg rev2gdp2018 index_identcap i.Inc_id,robust
	estadd scalar Observations = `e(N)'
eststo: reg rev2gdp2018 index_detection i.Inc_id,robust
	estadd scalar Observations = `e(N)'
eststo: reg rev2gdp2018 index_collection i.Inc_id,robust
	estadd scalar Observations = `e(N)'

	esttab using "${reploutdir}/Table1.tex", ///
	replace label b(%9.3f) se(%9.3f) ///
	keep (index_full_new index_identcap index_detection index_collection) ///
	order(index_full_new index_identcap index_detection index_collection) ///
	nomtitles ///
	mgroups("Tax/GDP 2018" "Tax/GDP 2018" "Tax/GDP 2018" "Tax/GDP 2018",  pattern(1 1 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) span) /// 
	star(* 0.10 ** 0.05 *** 0.001) ///
	nogaps nonotes compress
restore
