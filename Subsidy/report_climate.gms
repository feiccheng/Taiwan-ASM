$ifthen not declared energyprod

set energyprod (secondary) /biochar,ethanol,electricity,RNW_ELECTRICITY, CARBONEMS, CARBONRelease/;

parameter freport_energy_input(processalt, alli,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)  the input used in process energy only
          freport_energy_output(processalt, alli,ffscen,ethscen,elecscen,ghgscen,gcms,rcps) the outnput used in process energy only
          freport_energy_prod(secondary,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)          the energy related output
;

parameter
    freport_CROPBUDGET(subreg,crop,period,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
    freport_processed(primary,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
    freport_prod(secondary,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
    freport_acres(crop,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
    freport_Proc_Input(processalt, alli,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
    freport_Proc_Output(Processalt, alli,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
    freport_ricebch_acres(subreg,crop,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
    freport_energycrop_acres(subreg, crop,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
    freport_energycrop(subreg, primary,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
    freport_welfare(ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
    freport_acres_group(allregions, cropgroup, period,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
    freport_input_reg(input,inputcat, allregions,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
    freport_biochar_fillback(allregions,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
	freport_biochar_acres(allregions,crop,ffscen,ethscen,elecscen,ghgscen,gcms,rcps) 
    freport_demand(alli,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
    freport_price(alli,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
    freport_energyprocbud(alli,processalt,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
	freport_biochar(*,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
;


$endif

loop(mapscenario(altrun,ffscen,ethscen, elecscen, ghgscen, gcms, rcps),

freport_energy_input(energyprocess, alli,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
         =sreport_Proc_Input(energyprocess, alli,altrun)  ;
freport_energy_output(energyprocess, alli,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
         =sreport_Proc_Output(energyprocess, alli,altrun);
freport_energy_prod(energyprod,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
         =sreport_prod(energyprod,altrun)                 ;





    freport_CROPBUDGET(subreg,crop,period,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)                 =sreport_CROPBUDGET(subreg,crop,period,altrun)  ;
    freport_processed(primary,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)                             =sreport_processed(primary,altrun)              ;
    freport_prod(secondary,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)                                =sreport_prod(secondary,altrun)                 ;
    freport_acres(crop,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)                                    =sreport_acres(crop,altrun)                     ;
    freport_Proc_Input(processalt, alli,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)                   =sreport_Proc_Input(processalt, alli,altrun)    ;
    freport_Proc_Output(Processalt, alli,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)                  =sreport_Proc_Output(Processalt, alli,altrun)   ;
    freport_ricebch_acres(subreg,crop,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)                     =sreport_ricebch_acres(subreg,crop,altrun)      ;
    freport_energycrop_acres(subreg, crop,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)                 =sreport_energycrop_acres(subreg, crop,altrun)  ;
    freport_energycrop(subreg, primary,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)                    =sreport_energycrop(subreg, primary,altrun)     ;
    freport_welfare(ffscen,ethscen,elecscen,ghgscen,gcms,rcps)                                       =sreport_welfare(altrun)                        ;
    freport_acres_group(allregions, cropgroup, period,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)     =sreport_acres_group(allregions, cropgroup, period,altrun) ;
    freport_input_reg(input,inputcat, allregions,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)          =sreport_input_reg(input,inputcat, allregions,altrun)      ;
    freport_biochar_fillback(allregions,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)                   =sreport_biochar_fillback(allregions,altrun)               ;
	freport_biochar_acres(allregions,crop,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)		         =sreport_ricebch_acres(allregions,crop,altrun)				;
    freport_demand(alli,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)                                   =sreport_demand(alli,altrun)                               ;
    freport_price(alli,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)                                    =sreport_price(alli,altrun)                                ;
    freport_energyprocbud(alli,processalt,ffscen,ethscen,elecscen,ghgscen,gcms,rcps)                 =sreport_energyprocbud(alli,processalt,altrun)             ;


);
freport_energy_prod('RNW_ELECTRICITY',ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
         =sum(energyprocess,
                 freport_energy_output(energyprocess,'RNW_ELECTRICITY',ffscen,ethscen, elecscen, ghgscen, gcms, rcps))     ;
	
freport_energy_prod('biochar',ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
         =sum(energyprocess,
                 freport_energy_output(energyprocess,'biochar',ffscen,ethscen, elecscen, ghgscen, gcms, rcps))     ;			 
				 
freport_biochar('fillback_amount_rice',ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
		=freport_biochar_fillback('total',ffscen,ethscen,elecscen,ghgscen,gcms,rcps);
		
freport_biochar('fillback_acres',ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
		=sum(crop, freport_biochar_acres('total',crop,ffscen,ethscen,elecscen,ghgscen,gcms,rcps));			

freport_biochar('fillback_unituse',ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
		$freport_biochar('fillback_acres',ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
		=freport_biochar('fillback_amount_rice',ffscen,ethscen,elecscen,ghgscen,gcms,rcps)
		/freport_biochar('fillback_acres',ffscen,ethscen,elecscen,ghgscen,gcms,rcps);
		
freport_biochar('total',ffscen,ethscen,elecscen,ghgscen,gcms,rcps)		
		=freport_energy_prod('biochar',ffscen,ethscen,elecscen,ghgscen,gcms,rcps);
		
freport_biochar('burned',ffscen,ethscen,elecscen,ghgscen,gcms,rcps)		
		=freport_Proc_Input('proc_biochar_elec','biochar',ffscen,ethscen,elecscen,ghgscen,gcms,rcps);		
	
freport_biochar('fillback_other',ffscen,ethscen,elecscen,ghgscen,gcms,rcps)		
		=freport_Proc_Input('proc_biochar_fillback','biochar',ffscen,ethscen,elecscen,ghgscen,gcms,rcps);				 

execute_unload 'report.gdx' freport_energycrop_acres freport_energycrop freport_energy_input freport_energy_output freport_energy_prod freport_welfare freport_acres_group
                            freport_input_reg,freport_biochar_fillback,freport_CROPBUDGET, freport_demand, freport_price, freport_energyprocbud freport_biochar;

execute "gdxxrw report.gdx par=freport_energycrop_acres rng=Energycrop_Acre!A1 rdim=2 cdim=6  par=freport_energycrop rng=Energycrop_Prod!A1 cdim=6 par=freport_energy_input rng=Input_proc!A1 cdim=6"
execute "gdxxrw report.gdx par=freport_energy_output rng=Output_Proc!A1 cdim=6 par=freport_energy_prod rng=TotalProd!A1 cdim=6  par=freport_welfare rng=Welfare!A1 cdim=6"
execute "gdxxrw report.gdx par=freport_acres_group rng=Output_Crop_Acres!A1 cdim=6 par=freport_input_reg rng=Input!A1 cdim=6 par=freport_biochar_fillback rng=biocharfillback!A1 cdim=6 "
execute "gdxxrw report.gdx par=freport_demand rng=Demand!A1 cdim=6 par=freport_price rng=Price!A1 cdim=6 par=freport_energyprocbud rng=PROCbud!A1 cdim=6"
execute "gdxxrw report.gdx par=freport_biochar rng=Biochar_all!A1 cdim=6" 