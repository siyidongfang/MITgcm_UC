%%%
%%% calc_all_vorticity.m
%%%

    clear;close all;
    addpath functions/;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    
    prodir = ['/Users/csi/MITgcm_UC/products_new/' exp_group '/'];
    figdir = ['/Users/csi/MITgcm_UC/figures_uc/vorticity/' exp_group '/'];
    useSEAICE = true;
    savefigure = false;

%     for n=1:nEXP
for n=1
    if(is_prod_run(n))
        close all
        expname = EXPNAME{n}
        loadexp;
        load_data;
        load_spacing;

        calc_BCvorticity_cdw_sw;
%         calc_BTvorticity_curl_int; 
%         calc_BTvorticity_Aint;
%         calc_BTVorticity_fh_int;
%         calc_BTvorticity_int_curl;  
%         calc_pressure_torque;
%         calc_BTvorticity_uc;
    end
end








