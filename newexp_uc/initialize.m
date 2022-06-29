clear;close all;
expdir = '/Users/csi/MITgcm_UC/exps_aofd/shelfice_seaice/';
expname_old = 'res2km_Ua-8Va8_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_stampede2';
expname_new = 'res2km_Ua-8Va8_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_prod_ardbeg';


expiter = 1261440;

useSEAICE = true;

initialize_3DuvtspIce (expdir,expname_old,expname_new,expiter,useSEAICE);

