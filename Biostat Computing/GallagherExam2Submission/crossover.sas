
data new;
    input subject group period1$ y1 period2$ y2;
/*
s  g p  y   p  y
u  r e  1   e  2
b  o r      r
j  u i      i
e  p o      o
c    d      d
t    1      2
*/
datalines;
11 1 A 1.28 B 1.33
12 1 A 1.60 B 2.21
13 1 A 2.46 B 2.43
14 1 A 1.41 B 1.81
15 1 A 1.40 B 0.85
16 1 A 1.12 B 1.20
17 1 A 0.90 B 0.90
18 1 A 2.41 B 2.79
19 2 B 3.06 A 1.38
21 2 B 2.68 A 2.10
22 2 B 2.60 A 2.32
23 2 B 1.48 A 1.30
24 2 B 2.08 A 2.34
25 2 B 2.72 A 2.48
26 2 B 1.94 A 1.11
27 2 B 3.35 A 3.23
28 2 B 1.16 A 1.25
;
run;

/* Beginning of Problem 14(A) */

data Grp1Prd1A;
    set new;
    if period1='A' then grp1prd1mean=y1;
    *if mean1A=. then delete;
run;

data Grp1Prd2B;
    set new;
    if period2='B' then grp1prd2mean=y2;
    *if mean2A=. then delete;
run;

data Grp2Prd1A;
    set new;
    if period1='B' then grp2prd1mean=y1;
    *if mean1B=. then delete;
run;

data Grp2Prd2B;
    set new;
    if period2='A' then grp2prd2mean=y2;
    *if mean2B=. then delete;
run;

data merged;
    merge Grp1Prd1A Grp1Prd2B Grp2Prd1A Grp2Prd2B;
run;

proc univariate noprint data=merged;
    VAR grp1prd1mean grp1prd2mean grp2prd1mean grp2prd2mean;
    output out=meann mean=grp1prd1mean grp1prd2mean grp2prd1mean grp2prd2mean;
run;

data meann;
    set meann;
    rename grp1prd1mean = _1A;
    rename grp1prd2mean = _1B;
    rename grp2prd1mean = _2B;
    rename grp2prd2mean = _2A;
run;

proc print data=meann;
run;

/* We get 1A = 1.5725, 1B=1.69, 2B=2.3411, 2A=1.94556 */

* End of problem 14(A) ;
    
/* START OF 14(B) */
/*
data plotting;
    input period mean labelname$ leg$;
    datalines;
        1 1.5725 1A A
        2 1.69 1B B
        1 2.3411 2B B
        2 1.94556 2A A
        ;
run;

proc print data=plotting;
run;

ods graphics on / reset imagename="&fnroot-b" imagefmt=png;

proc sgplot data=plotting NOAUTOLEGEND;
    title "Groups-by-periods plot for Patel's data";
    series x=period y=mean / group=leg lineattrs = (thickness=3 pattern = solid) datalabel=labelname;
    yaxis values=(0 to 3 by 0.5);
    xaxis values=(0.5 to 2.5 by 0.5);
run;

/* END OF 14B */

/* START OF 14C*/
/*
data panel1a;
    set new;
    if group=2 then delete;
    if period1='A' then y=y1;
run;

data panel1b;
    set new;
    if group=2 then delete;
    if period2='B' then y=y2;
run;

data panel1;
    set panel1a panel1b;
    if y1=y then period=1;
    if y2=y then period=2;
    if _n_<10 then x=1;
    if _n_>10 then x=0;
    if y=0.90 then if x=1 then period=1; *LOL;
    keep group y period subject;
run;

data panel2a;
    set new;
    if group=1 then delete;
    if period1='B' then y=y1;
run;

data panel2b;
    set new;
    if group=1 then delete;
    if period2='A' then y=y2;
run;

data panel2;
    set panel2a panel2b;
    if y1=y then period=1;
    if y2=y then period=2;
    keep group y period subject;
run;

data panel;
    set panel1 panel2;
run;

proc print data=panel;run;
    
ods graphics on / reset imagename="&fnroot-c" imagefmt=png;

proc sgpanel data=panel NOAUTOLEGEND;
    title "Figure 2.1 - Subject profiles for Patel's data";
    panelby group / onepanel columns=1;
    series x=period y=y / group=subject lineattrs=(pattern=1 color=CX000000) markers markerattrs=(symbol=X); /*Now i see how i would do this for problem 14D*/

/*
    label period='Period' y='Response';
    colaxis values=(0.5 to 2.5 by 0.5);
    rowaxis values=(0 to 4 by 0.5);
run;
    
proc print data=new; run;

/* END OF 14C */

/* Start 14D */


data diff;
    set new;
    add = y1+y2;
    diff=y1-y2;
    keep group add diff;
run;

proc sort data=diff;
    by add;
run;

ods graphics on / reset imagename="&fnroot-d" imagefmt=png;

%sganno;

data polygon;
    *%sgrectangle(x1=50,y1=50,height=1,width=1);
    *group1 polygon;
    %sgpolygon(x1=1.80, y1=0, drawspace="datavalue");
    %sgpolycont(x1=2.25, y1=0.55);
    %sgpolycont(x1=4.89, y1=.03);
    %sgpolycont(x1=5.20, y1=-0.38);
    %sgpolycont(x1=3.81, y1=-0.61);

    *group2 polygon;
    %sgpolygon(x1=2.41, y1=-0.09, drawspace="datavalue");
    %sgpolycont(x1=3.05, y1=0.83);
    %sgpolycont(x1=4.44, y1=1.68);
    %sgpolycont(x1=6.58, y1=0.12);
    %sgpolycont(x1=4.42, y1=-0.26);
run;

proc sgplot data=diff NOAUTOLEGEND sganno=polygon;
    title "Differences against totals plot for Patel's data. o=group1, +=group 2.";
    scatter x=add y=diff / group=group;
    * polygon x=add y=diff id=group --  is a possible solution;
    yaxis values=(-1 to 2 by 0.5);
    xaxis values=(1 to 7 by 1);
run;

*proc print data=diff;run;

/* END OF 14D */
