
    close all;clear;
    addpath functions/
    addpath colormaps/
    expdir = '/Users/csi/MITgcm_UC/exps_aofd/shelfice_seaice/';
    expname = 'res2km_Ua-2Va2_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_prod_ardbeg'
    prodir = [expdir expname '/'];

    tmin = 0;
    tmax = 5;

    avg_t
    calcOverturning_rho_Aocean (expdir,expname,prodir)