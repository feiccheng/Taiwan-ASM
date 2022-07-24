$ifthen setglobal stoc
$setglobal stoc1 sum(son, probability(son)*
$setglobal stoc2 )
$else
$setglobal stoc1
$setglobal stoc2
$endif


set item the items used in the report /dom_demand, import, export, production,processed, fromproc, price, Impprice, expprice, tax, taxRate, TaxAmount/
    citem /simul, orig, ratio/ ;

parameter balance(alli, item%addson%) report the primary price and quantity
          compare(alli,item, citem)  compare the demand level

;

$ondotl
balance(primary, 'dom_demand'%addson%) =DEMANDP(primary%addson%);
balance(primary, 'import'    %addson%) =IMPORTP(primary%addson%);
balance(primary, 'export'    %addson%) =EXPORTP(primary%addson%);

balance(primary, 'price'   %addson%) =price(pDemand, DEMANDPS, primary) ;
balance(primary, 'Impprice'%addson%) =price(pImport, IMPORTpS, primary)-Tax(pImport, IMPORTpS, primary) ;
balance(primary, 'Expprice'%addson%) =Pexport(primary,'price') ;


balance(secondary, 'dom_demand'%addson%) =DEMANDS(secondary%addson%);
balance(secondary, 'import'    %addson%) =IMPORTS(secondary%addson%);
balance(secondary, 'export'    %addson%) =EXPORTS(secondary%addson%);

balance(secondary, 'price'   %addson%) =price(sDemand, DEMANDSS, secondary) ;
balance(secondary, 'Impprice'%addson%) =price(sImport, IMPORTSS, secondary) -Tax(sImport, IMPORTSS, secondary);
balance(secondary, 'Expprice'%addson%) =sexport(secondary,'price') ;

balance(primary, 'price'%addson%)$(balance(primary, 'price'%addson%)=0)=primaryBAL.m(primary%addson%)*SCALOBJ  ;
balance(secondary, 'price'%addson%)$(balance(secondary, 'price'%addson%)=0)=  SECONDBAL.m(secondary%addson%)*SCALOBJ;

balance(primary, 'production'%addson%)
        =  SUM(cbudexist(subreg,crop,period),
                 CROPBUDGET(subreg,crop,period)
                *Cbuddata(subreg,crop,period,primary)
                *agyieldadj(subreg,crop,period%addson%) )
$ifthen setglobal forest
         +SUM((subreg, forest),
                 FORBUDGET(subreg,forest)
                *Fbuddata(primary,subreg,forest)
                *foryieldadj(primary,subreg,forest%addson%) )
$endif
        +SUM(lbudexist(subreg, livestock),
                 LVSTBUDGET(subreg,livestock)
                *Lbuddata(subreg,livestock, primary)
                *livyieldadj(subreg,livestock%addson%) );

balance(primary, 'processed'%addson%)
    =-SUM(processalt,PROCESS(processalt%addson%)*procbud(primary,processalt));


* compare the calibration result with the original data;
compare(alli,item, 'simul') = %stoc1%balance(alli,item%addson%)%stoc2% ;

compare(primary,'dom_demand', 'orig')  = Pdemand(primary,'quantity');
compare(primary,'import'    , 'orig')  = Pimport(primary,'quantity');
compare(primary,'export'    , 'orig')  = Pexport(primary,'quantity');
compare(primary,'price'     , 'orig')  = Pdemand(primary,'price');
compare(primary,'impprice'  , 'orig')  = Pimport(primary,'price')-Tax(pImport, IMPORTpS, primary);
compare(primary,'expprice'  , 'orig')  = Pexport(primary,'price');


compare(secondary,'dom_demand', 'orig')  = sdemand(secondary,'quantity');
compare(secondary,'import'    , 'orig')  = simport(secondary,'quantity');
compare(secondary,'export'    , 'orig')  = sexport(secondary,'quantity');
compare(secondary,'price'     , 'orig')  = sdemand(secondary,'price');
compare(secondary,'impprice'  , 'orig')  = simport(secondary,'price')-Tax(sImport, IMPORTSS, secondary);
compare(secondary,'expprice'  , 'orig')  = sexport(secondary,'price');

compare(alli,item, 'ratio') $compare(alli, item,'orig')
       = compare(alli,item, 'simul')/ compare(alli,item, 'orig');

display balance, pdemand, compare;

execute_unload 'Validation.gdx' compare    ;
execute "gdxxrw Validation.gdx par= compare rng=Validation!A1 rdim= 2"

$offdotl
