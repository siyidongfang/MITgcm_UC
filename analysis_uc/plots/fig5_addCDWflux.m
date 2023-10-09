%%%
%%% fig5_addCDWflux.m  --- This should be Fig. 2 in the manuscript 
%%%
%%% Area-integrated vorticity budget
%%%

    clear;close all;
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions/
    addpath  /Users/csi/MITgcm_UC/analysis_uc
    
    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    
    prodir = ['/Users/csi/MITgcm_UC/products/' exp_group '/'];
    useSEAICE = true;
    ne=1;
    expname = EXPNAME{ne}
    loadexp;
    load_data;
    load_spacing;
    load_colors;
    
    prodname = [prodir expname '_vortPVint-v4.mat'];
    load(prodname)

    fontsize = 17;
    bathy2=bathy;
    bathy2(YY>150*m1km)=NaN;

    YLIM = [0 270];
    YTICKS = [0 50 100 150 200 250];
    XL = 100;
    XLIM = [-300+XL 300-XL];
    XTICKS = [-300+XL  -100 0 100  300-XL];

    showfigure = false;
    calc_heat_IceShelfCavity;
    vt_zint_cdw(vt_zint_cdw==0)=NaN;

    calc_basics;

    %%

    figure(1)
    clf;set(gcf,'color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 560 1000]);

   
    ax1 = subplot('position',[0.105 0.737 0.78 0.24]);
    pcolor(xx/1000,yy/1000,-(1e-9)*cp_o*rho_o*(vt_zint_cdw)');
    colormap(cmocean('balance'));
    % colormap(redblue);
    shading interp;
    handle1=colorbar;
    % handle1=colorbar('XTickLabel',{'-0.15','-0.1','-0.05','0','0.05','0.1','0.15'}, ...
               % 'XTick', -0.15:0.05:0.15);
    set(handle1,'Position',[0.905    0.755    0.012    0.2])
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    svx = 6; svy = 4;
    scalefactor=0.9;
    curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:135)'/1000, ...
    scalefactor*UU_cdw(1:svx:end,1:svy:135)',scalefactor*VV_cdw(1:svx:end,1:svy:135)');
    % curr.Color = [0 102 0]/255;
    curr.Color = [0.4 0.4 0.4];
    curr.LineWidth = 1;
    % set(curr,'AutoScale','on', 'AutoScaleFactor',1.6)
    set(curr,'AutoScale','off')
    currScale = quiver(148,28,scalefactor*25,0,'MaxHeadSize',30);
    currScale.Color = [0.4 0.4 0.4];
    currScale.LineWidth = 1;
    set(currScale,'AutoScale','off')
    text(138,32,'25 m^2/s','verticalalignment','bottom','FontSize',fontsize-3)
    plot(-100:1:100,100*ones(201,1),'-','LineWidth',1.5,'Color',black)
    ylim(YLIM);xlim(XLIM);
    yticks(YTICKS);xticks(XTICKS);
    % clim([-0.15 0.15])
    clim([-0.301 0.301])
    box on;
    annotation('textbox',[0.863 0.985 0.2 0.01],'String','(10^9 W/m)','FontSize',fontsize,'LineStyle','None');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);
    title('Onshore CDW heat flux and volume flux','FontSize',fontsize+3,'fontweight', 'normal')
    annotation('textbox',[0 0.995 0.15 0.01],'String','A','FontSize',fontsize+3,'fontweight','bold','LineStyle','None');
    freezeColors;

    %%

    ax2 = subplot('position',[0.105 0.42 0.78 0.24]);
    contour(XX/1000,YY/1000,PV,(-20:0.1:0)*1e-7,'Color',gray,'LineWidth',0.5)
    hold on;
    contour(XXf/1000,YYf/1000,pvf.*Amaskf,round(Wmin,8):1e-8:round(Wmax,8),'LineWidth',1.5)
    % contour(XXf/1000,YYf/1000,pvf.*Amaskf,Wmin:1e-8:Wmax,'LineWidth',1.2)
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    plot(-100:1:100,100*ones(201,1),'-','LineWidth',1.5,'Color',black)
    colormap(WhiteBlueGreenYellowRed(5));
    handle=colorbar; 
    set(handle,'Position',[0.905    0.44    0.012    0.2])
    ylim(YLIM)
    xlim(XLIM)
    clim([-4 -1]*1e-7);
    yticks(YTICKS);xticks(XTICKS);
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);
    title('CDW potential vorticity \it q_{cdw}','FontSize',fontsize+3,'FontWeight','normal')
    box on;
    annotation('textbox',[0.885 0.67 0.15 0.01],'String','(m^{-1}s^{-1})','FontSize',fontsize,'LineStyle','None');
    text(ax2,45,200,'Gray: CDW PV contours','FontSize',fontsize-1,'Color',darkgray)
    text(ax2,45,160,{'Color: selected contours', '           for area integral'},'FontSize',fontsize-1,'Color',blue)
    % text(ax1,-297,18,'(a)','FontSize',fontsize+2)
    annotation('textbox',[0 0.69 0.15 0.01],'String','B','FontSize',fontsize+3,'fontweight','bold','LineStyle','None');



    ax3 = subplot('position',[0.105 0.055 0.85 0.27]);
    lres =plot(yyf/1000,residual_Aint/1000,'LineWidth',4,'Color',boxcolor);
    hold on;
    ldis = plot(yyf/1000,Diss_Aint/1000,'LineWidth',3,'Color',yellow);
    lbpt = plot(yyf/1000,BPT_Aint/1000,':','LineWidth',1.5,'Color',blue);
    lipt = plot(yyf/1000,IPT_Aint/1000,'--','LineWidth',1,'Color',blue);
    lpt =plot(yyf/1000,BPTplusIPT_Aint/1000,'LineWidth',3,'Color',blue);
%     plot(yyf/1000,BPT_Aint+IPT_Aint,'LineWidth',2)
    ladv = plot(yyf/1000,Advec_Aint/1000,'LineWidth',3,'Color',green);
    lcori = plot(yyf/1000,Cori_Aint/1000,':','LineWidth',1.5,'Color',green);
    lvortadv = plot(yyf/1000,AdvZ3f_Aint/1000,'--','LineWidth',1,'Color',green);
    lvertadv = plot(yyf/1000,AdvRef_Aint/1000,'-.','LineWidth',1,'Color',green);
    set(gca,'FontSize',fontsize);
    leg1  = legend([lpt ladv ldis lres],...
    'Total pressure torque','Total advection','Dissipation','Residual','FontSize',fontsize);
    legend boxoff;
    set(leg1,'Position', [0.1318 0.24 0.3709 0.0875])  
    xlabel('Latitude, y (km)');
    ylabel('(10^3 m^3/s^2)');
    title('Cumulatively integrated vorticity budget','FontSize',fontsize+3,'FontWeight','normal')
    xlim([50 250])
    ylim([-8 8])
    yticks([-8:4:8]);
    grid on;grid minor;
    % text(ax2,51,-9,'(b)','FontSize',fontsize+2)
    annotation('textbox',[0 0.35 0.15 0.01],'String','C','FontSize',fontsize+3,'fontweight','bold','LineStyle','None');


    ah=axes('position',get(ax3,'position'),'visible','off');
    leg2 = legend(ah,[lbpt lipt],...
        'Bottom pressure torque','Interfacial pressure torque',...
        'FontSize',fontsize-0.5);
    legend boxoff;
    set(leg2,'Position', [0.1291 0.0635 0.4264 0.0445])  

    ah2=axes('position',get(ax3,'position'),'visible','off');
    leg3 = legend(ah2,[lcori lvortadv lvertadv],...
        'Coriolis term','Vorticity advection','Vertical advection','FontSize',fontsize-0.5);
    legend boxoff;
    set(leg3,'Position', [0.5736 0.0530 0.3236 0.0650])  


     figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots/fig5/';
     print('-dpng','-r300',[figdir 'fig5_matlab2.png']);

     % % print('-dpng','-r300',[figdir 'fig5_colorbar.png']);















    

