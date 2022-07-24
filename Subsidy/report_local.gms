$ifthen not declared energyprod

set energyprod (secondary) /biochar,ethanol,electricity,RNW_ELECTRICITY, CARBONEMS, CARBONRelease/;

parameter freport_energy_input(processalt, alli,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)  the input used in process energy only
          freport_energy_output(processalt, alli,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules) the outnput used in process energy only
          freport_energy_prod(secondary,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)          the energy related output
;

parameter
    freport_CROPBUDGET(subreg,crop,period,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
    freport_processed(primary,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
    freport_prod(secondary,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
    freport_acres(crop,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
    freport_Proc_Input(processalt, alli,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
    freport_Proc_Output(Processalt, alli,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
    freport_ricebch_acres(subreg,crop,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
    freport_energycrop_acres(subreg, crop,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
    freport_energycrop(subreg, primary,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
    freport_welfare(ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
    freport_acres_group(allregions, cropgroup, period,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
    freport_input_reg(input,inputcat, allregions,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
    freport_biochar_fillback(allregions,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
    freport_demand(alli,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
    freport_price(alli,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
    freport_energyprocbud(alli,processalt,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
	freport_biochar_acres(allregions,crop,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
    freport_biochar(*,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)


;


$endif

display energyprocess;
loop(mapscenario(altrun,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules),

freport_energy_input(energyprocess, alli,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
         =sreport_Proc_Input(energyprocess, alli,altrun)  ;
freport_energy_output(energyprocess, alli,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
         =sreport_Proc_Output(energyprocess, alli,altrun);
freport_energy_prod(energyprod,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
         =sreport_prod(energyprod,altrun)                 ;





    freport_CROPBUDGET(subreg,crop,period,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)                 =sreport_CROPBUDGET(subreg,crop,period,altrun)  ;
    freport_processed(primary,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)                             =sreport_processed(primary,altrun)              ;
    freport_prod(secondary,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)                                =sreport_prod(secondary,altrun)                 ;
    freport_acres(crop,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)                                    =sreport_acres(crop,altrun)                     ;
    freport_Proc_Input(processalt, alli,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)                   =sreport_Proc_Input(processalt, alli,altrun)    ;
    freport_Proc_Output(Processalt, alli,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)                  =sreport_Proc_Output(Processalt, alli,altrun)   ;
    freport_ricebch_acres(subreg,crop,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)                     =sreport_ricebch_acres(subreg,crop,altrun)      ;
    freport_energycrop_acres(subreg, crop,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)                 =sreport_energycrop_acres(subreg, crop,altrun)  ;
    freport_energycrop(subreg, primary,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)                    =sreport_energycrop(subreg, primary,altrun)     ;
    freport_welfare(ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)                                       =sreport_welfare(altrun)                        ;
    freport_acres_group(allregions, cropgroup, period,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)     =sreport_acres_group(allregions, cropgroup, period,altrun) ;
    freport_input_reg(input,inputcat, allregions,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)          =sreport_input_reg(input,inputcat, allregions,altrun)      ;
    freport_biochar_fillback(allregions,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)                   =sreport_biochar_fillback(allregions,altrun)               ;
    freport_demand(alli,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)                                   =sreport_demand(alli,altrun)                               ;
    freport_price(alli,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)                                    =sreport_price(alli,altrun)                                ;
    freport_energyprocbud(alli,processalt,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)                 =sreport_energyprocbud(alli,processalt,altrun)             ;

	freport_biochar_acres(allregions,crop,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)		           =sreport_ricebch_acres(allregions,crop,altrun)				;

);

freport_energy_prod('RNW_ELECTRICITY',ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
         =sum(energyprocess,
                 freport_energy_output(energyprocess,'RNW_ELECTRICITY',ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules))
         + freport_Proc_Output('proc_biochar_elec','RNW_ELECTRICITY',ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules);
	
freport_energy_prod('biochar',ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
         =sum(energyprocess,
                 freport_energy_output(energyprocess,'biochar',ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules))     ;			 

freport_energy_prod('sub_ELECTRICITY',ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
         =sum(Processalt,
                 freport_Proc_Output(Processalt,'sub_ELECTRICITY',ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules));
	

freport_energy_output('proc_biochar_elec',alli,ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
         = freport_Proc_Output('proc_biochar_elec',alli,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules);

freport_energy_output('proc_biochar_elec',alli,ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
          $(freport_energy_output('proc_biochar_elec',alli,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)=0)
         =- freport_Proc_input('proc_biochar_elec',alli,ethscen, elecscen, ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules);
	
		
			
 
freport_biochar('fillback_amount_rice',ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
		=freport_biochar_fillback('total',ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules);
		
freport_biochar('fillback_acres',ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
		=sum(crop, freport_biochar_acres('total',crop,ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules));			

freport_biochar('fillback_unituse',ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
		$freport_biochar('fillback_acres',ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
		=freport_biochar('fillback_amount_rice',ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)
		/freport_biochar('fillback_acres',ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules);
		
freport_biochar('total',ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)		
		=freport_energy_prod('biochar',ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules);
		
freport_biochar('burned',ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)		
		=freport_Proc_Input('proc_biochar_elec','biochar',ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules);		
	
freport_biochar('fillback_other',ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules)		
		=freport_Proc_Input('proc_biochar_fillback','biochar',ethscen,elecscen,ghgscen,elec_qscen,ethnoal_qscen,elec_subsidyscen,subsidy_rules);		





execute_unload 'report.gdx' freport_energycrop_acres freport_energycrop freport_energy_input freport_energy_output freport_energy_prod freport_welfare freport_acres_group
                            freport_input_reg,freport_biochar_fillback,freport_CROPBUDGET, freport_demand, freport_price, freport_energyprocbud, Subsidy_Rules_wbud;

execute "gdxxrw report.gdx par=freport_energycrop_acres rng=Energycrop_Acre!A1 rdim=2 cdim=7  par=freport_energycrop rng=Energycrop_Prod!A1 cdim=7 par=freport_energy_input rng=Input_proc!A1 cdim=7"
execute "gdxxrw report.gdx par=freport_energy_output rng=Output_Proc!A1 cdim=7 par=freport_energy_prod rng=TotalProd!A1 cdim=7  par=freport_welfare rng=Welfare!A1 cdim=7"
execute "gdxxrw report.gdx par=freport_acres_group rng=Output_Crop_Acres!A1 cdim=7 par=freport_input_reg rng=Input!A1 cdim=7 par=freport_biochar_fillback rng=biocharfillback!A1 cdim=7 "
execute "gdxxrw report.gdx par=freport_demand rng=Demand!A1 cdim=7 par=freport_price rng=Price!A1 cdim=7 par=freport_energyprocbud rng=PROCbud!A1 cdim=7 par=Subsidy_Rules_wbud rng=Subsidy_Rules!A1 cdim=1"
