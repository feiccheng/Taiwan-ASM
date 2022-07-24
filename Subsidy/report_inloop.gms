
$ondotl

report_prod(secondary)
    =SUM(processalt$(procbud(secondary,processalt)>0),PROCESS(processalt%addson%) *procbud(secondary,processalt) );

report_processed(primary)
    =-SUM(processalt,PROCESS(processalt%addson%)*procbud(primary,processalt));

report_acres(crop)
    = sum((subreg, period),CROPBUDGET(subreg,crop,period));

report_Proc_Input(processalt, alli)
    $(procbud(alli,processalt)<0)
    = - PROCESS(processalt%addson%) *procbud(alli,processalt);

report_Proc_Input(processalt, cost)=0;

report_Proc_Output(processalt, alli)
    $(procbud(alli,processalt)>0)
    =  PROCESS(processalt%addson%) *procbud(alli,processalt);
report_Proc_Output(processalt, cost)=0;


report_ricebch_acres(subreg, crop)
     $( biochar_rice(crop))
     = sum(period, CROPBUDGET(subreg,crop,period));
	 
report_ricebch_acres(regions, crop)
     = sum(map_reg_subreg(regions,subreg), report_ricebch_acres(subreg, crop));

report_biochar_fillback(subreg)
     =- sum((period,crop), CROPBUDGET(subreg,crop,period)*cbuddata(subreg, crop, period,'biochar'));

report_biochar_fillback(regions)
     = sum(map_reg_subreg(regions,subreg),report_biochar_fillback(subreg));


report_energycrop_acres(subreg, crop)
     $sum((period,energyinput(primary)), cbuddata(subreg, crop, period, primary) )
     = sum(period, CROPBUDGET(subreg,crop,period));

report_energycrop(subreg, energyinput)
     $sum((period,crop), cbuddata(subreg, crop, period, energyinput) )
     = sum((period, crop),cbuddata(subreg, crop, period, energyinput)* CROPBUDGET(subreg,crop,period) );


report_welfare=
$ifthen setglobal stoc
sum(son, probability(son)*
$endif
(
*primary demand surplus, import and export
 + Pdmd  + pExp - Pimp
*secondary demand surplus, import and export
 + Sdmd - Simp + Sexp
* labor supply curve
 - suparea(laboravail, HIRED,HIREDS, subreg)

* take out the producing and processing cost
 - SUM((cbudexist(subreg, crop, period), cost),
         Cbuddata(subreg,crop,period,cost) *CROPBUDGET(subreg,crop,period)  )
 - SUM((lbudexist(subreg,livestock), cost),
         Lbuddata(subreg,livestock, cost)* LVSTBUDGET(subreg,livestock) )
 - SUM((processalt,cost),
         procbud(cost,processalt)*PROCESS(processalt%addson%))
 - SUM(input $(SUM(Cbudexist(subreg,crop,period),Cbuddata(subreg,crop,period,input))
              + SUM(Lbudexist(subreg,livestock),Lbuddata(subreg,livestock,input))
$ifthen setglobal forest
              +sum((subreg, forest), Fbuddata(INPUT,subreg,forest))
$endif
              ),
         inputprice(input)*BUYINPUT(input%addson%))
* land transaction cost
 - sum(maplandtrans(subreg, landtype2, landtype),
         landtrancost(landtype, landtype2)* LANDTRANS(subreg, landtype2, landtype))
* aside land subside
 + sum((subreg,period)$landavail(subreg, 'aside'), landrent(period, 'aside')*ASIDEBUDGET(subreg,period) )

$ifthen setglobal forest
- SUM((subreg,forest)$Fbuddata(forest,subreg,forest),
      SUM(cost,Fbuddata(cost,subreg,forest))
        *FORBUDGET(subreg,forest)  )
$endif
   )
$ifthen setglobal stoc
   )
$endif
   /SCALOBJ;

report_acres_group(subreg, cropgroup, period)
    = sum(grouping1(cropgroup, crop),   CROPBUDGET(subreg,crop,period) );

report_acres_group(regions, cropgroup, period)
    =sum(map_reg_subreg(regions,subreg),report_acres_group(regions, cropgroup, period));
report_input_reg(input,'crops', subreg)
    =        +SUM(Cbudexist(subreg,crop,period),
                 CROPBUDGET(subreg,crop,period)
                *Cbuddata(subreg,crop,period,input)
                *agyieldadj(subreg,crop,period%addson%))   ;

report_input_reg(input,'livestock', subreg)
     =       +SUM(Lbudexist(subreg,livestock),
                 LVSTBUDGET(subreg,livestock)
                *Lbuddata(subreg,livestock,input)
                *livyieldadj(subreg,livestock%addson%)) ;


report_input_reg(input,'total', subreg)
         =report_input_reg(input,'crops', subreg)
         + report_input_reg(input,'livestock', subreg) ;

report_input_reg(input,inputcat, regions)
         =sum(map_reg_subreg(regions,subreg),report_input_reg(input,inputcat, subreg));

report_input_reg(input,'proc', 'total')
    =    +SUM(processalt,PROCESS(processalt%addson%)*procbud(INPUT,processalt)) ;

report_input_reg(input,'total', 'total')=0;
report_input_reg(input,'total', 'total')
         =SUM( inputcat$(NOT SAMEAS(inputcat, 'total')),
                   report_input_reg(input,inputcat, 'total'));

report_demand(primary)=DEMANDP.l(primary%addson%);
report_demand(secondary)=DEMANDS.l(secondary%addson%);
report_price(primary) =primaryBAL.m(primary%addson%)*SCALOBJ;
report_price(secondary)=SECONDBAL.m(secondary%addson%)*SCALOBJ;
*display report_processed, report_prod, report_acres,report_Proc_Input, report_Proc_Output ,report_energycrop_acres, report_ricebch_acres, report_energycrop;
*--------------------------------
* report for all arios
*---------------------------------
    sreport_CROPBUDGET(subreg,crop,period,altrunhere)            =CROPBUDGET(subreg,crop,period);
    sreport_processed(primary,altrunhere)                        =report_processed(primary)            ;
    sreport_prod(secondary,altrunhere)                           =report_prod(secondary)               ;
    sreport_acres(crop,altrunhere)                               =report_acres(crop)                   ;
    sreport_Proc_Input(processalt, alli,altrunhere)              =report_Proc_Input(processalt, alli)  ;
    sreport_Proc_Output(Processalt, alli,altrunhere)             =report_Proc_Output(Processalt, alli) ;
    sreport_ricebch_acres(allregions,crop,altrunhere)            =report_ricebch_acres(allregions,crop)    ;
    sreport_energycrop_acres(allregions,crop,altrunhere)         =report_energycrop_acres(allregions, crop);
    sreport_energycrop(allregions,primary,altrunhere)            =report_energycrop(allregions, primary)   ;
    sreport_welfare(altrunhere)                                  =report_welfare                           ;
    sreport_acres_group(allregions,cropgroup,period,altrunhere)  =report_acres_group(allregions,cropgroup,period);
    sreport_input_reg(input,inputcat, allregions,altrunhere)     =report_input_reg(input,inputcat, allregions);
    sreport_biochar_fillback(allregions,altrunhere)              =report_biochar_fillback(allregions)  ;
    sreport_demand(alli,altrunhere)                              =report_demand(alli);
    sreport_price(alli,altrunhere)                               =report_price(alli);


$offdotl
