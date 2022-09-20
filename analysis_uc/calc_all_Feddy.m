
%%%
%%% calc_all_Feddy.m
%%%
%%% Calculate the eddy momentum flux

    clear;
%     close all;
    addpath functions/;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    
    prodir = ['/Users/csi/MITgcm_UC/products_uc/' exp_group '/'];
    figdir = ['/Users/csi/MITgcm_UC/figures_uc/vorticity/' exp_group '/'];
    useSEAICE = true;
    savefigure = false;
    load_colors;

%     for n=1:nEXP
for n=15
    if(is_prod_run(n))
%         close all
        expname = EXPNAME{n}
        loadexp;
        load([prodir expname '_tavg_5yrs.mat'],'VVEL','SALT','THETA','PHIHYD','VVELSLT','VVELTH',...
            'UVEL','SIuice','WVEL','WU_VEL');        
        load_spacing;
        calcFeddy;
        calcFeddy_uw;
    end
end




