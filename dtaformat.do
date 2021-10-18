/*****************************************************************
** 				ENAPRES: SPSS TO STATA FORMAT
**
** Author	 	:  Ronny M. Condor (ronny.condor@unmsm.edu.pe)
**
** Objective 	:  Import the SPSS files and save as .dta files
**
** Inputs 	 	:  RENADEF (all years).sav
**
** Output	 	:  RENADEF (all years).dta
**
** Comments 	:  INEI publishs the RENADEF in SPSS format

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

/*-----------------------------------------------------------------------------
								IMPORT SPSS FILES	
------------------------------------------------------------------------------*/

*___________________________________
* CHAPTER 100: NUMBER OF DENUNCIAS
*___________________________________



forvalues yy = 2011(1)2017 {

	if `yy' == 2012 {
		di "RENADEF is not available in `yy'"
	}

	if `yy' == 2011 | `yy' >= 2013{
		import spss using "$raw_renadef\cap100\\`yy'\\`yy'.sav", case(lower) clear

		save "$raw_renadef\cap100\\`yy'\\`yy'.dta", replace
	}

}
