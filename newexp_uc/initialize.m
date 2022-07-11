clear;close all;
expdir = '/Users/csi/MITgcm_UC/exps_aofd/seaice_boundary/';
expname_old = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_kmax0.001';
expname_new = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_kmax0.001_prod';


expiter = 1484048;

useSEAICE = true;

initialize_3DuvtspIce (expdir,expname_old,expname_new,expiter,useSEAICE);

