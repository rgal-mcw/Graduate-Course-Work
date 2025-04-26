/* Ryan Gallagher
    Problem 15 for BIOS04224 Exam2 */
proc sort data=f.us out=sorting;
    by zip3;
run;


proc freq data=f.us; *Gives amount of subjects with adi_narank as COUNT; 
    where postal in('IL', 'MI', 'MN');
    tables postal;
    tables zip3 / noprint out=zip3;
run;


*Gives SD of adi_narank per zip code (lines 14-24);
proc univariate noprint data=sorting(where=(postal in('IL', 'MI', 'MN')));
    VAR adi_narank;
    by zip3;
    output out=adi STD=adi_narank;
    run;

data glerp; 
    set adi;
    rename adi_narank=adiSD;
run;

data zip3;
    merge zip3 glerp;
    by zip3;
run;

* Get center location of zipcode;
proc univariate noprint data=tiger.zip3(where=(postal in('IL','MI','MN')));
    var X Y;
    by zip3;
    output out=xy mean=X Y;
run;

*Here, I didnt rename the adi_narank to SD, but the values are still SDs from the adi dataset;
data xy;
    merge xy adi;
    by zip3;
    adi_narank=round(adi_narank);
    if adi_narank=. then delete;
run;

proc print data=zip3;run;

ods graphics on / reset imagename="&fnroot" imagefmt=png;
title "Standard Deviation of Subject's ADI by ZIP3, rounded down for map clairity";
proc sgmap NOAUTOLEGEND
    mapdata=tiger.zip3(where=(postal in('IL', 'MI', 'MN')) drop=long lat)
    maprespdata=zip3 plotdata=xy;
    /*gradlegend 'sd' / title="Standard Deviation of ADI";*/
    choromap adiSD  /  id=zip3  mapid=zip3 name='sd' colormodel=(white);
    TEXT X=X Y=Y TEXT=adi_narank;
run;
quit;
    
/* NOTE:
    I don't think a gradient is necessary/gives any meaningful information when the question is simply to show the
    standard deviation per zip3 - especially when we're showing that they're ALL NOT GOOD, and that there's a wide
    variability of ADI at the ZIP3 level.

    I have left the code in for a gradiant, however, but you'd need to change options
    to colormodel=(white gray red) or other color and uncommont the gradlegend statement.

*/

/*   END OF PROBLEM 15(A)    */

/*   START OF PROBLEM 15(B)  */

/*
proc univariate noprint data=sorting(where=(postal in('IL', 'MI', 'MN')));
    VAR secondary_ruca_code_2010;
    by zip3;
    output out=RUCA STD=secondary_ruca_code_2010;
    run;

data blerp; 
    set RUCA;
    rename secondary_ruca_code_2010=rucaSD;
run;

data zip3_2;
    merge zip3 blerp;
    by zip3;
    keep zip3 count percent rucaSD;
run;

data xy_2;
    merge xy blerp;
    by zip3;
    if rucaSD=. then delete;
    keep zip3 X Y rucaSD;
    p=10**2;
    rucaSD=int(rucaSD*p)/p;
run;

proc print data=xy_2; run;


ods graphics on / reset imagename="&fnroot-2" imagefmt=png;
title "Standard Deviation of Subject's RUCA by ZIP3, Truncated to the second decimal for clairity";
proc sgmap NOAUTOLEGEND
    mapdata=tiger.zip3(where=(postal in('IL', 'MI', 'MN')) drop=long lat)
    maprespdata=zip3_2 plotdata=xy_2;
    gradlegend 'sd' / title="Standard Deviation of RUCA value";
    choromap rucaSD  /  id=zip3  mapid=zip3 name='sd';
    TEXT X=X Y=Y TEXT=rucaSD;
run;
quit;


/* For this question, a gradiant was helpful to see the scale of standard deviation for the RUCA per zip3.
    We can see in this map that many zip3 that are cities (Minneapolis, Chicago, Detroit) dont have very
    diverse RUCA values per patient, and rural areas also don't have very diverse RUCA values. The counties that do
    have diverse RUCA values likely contain a mid-sized city with a lot of agriculute around it, I think of my home
    county (DANE COUNTY) where we have madison but it's surrounded by small farming communities.
*/
