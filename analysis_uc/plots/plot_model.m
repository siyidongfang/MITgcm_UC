%%%
%%% plot_model.m
%%%
%%% Plot the model configuration for the undercurrent project 
%%%


    clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    load_colors;
    n =1; % Load the reference experiment
    expname = EXPNAME{n}
%     expdir = EXPDIR{nn};
%     nIter = NITER(nn);
%     year = YEAR{nn};
    loadexp;
    fontsize = 25;
    ncolor=250; % Number of color contours
    m1km = 1000;
    load_data;


    % bathycolor = hex2rgb('#958872');
    bathycolor = hex2rgb('#bcb099');
    icedraftcolor = hex2rgb('#7ba1d2');
    icetopcolor = hex2rgb('#7ba1d2');
    boxcolor = [0.85 0.85 0.85];
    % isothermcolor = [87 151 246]/255;
    isothermcolor = hex2rgb('#6756BE');
    
    %%% Calculate CDW layer properties
%     prodir = [expdir expname '/'];
%     load([prodir '/' expname '_tavg_5yrs.mat'], 'THETA','SALT','UVEL','VVEL','VVELTH','ETAN')
%     calc_basics;
    nIter = 1298541;

    %%% Read snapshot data
%     uu = rdmdsWrapper(fullfile(exppath,'/results/UVEL'),nIter);    
%     tt = rdmdsWrapper(fullfile(exppath,'/results/THETA'),nIter); 
%     ss = rdmdsWrapper(fullfile(exppath,'/results/SALT'),nIter); 
%     theta_inst = rdmdsWrapper(fullfile(exppath,'/results/T'),nIter); 
%     salt_inst = rdmdsWrapper(fullfile(exppath,'/results/S'),nIter); 
%     theta_inst(hFacC==0) = NaN; %%% Remove topography
%     salt_inst(hFacC==0) = NaN; 

    %%% Select potential temperature surface
    theta_plot = 0.5;


    %%% bathymetry and icedraft
    Hicefront = 200; %%% Depth of ice shelf frace
    h=bathy;
    fid = fopen(fullfile(exppath,'input','SHELFICEtopoFile.bin'),'r','b');
    icedraft = fread(fid,[Nx Ny],'real*8');
    
    

    %%% Grid
    [Y,X] = meshgrid(yy/1000,xx/1000);
    [YY,XX,ZZ]=meshgrid(yy/1000,xx/1000,zz/1000);
    [ZZZ,YYY] = meshgrid(zz/1000,yy/1000);

    %%% Extract zonal boundary values
    idx_1 = 1;
    BC_u = squeeze(uu(idx_1,:,:));
    BC_u(BC_u==0) = NaN;
    BC_t = squeeze(tt(idx_1,:,:));
    BC_s = squeeze(ss(idx_1,:,:));
    %%% Calculate the restoring neutral density at the zonal boundaries
    lon_sec = -115;
    lat_sec = -71;
    [SA_BC, in_ocean] = gsw_SA_from_SP(BC_s,-ZZZ,lon_sec,lat_sec);
    T_insitu = gsw_t_from_pt0(SA_BC,BC_t,-ZZZ);
    CT_east = gsw_CT_from_pt(SA_BC,BC_t); 
    for jj = 1:Ny
        [gamma_n_east(jj,:)] = eos80_legacy_gamma_n(BC_s(jj,:),T_insitu(jj,:),-zz,lon_sec,lat_sec);
    end






    %%




    %%% Plot bathymetry and ice draft
    figure(1)
    set(gcf,'Position',[1  107 1475 1139])
    clf;    
    
    %%% Bathymetry  
    p = surface(X(:,2:end-1),Y(:,2:end-1),-h(:,2:end-1)/1000);
    p.FaceColor = [11*16+9 9*16+12 6*16+11]/255;
    p.FaceColor = bathycolor;
    p.EdgeColor = 'none';
    
    %%% Modified ice draft to look good in the plot
    icedraft_plot = icedraft;
    icedraft_plot(icedraft==0) = NaN;
    icetop_plot = 0*icedraft_plot;
    for i=1:Nx
    j = find(~isnan(icetop_plot(i,:)),1,'last');
    if (isempty(j))
    continue;
    else
    icetop_plot(i,j+1) = max(-Hicefront,h(i,j+1));
    end
    end
    
    %%% Plot ice
    hold on;
    p = surface(X(:,2:end-1),Y(:,2:end-1),-icedraft_plot(:,2:end-1)/1000);
    p.FaceColor = icedraftcolor;
    p.EdgeColor = 'none';
    alpha(p,1);
    p = surface(X(:,2:end-1),Y(:,2:end-1),-icetop_plot(:,2:end-1)/1000);
    p.FaceColor = icetopcolor;
    p.EdgeColor = 'none';
    alpha(p,1);




    %%% Plot zonal boundary conditions: temperature field + neutral density
    %%% contours + thermal wind velocity

    % Plot the restoring temperature
    ZZZ(:,end)=-4;
    p_bct = surface(xx(idx_1)/1000*ones(size(YYY)),YYY,-ZZZ,BC_t);
    colormap(colormap(cmocean('balance',ncolor)))
    clim([-2.3 2.3]);
    p_bct.FaceColor = 'texturemap';
    p_bct.EdgeColor = 'none';         
    alpha(p_bct,1);
    freezeColors;

    handle_tt = colorbar(gca,'TickLabels', [ ],'Ticks', [ ]);
    set(handle_tt,'Position',[0.795    0.3    0.01    0.15]);
    annotation('textbox',[0.645 0.43 0.15 0.01],'String',{'Restoring';'temperature';['(' char(176) 'C)']},'FontSize',fontsize-1,'LineStyle','None','horizontalAlignment','right');
    annotation('textbox',[0.15 0.86 0.15 0.01],'String',{'(a)'},'FontSize',fontsize+2,'LineStyle','None');
    anno51 = annotation('textbox',[0.805 0.352 0.05 0.1],'String',{'\fontsize{22}2','\fontsize{26}','\fontsize{22}0','\fontsize{26}','\fontsize{22}-2'},'EdgeColor','none');     

% %     p_bcu = contour3(XX_bc,YY_bc,BC_u,...
% %         [-0.08:0.01:0.01],'LineColor','k','LineWidth',1.5,'ShowText','on');
% % %     colormap(redblue)
% %     caxis([-0.08 0.08]);
% 
% %     p_bcu = surface(xx(end)/1000*ones(size(YYY)),YYY,-ZZZ,BC_u);
% %     colormap(colormap(cmocean('balance',ncolor)))
% %     caxis([-0.08 0.08])
% %     p_bcu.FaceColor = 'texturemap';
% %     p_bcu.EdgeColor = 'none';         
% %     alpha(p_bcu,0.6);
% %     freezeColors;
% 
% 
%     % Add neutral density contours
% %     gamma_cntrs = [27:0.2:27.8 27.95:0.05:28.3];
% %     surfc(squeeze(YY(1,:,:)),-squeeze(ZZ(1,:,:)),gamma_n_east,gamma_cntrs,'LineColor','k','LineWidth',1.5);
% 
%     % Add restoring zonal velocity
% 





%     %%% Plot 0 degC isotherms
%     fv = isosurface(XX(:,2:end-1,:),YY(:,2:end-1,:),-ZZ(:,2:end-1,:),theta_inst(:,2:end-1,:),theta_plot);
%     p = patch(fv);
%     p.FaceColor = isothermcolor;
%     p.EdgeColor = 'none';
%     alpha(p,0.4);



    %%% Plot a slice of zonal velocity near x = -50km
    Lx_u2 = 220*m1km;
    idx_u2 = round(Lx_u2/delX(1));
    Ly_end = 280*m1km;
    Ly_start = 200*m1km;
    yidx_u2 = round(Ly_start/delY(1)):round(Ly_end/delY(1));
    uvel_slice = squeeze(uu(idx_u2,:,:));
    % uvel_slice(uvel_slice==0) = NaN;
    p = surface(xx(idx_u2)/1000*ones(length(yidx_u2),Nr),YYY(yidx_u2,:),-ZZZ(yidx_u2,:),uvel_slice(yidx_u2,:));
    p.FaceColor = 'texturemap';
%     colormap(cmocean('delta'))
    clim([-0.08 0.08]);
    p.EdgeColor = 'none';         
    alpha(p,0.9);
    freezeColors;

    handle_uc = colorbar;
    set(handle_uc,'Position',[0.58-0.03    0.22+0.06    0.01    0.15]);
    annotation('textbox',[0.42-0.02 0.34+0.06 0.15 0.01],'String',{'Zonal';'velocity';'(m/s)'},'FontSize',fontsize,'LineStyle','None','horizontalAlignment','right');
 

%     %%% Plot CDW heat flux
%     Ly_end = 280*m1km;
%     Ly_start = 2*m1km;
%     yidx_cdw = round(Ly_start/delY(1)):round(Ly_end/delY(1))+10;
%     xidx_cdw = round(160*m1km/delX(1)):round(440*m1km/delX(1));
% %     yidx_cdw = 1:Ny;
% %     xidx_cdw = 1:Nx;
%     p = surface(X(xidx_cdw,yidx_cdw),Y(xidx_cdw,yidx_cdw),0.5*ones(size(X(xidx_cdw,yidx_cdw))),-Fheat_cdw(xidx_cdw,yidx_cdw)/1e9);
%     Fmax = max(max(abs(Fheat_cdw(xidx_cdw,yidx_cdw)/1e9)));
%     caxis([-Fmax/1.2 Fmax/1.2]);
%     
%     % colormap(colormap(cmocean('balance',ncolor)))
%     colormap(redblue);
%     set(p,'FaceColor','texturemap','EdgeColor','none')
%     alpha(p,1);
% 
% 
%     %%% Plot CDW volume flux
%     svx = 7; svy = 7;
%     yidx_cdw = round(Ly_start/delY(1)):svy:round(Ly_end/delY(1))+10;
%     xidx_cdw = round(160*m1km/delX(1))-40:svx:round(440*m1km/delX(1));
% %     yidx_cdw = 1:Ny;
% %     xidx_cdw = 1:Nx;
%     curr = quiver3(xx(xidx_cdw)'/1000,yy(yidx_cdw)'/1000,0.5*ones(size(UU_cdw(xidx_cdw,yidx_cdw)')), ...
%         UU_cdw(xidx_cdw,yidx_cdw)',VV_cdw(xidx_cdw,yidx_cdw)',0*ones(size(UU_cdw(xidx_cdw,yidx_cdw)')),4);
%     curr.Color = [0 102 0]/255;
%     curr.LineWidth = 1.5;



    %%% Decorations
    hold off;
%     view(-219,47);
    view(-223,16);
    xlabel('x (km)');
    ylabel('y (km)');
    zlabel('Depth (km)');
    set(gca,'FontSize',fontsize);
    set(gca,'ZTick',[0:1:4],'fontsize',fontsize-1);
    set(gca,'YLim',[0 400]);
    set(gca,'YTick',[0:100:400],'fontsize',fontsize-1);
    set(gca,'XLim',[-300 300]);
    set(gca,'XTick',[-300:100:300],'fontsize',fontsize-1);
    set(gca, 'ZDir','reverse')
    axis tight;
    pbaspect([Lx/Ly 1 1]);
    camlight('headlight');
    lightangle(140,-34);
    lighting flat;
    box on;
    grid off;





     figdir = '/Users/csi/MITgcm_UC/figures_uc/';
     print('-dpng','-r200',[figdir 'model_ver3.png']);
    
    


