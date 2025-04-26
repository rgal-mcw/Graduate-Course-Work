/* Ryan Gallagher 04224 Exam 2
    SAS Cold Decking Macro */

data toy;
    set ntdb.strata;
    keep INC_KEY hispanic male sbp pulse rr;*/
run;

/* This gives the frequency of missing values per variable. */
proc freq data=toy;
    tables hispanic male sbp pulse rr / missing;
    title 'Missing frequency to begin with';
run;

/* We have 11388 missing values for hispanic.
    1 missing value for male
    254 missing values for sbp
    263 missing values for pusle
    725 missing values for rr
*/

ods graphics on / reset imagename="&fnroot" imagefmt=png;

/* distribution for hispanic variable before */
proc sgplot data=toy;
    histogram hispanic;
run;

/* distribution for male variable before */
proc sgplot data=toy;
    histogram male;
run;

/* distribution for sbp variable before */
proc sgplot data=toy;
    histogram sbp;
run;

/* distribution for pulse variable before */
proc sgplot data=toy;
    histogram pulse;
run;

/* distribution for rr before */
proc sgplot data=toy;
    histogram rr;
run;

%macro coldDeck(data=, out=, var=, seed=); /*add var1=, var2=,...;*/

    %local k;
    %let k=%_nobs(data=&data);
    
    data temp;
        set &data;

        if _n_=1 then call streaminit(&seed);
        rand = rand("integer",1,&k);

        array variables(*) _&var; /*Fill this with the submitted variables*/
       
run;

   data temp2;
       set temp;
       /*do while(nmiss(of &var))*/
       do while(missing(&var));
           set temp point=rand; /*Itterating to replace the whole row with row x. WE NEED TO ONLY REPLACE THE ONE VARIABLE;*/
           _&var=&var; /*saving the value in this array*/
       end;
   keep _&var; /*saving the table with only the array*/
   
run;

data &out;
    merge &data temp2;
    if missing(&var) then &var=_&var; /*replacing the values, and done*/
run;
            
%mend coldDeck;

/* New idea, do the macro over all the variables */

%coldDeck(data=toy, out=new1, var=hispanic, seed=123);
%coldDeck(data=new1, out=new2, var=male, seed=123);
%coldDeck(data=new2, out=new3, var=sbp, seed=123);
%coldDeck(data=new3, out=new4, var=pulse, seed=123);
%coldDeck(data=new4, out=fin, var=RR, seed=123);

proc print data=fin; run;

proc freq data=fin;
    tables hispanic male sbp pulse rr / missing;
    title 'Missing frequency after macro';
run;

/* Running this gives should give no missing values for the variables. */
    

/* We can see the distribution stay the same after this macro by comparing the before/after graphs per variable */

/* distribution for hispanic variable after */
proc sgplot data=fin;
    histogram hispanic;
run;

/* distribution for male variable after */
proc sgplot data=fin;
    histogram male;
run;

/* distribution for sbp variable after */
proc sgplot data=fin;
    histogram sbp;
run;

/* distribution for pulse variable after*/
proc sgplot data=fin;
    histogram pulse;
run;

/* distribution for hispanic rr after */
proc sgplot data=fin;
    histogram rr;
run;


%_pdfjam;
