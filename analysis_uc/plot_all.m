%%%
%%% plot_all.m
%%%
%%% A convenient script to make plots for all simulations




    %% For only one experiments
    clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;

%     expdir = '/Users/csi/MITgcm_UC/exps_aofd/shelfice_seaice/'
%     expname = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_ardbeg'

    expdir = '/Users/csi/MITgcm_UC/exps_aofd/shelfice_seaice/'
    expname = 'res5km_Ua-2Va2_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_stampede2_noGMRedi'


    loadexp;
    plot_KE_EKE_T_S_series


    nIter = 296809;
    year = num2str(4);
    
    plot_basics
    plot_shelfIce
    plot_seaice


    %% For groups of experiments 
%     
%     clear;close all;
% 
%     %%% Add path
%     addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
%     addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
%     addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
%     
%     %%% List of experiments
%     expdir = '/Users/csi/MITgcm_UC/experiments/shelfice_obcsE_orlanskiW/';
%     EXPNAME = {'res2km_Ua-4.5Va4.5_Atide0_Hi0Ai0_Ws40_strongwinds_stampede2'...
%         'res2km_Ua-4Va4_Atide0.02_Hi0Ai0_Ws40_tides_stampede2'...
%         'res2km_Ua-4Va4_Atide0_Hi0Ai0_Ws40_SHELFICEboundaryLayer_stampede2'...
%         'res2km_Ua-4Va4_Atide0_Hi0Ai0_Ws40_flatIsopyc_ardbeg'...
%         'res2km_Ua-4Va4_Atide0_Hi0Ai0_Ws40_polynya_stampede2'...
%         'res2km_Ua-4Va4_Atide0_Hi1Ai1_Ws40_ardbeg'...
%         'res2km_Ua-5Va5_Atide0_Hi0Ai0_Ws30_CDWflatBot-tiltSurf_OBbalanceFacN-1_ardbeg'...
%         'res2km_Ua-5Va5_Atide0_Hi0Ai0_Ws40_isop_ardbeg'...
%         };
% 
%     NITER =      [797258  1151596  797258  1425356  797258  1206295  927529  1752000];
%     YEAR = {num2str(4.5) num2str(6.5) num2str(4.5) num2str(8) num2str(4.5) num2str(7) num2str(5) num2str(10)};
% 
% 
% 
% %     expdir = '/Users/csi/MITgcm_UC/experiments/shelfice_double_obcs/';
% %     EXPNAME = {'res2km_Ua-4Va4_Atide0_Hi1Ai1_Ws40_stampede2'...
% %         'res2km_Ua-4Va4_Atide0_Hi0Ai0_Ws40_flatIsopyc_stampede2'...
% %         'res2km_Ua-4Va4_Atide0_Hi1Ai1_Ws40_seaice_ZcdwN380_stempede2'...
% %         'res2km_Ua-4Va4_Atide0_Hi1Ai1_Ws40_seaice_flatIsopyc_stempede2'...
% %         };
% % 
% %     NITER =      [797258  1100093  974427  1191767];
% %     YEAR = {num2str(4.5) num2str(6) num2str(5.5) num2str(6.5)};
% 
% 
%     useSHELFICE = true;
%     useSEAICE = false;
% 
%     Nexp = length(EXPNAME);
% 
%     for nn = 1:Nexp
% 
%         expname = EXPNAME{nn}
%         nIter = NITER(nn);
%         year = YEAR{nn};
%         loadexp;
% 
%         %%% Make plots!!
% %         plot_KE_EKE_T_S_series
% %         plot_basics
%     
%         if(useSHELFICE)
%             plot_shelfIce
%         end
%     
%         if(useSEAICE)
%             plot_seaice
%         end
% 
%     end
% 




