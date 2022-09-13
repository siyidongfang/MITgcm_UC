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
    savefigure = false;
    calc_pd;


    LAT1 = Yshelfbreak;
    yidx1 = round(Yshelfbreak/dy);
    T_section = squeeze(tt(:,yidx1,:));
    S_section = squeeze(tt(:,yidx1,:));
    rho_section = squeeze(pd(:,yidx1,:)); %%% Potential density

    %%% Plotting options
    scrsz = get(0,'ScreenSize');
    fontsize = 18;
    framepos = [0 scrsz(4)/2 900 550];
    plotloc = [0.15 0.15 0.7 0.75];

    [XX_xz,ZZ_xz] = meshgrid(xx,zz);


    %%% Make the plot
    handle = figure(1);
    subplot(1,3,1)
    set(handle,'Position',framepos);
    clf;
    set(gcf,'color','w');
    pcolor(XX_xz/1000,-ZZ_xz/1000,T_section');shading interp;axis ij;
    caxis([-2 2]);
    colorbar;
    % colormap(flip(WhiteBlueGreenYellowRed(0)));
    colormap(cmocean('balance'))
    xlabel('Longitude (km)');ylabel('Depth (km)');
    set(gca,'FontSize',fontsize);
    title('Potential temperature (^oC)','FontSize',fontsize+3)
    set(gca,'Position',plotloc);
    ylim([0 0.8]);xlim([-298 298])
    xticks(-300:100:300); yticks(0:0.2:1)
    text(-250, 0.7, 'Shelf break, y = ','FontSize',fontsize+5)

%     subplot(1,3,2)
% 
%     subplot(1,3,3)

    if(savefigure)
    print('-dpng','-r150',[figdir expname '_TS.png']);
    end