 POSITIVE VARIABLES
* no risk term
CROPBUDGET(subreg,crop,period)       crop BUDGETS
ASIDEBUDGET(subreg,period)           aside land budget
SHORTLAND(subreg,landtype)
LANDTRANS(subreg, landtype2, landtype)   land transfer
Energyshortland(subreg)                 energy crop land short term
*CROFBUDGET(subreg,CROF,period)       CROF BUDGETS
*SETASIDE(subreg,period,ASIDEITEM)    crop SETASIDE ACTIVITY
LVSTBUDGET(subreg,livestock)         livestock BUDGETS
$ifthen setglobal forest
forBUDGET(subreg,forest)             forest BUDGETS
treeBUDGET(subreg,forest)            ag tree BUDGETS
$endif
*LANDSUPPLY(regions,landtype)         REGIONAL LAND SUPPLY
*FAMILY(subreg)                      FAMILY LABOR SUPPLY
HIRED(subreg%addson%)                       HIRED LABOR SUPPLY
$ifthen setglobal mixon
MIXR(subreg,crpmixalt,period)        crop MIXES BY REGION
MIXR2(subreg,crpmixalt)             crop MIXES BY REGION
*MIXCA(subreg,mixa, period)           the mix of crops and aside land
*MIXRF(subreg,crpmixalt,period)       CROF MIXES BY REGION
NATMIX(subreg,natmixalt)            livestock MIXES ACROSS regions
$endif
$ifthen setglobal forest
forMIX(primary,natmixalt)            forest PRODUCT MIXES ACROSS regions
$endif
*MIXS(subreg,SETMIX,period)        SETASIDE MIXES BY REGION
* risk term
PROCESS(processalt%addson%)              PROCESSING BUDGETS
DEMANDP(primary%addson%)                 primary PRODUCT DOMESTIC DEMAND
IMPORTP(primary%addson%)                 primary PRODUCT IMPORTS
EXPORTP(primary%addson%)                 primary PRODUCT EXPORTS
DEMANDS(secondary%addson%)               secondary PRODUCT DOMESTIC DEMAND
DEMANDSN(secondary%addson%)               secondary PRODUCT DOMESTIC DEMAND with negative prices
IMPORTS(secondary%addson%)               secondary PRODUCT IMPORTS
EXPORTS(secondary%addson%)               secondary PRODUCT EXPORTS
BUYINPUT(INPUT%addson%)                  INPUT PURCHASES
CCCLOANP(primary%addson%)                primary PRODUCT CCC LOAN DEMAND
CCCLOANS(secondary%addson%)              secondary PRODUCT CCC LOAN DEMAND

*SPATIAL EQUILIBRIUM VARIABLE

*TRADECON(country,country%addson%)  EXPORT FROM country TO country
*DEMANDCON(country%addson%)         primary DEMAND FOR country
*SUPPLYCON(country%addson%)         primary SUPPLY FOR country

*seperable variable
*LANDSUPPLS(regions,landtype,steps)  REGIONAL LAND SUPPLY
HIREDS(subreg,steps%addson%)                HIRED LABOR SUPPLY
DEMANDPS(primary,steps%addson%)          primary DOMESTIC DEMAND BY STEP
IMPORTPS(primary,steps%addson%)          primary IMPORT DEMAND BY STEP
IMPORTSS(secondary,steps%addson%)          primary IMPORT DEMAND BY STEP
IMPORTPNS(primary,steps%addson%)          primary IMPORT DEMAND BY STEP
DEMANDSS(secondary,steps%addson%)        secondary DOMESTIC DEMAND BY STEP
IMPORTSNS(secondary,steps%addson%)          secondary IMPORT DEMAND BY STEP

*DEMANDCONS(country,steps%addson%)         primary DEMAND FOR country by steps
*SUPPLYCONS(country,steps%addson%)         primary SUPPLY FOR country by steps
 VARIABLES

   CSPS;

 EQUATIONS

    OBJT
    MAXLAND(subreg,landtype)     MAXIMUM LAND AVAILABLE IN A subreg (pasture and forest)
    MAXLAND1(subreg,landtype,period)      MAXIMUM LAND AVAILABLE IN A subreg (crop and aside)
    RICELANDBAL(subreg, period)    the limitation of rice land
    EnergyShortLandBal(subreg,period)  shortterm land used for energy crops
    EnergyLandBal(subreg)              total land used for energy crop less than 35 percent aside land
*    MAXLAND2(subreg,period)     MAXIMUM LAND FOR CROF
*    MINLAND(subreg)              MINIMUM cropLAND USE IN A subreg
*    LAND(regions,landtype)       REGIONAL LAND BALANCE
    LABORBAL(subreg%addson%)               REGIONAL LABOR BALANCE
*    FAMILYLIM(regions)           MAXIMUM FAMILY LABOR
*    HIRELIM(regions)             MAXIMUM HIRED LABOR
    primaryBAL(primary%addson%)      primary PRODUCT BALANCE
*    RICEPURCH                    GOVERNMENT RICE PURCHASING
    SECONDBAL(secondary%addson%)     secondary PRODUCT BALANCE

$ifthen.a setglobal mixon
    MIXREGLOWER(crop,subreg,period)   crop MIX CONSTRAINTS BY ACREAGE IN subregION
    MIXREGUPPER(crop,subreg,period)   crop MIX CONSTRAINTS BY ACREAGE IN subregION
*    MIXREGF(CROF,subreg,period)  CROF MIX CONSTRAINTS BY ACREAGE IN subregION
*    MIXREGTOTUPPER(crop, subreg)     TOTAL ACRES IN A crop MIX
*    MIXREGTOTLOWER(crop, subreg)     TOTAL ACRES IN A crop MIX
*   MIXcropASIDELOWER(subreg, period, cropaside)    the mix control of crops and aside land
*   MIXcropASIDEUPPER(subreg, period, cropaside)     the mix control of crops and aside land

    MIXNATUPPER(livestock,subreg)       livestock PRODUCT DISTRIBUTION ACCROSS regions
    MIXNATLOWER(livestock,subreg)       livestock PRODUCT DISTRIBUTION ACCROSS regions
$ifthen setglobal forest
    MIXfor(primary,subreg)       forest PRODUCT DISTRIBUTION ACCROSS regions
$endif
*    MIXSET(ASIDEITEM,subreg,period)  SETASIDE MIX CONSTRAINTS BY ACREAGE IN subregION
*    MIXSETTOT(subreg,period)     TOTAL ACRES IN A SETASIDE MIX

$endif.a
    INPUTBAL(INPUT%addson%)          NATIONAL INPUT BALANCES

*    cccrice                  rice cccloan equation

*SPATIAL EQUILIBRIUM CONSTRAINTS
*    CEXPORTBAL(country%addson%)  SUPPLY AND DEMAND BALANCE FOR EXPORTERS
*    CIMPORTBAL(country%addson%)  SUPPLY AND DEMAND BALANCE FOR IMPORTERS
*    TAIIMPREST                       TOTAL IMPORT RESTRICTIONS

*seperable and convesity constraint

    PDEMIDENT(primary%addson%)        IDENTITY FOR primary PRODUCTS
    PDEMCONVEX(primary%addson%)       primary PRODUCT DEMAND CONVEXITY
    PIMPIDENT(primary%addson%)        IDENTITY FOR primary PRODUCTS
    PIMPCONVEX(primary%addson%)       primary PRODUCT IMPORT CONVEXITY
    SIMPIDENT(secondary%addson%)        IDENTITY FOR secondary PRODUCTS
    SIMPCONVEX(secondary%addson%)       secondary PRODUCT IMPORT CONVEXITY
    SDEMCONVEX(secondary%addson%)     secondary PRODUCT DEMAND CONVEXITY
    SDEMIDENT(secondary%addson%)      IDENTITY FOR secondary PRODUCTS
*    CDEMIDENT(country%addson%)    IDENTITY FORprimary DEMAND FOR country
*    CDEMCONVEX(country%addson%)    primary DEMAND FOR country   CONVEXITY
*    CSUPIDENT(country%addson%)    IDENTITY FORprimary SUPPLY FOR country
*    CSUPCONVEX(country%addson%)    primary SUPPLY FOR country   CONVEXITY

    LABRIDENT(subreg%addson%)            LABOR IDENTITY
    LABRCONVEX(subreg%addson%)           LABOR CONVEXITY
    PROCESSLimit(processalt%addson%)     process limits
    PROCESSLimit2(primary%addson%)       process limits of biomass  usage
    ;

