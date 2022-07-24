

set inputcat      the input used in each catergory
      /crops, livestock, proc, total/;
parameter report_processed(primary)                              the total primary product used in process
          report_prod(secondary)                                 the total seconary product produced in processes
          report_acres(crop)                                     the total acres of crops
          report_Proc_Input(processalt, alli)                    the prod processed by process
          report_Proc_Output(Processalt, alli)                   the prod producted by process
          report_ricebch_acres(allregions,crop)                      the rice using biochar
          report_energycrop_acres(allregions, crop)                  the energy crops
          report_energycrop(allregions, primary)                     the energy input resource
          report_welfare                                         the total welfare
          report_acres_group(allregions, cropgroup, period)      the acres of crops by regions and crop group
          report_input_reg(input,inputcat, allregions)           the input used in each category by region
          report_biochar_fillback(allregions)                    the total biochar in the rice field
          report_demand(alli)                                    the total demand
          report_price(alli)                                     primary and secondary price

;



parameter
    sreport_CROPBUDGET(subreg,crop,period,altrunsall)                    the crop land usage by scenarios
    sreport_processed(primary,altrunsall)                                the total primary product used in process
    sreport_prod(secondary,altrunsall)                                   the total seconary product produced in processes
    sreport_acres(crop,altrunsall)                                       the total acres of crops
    sreport_Proc_Input(processalt, alli,altrunsall)                      the prod processed by process
    sreport_Proc_Output(Processalt, alli,altrunsall)                     the prod producted by process
    sreport_ricebch_acres(allregions,crop,altrunsall)                        the rice using biochar
    sreport_energycrop_acres(allregions, crop,altrunsall)                    the energy crops
    sreport_energycrop(allregions, primary,altrunsall)                       the energy input resource
    sreport_welfare(altrunsall)                                          the total welfare
    sreport_acres_group(allregions, cropgroup, period,altrunsall)        the acres of crops by regions and crop group
    sreport_input_reg(input,inputcat, allregions,altrunsall)             the input used in each category by region
    sreport_biochar_fillback(allregions,altrunsall)                      the biochar send back to the rice field
    sreport_demand(alli,altrunsall)                                      total demand
    sreport_price(alli,altrunsall)                                       price




;
