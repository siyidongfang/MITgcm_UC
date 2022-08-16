


    clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/customcolormap/;

    exp_group = 'seaice_boundary';
    list_exps_new;


    nEXP = length(EXPNAME);

    n=2
    expname = EXPNAME{n}
    loadexp;
    load_data;
    calc_basics;
    gamma_n_weakwind = gamma_n_w;
    YY_weak = YY_yz;
    ZZ_weak = ZZ_yz;


    clear YY_yz ZZ_yz yy zz gamma_n_w

    n=3
    expname = EXPNAME{n}
    loadexp;
    load_data;
    calc_basics;
    gamma_n_strongwind = gamma_n_w;
    YY_strong = YY_yz;
    ZZ_strong = ZZ_yz;


    boxcolor = [0.6 0.6 0.6];
    blue = hex2rgb('#3c73a8');

    figure()
    set(gcf,'Position',[284         349        1187         857])
    clf;
    subplot(1,2,1)
    [M,c] = contour(YY_weak/1000,-ZZ_weak/1000,gamma_n_weakwind,[27:0.2:27.8 27.95:0.05:28.3],'LineColor',blue,'LineWidth',2);
    clabel(M,c,'LabelSpacing',200);
    hold on;
    [M,c] = contour(YY_strong/1000,-ZZ_strong/1000,gamma_n_strongwind,[27:0.2:27.8 27.95:0.05:28.3],'LineColor','r','LineWidth',2);
    hold on;plot(yy/1000,-bathy(1,:)/1000,'Color','k','LineWidth',3);hold on; plot(yy/1000,-bathy(round(Nx/2),:)/1000,'--','Color','k','LineWidth',3);hold off;
    axis ij;
    title('Mean neutral density west of the trough (kg/m^3)')
    ylabel('Depth (km)');xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(1,2,2) 
    [M,c] = contour(YY_weak/1000,-ZZ_weak/1000,gamma_n_weakwind,[27:0.2:27.8 27.95:0.05:28.3],'LineColor',blue,'LineWidth',2);
    clabel(M,c,'LabelSpacing',200);
    hold on;
    [M,c] = contour(YY_strong/1000,-ZZ_strong/1000,gamma_n_strongwind,[27:0.2:27.8 27.95:0.05:28.3],'LineColor','r','LineWidth',2);
    hold on;plot(yy/1000,-bathy(1,:)/1000,'Color','k','LineWidth',3);hold on; plot(yy/1000,-bathy(round(Nx/2),:)/1000,'--','Color','k','LineWidth',3);hold off;
    axis ij;
    title('Zoom in')
    ylabel('Depth (km)');xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:0.5:4]);ylim([0.25 2])
    xlim([190 270])
    set(gca,'FontSize',fontsize+3);



    figdir = '/Users/csi/MITgcm_UC/figures_uc/';
    print('-dpng','-r150',[figdir 'wind_gamma_n_seaiceboundary.png']);


