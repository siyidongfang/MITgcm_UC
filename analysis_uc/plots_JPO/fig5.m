%%%
%%% fig5.m
%%%
%%% Area-integrated vorticity budget
%%%

    clear;close all;
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions/
    
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
    
    prodname = [prodir expname '_vortPVint.mat'];
    load(prodname)

    fontsize = 18;
    bathy2=bathy;
    bathy2(YY>150*m1km)=NaN;


    figure(1)
    clf;set(gcf,'color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 600 800]);

    ax1 = subplot('position',[0.105 0.585 0.85 0.38]);
    annotation('textbox',[0.095 0.995 0.15 0.01],'String','(a)','FontSize',fontsize+2,'LineStyle','None');
    contour(XX/1000,YY/1000,PV,(-20:0.1:0)*1e-7,'Color',gray)
    hold on;
    contour(XXf/1000,YYf/1000,pvf.*Amaskf,Wmin:1e-8:Wmax,'LineWidth',1.2)
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    colorbar; colormap(WhiteBlueGreenYellowRed(5));
    clim([-4 -1]*1e-7);
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);
    title('CDW potential vorticity ','FontSize',fontsize+3,'FontWeight','normal')
    box on;
    annotation('textbox',[0.87 0.55 0.15 0.01],'String','(m^{-1}s^{-1})','FontSize',fontsize,'LineStyle','None');
    text(ax1,50,370,'Gray: CDW PV contours','FontSize',fontsize-1,'Color',darkgray)
    text(ax1,50,330,{'Color: selected contours', '           for area integral'},'FontSize',fontsize-1,'Color',blue)


    ax2 = subplot('position',[0.105 0.07 0.85 0.38]);
    annotation('textbox',[0.095 0.48 0.15 0.01],'String','(b)','FontSize',fontsize+2,'LineStyle','None');
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
    set(leg1,'Position', [0.11 0.3319 0.3650 0.1169])  
    xlabel('Latitude, y (km)');
    ylabel('(10^3 m^3/s^2)');
    title('Cumulatively integrated vorticity budget','FontSize',fontsize+3,'FontWeight','normal')
    xlim([50 250])
    grid on;grid minor;

    ah=axes('position',get(ax2,'position'),'visible','off');
    leg2 = legend(ah,[lbpt lipt],...
        'Bottom pressure torque','Interfacial pressure torque',...
        'FontSize',fontsize-0.5);
    legend boxoff;
    set(leg2,'Position', [0.11 0.0950 0.4200 0.0606])  

    ah2=axes('position',get(ax2,'position'),'visible','off');
    leg3 = legend(ah2,[lcori lvortadv lvertadv],...
        'Coriolis term','Vorticity advection','Vertical advection','FontSize',fontsize-0.5);
    legend boxoff;
    set(leg3,'Position', [0.5467 0.0750 0.3183 0.0887])  


     figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots_JPO/fig5/';
     print('-dpng','-r200',[figdir 'fig5.png']);















    

