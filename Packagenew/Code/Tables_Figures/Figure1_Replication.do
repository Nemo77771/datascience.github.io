

* Import Data
use "${repldir}/Data/01_base/unuwider_data/UNUWIDERGRD_2022_Merged (Oct).dta",clear

* Merge with GDP

preserve
	use "${repldir}/Data/01_base/unuwider_data/WIID_30JUN2022_0.dta",clear
	collapse (max) gdp (min) gini ratio_top20bottom20 (max) population,by(country year)
	tempfile gdp
	sa `gdp'
restore

merge 1:1 country year using `gdp',keepusing(gini gdp ratio_top20bottom20 population)
drop if _merge==2

encode country,g(country_id)

tsset,clear
tsset country_id year,yearly
sort country_id year
by country_id: g laggdp = gdp[_n-1]
g gdpmis = gdp==.
bys country_id gdpmis: egen minyearwgdp1 = min(year)
replace minyearwgdp = . if gdpmis==1
by country_id: egen minyearwgdp2 = min(minyearwgdp1)
by country_id: g firstgdp1 = gdp if year==minyearwgdp2
by country_id: egen firstgdp2 = max(firstgdp1)

g yryrgdp = (gdp-laggdp)/laggdp
cap drop gdpvsfirst
g gdpvsfirst = ((gdp-firstgdp2)/firstgdp2)*100


* 5-year averages
	egen yearcut = cut(year),at(1982(5)2022)
	egen yearcut3 = cut(year),at(1980(3)2022)
	bys yearcut inc: egen meangdp5yr = mean(gdp)
	bys yearcut3 inc: egen meangdp3yr = mean(gdp)
	
**********************************************************************
* Figure 1: Growth GDP 1990 to 2018 vs. Tax to GDP growth 1990 to 2018

preserve

g gdp1990_tmp = gdp if year>=1990 & year<=2000
g gdp2018_tmp = gdp if year>=2010 & year<=2019
g rev1990_tmp = rev_ex_gr_ex_sc if year>=1990 & year<=2000
g rev2018_tmp = rev_ex_gr_ex_sc if year>=2010 & year<=2019

drop if country=="El Salvador"

foreach var in gdp rev{
foreach yy in 1990 2018{
bys country: egen `var'`yy'_tmp2 = mean(`var'`yy'_tmp)
bys country: egen `var'`yy' = max(`var'`yy'_tmp2)
}
g `var'_chg90to18 = (`var'2018-`var'1990)/`var'1990
}
br country year gdp rev_ex_gr_ex_sc gdp_chg rev_chg

collapse (max) gdp_chg90to18 rev_chg90to18 rev*_tmp (max) inc reg,by(country)

* Measures for footnote 1
sum rev1990_tmp if inc==3|inc==4,d
sum rev2018_tmp if inc==3|inc==4,d
sum rev1990_tmp if inc==1|inc==2,d
sum rev2018_tmp if inc==1|inc==2,d

sum rev2018_tmp if inc==4,d
sum rev1990_tmp if inc==4,d
sum rev2018_tmp if inc==3,d
sum rev1990_tmp if inc==3,d
sum rev2018_tmp if inc==2,d
sum rev1990_tmp if inc==2,d
sum rev2018_tmp if inc==1,d
sum rev1990_tmp if inc==1,d
sum rev1990_tmp,d
sum rev2018_tmp,d

	keep if inc==1 | inc==2
	drop if rev_chg90to18>1.7
	drop if gdp_chg90to18>1.75
	replace country = "Micronesia" if strmatch(country,"*Micronesia*")
	g country_lab = country if ///
		country=="Guinea-Bissau" | ///
		country=="Mozambique" | ///
		country=="Nigeria" | ///
		country=="Kenya" | ///
		country=="Pakistan" | ///
		country=="Bangladesh" | ///
		country=="Ghana" | ///
		country=="Nepal" | ///
		country=="Cambodia" | ///
		country=="Sri Lanka" | ///
		country=="India" | ///
		country=="Vietnam" | ///
		country=="Yemen" | ///
		country=="Zimbabwe" | ///
		country=="Mali" | ///
		country=="Uganda" | ///
		country=="Malawi" | ///
		country=="Haiti" | ///
		country=="Burkina Faso" | ///
		country=="Senegal" | ///
		country=="Iran" | ///
		country=="Tanzania" | ///
		country=="Indonesia" | ///
		country=="Cote d'Ivoire" | ///
		country=="Morocco" | ///
		country=="Ukraine" | ///
		country=="Ethiopia"
	replace rev_chg90to18 = rev_chg90to18*100
	replace gdp_chg90to18 = gdp_chg90to18*100
	drop if inc!=1 & inc!=2
	
	tw (scatter rev_chg90to18 gdp_chg90to18 if inc==1 & country!="Uganda",mlab(country_lab) mlabsize(vsmall) mlabpos(2) m(circle) mc(teal)) ///
		(scatter rev_chg90to18 gdp_chg90to18 if inc==2 & country!="Kenya" & country!="India" & country!="Pakistan" & country!="Haiti" & country!="Iran" & country!="Cote d'Ivoire" & country!="Vietnam",mlab(country_lab) mlabpos(2) mlabsize(vsmall) m(triangle) mc(midblue*0.5)) ///
		(scatter rev_chg90to18 gdp_chg90to18 if inc==1 & (country=="Uganda"),mlab(country_lab) mlabsize(vsmall) mlabpos(12) m(circle) mc(teal)) ///
		(scatter rev_chg90to18 gdp_chg90to18 if inc==2 & (country=="Haiti"),mlab(country_lab) mlabsize(vsmall) mlabpos(3) m(triangle) mc(midblue*0.5)) ///
		(scatter rev_chg90to18 gdp_chg90to18 if inc==2 & (country=="Kenya"|country=="India"),mlab(country_lab) mlabsize(vsmall) mlabpos(3) m(triangle) mc(midblue*0.5)) ///
		(scatter rev_chg90to18 gdp_chg90to18 if inc==2 & (country=="Pakistan"),mlab(country_lab) mlabsize(vsmall) mlabpos(4) m(triangle) mc(midblue*0.5)) ///
		(scatter rev_chg90to18 gdp_chg90to18 if inc==2 & (country=="Iran"),mlab(country_lab) mlabsize(vsmall) mlabpos(4) m(triangle) mc(midblue*0.5)) ///
		(scatter rev_chg90to18 gdp_chg90to18 if inc==2 & (country=="Cote d'Ivoire"|country=="Vietnam"),mlab(country_lab) mlabsize(vsmall) mlabpos(6) m(triangle) mc(midblue*0.5)) ///
		(lfit rev_chg90to18 gdp_chg90to18 if inc==1 | inc==2,lc(navy)), xtitle("% Change in GDP per capita, 1990-2000 to 2010-2019",size(small)) ///
		ytitle("% Change in Tax/GDP, 1990-2000 to 2010-2019",size(small)) legend(order(1 2) rows(1) label(1 "Low-income countries") label(2 "Lower-middle-income countries") pos(6)) yscale(range(-75 175)) xscale(range(-30 170)) xtick(-25(25)175) xlab(0(50)150) ///
		ttext(45 150 "Slope = 0.04 (se = 0.16)", size(vsmall) col(gs4))

		
		reg rev_chg90to18 gdp_chg90to18 if inc==1 | inc==2,robust //slope for figure

		graph export "${reploutdir}/Figure1.pdf",replace
		
	restore
