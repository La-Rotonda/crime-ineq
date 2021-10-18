/*****************************************************************
** 				INEQUALITY AND CRIME
**
** Author	 	:  Ronny M. Condor (ronny.condor@unmsm.edu.pe)
**
** Objective 	:  Descriptive analysis
**
** Inputs 	 	:  RENADEF and ENAHO
**
** Output	 	:  graphs and tables
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

set scheme blogrotonda

foreach var in patrimonio_st segpublica_st tranpublica_st dentotal_st {
qui summ `var', d
replace `var' = . if `var' > r(p95)
}


pwcorr gini *_st, star(0.1)

graph tw (scatter segpublica_st gini)
graph export "$graphs/scatter_gini_seg.png", as(png) replace

binscatter segpublica_st gini
graph export "$graphs/binscatter_gini_seg.png", as(png) replace

