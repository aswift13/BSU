
/***************************************************************/
/*Importing data */
/*********************************************************************/
proc import out=market2
    datafile="C:\Users\Aswif\OneDrive\Documents\Coding Projects\Marketing\ifood_df.csv"
    dbms=csv
    replace;
    getnames=YES;
run;


proc contents  data= market2 varnum ;
run;



/*********************************************************************/
/*********      2       *****************/
/*********   Cleaning   *****************/
/*********************************************************************/

/*checking general statistics for all variables*/
proc means data = market2;run;

/*Looking at MntRegularProds*/
ODS TRACE ON;
PROC UNIVARIATE DATA=market2;
VAR MntRegularProds;
RUN;
ODS TRACE OFF;


/*Boxplot to visualize */
proc sgplot data=market2;
vbox MntRegularProds;
run;

/*Histogram to visualize*/
proc univariate data = market2;
var MntRegularProds;
histogram MntRegularProds;
run;

/*see what the issue is*/
proc print data = cmp;
var  MntWines MntFruits MntMeatProducts MntFishProducts MntSweetProducts MntGoldProds MntRegularProds;
where MntRegularProds le 0;
run;


/*Data engineering: Cleanin & Manipulation */
data cmp (drop = Acceptex); 

set market2 ;

/*Create new variables */
length pattern $7    
TOT_Purchase 6 
TOT_Children 3 ChildrenBV 3 Children $ 13 
SingleBV 3 Single $10 Marital_Status $ 8
CollegeBV 3 College $20 Education_Level $ 12
Acceptex 3 Accept $ 8 AcceptBV 3  AcceptCBV $15 Accept5BV 3 Accept5CBV $ 15 ;

/*These variables will tell me how many acceptances customers responded too*/
Acceptex =   AcceptedCmp1+AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5 ;
Accept = cat("Cmp" , Acceptex);

if Response = 0 & AcceptedCmp1+AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5 =0 then Accept = "Cmp0";
if Response = 1 & AcceptedCmp1+AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5 =0 then Accept = "Cmp1";
if Response = 1 & AcceptedCmp1+AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5 =1 then Accept = "Cmp2";
if Response = 1 & AcceptedCmp1+AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5 =2 then Accept = "Cmp3";
if Response = 1 & AcceptedCmp1+AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5 =3 then Accept = "Cmp4";
if Response = 1 & AcceptedCmp1+AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5 =4 then Accept = "Cmp5";
if Response = 1 & AcceptedCmp1+AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5 =5 then Accept = "Cmp6";

/*three factor variable based on old , new and no responses*/
if AcceptedCmp1+AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5 > 0 then Accept5BV = 1; 
else Accept5BV = 0;

if AcceptedCmp1+AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5 > 0 then Accept5CBV = "Prior Response"; 

if AcceptedCmp1+AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5 =0  & Response =1 then Accept5CBV = "New Response";

if AcceptedCmp1+AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5 =0  & Response =0 then Accept5CBV = "No Response";

/*Binary categorical variable of response*/
if AcceptedCmp1+AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5 +Response > 0 then AcceptCBV = "Respond";
else AcceptCBV = "Did not Respond";

/*Binary numerical variable  of response*/
if AcceptedCmp1+AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5 +Response > 0 then AcceptBV = 1;
else AcceptBV = 0;

/*Total number of purchases and children*/
TOT_Purchase = NumCatalogPurchases + NumWebPurchases + NumStorePurchases;
TOT_Children = Teenhome+Kidhome;

/*binary variable for children*/
if Kidhome = 0 & Teenhome = 0 then ChildrenBV = 0;
else ChildrenBV = 1;

/*binary categorical variable for children*/
if Kidhome =0 & Teenhome =0 then Children = "No Children";
else Children = "Has Children";

/*binary variable for single status*/
if marital_Divorced + marital_Widow + marital_Single gt 0 then SingleBV = 1;
else SingleBV = 0;

/*binary categorical variable for single status */
if marital_Divorced + marital_Widow + marital_Single gt 0 then Single = "Single";
else Single = "Not Single";

/*marital status categorical variable*/
if marital_Divorced =1 then Marital_Status ="Divorced";
else if marital_Married =1 then Marital_Status = "Married";
else if marital_Single =1 then Marital_Status = "Single";
else if marital_Widow =1 then Marital_Status = "Widow";
else if marital_Together =1 then Marital_Status ="Together";

/*binary variable if graduated college*/
if education_2n_Cycle + education_Basic gt 0 then CollegeBV =0; 
else CollegeBV = 1;

/*binary categorical status for collgege graduation status */
if education_2n_Cycle + education_Basic gt 0 then College ="Non College Graduate"; 
else College = "College Graduate";

/*education level categorical variable*/
If education_2n_Cycle = 1 then Education_Level = "Second Cycle";
else if education_Basic = 1 then Education_Level = "Basic";
else if education_Graduation =1 then Education_Level ="Undergrad";
else if education_Master =1 then Education_Level = "Masters";
else if education_PhD =1 then Education_Level = "Phd";

/*returns the pattern of responses from the customer*/
pattern = cat("P",AcceptedCmp1,AcceptedCmp2, AcceptedCmp3, AcceptedCmp4, AcceptedCmp5, Response);

TOT_Prods = MntWines +MntFruits +MntMeatProducts +MntFishProducts+ MntSweetProducts+ MntGoldProds;
TOT_Grocery  = MntWines +MntFruits +MntMeatProducts +MntFishProducts+ MntSweetProducts;

drop AcceptedCmpOverall Z_CostContact Z_Revenue MntRegularProds;

run;

proc export data=cmp
    outfile="C:\Users\Aswif\OneDrive\Documents\Coding Projects\Marketing\camp1.csv"
    dbms=csv
    replace;
run;

/*Consolidating to a campaign variable to create a proc report*/;
data re_arrange;
	length Campaign $ 16;
    set work.cmp;
    Campaign='Campaign1';
    Accepted_C=AcceptedCmp1;
    output;    
	Campaign='Campaign2';
    Accepted_C=AcceptedCmp2;
    output;    
	Campaign='Campaign3';
    Accepted_C=AcceptedCmp3;
    output;    
	Campaign='Campaign4';
    Accepted_C=AcceptedCmp4;
    output;    
	Campaign='Campaign5';
    Accepted_C=AcceptedCmp5;
    output;
	Campaign='Response';
    Accepted_C=Response;
    output;
	run;

proc export data=re_arrange
    outfile="C:\Users\Aswif\OneDrive\Documents\Coding Projects\Marketing\camp2.csv"
    dbms=csv
    replace;
run;


data cmptest;
set re_arrange;
if Accepted_C =1 then output;
run;
/*End of data manipulation*/
/***********************************************************************************************************/

proc sgplot data=cmptest pctlevel=group;
  vbar Campaign / stat=sUM group=Accept ;
  xaxis display=(nolabel);
  yaxis grid;
  run;


/*seeing how many responses each customer had*/
proc format ;
value $Accept 
'Cmp0' = 'No Offers Accepted'
'Cmp1' = 'Accepted One Offer'
'Cmp2' = 'Accepted Two Offers'
'Cmp3' = 'Accepted Three Offers'
'Cmp4' = 'Accepted Four Offers'
'Cmp5' = 'Accepted Five Offers'
;
run;
proc freq data = cmp order = freq;
table Accept/list missing;
format Accept $Accept.;
run;
/*******************************************************/



/*Frequency of each marital status*/
proc freq data = cmp order = freq ;
table Marital_Status;
run;
/***********************************/



/**********************************************************************************/
proc stdize data= cmp PctlMtd=ORD_STAT outstat=StdLongPctls
           pctlpts= 25,50,75,99;
var Income MntWines;
run;
 
proc print data=StdLongPctls noobs;
where _type_ =: 'P';
run;
/***************************************************************************************/
proc rank data=cmp out=cars groups=4;
var Income MntWines;
ranks rank_Income rank_Wines;
run;

proc freq data=cars;
table rank_Income rank_Wines;
run;
/*******************************************************************************/

proc sql;
create table want as
select rank,Income,max(Income) as Income_Per
 from have
  group by rank
   order by 1,2;
quit;

proc print;run;

proc sort data = cmp;
by College AcceptCBV Single;
run;

proc summary data=cmp;
by College AcceptCBV Single;
var Income: ;
output out=want p25= p75= p99 = mean = /autoname;
run;
proc print;run;

proc sgplot data = cmpex;
vbar year / Response = TOT_Purchase stat = mean group = Accept5CBV nostatlabel
  groupdisplay=cluster dataskin=gloss;
xaxis display=(nolabel);
yaxis grid;
run;

proc univariate data = cmpex normal;
histogram Income / normal;
var Income;
run;

  proc ANOVA data=cmpex;
	title Example of one-way ANOVA;
	class AcceptCBV;
	model Income = AcceptCBV;
	means method /hovtest welch;
	run;

	
  proc ANOVA data=cmpex;
	title Example of one-way ANOVA;
	class AcceptCBV;
	model Age = AcceptCBV;
	means method /hovtest welch;
	run;

	proc univariate data = cmpex normal;
histogram Income / normal;
var Income;
run;

/***********************************************************************/
/***********************************************************************/
/***********************************************************************/


ods RTF file="C:\Users\Aswif\OneDrive\Documents\Coding Projects\Marketing\reg1.rtf" style = minimal;

/*******************************************************/
/*checking general statistics for all variables*/
title 'Descriptive Statistics of Variables';
proc means data = market2;run;

/*******************************************************/
/*Looking at MntRegularProds*/
title 'Advanced Statistics on MntRegularProds Variable';
ODS TRACE ON;
PROC UNIVARIATE DATA=market2;
VAR MntRegularProds;
RUN;
ODS TRACE OFF;

/*******************************************************/
/*Boxplot to visualize */
title 'Boxplot of MntRegularProds';
proc sgplot data=market2;
vbox MntRegularProds;
run;

/*******************************************************/
/*Histogram to visualize*/
title 'Histogram of MntRegularProds';
ods select histogram;
proc univariate data = market2 noprint;
var MntRegularProds;
histogram MntRegularProds ;
run;

/*******************************************************/
/*see what the issue is*/
title 'Mnt: Variables';
proc print data = market2;
var  MntWines MntFruits MntMeatProducts MntFishProducts MntSweetProducts MntGoldProds MntRegularProds;
where MntRegularProds le 0;
run;

/*******************************************************/
/*seeing how many responses each customer had*/
proc format ;
value $Accept 
'Cmp0' = 'No Offers Accepted'
'Cmp1' = 'Accepted One Offer'
'Cmp2' = 'Accepted Two Offers'
'Cmp3' = 'Accepted Three Offers'
'Cmp4' = 'Accepted Four Offers'
'Cmp5' = 'Accepted Five Offers';
run;

title 'Frequency: number of responses/acceptances';
proc freq data = cmp order = freq;
table Accept/list missing;
format Accept $Accept.;
run;

/*******************************************************/
title 'Stacked Bar Plot of Campaigns';
proc sgplot data=cmptest pctlevel=group;
  vbar Campaign / stat=sUM group=Accept ;
  xaxis display=(nolabel);
  yaxis grid;
  run;

/*******************************************************/
  title 'Yearly Progress of Campaigns';
proc sgplot data = cmpex;
vbar year / Response = TOT_Purchase stat = mean group = Accept5CBV nostatlabel
  groupdisplay=cluster dataskin=gloss;
xaxis display=(nolabel);
yaxis grid;
run;


/**********************************************************************************/
title 'Percentile Values of Income and MntWines';
proc stdize data= cmp PctlMtd=ORD_STAT outstat=StdLongPctls
           pctlpts= 25,50,75,99;
var Income MntWines;
run;
 
proc print data=StdLongPctls noobs;
where _type_ =: 'P';
run;


proc sort data = cmp;
by College AcceptCBV Single;
run;
title 'Income Percentiles by Multiple Factors';
proc summary data=cmp;
by College AcceptCBV Single;
var Income: ;
output out=want p25= p75=  mean = /autoname;
run;
proc print;run;

title 'T-Test Income';
proc ttest data=cmp;
class AcceptCBV;
var Income;
run;

title 'T-Test Age';
proc ttest data=cmp;
class AcceptCBV;
var Age;
run;
ods select default;

ods RTF close;

