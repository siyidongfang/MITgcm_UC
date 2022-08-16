

    clear;close all;
    addpath functions/;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    
    prodir = ['/Users/csi/MITgcm_UC/products_uc/' exp_group '/'];
    figdir = ['/Users/csi/MITgcm_UC/figures_uc/momentum/' exp_group '/'];
    
    useSEAICE = true;

    fontsize = 17;

 
    Ycoast = 120;
    Yshelfbreak = 220;
    Ydeep = 310;
    
%     for n=1:nEXP
for n=[8 9 15]
        if(is_prod_run(n))
            clear vi vi_mass
            close all
            expname = EXPNAME{n}
            loadexp;

            %%% Zonal integal for the entire domain, excluding the zonal sponge layers 
            spongeThickness = 10;
            zonal_idx = (spongeThickness+5):(Nx-spongeThickness-5);

            calcMomBudgetFromTendency_xint
            plot_momentum_ocean

            calcMomBudget_ice_xint
            plot_momentum_seaice
        end
    end