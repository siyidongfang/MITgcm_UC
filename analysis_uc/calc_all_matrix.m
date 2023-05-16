%%%
%%% calc_matrix.m
%%%
%%% Calculate the following quantities:
%%%
%%% Tot_east: total eastward transport over the slope region
%%% Vol_east: total ocean volume with eastward velocity over the slope region
%%% U_east_avg = Tot_east/Vol_east: mean undercurrent strength over the slope region
%%% Ub_east_max: maximum eastward seafloor velocity
%%% Ub_east_avg: mean eastward seafloor velocity
%%% U_east_max: maximum eastward velocity
%%% U_west_max: strongest westward velocity (negative) 
%%% Tot_west_Sv: total westward transport (negative), in Sv
%%% Tot_Sv = Tot_west_Sv + Tot_east_Sv: total zonal ocean transport (negative) 
%%% MeltRate: ice shelf melting rate

%%% Correlation coefficient between (1) total eastward transport, (2) mean
%%% undercurrent strength, (3) maximum undercurrent strength, (4) eastward
%%% heat transport associated with the undercurrent along the shelf break,
%%% (5) maximum eastward seafloor velocity 
%%% with (1) ice shelf melt rate, (2) shoreward CDW transport, (3) total
%%% westward ocean transport
%%%

    clear;close all;
    
    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions/;    
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;

    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};

    exp_group = EXP_GROUP{2}
    list_exps_new;
    load_colors;
    savefigure = true;
    showfigure = true;

% for ne=1:nEXP
% for ne =1:21
for ne=1:4
    ne
    clear yidx xidx dy dx
    expname = EXPNAME{ne};
    loadexp;
    load_constants;
    load_data;
    load_spacing;

    yidx = round(Ymin/dy):round(Ymax/dy);
    xidx = round(Xmin/dx):round(Xmax/dx); %%% exclude the eastern and western sponge layers
    
    calc_matrix_transport;
    calc_matrix_melt_rate;
    calc_matrix_surface_stress;
    calc_matrix_SSHgradient;
    calc_matrix_buoyancy_gradient;
    calc_matrix_cdw;
    calc_heat_IceShelfCavity;

end


% for n=[14:22]
%     n
%     clear yidx xidx dy dx
%     prodir = '/Users/csi/MITgcm_UC/products_uc/seaice_boundary/';
%     expname = EXPNAME{n};
%     loadexp;
%     load_constants;
%     load_data;
%     load_spacing;
% 
%     yidx = round(Ymin/dy):round(Ymax/dy);
%     xidx = round(Xmin/dx):round(Xmax/dx); %%% exclude the eastern and western sponge layers
%     
%     calc_matrix_transport;
%     calc_matrix_melt_rate;
%     calc_matrix_buoyancy_gradient;
% end


% for n=[23]
%     n
%     clear yidx xidx dy dx
%     expname = EXPNAME{n};
%     prodir = '/Users/csi/MITgcm_UC/products_new/seaice_boundary/';
%     loadexp;
%     load_constants;
%     load_data;
%     load_spacing;
% 
%     yidx = round(Ymin/dy):round(Ymax/dy);
%     xidx = round(Xmin/dx):round(Xmax/dx); %%% exclude the eastern and western sponge layers
%     
%     calc_matrix_transport;
%     calc_matrix_melt_rate;
%     calc_matrix_buoyancy_gradient;
% end


% for n=[24]
%     n
%     clear yidx xidx dy dx
%     prodir = '/Users/csi/MITgcm_UC/products_uc/seaice_boundary/';
%     expname = EXPNAME{n};
%     loadexp;
%     load_constants;
%     load_data;
%     load_spacing;
% 
%     yidx = round(Ymin/dy):round(Ymax/dy);
%     xidx = round(Xmin/dx):round(Xmax/dx); %%% exclude the eastern and western sponge layers
%     
%     calc_matrix_transport;
%     calc_matrix_melt_rate;
%     calc_matrix_buoyancy_gradient;
% end



    prodir_vorticity = '/Users/csi/MITgcm_UC/products/';


    save([prodir_vorticity 'matrix_' exp_group '.mat'],'exp_group','EXPNAME','Ymin','Ymax','Xmin','Xmax',...
        'Ub_east_max','Ub_east_avg','Ub_west_min','Ub_west_avg','Ub_avg',...
        'Ueast_transportweighted','Tot_west_Sv','Tot_Sv','Tot_east_Sv','U_west_avg','U_east_avg','u_xmean_max',...
        'Umin','Umax','U_west_avg_upper','Tot_west_upper','Vol_west_upper',...
        'MeltRate_m','MeltRate_Gt',...
        'Ug_east_transportweighted','Ug_east_avg','ug_xmean_max','Totg_east_Sv', ...
        'Fheatcdw_icefront_trough','Fheattot_icefront_trough','Fheatcdw_icefront_all','Fheattot_icefront_all',...
        'Vcdw_east','Fheatcdw_east','Fheattot_east','Ucdw_west','Ucdw_west_max',...
        'detady','TAUx','TAUy','TAUx_estimate','TAUy_estimate',...
        'Hcdw','Scdw','Tcdw','Vcdw',...
        'Tcdw_cumulative','Tc_bc_cdw','Tc_uc_cdw','Tc_bc','Tc_uc','Tc_bc_cdw_mean','Tc_uc_cdw_mean','Tc_bc_mean','Tc_uc_mean')



%     calc_matrix_combine;
%         'min_slope_2805','max_slope_2800','avg_slope_2805','avg_slope_2800',...
%         'db_463','db_490','db_520','db_547','db_575','db_603',...
