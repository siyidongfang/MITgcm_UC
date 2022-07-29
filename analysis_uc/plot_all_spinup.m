%%%
%%% plot_all_spinup.m
%%%
%%% A convenient script to make plots for all simulations


    % For only one experiments
    clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/customcolormap/;



    expdir = '/Users/csi/MITgcm_UC/exps_aofd/shelfice_seaice/';
    expname = 'res2km_Ua-2Va2_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_stampede2'

    loadexp;
    plot_KE_EKE_T_S_series

    nIter = 1261440;
    year = num2str(7);
    

    tt = rdmds([exppath,'/results/THETA'],nIter);
    ss = rdmds([exppath,'/results/SALT'],nIter);
    uu = rdmds([exppath,'/results/UVEL'],nIter);
    vv = rdmds([exppath,'/results/VVEL'],nIter);
    vt = rdmds([exppath,'/results/VVELTH'],nIter);
    eta = rdmds([exppath,'/results/ETAN'],nIter);

    SHIfwFlx = rdmds([exppath,'/results/SHIfwFlx'],nIter);
    SHIhtFlx = rdmds([exppath,'/results/SHIhtFlx'],nIter);
    SHI_TauX = rdmds([exppath,'/results/SHI_TauX'],nIter);
    SHI_TauY = rdmds([exppath,'/results/SHI_TauY'],nIter);
    SHIForcT = rdmds([exppath,'/results/SHIForcT'],nIter);
    SHIForcS = rdmds([exppath,'/results/SHIForcS'],nIter);

    SIuice = rdmds([exppath,'/results/SIuice'],nIter);
    SIvice = rdmds([exppath,'/results/SIvice'],nIter);
    SIheff = rdmds([exppath,'/results/SIheff'],nIter);
    SIarea = rdmds([exppath,'/results/SIarea'],nIter);

    u_surf = uu(:,:,1);
    v_surf = vv(:,:,1);

    plot_basics
    plot_shelfIce
    plot_seaice


%     %% For groups of experiments 
%     
%     clear;close all;
% 
%     %%% Add path
%     addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
%     addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
%     addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
%     addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/customcolormap/;
% 
%     
%     list_exps;
% 
%     nEXP = length(EXPNAME);
% 
% for nn =4
% 
%         expname = EXPNAME{nn}
%         expdir = EXPDIR{nn};
%         nIter = NITER(nn);
%         year = YEAR{nn};
%        
%         loadexp;
% 
%         %%% Make plots!!
%         plot_KE_EKE_T_S_series
% %         plot_basics
% %    
% %         useSEAICE = USESEAICE(nn);
% %         useSHELFICE = USESHELFICE(nn);
% %         if(useSHELFICE)
% %             plot_shelfIce
% %         end
% %         if(useSEAICE)
% %             plot_seaice
% %         end
% 
%     end





