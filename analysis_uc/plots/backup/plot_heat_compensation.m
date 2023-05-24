
%%%
%%% plot_heat_compensation.m
%%%
%%% Calculate the cumulative heat transport within the ice shelf cavity

    clear; 
    close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;

    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{2}
    list_exps_new;
    load_constants;
    load_colors;

    ne = 1;
    expname = EXPNAME{ne}
    calc_heat_compensation;


    fontsize = 16;

%     CLIM = [-0.1 0.1];
%     YLIM = [-0.2 2.8];
    CLIM = [-0.25 0.25];
%     YLIM = [0 6.3];
YLIM = [-1 6.3];
    


    figure(2)
    set(gcf,'Position',[294 476 1326 754])
    clf;set(gcf,'Color', 'w')



    subplot(2,2,1)
    pcolor(xx/1000,yy/1000,-Fheat_cdw'/1e9);colorbar;colormap(redblue);shading flat;
    xlim([-230 230]);ylim([0 248]);hold on;
    [C,h]=contour(XX(:,230/2:250/2)/1000,YY(:,230/2:250/2)/1000,bathy(:,230/2:250/2),[-2000 -1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);
    [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-900:100:-600],'k:','LineWidth',1.5,'ShowText','off');
    [C,h]=contour(XX/1000,YY/1000,bathy,[-300 -300],'k','LineWidth',2,'ShowText','off');
    svx = 6; svy = 6;
    curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:end)'/1000, ...
    UU_cdw(1:svx:end,1:svy:end)',VV_cdw(1:svx:end,1:svy:end)');
%     curr.Color = [0 102 0]/255;
    curr.Color =  green;
    curr.LineWidth = 1.5;
    set(curr,'AutoScale','on', 'AutoScaleFactor', 5)
    plot(xx(98:197)/1000,100*ones(1,100),'LineWidth',3,'Color',darkgray)
    hold off;
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);
    clim(CLIM)
    title('Onshore CDW heat flux (color) and volume flux (arrows)','FontSize',fontsize + 2);
    c1 = colorbar;
    annotation('textbox',[0.415 0.065 0.15 0.01],'String','10^9 (W/m)','FontSize',fontsize-1,'LineStyle','None');

    subplot(2,2,2)
    plot(xx/1000,Tc_cdw,'LineWidth',2.5);xlim([-110 110]);
    ylim(YLIM);
    hold on;
    plot(xx/1000,zeros(1,length(xx)),'k--')
    rectangle('Position',[30 -2 10 10],'EdgeColor',boxcolor,'FaceColor',[boxcolor/1.3 0.2])
    rectangle('Position',[-27 -2 10 10],'EdgeColor',boxcolor,'FaceColor',[boxcolor/1.3 0.2])
    hold off;grid on;
    xlabel('Longitude, x (km)');
    ylabel('10^{12} (W)');
    set(gca,'FontSize',fontsize);
    title('Cumulative CDW heat transport at ice front (y=100km)','FontSize',fontsize + 2);


    ne = 4;
    expname = EXPNAME{ne}
    calc_heat_compensation;

  
    subplot(2,2,3)
    pcolor(xx/1000,yy/1000,-Fheat_cdw'/1e9);colorbar;colormap(redblue);shading flat;
    xlim([-230 230]);ylim([0 248]);hold on;
    [C,h]=contour(XX(:,230/2:250/2)/1000,YY(:,230/2:250/2)/1000,bathy(:,230/2:250/2),[-2000 -1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);
    [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-900:100:-600],'k:','LineWidth',1.5,'ShowText','off');
    [C,h]=contour(XX/1000,YY/1000,bathy,[-300 -300],'k','LineWidth',2,'ShowText','off');
    svx = 6; svy = 6;
    curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:end)'/1000, ...
    UU_cdw(1:svx:end,1:svy:end)',VV_cdw(1:svx:end,1:svy:end)');
%     curr.Color = [0 102 0]/255;
     curr.Color = green;
    curr.LineWidth = 1.5;
    set(curr,'AutoScale','on', 'AutoScaleFactor', 5)
    plot(xx(98:197)/1000,100*ones(1,100),'LineWidth',3,'Color',darkgray)
    hold off;
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);
    clim(CLIM)
    title('Onshore CDW heat flux (color) and volume flux (arrows)','FontSize',fontsize + 2);
    c1 = colorbar;
    annotation('textbox',[0.415 0.545 0.15 0.01],'String','10^9 (W/m)','FontSize',fontsize-1,'LineStyle','None');

    subplot(2,2,4)
    plot(xx/1000,Tc_cdw,'LineWidth',2.5);xlim([-110 110]);
    ylim(YLIM);
    hold on;
    plot(xx/1000,zeros(1,length(xx)),'k--')
    rectangle('Position',[30 -2 10 10],'EdgeColor',boxcolor,'FaceColor',[boxcolor/1.3 0.2])
    rectangle('Position',[-27 -2 10 10],'EdgeColor',boxcolor,'FaceColor',[boxcolor/1.3 0.2])
    hold off;grid on;
    xlabel('Longitude, x (km)');
    ylabel('10^{12} (W)');
    set(gca,'FontSize',fontsize);
    title('Cumulative CDW heat transport at ice front (y=100km)','FontSize',fontsize + 2);


%     figdir = '/Users/csi/MITgcm_UC/figures_uc/';
%     print('-dpng','-r300',[figdir 'heat_compensation.png']);


   

