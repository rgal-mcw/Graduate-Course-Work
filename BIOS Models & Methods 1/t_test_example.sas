*/ Input data to SAS by hand;

data age;
   input group $ age_walk;
   datalines;
ACTIVE 9
ACTIVE 9.5
ACTIVE 9.75
ACTIVE 10
ACTIVE 13
ACTIVE 9.5
CONTROL 13.25
CONTROL 11.5
CONTROL 12
CONTROL 13.5
CONTROL 11.5
;


proc ttest data=age alpha=0.05;
class group;
var age_walk;
run;


*/ Import data for paired t-test example; 
FILENAME REFFILE '/home/u62118156/paired_test_example.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.PAIR;
	GETNAMES=YES;
RUN;


*/ Run 2-sample t-test procedure;
proc ttest data=pair alpha=0.05;
class Group;
var Response;
run;


*/ Need the data formatted differently for the paired t-test;
FILENAME REFFILE '/home/u62118156/paired_test_example2.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.pair2;
	GETNAMES=YES;
RUN;

*/ Run paired t-test;
proc ttest data=pair2 alpha=0.05;
Paired Before*After;
run;


*/ Paired t-test where we define our variable as the difference;
data DIFF;
set pair2;
W = Before - After;
run;

proc ttest data=DIFF alpha=0.05;
var W;
run;





