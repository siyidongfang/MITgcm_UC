%%%
%%% fig1.m
%%%
%%% Plot the model configuration for the undercurrent project 
%%%
%%% TO DO: add salinity contours to panel (a)


    clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/plots_JPO/cbarrow;

    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    load_colors;
    ne =1; % Load the reference experiment
    expname = EXPNAME{ne}
    loadexp;
    fontsize = 19;
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

    nIter = 1298541;
    uvel_inst = rdmdsWrapper(fullfile(exppath,'/results/U'),nIter);    

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

    calcFig1_bc;
    


    %%
    figure(1)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 1400 600]);


%%%%%%%%%%%%%%%%%%%
%%% panel (a) %%%%%
%%%%%%%%%%%%%%%%%%%
    %%% Plotting options
    ax1 = subplot('position',[0.03 0.055 0.49 0.95]);
    annotation('textbox',[0.025 0.88 0.15 0.01],'String','(a)','FontSize',fontsize+2,'LineStyle','None');

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

    % Plot the restoring temperature
    ZZZ(:,end)=-4;
    p_bct = surface(ax1,xx(idx_1)/1000*ones(size(YYY)),YYY,-ZZZ,BC_t);
    colormap(cmocean('balance',ncolor))
    clim([-2.3 2.3]);
    p_bct.FaceColor = 'texturemap';
    p_bct.EdgeColor = 'none';         
    alpha(p_bct,1);
    freezeColors;

    handle_tt = colorbar(gca,'TickLabels', [ ],'Ticks', [ ]);
    %     handle_tt = colorbar(ax1);
    set(handle_tt,'Position',[0.48    0.3    0.006    0.15]);
    annotation('textbox',[0.33 0.425 0.15 0.01],'String',{'Restoring';'temperature';['(' char(176) 'C)']},'FontSize',fontsize-1,'LineStyle','None','horizontalAlignment','right');
    anno51 = annotation('textbox',[0.485 0.36 0.03 0.1],'String',{'\fontsize{15}2','\fontsize{3}','\fontsize{15}0','\fontsize{3}','\fontsize{15}-2'},'EdgeColor','none');     
%     cbarrow;
%     %%% Add contours of restoring salinity
%     p_bct = contour3(xx(idx_1)/1000*ones(size(YYY)),YYY,-ZZZ,BC_s);
    


    ax2 = ax1;
    linkaxes([ax1,ax2]);
    %%Hide the top axes
%     ax2.Visible = 'off';
    ax2.XTick = [];
    ax2.YTick = [];

    %%% Plot a slice of zonal velocity near x = -50km
    Lx_u2 = 220*m1km;
    idx_u2 = round(Lx_u2/delX(1));
    Ly_end = 280*m1km;
    Ly_start = 200*m1km;
    yidx_u2 = round(Ly_start/delY(1)):round(Ly_end/delY(1));
    uvel_slice = squeeze(uvel_inst(idx_u2,:,:));
    % uvel_slice(uvel_slice==0) = NaN;
    p = surface(ax2,xx(idx_u2)/1000*ones(length(yidx_u2),Nr),YYY(yidx_u2,:),-ZZZ(yidx_u2,:),uvel_slice(yidx_u2,:));
    p.FaceColor = 'texturemap';
    colormap(cmocean('balance',ncolor))
%             colormap(ax2,cmocean('delta'))
    clim([-0.1 0.1]);
    p.EdgeColor = 'none';         
    alpha(p,0.9);
    freezeColors;

    %     handle_uc = colorbar(gca,'TickLabels', {'-0.1','0','0.1'},'Ticks', [-0.1 0 0.1]);
    handle_uc = colorbar(ax2);    
    set(handle_uc,'Position',[0.31   0.28    0.006    0.15]);
    annotation('textbox',[0.16 0.415 0.15 0.01],'String',{'Instantaneous';'zonal';'velocity';'(m/s)'},'FontSize',fontsize,'LineStyle','None','horizontalAlignment','right');

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
    set(gca,'TickLength',[0.1, 0.015])
    axis tight;
    pbaspect([Lx/Ly 1 1]);
    camlight('headlight');
    lightangle(140,-34);
    lighting flat;
    box on;
    grid on;

%%%%%%%%%%%%%%%%%%%
%%% panel (b) %%%%%
%%%%%%%%%%%%%%%%%%%

    %%% Zonal boundary conditions: thermal wind velocity + neutral density contours
    axb = subplot('position',[0.57 0.6 0.19 0.35]);
    annotation('textbox',[0.54 0.995 0.15 0.01],'String','(b)','FontSize',fontsize+2,'LineStyle','None');

 
    pcolor(yy/1000,-zz/1000,uEast'.*bathy_east')
    shading flat;axis ij;
    hold on;[M,c] = contour(YY/1000,-ZZ/1000,gamma_n_east.*bathy_east,[27:0.2:27.8 27.95:0.05:28.3],'LineColor','k','LineWidth',1);
    clabel(M,c,'LabelSpacing',200);hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',3);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',3);
    colormap(axb,cmocean('balance',ncolor));
    clim([-0.06 0.06])
    set(gca,'FontSize',fontsize);
    title('Boundary restoring velocity','FontSize',fontsize+3)
    ylabel('Depth (km)');xlabel('Latitude, y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    xlim([100 400])
    ylim([0 4])
    set(gca,'YTick',[0:1:4]);
    grid on;


%%%%%%%%%%%%%%%%%%%
%%% panel (c) %%%%%
%%%%%%%%%%%%%%%%%%%
    %%% Zonal-mean zonal velocity + neutral density contours
    axc = subplot('position',[0.57 0.1 0.19 0.35]);
    annotation('textbox',[0.54 0.5 0.15 0.01],'String','(c)','FontSize',fontsize+2,'LineStyle','None');

    pcolor(yy/1000,-zz/1000,uu_xmean');
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',3);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',3);hold off;
    hold on;[M,c] = contour(YY_yz/1000,-ZZ_yz/1000,gamma_n_xmean,[27:0.2:27.8 27.95:0.05:28.3],'LineColor','k','LineWidth',1);
    clabel(M,c,'LabelSpacing',200);hold off;
    shading interp;axis ij;
    colormap(axc,cmocean('balance',ncolor));
    clim([-0.06 0.06])
    set(gca,'FontSize',fontsize);
    title('Zonal-mean zonal velocity','FontSize',fontsize+3)
    ylabel('Depth (km)');xlabel('Latitude, y (km)')
    set(gca,'XTick',[190:20:270]);
    set(gca,'YTick',[0:0.25:4]);
    ylim([0.25 1.5])
    xlim([190 270])
    grid on;
    handled = colorbar(axc);    
    set(handled,'Position',[0.773 0.2 0.005 0.6]);
    cbarrow;
    annotation('textbox',[0.77 0.845 0.01 0.01],'String','(m/s)','FontSize',fontsize,'LineStyle','None');



    %%
%%%%%%%%%%%%%%%%%%%
%%% panel (d) %%%%%
%%%%%%%%%%%%%%%%%%%
    %%% CDW depth at the zonal boundaries
    axd = subplot('position',[0.85 0.7 0.14 0.25]);
%      axd = subplot('position',[0.85 0.6 0.14 0.35]);
    annotation('textbox',[0.82 0.995 0.15 0.01],'String','(d)','FontSize',fontsize+2,'LineStyle','None');

    plot(yy/1000,-Zcdw_pt/1000,'LineWidth',2)
    hold on
    plot(yy/1000,-Zcdw_s/1000,'LineWidth',2)
    hold off;
    axis ij;
    ylim([0.3 0.85])
    ylabel('Depth (km)')
    xlabel('Latitude, y (km)')
    leg1 = legend('Depth of \theta_{max}','Depth of S_{max}');
    set(leg1,'Position',[0.8487 0.8664 0.0943 0.0875]);legend boxoff;
    set(gca,'fontsize',fontsize);
%     title('Eastern boundary CDW depth')
    title('Thermocline/halocline','FontSize',fontsize+3)
    grid on;grid minor



%%%%%%%%%%%%%%%%%%%
%%% panel (e) %%%%%
%%%%%%%%%%%%%%%%%%%
    tNorth = tEast(Ny,:);
    sNorth = sEast(Ny,:);

    %%% Restoring T/S at the northern boundary
    ax51 = subplot('position',[0.85 0.1 0.14 0.4]);
    annotation('textbox',[0.82 0.58 0.15 0.01],'String','(e)','FontSize',fontsize+2,'LineStyle','None');
    plot(ax51,tNorth,-zz/1000,'Color',[0.8500 0.3250 0.0980],'LineWidth',1.5);
    ax52 = axes('Position',get(ax51,'Position'));
    plot(ax52,sNorth,-zz/1000,'Color','k','LineWidth',1.5);
%     set(ax51,'YTick',[1 2 3 4]);
    hold off;
    text3 = text(ax52,33.63,0.8,{'Northern boundary';'relaxation'},'FontSize',fontsize+3,'color','k','fontweight', 'bold');
    set(ax51,'YDir','reverse');
    set(ax52,'YDir','reverse');
    set(ax51,'XAxisLocation','Bottom');
    set(ax52,'XAxisLocation','Top');
    set(ax51,'YAxisLocation','Left')
    set(ax52,'YAxisLocation','Right');
    set(ax51,'XColor',[0.8500 0.3250 0.0980]); 
    set(ax52,'XColor','k');
    set(ax51,'XLim',[-2 2.1]);
    set(ax51,'XTick',[-2:1:2]);
    set(ax51,'FontSize',fontsize);
    set(ax52,'FontSize',fontsize);
    set(ax52,'XTick',[33.6 34 34.4 34.8],'fontsize',fontsize-1);
    set(ax52,'XLim',[min(sNorth)-0.1 max(sNorth)+0.1]);
    set(ax51,'YLim',[0 4]);
    set(ax52,'YTick',[]);
    set(ax52,'YLim',[0 4]);
    set(ax51,'YColor','k');
    set(ax52,'YColor','k');
    set(get(ax51,'XLabel'),'String','Potential temperature (^oC)','FontSize',fontsize);
    set(get(ax52,'XLabel'),'String','Salinity (psu)','FontSize',fontsize);
    set(ax52,'Color','none');
    set(ax51,'Box','off');
    set(ax52,'Box','off');
%     annotation('line',[0.85 0.99],[0.1 0.1],'LineWidth',1,'LineStyle','-','color',[0    0.4470    0.7410]);



     figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots_JPO/fig1/';
     print('-dpng','-r200',[figdir 'fig1_v1.png']);
    
    


