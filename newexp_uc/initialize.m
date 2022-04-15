clear;close all;
expdir = ['/Users/csi/MITgcm_UC/exps_uc/'];
expname_old = 'noice_ssurf33_0dS_lores_Ua-2Va2_Atide0_Hi0Ai0_Ws25_prod';
expname_new = 'noice_ssurf33_0dS_lores_Ua-2Va2_Atide0_Hi0Ai0_Ws25_orlanski4';


expiter = 1126286;

useSEAICE = false;

initialize_3DuvtspIce (expdir,expname_old,expname_new,expiter,useSEAICE);

