
    close all;clear;
    addpath functions/
    addpath colormaps/
    
    exp_group = 'seaice_boundary'
    expdir = ['/Users/csi/MITgcm_UC/exps_uc/' exp_group '/'];
    prodir = ['/Users/csi/MITgcm_UC/products_new/' exp_group '/'];

    expname = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed0Htr200_Zn350Zsb550dZs150_prod_Adv7'

    tmin = 2;
    tmax = 7;

    avg_t
    calcOverturning_rho_Aocean (expdir,expname,prodir)