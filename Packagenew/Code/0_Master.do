********************************************************************************
* Program: 0_Master.do
* Author: Gabriel Tourek
* Created: 30 Oct 2023
* Modified: 		
* Purpose: Replication of "How Can Lower-Income Countries Collect More Taxes? 
*		   The Role of Technology, Tax Agents, and Politics" by
*		   Okunogbe and Tourek (2023).
********************************************************************************

	clear all
	set more off
	set varabbrev on

	
	set timeout1 32000
	set timeout2 32000
	set maxvar 30000

	
* 1. Set up your user specific root directory to Replication Materials folder

		gl stem "C:/WBG/Rep-checks/20231102-jep-tax-2023-v1.1"
		sysdir set PLUS "${stem}/Code/ado"
	
* 3. Route file paths

		global repldir "${stem}"
		
		// Dofiles
		global repldodir "${stem}/Code"
		
		// Output
		global reploutdir "${stem}/Output"

* 4. Run replication files

	do "$repldodir/1_Package_Setup.do"
	do "$repldodir/2_Data_Construction.do"
	do "$repldodir/3_Tables_Figures.do"

cap log close main
cap log off main
	
