clear;close all;
expdir = '/Users/csi/MITgcm_UC/exps_uc/seaice_boundary/';
expname_old = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr0_Zn350Zsb750dZs250_stampede2';
expname_new = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr0_Zn350Zsb750dZs250_prod';


expiter = 1492828;

useSEAICE = true;

initialize_3DuvtspIce (expdir,expname_old,expname_new,expiter,useSEAICE);

