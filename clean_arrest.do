#delimit;

clear;

cd "/Users/nobeedee/Desktop/projects/ucr_scraper";

global CURR_PATH `c(pwd)';
global RAW_PATH = "${CURR_PATH}/raw";
global CLEANED_PATH = "${CURR_PATH}/cleaned";

capture mkdir "${CLEANED_PATH}";

/*** By State ***/
local file_list: dir "${RAW_PATH}" files "arrest_by_state_*.xlsx";

foreach file of local file_list {;
	local new_file = subinstr("`file'", ".xlsx", ".dta", 1);
	import excel "${RAW_PATH}/`file'", firstrow case(preserve) clear;
	qui count;
	if r(N)==0 {;
		continue;
	};
	drop csv_header;	// Not sure what this is for
	
	gen total = aggravated_assault + simple_assault + all_other_offenses + arson 
		+ burglary + curfew + disorderly + driving + drug_abuse_gt 
		+ drunkness + embezzlement + forgery + fraud 
		+ g_all + ht_c_s_a + ht_i_s + larceny + liquor 
		+ manslaughter + murder + mvt + offense_family 
		+ prostitution + prostitution_a_p_p + prostitution_p + prostitution_p_p 
		+ rape + robbery + sex_offense + stolen_property + suspicion 
		+ vagrancy + vandalism + weapons;
		
	order 
		state_abbr data_year total 
		aggravated_assault simple_assault all_other_offenses 
		arson burglary 
		curfew disorderly 
		driving drug_abuse_gt 
		drug_poss_m drug_poss_opium 
		drug_poss_other drug_poss_subtotal 
		drug_poss_synthetic drug_sales_m 
		drug_sales_opium drug_sales_other 
		drug_sales_subtotal drug_sales_synthetic 
		drunkness embezzlement 
		forgery fraud 
		g_all g_b g_n g_t 
		ht_c_s_a ht_i_s 
		larceny liquor 
		manslaughter murder 
		mvt offense_family 
		prostitution prostitution_a_p_p prostitution_p prostitution_p_p 
		rape robbery sex_offense 
		stolen_property suspicion 
		vagrancy vandalism weapons
	;

	la var state_abbr "State";
	la var data_year "Year";
	la var total "Total Arrests";
	la var aggravated_assault "Aggravated Assault";
	la var simple_assault "Simple Assault";
	la var all_other_offenses "All Other Offenses";
	la var arson "Arson";
	la var burglary "Burglary";
	la var curfew "Curfew";
	la var disorderly "Disorderly Conduct";
	la var driving "DUI";
	la var drug_abuse_gt "Drug Offense - Grand Total";
	la var drug_poss_m "Drug Possession - Marijuana";
	la var drug_poss_opium "Drug Possession - Opium";
	la var drug_poss_other "Drug Possession - Other";
	la var drug_poss_subtotal "Drug Possession - Subtotal";
	la var drug_poss_synthetic "Drug Possession - Synthetic";
	la var drug_sales_m "Drug Sales - Marijuana";
	la var drug_sales_opium "Drug Sales - Opium";
	la var drug_sales_other "Drug Sales - Other";
	la var drug_sales_subtotal "Drug Sales - Subtotal";
	la var drug_sales_synthetic "Drug Sales - Synthetic";
	la var drunkness "Drunkenness";
	la var embezzlement "Embezzlement";
	la var forgery "Forgery";
	la var fraud "Fraud";
	la var g_all "Gambling - All Other";
	la var g_b "Gambling - Bookmaking";
	la var g_n "Gambling - Numbers";
	la var g_t "Gambling - Total";
	la var ht_c_s_a "Human Trafficking - Commercial";
	la var ht_i_s "Human Trafficking - Servitude";
	la var larceny "Larceny";
	la var liquor "Liquor Laws";
	la var manslaughter "Manslaughter";
	la var murder "Murder";
	la var mvt "Motor Vehicle Theft";
	la var offense_family "Offense Against Family";
	la var prostitution "Prostitution";
	la var prostitution_a_p_p "Prostitution - Assisting";
	la var prostitution_p "Prostitution - Prostitution";
	la var prostitution_p_p "Prostitution - Purchasing";
	la var rape "Rape";
	la var robbery "Robbery";
	la var sex_offense "Sex Offenses";
	la var stolen_property "Stolen Property";
	la var suspicion "Suspicion";
	la var vagrancy "Vagrancy";
	la var vandalism "Vandalism";
	la var weapons "Weapons";	
	
	gsort state_abbr data_year;
	
	save "${CLEANED_PATH}/`new_file'", replace;
};


/*** By Agency ***/
local file_list: dir "${RAW_PATH}" files "arrest_by_agency_*.xlsx";

foreach file of local file_list {;
	local new_file = subinstr("`file'", ".xlsx", ".dta", 1);
	import excel "${RAW_PATH}/`file'", firstrow case(preserve) clear;
	qui count;
	if r(N)==0 {;
		continue;
	};
	drop csv_header;	// Not sure what this is for
	
	gen total = aggravated_assault + simple_assault + all_other_offenses + arson 
		+ burglary + curfew + disorderly + driving + drug_abuse_gt 
		+ drunkness + embezzlement + forgery + fraud 
		+ g_all + ht_c_s_a + ht_i_s + larceny + liquor 
		+ manslaughter + murder + mvt + offense_family 
		+ prostitution + prostitution_a_p_p + prostitution_p + prostitution_p_p 
		+ rape + robbery + sex_offense + stolen_property + suspicion 
		+ vagrancy + vandalism + weapons;
		
	order 
		ori data_year total 
		aggravated_assault simple_assault all_other_offenses 
		arson burglary 
		curfew disorderly 
		driving drug_abuse_gt 
		drug_poss_m drug_poss_opium 
		drug_poss_other drug_poss_subtotal 
		drug_poss_synthetic drug_sales_m 
		drug_sales_opium drug_sales_other 
		drug_sales_subtotal drug_sales_synthetic 
		drunkness embezzlement 
		forgery fraud 
		g_all g_b g_n g_t 
		ht_c_s_a ht_i_s 
		larceny liquor 
		manslaughter murder 
		mvt offense_family 
		prostitution prostitution_a_p_p prostitution_p prostitution_p_p 
		rape robbery sex_offense 
		stolen_property suspicion 
		vagrancy vandalism weapons
	;

	la var ori "UCR Agency ORI";
	la var data_year "Year";
	la var total "Total Arrests";
	la var aggravated_assault "Aggravated Assault";
	la var simple_assault "Simple Assault";
	la var all_other_offenses "All Other Offenses";
	la var arson "Arson";
	la var burglary "Burglary";
	la var curfew "Curfew";
	la var disorderly "Disorderly Conduct";
	la var driving "DUI";
	la var drug_abuse_gt "Drug Offense - Grand Total";
	la var drug_poss_m "Drug Possession - Marijuana";
	la var drug_poss_opium "Drug Possession - Opium";
	la var drug_poss_other "Drug Possession - Other";
	la var drug_poss_subtotal "Drug Possession - Subtotal";
	la var drug_poss_synthetic "Drug Possession - Synthetic";
	la var drug_sales_m "Drug Sales - Marijuana";
	la var drug_sales_opium "Drug Sales - Opium";
	la var drug_sales_other "Drug Sales - Other";
	la var drug_sales_subtotal "Drug Sales - Subtotal";
	la var drug_sales_synthetic "Drug Sales - Synthetic";
	la var drunkness "Drunkenness";
	la var embezzlement "Embezzlement";
	la var forgery "Forgery";
	la var fraud "Fraud";
	la var g_all "Gambling - All Other";
	la var g_b "Gambling - Bookmaking";
	la var g_n "Gambling - Numbers";
	la var g_t "Gambling - Total";
	la var ht_c_s_a "Human Trafficking - Commercial";
	la var ht_i_s "Human Trafficking - Servitude";
	la var larceny "Larceny";
	la var liquor "Liquor Laws";
	la var manslaughter "Manslaughter";
	la var murder "Murder";
	la var mvt "Motor Vehicle Theft";
	la var offense_family "Offense Against Family";
	la var prostitution "Prostitution";
	la var prostitution_a_p_p "Prostitution - Assisting";
	la var prostitution_p "Prostitution - Prostitution";
	la var prostitution_p_p "Prostitution - Purchasing";
	la var rape "Rape";
	la var robbery "Robbery";
	la var sex_offense "Sex Offenses";
	la var stolen_property "Stolen Property";
	la var suspicion "Suspicion";
	la var vagrancy "Vagrancy";
	la var vandalism "Vandalism";
	la var weapons "Weapons";	
	
	gsort ori data_year;
	
	save "${CLEANED_PATH}/`new_file'", replace;
};

