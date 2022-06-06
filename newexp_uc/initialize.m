clear;close all;
expdir = '/Users/csi/MITgcm_UC/exps_aofd/shelfice_seaice/';
expname_old = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_ardbeg';
expname_new = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_ardbeg_prod';


expiter = 1298542;

useSEAICE = true;

initialize_3DuvtspIce (expdir,expname_old,expname_new,expiter,useSEAICE);

