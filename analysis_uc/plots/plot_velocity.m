%%%
%%% plot_velocity.m
%%%
%%% Plot the boundary restoring velocity and mean zonal velocity
%%%


%     clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    load_colors;
    n =1; % Load the reference experiment
    expname = EXPNAME{n}
    loadexp;
    fontsize = 17;
    ncolor=250; % Number of color contours
    m1km = 1000;
    load_data;

    nIter = 1298541;

%     calc_basics;
    u_boundary = squeeze(uu(1,:,:));
    u_boundary(u_boundary==0)=NaN;

    subplotsize = [0.85 0.38];

    figure(1)
    set(gcf,'Position',[1  107 500 700])
    clf;    

    ax1 = subplot('position',[0.1 0.58 subplotsize]);
    annotation('textbox',[0.015 0.96 0.05 0.05],'String','(b)','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');
    pcolor(yy/1000,-zz/1000,u_boundary');
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    hold on;[M,c] = contour(YY_yz/1000,-ZZ_yz/1000,gamma_n_xmean,[27:0.2:27.8 27.95:0.05:28.3],'LineColor','k','LineWidth',1);
    clabel(M,c,'LabelSpacing',200);hold off;
    shading interp;axis ij;colormap(mycolormap);colorbar
    clim([-0.06 0.06])
    title('Zonal boundary restoring velocity (m/s)')
    ylabel('Depth (km)');xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);
    set(gca,'FontSize',fontsize);

    ax2 = subplot('position',[0.1 0.08 subplotsize]);
    annotation('textbox',[0.015 0.46 0.05 0.05],'String','(c)','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');

    pcolor(yy/1000,-zz/1000,uu_xmean');
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    hold on;[M,c] = contour(YY_yz/1000,-ZZ_yz/1000,gamma_n_xmean,[27:0.2:27.8 27.95:0.05:28.3],'LineColor','k','LineWidth',1);
    clabel(M,c,'LabelSpacing',200);hold off;
    shading interp;axis ij;colormap(mycolormap);colorbar
    clim([-0.05 0.05])
    title('Zonal-mean zonal velocity (m/s)')
    ylabel('Depth (km)');xlabel('y (km)')
    set(gca,'XTick',[0:20:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);
    ylim([0.25 2])
    xlim([190 270])
    set(gca,'FontSize',fontsize);




