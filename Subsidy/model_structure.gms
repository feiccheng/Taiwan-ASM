*#############################################################################
*  List of Future Modifications:
*  I. Production Outside ASM:
*      (i).  Agricultural production occured outside desinated regions;
*            e.g., sugarCANE produced in TAIPEI.
*
*      (ii). Production in non-ag sector but potentially may take place
*            in agrictutural land; e.g., CATTLE produced in PASTUEE land.
*
*  --- Both (i) and (ii) are currently treated as import supply to the ag
*      sector.  We need to add another set of supply activities to
*      accomodate these production.
*
*#############################################################################
* DEMAND CURVES SPECIFICATIONS IN ASM INCLUDE THE FOLLOWING 4 CASES:
*(1) NO FINAL DEMAND:   P NE 0.0;  Q EQ 0.0;  ELAS EQ 0.0
*(2) REGULAR DEMAND:    P NE 0.0;  Q NE 0.0;  ELAS LE -0.05
*(3) HORIZONATAL DEMAND:P NE 0.0;  Q NE 0.0;  ELAS EQ 0.0 (FIXED price DEMAND)
*(4) VERTICAL DEMAND:   P NE 0.0;  Q NE 0.0;  W/ MINQ GT 0.0
* THESE SPEICIFICATIONS ALSO APPLY TO THE IMPORT ANS INPUT SUPPLY CURVES.
*#############################################################################
* turn on setglobal forest if need to run forest part
*#######################################################################

*$setglobal stoc

$ifthen setglobal stoc
$setglobal addson ,son
$endif

$ifthen not setglobal stoc
$setglobal addson
$endif



$ifthen not setglobal forest
* turn off demand side of forest primary and secondary
PDemand(forest,sditem)=0;
* need to adjust labor and input

$endif


$include %whereisdata%model_declaration
$include %whereisdata%model_macro
$include %whereisdata%model_bounds


$include %whereisdata%model_structure_facility.gms



*-------------------------------------
* Objective function
*-------------------------------------


  OBJT.. CSPS =E=
$ifthen setglobal stoc
sum(son, probability(son)*
$endif
(
*primary demand surplus, import and export
 + Pdmd + pExp - Pimp
*secondary demand surplus, import and export
 + Sdmd - Simp + Sexp  +SNdmd
* rice international trade
* + RiceDmd - RiceSup

*subtract import tariff
* -sum(primary, Tax(pImport,IMPORTPS,IMPORTP,Primary))
* -sum(secondary, Tax(sImport,IMPORTSS,IMPORTS,secondary))

* labor supply curve
 - suparea(laboravail, HIRED,HIREDS, subreg)
 + TotalProcCost
* take out the producing and processing cost
 - SUM((cbudexist(subreg, crop, period), cost),
         Cbuddata(subreg,crop,period,cost) *CROPBUDGET(subreg,crop,period)  )
 - SUM((lbudexist(subreg,livestock), cost),
         Lbuddata(subreg,livestock, cost)* LVSTBUDGET(subreg,livestock) )

 - SUM(input $(SUM(Cbudexist(subreg,crop,period),Cbuddata(subreg,crop,period,input))
              + SUM(Lbudexist(subreg,livestock),Lbuddata(subreg,livestock,input))
$ifthen setglobal forest
              +sum((subreg, forest), Fbuddata(INPUT,subreg,forest))
$endif
              ),
         inputprice(input)*BUYINPUT(input%addson%))

* land transaction cost
 - sum(maplandtrans(subreg, landtype2, landtype),
         landtrancost(landtype, landtype2)* LANDTRANS(subreg, landtype, landtype2))
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
   /SCALOBJ ;

*------------------------------------------------------------
* Part 1: balance of primary, secondary and rice international trade
*------------------------------------------------------------

*^^^^^^1.1 primary balance ^^^^^^^^^^^^^
 primaryBAL(primary%addson%)
     $((SUM(cbudexist(subreg,crop,period),Cbuddata(subreg,crop,period,primary))
$ifthen setglobal forest
      or  SUM((subreg, forest),Fbuddata(primary,subreg,forest))
$endif
      or SUM(lbudexist(subreg, livestock),Lbuddata(subreg,livestock, primary))
      or pImport(primary,"quantity") )
$ifthen.f setglobal iwantfacility
      and not f_primary(primary)
$endif.f
      )..

        - SUM(cbudexist(subreg,crop,period),
                 CROPBUDGET(subreg,crop,period)
                *Cbuddata(subreg,crop,period,primary)
                *agyieldadj(subreg,crop,period%addson%) )


$ifthen setglobal forest
         - SUM((subreg, forest),
                 FORBUDGET(subreg,forest)
                *Fbuddata(primary,subreg,forest)
                *foryieldadj(primary,subreg,forest%addson%) )
$endif
         - SUM(lbudexist(subreg, livestock),
                 LVSTBUDGET(subreg,livestock)
                *Lbuddata(subreg,livestock, primary)
                *livyieldadj(subreg,livestock%addson%) )

      +DEMANDP(primary%addson%)$PDemand(primary,"quantity")

      -IMPORTP(primary%addson%)$pImport(primary,"quantity")


      +EXPORTP(primary%addson%)$pExport(primary,"quantity")

      -SUM(processalt,PROCESS(processalt%addson%)*procbud(primary,processalt))

*      +CCCLOANP(primary%addson%)$(FARMPROD("LOANRATE",primary) GT 0)
          =L= 0. ;




*^^^^^^^^^^1.2 Secondary Balance^^^^^^^^^^^^^^^^^^
 SECONDBAL(secondary%addson%)
$ifthen.f setglobal iwantfacility
 $(not f_secondary(secondary))
$endif.f
..

         -SUM(cbudexist(subreg, crop, period),
                 CROPBUDGET(subreg,crop,period)
                *Cbuddata(subreg,crop,period,secondary)     )

$ifthen setglobal forest
         -SUM((subreg,forest),
                 FORBUDGET(subreg,forest)
                *Fbuddata(secondary,subreg,forest)     )

$endif
        -SUM(lbudexist(subreg, livestock),
                  LVSTBUDGET(subreg,livestock)
                 *Lbuddata(subreg,livestock, secondary)      )

          +DEMANDS(secondary%addson%)$(SDemand(secondary,"quantity") and (SDemand(secondary,"price")ge 0))
          -IMPORTS(secondary%addson%)$sImport(secondary,"quantity")
          +EXPORTS(secondary%addson%)$SEXPORT(secondary,"quantity")
          -DEMANDSN(secondary%addson%)$(SDemand(secondary,"quantity")and (SDemand(secondary,"price")lt 0))
*        +SUM(country, TRADECON("TAIWAN",country%addson%)
*                    $CDemand(country,"quantity"))$sameas(secondary, 'brownrice')

        -SUM(processalt,PROCESS(processalt%addson%) *procbud(secondary,processalt) )
          =E= 0. ;


*----------------------------------------------
*  Part 2: Land, Labor and other Inputs Balance
*-----------------------------------------------
*^^^^^^^^^^^2.1  year round land balance ^^^^^^^^^^^^^^^^^^^
 MAXLAND(subreg,landtype)
      $LANDAVAIL(subreg,landtype) ..

* cropland and aside land part
       + SUM(cbudexist(subreg,crop,'3'),
              CROPBUDGET(subreg,crop,'3')
             *Cbuddata(subreg,crop,'3',landtype))

        + ASIDEBUDGET(subreg,'3')$sameas(landtype, 'aside')

        + SHORTLAND(subreg, landtype)$(sameas(landtype, 'cropland') or sameas(landtype, 'aside'))

$ifthen setglobal forest
       +  SUM(forest,
             FORBUDGET(subreg,forest)
             *Fbuddata(landtype,subreg,forest))
$endif
        + SUM(lbudexist(subreg, livestock),
             LVSTBUDGET(subreg,livestock)
             *Lbuddata(subreg,livestock, landtype) )

        - sum(maplandtrans(subreg, landtype2, landtype),
             LANDTRANS(subreg, landtype2, landtype))

        +sum(maplandtrans(subreg,landtype, landtype2),
             LANDTRANS(subreg, landtype, landtype2))

         =L=
         LANDAVAIL(subreg,landtype)
            ;

*^^^^^^^^^^ 2.2 short-term cropland and aside land available balance ^^^^^^^^^^^^^^^^^^^
 MAXLAND1(subreg,landtype, period)
   $(LANDAVAIL(subreg,landtype)
     and [sameas(landtype,"cropland") or sameas(landtype, 'aside')]
     and (not sameas(period, '3')))..


             SUM(cbudexist(subreg,crop,period),
              CROPBUDGET(subreg,crop,period)
             *Cbuddata(subreg,crop,period,landtype))

             + ASIDEBUDGET(subreg,period)$sameas(landtype, 'aside')

         =L=
            SHORTLAND(subreg,landtype);


* ^^^^^^^^^^^^^2.2.1 Energy crop shortland ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

 EnergyShortLandBal(subreg,period)
   $(LANDAVAIL(subreg,'aside')
     and (not sameas(period, '3')))..


        SUM(cbudexist(subreg,crop,period),
              CROPBUDGET(subreg,crop,period)
             *Cbuddata(subreg,crop,period,'aside'))
             =L= Energyshortland(subreg);


 EnergyLandBal(subreg)
    $LANDAVAIL(subreg,'aside')..
        Energyshortland(subreg)
    +   SUM(cbudexist(subreg,crop,'3'),
              CROPBUDGET(subreg,crop,'3')
             *Cbuddata(subreg,crop,'3', 'aside'))
        =L= 0.35* LANDAVAIL(subreg,'aside');

*^^^^^^^^^^2.3 Rice land limition^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* we limit the area of rice land to be the historical max*10% as the proxy for water limits

RICELANDBAL(subreg, period)
     ..

     SUM(cbudexist(subreg,rice,period),
        CROPBUDGET(subreg,rice,period)
        *Cbuddata(subreg,rice,period,'cropland'))

         =L=
       1.1*  smax(crpmixalt,sum(rice, cropmix(subreg,rice, period, crpmixalt))) ;


*^^^^^^^^^^^^^^^^^2.4 Labor Balance^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 LABORBAL(subreg%addson%)$laboravail(subreg,"quantity")..

         sum(cbudexist(subreg, crop, period),
                  CROPBUDGET(subreg,crop,period)
                  *Cbuddata(subreg,crop,period, "labor")
                  *agyieldadj(subreg,crop,period%addson%) )

$ifthen setglobal forest
           +  SUM((forest),
                  FORBUDGET(subreg,forest)
                 *Fbuddata("LABOR",subreg,forest)
                 *foryieldadj(subreg,forest%addson%))
$endif
           +   SUM(lbudexist(subreg,livestock),
                   LVSTBUDGET(subreg,livestock)
                  *Lbuddata(subreg,livestock,'Labor')
                  *livyieldadj(subreg,livestock%addson%))
         - HIRED(subreg%addson%)
            =L= 0;


*^^^^^^^^^^^^^^^^^^^ 2.5 Input Balance ^^^^^^^^^^^^^^^^^^^^^^^^^^^
 INPUTBAL(INPUT%addson%)
   $(SUM(Cbudexist(subreg,crop,period),Cbuddata(subreg,crop,period,input))
   + SUM(Lbudexist(subreg,livestock),Lbuddata(subreg,livestock,input))
$ifthen setglobal forest
   +sum((subreg, forest), Fbuddata(INPUT,subreg,forest))
$endif
)..

        +SUM(Cbudexist(subreg,crop,period),
                 CROPBUDGET(subreg,crop,period)
                *Cbuddata(subreg,crop,period,input)
                *agyieldadj(subreg,crop,period%addson%))
$ifthen setglobal forest
        +SUM((forest),
                 FORBUDGET(subreg,forest)
                *Fbuddata(INPUT,subreg,forest)
                *foryieldadj(subreg,forest%addson%))
$endif
        +SUM(Lbudexist(subreg,livestock),
                 LVSTBUDGET(subreg,livestock)
                *Lbuddata(subreg,livestock,input)
                *livyieldadj(subreg,livestock%addson%))

        +SUM(processalt,PROCESS(processalt%addson%)*procbud(INPUT,processalt))

$ifthen.f setglobal iwantfacility
        +SUM(domain_for_PROCESS_REG(facility,processalt,allregions%addson%),
                    PROCESS_REG(facility,processalt,allregions%addson%)
                   *procbud(INPUT,processalt))
$endif.f
        -BUYINPUT(INPUT%addson%)
          =L= 0. ;

*---------------------------------------------------------
* Part 3: Mix of crops and livestocks
*-------------------------------------------------------

$ifthen.a setglobal mixon

*^^^^^^^^^^^^^^^3.1 crop mix lower bound ^^^^^^^^^^^^^^^^^^^^^

 MIXREGLOWER(cropinmix,subreg,period)
        $SUM(crpmixalt,cropmix(subreg, cropinmix, period, crpmixalt))..

         sum((mapcropmix(crop, cropinmix),landtype),
             CROPBUDGET(subreg,crop,period)
             *Cbuddata(subreg,crop,period,landtype))
        =G=
           0.95*SUM(crpmixalt,
               cropmix(subreg, cropinmix, period, crpmixalt)
                 *MIXR(subreg,crpmixalt,period))
      ;

*^^^^^^^^^^^^^^^3.2 crop mix upper bound
 MIXREGUPPER(cropinmix,subreg,period)
        $SUM(crpmixalt,cropmix(subreg, cropinmix, period, crpmixalt))..

         sum((mapcropmix(crop, cropinmix),landtype),
             CROPBUDGET(subreg,crop,period)
             *Cbuddata(subreg,crop,period,landtype))
        =L=
           1.05*SUM(crpmixalt,
               cropmix(subreg, cropinmix, period, crpmixalt)
                 *MIXR(subreg,crpmixalt,period))

       ;


*^^^^^^^^^^^^^^^3.3 Livestock lower bound ^^^^^^^^^^^^^^^^^^^^^

 MIXNATLOWER(livestock,subreg)
            $SUM(natmixalt,livemix(subreg,livestock,natmixalt))..

       LVSTBUDGET(subreg,livestock)
          =G= 0.90*
             SUM(natmixalt,
                 livemix(subreg,livestock,natmixalt)*NATMIX(subreg,natmixalt))
       ;

*^^^^^^^^^^^^^^3.4 Livestock upper bound
 MIXNATUPPER(livestock,subreg)
            $SUM(natmixalt,livemix(subreg,livestock,natmixalt))..

        LVSTBUDGET(subreg,livestock)
          =L= 1.1*
             SUM(natmixalt,
                 livemix(subreg,livestock,natmixalt)*NATMIX(subreg,natmixalt))
        ;

$ifthen setglobal forest
 MIXfor(primary,subreg)
            $SUM(natmixalt,forMIXDATA(natmixalt,subreg,primary))..
        SUM((forest)$(Fbuddata(primary,subreg,forest) gt 0),
                FoRBUDGET(subreg,forest)
                *Fbuddata(primary,subreg,forest)     )
         - SUM(natmixalt,
             forMIXDATA(natmixalt,subreg,primary)*forMIX(primary,natmixalt))
         + tolr(primary,subreg)
          =E= 0.;
$endif

$endif.a

*----------------------------------------------------------------
*    Part 4: SEPERABLE PROGRAMING CONVEXITY CONSTRAINTS
*------------------------------------------------------
* ^^^^^^^^^^^^ 4.1 Primary demand Identity ^^^^^^^^^^^^^^^^^^^^^
PDEMIDENT(primary%addson%)$(PDemand(primary,"elasticity") LT -0.05)..

   SUM(steps$(PDemand(primary,"TFAC") GE 1/qinc(steps)),
             qinc(steps)*PDemand(primary,"quantity")*DEMANDPS(primary,steps%addson%))
                      =l= DEMANDP(primary%addson%);

* ^^^^^^^^^^^^^ 4.2 primary demand convexity ^^^^^^^^^^^^^^^^^^^
PDEMCONVEX(primary%addson%)$( PDemand(primary,"elasticity") lT -0.05)..

   SUM(steps$(PDemand(primary,"TFAC") GE 1/qinc(steps)),
                      DEMANDPS(primary,steps%addson%)) =L= 1.;


* ^^^^^^^^^^^^^ 4.3 Primary import identity ^^^^^^^^^^^^^^^^^^^^^^^
PIMPIDENT(primary%addson%)
    $( pImport(primary,"elasticity") GT 0.05)..

  -SUM(steps,qinc(steps)*pImport(primary,"quantity")
             *IMPORTPS(primary,steps%addson%))
                  =l= -IMPORTP(primary%addson%);

* ^^^^^^^^^^^^^^^ 4.4. primary import convexity ^^^^^^^^^^^^^^^^^^^^^
PIMPCONVEX(primary%addson%)
      $( pImport(primary,"elasticity") GT 0.05 )..

          SUM(steps,IMPORTPS(primary,steps%addson%)) =L= 1.;


*^^^^^^^^^^^^^^^^ 4.5 Secondary Demand Identity ^^^^^^^^^^^^^^^^^
SDEMIDENT(secondary%addson%)$( SDemand(secondary,"elasticity") LT -0.05)..

   SUM(steps$(SDemand(secondary,"TFAC") GE 1/qinc(steps)),
          qinc(steps)*SDemand(secondary,"quantity")*DEMANDSS(secondary,steps%addson%))
                 =l= DEMANDS(secondary%addson%);

* ^^^^^^^^^^^^^^^ 4.6 Secondary Demand Convexity ^^^^^^^^^^^^^^^^^^^^^^^^
SDEMCONVEX(secondary%addson%)$( SDemand(secondary,"elasticity") LT -0.05)..

               SUM(steps$(SDemand(secondary,"TFAC") GE 1/qinc(steps)),
                         DEMANDSS(secondary,steps%addson%)) =L= 1.;

*^^^^^^^^^^^^^^^^ 4.7 Secondary Import Identity ^^^^^^^^^^^^^^^^^^^^^
SIMPIDENT(secondary%addson%)
    $( sImport(secondary,"elasticity") GT 0.05)..

  -SUM(steps,qinc(steps)*sImport(secondary,"quantity")
             *IMPORTSS(secondary,steps%addson%))
                  =l= -IMPORTS(secondary%addson%);

* ^^^^^^^^^^^^^^^^ 4.8 Secondary Import Convexity ^^^^^^^^^^^^^^^^^^^
SIMPCONVEX(secondary%addson%)
      $( sImport(secondary,"elasticity") GT 0.05)..

          SUM(steps,IMPORTSS(secondary,steps%addson%)) =L= 1.;

*^^^^^^^^^^^^^^^^^^ 4.9 Labor Identity ^^^^^^^^^^^^^^^^^^^^^^^^^^
 LABRIDENT(subreg%addson%)
        $(laboravail(subreg,"elasticity") GT 0.05)..

   -SUM(steps,qinc(steps)*laboravail(subreg,"quantity")
          *HIREDS(subreg,steps%addson%))
    =l= -HIRED(subreg%addson%);

*^^^^^^^^^^^^^^^^^^ 4.10 Labor Convexity ^^^^^^^^^^^^^^^^^
   LABRCONVEX(subreg%addson%)$(laboravail(subreg,"elasticity") GT 0.05)..

           SUM(steps,HIREDS(subreg,steps%addson%)) =L= 1.;


$ifthen not setglobal calibration
PROCESSLimit(processalt%addson%)
     $(proc_upper(PROCESSALT))..

      PROCESS(processalt%addson%)
$ifthen.f setglobal iwantfacility
    + SUM(domain_for_PROCESS_REG(facility,processalt,allregions%addson%),
                     PROCESS_REG(facility,processalt,allregions%addson%)
                   )
$endif.f
        =L=proc_upper(PROCESSALT) ;

PROCESSLimit2(primary%addson%)
     $(maxuse(primary))..

$ifthen.f setglobal iwantfacility
    - sum(processalt$(sum(link_facility_proc(facility, processalt),1)=0),
                procbud(primary,processalt)* PROCESS(processalt%addson%))
    - SUM(domain_for_PROCESS_REG(facility,processalt,allregions%addson%),
                    PROCESS_REG(facility,processalt,allregions%addson%)
                   *procbud(primary,processalt))
$else.f
            - sum(processalt,
                procbud(primary,processalt)* PROCESS(processalt%addson%))
$endif.f

        =L=  maxuse(primary)*1.0;
$endif





Option iterlim = 400000;
option solveopt=replace;
option nlp=minos;
*option lp=osl;
*option nlp=gamschk;
MODEL SECTOR /ALL/;
sector.scaleopt=1;
*option solprint=off;
option limrow = 0
option limcol = 0
*Option iterlim = 400000000;
OPTION RESLIM = 200000;

file gckfile "gamschk file"  /%system.fn%.gck/;
put gckfile;
$onput

ANALYSIS

postopt
variable
DEMANDSN
    DEMANDS(biochar)
DEMANDS(CARBONEMS)
DEMANDS(CARBONrelease)
DEMANDS(elec*)
DEMANDS(rnw*)
process(convert_RNW_elec)
process(convert_coal_elec)
process(proc_coal_elec)
process(PYROLYSIS_swp_torr)
process(PYROLYSIS_swp_slow)
equation
PROCESSLimit2
    SECONDBAL(biochar)
 SECONDBAL(electricity)
 SECONDBAL(RNW_ELECTRICITY)
 SECONDBAL(rnw*)
 SECONDBAL(CARBONEMS)
 SECONDBAL(CARBONrelease)

$offput
putclose;

option lp=gamschk;

$ifthen.f setglobal iwantfacility
SOLVE SECTOR USING MIP MAXIMIZING CSPS;
$else.f
SOLVE SECTOR USING LP MAXIMIZING CSPS;
$endif.f
