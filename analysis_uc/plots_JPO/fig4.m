%%%
%%% fig4.m
%%%
%%% Vorticity budget
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
    exp_group = EXP_GROUP{2};
    list_exps_new;
    load_constants;
    load_colors;
    ne =1; % Load the reference experiment
    expname = EXPNAME{ne};
    loadexp;
    load_data;
    load_spacing;
    load_colors;



    prodname = [prodir expname '_vorticity_cdw.mat'];
    load(prodname)
    YLIM = [0 400];
    CLIM = [-1 1]/1e5;



    %%

    fontsize = 17;
    panelsize = [0.25 0.23];

    figure(1)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 1300 900]);

    ax1 = subplot('position',[0.045 0.74 panelsize]);
%     annotation('textbox',[0 0.98 0.15 0.01],'String','(a)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XXf/1000,YYf/1000,zeta_BPT+zeta_IPT)
    shading flat;colormap(cmocean('balance'));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim([-300 300])
    yticks(0:100:400);xticks(-300:200:300)
    ylabel('Latitude, y (km)','Interpreter','latex')
    xlabel('Longitude, x (km)','Interpreter','latex');
    title('Total pressure torque (BPT+IPT)','Interpreter','latex','FontSize',fontsize+3)
    text(ax1,-294,25,{'(a)'},'FontSize',fontsize+2,'Interpreter','latex')

    ax2 = subplot('position',[0.36 0.74 panelsize]);
%     annotation('textbox',[0.33 0.98 0.15 0.01],'String','(b)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XXf/1000,YYf/1000,zeta_Advec)
    shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim([-300 300])
    yticks(0:100:400);xticks(-300:200:300)
    ylabel('Latitude, y (km)','Interpreter','latex')
    xlabel('Longitude, x (km)','Interpreter','latex');
    title('Total advection','Interpreter','latex','FontSize',fontsize+3)
    text(ax2,-294,25,{'(b)'},'FontSize',fontsize+2,'Interpreter','latex')

    ax3 = subplot('position',[0.68 0.74 panelsize]);
%     annotation('textbox',[0.665 0.98 0.15 0.01],'String','(c)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XXf/1000,YYf/1000,zeta_Diss)
    shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim([-300 300])
    yticks(0:100:400);xticks(-300:200:300)
    ylabel('Latitude, y (km)','Interpreter','latex')
    xlabel('Longitude, x (km)','Interpreter','latex');
    title('Dissipation','Interpreter','latex','FontSize',fontsize+3)
    text(ax3,-294,25,{'(c)'},'FontSize',fontsize+2,'Interpreter','latex')

    handle=colorbar;set(handle,'position',[0.96 0.23 0.005 0.5]);
    annotation('textbox',[0.953 0.735 0.05 0.05],'String','(Pa/m)','FontSize',fontsize,'LineStyle','None');


    ax4 = subplot('position',[0.045 0.37 panelsize]);
%     annotation('textbox',[0 0.66 0.15 0.01],'String','(d)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XXf/1000,YYf/1000,zeta_IPT)
    shading flat;colormap(cmocean('balance'));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim([-300 300])
    yticks(0:100:400);xticks(-300:200:300)
    ylabel('Latitude, y (km)','Interpreter','latex')
    title('Interfacial pressure torque (IPT)','Interpreter','latex','FontSize',fontsize+3)
    text(ax4,-294,25,{'(d)'},'FontSize',fontsize+2,'Interpreter','latex')


    ax5 = subplot('position',[0.36 0.37 panelsize]);
%     annotation('textbox',[0.33 0.66 0.15 0.01],'String','(e)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XX/1000,YY/1000,zeta_Cori)
    shading flat;colormap(cmocean('balance'));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
    title('Coriolis','Interpreter','latex')
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim([-300 300])
    yticks(0:100:400);xticks(-300:200:300)
    ylabel('Latitude, y (km)','Interpreter','latex')
    text(ax5,-294,25,{'(f)'},'FontSize',fontsize+2,'Interpreter','latex')

    ax6 = subplot('position',[0.68 0.37 panelsize]);
%     annotation('textbox',[0.665 0.66 0.15 0.01],'String','(f)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XX/1000,YY/1000,zeta_AdvZ3)
    shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
    title('Vorticity advection','Interpreter','latex')
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim([-300 300])
    yticks(0:100:400);xticks(-300:200:300)
    ylabel('Latitude, y (km)','Interpreter','latex')
    text(ax6,-294,25,{'(g)'},'FontSize',fontsize+2,'Interpreter','latex')

    ax7 = subplot('position',[0.045 0.065 panelsize]);
%     annotation('textbox',[0 0.345 0.15 0.01],'String','(g)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XXf/1000,YYf/1000,zeta_BPT)
    shading flat;
    colormap(cmocean('balance'));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim([-300 300])
    yticks(0:100:400);xticks(-300:200:300)
    xlabel('Longitude, x (km)','Interpreter','latex');
    ylabel('Latitude, y (km)','Interpreter','latex')
    title('Bottom pressure torque (BPT)','Interpreter','latex','FontSize',fontsize+3)
    text(ax7,-294,25,{'(e)'},'FontSize',fontsize+2,'Interpreter','latex')

    ax8 = subplot('position',[0.36 0.065 panelsize]);
%     annotation('textbox',[0.33 0.345 0.15 0.01],'String','(h)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XX/1000,YY/1000,zeta_AdvRe)
    shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
%     title('Vertical advection (explicit part)','Interpreter','latex')
     title('Vertical advection','Interpreter','latex')
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim([-300 300])
    yticks(0:100:400);xticks(-300:100:300)
    xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
    text(ax8,-294,25,{'(h)'},'FontSize',fontsize+2,'Interpreter','latex')

    ax9 = subplot('position',[0.68 0.065 panelsize]);
%     annotation('textbox',[0.665 0.345 0.15 0.01],'String','(i)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XX/1000,YY/1000,zeta_Advec-(zeta_AdvRe+zeta_AdvZ3+zeta_Cori))
    shading flat;colormap(cmocean('balance'));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
    title('Total Adv - (Cori + Vort Adv + Vert Adv) ','Interpreter','latex')
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim([-300 300])
    yticks(0:100:400);xticks(-300:100:300)
    xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
    text(ax9,-294,25,{'(i)'},'FontSize',fontsize+2,'Interpreter','latex')

%%
     figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots_JPO/fig4/';
     print('-dpng','-r200',[figdir 'fig4_matlab_v1.png']);


    %%% plot beta*V
    zeta_betaV(zeta_betaV==0)=NaN;
   
    figure(2)
    clf;set(gcf,'color','w');
    set(gcf,'Position',[704 169 1000 500])
    pcolor(XX/1000,YY/1000,zeta_betaV)
    shading flat;colorbar;colormap(cmocean('balance'));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM/10);
    title('$-\rho_0 \beta \int v\, \mathrm{d}z $ (Pa/m)','Interpreter','latex')
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim([-300 300])
    yticks(0:100:400);xticks(-300:100:300)
    xlabel('Longitude, x (km)','Interpreter','latex');
    ylabel('Latitude, y (km)','Interpreter','latex')
    
    
    
    

