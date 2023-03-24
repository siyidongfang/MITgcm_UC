
    close all;clear;
    addpath functions/
    addpath colormaps/
    
    tmin = 3;
    tmax = 7;

    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;

% for ne=1:nEXP
for ne=[10 11]
% for ne=1
    expname = EXPNAME{ne}
    avg_t;
    calcOverturning_rho_Aocean (expdir,expname,prodir);
end