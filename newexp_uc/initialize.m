clear;close all;
% expdir = '/Users/csi/MITgcm_UC/exps_uc/seaice_boundary/';
expdir = '/Users/csi/MITgcm_UC/exps_uc/pseudo_shelfice_seaice/';
expname_old = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_melt4.15m_ardbeg_prod';
expname_new = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_melt4.15m_prod_Adv7';


expiter = 927530;

useSEAICE = true;

initialize_3DuvtspIce (expdir,expname_old,expname_new,expiter,useSEAICE);

