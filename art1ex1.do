sysuse nlsw88, clear

gen byte marst = !never_married + married if !missing(never_married)
label variable marst "marital status"
label define marst 0 "never married"    ///
                   1 "widowed/divorced" ///
                   2 "married"
label value marst marst

gen byte urban = c_city + smsa
label define urban 2 "central city" ///
                   1 "suburban"     ///
                   0 "rural"
label value urban urban
label variable urban "urbanicity"
