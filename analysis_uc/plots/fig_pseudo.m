%%%
%%% fig_pseudo.m --- This should be Fig. 4 in the manuscript 
%%%
%%% plot heat transport of 4 simulations with pseudo ice shelf

   clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/plots/cbarrow;
    addpath /Users/csi/MITgcm_UC/analysis_uc/plots/quivers/;

    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{2}
    list_exps_new;
    load_constants;
    load_colors;
    showfigure = false;
    CLIM=[-0.301 0.301];
    YLIM = [-0.2 3.6];


    subplotsize = [0.39 0.195];
    fontsize = 16;
    sz = 60;
    LineWidthsz = 1;

    %%
    figure(1)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 900 950]);


    ne =1; 
    expname = EXPNAME{ne}
    loadexp;
    load_data;
    load_spacing;
    calc_basics;
    calc_heat_IceShelfCavity;
    bathy2=bathy;
    bathy2(YY>150*m1km)=NaN;
    vt_zint_cdw(vt_zint_cdw==0)=NaN;
  
    %%
    ax1 = subplot('position',[0.065 0.77 subplotsize]);
    pcolor(xx/1000,yy/1000,-(1e-9)*cp_o*rho_o*(vt_zint_cdw)');
    colormap(cmocean('balance'));
    % colormap(redblue)
    shading interp;
    % xlim([-300 300]);ylim([0 400]);
    xlim([-230 230]);ylim([0 250]);
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    plot(-100:1:100,100*ones(201,1),'-','LineWidth',1.5,'Color',black)
    svx = 6; svy = 4;
    scalefactor = 0.9;
    % curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:Ny)'/1000, ...
    % scalefactor*UU_cdw(1:svx:end,1:svy:Ny)',scalefactor*VV_cdw(1:svx:end,1:svy:Ny)');
    curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:135)'/1000, ...
    scalefactor*UU_cdw(1:svx:end,1:svy:135)',scalefactor*VV_cdw(1:svx:end,1:svy:135)');
    curr.Color = [0.4 0.4 0.4];
    curr.LineWidth = 1;
    set(curr,'AutoScale','off');
    currScale = quiver(-178,28,scalefactor*25,0,'MaxHeadSize',30);
    currScale.Color = [0.4 0.4 0.4];
    currScale.LineWidth = 1;
    set(currScale,'AutoScale','off')
    text(-198,32,'25 m^2/s','verticalalignment','bottom','FontSize',fontsize-3)
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);
    clim(CLIM)
    title('Onshore CDW heat flux and volume flux','FontSize',fontsize+2.5,'fontweight', 'normal')
    annotation('textbox',[0.001 0.995 0.15 0.01],'String','a','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');


    ax2 = subplot('position',[0.606 0.77 subplotsize]);
    plot(xx/1000,Tc_cdw,'LineWidth',2);xlim([-110 110]);
    ylim(YLIM);
    hold on;
    plot(xx/1000,zeros(1,length(xx)),'k--')
    hold off;grid on;grid minor;
    ylabel('(10^{12} W)');
    set(gca,'FontSize',fontsize);
    title('Cumulative CDW heat transport at ice front','FontSize',fontsize+2.5,'fontweight', 'normal')
    annotation('textbox',[0.54 0.995 0.15 0.01],'String','b','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');

%%


    ne =2; 
    expname = EXPNAME{ne}
    loadexp;
    load_data;
    load_spacing;
    calc_basics;
    calc_heat_IceShelfCavity;
    bathy2=bathy;
    bathy2(YY>150*m1km)=NaN;
    vt_zint_cdw(vt_zint_cdw==0)=NaN;

    %%
    ax3 = subplot('position',[0.065 0.53 subplotsize]);
    pcolor(xx/1000,yy/1000,-(1e-9)*cp_o*rho_o*(vt_zint_cdw)');
    shading interp;
    xlim([-230 230]);ylim([0 250]);
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    plot(-100:1:100,100*ones(201,1),'-','LineWidth',1.5,'Color',black)
    svx = 6; svy = 4;
    curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:Ny)'/1000, ...
    scalefactor*UU_cdw(1:svx:end,1:svy:Ny)',scalefactor*VV_cdw(1:svx:end,1:svy:Ny)');
    curr.Color = [0.4 0.4 0.4];
    curr.LineWidth = 1;
    set(curr,'AutoScale','off');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);
    clim(CLIM)
    annotation('textbox',[0.001 0.738 0.15 0.01],'String','c','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');


    ax4 = subplot('position',[0.606 0.53 subplotsize]);
    plot(xx/1000,Tc_cdw,'LineWidth',2);xlim([-110 110]);
    ylim(YLIM);
    hold on;
    plot(xx/1000,zeros(1,length(xx)),'k--')
    hold off;grid on;grid minor;
    ylabel('(10^{12} W)');
    set(gca,'FontSize',fontsize);
    annotation('textbox',[0.54 0.738 0.15 0.01],'String','d','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');


%%
    ne =3; 
    expname = EXPNAME{ne}
    loadexp;
    load_data;
    load_spacing;
    calc_basics;
    calc_heat_IceShelfCavity;
    bathy2=bathy;
    bathy2(YY>150*m1km)=NaN;
    vt_zint_cdw(vt_zint_cdw==0)=NaN;

    ax5 = subplot('position',[0.065 0.29 subplotsize]);
    pcolor(xx/1000,yy/1000,-(1e-9)*cp_o*rho_o*(vt_zint_cdw)');
    shading interp;
    xlim([-230 230]);ylim([0 250]);
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    plot(-100:1:100,100*ones(201,1),'-','LineWidth',1.5,'Color',black)
    svx = 6; svy = 4;
    curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:Ny)'/1000, ...
    scalefactor*UU_cdw(1:svx:end,1:svy:Ny)',scalefactor*VV_cdw(1:svx:end,1:svy:Ny)');
    curr.Color = [0.4 0.4 0.4];
    curr.LineWidth = 1;
    set(curr,'AutoScale','off');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);
    clim(CLIM)
    annotation('textbox',[0.001 0.5 0.15 0.01],'String','e','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');

%%
    ax6 = subplot('position',[0.606 0.29 subplotsize]);
    plot(xx/1000,Tc_cdw,'LineWidth',2);xlim([-110 110]);
    ylim(YLIM);
    hold on;
    plot(xx/1000,zeros(1,length(xx)),'k--')
    hold off;grid on;grid minor;
    ylabel('(10^{12} W)');
    set(gca,'FontSize',fontsize);
    annotation('textbox',[0.54 0.5 0.15 0.01],'String','f','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');



%%
    ne =4; 
    expname = EXPNAME{ne}
    loadexp;
    load_data;
    load_spacing;
    calc_basics;
    calc_heat_IceShelfCavity;
    bathy2=bathy;    
    bathy2(YY>150*m1km)=NaN;
    vt_zint_cdw(vt_zint_cdw==0)=NaN;

    %%
    ax7 = subplot('position',[0.065 0.05 subplotsize]);
    pcolor(xx/1000,yy/1000,-(1e-9)*cp_o*rho_o*(vt_zint_cdw)');
    shading interp;
    xlim([-230 230]);ylim([0 250]);
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    plot(-100:1:100,100*ones(201,1),'-','LineWidth',1.5,'Color',black)
    svx = 6; svy = 4;
    curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:Ny)'/1000, ...
    scalefactor*UU_cdw(1:svx:end,1:svy:Ny)',scalefactor*VV_cdw(1:svx:end,1:svy:Ny)');
    curr.Color = [0.4 0.4 0.4];
    curr.LineWidth = 1;
    set(curr,'AutoScale','off')
    ylabel('Latitude, y (km)');
    xlabel('Longitude, x (km)');
    set(gca,'FontSize',fontsize);
    clim(CLIM)
    annotation('textbox',[0.001 0.26 0.15 0.01],'String','g','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
%%

    handle=colorbar;set(handle,'position',[0.47 0.2 0.01 0.59]);
    annotation('textbox',[0.455 0.78 0.2 0.05],'String','(10^9 W/m)','FontSize',fontsize+1,'LineStyle','None');


    ax8 = subplot('position',[0.606 0.05 subplotsize]);
    plot(xx/1000,Tc_cdw,'LineWidth',2);xlim([-110 110]);
    ylim(YLIM);
    hold on;
    plot(xx/1000,zeros(1,length(xx)),'k--')
    hold off;grid on;grid minor;
    xlabel('Longitude, x (km)');
    ylabel('(10^{12} W)');
    set(gca,'FontSize',fontsize);
    annotation('textbox',[0.54 0.26 0.15 0.01],'String','h','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');





    figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots/fig_pseudo/';
    print('-dpng','-r300',[figdir 'fig_pseudo_matlab.png']);

