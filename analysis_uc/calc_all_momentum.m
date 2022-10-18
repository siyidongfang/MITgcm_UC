

    clear;close all;
    addpath functions/;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    
    prodir = ['/Users/csi/MITgcm_UC/products_uc/' exp_group '/'];
    figdir = ['/Users/csi/MITgcm_UC/figures_uc/momentum/' exp_group '/'];
    
    useSEAICE = true;
    savefigure = true;


%     for n=1:nEXP
for n=26
        if(is_prod_run(n))
            clear vi vi_mass
            close all
            expname = EXPNAME{n}
            loadexp;
            load_data;
            load_spacing;

            %%% Zonal integal for the entire domain, excluding the zonal sponge layers 
            calcMomBudget_xint
            plot_momentum_ocean

            calcMomBudget_ice_xint
            plot_momentum_seaice

            calcMomBudget_xy

            calcMomBudget_uc_xint
            calcMomBudget_uc_xy

            calcMomBudget_cdw_xy
            calcMomBudget_sw_xy
            
            
        end
end


