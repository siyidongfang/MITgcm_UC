%%%
%%% plot_cross_sections.m
%%%

    clear;close all;
    addpath functions/;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    load_colors;
    
    prodir = ['/Users/csi/MITgcm_UC/products_uc/' exp_group '/'];
    figdir = ['/Users/csi/MITgcm_UC/figures_uc/cross_section/' exp_group '/'];
    
    useSEAICE = true;

    n=1;
    expname = EXPNAME{n}
    loadexp;
    load_data;
    load_spacing;
    savefigure = true;
    calc_pd;


    %%

    LAT1 = 175*m1km;
%     YLIM = [0 0.9];XLIM=[-110 110];
     YLIM = [0 0.9];XLIM=[-298 298];
    yidx1 = round(LAT1/dy);
    T_section = squeeze(tt(:,yidx1,:));
    S_section = squeeze(ss(:,yidx1,:));
    rho_section = squeeze(pd(:,yidx1,:)); %%% Potential density

    u_section = squeeze(uu(:,yidx1,:));
    v_section = squeeze(vv(:,yidx1,:));

    T_section(T_section==0)=NaN;
    S_section(S_section==0)=NaN;
    rho_section(rho_section==0)=NaN;
    u_section(u_section==0)=NaN;
    v_section(v_section==0)=NaN;

    %%% Plotting options
    scrsz = get(0,'ScreenSize');
    fontsize = 18;
    framepos = [0 scrsz(4)/2 900 550];
    plotloc = [0.15 0.15 0.7 0.75];

    [XX_xz,ZZ_xz] = meshgrid(xx,zz);

    
%     %%% Make the plot
%     handle = figure(1);
%     set(handle,'Position',framepos);
%     clf;
%     set(gcf,'color','w');
%     pcolor(XX_xz/1000,-ZZ_xz/1000,T_section');shading interp;axis ij;
%     caxis([-2.3 2.3]);
%     colorbar;
%     % colormap(flip(WhiteBlueGreenYellowRed(0)));
%     colormap(cmocean('balance',60))
%     xlabel('Longitude (km)');ylabel('Depth (km)');
%     set(gca,'FontSize',fontsize);
%     title('Potential temperature (^oC)','FontSize',fontsize+3)
%     set(gca,'Position',plotloc);
%     ylim(YLIM);xlim(XLIM)
%     xticks(-300:100:300); 
%     text(min(XLIM)+10, max(YLIM)-0.1, ['y = ' num2str(LAT1/m1km) ' km'],'FontSize',fontsize+5)
% 
%     if(savefigure)
%     print('-dpng','-r150',[figdir expname '_y' num2str(LAT1/m1km) 'km_T.png']);
%     end
% 
% 
%     %%% Make the plot
%     handle = figure(2);
%     set(handle,'Position',framepos);
%     clf;
%     set(gcf,'color','w');
%     pcolor(XX_xz/1000,-ZZ_xz/1000,S_section');shading interp;axis ij;
%     caxis([33.5 34.8]);
%     colorbar;
% %     colormap(WhiteBlueGreenYellowRed(0));
%     colormap(cmocean('balance',60))
%     xlabel('Longitude (km)');ylabel('Depth (km)');
%     set(gca,'FontSize',fontsize);
%     title('Salinity (psu)','FontSize',fontsize+3)
%     set(gca,'Position',plotloc);
%     ylim(YLIM);xlim(XLIM)
%     xticks(-300:100:300); 
%     text(min(XLIM)+10, max(YLIM)-0.1, ['y = ' num2str(LAT1/m1km) ' km'],'FontSize',fontsize+5)
%     
% 
%     if(savefigure)
%     print('-dpng','-r150',[figdir expname '_y' num2str(LAT1/m1km) 'km_S.png']);
%     end
% 
% 
%     %%% Make the plot
%     handle = figure(3);
%     set(handle,'Position',framepos);
%     clf;
%     set(gcf,'color','w');
%     pcolor(XX_xz/1000,-ZZ_xz/1000,rho_section');shading interp;axis ij;
%     caxis([1026.9 1027.85]);
%     colorbar;
%     colormap(cmocean('balance',60))
%     xlabel('Longitude (km)');ylabel('Depth (km)');
%     set(gca,'FontSize',fontsize);
%     title('Potential density (kg/m^3)','FontSize',fontsize+3)
%     set(gca,'Position',plotloc);
%     ylim(YLIM);xlim(XLIM)
%     xticks(-300:100:300); 
%     text(min(XLIM)+10, max(YLIM)-0.1, ['y = ' num2str(LAT1/m1km) ' km'],'FontSize',fontsize+5)
% 
%     if(savefigure)
%     print('-dpng','-r150',[figdir expname '_y' num2str(LAT1/m1km) 'km_rho.png']);
%     end


    %%% Make the plot
    handle = figure(4);
    set(handle,'Position',framepos);
    clf;
    set(gcf,'color','w');
    pcolor(XX_xz/1000,-ZZ_xz/1000,u_section');shading interp;axis ij;
    caxis([-0.1 0.1]);
    colorbar;
    colormap(cmocean('balance',60))
    xlabel('Longitude (km)');ylabel('Depth (km)');
    set(gca,'FontSize',fontsize);
    title('Zonal velocity (m/s)','FontSize',fontsize+3)
    set(gca,'Position',plotloc);
    ylim(YLIM);xlim(XLIM)
    xticks(-300:100:300); 
    text(min(XLIM)+10, max(YLIM)-0.1, ['y = ' num2str(LAT1/m1km) ' km'],'FontSize',fontsize+5)

    if(savefigure)
    print('-dpng','-r150',[figdir expname '_y' num2str(LAT1/m1km) 'km_u.png']);
    end

    %%% Make the plot
    handle = figure(5);
    set(handle,'Position',framepos);
    clf;
    set(gcf,'color','w');
    pcolor(XX_xz/1000,-ZZ_xz/1000,v_section');shading interp;axis ij;
    caxis([-0.1 0.1]);
    colorbar;
    colormap(cmocean('balance',60))
    xlabel('Longitude (km)');ylabel('Depth (km)');
    set(gca,'FontSize',fontsize);
    title('Meridional velocity (m/s)','FontSize',fontsize+3)
    set(gca,'Position',plotloc);
    ylim(YLIM);xlim(XLIM)
    xticks(-300:100:300); 
    text(min(XLIM)+10, max(YLIM)-0.1, ['y = ' num2str(LAT1/m1km) ' km'],'FontSize',fontsize+5)

    if(savefigure)
    print('-dpng','-r150',[figdir expname '_y' num2str(LAT1/m1km) 'km_v.png']);
    end

