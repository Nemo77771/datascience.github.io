***************************************************************************************
* Program: 1_Package_Setup.do
* Author: Gabriel Tourek
* Created: 30 Oct 2023
* Modified: 		
* Purpose: Checks if necessary packages are present, and if not, installs them.
*	 Modified from Gentzkow Shapiro Lab's config_stata.do 
*	(https://github.com/gslab-econ/template/blob/master/config/config_stata.do)
***************************************************************************************

* The section below is commented-out because the package files are included
* in the folder ./Code/ado . No package installation is necessary

/*
local ssc_packages "estout grstyle palettes revrs blindschemes"
* install using ssc, but avoid re-installing if already present
foreach pkg in `ssc_packages' {
	capture which `pkg'
	if _rc == 111 {                 
		dis "Installing `pkg'"
		quietly ssc install `pkg', replace
	}
}
*/

* Set graph style
cap set scheme plainplot
cap set scheme plotplainblind //for Stata 18
