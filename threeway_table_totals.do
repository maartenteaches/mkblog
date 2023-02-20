//art Threeway table 

/*txt
The goal is to create a three-way cross-tabulation using <b>table</b>, and there
is a complication with the totals. To illustrate lets open some example data,
and prepare it:
txt*/

//ex
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
//endex

/*txt
We can create our three-way cross-tabulation with column percentages, but it 
adds an extra "panel" looking at the association between marst and collgrad 
regardless of urban: the panel labeled Total, and I don't want it.
txt*/

//ex
table (urban marst) (collgrad), stat(percent, across(marst))
//endex

/*
We can use the <b>total()</b> option to specify which totals we want, but it is a
bit finicky. We want:

<ul>
<li> the urban-specific totals for marst, i.e. urban#marst.</li> 
<li> the urban-specific totals for collgrad, i.e. urban#collgrad</li>
<li> the urban-spedific grand totals i.e. urban</li>
</ul>
txt*/

//ex
table (urban marst) (collgrad), stat(percent, across(marst)) ///
   total(urban urban#marst urban#collgrad)
//endex
//endart