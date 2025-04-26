/* Ryan Gallagher
   Macro for problem 11(B) on exam 2 of BIOS04224 */

%macro strat(M=, data=, out=, seed=, by=, strata=);

proc sort data=&data out=&out;
    by &strata;
run;


data &out;
    set &out;
    array x(&M) x1-x&M;
    seed=&seed;
    lemod = mod(_N_-1,&M);
    retain x1-x&M;
    keep &by &strata lemod;
    if lemod = 0 then do;
        call ranperm(seed, of x1-x&M);
        end;
run;

proc sort data=&out out=&out;
    by &by;
run;
%mend strat;


/* Example of using the macro to stratify by trauma center and sort by INC_KEY on NTDB using an
    arbitrary M=10. This works for any M!*/

%strat(M=10,data=ntdb.strata,out=new, seed=12345,by=INC_KEY, strata=traumactr); 

proc print data=new;
run;
