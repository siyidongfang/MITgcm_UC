

    clear;close all;
    addpath functions/;
    list_exps_new
    
    prodir = '/Users/csi/MITgcm_UC/products_uc/';
    figdir = '/Users/csi/MITgcm_UC/figures_uc/momentum/';
    
    useSEAICE = true;

    blue = [0 0.4470 0.7410];
    yellow = [0.9290 0.6940 0.1250];
    purple = [0.4940 0.1840 0.5560];
    green = [0.4660 0.6740 0.1880];
    fontsize = 17;

    yup = 0.6;
    ydown = -0.6;   
    Ycoast = 120;
    Yshelfbreak = 220;
    Ydeep = 310;
    
    % for n=1:nEXP
    for n=1
        if(is_prod_run(n))
            expname = EXPNAME{n}
            expdir = EXPDIR{n};
            prodir = [expdir expname '/'];
            loadexp;

            %%% Zonal integal for the entire domain, excluding the zonal sponge layers 
            spongeThickness = 10;
            zonal_idx = (spongeThickness+5):(Nx-spongeThickness-5);

            calcMomBudgetFromTendency_xint
            calcMomBudget_ice_xint
        
            plot_momentum_ocean
            plot_momentum_seaice
        end
    end