%%%
%%% plot_fig1_NG.m
%%%
%%% Create a stereographic plot of seafloor salinity, with arrows to
%%% indicate barotropic ocean flow. Create two panels of observed hydrography, 
%%% and two panels of instantaneous isotherms in the simulations.


%%%%%% TO DO: 1. Change the aspect ratio? or keep current aspect ratio, and crop
%%%%%% the image. 2. plot temperature sections as a function of y(km).
%%%%%% Convert latitude to km, and show latitude at the top of the panel,
%%%%%% y(km) at the bottom of the panel


%%% Add path 
addpath /Users/csi/MITgcm_ASF-csi/analysis;
addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps;
addpath /Users/csi/MITgcm_ASF-csi/data_WOA18_etopo;
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng/';
figdir = '/Users/csi/MITgcm_ASF-csi/cross_slope_exchange/animation_calgfd/';

%%% Initialize figure
figure(10);
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.1*scrsz(3) 0.3*scrsz(4) 1100 450]);
boxcolor = [0.85 0.85 0.85];
gray = [0.6 0.6 0.6];
darkgray = [0.45 0.45 0.45];

set(gcf,'Color','w');
fontsize = 13;
ncolor = 40; % Number of levels in the colormap



expname = 'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_daily_calgfd';
loadexp;
    
%%% Frequency of diagnostic output
% dumpFreq = abs(diag_frequency(1));
dumpFreq = 86400;
nDumps = round(nTimeSteps*deltaT/dumpFreq);
dumpIters_dense = round((1:nDumps)*dumpFreq/deltaT);
dumpIters_dense = dumpIters_dense(dumpIters_dense > nIter0);
nDumps = length(dumpIters_dense);



expname = 'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_daily_calgfd';
loadexp;
    
%%% Frequency of diagnostic output
% dumpFreq = abs(diag_frequency(1));
dumpFreq = 86400;
nDumps = round(nTimeSteps*deltaT/dumpFreq);
dumpIters_fresh = round((1:nDumps)*dumpFreq/deltaT);
dumpIters_fresh = dumpIters_fresh(dumpIters_fresh > nIter0);
nDumps = length(dumpIters_fresh);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Instantaneous isotherms: dense shelf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
    
for nn = 1:nDumps
% for nn = 1:1


    expname = 'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_daily_calgfd';
    loadexp;
    
    figname = num2str(nn);

    nIters = dumpIters_dense(nn);

    clf;

    ann3 = annotation('textbox',[0.45 0.9 0.2 0.05],'String',['t = ' figname ' days'],'FontSize',fontsize+3,'LineStyle','None','fontweight', 'normal');

    ax3 = subplot('position',[0.06 0.05 0.37 0.95]);
  


    [YY,XX,ZZ]=meshgrid(yy,xx,zz);
    XX = XX / 1000;
    YY = YY / 1000;
    ZZ = ZZ / 1000;
    
    %%% Read snapshot
    theta_inst = rdmdsWrapper(fullfile(exppath,'/results/THETA_inst'),nIters); 
    salt_inst = rdmdsWrapper(fullfile(exppath,'/results/SALT_inst'),nIters); 
    uvel = rdmdsWrapper(fullfile(exppath,'/results/UVEL'),nIters);         
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


    %%% Plot instantaneous surface density
    pd_surf = densmdjwf(salt_inst(:,:,1),theta_inst(:,:,1),0);
    
    p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,-1.5*ones(size(X(:,2:end-1))),pd_surf(:,2:end-1));
    caxis([1027.2 1027.6]);

    colormap(ax3,colormap(cmocean('balance',ncolor)))
    %     colormap(ax3, cmocean('delta'));
    set(p,'FaceColor','texturemap','EdgeColor','none')
    alpha(p,1);
    freezeColors;

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
    uvel_end = squeeze(uvel(i_end,:,:));
    uvel_end(uvel_end==0) = NaN;
    [ZZZ,YYY] = meshgrid(zz,yy);
    zz_i = -H+5:10:-5;
    Nz_i = length(zz_i);
    [ZZZ_i,YYY_i] = meshgrid(zz_i,yy);
    uvel_i = zeros(Ny,Nz_i);
    for j=1:Ny
        uvel_i(j,:) = interp1(zz,uvel_end(j,:),zz_i,'linear');
    end
    p = surface(xx(i_end)/1000*ones(size(YYY_i)),YYY_i/1000,-ZZZ_i/1000,uvel_i);
    p.FaceColor = 'texturemap';
    colormap(ax3, cmocean('balance',ncolor));
    %     colormap(ax3, cmocean('delta'));
    caxis([-0.35 0.35]);
    p.EdgeColor = 'none';         
    alpha(p,1);
    

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
    annotation('textbox',[0.06 0.3 0.15 0.01],'String',['u (m/s)'],'FontSize',fontsize,'LineStyle','None');

    annotation('textbox',[0.15 0.49 0.15 0.01],'String',['0' char(176) 'C isotherms'],'FontSize',fontsize,'LineStyle','None');
    camlight('headlight');
    lightangle(ax3,-50,-38);
    lighting gouraud;
    box on;

    

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Instantaneous isotherms: fresh shelf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ax5 = subplot('position',[0.59 0.05 0.37 0.95]);
%     ann5 = annotation('textbox',[0.6 0.45 0.05 0.05],'String','e','FontSize',fontsize+1,'LineStyle','None','fontweight', 'bold');


    
    expname = 'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_daily_calgfd';
    loadexp;
    nIters = dumpIters_fresh(nn);


    [YY,XX,ZZ]=meshgrid(yy,xx,zz);
    XX = XX / 1000;
    YY = YY / 1000;
    ZZ = ZZ / 1000;
    
    %%% Read snapshot
    theta_inst = rdmdsWrapper(fullfile(exppath,'/results/THETA_inst'),nIters);  
    salt_inst = rdmdsWrapper(fullfile(exppath,'/results/SALT_inst'),nIters);    
    uvel = rdmdsWrapper(fullfile(exppath,'/results/UVEL'),nIters);      
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

    
    
    %%% Plot instantaneous surface density
    pd_surf = densmdjwf(salt_inst(:,:,1),theta_inst(:,:,1),0);
    
    p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,-1.5*ones(size(X(:,2:end-1))),pd_surf(:,2:end-1));
    caxis([1026.5 1026.9]); 
    colormap(ax5, cmocean('balance',ncolor));
    set(p,'FaceColor','texturemap','EdgeColor','none')
    alpha(p,1);
    freezeColors;
    
    
%     handle51 = colorbar;
    handle51 = colorbar('TickLabels', [],'Ticks', []);    
    set(handle51,'Position',[0.5-0.01    0.6    0.01    0.2],'TickLength',0.04,'AxisLocation','in');
    anno51 = annotation('textbox',[0.51-0.01 0.71 0.05 0.1],'String',{'1026.9','','','1026.7','','','1026.5'},'FontSize',fontsize-2,'EdgeColor','none');     
    anno52 = annotation('textbox',[0.46-0.01 0.71 0.05 0.1],'String',{'1027.6','','','1027.4','','','1027.2'},'FontSize',fontsize-2,'EdgeColor','none');     
    anno54 = annotation('textbox',[0.483-0.01 0.46 0.05 0.05],'String',...
        '(kg/m^3)','FontSize',fontsize,...
        'LineStyle','None','HorizontalAlignment', 'center');
    anno511 = annotation('textbox',[0.51-0.01 0.53 0.05 0.05],'String',...
        '\rho_{fresh}^{surf}','FontSize',fontsize+2,'EdgeColor','none');
    anno522 = annotation('textbox',[0.46-0.01 0.53 0.05 0.05],'String',...
        '\rho_{dense}^{surf}','FontSize',fontsize+2,'EdgeColor','none');
    
    anno5111 = annotation('textbox',[0.355 0.815 0.05 0.05],'String',...
        '\rho_{dense}^{surf}','FontSize',fontsize+2,'EdgeColor','none','Color','white');
    anno5222 = annotation('textbox',[0.62 0.815 0.05 0.05],'String',...
        '\rho_{fresh}^{surf}','FontSize',fontsize+2,'EdgeColor','none','Color','white');

   
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
    uvel_end = squeeze(uvel(i_end,:,:));
    uvel_end(uvel_end==0) = NaN;
    [ZZZ,YYY] = meshgrid(zz,yy);
    zz_i = -H+5:10:-5;
    Nz_i = length(zz_i);
    [ZZZ_i,YYY_i] = meshgrid(zz_i,yy);
    uvel_i = zeros(Ny,Nz_i);
    for j=1:Ny
        uvel_i(j,:) = interp1(zz,uvel_end(j,:),zz_i,'linear');
    end
    p = surface(xx(i_end)/1000*ones(size(YYY_i)),YYY_i/1000,-ZZZ_i/1000,uvel_i);
    p.FaceColor = 'texturemap';
    colormap(ax5, cmocean('balance',ncolor));
    %     colormap(ax5, cmocean('delta'));
    caxis([-0.35 0.35]);
    p.EdgeColor = 'none';         
    alpha(p,1);
    %   colormap(pmkmp(56,'Swtth'));
    %   colormap(cmocean('thermal',56));
    handle52 = colorbar;
    set(handle52,'Position',[0.5-0.01    0.2    0.01    0.2],'TickLength',0.04,'AxisLocation','in');
    anno5 = annotation('textbox',[0.47 0.15 0.05 0.05],'String',...
        'u (m/s)','FontSize',fontsize+1,...
        'LineStyle','None','HorizontalAlignment', 'center');

    annotation('textbox',[0.91 0.3 0.15 0.01],'String',['u (m/s)'],'FontSize',fontsize,'LineStyle','None');

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
    annotation('textbox',[0.78 0.47 0.15 0.01],'String',['0' char(176) 'C isotherms'],'FontSize',fontsize,'LineStyle','None');
    camlight('headlight');
    lightangle(ax5,50,-38);
    lighting gouraud;
    box on;

set(gcf, 'InvertHardcopy', 'off')

%%% Save the figure
 print('-djpeg','-r150',[figdir figname '.jpeg']);

end
