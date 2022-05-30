%%%
%%% plot_energy.m
%%% Plot the energy budget of MITgcm_UC experiments
%%%
    
    clear;close all;
    
    %%% Add path
    addpath colormaps;
    addpath colormaps/cmocean/;
    addpath functions/
    
    expdir = '/Users/csi/MITgcm_UC/experiments/exps_strongwinds/shelfice_obcsE_orlanskiW_surfaceT/';
    expname = 'res2km_Ua-4.4Va4.4_Atide0_Hi0Ai0_Ws30_ardbeg_prod'
    loadexp;
    prodir = [exppath '/'];
    figdir = [exppath '/img/'];
    
    useSEAICE = false;
    fontsize = 17;
    fname = ''

    %     calcEnergyBudget_TS
    load([prodir '/' expname,'_EnergyBudget_5yrs.mat'])

    %%% Plotting options
    scrsz = get(0,'ScreenSize');
    fontsize = 17;
    framepos = [0 scrsz(4)/2 1100 800];
    plotloc = [0.15 0.15 0.7 0.75];
    
    [ZZ,YY] = meshgrid(zz,yy);
    figure(1)
    handle = figure(1);
    set(handle,'Position',framepos);
    
    clf;
    set(gcf,'color','w');  
    subplot(2,2,1)
    pcolor(YY/1000,-ZZ/1000,log10(EKE_xavg)); shading flat;axis ij;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    xlabel('Latitude, y (km)','interpreter','latex','FontSize',fontsize);
    ylabel('Depth (km)','interpreter','latex','FontSize',fontsize);
    handle=colorbar;
    set(handle,'FontSize',fontsize);
    set(gca,'FontSize',fontsize);
    colormap jet;
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);xlim([0 Ly/1000])
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    title('$\log_{10}(\mathrm{EKE})$ ($\mathrm{m}^2$/$\mathrm{s}^2$)','interpreter','latex','FontSize',fontsize+2);
    text(20,3.4,fname,'FontSize', fontsize+2,'interpreter','latex');
    
    subplot(2,2,3)
    pcolor(YY/1000,-ZZ/1000,PE_EKE_xavg); shading flat;axis ij;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    xlabel('Latitude, y (km)','interpreter','latex','FontSize',fontsize);
    ylabel('Depth (km)','interpreter','latex','FontSize',fontsize);
    title ('$\mathrm{PE}\to\mathrm{EKE}$ ($\mathrm{m}^2$/$\mathrm{s}^3$)','interpreter','latex','FontSize',fontsize+2)
    handle=colorbar;
    set(handle,'FontSize',fontsize);
    set(gca,'FontSize',fontsize);
    colormap redblue;
    caxis([-1 1]*1e-8);
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);xlim([0 Ly/1000])
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    text(20,3.4,fname,'FontSize', fontsize+2,'interpreter','latex')
    
    
    subplot(2,2,4)
    pcolor(YY/1000,-ZZ/1000,MKE_EKE_xavg);   shading flat;axis ij;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    xlabel('Latitude, y (km)','interpreter','latex','FontSize',fontsize);
    ylabel('Depth (km)','interpreter','latex','FontSize',fontsize);
    title ('$\mathrm{MKE}\to\mathrm{EKE}$ ($\mathrm{m}^2$/$\mathrm{s}^3$)','interpreter','latex','FontSize',fontsize+2)
    handle=colorbar;
    set(handle,'FontSize',fontsize);
    set(gca,'FontSize',fontsize);
    colormap redblue;
    caxis([-5 5]*1e-10);
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);xlim([0 Ly/1000])
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    text(20,3.4,fname,'FontSize', fontsize+2,'interpreter','latex')
    
    
    subplot(2,2,2)
    pcolor(YY/1000,-ZZ/1000,PE_MKE_xavg);  shading flat;axis ij;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    xlabel('Latitude, y (km)','interpreter','latex','FontSize',fontsize);
    ylabel('Depth (km)','interpreter','latex','FontSize',fontsize);
    title ('$\mathrm{PE}\to\mathrm{MKE}$ ($\mathrm{m}^2$/$\mathrm{s}^3$)','interpreter','latex','FontSize',fontsize+2)
    handle=colorbar;
    set(handle,'FontSize',fontsize);
    set(gca,'FontSize',fontsize);
    colormap redblue;
    caxis([-5 5]*1e-6);
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);xlim([0 Ly/1000])
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    text(20,3.4,fname,'FontSize', fontsize+2,'interpreter','latex')
    
    
    print('-dpng','-r150',[figdir 'tavg_5yr_energy.png']);