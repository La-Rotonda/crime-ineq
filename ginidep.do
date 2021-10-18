/**************************************************************
*Project	:	Crime and inequality: a departmental exploratory analysis
*Objetive	: 	Calculate Gini index by department
*Author		:  	Gianella Basilio (gianella.basilio@unmsm.edu.pe)
*Inputs		:	ENAHO (2011-2019)
*Outputs	:	Giani index
*Comments	:	The code was taken and modified from the project "dataset creator" from Rony Condor. More detail in his github page.
*/

*==========================================================================
*				Dataset: ENAHO - Gini indices (2011 - 2019)
*				Source : INEI
*==========================================================================


* Folder structure

global root "G:\Mi unidad\La Rotonda Blog\Research\Criminalidad y desigualdad\03_data"

global raw	"${root}\01_raw\enaho"
global codes	"${root}\02_codes"
global cleaned	"${root}\03_cleaned"
global analysis "${root}\04_analysis"
global results	"${root}\05_results"


	
use "${cleaned}\enaho_2011_to_2019.dta", clear

*2. Store indices in dataset variables
*First option
*statsby gini = r(gini), by(dep_name): ineqdeco y

*Second option

*Regional level
forvalues yy = 2011(1)2019{

ineqdeco y if year== `yy' , by(department)
return list //note: inequality indices stored for each group

gen gini`yy' 	= 	.
lab var gini`yy' "Gini index `yy'"

levelsof department, local(levels)
foreach x of local levels {
	qui ineqdeco y if department == `x' & year == `yy' 
	replace gini`yy' = r(gini) if department == `x' & year == `yy' 
}

}

/*collapse (mean) gini*, by(department year)
sort year department
lab var year 	 "Year"
lab var gini2019 "Gini index 2019"
lab var gini2020 "Gini index 2020"
gen gini = gini2019 if year == 2019
replace gini = gini2020 if year == 2020
drop gini2019 gini2020
*/
reshape long gini, i(department) j(year)
save "${cleaned}\gini_departamental", replace


