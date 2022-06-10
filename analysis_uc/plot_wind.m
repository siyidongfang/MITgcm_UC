


    clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/customcolormap/;

    
    list_exps;

    nEXP = length(EXPNAME);

    nn=2
    expname = EXPNAME{nn}
    expdir = EXPDIR{nn};
    nIter = NITER(nn);
    year = YEAR{nn};
    loadexp;
    calc_basics;
    gamma_n_weakwind = gamma_n_w;


    nn=3
    expname = EXPNAME{nn}
    expdir = EXPDIR{nn};
    nIter = NITER(nn);
    year = YEAR{nn};
    loadexp;
    calc_basics;
    gamma_n_strongwind = gamma_n_w;




    boxcolor = [0.6 0.6 0.6];
    blue = hex2rgb('#3c73a8');

    figure()
    set(gcf,'Position',[284         349        1187         857])
    clf;
    subplot(1,2,1)
    [M,c] = contour(YY_yz/1000,-ZZ_yz/1000,gamma_n_weakwind,[27:0.2:27.8 27.95:0.05:28.3],'LineColor',blue,'LineWidth',2);
    clabel(M,c,'LabelSpacing',200);
    hold on;
    [M,c] = contour(YY_yz/1000,-ZZ_yz/1000,gamma_n_strongwind,[27:0.2:27.8 27.95:0.05:28.3],'LineColor','r','LineWidth',2);
    hold on;plot(yy/1000,-bathy(1,:)/1000,'Color','k','LineWidth',3);hold on; plot(yy/1000,-bathy(round(Nx/2),:)/1000,'--','Color','k','LineWidth',3);hold off;
    axis ij;
    title('Mean neutral density west of the trough (kg/m^3)')
    ylabel('Depth (km)');xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(1,2,2) 
    [M,c] = contour(YY_yz/1000,-ZZ_yz/1000,gamma_n_weakwind,[27:0.2:27.8 27.95:0.05:28.3],'LineColor',blue,'LineWidth',2);
    clabel(M,c,'LabelSpacing',200);
    hold on;
    [M,c] = contour(YY_yz/1000,-ZZ_yz/1000,gamma_n_strongwind,[27:0.2:27.8 27.95:0.05:28.3],'LineColor','r','LineWidth',2);
    hold on;plot(yy/1000,-bathy(1,:)/1000,'Color','k','LineWidth',3);hold on; plot(yy/1000,-bathy(round(Nx/2),:)/1000,'--','Color','k','LineWidth',3);hold off;
    axis ij;
    title('Zoom in')
    ylabel('Depth (km)');xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:0.5:4]);ylim([0.25 2])
    xlim([190 270])
    set(gca,'FontSize',fontsize+3);



    figdir = '/Users/csi/MITgcm_UC/analysis_uc/figures/';
    print('-dpng','-r150',[figdir 'wind_gamma_n.png']);


