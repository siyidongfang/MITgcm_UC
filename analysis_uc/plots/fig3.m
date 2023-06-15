%%%
%%% fig3.m
%%%
%%% Model evaluation -- cross-sections of T, S, u
%%%


   clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc;
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/plots/cbarrow;


    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{1};
    list_exps_new;
    load_constants;
    load_colors;
    ne =1; % Load the reference experiment
    expname = EXPNAME{ne}
    loadexp;
    load_data;
    load_spacing;

    ss(ss==0)=NaN;
    tt(tt==0)=NaN;
    uu(uu==0)=NaN;
    m1km = 1000;
    L1 = 250*m1km;
    L2 = 300*m1km;
    L3 = 350*m1km;
    idx1 = round(L1/DX(1));
    idx2 = round(L2/DX(1));
    idx3 = round(L3/DX(1));
    s1 = squeeze(ss(idx1,:,:));
    t1 = squeeze(tt(idx1,:,:));
    u1 = squeeze(uu(idx1,:,:));
    s2 = squeeze(ss(idx2,:,:));
    t2 = squeeze(tt(idx2,:,:));
    u2 = squeeze(uu(idx2,:,:));
    s3 = squeeze(ss(idx3,:,:));
    t3 = squeeze(tt(idx3,:,:));
    u3 = squeeze(uu(idx3,:,:));

    [ZZ,YY] = meshgrid(zz,yy);

%     ZZ1=ZZ;
%     ZZ2=ZZ;
%     ZZ3=ZZ;
%     hFacC1 = squeeze(hFacC(idx1,:,:));
%     hFacC2 = squeeze(hFacC(idx2,:,:));
%     hFacC3 = squeeze(hFacC(idx3,:,:));
% 
%     DRC = rdmds(fullfile(resultspath,'DRC'));
% 
%     ZZ1(hFacC1==0)=NaN;
% %     ZZ2(hFacC2==0)=NaN;
% %     ZZ3(hFacC3==0)=NaN;
%     for jj=1:Ny
%         for kk=2:Nr
%             if( (hFacC1(jj,kk)~=1) && (hFacC1(jj,kk)~=0) )
%                 ZZ1(jj,kk)= ZZ1(jj,kk-1)-DRC(1,1,kk)*hFacC1(jj,kk);
%             end
%         end
%     end


%     figure(10)
%     pcolor(YY/1000,-ZZ/1000,hFacC1);
%     set(gca,'XTick',XTICK);xlim(XLIM)
%     set(gca,'YTick',[0:0.5:4]);ylim(YLIM)
%     shading interp;axis ij;colorbar;
%     title('hFacC')
    %%

    fontsize = 18;
     XLIM = [0 400];
    % XLIM = [190 270];
    YLIM = [0 1.5];
    % XLIM = [200 400];
    % YLIM = [0 4];
    XTICK=[10:20:300];
    panelsize = [0.236 0.26];

    figure(1)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 1400 800]);

    %%% Plotting options
    ax1 = subplot('position',[0.042 0.705 panelsize]);
%     annotation('textbox',[0 0.98 0.15 0.01],'String','(a)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(YY/1000,-ZZ/1000,t1);
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,t1,[-2:0.5:2.5],'EdgeColor','k');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,t1,[1.8:0.05:2.5],'k--');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',3);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',3);hold off;
    shading interp;axis ij;colormap(cmocean('balance'));
    clim([-2.3 2.3])
    title('Potential temperature','FontSize',fontsize+3,'fontweight', 'normal');
    ylabel('Depth (km)');
    set(gca,'XTick',XTICK);xlim(XLIM)
    set(gca,'YTick',[0:0.5:4]);ylim(YLIM)
    set(gca,'FontSize',fontsize);
    handle=colorbar;set(handle,'position',[0.295 0.23 0.005 0.5]);
    annotation('textbox',[0.29 0.72 0.05 0.05],'String','(^oC)','FontSize',fontsize,'LineStyle','None');
    text1 = text(ax1,191,1.3,{'\theta, west of the trough','(x = -50 km)'},'FontSize',fontsize,'color',darkgray);
    % text(ax1,192,1,{'(a)'},'FontSize',fontsize+2);
    annotation('textbox',[0.001 1 0.15 0.01],'String','a','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');

    %%
    ax2 = subplot('position',[0.375 0.705 panelsize]);
%     annotation('textbox',[0.33 0.98 0.15 0.01],'String','(b)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(yy/1000,-zz/1000,s1');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,s1,[32:0.2:35],'EdgeColor','k');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,s1,[34.7:0.01:35],'k--');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',3);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',3);hold off;
    shading interp;axis ij;colormap(cmocean('balance'));
    clim([33.5 34.9]);
    title('Salinity','FontSize',fontsize+3,'fontweight', 'normal');
    ylabel('Depth (km)');
    set(gca,'XTick',XTICK);xlim(XLIM)
    set(gca,'YTick',[0:0.5:4]);ylim(YLIM)
    set(gca,'FontSize',fontsize);
    handle=colorbar;set(handle,'position',[0.627 0.23 0.005 0.5]);
    annotation('textbox',[0.622 0.72 0.05 0.05],'String','(psu)','FontSize',fontsize,'LineStyle','None');
    text2 = text(ax2,191,1.3,{'S, west of the trough','(x = -50 km)'},'FontSize',fontsize,'color',darkgray);
    % text(ax2,192,1,{'(b)'},'FontSize',fontsize+2);
    annotation('textbox',[0.335 1 0.15 0.01],'String','b','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');


    ax3 = subplot('position',[0.71 0.705 panelsize]);
%     annotation('textbox',[0.665 0.98 0.15 0.01],'String','(c)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(yy/1000,-zz/1000,u1');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,u1,[-0.2:0.02:0],'k--');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,u1,[0:0.02:0.2],'EdgeColor','k');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',3);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',3);hold off;
    shading interp;axis ij;colormap(cmocean('balance'));
    clim([-0.15 0.15])
    title('Zonal velocity','FontSize',fontsize+3,'fontweight', 'normal');
    ylabel('Depth (km)');% xlabel('y (km)')
    set(gca,'XTick',XTICK);xlim(XLIM)
    set(gca,'YTick',[0:0.5:4]);ylim(YLIM)
    set(gca,'FontSize',fontsize);
    handle=colorbar;set(handle,'position',[0.963 0.23 0.005 0.5]);
    annotation('textbox',[0.958 0.72 0.05 0.05],'String','(m/s)','FontSize',fontsize,'LineStyle','None');
    text3 = text(ax3,191,1.3,{'u, west of the trough','(x = -50 km)'},'FontSize',fontsize,'color',darkgray);
    % text(ax3,192,1,{'(c)'},'FontSize',fontsize+2);
    annotation('textbox',[0.668 1 0.15 0.01],'String','c','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');


    %%% Plotting options
    ax4 = subplot('position',[0.042 0.385 panelsize]);
%     annotation('textbox',[0 0.66 0.15 0.01],'String','(d)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(yy/1000,-zz/1000,t2');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,t2,[-2:0.5:2.5],'EdgeColor','k');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,t2,[1.8:0.05:2.5],'k--');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',3);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',3);hold off;
    shading interp;axis ij;colormap(cmocean('balance'));
    clim([-2.3 2.3])
    ylabel('Depth (km)');
    set(gca,'XTick',XTICK);xlim(XLIM)
    set(gca,'YTick',[0:0.5:4]);ylim(YLIM)
    set(gca,'FontSize',fontsize);
    text4 = text(ax4,191,1.3,{'\theta, trough center','(x = 0 km)'},'FontSize',fontsize,'color',darkgray);
    % text(ax4,192,1,{'(d)'},'FontSize',fontsize+2);
    annotation('textbox',[0.001 0.66 0.15 0.01],'String','d','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');


    ax5 = subplot('position',[0.375 0.385 panelsize]);
%     annotation('textbox',[0.33 0.66 0.15 0.01],'String','(e)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(yy/1000,-zz/1000,s2');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,s2,[32:0.2:35],'EdgeColor','k');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,s2,[34.7:0.01:35],'k--');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',3);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',3);hold off;
    shading interp;axis ij;colormap(cmocean('balance'));
    clim([33.5 34.9]);
    ylabel('Depth (km)');
    set(gca,'XTick',XTICK);xlim(XLIM)
    set(gca,'YTick',[0:0.5:4]);ylim(YLIM)
    set(gca,'FontSize',fontsize);
    text5 = text(ax5,191,1.3,{'S, trough center','(x = 0 km)'},'FontSize',fontsize,'color',darkgray);
    % text(ax5,192,1,{'(e)'},'FontSize',fontsize+2);
    annotation('textbox',[0.336 0.66 0.15 0.01],'String','e','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');

    ax6 = subplot('position',[0.71 0.385 panelsize]);
%     annotation('textbox',[0.665 0.66 0.15 0.01],'String','(f)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(yy/1000,-zz/1000,u2');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,u2,[-0.2:0.02:0],'k--');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,u2,[0:0.02:0.2],'EdgeColor','k');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',3);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',3);hold off;
    shading interp;axis ij;colormap(cmocean('balance'));
    clim([-0.15 0.15])
    ylabel('Depth (km)');
    set(gca,'XTick',XTICK);xlim(XLIM)
    set(gca,'YTick',[0:0.5:4]);ylim(YLIM)
    set(gca,'FontSize',fontsize);
    text6 = text(ax6,191,1.3,{'u, trough center','(x = 0 km)'},'FontSize',fontsize,'color',darkgray);
    % text(ax6,192,1,{'(f)'},'FontSize',fontsize+2);
    annotation('textbox',[0.668 0.66 0.15 0.01],'String','f','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');



    %%% Plotting options
    ax7 = subplot('position',[0.042 0.07 panelsize]);
%     annotation('textbox',[0 0.345 0.15 0.01],'String','(g)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(yy/1000,-zz/1000,t3');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,t3,[-2:0.5:2.5],'EdgeColor','k');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,t3,[1.8:0.05:2.5],'k--');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',3);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',3);hold off;
    shading interp;axis ij;colormap(cmocean('balance'));
    clim([-2.3 2.3])
    ylabel('Depth (km)');
    xlabel('Latitude, y (km)')
    set(gca,'XTick',XTICK);xlim(XLIM)
    set(gca,'YTick',[0:0.5:4]);ylim(YLIM)
    set(gca,'FontSize',fontsize);
    text7 = text(ax7,191,1.3,{'\theta, east of the trough','(x = 50 km)'},'FontSize',fontsize,'color',darkgray);
    % text(ax7,192,1,{'(g)'},'FontSize',fontsize+2);
    annotation('textbox',[0.001 0.345 0.15 0.01],'String','g','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');

    ax8 = subplot('position',[0.375 0.07 panelsize]);
%     annotation('textbox',[0.33 0.345 0.15 0.01],'String','(h)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(yy/1000,-zz/1000,s3');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,s3,[32:0.2:35],'EdgeColor','k');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,s3,[34.7:0.01:35],'k--');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',3);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',3);hold off;
    shading interp;axis ij;colormap(cmocean('balance'));
    clim([33.5 34.9]);
    ylabel('Depth (km)');
    xlabel('Latitude, y (km)')
    set(gca,'XTick',XTICK);xlim(XLIM)
    set(gca,'YTick',[0:0.5:4]);ylim(YLIM)
    set(gca,'FontSize',fontsize);
    text8 = text(ax8,191,1.3,{'S, east of the trough','(x = 50 km)'},'FontSize',fontsize,'color',darkgray);
    % text(ax8,192,1,{'(h)'},'FontSize',fontsize+2);
    annotation('textbox',[0.335 0.345 0.15 0.01],'String','h','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');


    ax9 = subplot('position',[0.71 0.07 panelsize]);
%     annotation('textbox',[0.665 0.345 0.15 0.01],'String','(i)','FontSize',fontsize+2,'LineStyle','None');
    pcolor(yy/1000,-zz/1000,u3');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,u3,[-0.2:0.02:0],'k--');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,u3,[0:0.02:0.2],'EdgeColor','k');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',3);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',3);hold off;
    shading interp;axis ij;colormap(cmocean('balance'));
    clim([-0.15 0.15])
    ylabel('Depth (km)');
    xlabel('Latitude, y (km)')
    set(gca,'XTick',XTICK);xlim(XLIM)
    set(gca,'YTick',[0:0.5:4]);ylim(YLIM)
    set(gca,'FontSize',fontsize);
    text9 = text(ax9,191,1.3,{'u, east of the trough','(x = 50 km)'},'FontSize',fontsize,'color',darkgray);
    % text(ax9,192,1,{'(i)'},'FontSize',fontsize+2);
    annotation('textbox',[0.668 0.345 0.15 0.01],'String','i','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');


%%

     figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots/fig3/';
     print('-dpng','-r300',[figdir 'fig3-cavity.png']);




