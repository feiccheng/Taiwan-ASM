$setglobal whereisdata '..\..\source\'
$setglobal readset
$include %whereisdata%scenarios_data.gms
$dropglobal readset
set sset the scenario sets /sset1*sset10 /;
set subsidy_rules  the subsidy rules /rule1*rule10/;
singleton set subsidyhere(subsidy_rules);
set  needtorun(sset,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) the runs using sets

/
 sset1. ethbase  .elecbase      .         (ghg0*ghg113) .elec_q0.eth_q0.elec_subsidy0.rule1
 sset2. ethbase  .elecbase      .         (ghg0*ghg113) .elec_q0.eth_q0.elec_subsidy1.rule2
 sset3. ethbase  .elecbase      .         (ghg0*ghg113) .elec_q0.eth_q0.elec_subsidy2.rule3
 sset4. ethbase  .elecbase      .         (ghg0*ghg113) .elec_q0.eth_q0.elec_subsidy3.rule4
 / ;

scalar count /1/
       maxcount  the max scenario we could have;
maxcount= card(altrunsall);

display maxcount;


file writeset /'data_local_scenario_list.gms'/ ;
writeset.nj= 2;
put writeset;

put 'set mapscenario(altrunsall, ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) the scenario we need to loop' /;
put '/'/;

loop(needtorun(sset,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules),

      eth(ethscen)               $needtorun(sset,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) =yes;
      elec(elecscen)             $needtorun(sset,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) =yes;
      ghg(ghgscen)               $needtorun(sset,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) =yes;
      elecq(elec_qscen)          $needtorun(sset,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) =yes;
      ethq(ethnoal_qscen)        $needtorun(sset,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) =yes;
      budget(elec_subsidyscen)   $needtorun(sset,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) =yes;
      subsidyhere(subsidy_rules) $needtorun(sset,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) =yes;

    if (count<maxcount,
            put 'altrun' count:5:0 '.' eth.tl:15 '.' elec.tl:15 '.' ghg.tl:15 '.' elecq.tl:15 '.' ethq.tl:15 '.' budget.tl:15 '.' subsidyhere.tl:15 /;

            count= count +1;
    );
 

);

put '/;' /;