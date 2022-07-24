
$call 'gams buildup_scenarios_stepsubsidy_ee.gms '
$include %whereisdata%scenarios_data.gms
set subsidy_rules  the subsidy rules /rule1*rule10/;
singleton set subsidyhere(subsidy_rules);

Table Elec_Subsidy_rules(subsidy_rules,subsidyitem,rnwelec_proc)     the quantity limits (kwh) and subsidy for electricity

* note the quantity is the amount in each stage
* the last one (rnwelec5) must be zero and zero to allow renewable electricity convert to electricity
* we can increase the steps if needed... but make sure to modify the code below
$ontext
                  convert_rnwelec1     convert_rnwelec2    convert_rnwelec3  convert_rnwelec4    convert_rnwelec5
rule1. quantity   5000000                 8000000              10000000         12000000                 0
rule1. subsidy     1.60                    1.28                 1.024            0.8192                  0
rule2. quantity   6250000                 10000000             12500000         15000000                 0
rule2. subsidy     1.28                    1.024                0.8192           0.65536                 0
rule3. quantity   4166667                 6666667               8333333         10000000                 0
rule3. subsidy     1.92                    1.536                1.2288           0.98304                 0
rule4. quantity   8333333                 15238095             21768707         29854227                 0
rule4. subsidy     0.96                    0.672                 0.4704          0.32928                 0
$offtext
                  convert_rnwelec1     convert_rnwelec2    convert_rnwelec3   convert_rnwelec4    convert_rnwelec5
rule1. quantity     2400000                  2400000             4800000        4800000                 0
rule1. subsidy      4.8                      4.32                3.888           3.4992                 0
rule2. quantity     1500000                  3000000             3000000        3000000                 0
rule2. subsidy      5.4                      4.32                  3.456          2.7648                0
rule3. quantity     3000000                  3000000             3000000        3000000                 0
rule3. subsidy      3.6                      3.384               3.18096         2.9901024              0
rule4. quantity     2400000                  2400000             2400000        2400000                 0
rule4. subsidy      4.5                      4.25                   4             3.75                  0
;

Elec_Subsidy_rules(subsidy_rules,'cost',rnwelec_proc)
         = Elec_Subsidy_rules(subsidy_rules,'quantity',rnwelec_proc) *Elec_Subsidy_rules(subsidy_rules,'subsidy',rnwelec_proc) ;

loop(subsidy_rules$Elec_Subsidy_rules(subsidy_rules,'quantity','convert_rnwelec1'),
         rnwelec_proc2(rnwelec_proc)= no;;
         loop(rnwelec_proc,
                  rnwelec_proc2(rnwelec_proc)= yes;
                  Elec_Subsidy_rules(subsidy_rules,'cum_cost', rnwelec_proc)=sum(rnwelec_proc2, Elec_Subsidy_rules(subsidy_rules,'cost', rnwelec_proc2));
         ); );
* merge the budget with subsidy rules
set link_subsidy_rules(elec_subsidyscen,subsidy_rules)   link the subsidy rules with budget
/
elec_subsidy0.rule1
elec_subsidy1.rule2
elec_subsidy2.rule3
elec_subsidy3.rule4
/
;

parameter 

budget_available(elec_subsidyscen)      the renewable electricity subsidy available in each scenario
;

budget_available(elec_subsidyscen)
    =sum((link_subsidy_rules(elec_subsidyscen,subsidy_rules),rnwelec_proc),
             Elec_Subsidy_rules(subsidy_rules,'quantity',rnwelec_proc)
            *Elec_Subsidy_rules(subsidy_rules,'subsidy',rnwelec_proc));

parameter Subsidy_Rules_wbud(elec_subsidyscen,subsidy_rules,subsidyitem,rnwelec_proc)  the subsidy rules with budget consideration ;
parameter budgethere  the total budget available  ;

loop(elec_subsidyscen$sum(link_subsidy_rules(elec_subsidyscen,subsidy_rules), budget_available(elec_subsidyscen)),
          budgethere=budget_available(elec_subsidyscen);

         loop(subsidy_rules$(Elec_Subsidy_rules(subsidy_rules,'quantity','convert_rnwelec1')and link_subsidy_rules(elec_subsidyscen,subsidy_rules)),
                  rnwelec_proc2(rnwelec_proc)= no;;
                  loop(rnwelec_proc$(not sameas(rnwelec_proc,'convert_rnwelec5')),

                           if( ((Elec_Subsidy_rules(subsidy_rules,'cum_cost',rnwelec_proc)<budgethere) and not sameas(rnwelec_proc,'convert_rnwelec4')),
                                Subsidy_Rules_wbud(elec_subsidyscen,subsidy_rules,subsidyitem,rnwelec_proc)
                                         =Elec_Subsidy_rules(subsidy_rules,subsidyitem,rnwelec_proc);
                           else
                                Subsidy_Rules_wbud(elec_subsidyscen,subsidy_rules,'subsidy',rnwelec_proc)    = Elec_Subsidy_rules(subsidy_rules,'subsidy', rnwelec_proc);
                                Subsidy_Rules_wbud(elec_subsidyscen,subsidy_rules,'cum_cost',rnwelec_proc) = budgethere;
                                Subsidy_Rules_wbud(elec_subsidyscen,subsidy_rules,'cost',rnwelec_proc)     = budgethere- sum(rnwelec_proc2, Elec_Subsidy_rules(subsidy_rules,'cost', rnwelec_proc2));
                                Subsidy_Rules_wbud(elec_subsidyscen,subsidy_rules,'quantity',rnwelec_proc)
                                         = Subsidy_Rules_wbud(elec_subsidyscen,subsidy_rules,'cost',rnwelec_proc)
                                          /Elec_Subsidy_rules(subsidy_rules,'subsidy', rnwelec_proc) ;

                                );

                            rnwelec_proc2(rnwelec_proc)= yes;

                  );
                 Subsidy_Rules_wbud(elec_subsidyscen,subsidy_rules,subsidyitem,'convert_rnwelec5')  =0;
                 Subsidy_Rules_wbud(elec_subsidyscen,subsidy_rules,'cum_cost','convert_rnwelec5')=budgethere;

); );


display Subsidy_Rules_wbud;

$include data_local_scenario_list.gms

altrun(altrunsall)= no;
altrun(altrunsall)$sum(mapscenario(altrunsall, ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules),1) = yes;

display altrun;

$include %whereisdata%report_set.gms

set   secondary_food(secondary)         the secondary food
/
brownrice,
                   soybeanoil,  soybeanmeal, sesameoil, sesamemeal, peanutoil, peanutmeal,
                       cornoil,       sugar, cornmeal, cornbran
*                     starch,
                       whflour,  wheatbran,
                       hogfeed,  geesefeed,
                      chicfeed,   duckfeed, turkeyfeed
                    cattlefeed,   goatfeed,  milkfeed, eggfeed
                    beef,      chickenmeat, chickengut including neck heart liver other gut, chickenneck,
*                    loin, shoulder, belly, ham, rib, piggut,
                    pork, lard, piggut, pigbone, pigfeet, oxgut, oxbone, MilkPowder, concmilk, evapmilk, butter
                    /;


file gckfile1 "gamschk file"  /%system.fn%.gck/;
put gckfile1;
$onput

ANALYSIS

postopt
variable
DEMANDSN
DEMANDS(CARBONEMS)
DEMANDS(elec*)
DEMANDS(rnw*)
DEMANDS(sub*)
equation
PROCESSLimit2
 SECONDBAL(electricity)
 SECONDBAL(rnw*)
 SECONDBAL(CARBONEMS)
 SECONDBAL(CARBONrelease)

$offput
putclose;

parameter save_SDemand(secondary, sditem) save the secondary demand info
          save_agyieldadj(subreg,crop,period%addson%) save the ag adjust data
          save_inputprice(input)           save the input prices
          save_procbud(alli,PROCESSALT)     save procbud;

save_SDemand(secondary, sditem)= SDemand(secondary, sditem);
save_agyieldadj(subreg,crop,period%addson%)= agyieldadj(subreg,crop,period%addson%);
save_inputprice(input) = INPUTPRICE(INPUT);
save_procbud(alli,PROCESSALT) =procbud(alli,PROCESSALT) ;


* turn off the carbon release from fossile fuel to remove the impact of fossil fuel mkt
save_procbud('CARBONRelease','proc_coal_elec') =0;
save_procbud('CARBONRelease','proc_naturalgas_elec') =0;
save_procbud('CARBONRelease','proc_oil_elec') =0;





parameter energyprocbud(alli,processalt)                                                      the energy budget with new profit calculation
          sreport_energyprocbud(alli,processalt,altrunsall)                                   the energy budget with new profit calculation;

*-----------------------------------
* loop the model
*-----------------------------
SDemand('sub_electricity','elasticity') =-0.01;
SDemand('sub_electricity','elasticity') =-0.01;
loop(altrun,
         loop(mapscenario(altrun, ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) ,
* set the aside land to be at least 2/3 of current level
* set the crop production to be at least 90% of current level
* set the elec demand to be  104% of current level
                 altrunhere(altrun) = yes;
                 eth(ethscen)               $mapscenario(altrunhere, ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) =yes;
                 elec(elecscen)             $mapscenario(altrunhere, ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) =yes;
                 ghg(ghgscen)               $mapscenario(altrunhere, ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) =yes;
                 elecq(elec_qscen)          $mapscenario(altrunhere, ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) =yes;
                 ethq(ethnoal_qscen)        $mapscenario(altrunhere, ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) =yes;
                 budget(elec_subsidyscen)   $mapscenario(altrunhere, ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) =yes;
                 subsidyhere(subsidy_rules) $mapscenario(altrunhere, ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) =yes;
           );

* get bio energy product prices
    SDemand(SECONDARY,SDITEM)             =save_SDemand(secondary, sditem);
    Inputprice(input)                     =save_inputprice(input);
    procbud(alli,PROCESSALT)              =save_procbud(alli,PROCESSALT);
*    procbud(alli,'convert_RNW_elec')=0;

    if (sameas(ghg, 'base'),
      procbud(alli,energyprocess(processalt) )=0;
     );
    if (not sameas(ghg, 'base'),
         ASIDEBUDGET.lo(subreg,'3')            = 2/3*landavail(subreg,'aside') ;
*         SDemand('electricity','quantity')     =save_SDemand('electricity','quantity')*1.04 ;
         DEMANDP.lo(primary%addson%)           =PDemand(primary,"quantity")*0.9;
         DEMANDS.lo(secondary_food%addson%)    =SDemand(secondary_food,"quantity")*0.9;
     );

    SDemand('ethanol','price')              =ethprice(eth);

    SDemand('sub_electricity','price')      =elecprice(elec);
*    PROCBUD('proccost','convert_RNW_elec')  = -elecprice(elec)-rnw_subsidy+SDemand('electricity','price');
    SDemand('CARBONEMs','price')            =ghgprice(ghg)/1000;
    SDemand('CARBONRelease','price')        =-ghgprice(ghg)/1000-0.0001;
    SDemand('ethanol','quantity')         =ethonal_quantity(ethq) ;
    SDemand('electricity','quantity')     =elec_quantity(elecq) ;


* adjust the subsidy and budget
    Elec_Subsidy(subsidyitem, rnwelec_proc)= Subsidy_Rules_wbud(budget,subsidyhere,subsidyitem,rnwelec_proc) ;
    procbud('proccost',rnwelec_proc)     = -Elec_Subsidy('subsidy', rnwelec_proc)  ;
*display Elec_Subsidy, subsidyitem, rnwelec_proc, Subsidy_Rules_wbud, budget,subsidyhere;

$include %whereisdata%model_bounds
$include %whereisdata%asmcalrn

DEMANDS.lo('sub_electricity')    =0;
DEMANDS.up('sub_electricity')    =+inf;
DEMANDS.fx('electricity')        =SDemand('electricity','quantity');
DEMANDS.fx('rnw_electricity')        =SDemand('electricity','quantity');
PROCESS.up(rnwelec_proc%addson%)$Elec_Subsidy('quantity',rnwelec_proc)=Elec_Subsidy('quantity', rnwelec_proc);
PROCESS.lo(rnwelec_proc%addson%)=0;
PROCESS.up(rnwelec_proc%addson%)$(Elec_Subsidy('quantity',rnwelec_proc)=0) =inf;

option lp=cplex;
*option lp=gamschk;

    SOLVE SECTOR USING LP MAXIMIZING CSPS;

$include %whereisdata%report_inloop

   energyprocbud(alli,energyprocess)= procbud(alli,energyprocess);
   energyprocbud('profit',energyprocess)=0;

   energyprocbud("PROFIT",energyprocess(PROCESSALT))
           =
            +SUM(PRIMARY,report_price(PRIMARY)
                        *(energyprocbud(PRIMARY,PROCESSALT)))
            +SUM(SECONDARY,
                        report_price(SECONDARY)
                        *(energyprocbud(SECONDARY,PROCESSALT)))
            -SUM(INPUT,INPUTPRICE(INPUT)
                        *energyprocbud(INPUT,PROCESSALT))
            -SUM(COST,energyprocbud(COST,PROCESSALT))   ;

sreport_energyprocbud(alli,processalt,altrunhere)= energyprocbud(alli,processalt);

*display energyprocbud;

    eth(ethscen)   =no;
    elec(elecscen) =no;
    ghg(ghgscen)   =no;
    elecq(elec_qscen)            =no;
    ethq(ethnoal_qscen)          =no;
    budget(elec_subsidyscen)     =no;
    subsidyhere(subsidy_rules)   =no;

    altrunhere(altrunsall) = no;

);


$include report_local.gms
















