clear;close all;
expdir = '/Users/csi/MITgcm_UC/exps_aofd/no_seaice/';
expname_old = 'res2km_Ua-5Va5_Atide0_Hi0Ai0_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_shelfice_ErestWrest_ardbeg';
expname_new = 'res2km_Ua-5Va5_Atide0_Hi0Ai0_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_shelfice_ErestWrest_ardbeg_prod';


expiter = 1669553;

useSEAICE = false;

initialize_3DuvtspIce (expdir,expname_old,expname_new,expiter,useSEAICE);

