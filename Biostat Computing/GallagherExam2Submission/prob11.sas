/*Ryan Gallagher
  Problem 11 on the Final Exam for BIOS04224 */

/*
  A common use of random sampling is when you have a large number
  of subjects but it would be prohibitive to utilize all of them in your
  study.  
  
  (A) Suppose there are $N$ subjects and you want to randomly sample
  $n$.  Use SAS to randomly generate $N=25000$ values from the
  standard Uniform distribution, i.e., $z~\U{0, 1}$, and sample
  $n=500$ of them.  Don't forget to set your seed so that you can
  re-generate the same random stream in the future.

  (B) Stratified random sampling divides all subjects into $M$ random
  samples such that each sample is ``balanced'' with respect to one or
  more strata.  For example, suppose that we want to draw a random
  sample from the NTDB study preserving the distribution of GCSTOT in
  each of the the $M$ samples. Create a SAS macro to perform stratified
  random sampling and provide a random number seed for reproducibility.

*/

/* Problem11 (A) */

data p11; /* This generates the values wanted */
    call streaminit(12345);
    val=RAND('Uniform'); /* Doing this makes the first observation get a value. Doesn't otherwise */
    do _n_=0 to 25000; /* First observation is '.' and idk why*/
    output;
    val=RAND('UNIForm');
    end;
run;

/* This creates a random variable to sort by then select at random */


data sampled;
    set p11;
    call streaminit(54321);
    sampling=RAND('Uniform');
run;

proc sort data=sampled out=sampled;  *Sort data (acending by default);
    by sampling;                    /*Since the 'sampling' variable is random*/
run;                                 *this ordering is random;

proc print data=sampled (obs=500);   *Only get the first 500 observations, so we sample 500;

/* End of Problem11 (A) */

/* Problem11 (B) */

%include '~/04224/exam/prob11b.sas'; *Macro exists in this path;

/* Example of using the macro to stratify by trauma center and sort by INC_KEY on NTDB using an
    arbitrary M=10. This works for any M!*/

%strat(M=10,data=ntdb.strata,out=new, seed=12345,by=INC_KEY, strata=traumactr); 

proc print data=new;                 *outputs the macro .lst, will need to scroll down;
run;

/* End of Problem11 (B) */
