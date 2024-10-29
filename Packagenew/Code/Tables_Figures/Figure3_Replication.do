clear
set more off

u "${repldir}/Data/02_clean_combined/rafit_coded.dta",replace

***********
* Variables
***********

* Keep 2018 (pre-COVID year, 2019 filing/payment affected by COVID)
keep country *2018* Inc*

********
* Figure
********

* Revenue/GDP to ICT cost operating expenditure
replace rev2gdp2018 = "" if rev2gdp2018=="D"
replace ictopcost_opexp2018 = "" if ictopcost_opexp2018=="D"
destring rev2gdp2018 ictopcost_opexp2018,replace

replace popfte2018 = "" if popfte2018=="D"
destring popfte2018,replace

* Arrears to staff per pop
cap replace popfte2018 = "" if popfte2018=="D"
cap destring popfte2018,replace


* Revenue/GDP to staff per pop/labforce2018
replace labforcefte2018 = "" if labforcefte2018=="D"
destring labforcefte2018,replace

* Figure 3: exclude island nations for readability of figure
preserve
g country2 = ""
replace country2 = country if inlist(country,"United Kingdom","United States","Canada","Mexico","Argentina","Norway","Germany")
replace country2 = country if inlist(country,"Sweden","Denmark","Ghana","Pakistan","Morocco","Liberia","Central African Republic")
replace country2 = country if inlist(country,"Zimbabwe","South Africa","Cameroon","Turkey","Ecuador","Costa Rica","Singapore")
replace country2 = country if inlist(country,"Dominican Republic","Australia","Czech Republic","Cyprus","Japan")
replace country2 = country if inlist(country,"Slovak Republic","Poland","Austria","Portugal","Latvia","Uruguay")
replace country2 = country if inlist(country,"Slovenia","Poland","Austria","Portugal","Latvia","China, P.R.: Hong Kong")
replace country2 = country if inlist(country,"Estonia","Saudi Arabia","Switzerland")
replace country="" if strmatch(country,"*Antigua and Barbuda*")


replace country="Afghanistan" if strmatch(country,"*Afghan*")

replace country="" if strmatch(country,"*Bahamas*")
replace country="" if strmatch(country,"*Barbados*")
replace country="" if strmatch(country,"*Belize*")
replace country="" if strmatch(country,"*Cabo Verde*")
replace country="" if strmatch(country,"*Comoros*")
replace country="" if strmatch(country,"*Cuba*")
replace country="" if strmatch(country,"*Dominica*")
replace country="" if strmatch(country,"*Dominican Republic*")
replace country="" if strmatch(country,"*Fiji*")
replace country="" if strmatch(country,"*Grenada*")
replace country="" if strmatch(country,"*Guinea-Bissau*")
replace country="" if strmatch(country,"*Guyana*")
replace country="" if strmatch(country,"*Haiti*")
replace country="" if strmatch(country,"*Jamaica*")
replace country="" if strmatch(country,"*Kiribati*")
replace country="" if strmatch(country,"*Maldives*")
replace country="" if strmatch(country,"*Marshall Islands*")
replace country="" if strmatch(country,"*Federated States of Micronesia*")
replace country="" if strmatch(country,"*Mauritius*")
replace country="" if strmatch(country,"*Nauru*")
replace country="" if strmatch(country,"*Palau*")
replace country="" if strmatch(country,"*Papua New Guinea*")
replace country="" if strmatch(country,"*Samoa*")
replace country="" if strmatch(country,"*Sao Tome and Principe*")
replace country="" if strmatch(country,"*Singapore*")
replace country="" if strmatch(country,"*St. Kitts and Nevis*")
replace country="" if strmatch(country,"*St. Lucia*")
replace country="" if strmatch(country,"*St. Vincent and the Grenadines*")
replace country="" if strmatch(country,"*Seychelles*")
replace country="" if strmatch(country,"*Solomon Islands*")
replace country="" if strmatch(country,"*Suriname*")
replace country="" if strmatch(country,"*Timor-Leste*")
replace country="" if strmatch(country,"*Tonga*")
replace country="" if strmatch(country,"*Trinidad and Tobago*")
replace country="" if strmatch(country,"*Tuvalu*")
replace country="" if strmatch(country,"*Vanuatu*")
replace country="" if strmatch(country,"*Turks and Caicos Islands*")
replace country="" if strmatch(country,"*Cook Islands*")
drop if country==""

replace country = "China" if country=="China, P.R.: Mainland"
g country_lab = country ///
	if country=="United States" | ///
	 country=="United Kingdom" | ///
	 country=="Sweden" | ///
	 country=="Denmark" | ///
	 country=="South Africa" | ///
	 country=="Pakistan" | ///
	 country=="Ghana" | ///
	 country=="Togo" | ///
	 country=="South Africa" | ///
	 country=="Liberia" | ///
	 country=="Saudi Arabia" | ///
	 country=="Switzerland" | ///
	 country=="China"


drop if popfte2018>13500
tw (scatter rev2gdp2018 popfte2018 if Inc_id==4 & country!="Switzerland",mlab(country_lab) mlabsize(vsmall) mlabpos(3) m(circle) mc(black)) ///
(scatter rev2gdp2018 popfte2018 if Inc_id==3 & country!="China",mlab(country_lab) mlabsize(vsmall) m(square) mc(gray)) ///
(scatter rev2gdp2018 popfte2018 if Inc_id==2,mlab(country_lab) mlabsize(vsmall) m(diamond) mc(midblue*0.5)) ///
(scatter rev2gdp2018 popfte2018 if Inc_id==1,mlab(country_lab) mlabsize(vsmall) mlabpos(2) m(triangle) mc(green*0.5)) (lfit rev2gdp2018 popfte2018 if Inc_id!=.,lc(navy)) ///
(scatter rev2gdp2018 popfte2018 if Inc_id==4 & country=="Switzerland",mlab(country_lab) mlabsize(vsmall) mlabpos(4) m(circle) mc(black)) ///
(scatter rev2gdp2018 popfte2018 if Inc_id==3 & country=="China",mlab(country_lab) mlabsize(vsmall) mlabpos(2) m(square) mc(gray)), ///
legend(order(4 3 2 1) label(1 "High income") label(2 "Upper middle income") label(3 "Lower middle income") label(4 "Low income") pos(6) rows(1)) ///
ytitle("Tax Revenue as a Share of GDP",size(small)) xtitle("Population per Tax Staff",size(small)) ///
 ttext(3 9000 "Slope = -0.002 (se = 0.0002)", size(vsmall) col(gs4))
g popfte2018_1000 = popfte2018/1000
reg rev2gdp2018 popfte2018 if Inc_id!=.,robust // slope estimate

graph export "${reploutdir}/Figure3.pdf",replace
restore
