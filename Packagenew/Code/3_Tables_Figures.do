********************************************************************************
* Program: 3_Tables_Figures
* Author: Gabriel Tourek
* Created: 30 Oct 2023
* Modified: 		
* Purpose: Replicate Main Tables and Figures
********************************************************************************

foreach output in Figure1 Figure2_Table1 Figure3 Figure4{
	do "$repldodir/Tables_Figures/`output'_Replication.do"
}
