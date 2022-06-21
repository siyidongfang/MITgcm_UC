%%%
%%% plot_all.m
%%%
%%% A convenient script to make plots for all simulations




    % For only one experiments
    clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;


    expdir = '/Users/csi/MITgcm_UC/exps_aofd/pseudo_shelfice_seaice/';
    expname = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_ardbeg'

    loadexp;
    plot_KE_EKE_T_S_series


    nIter = 742024;
    year = num2str(4);
    
    plot_basics
%     plot_shelfIce
    plot_seaice


    %% For groups of experiments 
    
    clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/customcolormap/;

    
    list_exps;

    nEXP = length(EXPNAME);

for nn =4

        expname = EXPNAME{nn}
        expdir = EXPDIR{nn};
        nIter = NITER(nn);
        year = YEAR{nn};
       
        loadexp;

        %%% Make plots!!
        plot_KE_EKE_T_S_series
%         plot_basics
%    
%         useSEAICE = USESEAICE(nn);
%         useSHELFICE = USESHELFICE(nn);
%         if(useSHELFICE)
%             plot_shelfIce
%         end
%         if(useSEAICE)
%             plot_seaice
%         end

    end





