    %%%
    %%% plot_model.m
    %%%
    %%% Plot a schematic of the model setup, plus reminders of the model state
    %%% In Nature Geoscience format
    %%%
    
    clear;close all;

    %%% Plotting options
    fontsize = 14;

    %%% Select simulation
    addpath /Users/csi/MITgcm_ASF-csi/analysis;
    addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis;
    addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps;
    addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps/customcolormap;
    expdir = '/Volumes/si/MITgcm_ASF-csi/exps_cross_slope/';
    expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod';
    prodir = '/Volumes/si/MITgcm_ASF-csi/products_cross_slope/';

    loadexp;
    load([prodir 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod_tavg_5yrs.mat'],'THETA','SIheff');
    load ([exppath '/setParams'],'Ua','Va')



    %%% Vertical grid spacing matrix
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]); 
    %%% Diagnostic indix corresponding to instantaneous velocity
    diagnum = length(diag_frequency);
    %%% This needs to be set to ensure we are using the correct output frequency
    diagfreq = diag_frequency(diagnum);
    %%% Frequency of diagnostic output
    dumpFreq = abs(diagfreq);
    nDumps = round(nTimeSteps*deltaT/dumpFreq);
    dumpIters = round((1:nDumps)*dumpFreq/deltaT);
    dumpIters = dumpIters(dumpIters >= nIter0);
    nDumps = length(dumpIters);
    nIters = 1312200

    %%% Read snapshot
    theta_inst = rdmdsWrapper(fullfile(exppath,'/results/T'),nIters);    
    salt_inst = rdmdsWrapper(fullfile(exppath,'/results/S'),nIters);    
    uvel_inst = rdmdsWrapper(fullfile(exppath,'/results/U'),nIters);         
    vvel_inst = rdmdsWrapper(fullfile(exppath,'/results/V'),nIters);
    siheff_inst = rdmdsWrapper(fullfile(exppath,'/results/HEFF'),nIters);
    %%% Remove topography
    theta_inst(hFacC==0) = NaN;
    eta(hFacC(:,:,1)==0) = NaN;

fname = '/Volumes/si/MITgcm_ASF-csi/experiments_configuration/hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25/img/RelaxationT.fig';

fig = openfig(fname);
hdata = findobj(gca,'Type','line')
xdata=get(hdata,'Xdata') ;
depthdata=get(hdata,'Ydata') ;
zData = -depthdata{2};
tData_north=xdata{2};
tData_south = xdata{1};

sData_ssurf33 = 33.*ones(1,31);
sData_ssurf3359 = 33.59.*ones(1,31);
close(gcf)

fname = '/Volumes/si/MITgcm_ASF-csi/experiments_configuration/hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25/img/RelaxationS.fig';
fig = openfig(fname);
hdata = findobj(gca,'Type','line')
xdata=get(hdata,'Xdata') ;    
sData_north = xdata{2};
sData_south_ref = xdata{1};
close(gcf) 

fname = '/Volumes/si/MITgcm_ASF-csi/experiments_configuration/hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff1/img/RelaxationS.fig';
fig = openfig(fname);
hdata = findobj(gca,'Type','line')
xdata=get(hdata,'Xdata') ;    
sData_sdiff1 = xdata{1};
close(gcf)

fname = '/Volumes/si/MITgcm_ASF-csi/experiments_configuration/hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff2/img/RelaxationS.fig';
fig = openfig(fname);
hdata = findobj(gca,'Type','line')
xdata=get(hdata,'Xdata') ;   
sData_sdiff2 = xdata{1};
close(gcf)

fname3 = '/Volumes/si/MITgcm_ASF-csi/experiments_configuration/hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3/img/RelaxationS.fig';
fig3 = openfig(fname3);
hdata3 = findobj(gca,'Type','line')
xdata3=get(hdata3,'Xdata') ;  
sData_sdiff3 = xdata3{1};
close(gcf)
    
%%
 
    %%% Initialize figure
    figure(10);
    clf;
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.01*scrsz(3) 0.3*scrsz(4) 1200 460]);
    set(gcf,'Color','w');
    boxcolor = [0.85 0.85 0.85];

    %%% Select potential temperature surface
    theta_plot = 0;

    
    
    
    %%% Bottom topography
    hb = -bathy(1,:);

    g_mean = squeeze(nanmean(theta_inst(:,:,:)));
    BATHY = g_mean;
    idx_bathy = isnan(g_mean);
    % g_mean(idx_bathy) = NaN;



    %% 

    
    
    
    [YY,XX,ZZ]=meshgrid(yy,xx,zz);
    XX = XX / 1000;
    YY = YY / 1000;
    ZZ = ZZ / 1000;


    clf;
    %%% Plotting options
    ax1 = subplot('position',[0.06 0.01 0.35 0.95]);
    ann1 = annotation('textbox',[0.01 0.88 0.05 0.05],'String','a','FontSize',fontsize,'LineStyle','None','fontweight', 'bold');

    %%% Bathymetry
    [Y,X] = meshgrid(yy,xx);  
    p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,bathy(:,2:end-1)/1000);
    p.FaceColor = [164 176 183]/255;
    p.EdgeColor = 'none';       
    hold on;
    zidx = 1;

    %%% Plot SSS
    p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,0*X(:,2:end-1),salt_inst(:,2:end-1,zidx));
    caxis([min(min(salt_inst(:,2:end-1,zidx)))-0.2 max(max(salt_inst(:,2:end-1,zidx)))+0.2]);
%     caxis([32.7 33.5]);
    caxis([33.65 34.15]);
    colormap(pmkmp(28,'LinearL'));
    set(p,'FaceColor','texturemap','EdgeColor','none')
    alpha(p,0.8);
    freezeColors;


    %%% Plot ocean surface current
    u_surf = squeeze(uvel_inst(:,:,zidx));
    v_surf = squeeze(vvel_inst(:,:,zidx));
    svx = 25;  % Step
    svy = 20;
    curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:end)'/1000, ...
        u_surf(1:svx:end,1:svy:end)',v_surf(1:svx:end,1:svy:end)');
    curr.Color = 'k';
    curr.LineWidth = 0.4;

    %%% Isopycnal
    fv = isosurface(XX(:,2:end-1,:),YY(:,2:end-1,:),ZZ(:,2:end-1,:),theta_inst(:,2:end-1,:),theta_plot);
    p = patch(fv);
    p.FaceColor = [87 151 246]/255;
    p.EdgeColor = 'none';
    alpha(p,0.5);
    hold off;

    %%% Decorations
    view(50,38);
    axis tight;
    xlabel('x (km)');
    ylabel('y (km)');
    zlabel('z (km)');
    set(gca,'XLim',[-200 200]);
    set(gca,'XTick',[-200:100:200]);
    set(gca,'YLim',[0 450]);
    set(gca,'YTick',[0:100:450]);
    set(gca,'ZLim',[-4 0]);
    set(gca,'ZTick',[-4:2:0]);
    set(gca,'FontSize',fontsize);
    set(gca,'TickDir','out','TickLength',[0.01 0.02]);
    pbaspect([Lx/Ly 1 0.75]);
    handle = colorbar;
    set(handle,'Position',[0.03    0.65    0.01    0.2117]);
    annotation('textbox',[0.038 0.88 0.15 0.01],'String',{'Surface';'salinity';'(psu)'},'FontSize',fontsize,'LineStyle','None');
%     annotation('textbox',[0.26 0.55 0.15 0.01],'String',{'$0^\circ$ C isotherms'},'FontSize',fontsize,'LineStyle','None','interpreter','latex');
    annotation('textbox',[0.25 0.54 0.15 0.01],'String',['0' char(176) 'C isotherms'],'FontSize',fontsize,'LineStyle','None');
    camlight('headlight');
    lightangle(50,38);
    lighting gouraud;
    view(ax1,[115.3500 13.8761])

%     ylim([0 420])
    set(gca, 'FontName', 'Helvetica')

    %%
    clear ZZ YY;
    [ZZ,YY] = meshgrid(zz,yy);
    for j=1:Ny
      hFacC_col = squeeze(hFacC(1,j,:));  
      kmax = length(hFacC_col(hFacC_col>0));  
      zz_botface = -sum(hFacC_col.*delR');
      ZZ(j,1) = 0;
      if (kmax>0)
        ZZ(j,kmax) = zz_botface;
      end
    end


    uwind = [Ua:-Ua/(Ny-1):0].*ones(Nx,1); 
    vwind = [Va:-Va/(Ny-1):0].*ones(Nx,1); 
    rho_a = 1.3;               %%% Air density, kg/m^3
    zonalWind = rho_a.*SEAICE_drag.*sqrt(uwind.^2+vwind.^2).*uwind;
    meridionalWind = rho_a.*SEAICE_drag.*sqrt(uwind.^2+vwind.^2).*vwind;

    %% Plot isopycnals and topography
    ax2 = subplot('position',[0.5 0.1 0.32 0.55]);
%     annotation('textbox',[0.495 0.7 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize,'LineStyle','None');
    annotation('textbox',[0.495 0.695 0.05 0.05],'String','c','FontSize',fontsize,'LineStyle','None','fontweight', 'bold');

    % caxis([33.3 34.75]); % fresh shelf
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});

    theta0=THETA;
    theta0(idx_bathy) = NaN;
    theta=squeeze(nanmean(theta0,1));
    theta(idx_bathy) = NaN;
    g_mean0 = squeeze(nanmean(theta0(:,:,:)));
    g_mean0(g_mean0==0)=NaN;

    pcolor(yy/1000,-zz/1000,theta');shading interp;axis ij;
    colormap(ax2,mycolormap);
    set(gca,'clim',[-1.82 1.82]);
    set(gca,'color',boxcolor);

    hold on;
%     text0 = text(300,2.5,'$\theta\ (^\circ C)$','FontSize',fontsize,'interpreter','latex','color','k');
    text0 = text(280,2.5,['\theta (' char(176) 'C)'],'FontSize',fontsize,'color','k');

    [C,h]=contour(YY/1000,-ZZ/1000,g_mean0,[0 0],'EdgeColor','k','LineStyle','--');
    clabel(C,h,'Color','k','FontSize',fontsize,'LabelSpacing',150);
    plot(yy/1000,-bathy(1,:)/1000,'k-.','LineWidth',2);
    plot(yy/1000,-bathy(50,:)/1000,'k','LineWidth',2);
    line([430 430],[0 4],'Color','w','LineStyle',':','LineWidth',2);  
    line([20 20],[0 0.5],'Color','w','LineStyle',':','LineWidth',2);
    text(440,2,'RESTORING','FontSize',fontsize+1,'Rotation',270,'Color','k');
    hold off;
    xlabel('y (km)','FontSize',fontsize);
    ylabel('Depth (km)','FontSize',fontsize);
    set(gca,'FontSize',fontsize);
    set(gca,'YDir','reverse');
    set(gca,'XTick',[0:100:450]);
    set(gca,'YTick',[0 1 2 3 4]);

%     handle = colorbar;
%     set(handle,'Position',[0.528    0.1    0.01    0.2117]);
%     text0 = text(20,2.2,'$\theta\ (^\circ C)$','FontSize',fontsize,'interpreter','latex','color','k');

%     annotation('textbox',[0.53   0.35  0.15 0.01],'String',{'Potential';'temperature';'($^\circ$C)'},'FontSize',fontsize,'LineStyle','None','interpreter','latex');
    %% Sea ice and fluxes
    % subplot('position',[0.15+.5/9 0.83 0.5-.5/9 0.02]);
    % subplot('position',[0.15 0.8035 0.5 0.02]);
    ax3 = subplot('position',[0.5 0.66 0.32 0.04]);
    area(yy/1000,squeeze(nanmean(SIheff(:,:,1))),'FaceColor',[225 225 225]/255);
    hold on
    line([430 430]+1,[0 1],'Color','w','LineStyle',':','LineWidth',2);
    line([20 20]-1,[0 1],'Color','w','LineStyle',':','LineWidth',2);
    text(195,0.6,'Sea ice','FontSize',fontsize+1);

    box off;
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    set(gca,'Visible','off')

    hold off
    annotation('arrow',[0.472 0.498],[0.68 0.68],'LineWidth',1.5,'LineStyle','-','HeadStyle','cback3','color',[128 128 128]/255);
    annotation('textbox',[0.43 0.677 0.2 0.05],'String',{'Prescribed';'inflow'},'FontSize',fontsize,'LineStyle','None');

    %% Plot wind stress
    ax4 = subplot('position',[0.5 0.8 0.32 0.15]);
    annotation('textbox',[0.495 0.95 0.05 0.05],'String','b','FontSize',fontsize,'LineStyle','None','fontweight', 'bold');

    plot(yy/1000,zonalWind(1,:));
    hold on;
    plot(yy/1000,meridionalWind(1,:));
    hold off;
    set(gca,'XTick',[0:100:450]);
    set(gca,'XLim',[0 450]);
    set(gca,'FontSize',fontsize);
    ylabel({'Wind';'stress';'(N/m^2)'},'FontSize',fontsize,'Rotation',0);
    set(get(gca,'ylabel'),'Position',get(get(gca,'ylabel'),'Position')-[20 0.05 0]);
    text1 = text(200,-0.06,'Zonal wind','FontSize',fontsize,'color',[0    0.4470    0.7410],'LineWidth',1.5);
    text2 = text(200,0.06,'Meridional wind','FontSize',fontsize,'color',[0.8500    0.3250    0.0980],'LineWidth',1.5);


    %% Relaxation profiles
    ax51 = subplot('position',[0.85 0.1 0.14 0.55]);
    annotation('textbox',[0.835 0.695 0.05 0.05],'String','d','FontSize',fontsize,'LineStyle','None','fontweight', 'bold');
    plot(ax51,tData_north,-zData/1000,'Color',[0    0.4470    0.7410],'LineWidth',1.5);
    hold on;
    plot(ax51,tData_south,-zData(1:31)/1000,'-.','Color',[0    0.4470    0.7410],'LineWidth',1.5);
    hold off;
    ax52 = axes('Position',get(ax51,'Position'));
    plot(ax52,sData_north,-zData/1000,'Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
    % BreakXAxis(ax52,sData_north,-zData/1000,34.2,34.6,1)
    hold on;
    plot(ax52,sData_south_ref,-zData(1:31)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
    plot(ax52,sData_sdiff1,-zData(1:31)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
    plot(ax52,sData_ssurf33,-zData(1:31)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
    plot(ax52,sData_ssurf3359,-zData(1:31)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
    plot(ax52,sData_sdiff2,-zData(1:31)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
    plot(ax52,sData_sdiff3,-zData(1:31)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
    set(ax51,'YTick',[1 2 3 4]);
    hold off;
    text3 = text(ax52,34.67,3.5,{'Northern';'boundary'},'FontSize',fontsize,'color','k');
    text4 = text(ax52,34.2,0.8,{'Southern';'boundary'},'FontSize',fontsize,'color','k');
    set(ax51,'YDir','reverse');
    set(ax52,'YDir','reverse');
    set(ax51,'XAxisLocation','Bottom');
    set(ax52,'XAxisLocation','Top');
    set(ax51,'YAxisLocation','Left')
    set(ax52,'YAxisLocation','Right');
    set(ax51,'XColor',[0    0.4470    0.7410]); 
    set(ax52,'XColor',[0.8500    0.3250    0.0980]);
    set(ax51,'XLim',[-3.5 1]);
    set(ax51,'XTick',[-2 -1 0 1]);
    set(ax51,'FontSize',fontsize);
    set(ax52,'FontSize',fontsize);
    set(ax52,'XTick',[33 34.12 34.6 34.9],'fontsize',fontsize-1);
    set(ax52,'XLim',[32.97 34.98]);
    set(ax51,'YLim',[0 4]);
    set(ax52,'YTick',[]);
    set(ax52,'YLim',[0 4]);
    set(ax51,'YColor','k');
    set(ax52,'YColor','k');
    set(get(ax51,'XLabel'),'String',['Potential temperature (' char(176) 'C)'],'FontSize',fontsize);
    set(get(ax52,'XLabel'),'String','Salinity (psu)','FontSize',fontsize);
    set(ax52,'Color','none');
    set(ax51,'Box','off');
    set(ax52,'Box','off');
    breakxaxis([33.05 34.05],0.01);
    % breakxaxis([33.05 33.55],0.005);
    % breakxaxis([33.6 34.15],0.005);
    grid on
    annotation('line',[0.85 0.99],[0.1 0.1],'LineWidth',1,'LineStyle','-','color',[0    0.4470    0.7410]);



    %%
  figname = 'images/fig1_model'
%   exportgraphics(gcf,[figname '_sdiff3_2.jpeg'],'Resolution',300)
  %   exportgraphics(gcf,[figname '.eps'],'ContentType','vector','Resolution',300)
  %   print('-djpeg','-r300',[figname '.jpeg']);
