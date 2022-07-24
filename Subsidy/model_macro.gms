*----------------------------------------
* the area under any demand curver
*------------------------------------------
*data: demand data
* Var: variable without steps (<= tfac)
* varsteps: variable with steps
* ps: ps or secondary; country for rice international trade

$macro dmdarea(data, var,VarStep, ps)  \
 [ SUM(ps$((data(ps,"quantity")   GT 0) AND   \
               (data(ps,"price")     ne 0) AND   \
               (data(ps,"elasticity") LT -0.05   )  ),   \
\
   + (SUM(steps$(data(ps,"tfac") GE 1/qinc(steps)),   \
            [qinc(steps) **(1./data(ps,"elasticity"))   \
                  * data(ps,"quantity")*qinc(steps)   * data(ps,"price")  \
                  * data(ps,"elasticity")   / (1.+data(ps,"elasticity"))  \
                  + data(ps,"constant1" )   + data(ps,"constant2")]   \
    *VARSTEP(ps,steps%addson%)) \
    )  )\
\
 +SUM(ps$( ( data(ps,"price")    gt 0) AND \
              (abs( data(ps,"elasticity")) LE 0.05 )\
              AND (data(ps,"quantity") GT 0 )  ), \
               data(ps,"price")*VAR(ps%addson%))]

*--------------------------
* the area under any supply curve
*------------------------------
$macro suparea(data, var, varStep, ps)  \
[+SUM(ps$((data(ps,"quantity") GT 0 )AND  \
                    (data(ps,"price")      GT 0) AND  \
                    (data(ps,"elasticity") GT 0.05 )),  \
  data(ps,"elasticity")  \
  /(1.+data(ps,"elasticity"))  \
  *(data(ps,"price")  \
  *(SUM(steps,(qinc(steps))**(1./data(ps,"elasticity"))  \
               * qinc(steps)*data(ps,"quantity") \
              *VARSTEP(ps,steps%addson%) )   ))) \
\
  +SUM((ps)$((data(ps,"price")   GT 0 )AND  \
                    (data(ps,"elasticity") LE 0.05 )AND  \
                   ( data(ps,"quantity"))  ),  \
     data(ps,"price")*VAR(ps%addson%))]


*-------------------------
*primary macros
*------------------------------

$macro PDmd dmdarea(Pdemand, DEMANDP, DEMANDPS, primary)

$macro pExp \
 [+SUM(primary$((pExport(primary,"quantity")   GT 0) AND \
             (pExport(primary,"price")      GT 0) ), \
    EXPORTP(primary%addson%)*pExport(primary,"price")) ]

$macro pImp suparea(PImport, IMPORTP, IMPORTPS, primary)

*-------------------------
*SECONDARY macros
*------------------------------

$macro Sdmd dmdarea(Sdemand, DEMANDS, DEMANDSS, secondary)
$macro SImp suparea(Simport, IMPORTS, IMPORTSS, secondary)

$macro Sexp \
 SUM(secondary$((SEXPORT(secondary,"quantity")   GT 0 )AND  \
                (SEXPORT(secondary,"price")      GT 0 )),  \
     EXPORTS(secondary%addson%)  \
   * SEXPORT(secondary,"price"))

$macro SNdmd        \
  SUM(secondary$( ( Sdemand(secondary,"price")    le 0) AND \
              (abs( Sdemand(secondary,"elasticity")) LE 0.05 )\
              AND (Sdemand(secondary,"quantity") GT 0 )  ), \
               Sdemand(secondary,"price")*DEMANDSN(secondary%addson%))


*-----------------------
* rice trade
*--------------------

$macro RiceDmd  dmdarea(cdemand, DEMANDCON, DEMANDCONS, country )
$macro RiceSup  suparea(csupply, SUPPLYCON, SUPPLYCONS, country )


*----------------------------------------
* get the price on the demand / supply curve
*-------------------------------------------
$macro price(data, varStep, ps) \
 [ +(SUM(steps$(data(ps,"tfac") GE 1/qinc(steps)), \
            [qinc(steps) **(1./data(ps,"elasticity")) * data(ps,"price")]  \
    *VARSTEP(ps,steps%addson%)) \
    )$ ((data(ps,"quantity")   GT 0 )AND \
               (data(ps,"price")      GT 0) AND \
               (abs(data(ps,"elasticity")) GT 0.05  )   ) \
\
     +data(ps,"price")$(  (data(ps,"price")      GT 0) AND \
                  ( abs(data(ps,"elasticity")) LT 0.05) \
                    AND( data(ps,"quantity") NE 0)  )]


$macro Tax(data,VarStep, ps)\
     [  (price(data, varStep, ps)/(1+ imptax(ps, 'TaxRate') )* imptax(ps, 'TaxRate'))$imptax(ps, 'TaxRate') \
    +  imptax(ps, 'TaxAmount')]


*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Process cost
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`
$ifthen.f setglobal iwantfacility
$macro TotalProcCost                                                                                     \
 [- SUM((processalt,cost)                                                                                 \       
                $(sum(link_facility_proc(facility, processalt),1)=0 ),    \
             procbud(cost,processalt)*PROCESS(processalt%addson%))                                      \                     
 - SUM((domain_for_PROCESS_REG(facility,processalt,allregions%addson%), cost),                          \
                    PROCESS_REG(facility,processalt,allregions%addson%)                                 \
                   *procbud(cost,processalt))                                                           \
 - sum((facility,subreg),                                                                               \
            BUILD_FACILITY(facility,subreg) *facility_cost(facility, 'FCOST'))                          \
 - sum(domain_for_TO_Region(alli, subreg2, allregions),                                                 \
            haul_cost(subreg2, allregions)*TO_Region(alli, subreg2, allregions))    ]                   \
$else.f

$macro TotalProcCost                                                            \
 [- SUM((processalt,cost),                                                       \
         procbud(cost,processalt)*PROCESS(processalt%addson%))]
         
$endif.f










