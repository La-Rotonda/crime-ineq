/*****************************************************************
** 				ENAPRES: SPSS TO STATA FORMAT
**
** Author	 	:  Ronny M. Condor (ronny.condor@unmsm.edu.pe)
**
** Objective 	:  Import the SPSS files and save as .dta files
**
** Inputs 	 	:  ENAPRES (all years).sav
**
** Output	 	:  ENAPRES (all years).dta
**
** Comments 	:  INEI publishs the ENAPRES in SPSS format
** YEARS: 2011, 2013, 2015 - 2017

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
* CAPÍTULO 100: NÚMERO DE DENUNCIAS
*___________________________________

global key_vars   anio id_n ubigeo dep_name 
global main_vars  patrimonio segpublica tranpublica dentotal

qui forvalues yy = 2011(1)2017 {

	if `yy' <= 2011 | `yy' == 2013 {		
		tempfile renadef100_`yy'
		use "$raw_renadef\cap100\\`yy'\\`yy'.dta", clear
			rename (dn105 dn111 dn113 dn120) (patrimonio segpublica tranpublica dentotal)
			gen dep_name = upper(ustrto(ustrnormalize(nombredd, "nfd"), "ascii", 2))
			lab var dep_name "NOMBRE DE DEPARTAMENTO"
			order $key_vars $main_vars
			keep $key_vars $main_vars
		save `renadef100_`yy''
	}

	if `yy' == 2015{

		tempfile renadef100_`yy'
		use "$raw_renadef\cap100\\`yy'\\`yy'.dta", clear
			encode delito_especifico, gen(delito)
			sort id_n ubigeo delito
			keep id_n ubigeo delito
			bysort id_n ubigeo delito: gen freq = _N

			collapse (mean) freq, by(id_n ubigeo delito)

			reshape wide freq, i(id_n ubigeo) j(delito)
			egen dentotal = rowtotal(freq*)
			gen anio = `yy'

			rename (freq1 freq2 freq3) (patrimonio segpublica tranpublica) 

			gen district = ubigeo
			replace district = "0" + district if length(district) == 5
			gen department   = substr(district,1,2)
			gen province     = substr(district,1,4)

			gen     dep_name = ""
			replace dep_name = "AMAZONAS"      if department == "01"
			replace dep_name = "ANCASH"        if department == "02"
			replace dep_name = "APURIMAC"      if department == "03"
			replace dep_name = "AREQUIPA"      if department == "04"
			replace dep_name = "AYACUCHO"      if department == "05"
			replace dep_name = "CAJAMARCA"     if department == "06"
			replace dep_name = "CALLAO"        if department == "07"
			replace dep_name = "CUSCO"         if department == "08"
			replace dep_name = "HUANCAVELICA"  if department == "09"
			replace dep_name = "HUANUCO"       if department == "10"
			replace dep_name = "ICA"           if department == "11"
			replace dep_name = "JUNIN"         if department == "12"
			replace dep_name = "LA LIBERTAD"   if department == "13"
			replace dep_name = "LAMBAYEQUE"    if department == "14"
			replace dep_name = "LIMA"          if department == "15"
			replace dep_name = "LORETO"        if department == "16"
			replace dep_name = "MADRE DE DIOS" if department == "17"
			replace dep_name = "MOQUEGUA"      if department == "18"
			replace dep_name = "PASCO"         if department == "19"
			replace dep_name = "PIURA"         if department == "20"
			replace dep_name = "PUNO"          if department == "21"
			replace dep_name = "SAN MARTIN"    if department == "22"
			replace dep_name = "TACNA"         if department == "23"
			replace dep_name = "TUMBES"        if department == "24"
			replace dep_name = "UCAYALI"       if department == "25"

			drop department province district

			order anio id_n ubigeo dep_name patrimonio segpublica tranpublica dentotal
			keep  anio id_n ubigeo dep_name patrimonio segpublica tranpublica dentotal
		save `renadef100_`yy''

		
	}
	
	
	if `yy' == 2016 {		
		tempfile renadef100_`yy'
		use "$raw_renadef\cap100\\`yy'\\`yy'.dta", clear
			gen anio = `yy'
			rename (faltas_b faltas_d faltas_e faltas) (patrimonio segpublica tranpublica dentotal)
			cap rename departamento dep_name
			cap gen dep_name = upper(ustrto(ustrnormalize(nombredd, "nfd"), "ascii", 2))
			lab var dep_name "NOMBRE DE DEPARTAMENTO"
			order $key_vars $main_vars
			keep $key_vars $main_vars
		save `renadef100_`yy''
	}
	
		if `yy' == 2017 {		
		tempfile renadef100_`yy'
		use "$raw_renadef\cap100\\`yy'\\`yy'.dta", clear
			gen anio = `yy'
			rename (faltas_b faltas_d faltas_e faltas) (patrimonio segpublica tranpublica dentotal)
			destring nombredd, replace
			gen dep_name = ""
			replace dep_name = "AMAZONAS" if nombredd ==1
			replace dep_name = "ANCASH" if nombredd ==2
			replace dep_name = "APURIMAC" if nombredd ==3
			replace dep_name = "AREQUIPA" if nombredd ==4
			replace dep_name = "AYACUCHO" if nombredd ==5
			replace dep_name = "CAJAMARCA" if nombredd ==6
			replace dep_name = "CALLAO" if nombredd ==7
			replace dep_name = "CUSCO" if nombredd ==8
			replace dep_name = "HUANCAVELICA" if nombredd ==9
			replace dep_name = "HUANUCO" if nombredd ==10
			replace dep_name = "ICA" if nombredd ==11
			replace dep_name = "JUNIN" if nombredd ==12
			replace dep_name = "LA LIBERTAD" if nombredd ==13
			replace dep_name = "LAMBAYEQUE" if nombredd ==14
			replace dep_name = "LIMA" if nombredd ==15
			replace dep_name = "LIMA" if nombredd ==15.1
			replace dep_name = "LORETO" if nombredd ==16
			replace dep_name = "MADRE DE DIOS" if nombredd ==17
			replace dep_name = "MOQUEGUA" if nombredd ==18
			replace dep_name = "PASCO" if nombredd ==19
			replace dep_name = "PIURA" if nombredd ==20
			replace dep_name = "PUNO" if nombredd ==21
			replace dep_name = "SAN MARTIN" if nombredd ==22
			replace dep_name = "TACNA" if nombredd ==23
			replace dep_name = "TUMBES" if nombredd ==24
			replace dep_name = "UCAYALI" if nombredd ==25

			lab var dep_name "NOMBRE DE DEPARTAMENTO"
			order $key_vars $main_vars
			keep $key_vars $main_vars
		save `renadef100_`yy''
	}

}

clear
use `renadef100_2011'
		foreach i in 2013 2015 2016 2017{
				append using `renadef100_`i''
			}

save "$cleaned\renadefcap100.dta", replace