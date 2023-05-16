
    close all;clear;
    addpath functions/
    addpath colormaps/
    
    tmin = 0;
    tmax = 6;

    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{2}
    list_exps_new;

% for ne=1:nEXP
for ne=[2 3 4]
% for ne=2
    expname = EXPNAME{ne}
    avg_t;
    calcOverturning_rho_Aocean (expdir,expname,prodir);
end