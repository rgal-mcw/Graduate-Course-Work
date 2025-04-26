/* Ryan Gallagher
   BIOS-04232 HW1
   SAS Portion
*/

/* ----Q1----- */
proc import datafile="~/04232/air.csv" out=air
   dbms=csv
   replace;
   getnames=yes;
run;

/* Here, we find that the coefficients are the same under the Standard table in the .lst file. 
proc glm data=air;
    model CPM=UTL ASL SPA ALF;
run;
*/
/* ---Q3--- */

/*     H0:    */
title 'H0 Q3';
proc glm data=air;
    model CPM=UTL SPA ALF;
run;

/*     H1:    */
title 'H1 Q3';
proc glm data=air;
    model CPM=UTL ASL SPA ALF;
run;

/* Proc Reg Test to confirm p_value */
title "Q3 proc reg";
proc reg data=air;
    model CPM = UTL ASL SPA ALF;
    test ASL=0;
run;

/* ---Q4 --- */

/*   H0:     */
title 'H0 Q4';
proc glm data=air;
    model CPM = UTL;
run;

/*   H1:     */
title 'H1 Q4';
proc glm data=air;
    model CPM = UTL ASL SPA;
run;

title "Q4 proc reg";
proc reg data=air;
    model CPM = UTL ASL SPA;
    test ASL = SPA = 0;
run;

/* ---- Q5 ---- */
title "Q5";
proc reg data=air;
    model CPM = UTL ASL SPA ALF / covb;
    test SPA = ALF;
run;

/* ---- Q6 ---- */
data q6;
    set air;
    ALFm2SPA = ALF - (2*SPA);
    CPMpSPA = CPM + (17*SPA);
run;

title "Q6 - test";
proc reg data=q6;
    model CPM = UTL ASL SPA ALF;
    test SPA + 2*ALF = -17;
run;
        
    
