/* Project: 12 Lead Association Study Addition Analysis
   Also an analysis for BIOS 04222 Consulting
   PI: Dr. Tom Aufderheide & Chris Naas
   PhD: Dr. Szabo
   DA: Ryan Gallagher

   See instructions for more details on this work
*/

%include 'dangast.sas';
%include 'ODSmemo.sas';

/* Import dataset from Excel sheet */
proc import datafile='Spreadsheet for Biostats 060323.xlsx'
    OUT =dn
    DBMS=xlsx
    REPLACE;
    GETNAMES=YES;

    ;
run;

proc format;
    value $ d_rank
        "No" = "No"
        "Yes Decreased" = "Yes Decreased"
        "Yes Increased" = "Yes Increased"
        ;
run;


/* Clean up Excel formatting garbage */
data dn;
    set dn;

    rename VAR6 = If_Yes_Define_Evo;
    rename Change_in_ECG_Classification_ = Change_in_ECG_Classification;
    rename Prehospital_epinephrine_push_dos = Prehospital_epinephrine_dose;
    rename Time_between_prehospital_and_ED = Time_btwn_prehosp_ED_ECG;
    drop AC AD AE VAR32;

    /* Random Obs with no entries from import - removed */
    if (missing(Prehospital_STEMI) | missing(Change_in_ECG_Classification_)) then mi=1;
    if missing(mi);

    if Time_from_ROSC_to_prehospital_EC='N/A' then Time_from_ROSC_to_prehospital_EC=.;
    Time_from_ROSC_to_ECG = input(Time_from_ROSC_to_prehospital_EC, best9.);

    if Duration_of_prehospital_CPR_prio = "N/A" then Duration_of_prehospital_CPR_prio=.;
    Duration_of_prehospital_CPR = input(Duration_of_prehospital_CPR_prio, best9.);

    ROSC = input(Time_from_ROSC_to_prehospital_EC, best3.);
run;

data dn;
    set dn;
    format Change_in_ECG_Classification d_rank.;
run;

proc contents;


*proc contents varnum;
*proc print data=dn(obs=5);

/* YAMGAST for descriptive stats - WHAT GROUPING VARIABLE?*/
/*
   Is it a new YAMGAST for each assessment? -YES
   Can I get Wilcoxon FOR Y/N RESPONSES?? YES - SEE BELOW
   Ordfreq - NEED TO SET LEVELS VIA A FORMAT (ITS ALPHABETICAL IN NO, YES DECREASE, YES INCREASE
   
   For meanSD - reduce decimal points (assign format before running)
*/


/*   
%yamgast(
    dat=dn, grp=Prehospital_Ischemic,
    vlist = Prehospital_STEMI\freq\
    Prehospital_Ischemic\freq\
    Prehospital_Non_Ischemic\freq\
    Change_in_ECG_Classification\freq\
    Age\medR meanSD\
    Gender\freq\
    Witnessed_status\freq\
    Bystander_CPR\freq\
    Initial_cardiac_arrest_rhythm\freq\
    Prehospital_defibrillations\medR\
    ED_defibrillations\medR\
    Total_defibrillations\medR\
    Prehospital_epinephrine_dose\medR\
    ED_epinephrine_push_dose\medR\
    Total_epinephrine_push_dose\medR\
    Epinephrine_infusion\freq\
    Prehospital_norepinephrine\freq\
    ED_norepinephrine\freq\
    Any_norepinephrine\freq\
    Dopamine_infusion\freq\
    Prehospital_rearrests\medR\
    ED_rearrests\medR\
    Total_rearrests\medR\
    Time_from_ROSC_to_ECG\medR\
    Time_btwn_prehosp_ED_ECG\medR\
    Duration_of_prehospital_CPR\medR\,

    pct=col, total=yes, test=yes, ncont=yes, missing=no,
    style=journal, title="Aufderheide Project Table", ps=600, w1=4cm,
    w2=3cm, w3=3cm, file = stats.rtf
);
*/


/* Assessment 1 - Total Column?*/

data a1;
    set dn;

    if Prehospital_STEMI = 'Y' & (Change_in_ECG_Classification = 'No' |
        Change_in_ECG_Classification='Yes Decreased');
    
run;

%yamgast(
    dat=a1, grp=Change_in_ECG_Classification,

    vlist=ROSC\medR\
            Duration_of_Prehospital_CPR\medR\,

    pct=col, total=yes, test=yes, ncont=yes, missing=yes,
    style=journal, title="Comparison in ECG Classification for Prehospital STEMI Patients (2-way)",
    ps=600, w1=4cm, w2=3cm, w3=3cm, file=a1.rtf
);

/*
   Assessment 2 - Total column?
*/

data a2;
    set dn;

    if Prehospital_Ischemic  = 'Y';
run;

%yamgast(
    dat=a2, grp=Change_in_ECG_Classification,

    vlist=ROSC\medR\
            Duration_of_Prehospital_CPR\medR\,

    pct=col, total=yes, test=yes, ncont=yes, missing=yes,
    style=journal, title="Comparison in ECG Classification for Prehospital Ischemic Patients (3-way)",
    ps=600, w1=4cm, w2=3cm, w3=3cm, file=a2.rtf
);

/* Assessment 3 - Total columns? */

data a3;
    set dn;
    if Prehospital_non_ischemic = "Y" & (Change_in_ECG_Classification='No' |
        Change_in_ECG_Classification = 'Yes Increased');
run;

%yamgast(
    dat=a3, grp=Change_in_ECG_Classification,

    vlist=ROSC\medR\
          Duration_of_Prehospital_CPR\medR\,

    pct=col, total=yes, test=yes, ncont=yes, missing=yes,
    style=journal, title="Comparison in ECG Classification for Prehospital Non-Ischemic Patients (2-way)",
    ps=600, w1=4cm, w2=3cm, w3=3cm, file=a3.rtf
);

/* Make memo (for fun) */

%StartMemo(
    To = "Aniko Szabo",
    Department = "IHE, Division of Biostatistics",
    PreparedBy = "Ryan Gallagher",
    Re = "Assessments 1-3 for Aufderheide Project",
    HeaderInfo = header_info.txt,
    HeaderLogo = mcw_logo.png,
    RTFFile=~/04222/Project1-Aufderheide/tables
);

%AddSection(
    Header = "Methods",
    Text = "All tables were generated using the dangast macro. Each table is made for each assessment specified in the sent document.
    Some questions: Should I include the 'Total' column in these tables? Should I edit any of the variable names in the .rtf? Or should I leave that to the PI?");

%yamgast(
    dat=a1, grp=Change_in_ECG_Classification,

    vlist=ROSC\medR\
            Duration_of_Prehospital_CPR\medR\,

    pct=col, total=yes, test=yes, ncont=yes, missing=yes,
    style=journal, title="Comparison in ECG Classification for Prehospital STEMI Patients (2-way)",
    ps=600, w1=4cm, w2=3cm, w3=3cm, file=a1.rtf
);

%yamgast(
    dat=a2, grp=Change_in_ECG_Classification,

    vlist=ROSC\medR\
            Duration_of_Prehospital_CPR\medR\,

    pct=col, total=yes, test=yes, ncont=yes, missing=yes,
    style=journal, title="Comparison in ECG Classification for Prehospital Ischemic Patients (3-way)",
    ps=600, w1=4cm, w2=3cm, w3=3cm, file=a2.rtf
);

%yamgast(
    dat=a3, grp=Change_in_ECG_Classification,

    vlist=ROSC\medR\
          Duration_of_Prehospital_CPR\medR\,

    pct=col, total=yes, test=yes, ncont=yes, missing=yes,
    style=journal, title="Comparison in ECG Classification for Prehospital Non-Ischemic Patients (2-way)",
    ps=600, w1=4cm, w2=3cm, w3=3cm, file=a3.rtf
);

%CLOSEMEMO;

/*
    TTEST? Is the data normally distributed? CLT?

    What else?: WILCOXON RANK SUM (don't need to check normality)
                (Time to event variables are skewed / censored)

    3 way comparison - Kruskal Wallis

    proc npar1way - for these


    FOREST PLOTS: Do in SAS. proc SGPLOT.
    Need dataset with name, Odds ratio, & CI -> get from proc logisitic (use macro! - many variables)
*/

/* Get descriptive stats through %Yamgast() (nonparametic - get median) */



  



  
