*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*  upper and lower bound of inelastic product  *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

DEMANDP.up(primary%addson%)
     $(abs(Pdemand(primary, 'elasticity'))<0.05)= 2* Pdemand(primary, 'quantity');
IMPORTP.up(primary%addson%)
     $(abs(Pimport(primary, 'elasticity'))<0.05)= 2* Pimport(primary, 'quantity');
EXPORTP.up(primary%addson%)
     $(abs(Pexport(primary, 'elasticity'))<0.05)= 2* Pexport(primary, 'quantity');
DEMANDS.up(secondary%addson%)
     $(abs(Sdemand(secondary, 'elasticity'))<0.05)= 2* Sdemand(secondary, 'quantity');
IMPORTS.up(secondary%addson%)
     $(abs(Simport(secondary, 'elasticity'))<0.05)= 2* Simport(secondary, 'quantity');
EXPORTS.up(secondary%addson%)
     $(abs(Sexport(secondary, 'elasticity'))<0.05)= 2* Sexport(secondary, 'quantity');
EXPORTS.up('brownrice'%addson%) =1.1* Sexport('brownrice', 'quantity');

DEMANDP.lo(primary%addson%)
     $(abs(Pdemand(primary, 'elasticity'))<0.05)= 0.5* Pdemand(primary, 'quantity');
IMPORTP.lo(primary%addson%)
     $(abs(Pimport(primary, 'elasticity'))<0.05)= 0.5* Pimport(primary, 'quantity');

* stick the demand of swpotato to fix the price
*DEMANDP.lo('swpotato'%addson%)
*     $= Pdemand('swpotato','quantity');

EXPORTP.lo(primary%addson%)
     $(abs(Pexport(primary, 'elasticity'))<0.05)= 0.5* Pexport(primary, 'quantity');
DEMANDS.lo(secondary%addson%)
     $(abs(Sdemand(secondary, 'elasticity'))<0.05)= 0.5* Sdemand(secondary, 'quantity');
DEMANDS.lo('electricity'%addson%)
     $(abs(Sdemand('electricity', 'elasticity'))<0.05)= 0.9* Sdemand('electricity', 'quantity');
DEMANDS.lo('RNW_electricity'%addson%)
     $(abs(Sdemand('RNW_electricity', 'elasticity')))=0;

DEMANDS.up('RNW_electricity'%addson%)
     $(abs(Sdemand('RNW_electricity', 'elasticity')))=+inf;


IMPORTS.lo(secondary%addson%)
     $(abs(Simport(secondary, 'elasticity'))<0.05)= 0.5* Simport(secondary, 'quantity');
EXPORTS.lo(secondary%addson%)
     $(abs(Sexport(secondary, 'elasticity'))<0.05)= 0.5* Sexport(secondary, 'quantity');



DEMANDS.lo('CARBONEMS'%addson%) = 0;
DEMANDS.up('CARBONEMS'%addson%) = +inf;
*$ifthen not setglobal calibration
PROCESS.up(processalt%addson%)$proc_upper(PROCESSALT)  =proc_upper(PROCESSALT) ;
*$endif
