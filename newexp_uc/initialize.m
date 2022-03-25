clear;close all;
expdir = '/Volumes/si/MITgcm_UC/exps_uc/';
expname_old = 'ssurf33_0dS_lores_Ua0Va0_Atide0_Hi1Ai1_Ws25_init';
expname_new = 'ssurf33_0dS_lores_Ua0Va0_Atide0_Hi1Ai1_Ws25_new';


expiter = 86400;

useSEAICE = true;

initialize_3DuvtspIce (expdir,expname_old,expname_new,expiter,useSEAICE);

