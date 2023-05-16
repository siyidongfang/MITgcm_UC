%%%
%%% calc_all_vorticity.m
%%%

    clear;close all;
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions/;

    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{2}
    list_exps_new;
    load_constants;
    load_colors;
    
    figdir = ['/Users/csi/MITgcm_UC/figures/BCvorticity_cdw_sw/' exp_group '/'];
    useSEAICE = true;
    showfigure = true;
    savefigure = true;


for ne =[2 3 4]  
% for ne=[25]
    close all
        ne
        expname = EXPNAME{ne};
        loadexp;
        load_data;
        load_spacing;
        calc_BCvorticity_cdw_sw;
        calc_BCvorticity_PVint;
%         plot_BCvorticity_cdw_sw;
%         calc_BCvorticity_fh_lat_int;
        % calc_BCvorticity_stretching_Coriolis;
%         calc_BCvorticity_lat_rectangle_int
%         calc_BCvorticity_lat_int;
        % calc_CDW_quasi_stfn;
%         calc_BCvorticity_h_int;
        % calc_w_layers;
        % calc_zeta_cdw;
%         calc_BCvorticity_fh_int;
%         calc_BCvorticity_stfn_int;
%         calc_w;
%         calc_BCvorticity_sponge;
%         calc_BTvorticity_curl_int; 
%         calc_BTvorticity_Aint;
%         calc_BTVorticity_fh_int;
%         calc_BTvorticity_int_curl;  
        % calc_pressure_torque;
%         calc_BTvorticity_uc;
end










