clear;close all;
expdir = ['/Users/csi/MITgcm_UC/experiments/shelfice_obcsE_orlanskiW_surfaceT/'];
expname_old = 'res2km_Ua-4.4Va4.4_Atide0_Hi0Ai0_Ws30_ardbeg';
expname_new = 'res2km_Ua-4.4Va4.4_Atide0_Hi0Ai0_Ws30_ardbeg_prod';


expiter = 1704649;

useSEAICE = false;

initialize_3DuvtspIce (expdir,expname_old,expname_new,expiter,useSEAICE);

