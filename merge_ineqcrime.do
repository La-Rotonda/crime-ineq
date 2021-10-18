/*****************************************************************
** 				INEQUALITY AND CRIME
**
** Author	 	:  Ronny M. Condor (ronny.condor@unmsm.edu.pe)
**
** Objective 	:  Merge enaho and renadef datasets at departmental level
**
** Inputs 	 	:  RENADEF and ENAHO
**
** Output	 	:  ineqcrime.dta
**
** Comments 	:  

******************************************************************/

*Folder structure
global root 		"G:\Mi unidad\La Rotonda Blog\Research\Criminalidad y desigualdad\03_data"	
global raw			"${root}\01_raw"
global raw_renadef	"${raw}\renadef"
global raw_enaho	"${enaho}\enaho"

global codes		"${root}\02_codes"
global cleaned		"${root}\03_cleaned"
global analysis 	"${root}\04_analysis"
global tables 		"${analysis}\01_tables"
global graphs		"${analysis}\02_graphs"
global results		"${root}\05_results"

*RENADEF
tempfile renadef100
use  "$cleaned\renadefcap100.dta", clear
collapse (sum) patrimonio segpublica tranpublica dentotal, by(anio dep_name)
save `renadef100'


*ENAHO
use "$cleaned\gini_departamental", clear
reshape long gini, i(department) j(anio)
sort anio department
decode department, gen(dep_name)

*MERGE
merge 1:1 anio dep_name using `renadef100', keep(3) nogen
order anio department dep_name

*NORMALIZATION MIN MAX
foreach var in patrimonio segpublica tranpublica dentotal {
	qui sum `var', d
	gen `var'_st = (`var' - r(min))/(r(max) - r(min))
	lab var `var'_st "`var' min-max standarized"
}

save "$cleaned\ineqcrime.dta", replace






