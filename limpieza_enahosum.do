/**************************************************************
*Project	:	Crime and inequality: a departmental exploratory analysis
*Objetive	: 	Cleaning raw data for analysis 
*Author		:  	Gianella Basilio (gianella.basilio@unmsm.edu.pe)
*Inputs		:	ENAHO (2011-2019)
*Outputs	:	Cleaned datasets
*Comments	:	The code was taken and modified from the project "dataset creator" from Rony Condor. More detail in his github page.
*/
*==========================================================================
*				Dataset: ENAHO (2011-2019)
*				Source : INEI
*==========================================================================

* Folder structure

global root "G:\Mi unidad\La Rotonda Blog\Research\Criminalidad y desigualdad\03_data"

global raw	"${root}\01_raw\enaho"
global codes	"${root}\02_codes"
global cleaned	"${root}\03_cleaned"
global analysis "${root}\04_analysis"
global results	"${root}\05_results"


*1.Tempfiles with relevant variables

local key_vars ubigeo conglome vivienda hogar
local use_vars gashog1d gashog2d gru11hd gru21hd gru31hd gru41hd gru51hd gru61hd gru71hd gru81hd ingmo1hd inghog2d mieperho pobreza fac* linea* linpe 

forvalues yy = 2011(1)2019	{

use "${raw}/Modulo34//`yy'.dta", clear
	gen year=`yy'

		foreach var in `key_vars' ubigeo {
	    destring `var', force replace
		}
	sort year `key_vars'
	keep year `key_vars' `use_vars' 
	save "${raw}\tmp_`yy'.dta",	replace
}

*2. Append

clear
forvalues yy=2011(1)2019{	
	append using "${raw}/tmp_`yy'.dta"
	}


*3. Generate household-level variables

gen poor_ext = (pobreza == 1)
gen poor     = (pobreza <= 2)
gen no_poor  = (pobreza == 3)

*Based on Aragon & Rud (AEJ:EP 2013)
gen y_raw = ingmo1hd/mieperho/12 
gen y     = inghog2d/mieperho/12 
gen exp   = gashog2d/mieperho/12 

gen y_rel   =   y/linea
gen exp_rel = exp/linea

*Consumption by type	
*Type 1: food 
*Type 2: clothes
*Type 3: home rent, fuel and utilities
*Type 4: funiture and home maintenance
*Type 5: healthcare
*Type 6: transport and communication
*Type 7: leisure, education and cultural activities

egen exp_1 = rowtotal(gru11hd) 
egen exp_2 = rowtotal(gru21hd)
egen exp_3 = rowtotal(gru31hd)
egen exp_4 = rowtotal(gru41hd)
egen exp_5 = rowtotal(gru51hd)
egen exp_6 = rowtotal(gru61hd)
egen exp_7 = rowtotal(gru71hd)
drop gru* inghog* gashog*

 
*4. Variable Labels
 
label var exp_1 "expenditures on food "
label var exp_2 "expenditures on clothes"
label var exp_3 "expenditures on household maintenance and rent"
label var exp_4 "expenditures on furnishes"
label var exp_5 "expenditures on health services and goods"
label var exp_6 "expenditures on transport and comms"
label var exp_7 "expenditures on leisure"

label var poor     "Is poor"
label var poor_ext "Is extremely poor"
label var no_poor	"Is no poor"

label var linea "Linea total"
label var linpe "Linea de alimentos"

label var y_raw "Raw monetary HH income per capita (monthly, current PEN)"
label var y     "Net HH income per capita (monthly, current PEN)"
label var exp   "Total expenditures per capita (monthly, current PEN)"

label var y_rel   "HH pc income relative to poverty line"
label var exp_rel "Expenditure relative to poverty line"

label var linea "Poverty line"
label var linpe "Extreme poverty line"

order year, before(conglome)
compress

*5. Geographical Variable
tostring ubigeo, gen(district)
replace district = "0" + district if length(district) == 5
gen department   = substr(district,1,2)
gen province     = substr(district,1,4)
lab var department 	"Department"
lab var province 	"Province"
destring province, replace

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

destring department, replace
label define department 1 "AMAZONAS" 2 "ANCASH" 3 "APURIMAC" 4 "AREQUIPA" 5 "AYACUCHO" 6 "CAJAMARCA" 7 "CALLAO" ///
						8 "CUSCO" 9 "HUANCAVELICA" 10 "HUANUCO" 11 "ICA" 12 "JUNIN" 13 "LA LIBERTAD" 14 "LAMBAYEQUE" ///
						15 "LIMA" 16 "LORETO" 17 "MADRE DE DIOS" 18 "MOQUEGUA" 19 "PASCO" 20 "PIURA" 21 "PUNO" ///
						22 "SAN MARTIN" 23 "TACNA" 24 "TUMBES" 25 "UCAYALI"
label values department department
drop district

*6. Save cleaned dataset and remove temporal files

forvalues yy=2011(1)2019{
	erase "${raw}/tmp_`yy'.dta"
    }

save "${cleaned}\enaho_2011_to_2019.dta", replace

