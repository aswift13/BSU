
*2022-2023 Lineup*;

*creating libref for new data*;
libname MBB_2022 "C:\Users\Aswif\OneDrive\Documents\Coding Projects\BSU MBB\2022_2023\Data 2022";

*impoting data sets for configurations*;
proc import file = "C:\Users\Aswif\OneDrive\Documents\Coding Projects\BSU MBB\2022_2023\Data 2022\Lineup_2022.xlsx"
dbms = xlsx 
out = MBB_2022.lineups 
Replace;
getnames = yes;
run;

data
proc contents data = mbb_2022.lineups;run;

*Compresses the lineups to only have numbers and - *;

options obs = 10;
data mbb_2022.example;
set mbb_2022.lineups;
run;

options obs = max;
data MBB_2022.lineups;
set MBB_2022.lineups;

*Chaning PPP to a variable name easier to read*;
Pts_Poss = PPP;
format  Pts_Poss 8.4 ;

*lineup manipulation to attain only the player numbers and hyphens*;
lineup = compress(lineup,"/",'dk');
lineup = tranwrd(lineup,"/","-");
C = '-';
P = findc(Lineup,C, 'K', -length(Lineup));
if P then Lineup = substr(Lineup,1,P);
else Lineup = '';
   put Lineup= / ;
   drop  P;

   *Creates variables for each player position*;
Player1 = scan(Lineup,1,"-");
Player2 = scan(Lineup,2,"-");
Player3 = scan(Lineup,3,"-");
Player4 = scan(Lineup,4,"-");
Player5 = scan(Lineup,5,"-");

*Orders the player numbers from smalles to largest to better id lineups*;
Player1 = min(Player1,Player2,Player3,Player4,Player5);
player2 = smallest(2, of Player1-Player5);
player3 = smallest(3, of Player1-Player5);
player4 = largest(2, of Player1-Player5);
player5 = max(Player1,Player2,Player3,Player4,Player5);

run;

*sort the data by player numbers to assign IDs *;proc sort data= MBB_2022.Lineups out=MBB_2022.Lineups; 
  by Player1 Player2 Player3 Player4 Player5;
run;

*ALL variable data manipulaiton*;data MBB_2022.lineups;
set MBB_2022.lineups (rename = (Ass = Asst));
label  Asst = "Assist";
by Player1 Player2 Player3 Player4 Player5;

*creates the IDS and numbe in the sequence*;
  if first.Player5 then lineup_id + 1;

  if first.Player5 
    then seq_in_group = 1; 
    else seq_in_group + 1;

	*creates player name variables*;
	length P_Name1 $ 20 P_Name2 $ 20 P_Name3 $ 20 P_Name4 $ 20 P_Name5 $ 20 P_Name6 $ 20 P_Name7 $ 20 P_Name8 $ 20 P_Name9 $ 20 P_Name10 $ 20 P_Name11 $ 20 P_Name12 $ 20 P_Name13 $ 20 P_Name14 $ 20;
 if Player1 = 1  | Player2 = 1  | Player3 = 1  | Player4 = 1  | Player5 = 1  then P_Name1 = "D_Jacobs";
 if Player1 = 2  | Player2 = 2  | Player3 = 2  | Player4 = 2  | Player5 = 2  then P_Name2 = "L_Bumbalough";
 if Player1 = 3  | Player2 = 3  | Player3 = 3  | Player4 = 3  | Player5 = 3  then P_Name3 = "M_Pearson";
 if Player1 = 5  | Player2 = 5  | Player3 = 5  | Player4 = 5  | Player5 = 5  then P_Name4 = "P_Sparks";
 if Player1 = 11 | Player2 = 11 | Player3 = 11 | Player4 = 11 | Player5 = 11 then P_Name5 = "B_Jihad";
 if Player1 = 12 | Player2 = 12 | Player3 = 12 | Player4 = 12 | Player5 = 12 then P_Name6 = "J_Sellers";
 if Player1 = 24 | Player2 = 24 | Player3 = 24 | Player4 = 24 | Player5 = 24 then P_Name7 = "J_Windham";
 if Player1 = 0  | Player2 = 0  | Player3 = 0  | Player4 = 0  | Player5 = 0  then P_Name8 = "J_Coleman";
 if Player1 = 4  | Player2 = 4  | Player3 = 4  | Player4 = 4  | Player5 = 4  then P_Name9 = "M_Bell";
 if Player1 = 13 | Player2 = 13 | Player3 = 13 | Player4 = 13 | Player5 = 13 then P_Name10 = "D_White";
 if Player1 = 14 | Player2 = 14 | Player3 = 14 | Player4 = 14 | Player5 = 14 then P_Name11 = "J_Futa";
 if Player1 = 15 | Player2 = 15 | Player3 = 15 | Player4 = 15 | Player5 = 15 then P_Name12 = "Q_Adams";
 if Player1 = 23 | Player2 = 23 | Player3 = 23 | Player4 = 23 | Player5 = 23 then P_Name13 = "K_Cleary";
 if Player1 = 34 | Player2 = 34 | Player3 = 34 | Player4 = 34 | Player5 = 34 then P_Name14 = "B_Hendricks";
drop Player1 Player2 Player3 Player4 Player5 ; 

Length Jacobs Bumbalough Pearson Sparks Jihad Sellers Windham Coleman Bell White Futa Adams Clearly Hendricks 3 ;

If P_Name1  ^= ' ' then Jacobs =1 ;else Jacobs = 0;
If P_Name2  ^= ' ' then Bumbalough =1 ; else Bumbalough =0;
If P_Name3  ^= ' ' then Pearson =1 ; else Pearson = 0;
If P_Name4  ^= ' ' then Sparks =1 ; else Sparks =0;
If P_Name5  ^= ' ' then Jihad =1 ; else Jihad = 0;
If P_Name6  ^= ' ' then Sellers =1 ; else Sellers = 0;
If P_Name7  ^= ' ' then Windham =1 ; else Windham = 0;
If P_Name8  ^= ' ' then Coleman =1 ;else Coleman = 0;
If P_Name9  ^= ' ' then Bell =1 ; else Bell =0;
If P_Name10 ^= ' ' then White =1 ; else White = 0;
If P_Name11 ^= ' ' then Futa =1 ; else Futa =0;
If P_Name12 ^= ' ' then Adams =1 ; else Adams = 0;
If P_Name13 ^= ' ' then Clearly =1 ; else Clearly = 0;
If P_Name14 ^= ' ' then Hendricks =1 ; else Hendricks = 0;


drop P_Name1 P_Name2 P_Name3 P_Name4 P_Name5 P_Name6 P_Name7 P_Name8 P_Name9 P_Name10 P_Name11 P_Name12 P_Name13 P_Name14 C; 

*get the game nymber and opponent information from filename*;
Game_N = scan(Source_Name,1,"_");
OPPONENT = scan(Source_Name,3,"_.");

*get the team scores from the score differential*;
BSU_P = Scan(Score,1);
OPP_P = Scan(Score,2);

*manipulate  and format vairables*;

	BSU_PTS = input(BSU_P, comma9.);
	G_N = input(Game_N, comma9.);
	OPP_PTS = input(OPP_P, comma9.);
	drop BSU_P OPP_P Game_N Source_Name Score Time PPP;

	*----------------------------------     ENTER WINS AND LOSS DATA HERE -----------------------------*;
	
	Length RESULT  3 W_L $ 4;
		if G_N IN ("1","3","4","6","9","10","11","12","13", "14","15", "17", "18")then  W_L = "WON";
	else W_L = "LOSS";

	* More formating*;
			format Minutes 8.2;
	Minutes = Seconds / 60;
If W_L = "WON" then RESULT = 1; else RESULT = 0;


format LOC 8.0 ;
length H_A $6;

if G_N IN ("1","4","10","12","13","15","17","18")then  LOC = 1;
else LOC = 0;

if LOC = 1 then H_A = "HOME";
else H_A = "AWAY";
	
	run;

*Sort data by Game number*;proc sort data= MBB_2022.Lineups out=MBB_2022.Lineups; 
  by G_N;
run;
*Data manipulation ends here*;-----------------------------------------------------------------------;

*rearranging the variables to match previous seasons lineup *;data MBB_2022.lineups ;
retain G_N H_A OPPONENT  BSU_PTS OPP_PTS Score_Diff Pts_Min Minutes Reb Stl Tov Asst Pts_Poss Lineup lineup_id Jacobs Bumbalough Pearson Sparks Jihad Sellers Windham 
Coleman Bell White Futa Adams Clearly Hendricks LOC RESULT; 
set MBB_2022.lineups ; 
	 drop Seconds seq_in_group;
	run;


*exporting both files*;
proc export data= MBB_2022.lineups 
outfile = "C:\Users\Aswif\OneDrive\Documents\Coding Projects\BSU MBB\2022_2023\2022_2023_Lineups.xlsx" 
dbms= xlsx replace;
run;


*********Data used for report***********;

*most used lineups*;
proc freq data = mbb_2022.lineups order = freq noprint;
table lineup/ out = work.freqp;
run;

*points per possesion*;
ods exclude all;
proc means data = mbb_2022.lineups
N Mean 
STACKODSOUTPUT;
var Pts_Poss;
class Lineup;
ods output summary = meanssummary; 
run;
ods exclude none;

proc sort data = meanssummary;
by descending Mean;
run;

*lineup descriptive statistics*;
proc means data = mbb_2022.lineups;
var lineup_id;
run;

proc univariate data = freqp;
var count;
histogram count /endpoints=(1 to 26 by 1);run;

*lineup by time*;

ods exclude all;
proc means data = mbb_2022.lineups
N Mean 
STACKODSOUTPUT;
var Minutes;
class Lineup;
ods output summary = min; 
run;
ods exclude none;

proc sort data = min;
by descending Mean;
run;


***********Data used for report end***************;

*START OF pdf FILE*;
-----------------------------------------------------;

*Creating a pdf file FOR HOW DATA LOOKS BEFORE AND AFTER *;

ods _all_ close;
ods pdf file="C:\Users\Aswif\OneDrive\Documents\Coding Projects\BSU MBB\2022_2023\MBB_WL.pdf";

title 'Data BEFORE the manipulations';
proc print data = mbb_2022.Example(obs = 2);


title 'Data AFTER the manipulations';
proc print data = mbb_2022.Lineups(obs = 2);


title "Frequency of lineups";
proc univariate data = freqp;
var count;
histogram count /endpoints=(1 to 26 by 1);run;

title 'Most used Lineups';
proc print data = work.freqp(obs=20);
var lineup Count ;
run;


title 'Lineups with the highest average Points Per Possesion';
proc print data = work.Meanssummary(obs=20);
var Lineup N Mean;
where N GE 10;
footnote 'N >= 10';
footnote '';
run;

ods pdf close;
ods pdf;
ods html;
footnote'';
* End of pdf file*;
-------------------------;

*Check, makes sure game times add up to 40 ish minutes*;proc sql;
   select G_N, sum(Seconds/60) as sum_min
   from  MBB_2022.lineups 
   group by G_N;
quit;
