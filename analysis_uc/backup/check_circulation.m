    
    clear;close all;
    
    addpath /Users/csi/MITgcm_UC/analysis;
    addpath /Users/csi/MITgcm_UC/analysis/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis/colormaps/customcolormap;
    addpath /Users/csi/MITgcm_UC/analysis/jpo_analysis-hires;
    addpath /Users/csi/MITgcm_UC/analysis/jpo_analysis;
    
    %     expdir = '/Volumes/si/MITgcm_UC/exps_uc/';
    %     prodir = '/Volumes/si/MITgcm_UC/products_uc/';
    expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng/';
    prodir = '/Volumes/si/MITgcm_ASF-csi/products_new/';
    figdir = '/Users/csi/MITgcm_UC/analysis_uc/figures_uc/';
    
    ncolor=80;
    mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'},ncolor);
    GREY = [180 180 180]/255;
    
    
    %%% Initialize figure
    figure(2);
    clf;
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.05*scrsz(3) 0.15*scrsz(4) 600 380]);
    set(gcf,'Color','w');
    
    fontsize = 15;
    boxcolor = [225 225 225]/255;
    CLIM=[-0.4 0.4];
   
    expname= 'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod';
    loadexp;
    load([prodir expname '_tavg_10yrs.mat'],'UVEL')
    UVEL(UVEL==0) = NaN;
    aaa1=squeeze(nanmean(UVEL,1));
    %     aaaa1 = rdmds([exppath,'/results/U'],1326280);
    %     aaaa1(aaaa1==0)=NaN;
    %     aaa1 = squeeze(nanmean(aaaa1));
    pcolor(yy/1000,-zz/1000,aaa1');
    shading interp;axis ij;
    colormap(mycolormap);
    caxis(CLIM);
    colorbar;
    hold on;
    plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2);
    plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
    load([prodir expname '_gamma_n.mat'])
    gamma_n(gamma_n==0) = NaN;
    gamma = squeeze(nanmean(gamma_n,1));
    [M,c] = contour(yy/1000,-zz/1000,gamma',[27 27.5 28 28.25 28.3 28.35 28.6],'LineColor',GREY,'LineWidth',1);
    clabel(M,c,'LabelSpacing',250);
    ylabel('Depth (km)','FontSize',fontsize);
    xlabel('y (km)', 'FontSize', fontsize+1);
    set(gca,'YDir','reverse');
    set(gca,'fontsize',fontsize);
    xlim([20 430]) 
    ylim([0 4]) 
    set(gca,'YTick',[0:1:4]);
    set(gca,'XTick',[0:100:400]);
    title('8-year mean zonal velocity (m/s)','FontSize',fontsize+4,'fontweight', 'normal');
%     text(25,3.5,{'With sea ice,', 'no winds, no tides'},'FontSize',fontsize+1,'Color',[0 0 0]);

    print('-djpeg','-r200',[figdir 'u_' expname '.jpeg']);



