
clear;

addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires 
expname = '/ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2'
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_lores/';
prodir = '/Volumes/si/MITgcm_ASF-csi/exps_lores/ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2';

loadexp;

rho0 = 999.8;

load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext',...
'Um_Cori','Um_AdvZ3','Um_AdvRe');

%%% Grid spacing matrices
DX_xy = repmat(delX',[1 Ny]);
DY_xy = repmat(delY,[Nx 1]);
DY = repmat(delY',[1 Nr]);
DZ = repmat(delR,[Ny 1]);
DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

%%% U momentum tendency from Hydrostatic Pressure gradient
Um_dPhiX_xint = squeeze(rho0.*sum(Um_dPhiX.*DX_xyz,1));
Um_dPhiX_xzint = rho0.*sum(sum(Um_dPhiX.*hFacW.*DZ_xyz.*DX_xyz,3),1);

%%% U momentum tendency from Advection terms
Um_Advec_xint = squeeze(rho0.*sum(Um_Advec.*DX_xyz,1));
Um_Advec_xzint = rho0.*sum(sum(Um_Advec.*hFacW.*DZ_xyz.*DX_xyz,3),1);

%%% U momentum tendency from Dissipation
Um_Diss_xzint = rho0.*sum(sum(Um_Diss.*hFacW.*DZ_xyz.*DX_xyz,3),1);

%%% U momentum tendency from external forcing
Um_Ext_xzint = rho0.*sum(sum(Um_Ext.*hFacW.*DZ_xyz.*DX_xyz,3),1);

% %%% U momentum tendency from Adams-Bashforth
% AB_gU_xzint = rho0.*sum(sum(AB_gU.*hFacW.*DZ_xyz.*DX_xyz,3),1);

%%% TODO: Implicit vertical viscosity tendency (Vertical Viscous Flux of U momentum (Implicit part))

%%% U momentum tendency from Vorticity Advection
Um_AdvZ3_xzint = rho0.*sum(sum(Um_AdvZ3.*hFacW.*DZ_xyz.*DX_xyz,3),1);

%%% U momentum tendency from vertical Advection (Explicit part)
Um_AdvRe_xzint = rho0.*sum(sum(Um_AdvRe.*hFacW.*DZ_xyz.*DX_xyz,3),1);

%%% U momentum tendency from Coriolis term
Um_Cori_xzint = rho0.*sum(sum(Um_Cori.*hFacW.*DZ_xyz.*DX_xyz,3),1);

% totalchange_tendency = Um_dPhiX_xzint+Um_Advec_xzint+Um_Diss_xzint+Um_Ext_xzint+AB_gU_xzint;
totalchange_tendency = Um_dPhiX_xzint+Um_Advec_xzint+Um_Diss_xzint+Um_Ext_xzint;




    %%% Check Coriolis term
    yup = 0.2;
    ydown = -0.2; 
    fontsize = 18;
    length_int = Lx;

    blue = [0 0.4470 0.7410];
    orange = [0.8500 0.3250 0.0980];
    coral = [255 127 80]/255;
    yellow = [0.9290 0.6940 0.1250];
    gold = [255 215 0]/255;
    lightblue = [0.3010 0.7450 0.9330];
    purple = [0.4940 0.1840 0.5560];
    green = [0.4660 0.6740 0.1880];
    red = [0.6350 0.0780 0.1840];
    gray = [225 225 225]/255;
    pink = [255 153 204]/255;
    brown = [153 102 51]/255;
    olive = [107 142 35]/255;
    lightred = [249 102 102]/255;
    seagreen = [46 139 87]/255;
    

    figure(3)
    clf;    
    l0 = plot(yy/1000,-totalchange_tendency/length_int,'LineWidth',4,'color',[0.7 0.7 0.7]);
    hold on;
    l2 = plot(yy/1000,Um_Ext_xzint/length_int,'LineWidth',2,'Color',brown);
    l3 = plot(yy/1000,Um_Advec_xzint/length_int,'LineWidth',2,'Color',green);
    l4 = plot(yy/1000,Um_dPhiX_xzint/length_int,'LineWidth',2,'Color',yellow);
    l5 = plot(yy/1000,Um_Diss_xzint/length_int,'LineWidth',2,'Color',purple);
    l6 = plot(yy/1000,Um_Cori_xzint/length_int,'-.','LineWidth',2,'Color',orange);
    l20 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
    hold off;
    set(gca,'fontsize',fontsize);
    %   xlim([0 400])
    ylim([ydown yup]);
    ylabel('(N/m$^2$)', 'FontSize', fontsize,'interpreter','latex');
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    xticks([0 100 200 300 400])
    title('Ocean zonal force balance','FontSize',fontsize+2,'interpreter','latex');
    leg1 = legend([l2 l3 l4 l5 l0 l6],...
        'Ice-ocean stress',...
        'Ocean advection',...
        'Pressure gradient force',...
        'Bottom frictional stress',...
        'Residual term',...
        'Coriolis term',...
        'FontSize', fontsize-1,'interpreter','latex');
    set(leg1,'position',[0.1296    0.1190    0.25    0.14])
    legend boxon;




