
    close all;clear;
    addpath functions/
    addpath colormaps/
    
    tmin = 5;
    tmax = 9;

    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{2}
    list_exps_new;

% for n=1:nEXP
for n=[3]
    expname = EXPNAME{n}
    avg_t;
    calcOverturning_rho_Aocean (expdir,expname,prodir);
end