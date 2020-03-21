SAS Forum: Locating breakpoints for dogleg mutiple regression lines

Daily rice production in tons for the first hundred days of summer

github
https://tinyurl.com/wz4pdoa
https://github.com/rogerjdeangelis/utl-locating-breakpoints-for-dogleg-mutiple-regression-lines

SAS Forum
https://tinyurl.com/v45q2k6
https://communities.sas.com/t5/SAS-Programming/interrupted-time-series-segmented-regression/m-p/633400

Hi res R plot
https://tinyurl.com/yxyhm5d3
https://github.com/rogerjdeangelis/utl-locating-breakpoints-for-dogleg-mutiple-regression-lines/blob/master/dogleg.png

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;
options validvarname=upcase;
libname  sd1 "d:/sd1";
data sd1.have;
  call streaminit(421);
  do day=0 to 100;
     if  day<=39 then rice=day + int(25*rand('uniform'));
     if  day>=38 then rice=40   + (.2*day +int(25*rand('uniform')));
       output;
  end;
run;quit;

options ls=72 ps=40 nocenter;
proc plot data=sd1.have;
plot rice*day='+'/ href=31 box;
run;quit;

/*
Up to 40 obs SD1.HAVE total obs=100

 DAY    RICE

   1    17.0
   2    16.0
   3    25.0
   4    19.0
   5    24.0
   6    14.0
   7    21.0
   8     9.0
   9    29.0
  10    25.0
*/

        0        20        40        60        80        100
     ---+---------+---------+---------+---------+---------+---
 100 +                                                       +100
     |                                                       |
     |                                                       |
     |                                                       |
     |                                                       |
     |                                                       |
  80 +                                            + ++       + 80
     |                                    + +      +    + +  |
     |                              + +         +   ++       |
RICE |                      ++ ++    + +    +  +  +      +   |  RICE
     |                                ++++ + +               |
     |                             + +    ++ ++              |
  60 +                        +  +              ++ +  +++    + 60
     |                   ++  + + +++             +           |
     |                    ++            ++         +++       |
     |                + +       +                            |
     |                   +                                   |
     |             +                                         |
  40 +                                                       + 40
     |           + +  +++                                    |
     |          +   +  +                                     |
     |       + ++   +                                        |
     |    +  +       +                                       |
     |     +   +  +                                          |
  20 +    + + +   +                                          + 20
     |   +    +  +                                           |
     |     +                                                 |
     |      +                                                |
     |                                                       |
     |                                                       |
   0 +                                                       +  0
     ---+---------+---------+---------+---------+---------+---
        0        20        40        60        80        100

                               DAYS

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;


FROM R (SAS macro variable)

%put &=breakpoints;

  BREAKPOINTS=38


Up to 40 obs from PARMS total obs=4

Obs           MODEL           PARAMETER    ESTIMATE

 1     Day_less_than_38       Intercept     12.1869
 2     Day_less_than_38       SLOPE          0.9991
 3     Day_greater_than_38    Intercept     51.4847
 4     Day_greater_than_38    SLOPE          0.2241



        0        20        40        60        80        100
     ---+---------+---------+---------+---------+---------+---
 100 +                                                       +100
     |                                                       |
     |                                                       |
     |                   Day_greater_than_38 Intercept 51.5  |
     |                   Day_greater_than_38 SLOPE      0.2  |                                  |
     |                                                       |
  80 +                                            + ++       + 80
     |                   38               + +      +    + +  |
     |                    ^         + +         +   ++       |
RICE |                    | ++ ++    + +    +  +  +      +   |  RICE
     |                  + |--------------------------------  |
     |                   /|          + +    ++ ++            |
  60 +                + / |     +  +              ++ +  +++  + 60
     |            +  + /  |+  + + +++         *   +          |
     |            ++  /   |++            ++                  |
     |         +    +/ + +|      +                           |
     |          +  +/     |                                  |
     |       +     /+  +  |                                  |
  40 +          + /       |                                  + 40
     |       +   /+ +  +  |                                |
     |          /+   +  + |                                  |
     |       + /++   +    |                                  |
     |    +  +/       +   |                                  |
     |     + /  +  +      |                                  |
  20 +    + /+ +   +      |                                  + 20
     |   + /   +  +       |                                  |
     |    / +             |                                  |
     |      +             |                                  |
     | Day_less_than_38  Intercept  12.18                    |
     | Day_less_than_38  SLOPE       1.00                    |
   0 +                    |                                  +  0
     ---+---------+-------+-+---------+---------+---------+---
        0        20       ^ 40       60        80        100
                          |
                         38    DAYS

*
 _ __  _ __ ___   ___ ___  ___ ___
| '_ \| '__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
;

The R code below creates a the macro variable breakpoints;

%symdel breakpoints / nowarn;

%utl_submit_r64('
library(tseries);
library(strucchange);
library(forecast);
library(haven);
prod_df<-as.data.frame(read_sas("d:/sd1/have.sas7bdat"));
bp=breakpoints(prod_df$RICE ~ prod_df$DAY, h = 25);
bp$breakpoints;
writeClipboard(as.character(paste(bp$breakpoints, collapse = " ")));
png("d:/png/dogleg.png");
plot(prod_df$RICE ~ prod_df$DAY, pch = 19);
lines(fitted(bp, breaks = 1) ~ prod_df$DAY, col = 4, lwd = 1.5)
',returnvar=breakpoints);

%put &=breakpoints;

* SAS REGRESSION;

proc datasets lib=work;
  delete parms parmle38 parmgt38;
run;quit;

data parms(keep=model parameter estimate);
  if _n_=0 then do; %dosubl('

     * first leg;
     ods output  parameterEstimates=parmle38;
     proc reg data=sd1.have(where=(day<=38));
     Day_less_than_38: model rice=day;
     run;quit;

     * second leg;
     ods output  parameterEstimates=parmgt38;
     proc reg data=sd1.have(where=(day>38));
     Day_greater_than_38: model rice=day;
     run;quit;
     ')
  end;
  set
     parmle38
     parmgt38
  ;
  rename variable=PARAMETER;
  if variable="DAY" then variable="SLOPE";
run;quit;

%put &=brealpoints;




