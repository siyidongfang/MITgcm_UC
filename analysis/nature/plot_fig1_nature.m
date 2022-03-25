%%%
%%% plot_fig1_nature.m
%%%
%%% Create a stereographic plot of seafloor salinity, with arrows to
%%% indicate barotropic ocean flow. Create two panels of hydrography from WOA, 
%%% and two panels of instantaneous isotherms in the simulations.



%%% Add path 
addpath /Users/csi/MITgcm_ASF-csi/analysis;
addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps;
addpath /Users/csi/MITgcm_ASF-csi/data_WOA18_etopo;
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng/';
prodir = '/Volumes/si/MITgcm_ASF-csi/products_cross_slope/';
figdir = './fig1_nature/';
figname = 'fig1_ver23';

%%% Initialize figure
figure(10);
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.1*scrsz(3) 0.3*scrsz(4) 1100 900]);
boxcolor = [0.85 0.85 0.85];
gray = [0.6 0.6 0.6];
darkgray = [0.45 0.45 0.45];

set(gcf,'Color','w');
fontsize = 13;
ncolor = 40; % Number of levels in the colormap

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% A stereographic plot of seafloor salinity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('ss81_winter_500m.mat');
load('AntarcticCoastline.mat')
load coastlines
worldmap('antarctica')
antarctica = shaperead('landareas', 'UseGeoCoords', true,...
  'Selector',{@(name) strcmp(name,'Antarctica'), 'Name'});

clf;
ax1 = subplot('position',[0.305 0.58 0.4 0.4]);
ann1 = annotation('textbox',[0.32 0.94 0.05 0.05],'String','a','FontSize',fontsize+1,'LineStyle','None','fontweight', 'bold');
axesm('stereo','Origin',[-90 0],'MapLatLimit',[-90 -61],'MapLonLimit',[-180 180],'FontSize',fontsize)
worldmap([-90 -61],[0 360])
axis off;
framem on;
gridm on;
mlabel on;
plabel on;
setm(gca,'MLabelParallel',[-30]) 
pcolorm(LA_ss,LO_ss,ss_bot);
% colormap(ax1,cmocean_balance_0)
% caxis([33.7 35]);
colormap(ax1,colormap(cmocean('balance',ncolor)))


% colormap(ax1, cmocean('delta'));
caxis([34.3 34.95]);

hold on
%%%%%%%%%%% Plot the 1000m depth contour
bathyhandle = plotm(cntrs_sub{1}(2,:),cntrs_sub{1}(1,:),'Color','k','LineWidth',1,'LineStyle','--'); 
%%%%%%%%%%% Plot the coastline
coasthandle = plotm(flip(antarctica.Lat),flip(antarctica.Lon),'Color','k','LineWidth',0.5,'LineStyle','-');
%%%%%%%%%%% Fill in area of continents with light gray
patchm(antarctica.Lat, antarctica.Lon, [225 225 225]/255)
hold off;
set(gca,'FontSize',fontsize);
mainpos = get(gca,'Position');
mainpos(1) = mainpos(1) - 0.02;
% handle = colorbar;
% set(handle,'Position',[0.68 0.88 0.01 0.1],...
%     'TickLength',0.04,'AxisLocation','out');
% annotation('textbox',[0.53 0.95 0.15 0.01],'String',...
%     {'Seafloor';'salinity';'(psu)'},'FontSize',fontsize,'LineStyle','None',...
%     'HorizontalAlignment', 'right');
annotation('textbox',[0.24 0.95 0.15 0.01],'String',...
    'S (psu)','FontSize',fontsize,'LineStyle','None',...
    'HorizontalAlignment', 'right');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Instantaneous isotherms: dense shelf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
    ax3 = subplot('position',[0.06 0.05 0.37 0.45]);
    ann3 = annotation('textbox',[0.05 0.45 0.05 0.05],'String','d','FontSize',fontsize+1,'LineStyle','None','fontweight', 'bold');


        
  
    expname = 'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25';
    loadexp;

    [YY,XX,ZZ]=meshgrid(yy,xx,zz);
    XX = XX / 1000;
    YY = YY / 1000;
    ZZ = ZZ / 1000;
    
    %%% Read snapshot
    nIters = 2210467;
    theta_inst = rdmdsWrapper(fullfile(exppath,'/results/T'),nIters); 
    salt_inst = rdmdsWrapper(fullfile(exppath,'/results/S'),nIters); 
    salt = rdmdsWrapper(fullfile(exppath,'/results/SALT'),nIters);    
    %     uvel = rdmdsWrapper(fullfile(exppath,'/results/UVEL'),nIters);         
    %     vvel = rdmdsWrapper(fullfile(exppath,'/results/VVEL'),nIters);
    %     uvel_inst = rdmdsWrapper(fullfile(exppath,'/results/U'),nIters);         
    %     vvel_inst = rdmdsWrapper(fullfile(exppath,'/results/V'),nIters);
    %%% Remove topography
    theta_inst(hFacC==0) = NaN;
    
    %%% Select potential temperature surface
    theta_plot = 0;
    %%% Bathymetry
    [Y,X] = meshgrid(yy,xx);  
    p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,-bathy(:,2:end-1)/1000);
%     p.FaceColor = [164 176 183]/255;
    p.FaceColor = boxcolor;
    p.EdgeColor = 'none';       
    hold on;
    zidx = 1;

    %     %%% Plot surface vorticity
    %     ff = f0+beta*YY;
    %     vort = zeros(Nx,Ny,Nr);
    %     vort(:,1:Ny-1,:) = - (uvel_inst(:,2:Ny,:)-uvel_inst(:,1:Ny-1,:))/delY(1);
    %     vort = vort + (vvel_inst([2:Nx 1],:,:)-vvel_inst(:,:,:))/delX(1);
    %     vort(hFacS==0) = 0;
    %     vort(hFacW==0) = 0;
    %     vort(hFacC==0) = 0;
    %     vort(:,Ny-1,:) = 0;
    %     vort(:,2,:) = 0;
    %     vort = vort ./ abs(ff);

    %%% Plot instantaneous surface density
    pd_surf = densmdjwf(salt_inst(:,:,1),theta_inst(:,:,1),0);
    
    p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,-1.5*ones(size(X(:,2:end-1))),pd_surf(:,2:end-1));
    caxis([1027.2 1027.6]);

    %     colormap(ax3,colormap(cmocean('balance',ncolor)))
    colormap(flipud(cmocean('ice',ncolor)));
    set(p,'FaceColor','texturemap','EdgeColor','none')
    alpha(p,1);
    freezeColors;
    
    %     handle31 = colorbar('TickLabels', [-0.1 0 0.1],'Ticks', [-0.1 0 0.1]);    
    %     set(handle31,'Position',[0.375    0.46    0.006    0.05],'TickLength',0.04,'AxisLocation','in');
    %     anno31 = annotation('textbox',[0.327 0.465 0.05 0.05],'String',...
    %         {'0.01','0','-0.01'},'FontSize',fontsize,'EdgeColor','none','HorizontalAlignment', 'right');     
    %     anno3 = annotation('textbox',[0.368 0.43 0.05 0.05],'String',...
    %         '\zeta/f','FontSize',fontsize+1,...
    %         'LineStyle','None','HorizontalAlignment', 'center');

    %     %%% Plot ocean surface current
    %     u_surf = squeeze(uvel(:,:,zidx));
    %     v_surf = squeeze(vvel(:,:,zidx));
    %     svx = 25;  % Step
    %     svy = 20;
    %     scalefactor = 70;
    %     curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:end)'/1000, ...
    %         scalefactor*u_surf(1:svx:end,1:svy:end)',scalefactor*v_surf(1:svx:end,1:svy:end)',...
    %         'AutoScale','off');
    %     curr.Color = 'k';
    %     curr.LineWidth = 1;

    %%% Isopycnal
    fv = isosurface(XX(:,2:end-1,:),YY(:,2:end-1,:),-ZZ(:,2:end-1,:),theta_inst(:,2:end-1,:),theta_plot);
    p = patch(fv);
    %     p.FaceColor = [87 151 246]/255;
    p.FaceColor = boxcolor;
    p.EdgeColor = 'none';
    alpha(p,0.5);
    hold off;

    %%% Salinity section
    i_end = Nx;
    salt_end = squeeze(salt(i_end,:,:));
    salt_end(salt_end==0) = NaN;
    [ZZZ,YYY] = meshgrid(zz,yy);
    zz_i = -H+5:10:-5;
    Nz_i = length(zz_i);
    [ZZZ_i,YYY_i] = meshgrid(zz_i,yy);
    salt_i = zeros(Ny,Nz_i);
    for j=1:Ny
        salt_i(j,:) = interp1(zz,salt_end(j,:),zz_i,'linear');
        salt_i(j,end)=salt_i(j,end-1);
        nNaN = sum(isnan(salt_i(j,:)));
        for nn = 1:nNaN
            salt_i(j,nn) = salt_i(j,nNaN+1);
        end
    end

    p = surface(xx(i_end)/1000*ones(size(YYY_i)),YYY_i/1000,-ZZZ_i/1000,salt_i);
    p.FaceColor = 'texturemap';
    colormap(ax3, cmocean('balance',ncolor));
    %     colormap(ax3, cmocean('delta',ncolor));
    caxis([34.3 34.95]);
    p.EdgeColor = 'none';         
    alpha(p,1);
   
    %   colormap(pmkmp(56,'Swtth'));
    %   colormap(cmocean('thermal',56));
    
    %%% Temperature contours
%     hold on;
%     contour3(i_end*ones(Nx,Ny,Nr),YY/1000,-ZZ/1000,squeeze(theta(i_end,:,:)),[-0.5:0.5:1],'-','EdgeColor',gray,'LineWidth',1);
%     contour3(i_end*ones(Nx,Ny,Nr),YY/1000,-ZZ/1000,squeeze(theta(i_end,:,:)),[0 0],'EdgeColor',gray,'LineWidth',2);
%     hold off;


    %%% Decorations
%     view(-108.7927,10.6613);
    view(-116.5,13);
    axis tight;
    xlabel('x (km)');
    ylabel('y (km)');
    zlabel('Depth (km)');
    set(gca,'XLim',[-200 200]);
    set(gca,'XTick',[-200:100:200]);
    set(gca,'YLim',[0 450]);
    set(gca,'YTick',[0:100:450]);
    set(gca,'ZLim',[-1.5 4]);
    set(gca,'ZTick',[0:1:4]);
    set(gca, 'ZDir','reverse')
    set(gca,'FontSize',fontsize);
    set(gca,'TickDir','out','TickLength',[0.01 0.02]);
    pbaspect([Lx/Ly 1 0.9]);
    %     handle32 = colorbar;
    %     set(handle32,'Position',[0.38    0.23    0.01    0.1],'TickLength',0.04,'AxisLocation','in');
    annotation('textbox',[0.06 0.155 0.15 0.01],'String',['S (psu)'],'FontSize',fontsize,'LineStyle','None');

    annotation('textbox',[0.15 0.26 0.15 0.01],'String',['0' char(176) 'C isotherms'],'FontSize',fontsize,'LineStyle','None');
    camlight('headlight');
    lightangle(ax3,-50,-38);
    lighting gouraud;
    box on;
    

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Instantaneous isotherms: fresh shelf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ax5 = subplot('position',[0.59 0.05 0.37 0.45]);
    ann5 = annotation('textbox',[0.6 0.45 0.05 0.05],'String','e','FontSize',fontsize+1,'LineStyle','None','fontweight', 'bold');


    
    expname = 'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25';
    loadexp;

    [YY,XX,ZZ]=meshgrid(yy,xx,zz);
    XX = XX / 1000;
    YY = YY / 1000;
    ZZ = ZZ / 1000;
    
    %%% Read snapshot
    nIters = 2200186;
    theta_inst = rdmdsWrapper(fullfile(exppath,'/results/T'),nIters);  
    salt_inst = rdmdsWrapper(fullfile(exppath,'/results/S'),nIters);    
    salt = rdmdsWrapper(fullfile(exppath,'/results/SALT'),nIters);    
    %     uvel = rdmdsWrapper(fullfile(exppath,'/results/UVEL'),nIters);      
    %     vvel = rdmdsWrapper(fullfile(exppath,'/results/VVEL'),nIters);   
    theta_inst(hFacC==0) = NaN;
    
    %%% Select potential temperature surface
    theta_plot = 0;
    %%% Bathymetry
    [Y,X] = meshgrid(yy,xx);  
    p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,-bathy(:,2:end-1)/1000);
%     p.FaceColor = [164 176 183]/255;
    p.FaceColor = boxcolor;
    p.EdgeColor = 'none';       
    hold on;
    zidx = 1;

    
    %     %%% Plot surface vorticity
    %     
    %     ff = f0+beta*YY;
    %     vort = zeros(Nx,Ny,Nr);
    %     vort(:,1:Ny-1,:) = - (uvel(:,2:Ny,:)-uvel(:,1:Ny-1,:))/delY(1);
    %     vort = vort + (vvel([2:Nx 1],:,:)-vvel(:,:,:))/delX(1);
    %     vort(hFacS==0) = 0;
    %     vort(hFacW==0) = 0;
    %     vort(hFacC==0) = 0;
    %     vort(:,Ny-1,:) = 0;
    %     vort(:,2,:) = 0;
    %     vort = vort ./ abs(ff);
    
    %%% Plot instantaneous surface density
    pd_surf = densmdjwf(salt_inst(:,:,1),theta_inst(:,:,1),0);
    
    p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,-1.5*ones(size(X(:,2:end-1))),pd_surf(:,2:end-1));
    caxis([1026.5 1026.9]); 
    colormap(ax5,flipud(cmocean('ice',ncolor)));
%         colormap(ax5, cmocean('balance',ncolor));
    %     handle51 = colorbar;
    handle51 = colorbar(gca,'TickLabels', [ ],'Ticks', [ ]);    
    set(handle51,'Position',[0.5-0.01    0.3    0.01    0.1],'TickLength',0.04,'AxisLocation','in');
    anno51 = annotation('textbox',[0.51-0.01 0.305 0.05 0.1],'String',{'1026.9','','','1026.7','','','1026.5'},'FontSize',fontsize-2,'EdgeColor','none');     
    anno52 = annotation('textbox',[0.46-0.01 0.305 0.05 0.1],'String',{'1027.6','','','1027.4','','','1027.2'},'FontSize',fontsize-2,'EdgeColor','none');     
    anno54 = annotation('textbox',[0.483-0.01 0.225-0.02 0.05 0.05],'String',...
        '(kg/m^3)','FontSize',fontsize,...
        'LineStyle','None','HorizontalAlignment', 'center');
    anno511 = annotation('textbox',[0.51-0.01 0.255-0.01 0.05 0.05],'String',...
        '\rho_{fresh}^{surf}','FontSize',fontsize+2,'EdgeColor','none');
    anno522 = annotation('textbox',[0.46-0.01 0.255-0.01 0.05 0.05],'String',...
        '\rho_{dense}^{surf}','FontSize',fontsize+2,'EdgeColor','none');
    
    anno5111 = annotation('textbox',[0.355 0.394 0.05 0.05],'String',...
        '\rho_{dense}^{surf}','FontSize',fontsize+2,'EdgeColor','none','Color','white');
    anno5222 = annotation('textbox',[0.62 0.394 0.05 0.05],'String',...
        '\rho_{fresh}^{surf}','FontSize',fontsize+2,'EdgeColor','none','Color','white');
    
    set(p,'FaceColor','texturemap','EdgeColor','none')
    alpha(p,1);
    freezeColors;
    
    
    %     %%% Plot ocean surface current
    %     u_surf = squeeze(uvel(:,:,zidx));
    %     v_surf = squeeze(vvel(:,:,zidx));
    %     svx = 25;  % Step
    %     svy = 20;
    %     scalefactor = 70;
    %     curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:end)'/1000, ...
    %         scalefactor*u_surf(1:svx:end,1:svy:end)',scalefactor*v_surf(1:svx:end,1:svy:end)',...
    %         'AutoScale','off');
    %     curr.Color = 'k';
    %     curr.LineWidth = 1;
    %     %     text(0.05,500,'Arrow scale: 1m/s')
    %     %    legend(curr,'test')
 
   
    %%% Isopycnal
    fv = isosurface(XX(:,2:end-1,:),YY(:,2:end-1,:),-ZZ(:,2:end-1,:),theta_inst(:,2:end-1,:),theta_plot);
    p = patch(fv);
    %     p.FaceColor = [87 151 246]/255;
    p.FaceColor = boxcolor;
    p.EdgeColor = 'none';
    alpha(p,0.5);
    hold off;

    
    %%% Salinity section
    i_end = 1;
    salt_end = squeeze(salt(i_end,:,:));
    salt_end(salt_end==0) = NaN;
    [ZZZ,YYY] = meshgrid(zz,yy);
    zz_i = -H+5:10:-5;
    Nz_i = length(zz_i);
    [ZZZ_i,YYY_i] = meshgrid(zz_i,yy);
    salt_i = zeros(Ny,Nz_i);
    
    for j=1:Ny
        salt_i(j,:) = interp1(zz,salt_end(j,:),zz_i,'linear');
        salt_i(j,end)=salt_i(j,end-1);
        nNaN = sum(isnan(salt_i(j,:)));
        for nn = 1:nNaN
            salt_i(j,nn) = salt_i(j,nNaN+1);
        end
    end
    
        
    p = surface(xx(i_end)/1000*ones(size(YYY_i)),YYY_i/1000,-ZZZ_i/1000,salt_i);
    p.FaceColor = 'texturemap';
%     colormap(ax5, cmocean('balance',ncolor));
        colormap(ax5, flipud(cmocean('ice',ncolor)));
    caxis([34.3 34.95]);
    p.EdgeColor = 'none';         
    alpha(p,1);
    %   colormap(pmkmp(56,'Swtth'));
    %   colormap(cmocean('thermal',56));
    handle52 = colorbar;
    set(handle52,'Position',[0.5-0.01    0.44    0.01    0.1],'TickLength',0.04,'AxisLocation','in');
    anno5 = annotation('textbox',[0.45-0.01 0.45 0.05 0.05],'String',...
        'S (psu)','FontSize',fontsize+1,...
        'LineStyle','None','HorizontalAlignment', 'center');

    annotation('textbox',[0.91 0.155 0.15 0.01],'String',['S (psu)'],'FontSize',fontsize,'LineStyle','None');

    %%% Decorations
    % view(120,20);
    % view(108.7927,10.6613);
    view(116.5,13);
    axis tight;
    xlabel('x (km)');
    ylabel('y (km)');
    zlabel('Depth (km)');
    set(gca,'XLim',[-200 200]);
    set(gca,'XTick',[-200:100:200]);
    set(gca,'YLim',[0 450]);
    set(gca,'YTick',[0:100:450]);
    set(gca,'ZLim',[-1.5 4]);
    set(gca,'ZTick',[0:1:4]);
    set(gca, 'ZDir','reverse')
    set(gca,'FontSize',fontsize);
    set(gca,'TickDir','out','TickLength',[0.01 0.02]);
    pbaspect([Lx/Ly 1 0.9]);
    %     annotation('textbox',[0.038 0.42 0.15 0.01],'String',{'Surface';'salinity';'(psu)'},'FontSize',fontsize,'LineStyle','None');
    %     annotation('textbox',[0.26 0.55 0.15 0.01],'String',{'$0^\circ$ C isotherms'},'FontSize',fontsize,'LineStyle','None','interpreter','latex');
    annotation('textbox',[0.78 0.245 0.15 0.01],'String',['0' char(176) 'C isotherms'],'FontSize',fontsize,'LineStyle','None');
    camlight('headlight');
    lightangle(ax5,50,-38);
    lighting gouraud;
    box on;

set(gcf, 'InvertHardcopy', 'off')
% colormap(ax1,colormap(cmocean('balance',ncolor)))

%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Observed hydrography: dense shelf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load('section_81winter')

    dlat = 111.5;
    latbegin_dense = -73.05;
    latend_dense = 450/dlat+latbegin_dense;
    lat_idx = round(latbegin_dense:latend_dense);
    lat_idx_km = (lat_idx-latbegin_dense)*dlat;  
    lat_km=(lat-latbegin_dense)*dlat;

    
    ax2 = axes('position',[0.026 0.55 0.3 0.2]);
    ann2 = annotation('textbox',[0.01 0.73 0.05 0.05],'String','b','FontSize',fontsize+1,'LineStyle','None','fontweight', 'bold');

    pcolor(lat_km,depth/1000,ss_dense');axis ij;
    %     colormap(ax2, cmocean('delta'));
    %     colormap(ax2,colormap(cmocean('balance',ncolor)))
    caxis([34.3 34.95])
    shading interp;
%     xlim([-73.1 -68.6])
%     xlim([-73.1 -68.6])
    xlim([0 450])
    ylim([0 4])
    %     handle2 = colorbar;
    %     set(handle2,'Position',[0.303 0.59 0.01 0.1],...
    %         'TickLength',0.04,'AxisLocation','in');
   %     caxis([-2.4 1])
    set(gca,'FontSize',fontsize);
    xlabel('Latitude','FontSize',fontsize)
    xlabel('y (km)','FontSize',fontsize)
    ylabel('Depth (km)','FontSize',fontsize)
    set(gca,'YTick',[0:1:4]);
    set(gca,'XTick',[0:100:400]);
    annotation('textbox',[0.06 0.72 0.15 0.01],'String',['1 ' char(176) 'C'],'FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.06 0.675 0.15 0.01],'String',['0.5 ' char(176) 'C'],'FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.24 0.735 0.15 0.01],'String',['0 ' char(176) 'C'],'FontSize',fontsize,'LineStyle','None');

    annotation('textbox',[0.28 0.57 0.15 0.01],'String',['S (psu)'],'FontSize',fontsize,'LineStyle','None');
    set(gca, 'XDir','reverse')
    line1 = annotation('line','Position',[0.3263 0.749 0.1891 -0.0801],...
        'LineStyle',':','LineWidth',2,'Color',darkgray);
    line2 = annotation('line','Position',[0.0273 0.7479 0.4918 -0.1101],...
        'LineStyle',':','LineWidth',2,'Color',darkgray);
    line3 = annotation('line','Position',[0.5155 0.67 0.0054 -0.0334],...
        'LineStyle','-.','Color','red','LineWidth',2);
    set(gca,'Color',boxcolor);
    hold on;
    [ZZ_section,YY_section] = meshgrid(depth,lat_km);
    [C2,h2]=contour(YY_section,ZZ_section/1000,tt_dense,[0.5:0.5:1],'-','EdgeColor',gray,'LineWidth',1);
    [C2,h2]=contour(YY_section,ZZ_section/1000,tt_dense,[0 0],'EdgeColor',gray,'LineWidth',2);
    hold off;
    
    hb = axes('Position', get(ax2, 'Position'),'XAxisLocation', 'top','YAxisLocation', 'left','Color', 'none');
    set(hb,'YTick',[]);
    
    set(hb,'XTick',[1-lat_idx_km(5)/450 1-lat_idx_km(4)/450 1-lat_idx_km(3)/450 1-lat_idx_km(2)/450 1-lat_idx_km(1)/450],'FontSize',fontsize);
    set(hb,'xticklabel',flip(lat_idx),'FontSize',fontsize);
    set(hb,'TickDir','out');
    xlabel('Latitude','FontSize',fontsize) 

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Observed hydrography: fresh shelf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    latbegin_fresh = -67.75;
    latend_fresh = 450/dlat+latbegin_fresh;
    lat_idx = round(latbegin_fresh:latend_fresh);
    lat_idx_km = (lat_idx-latbegin_fresh)*dlat;
    lat_km=(lat-latbegin_fresh)*dlat;
    
    ax4 = axes('position',[0.696 0.55 0.3 0.2]);
    ann4 = annotation('textbox',[0.686 0.73 0.05 0.05],'String','c','FontSize',fontsize+1,'LineStyle','None','fontweight', 'bold');
    line4 = annotation('line','Position',[0.6273 0.8167 0.0681 -0.0656],...
        'LineStyle',':','LineWidth',2,'Color',darkgray);
    line5 = annotation('line','Position',[0.6482 0.8256 0.3482 -0.0767],...
        'LineStyle',':','LineWidth',2,'Color',darkgray);
    line6 = annotation('line','Position',[0.6264 0.8167 0.0209 0.01],...
        'LineStyle','-.','Color','red','LineWidth',2);    
    pcolor(lat_km,depth/1000,ss_fresh');axis ij;
    %     colormap(ax4, cmocean('delta',ncolor));
    colormap(ax4,colormap(cmocean('balance',ncolor)))
    caxis([34.3 34.95])
    shading interp;
    xlim([0 450])
    ylim([0 4])
    %     handle4 = colorbar;
    %     set(handle4,'Position',[0.709 0.59 0.01 0.1],...
    %         'TickLength',0.04,'AxisLocation','in');
    set(gca,'FontSize',fontsize);
    xlabel('y (km)','FontSize',fontsize)
    ylabel('z (km)','FontSize',fontsize)
    set(gca,'YTick',[0:1:4]);
    set(gca,'XTick',[0:100:400]);
    annotation('textbox',[0.92 0.705 0.15 0.01],'String',['1 ' char(176) 'C'],'FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.92 0.665 0.15 0.01],'String',['0.5 ' char(176) 'C'],'FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.92 0.6 0.15 0.01],'String',['0 ' char(176) 'C'],'FontSize',fontsize,'LineStyle','None');

    annotation('textbox',[0.699 0.57 0.15 0.01],'String',['S (psu)'],'FontSize',fontsize,'LineStyle','None');
    set(gca,'Color',boxcolor)
    
    
    hold on;
    [ZZ_section,YY_section] = meshgrid(depth,lat_km);
    [C4,h4]=contour(YY_section,ZZ_section/1000,tt_fresh,[0.5:0.5:1],'-','EdgeColor',gray,'LineWidth',1);
    [C4,h4]=contour(YY_section,ZZ_section/1000,tt_fresh,[0 0],'EdgeColor',gray,'LineWidth',2);
    hold off;
    
    hb = axes('Position', get(ax4, 'Position'),'XAxisLocation', 'top','YAxisLocation', 'left','Color', 'none');
    set(hb,'YTick',[]);
    
    set(hb,'XTick',[lat_idx_km(1)/450 lat_idx_km(2)/450 lat_idx_km(3)/450 lat_idx_km(4)/450 lat_idx_km(5)/450],'FontSize',fontsize);
    set(hb,'xticklabel',lat_idx,'FontSize',fontsize);
    set(hb,'TickDir','out');
    xlabel('Latitude','FontSize',fontsize) 

    
    
%%
%%% Save the figure
 print('-djpeg','-r300',[figdir figname '.jpeg']);