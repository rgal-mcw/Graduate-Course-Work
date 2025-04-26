
/*
libname tiger '.';
libname library '../JH/library';

proc mapimport
    datafile='/data/shared/04224/tiger/tl_2022_us_zcta520.shp'
    out=zcta_map;
    id zcta5ce20;
run;

proc contents varnum;
run;

data zcta_map;
    set zcta_map(rename=(x=long y=lat zcta5ce20=zcta));
    length zip3 $ 3 postal $ 2;
    zip3=substr(zcta, 1, 3);
    numzip3=input(zip3, 3.);
    postal=put(zip3, $zip3post2.);
    
    if postal in(
        'AL', 'AR', 'AZ', 'CA', 'CO', 'CT', 'DC', 'DE', 'FL', 'GA',
        'IA', 'ID', 'IL', 'IN', 'KS', 'KY', 'LA', 'MA', 'MD', 'ME',
        'MI', 'MN', 'MO', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ',
        'NM', 'NV', 'NY', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD',
        'TN', 'TX', 'UT', 'VA', 'VT', 'WA', 'WI', 'WV', 'WY');
run;

/* Above is the info. Below is the 'projection' */

/*
proc gproject eastlong latlong degrees
    data=zcta_map out=zcta_map;
    id zcta;
run;

/* But, these maps are 5 digit zip codes, we want them on the 3 digit level. thats below */

/*
proc gremove data=zcta_map out=tiger.zip3;
    by zip3;
    id zcta;
run;

footnote;

proc gmap data=zcta_map map=zcta_map all; 
    where postal in('IA', 'IN', 'IL', 'MI', 'MN', 'WI');
    id zcta; 
    choro zip3 / coutline=gray cdefault=cxF5F5DC nolegend; 
run;

goptions gsfmode=append;

proc gmap data=tiger.zip3 map=tiger.zip3 all; 
    where postal in('IA', 'IN', 'IL', 'MI', 'MN', 'WI');
    id zip3; 
    choro zip3 / coutline=gray cdefault=cxF5F5DC nolegend; 
run;


/* Hands on Assignment */

/* This is a map of the midwest and shown are the zip3 areas */
/* We want to label this map using the zip3. This is done by taking the coordinates average (X,Y) per */
/* Each zip, then placing the label in the space. That will have it centered. */



proc freq data=f.us;
    where postal in('IL', 'IN', 'MI', 'MN');
    tables postal;
    tables zip3 / noprint out=zip3;
run;

data zip3;
    set zip3;
    log10ceil=ceil(log10(count));
run;

proc freq data=zip3;
    tables log10ceil;
run;

proc univariate noprint data=tiger.zip3(where=(postal in('IL','IN','MI','MN')));
    var X Y;
    by zip3;
    output out=xy mean=X Y;
run;

/*
data zip3;
    merge zip3 xy;
    by zip3;
    rename X = mean_X;
    rename Y = mean_Y;
run;
*/
proc print data=xy;


footnote;

ods graphics on / reset imagename="&fnroot" imagefmt=png;


proc sgmap
    mapdata=tiger.zip3(where=(postal in('IL', 'IN', 'MI', 'MN')) drop=long lat)
    maprespdata=zip3 plotdata=xy;
    choromap log10ceil / id=zip3 mapid=zip3 discrete;
    TEXT X=X Y=Y TEXT=zip3;
run;
quit;

proc sgmap
    mapdata=tiger.zip3(where=(postal in('IL', 'IN', 'MI', 'MN')) drop=long lat)
    maprespdata=zip3 plotdata=xy;
    choromap count / id=zip3 mapid=zip3;
    TEXT X=X Y=Y TEXT=zip3;
run;
quit;

