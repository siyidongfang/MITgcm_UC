**MITgcm West Antarctic Slope Undercurrent process-oriented model (MITgcm_UC)
**

The Matlab scripts used to generate, run and analyze the MITgcm simulations.

MITgcm_UC/newexp_uc: The Matlab scripts used to generate and run the MITgcm simulations.
MITgcm_UC/analysis_uc: The Matlab scripts used to calculate products and make figures.
products.zip: The products calculated from MITgcm_UC model diagnostics and the data used to make figures for the manuscript.

All the raw data of the model output are available at: https://doi.org/10.15144/S4QP4N.

Matlab scripts for vorticity budget analysis in MITgcm_UC/analysis_uc:

- calc_all_vorticity.m: A convenient script to load experiments and calculate the vorticity budget
- functions/calc_BCvorticity_cdw_sw.m: Calculate the vorticity budget for the CDW layer and the surface layer, respectively, after interpolating the momentum budget terms onto a much finer vertical grid (3400 layers in the vertical direction).
- calc_IceShelfPressureTorque.m: Calculate the pressure torque exerted from the ice shelf to the CDW layer or the surface layer.
- functions/calc_BCvorticity_ISPT.m: Calculate the decomposition of the pressure torque in the vorticity budget, including the ice-shelf pressure torque, bottom pressure torque, and interfacial pressure torque.
- functions/calc_BCvorticity_PVint.m: Calculate the potential vorticity of the CDW layer, select PV contours, and then cumulatively integrate the vorticity budget terms for the selected area. 
- plots/fig4_new.m: Plot the vorticity budget (Extended Data Figs. 3 and 6 in the manuscript)
- plots/fig5_addCDWflux.m: Plot the area-integrated vorticity budget (Fig. 2 of the manuscript)
- plots/plot_stretch_new.m: Estimated pressure torques of the CDW layer using bottom vertical velocity, the vertical velocity across the upper bound of the CDW layer and the diapycnal velocity. (Extended Data Fig. 4 of the manuscript)

Feel free to contact Yidongfang Si via y_si@mit.edu if you have any questions.
