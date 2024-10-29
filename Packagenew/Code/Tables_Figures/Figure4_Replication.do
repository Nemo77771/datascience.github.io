
import excel "${repldir}/Data/01_base/lagos_data/Lagos_total_tax_99_12.xlsx", sheet("Sheet1") firstrow allstring clear

destring Year, g(year) 
destring Lagostotaltaxfromdigestinb, gen(lagos_tax)
destring Consumerpriceindex, gen(cpi)

gen lagos_tot_tax_adj=(lagos_tax/cpi)*100

twoway (connect lagos_tot_tax_adj year if year<2013), xtitle("")  xlabel(1999(1)2012, angle(90))  ylabel(0(20)180, angle(0) nogrid) xline(2004 2007, lpattern(dash)) text(140 2005.5 "Federal government" 130 2005.5 "witholds transfers" 120 2005.5 "from Lagos local" 110 2005.5 "governments",size(small)) graphregion(color(white) fcolor(white) lcolor(white) ilcolor(white) ifcolor(white)) legend(off) ytitle("Billions Naira (2010 prices)") 

graph export "${reploutdir}/Figure4.pdf", replace 

