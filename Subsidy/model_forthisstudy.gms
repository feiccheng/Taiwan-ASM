$setglobal mixon
$setglobal whereisdata ".\"

$include %whereisdata%model_structure
PROCESS.up(rnwelec_proc%addson%)$Elec_Subsidy('quantity',rnwelec_proc)=Elec_Subsidy('quantity', rnwelec_proc);
PROCESS.lo(rnwelec_proc%addson%)=0;
PROCESS.up(rnwelec_proc%addson%)$(Elec_Subsidy('quantity',rnwelec_proc)=0) =inf;
DEMANDS.lo('sub_electricity')=0;
DEMANDS.up('sub_electricity')=+inf;


SOLVE SECTOR USING LP MAXIMIZING CSPS;
display sdemand;
