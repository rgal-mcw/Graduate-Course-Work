libname f '/data/shared/04224/JH/libname/f';

/*data full;
    set f.vitals_us;
    keep patient_hash bp_systolic bp_diastolic;
run;


proc sort data=full;
    by patient_hash;
run;


proc univariate noprint data=full;
    var bp_systolic bp_diastolic;
    by patient_hash;
    output out=fin median=sys dia;
run;



proc print data=fin;


ods graphics on / reset imagename="&fnroot" imagefmt=pdf;
footnote;

*/

/*
proc sgplot data=fin;
    scatter X=sys Y=dia;
run;
*/

/* End of Problem 1 */

/*
proc sgplot;
    heatmap X=sys Y=dia / colorstat=freq colormodel=(black blue green yellow);
run;
*/

/* End of Problem 2 */
options obs=100;

proc univariate noprint data=f.vitals_us;
    var measure_date;
    by patient_hash;
    output out=time min=min_date max=max_date;
run;

options obs=10;

data time;
    set time;
    label min_date=' ' max_date=' ';
    format min_date max_date date7.;
    if min_date=max_date then delete;
run;

options obs=max;

data bp;
    merge time(in=intime)
        f.vitals_us(keep=patient_hash measure_date bp_diastolic bp_systolic);
    by patient_hash;
    rename bp_diastolic=dbp bp_systolic=sbp;
    format bp:;

    retain zero 0 one 1 middle 100;

    if first.patient_hash | last.patient_hash then text=patient_hash;

    if intime;
    
    thyme =(measure_date-min_date)/(max_date-min_date);
run;

ods graphics on / reset imagename="&fnroot" imagefmt=pdf;
footnote;

proc sgpanel data=bp;
    panelby patient_hash / columns=1;
    series X=thyme Y=sbp /markers;
    series X=thyme Y=dbp /markers;
    rowaxis label='SBP and DBP';
run;

%_pdfjam;

/* End of Problem 3 */


