%%%
%%% fig4.m
%%%
%%% Vorticity budget
%%%

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
    % YLIM = [0 400];
    YLIM = [0 270];
    YTICKS = [0 100 200 270];
    XL = 50;
    XLIM = [-300+XL 300-XL];
    XTICKS = [-300+XL -100 100 300-XL];
    CLIM = [-1 1]/1e5;

    bathy2=bathy;
    bathy2(YY>150*m1km)=NaN;



    zeta_IPT(isnan(zeta_IPT))=0;


    %%

    fontsize = 17;
    panelsize = [0.25 0.21];

    figure(1)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 1300 700]);

    ax1 = subplot('position',[0.045 0.74+0.01 panelsize]);
%     annotation('textbox',[0 0.98 0.15 0.01],'String','(a)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XXf/1000,YYf/1000,zeta_BPT+zeta_IPT)
    shading flat;colormap(cmocean('balance'));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim(XLIM)
    yticks(YTICKS);xticks(XTICKS)
    ylabel('Latitude, y (km)')
    xlabel('Longitude, x (km)');
    title('Total pressure torque (BPT+IPT)','FontSize',fontsize+3,'FontWeight','normal')
    % text(ax1,-294+XL,25,{'(a)'},'FontSize',fontsize+2)
    annotation('textbox',[0.001 1 0.15 0.01],'String','a','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    box on;

%%
    
    ax2 = subplot('position',[0.36 0.74+0.01 panelsize]);
%     annotation('textbox',[0.33 0.98 0.15 0.01],'String','(b)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XXf/1000,YYf/1000,zeta_Advec)
    shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim(XLIM)
    yticks(YTICKS);xticks(XTICKS)
    ylabel('y (km)')
    xlabel('Longitude, x (km)');
    title('Total advection','FontSize',fontsize+3,'FontWeight','normal')
    % text(ax2,-294+XL,25,{'(b)'},'FontSize',fontsize+2)
    annotation('textbox',[0.315 1 0.15 0.01],'String','b','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    box on;

    ax3 = subplot('position',[0.68 0.74+0.01 panelsize]);
%     annotation('textbox',[0.665 0.98 0.15 0.01],'String','(c)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XXf/1000,YYf/1000,zeta_Diss)
    shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim(XLIM)
    yticks(YTICKS);xticks(XTICKS)
    ylabel('y (km)')
    xlabel('Longitude, x (km)');
    title('Dissipation','FontSize',fontsize+3,'FontWeight','normal')
    % text(ax3,-294+XL,25,{'(c)'},'FontSize',fontsize+2)
    annotation('textbox',[0.635 1 0.15 0.01],'String','c','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    box on;


    handle=colorbar;set(handle,'position',[0.96 0.23 0.005 0.5]);
    annotation('textbox',[0.953 0.735+0.01 0.05 0.05],'String','(Pa/m)','FontSize',fontsize,'LineStyle','None');
%%

    zeta_IPT(zeta_IPT==0)=NaN;
    ax4 = subplot('position',[0.045 0.37+0.01 panelsize]);
%     annotation('textbox',[0 0.66 0.15 0.01],'String','(d)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XXf/1000,YYf/1000,zeta_IPT)
    shading flat;colormap(cmocean('balance'));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim(XLIM)
    yticks(YTICKS);xticks(XTICKS)
    ylabel('Latitude, y (km)')
    title('Interfacial pressure torque (IPT)','FontSize',fontsize+3,'FontWeight','normal')
    % text(ax4,-294+XL,25,{'(d)'},'FontSize',fontsize+2)
    annotation('textbox',[0.001 0.63 0.15 0.01],'String','d','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    box on;


%%
    ax5 = subplot('position',[0.36 0.37+0.01 panelsize]);
%     annotation('textbox',[0.33 0.66 0.15 0.01],'String','(e)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XX/1000,YY/1000,zeta_Cori)
    shading flat;colormap(cmocean('balance'));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
    title('Coriolis','FontSize',fontsize+3,'FontWeight','normal')
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim(XLIM)
    yticks(YTICKS);xticks(XTICKS)
    ylabel('y (km)')
    % text(ax5,-294+XL,25,{'(f)'},'FontSize',fontsize+2)
    annotation('textbox',[0.315 0.63 0.15 0.01],'String','f','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    box on;


    ax6 = subplot('position',[0.68 0.37+0.01 panelsize]);
%     annotation('textbox',[0.665 0.66 0.15 0.01],'String','(f)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XX/1000,YY/1000,zeta_AdvZ3)
    shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
    title('Vorticity advection','FontSize',fontsize+3,'FontWeight','normal')
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim(XLIM)
    yticks(YTICKS);xticks(XTICKS)
    ylabel('y (km)')
    % text(ax6,-294+XL,25,{'(g)'},'FontSize',fontsize+2)
    annotation('textbox',[0.635 0.63 0.15 0.01],'String','g','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    box on;


    ax7 = subplot('position',[0.045 0.065+0.01 panelsize]);
%     annotation('textbox',[0 0.345 0.15 0.01],'String','(g)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XXf/1000,YYf/1000,zeta_BPT)
    shading flat;
    colormap(cmocean('balance'));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim(XLIM)
    yticks(YTICKS);xticks(XTICKS)
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)')
    title('Bottom pressure torque (BPT)','FontSize',fontsize+3,'FontWeight','normal')
    % text(ax7,-294+XL,25,{'(e)'},'FontSize',fontsize+2)
    annotation('textbox',[0.001 0.325 0.15 0.01],'String','e','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    box on;


    ax8 = subplot('position',[0.36 0.065+0.01 panelsize]);
%     annotation('textbox',[0.33 0.345 0.15 0.01],'String','(h)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XX/1000,YY/1000,zeta_AdvRe)
    shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
%     title('Vertical advection (explicit part)')
     title('Vertical advection','FontSize',fontsize+3,'FontWeight','normal')
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim(XLIM)
    yticks(YTICKS);xticks(XTICKS)
    xlabel('Longitude, x (km)');ylabel('y (km)')
    % text(ax8,-294+XL,25,{'(h)'},'FontSize',fontsize+2)
    annotation('textbox',[0.315 0.325 0.15 0.01],'String','h','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    box on;



    %%
    ax9 = subplot('position',[0.68 0.065+0.01 panelsize]);
%     annotation('textbox',[0.665 0.345 0.15 0.01],'String','(i)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(XX/1000,YY/1000,zeta_Advec-(zeta_AdvRe+zeta_AdvZ3+zeta_Cori))
    shading flat;colormap(cmocean('balance'));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM);
    title('Total Adv - (Cori + Vort Adv + Vert Adv) ','FontSize',fontsize+3,'FontWeight','normal')
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim(XLIM)
    yticks(YTICKS);xticks(XTICKS)
    xlabel('Longitude, x (km)');ylabel('y (km)')
    % text(ax9,-294+XL,25,{'(i)'},'FontSize',fontsize+2)
    annotation('textbox',[0.635 0.325 0.15 0.01],'String','i','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');
    box on;



    %%% plot the location of shelf break
    load_constants;
    hold on; 
    y1 = Ymin/m1km;
    y2 = Ymax/m1km;
    x1 = (Xsbmin-Lx/2)/m1km;
    x2 = (Xsbmax-Lx/2)/m1km;
    plot(x1:x2,y1*ones(1,length(x1:x2)),'g-','LineWidth',1.5)
    plot(x1:x2,y2*ones(1,length(x1:x2)),'g-','LineWidth',1.5)
    plot(x1*ones(1,length(y1:y2)),y1:y2,'g-','LineWidth',1.5)
    plot(x2*ones(1,length(y1:y2)),y1:y2,'g-','LineWidth',1.5)

%%
     figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots/fig4/';
     % print('-dpng','-r300',[figdir 'fig4_matlab_v1.png']);
     print('-dpng','-r300',[figdir 'vorticity_nomelt.png']);



    %%% plot beta*V
    zeta_betaV(zeta_betaV==0)=NaN;
   
    figure(2)
    clf;set(gcf,'color','w');
    set(gcf,'Position',[704 169 1000 500])
    pcolor(XX/1000,YY/1000,zeta_betaV)
    shading flat;colorbar;colormap(cmocean('balance'));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    clim(CLIM/10);
    title('$-\rho_0 \beta \int v\, \mathrm{d}z $ (Pa/m)','FontSize',fontsize+3,'Interpreter','latex')
    set(gca,'FontSize',fontsize);
    ylim(YLIM);xlim(XLIM)
    yticks(YTICKS);xticks(XTICKS)
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)')
    
    
    
    

