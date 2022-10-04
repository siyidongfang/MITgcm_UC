clear;close all;
expdir = '/Users/csi/MITgcm_UC/exps_uc/no_seaice/';
expname_old = 'res2km_Ua0Va0_Atide0_Hi0Ai0_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_noIceShelfThermo';
expname_new = 'res2km_Ua0Va0_Atide0_Hi0Ai0_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_noIceShelfThermo_prod';


expiter = 1484047;

useSEAICE = true;

initialize_3DuvtspIce (expdir,expname_old,expname_new,expiter,useSEAICE);

