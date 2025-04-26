/*
   Ryan Gallagher
   04/17/2023
   MM2 HW7
*/

data grip;
   input subject x trt Gender $ time t y;
   datalines;
26  175  1  M  1  1  161
26  175  1  M  2  2  210
26  175  1  M  3  3  230
27  165  1  M  1  1  215
27  165  1  M  2  2  245
27  165  1  M  3  3  265
29  175  1  M  1  1  134
29  175  1  M  2  2  215
29  175  1  M  3  3  139
34  178  1  M  1  1  165
34  178  1  M  2  2  140
34  178  1  M  3  3  175
35  220  1  M  1  1  220
35  220  1  M  2  2  189
35  220  1  M  3  3  158
38   90  1  M  1  1  146
38   90  1  M  2  2  140
38   90  1  M  3  3  130
42  300  1  M  1  1  300
42  300  1  M  2  2  300
42  300  1  M  3  3  300
44  238  1  M  1  1  278
44  238  1  M  2  2  170
44  238  1  M  3  3  158
54  200  1  M  1  1  230
54  200  1  M  2  2  220
54  200  1  M  3  3  240
57  130  1  M  1  1  155
57  130  1  M  2  2  170
57  130  1  M  3  3  125
74  215  1  M  1  1  230
74  215  1  M  2  2  243
74  215  1  M  3  3  245
76  207  1  M  1  1  220
76  207  1  M  2  2  .
76  207  1  M  3  3  .
79  225  1  M  1  1  220
79  225  1  M  2  2  250
79  225  1  M  3  3  235
1  120  2  M  1  1  130
1  120  2  M  2  2  150
1  120  2  M  3  3  120
25  300  2  M  1  1  300
25  300  2  M  2  2  300
25  300  2  M  3  3  300
28  179  2  M  1  1  232
28  179  2  M  2  2  285
28  179  2  M  3  3  .
31  209  2  M  1  1  260
31  209  2  M  2  2  200
31  209  2  M  3  3  125
36  200  2  M  1  1  200
36  200  2  M  2  2  200
36  200  2  M  3  3  232
39  300  2  M  1  1  300
39  300  2  M  2  2  300
39  300  2  M  3  3  300
41  200  2  M  1  1  245
41  200  2  M  2  2  290
41  200  2  M  3  3  280
43  172  2  M  1  1  170
43  172  2  M  2  2  170
43  172  2  M  3  3  146
45  158  2  M  1  1  140
45  158  2  M  2  2  152
45  158  2  M  3  3  150
47  150  2  M  1  1  220
47  150  2  M  2  2  168
47  150  2  M  3  3  139
53  135  2  M  1  1  155
53  135  2  M  2  2  215
53  135  2  M  3  3  170
56   75  2  M  1  1  170
56   75  2  M  2  2  220
56   75  2  M  3  3  240
58  150  2  M  1  1  200
58  150  2  M  2  2  185
58  150  2  M  3  3  163
61  155  2  M  1  1  101
61  155  2  M  2  2   93
61  155  2  M  3  3  120
73  190  2  M  1  1  240
73  190  2  M  2  2  210
73  190  2  M  3  3  173
75  265  2  M  1  1  275
75  265  2  M  2  2  255
75  265  2  M  3  3  270
2   80  1  F  1  1   80
2   80  1  F  2  2   86
2   80  1  F  3  3   80
4   64  1  F  1  1   80
4   64  1  F  2  2   80
4   64  1  F  3  3   70
5   40  1  F  1  1   60
5   40  1  F  2  2  .
5   40  1  F  3  3  .
8   40  1  F  1  1   50
8   40  1  F  2  2   30
8   40  1  F  3  3   40
9   70  1  F  1  1   90
9   70  1  F  2  2  110
9   70  1  F  3  3   90
15   70  1  F  1  1   80
15   70  1  F  2  2   95
15   70  1  F  3  3  110
18   70  1  F  1  1   80
18   70  1  F  2  2   86
18   70  1  F  3  3  .
19   70  1  F  1  1   60
19   70  1  F  2  2   70
19   70  1  F  3  3   80
21   50  1  F  1  1   80
21   50  1  F  2  2   90
21   50  1  F  3  3   90
24   40  1  F  1  1   60
24   40  1  F  2  2   60
24   40  1  F  3  3   65
40  140  1  F  1  1  156
40  140  1  F  2  2  140
40  140  1  F  3  3  150
46  110  1  F  1  1   82
46  110  1  F  2  2   98
46  110  1  F  3  3  110
48  180  1  F  1  1  165
48  180  1  F  2  2  150
48  180  1  F  3  3  160
50  155  1  F  1  1  150
50  155  1  F  2  2  170
50  155  1  F  3  3  185
52   55  1  F  1  1  105
52   55  1  F  2  2   70
52   55  1  F  3  3   88
59   95  1  F  1  1   90
59   95  1  F  2  2   90
59   95  1  F  3  3  116
63   90  1  F  1  1  135
63   90  1  F  2  2   95
63   90  1  F  3  3  .
64  145  1  F  1  1  140
64  145  1  F  2  2  164
64  145  1  F  3  3  .
70   34  1  F  1  1   51
70   34  1  F  2  2   87
70   34  1  F  3  3  .
3   60  2  F  1  1   80
3   60  2  F  2  2   60
3   60  2  F  3  3   60
6   50  2  F  1  1   70
6   50  2  F  2  2   70
6   50  2  F  3  3   70
7   80  2  F  1  1   75
7   80  2  F  2  2   90
7   80  2  F  3  3   90
10   80  2  F  1  1  100
10   80  2  F  2  2   80
10   80  2  F  3  3   90
13   80  2  F  1  1   60
13   80  2  F  2  2   65
13   80  2  F  3  3   70
17   58  2  F  1  1   50
17   58  2  F  2  2   80
17   58  2  F  3  3   80
20   60  2  F  1  1   60
20   60  2  F  2  2   80
20   60  2  F  3  3   60
22   80  2  F  1  1   90
22   80  2  F  2  2  120
22   80  2  F  3  3  130
23   60  2  F  1  1   90
23   60  2  F  2  2   94
23   60  2  F  3  3  100
30   75  2  F  1  1  131
30   75  2  F  2  2   95
30   75  2  F  3  3  105
37  150  2  F  1  1  108
37  150  2  F  2  2  160
37  150  2  F  3  3  160
49   55  2  F  1  1   60
49   55  2  F  2  2   65
49   55  2  F  3  3   55
51  130  2  F  1  1  130
51  130  2  F  2  2  160
51  130  2  F  3  3  125
55  115  2  F  1  1   95
55  115  2  F  2  2  105
55  115  2  F  3  3  110
62  135  2  F  1  1  120
62  135  2  F  2  2  144
62  135  2  F  3  3  135
65   60  2  F  1  1   85
65   60  2  F  2  2   85
65   60  2  F  3  3  .
67   40  2  F  1  1   45
67   40  2  F  2  2   76
67   40  2  F  3  3   75
71  104  2  F  1  1  107
71  104  2  F  2  2  .
71  104  2  F  3  3  .
72   60  2  F  1  1   60
72   60  2  F  2  2   55
72   60  2  F  3  3   58
;
run;

/* I think we can use both glimmix and mix */
proc glimmix data=grip;
    class trt gender time;
    model y=trt gender time x / solution ddfm=kr;
    random _residual_ / subject=subject type=un vcorr;
run;

proc mixed data=grip;
  class trt gender time;
  model y = trt gender time x / ddfm=kr solution residual outp=residuals;
  repeated time / type=un subject=subject;
run;

/* 2) Test for interaction btwen time and other 3 */

proc mixed data=grip;
    class trt gender time;
    model y=trt|time gender|time x|time / solution ;
    repeated time / type=un subject=subject;
run;

/* 3) & 4) Plot boxplot of gender residuals */
proc print data=residuals;
run;

ods graphics on;
proc sgplot data=residuals;
    vbox resid / category=gender;
run;
ods graphics off;

data grip2;
    set grip;
    y_prime = log(y);
run;

proc mixed data=grip2;
  class trt gender time;
  model y_prime = trt gender time x / ddfm=kr solution residual outp=residuals2;
  repeated time / type=un subject=subject;
run;

ods graphics on;
proc sgplot data=residuals2;
    vbox resid / category=gender;
run;
ods graphics off;

/* (5) Test if time=1 and time=2 are equal */
title 'p5';
proc mixed data=grip2;
    class trt gender time;
    model y_prime = trt gender time x / ddfm=kr solution;
    repeated time / type=un subject=subject;
    lsmeans time / diff cl;
run;
