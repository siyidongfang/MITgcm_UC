
    close all;clear;
    addpath functions/
    addpath colormaps/
    exp_group = 'seaice_boundary'
    expdir = ['/Users/csi/MITgcm_UC/exps_uc/' exp_group '/'];
    prodir = ['/Users/csi/MITgcm_UC/products_uc/' exp_group '/'];

    expname = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_SEAICEnonLinIterMax100_prod'

    tmin = 0;
    tmax = 5;

    avg_t
    calcOverturning_rho_Aocean (expdir,expname,prodir)