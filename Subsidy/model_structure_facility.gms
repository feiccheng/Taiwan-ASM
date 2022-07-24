$ifthen.f setglobal iwantfacility

Positive variables
TO_Region(alli,allregions, allregions)   the shipping of biomass from one reg to the other
To_Total(alli,allregions)
PROCESS_REG(facility,processalt,allregions%addson%)

;

BINARY Variables
BUILD_FACILITY(facility,allregions)  how many facility plants should I build

;

Equations
primary_RegBAL(primary,allregions%addson%)   the primary product balance if it can be processed regionally
SECOND_RegBAL(secondary,allregions%addson%)  the secondary product balance if it can be processed regionally
FACILITY_BAL(facility,allregions)            the balance of facility capacity
;

alias(subreg, subreg2);

set
domain_for_To_Total(alli,allregions)
domain_for_TO_Region(alli,allregions, allregions) 
domain_for_PROCESS_REG(facility,processalt,allregions%addson%)

;

domain_for_To_Total(primary,allregions)
    $( PDemand(primary,"quantity")+ pExport(primary,"quantity")
      +SUM(processalt$(sum(link_facility_proc(facility, processalt),1)=0),
                                             procbud(primary,processalt) )
       and subreg(allregions) ) =yes;
         
domain_for_To_Total(secondary,allregions)
    $( SDemand(secondary,"quantity")+ SExport(secondary,"quantity")
      +SUM(processalt$(sum(link_facility_proc(facility, processalt),1)=0),
                                             procbud(secondary,processalt) )
       and subreg(allregions) ) =yes;
       
domain_for_TO_Region(primary,subreg,subreg2) 
    $(haul_cost(subreg,subreg2)
     and f_primary(primary)
     and PDemand(primary,"quantity")+ pExport(primary,"quantity")=0
     )= yes;
     
domain_for_TO_Region(secondary,subreg,subreg2) 
    $(haul_cost(subreg,subreg2)
     and f_secondary(secondary)
     and sDemand(secondary,"quantity")+ SExport(secondary,"quantity")=0
     )= yes;

domain_for_PROCESS_REG(facility,processalt,subreg%addson%)
    $link_facility_proc(facility, processalt) = yes;
display domain_for_TO_Region;
*~~~~~~~~~~~~~~~~~~~~`
* modified Model Structure
*~~~~~~~~~~~~~~~~~~~

 primary_RegBAL(primary,allregions%addson%)
     $((SUM((cbudexist(subreg(allregions),crop,period)),Cbuddata(subreg,crop,period,primary))
$ifthen setglobal forest
      or  SUM((subreg(allregions), forest),Fbuddata(primary,subreg,forest))
$endif
      or SUM(lbudexist(subreg(allregions), livestock),Lbuddata(subreg,livestock, primary))
      or (pImport(primary,"quantity") and sameas(allregions, 'total'))
      or sum(domain_for_PROCESS_REG(facility,processalt,subreg%addson%),procbud(primary,processalt) )) 
      and f_primary(primary)
      )..

        - SUM(cbudexist(subreg(allregions),crop,period),
                 CROPBUDGET(subreg,crop,period)
                *Cbuddata(subreg,crop,period,primary)
                *agyieldadj(subreg,crop,period%addson%) )


$ifthen setglobal forest
         - SUM((subreg(allregions), forest),
                 FORBUDGET(subreg,forest)
                *Fbuddata(primary,subreg,forest)
                *foryieldadj(primary,subreg,forest%addson%) )
$endif
         - SUM(lbudexist(subreg(allregions), livestock),
                 LVSTBUDGET(subreg,livestock)
                *Lbuddata(subreg,livestock, primary)
                *livyieldadj(subreg,livestock%addson%) )
                
      -sum(domain_for_TO_Region(primary, subreg2, allregions),TO_Region(primary, subreg2, allregions))                        
      +sum(domain_for_TO_Region(primary, allregions, subreg2),TO_Region(primary, allregions, subreg2))
      
      +sum(domain_for_To_Total(primary,allregions), To_Total(primary, allregions))$(not sameas(allregions, 'total'))
      -sum(domain_for_To_Total(primary,subreg), To_Total(primary, subreg))$sameas(allregions, 'total')
   
      +DEMANDP(primary%addson%)$(PDemand(primary,"quantity") and sameas(allregions, 'total')) 

      -IMPORTP(primary%addson%)$(pImport(primary,"quantity")and sameas(allregions, 'total')) 


      +EXPORTP(primary%addson%)$(pExport(primary,"quantity")and sameas(allregions, 'total')) 

      -SUM(processalt$(sum(link_facility_proc(facility, processalt),1)=0 and sameas(allregions, 'total')),
                    PROCESS(processalt%addson%)*procbud(primary,processalt))
                    
      -SUM(domain_for_PROCESS_REG(facility,processalt,allregions%addson%),
                      PROCESS_REG(facility,processalt,allregions%addson%)
                     *procbud(primary,processalt))

*      +CCCLOANP(primary%addson%)$(FARMPROD("LOANRATE",primary) GT 0)
          =L= 0. ;
          

 
 SECOND_RegBAL(secondary,allregions%addson%)$f_secondary(secondary)..

         -SUM(cbudexist(subreg(allregions), crop, period),
                 CROPBUDGET(subreg,crop,period)
                *Cbuddata(subreg,crop,period,secondary)     )

$ifthen setglobal forest
         -SUM((subreg(allregions),forest),
                 FORBUDGET(subreg,forest)
                *Fbuddata(secondary,subreg,forest)     )

$endif
        -SUM(lbudexist(subreg(allregions), livestock),
                  LVSTBUDGET(subreg,livestock)
                 *Lbuddata(subreg,livestock, secondary) )

      -sum(domain_for_TO_Region(secondary, subreg2, allregions),TO_Region(secondary, subreg2, allregions))                        
      +sum(domain_for_TO_Region(secondary, allregions, subreg2),TO_Region(secondary, allregions, subreg2))
      
      +sum(domain_for_To_Total(secondary,allregions), To_Total(secondary, allregions))$(not sameas(allregions, 'total'))
      -sum(domain_for_To_Total(secondary,subreg), To_Total(secondary, subreg))$sameas(allregions, 'total')             


          +DEMANDS(secondary%addson%)$(SDemand(secondary,"quantity") and (SDemand(secondary,"price")ge 0) and sameas(allregions, 'total'))
          -IMPORTS(secondary%addson%)$(sImport(secondary,"quantity") and sameas(allregions, 'total'))
          +EXPORTS(secondary%addson%)$(SEXPORT(secondary,"quantity") and sameas(allregions, 'total'))
          -DEMANDSN(secondary%addson%)$(SDemand(secondary,"quantity")and (SDemand(secondary,"price")lt 0) and sameas(allregions, 'total'))
*        +SUM(country, TRADECON("TAIWAN",country%addson%)
*                    $CDemand(country,"quantity"))$sameas(secondary, 'brownrice')

        -SUM(processalt$(sum(link_facility_proc(facility, processalt),1)=0 and sameas(allregions, 'total')),
                        PROCESS(processalt%addson%) *procbud(secondary,processalt) )
                        
        -SUM(domain_for_PROCESS_REG(facility,processalt,allregions%addson%),
                    PROCESS_REG(facility,processalt,allregions%addson%)
                   *procbud(secondary,processalt))
          =E= 0. ;


FACILITY_BAL(facility,allregions)$SUM(domain_for_PROCESS_REG(facility,processalt,allregions%addson%),1)..     
    SUM(domain_for_PROCESS_REG(facility,processalt,allregions%addson%),
                   PROCESS_REG(facility,processalt,allregions%addson%))
    =L= BUILD_FACILITY(facility,allregions)
        *facility_cost(facility, 'CAPACITY');


$endif.f