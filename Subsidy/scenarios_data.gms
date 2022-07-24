set
    ffscen the weight fossil price scenarios/
    ffbase, fflow,ffhigh,ff1*ff24    /
    ethscen  the ethanol price scenarios/
base
ethbase, ethmid, ethhigh,
eth15*eth40/
    elecscen the electricity price scenarios /
elecmid,elecbase,elechigh
ele16*ele56/
    ghgscen  the carbon emssion price scenarios /
base
ghgbase, ghgmid, ghghigh, ghg0, ghg1*ghg113/

    elec_qscen   electricity quantity sceanrio
/ elec_q0*elec_q20/

    ethnoal_qscen   ethnoal quantity scenario
 /eth_q0* eth_q20/

    elec_subsidyscen  the electricity subsidy scenario
  / elec_subsidy0* elec_subsidy10/

;
set altrunsall all alternative scenarios
/ altrun1*altrun1000/;
set altrun(altrunsall)  the subset of altrunsall;

*ghgX means X US dollar per ton, and then convert it to the NT$ per kg emission


*    ethscen  the ethanol price scenarios/ ethmid,ethbase,ethhigh/
*    elecscen the electricity price scenarios / elecmid,elecbase,elechigh/
*    ghgscen  the carbon emssion price scenarios /ghglow, ghgbase, ghghigh/;

set gcms /none, A1, B1/
    rcps /none, A1, B1/;

singleton set
         ff(ffscen)
         eth(ethscen)
         elec(elecscen)
         ghg(ghgscen)
         gcm(gcms)
         rcp(rcps)
         elecq(elec_qscen)
         ethq(ethnoal_qscen)
         budget(elec_subsidyscen)
         altrunhere(altrunsall)
;



$ifthen.r not setglobal readset
parameter
ffprice(ffscen) the fossil price by scenarios
*ff price is the weighted price of petroleum and natural gas,
* for a total 4.23 energy supply, petroleum has 3.23 and NG has 1
*this is the weight and the average price is (3.23*10.73+8.38)/4.23=10.17
* use as low as 82.5% and as high as 128%, we set up 24 ff scenarios
/
ffbase   10.4
fflow     8.4
ffhigh   12.4
ff1       8.4
ff2       8.6
ff3       8.8
ff4       9.0
ff5       9.2
ff6       9.4
ff7       9.6
ff8       9.8
ff9      10.0
ff10     10.2
ff11     10.4
ff12     10.6
ff13     10.8
ff14     11.0
ff15     11.2
ff16     11.4
ff17     11.6
ff18     11.8
ff19     12.0
ff20     12.2
ff21     12.4
ff22     12.6
ff23     12.8
ff24     13.0
/
ethprice(ethscen) the ethonal price by scenarios
/ base     0
  ethbase  20
  ethmid   30
  ethhigh  40
  eth15    15
  eth16    16
  eth17    17
  eth18    18
  eth19    19
  eth20    20
  eth21    21
  eth22    22
  eth23    23
  eth24    24
  eth25    25
  eth26    26
  eth27    27
  eth28    28
  eth29    29
  eth30    30
  eth31    31
  eth32    32
  eth33    33
  eth34    34
  eth35    35
  eth36    36
  eth37    37
  eth38    38
  eth39    39
  eth40    40/

elecprice(elecscen) the electricity price by scenarios
/
elecbase  3.4
elecmid   3.9
elechigh  5.4
ele16     1.6
ele17     1.7
ele18     1.8
ele19     1.9
ele20     2.0
ele21     2.1
ele22     2.2
ele23     2.3
ele24     2.4
ele25     2.5
ele26     2.6
ele27     2.7
ele28     2.8
ele29     2.9
ele30     3.0
ele31     3.1
ele32     3.2
ele33     3.3
ele34     3.4
ele35     3.5
ele36     3.6
ele37     3.7
ele38     3.8
ele39     3.9
ele40     4.0
ele41     4.1
ele42     4.2
ele43     4.3
ele44     4.4
ele45     4.5
ele46     4.6
ele47     4.7
ele48     4.8
ele49     4.9
ele50     5.0
ele51     5.1
ele52     5.2
ele53     5.3
ele54     5.4
ele55     5.5
ele56     5.6
/

ghgprice(ghgscen) the carbon price
/
base       0
ghgbase   300
ghgmid    900
ghghigh  5500
ghg0       0
ghg1       30
ghg2       60
ghg3       90
ghg4      120
ghg5      150
ghg6      180
ghg7      210
ghg8      240
ghg9      270
ghg10     300
ghg11     330
ghg12     360
ghg13     390
ghg14     420
ghg15     450
ghg16     480
ghg17     510
ghg18     540
ghg19     570
ghg20     600
ghg21     630
ghg22     660
ghg23     690
ghg24     720
ghg25     750
ghg26     780
ghg27     810
ghg28     840
ghg29     870
ghg30     900
ghg31     930
ghg32     960
ghg33     990
ghg34    1020
ghg35    1050
ghg36    1080
ghg37    1110
ghg38    1140
ghg39    1170
ghg40    1200
ghg41    1230
ghg42    1260
ghg43    1290
ghg44    1320
ghg45    1350
ghg46    1380
ghg47    1410
ghg48    1440
ghg49    1470
ghg50    1500
ghg51    1530
ghg52    1560
ghg53    1590
ghg54    1620
ghg55    1650
ghg56    1680
ghg57    1710
ghg58    1740
ghg59    1770
ghg60    1800
ghg61    1830
ghg62    1860
ghg63    1890
ghg64    1920
ghg65    1950
ghg66    1980
ghg67    2010
ghg68    2040
ghg69    2070
ghg70    2100
ghg71    2130
ghg72    2160
ghg73    2190
ghg74    2220
ghg75    2250
ghg76    2280
ghg77    2310
ghg78    2340
ghg79    2370
ghg80    2400
ghg81    2430
ghg82    2460
ghg83    2490
ghg84    2520
ghg85    2550
ghg86    2580
ghg87    2610
ghg88    2640
ghg89    2670
ghg90    2700
ghg91    2730
ghg92    2760
ghg93    2790
ghg94    2820
ghg95    2850
ghg96    2880
ghg97    2910
ghg98    2940
ghg99    2970
ghg100   3000
ghg101   3030
ghg102   3060
ghg103   3090
ghg104   3120
ghg105   3150
ghg106   3180
ghg107   3210
ghg108   3240
ghg109   3270
ghg110   3300
ghg111   3330
ghg112   3360
ghg113   3390

/
;
* please include the gap for the renewable energy here
parameter elec_quantity(elec_qscen)      the quantity of electricity demand in each scenario
/
elec_q0  230110000.00
elec_q1  250000000
elec_q2  300000000

/

ethonal_quantity(ethnoal_qscen)           the quantity of ethonal demand in each scenario
/
eth_q0  300000.00
eth_q1  200000.00
eth_q2  400000.00

/

;



*-------------------------------------------
* read the impact of climate to agricultural
*-----------------------------------------
Parameter       climate_agyieldadj(SUBREG,CROP,period,gcms, rcps)    ag yield proportions by climate gcms rcps;


Table climate_agyieldadj1(crop, gcms, rcps)   the son adjustment to crops
            A1.A1        B1.B1
Japonica    0.984       0.993
SWPotato    0.97        0.98
foodCorn    0.97        0.988
Soybean     1.03        1.04
Sorghum     1.18        1.07
Wheat       1.001       1.002

;

climate_agyieldadj1(crop, 'A1', 'A1')$(climate_agyieldadj1(crop, 'A1', 'A1') =0  )=1;
climate_agyieldadj1(crop, 'B1', 'B1')$(climate_agyieldadj1(crop, 'B1', 'B1') =0  )=1;
climate_agyieldadj1(crop, 'none', 'none') =1;

climate_agyieldadj(SUBREG,CROP,period,gcms, rcps)$(sum(primary, Cbuddata(subreg,crop,period,primary)) and climate_agyieldadj1(crop, gcms, rcps))=climate_agyieldadj1(crop, gcms, rcps);

* livestock and forest

parameter   climate_foryieldadj(SUBREG,forest,gcms, rcps)        forest yield proportions by  climate gcms rcps;
parameter   climate_livyieldadj(SUBREG,livestock,gcms, rcps)     livestock yield proportions by  climate gcms rcps;

$ifthen.a setglobal forest
         climate_foryieldadj(SUBREG,forest,gcms, rcps)$FBUDDATA(PRIMARY,SUBREG,FOREST)=1;
$endif.a
         climate_livyieldadj(SUBREG,livestock,gcms, rcps)$lBUDexist(SUBREG,livestock)=1;

$endif.r