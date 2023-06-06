clear // empty working space
version 11 // version control
set more off // tells Stata not to pause or display the --more-- message
set cformat %5.3f // specifies the output format of coeff., s.e.,... in tables
capture log close // close any open log-file
set scheme s1mono // set scheme for graphs

/******************************************************************************

	Empirical Evidence of the FED Put - Multiple linear regression models

	Author: Felix Reichel
	
******************************************************************************/

// Set working directory 
cd "/Users/felixreichel/Documents/UNI/WIWI_Bachelor/2023S/SE Bachelorarbeit/Git"

cap mkdir stata_fed_put // generate a sub-folder "stata"


// Open log file
log using "stata_fed_put/stata_fed_put", replace

// Load FOMC cycle dummies .csv
import delimited "data/dates_is_in_even_fomc_week_dummies.csv", clear
// Order master data by date
sort date
// save .dta
save d:fomc_data, replace

// Load SP500 data .csv
import delimited "data/sp500_df.csv", clear
// Order data by date
sort date
// save .dta
save d:sp500_data, replace

// Merge 1:1 Using date
merge date using d:fomc_data d:sp500_data
// Save new merged data .dta
save d:fed_put_datamerged_data, replace

// Generate date2
gen date2 = date(date, "YMD")
format date2 %ymd


// Drop rows with missing S&P500 values (holidays, weekends)
drop if missing(sp500_y)

// MLR with 7 binary dummies for the fomc cycle time
reg sp500_y w_t0 w_t1 w_t2 w_t3 w_t4 w_t5 w_t6
// R^2 of only 1,18%.




cap log close
clear
