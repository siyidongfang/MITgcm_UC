%%%
%%% fig2.m
%%%
%%% Model evaluation -- CDW and SSH
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
    addpath /Users/csi/MITgcm_UC/analysis_uc/plots_JPO/cbarrow;


    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{1};
    list_exps_new;
    load_constants;
    load_colors;
    ne =1; % Load the reference experiment
    expname = EXPNAME{ne};
    loadexp;
    load_data;
    load_spacing;
    calc_basics;

    fontsize = 17;
    panelsize = [0.27 0.38];
    YLIM = [0 400];

    bathy2=bathy;
    bathy2(YY>150*m1km)=NaN;


    figure(1)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 1400 600]);

     %%% Plotting options
    ax1 = subplot('position',[0.045 0.6 panelsize]);


    ax2 = subplot('position',[0.38 0.6 panelsize]);



    ax3 = subplot('position',[0.72 0.6 panelsize]);
%%


    ax4 = subplot('position',[0.045 0.09 panelsize]);
    eta(eta==0)=NaN;
    eta (SHIfwFlx~=0)=NaN;
    pcolor(xx/1000,yy/1000,eta');
    shading flat;colormap(cmocean('balance'));c1 = colorbar(ax4);
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    clim([-0.08 0.08]);
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim([-300 300])
    yticks(0:100:400);xticks(-300:200:300)
    ylabel('Latitude, y (km)')
    xlabel('Longitude, x (km)')
    title('Surface Height Anomaly (m)','FontSize',fontsize+3,'FontWeight','normal')
    text(ax4,-294,25,{'(d)'},'FontSize',fontsize+2)
    freezeColors;




    ax5 = subplot('position',[0.38 0.09 panelsize]);
    pcolor(xx/1000,yy/1000,HH_cdw'/1000);
    shading flat;colormap(WhiteBlueGreenYellowRed(0));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    clim([0 3]);colorbar;
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim([-300 300])
    yticks(0:100:400);xticks(-300:200:300)
    ylabel('Latitude, y (km)')
    xlabel('Longitude, x (km)')
    title('CDW thickness (km)','FontSize',fontsize+3,'FontWeight','normal')
    text(ax5,-294,25,{'(e)'},'FontSize',fontsize+2)




    ax6 = subplot('position',[0.72 0.09 panelsize]);
    pcolor(xx/1000,yy/1000,TT_cdw')
    shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    clim([0 2]);colorbar;
    title('Depth-averaged PT of the CDW layer (^oC)','FontSize',fontsize+3,'FontWeight','normal')
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim([-300 300])
    yticks(0:100:400);xticks(-300:200:300)
    ylabel('Latitude, y (km)')
    xlabel('Longitude, x (km)')
    text(ax6,-294,25,{'(f)'},'FontSize',fontsize+2)


    figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots_JPO/fig2/';
%     print('-dpng','-r200',[figdir 'fig2.png']);




