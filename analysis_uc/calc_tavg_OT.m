
    close all;clear;
    addpath functions/
    addpath colormaps/
    expdir = '/Users/csi/MITgcm_UC/exps_aofd/seaice_boundary/';
    expname = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_kmax0.0001_prod'
    prodir = [expdir expname '/'];

    tmin = 0;
    tmax = 5;

    avg_t
    calcOverturning_rho_Aocean (expdir,expname,prodir)