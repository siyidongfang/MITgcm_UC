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
    figdir = ['/Users/csi/MITgcm_UC/figures_uc/BCvorticity_cdw_sw/' exp_group '/'];
    useSEAICE = true;
    showfigrue = true;
    savefigure = false;

% for n=12:nEXP
% for n=[1:13 23 25 26]
% for n=1
%     if(is_prod_run(n))
%         close all
n=1
        expname = EXPNAME{n}
        loadexp;
        load_data;
        load_spacing;
%         calc_BCvorticity_area_int;
%         calc_w_layers;
%         calc_zeta_cdw;
%         calc_BCvorticity_fh_int;
%         calc_w;
%         calc_BCvorticity_cdw_sw;
%         plot_BCvorticity_cdw_sw;
%         calc_BCvorticity_sponge;
%         calc_BCvorticity_stretching_Coriolis;
%         calc_BTvorticity_curl_int; 
%         calc_BTvorticity_Aint;
%         calc_BTVorticity_fh_int;
%         calc_BTvorticity_int_curl;  
%         calc_pressure_torque;
%         calc_BTvorticity_uc;
%     end
% end


% for n=[14:22 24]
%     if(is_prod_run(n))
%         close all
%         expname = EXPNAME{n}
%         prodir = '/Users/csi/MITgcm_UC/products_uc/seaice_boundary/';
%         loadexp;
%         load_data;
%         load_spacing;
% %         calc_w;
% %         calc_BCvorticity_cdw_sw;
% %         plot_BCvorticity_cdw_sw;
%     end
% end









