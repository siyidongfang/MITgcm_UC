    %%%
    %%% Plot volume flux and heat flux of CDW (pt>0 degC) as a function of 
    %%% latitude and longitude
    %%%
    
    
%     clear;
    
    %%% Add path
    addpath functions/
    addpath colormaps;
    addpath colormaps/cmocean/;

%     expdir = '/Users/csi/MITgcm_UC/experiments/shelfice_double_obcs/';
%     expname = 'res2km_Ua-4Va4_Atide0_Hi0Ai0_Ws40_flatIsopyc_stampede2'
%     loadexp;

    figdir = [exppath '/img/'];

%     nIter = 1191767;
%     year = num2str(6.5);

    %%% Load data

    useSHELFICE = true;
    
    tt = rdmds([exppath,'/results/THETA'],nIter);
    ss = rdmds([exppath,'/results/SALT'],nIter);
    uu = rdmds([exppath,'/results/UVEL'],nIter);
    vv = rdmds([exppath,'/results/VVEL'],nIter);
    vt = rdmds([exppath,'/results/VVELTH'],nIter);
    eta = rdmds([exppath,'/results/ETAN'],nIter);

    rho_o = 1000;
    cp_o = 3994; % Unit: J/kg/degC

    %%% Grid spacing matrices
    DX = repmat(delX',[1 Ny Nr]);
    DY = repmat(delY,[Nx 1 Nr]);
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    [YY,XX] = meshgrid(yy,xx);
    
    %%% Find u,v,t of the CDW layer
    uu_tgrid = (uu+uu([2:Nx 1],:,:))/2;                       % mass-grid
    vv_tgrid = zeros(Nx,Ny,Nr);
    vv_tgrid(:,1:Ny-1,:) = (vv(:,1:Ny-1,:)+vv(:,2:Ny,:))/2;   % mass-grid
    vt_tgrid = zeros(Nx,Ny,Nr);
    vt_tgrid(:,1:Ny-1,:) = (vt(:,1:Ny-1,:)+vt(:,2:Ny,:))/2;   % mass-grid

    tt_cdw = tt;
    tt_cdw(tt<0)=NaN; %%% Find the CDW layer: temperature above 0 degC
    ss_cdw = ss;
    ss_cdw(tt<0)=NaN;
    
    idx_cdw = tt_cdw./tt_cdw;
    uu_cdw = uu_tgrid.*idx_cdw; %%% zonal velocity of the CDW layer
    vv_cdw = vv_tgrid.*idx_cdw; %%% meridional velocity of the CDW layer
    vt_cdw = vt_tgrid.*idx_cdw;

    HH_cdw = sum(idx_cdw.*DZ.*hFacC,3,'omitnan'); %%% CDW thickness
    HH_cdw(HH_cdw==0)=NaN;
    TT_cdw = sum(tt_cdw.*DZ.*hFacC,3,'omitnan')./HH_cdw; %%% Depth-averaged temperature of the CDW layer
    SS_cdw = sum(ss_cdw.*DZ.*hFacC,3,'omitnan')./HH_cdw; %%% Depth-averaged salinity of the CDW layer
    
    %%% Vertically integrate uu_cdw and vv_cdw to get the volume flux
    UU_cdw = sum(uu_cdw.*DZ.*hFacC,3,'omitnan');
    VV_cdw = sum(vv_cdw.*DZ.*hFacC,3,'omitnan');
    
    %%% Calculate vertically integrated heat flux of the CDW layer
    Fheat = rho_o*cp_o*sum(vt_cdw.*DZ.*hFacC,3,'omitnan'); % in W/m
    Fheat_xz = rho_o*cp_o*squeeze(sum(sum(vt.*delX(1).*DZ.*hFacS,3)))/1e12;%%% Zonally and depth-integrated, in TW
    
    %%% Make plots!
    fontsize = 16;
    
    figure()
    %     set(gcf,'Position',[-104 254 1712 396])
    set(gcf,'Position',[-42 576 1684 278])
    subplot(1,3,1)
    pcolor(xx/1000,yy/1000,TT_cdw');
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap(cmocean('delta'));
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title('Depth-averaged PT of the CDW layer (^oC)')
    set(gca,'FontSize',fontsize);
    caxis([0 2])
    
    subplot(1,3,2)
    pcolor(xx/1000,yy/1000,SS_cdw');
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap(WhiteBlueGreenYellowRed(0))
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title('Depth-averaged salinity of the CDW layer (psu)')
    set(gca,'FontSize',fontsize);
    caxis([34.3 34.9])
    
    subplot(1,3,3)
    pcolor(xx/1000,yy/1000,HH_cdw');
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap(WhiteBlueGreenYellowRed(0))
    % colormap(cmocean('delta'));
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title('CDW thickness (m)')
    set(gca,'FontSize',fontsize);
    caxis([0 3000])

    
    print('-dpng','-r150',[figdir 'Year' year '_fig1_CDW.png']);

    
    figure()
    %     set(gcf,'Position',[284 349 580 511])
    set(gcf,'Position',[25 367 805 426])
    pcolor(xx/1000,yy/1000,-Fheat'/1e9);
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    hold on;
    svx = 8; svy = 8;
    curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:end)'/1000, ...
    UU_cdw(1:svx:end,1:svy:end)',VV_cdw(1:svx:end,1:svy:end)');
    curr.Color = [0 102 0]/255;
    curr.LineWidth = 1.5;
    hold off;
    shading flat;colorbar;colormap('redblue');
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title({'Shoreward CDW heat flux (color, GW/m)', 'and CDW volume flux (vector)'})
    set(gca,'FontSize',fontsize);
     caxis([-1 1]/5)
    %     caxis([-max(max(abs(Fheat/1e9))) max(max(abs(Fheat/1e9)))])

    print('-dpng','-r150',[figdir 'Year' year '_fig2_heat_flux.png']);

    
    figure()
    %     set(gcf,'Position',[284 349 636*2 511])
    set(gcf,'Position',[1 203 1446 346])
    subplot(1,2,1)
    pcolor(xx/1000,yy/1000,-VV_cdw');
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap('redblue');
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title('Shoreward CDW volume flux (m^2/s), -V')
    set(gca,'FontSize',fontsize);
    caxis([-1 1]*50)

    subplot(1,2,2)
    pcolor(xx/1000,yy/1000,UU_cdw');
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap('redblue');
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title('Eastward CDW volume flux (m^2/s), U')
    set(gca,'FontSize',fontsize);
    caxis([-1 1]*50)
    %     caxis([-max(max(abs(Fheat/1e9))) max(max(abs(Fheat/1e9)))])

    print('-dpng','-r150',[figdir 'Year' year '_fig3_volume_flux.png']);

    
    figure()
    set(gcf,'Position',[284 349 636*2 400])
    clf;
    subplot(1,2,1)
    uu(uu==0)=NaN;
    aaa1 = squeeze(mean(uu,'omitnan'));
    pcolor(yy/1000,-zz/1000,aaa1');
hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading interp;axis ij;colormap('redblue');colorbar
    caxis([-0.15 0.15])
    title('Zonal velocity (m/s)')
    ylabel('Depth (km)');xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(1,2,2) 
    vtheta_xavg = squeeze(mean(vt,1,'omitnan'));
    vtheta_xavg(vtheta_xavg==0)=NaN;
    pcolor(yy/1000,-zz/1000,1000*vtheta_xavg');shading interp
    caxis([-80 80]/4);colorbar
hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    set(gca,'FontSize',fontsize)
    title('Advective heat flux {\it F}_{total} (blue = shoreward)','FontSize', fontsize+2,'FontWeight','normal');
    ylabel('Depth (km)');xlabel('y (km)')
    ylim([0 4]) 
    set(gca,'YDir','reverse');
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);
    print('-dpng','-r150',[figdir 'Year' year '_fig4_zonal_u_vt.png']);
    

    figure()
    [ZZ,YY] = meshgrid(zz,yy);
    set(gcf,'Position',[284 349 636*2 400])
    clf;
    subplot(1,2,1)
    tt(tt==0)=NaN;
    aaa1= squeeze(mean(tt(2:end-1,:,:),'omitnan'));
    pcolor(yy/1000,-zz/1000,aaa1');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,aaa1,[-2:0.3:2],'EdgeColor','k');hold off;
hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading flat;axis ij;colormap(cmocean('balance'));colorbar
    caxis([-2.3 2.3])
    title('Zonal-average potential temperature (^oC)')
    ylabel('Depth (km)');xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(1,2,2)
    aaa1 = zeros(Ny,Nr);
    ss(ss==0)=NaN;
    aaa1= squeeze(mean(ss(2:end-1,:,:),'omitnan'));
    pcolor(yy/1000,-zz/1000,aaa1');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,aaa1,[32:0.1:35],'EdgeColor','k');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,aaa1,[34.66:0.01:35],'k--');hold off;
hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading flat;axis ij;colormap(cmocean('balance'));colorbar
    caxis([33.5 34.9]);
    title('Zonal-average salinity (psu)')
    ylabel('Depth (km)');xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);


    print('-dpng','-r150',[figdir 'Year' year '_fig5_zonal_T_S.png']);



    figure()
    [YY,XX] = meshgrid(yy,xx);
    set(gcf,'Position',[1 203 1446 346])
    u_surf = uu(:,:,1);
    v_surf = vv(:,:,1);
    u_surf_vorgrid = zeros(Nx,Ny);
    u_surf_vorgrid(:,2:Ny) = (u_surf(:,1:Ny-1)+ u_surf(:,2:Ny))/2; % vorticity-gird
    v_surf_vorgrid = (v_surf+ v_surf([2:Nx 1],:))/2; % vorticity-gird
    speed_surf = sqrt(u_surf_vorgrid.^2+v_surf_vorgrid.^2);
    u_depthavg = sum(uu.*DZ.*hFacW,3,'omitnan')./sum(DZ.*hFacW,3,'omitnan');
    v_depthavg = sum(vv.*DZ.*hFacS,3,'omitnan')./sum(DZ.*hFacS,3,'omitnan');
    u_depthavg_vorgrid = zeros(Nx,Ny);
    u_depthavg_vorgrid(:,2:Ny) = (u_depthavg(:,1:Ny-1,:)+ u_depthavg(:,2:Ny,:))/2; % vorticity-gird 
    v_depthavg_vorgrid = (v_depthavg+ v_depthavg([2:Nx 1],:))/2; % vorticity-gird
    speed_depthavg = sqrt(u_depthavg_vorgrid.^2+v_depthavg_vorgrid.^2);
    subplot(1,2,1)
    pcolor(xx/1000,yy/1000,u_surf');
    caxis([-0.3 0.3])
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    hold on;
    svx = 8; svy = 8;
    curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:end)'/1000, ...
    u_surf(1:svx:end,1:svy:end)',v_surf(1:svx:end,1:svy:end)');
    curr.Color = [0 102 0]/255;
    curr.LineWidth = 1.5;
    hold off;
    shading flat;colorbar;colormap('redblue');
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title({'Surface zonal velocity (color, m/s)'})
    set(gca,'FontSize',fontsize);
    subplot(1,2,2)
    pcolor(xx/1000,yy/1000,u_depthavg');
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    hold on;
    svx = 8; svy = 8;
    curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:end)'/1000, ...
    u_depthavg(1:svx:end,1:svy:end)',v_depthavg(1:svx:end,1:svy:end)');
    curr.Color = [0 102 0]/255;
    curr.LineWidth = 1.5;
    hold off;
    caxis([-0.2 0.2])
    shading flat;colorbar;colormap('redblue');
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title({'Depth-mean zonal velocity (color, m/s)'})
    set(gca,'FontSize',fontsize);
    print('-dpng','-r150',[figdir 'Year' year '_fig6_surface_depthAvg_current.png']);



    figure()
    clf
    %     set(gcf,'Position',[284 349 580 511])
    set(gcf,'Position',[25 367 805 426])
    pcolor(xx/1000,yy/1000,eta');
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap('redblue');
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title('Surface Height Anomaly (m)')
    set(gca,'FontSize',fontsize);
%     caxis([-2.2 -1.8])
%     colormap('jet')
     caxis([-0.2 0.2])
    %     caxis([-max(max(abs(Fheat/1e9))) max(max(abs(Fheat/1e9)))])

    print('-dpng','-r150',[figdir 'Year' year '_fig7_eta.png']);




    figure()

    tt_depthavg = sum(tt.*DZ.*hFacC,3,'omitnan')./sum(DZ.*hFacC,3,'omitnan');
    ss_depthavg = sum(ss.*DZ.*hFacC,3,'omitnan')./sum(DZ.*hFacC,3,'omitnan');

    set(gcf,'Position',[1 203 1446 346*2.1])
    subplot(2,2,1)
    pcolor(xx/1000,yy/1000,tt_depthavg');
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap(cmocean('delta'));
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title('Depth-averaged PT (^oC)')
    set(gca,'FontSize',fontsize);
    caxis([-1 2])
    
    subplot(2,2,2)
    pcolor(xx/1000,yy/1000,ss_depthavg');
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap(WhiteBlueGreenYellowRed(0))
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title('Depth-averaged salinity (psu)')
    set(gca,'FontSize',fontsize);
    caxis([34.15 34.8])

    subplot(2,2,3)
    pcolor(xx/1000,yy/1000,tt(:,:,1)');
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title('Surface PT (^oC)')
    set(gca,'FontSize',fontsize);
    caxis([-1.87 -1.85])
    
    subplot(2,2,4)
    pcolor(xx/1000,yy/1000,ss(:,:,1)');
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap(WhiteBlueGreenYellowRed(0))
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title('Surface salinity (psu)')
    set(gca,'FontSize',fontsize);
    caxis([33.9 34])
    
    print('-dpng','-r150',[figdir 'Year' year '_fig8_depthAvg_surface.png']);




    %%

    m1km = 1000;
    L1 = 100*m1km;
    L2 = 250*m1km;
    L3 = 300*m1km;
    L4 = 350*m1km;
    L5 = 500*m1km;
    idx1 = round(L1/DX(1));
    idx2 = round(L2/DX(1));
    idx3 = round(L3/DX(1));
    idx4 = round(L4/DX(1));
    idx5 = round(L5/DX(1));
    s1 = squeeze(ss(idx1,:,:));
    t1 = squeeze(tt(idx1,:,:));
    u1 = squeeze(uu(idx1,:,:));
    s2 = squeeze(ss(idx2,:,:));
    t2 = squeeze(tt(idx2,:,:));
    u2 = squeeze(uu(idx2,:,:));
    s3 = squeeze(ss(idx3,:,:));
    t3 = squeeze(tt(idx3,:,:));
    u3 = squeeze(uu(idx3,:,:));
    s4 = squeeze(ss(idx4,:,:));
    t4 = squeeze(tt(idx4,:,:));
    u4 = squeeze(uu(idx4,:,:));
    s5 = squeeze(ss(idx5,:,:));
    t5 = squeeze(tt(idx5,:,:));
    u5 = squeeze(uu(idx5,:,:));

    [ZZ,YY] = meshgrid(zz,yy);

    figure()
    clf;
    set(gcf,'Position',[1 62 1643 1275])
    subplot(5,3,1)
    pcolor(yy/1000,-zz/1000,s1');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,s1,[32:0.3:35],'EdgeColor','k');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,s1,[34.66:0.03:35],'k--');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading flat;axis ij;colormap(cmocean('balance'));colorbar
    caxis([33.5 34.9]);
    title('S (psu), at x = -200 km')
    ylabel('Depth (km)');% xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(5,3,2)
    pcolor(yy/1000,-zz/1000,t1');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,t1,[-2:0.5:2],'EdgeColor','k');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading flat;axis ij;colormap(cmocean('balance'));colorbar
    caxis([-2.3 2.3])
    title('T (^oC), at x = -200 km')
    ylabel('Depth (km)');% xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(5,3,3)
    pcolor(yy/1000,-zz/1000,u1');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,u1,[-0.2:0.02:0],'k--');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,u1,[0:0.02:0.2],'EdgeColor','k');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading flat;axis ij;colormap(cmocean('balance'));colorbar
    caxis([-0.2 0.2])
    title('u (m/s), at x = -200 km')
    ylabel('Depth (km)');% xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(5,3,4)
    pcolor(yy/1000,-zz/1000,s2');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,s2,[32:0.3:35],'EdgeColor','k');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,s2,[34.66:0.03:35],'k--');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading flat;axis ij;colormap(cmocean('balance'));colorbar
    caxis([33.5 34.9]);
    title('S (psu), at x = -50 km')
    ylabel('Depth (km)');% xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(5,3,5)
    pcolor(yy/1000,-zz/1000,t2');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,t2,[-2:0.5:2],'EdgeColor','k');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading flat;axis ij;colormap(cmocean('balance'));colorbar
    caxis([-2.3 2.3])
    title('T (^oC), at x = -50 km')
    ylabel('Depth (km)');% xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(5,3,6)
    pcolor(yy/1000,-zz/1000,u2');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,u2,[-0.2:0.02:0],'k--');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,u2,[0:0.02:0.2],'EdgeColor','k');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading flat;axis ij;colormap(cmocean('balance'));colorbar
    caxis([-0.2 0.2])
    title('u (m/s), at x = -50 km')
    ylabel('Depth (km)');% xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(5,3,7)
    pcolor(yy/1000,-zz/1000,s3');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,s3,[32:0.3:35],'EdgeColor','k');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,s3,[34.66:0.03:35],'k--');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading flat;axis ij;colormap(cmocean('balance'));colorbar
    caxis([33.5 34.9]);
    title('S (psu), at x = 0 km')
    ylabel('Depth (km)');% xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(5,3,8)
    pcolor(yy/1000,-zz/1000,t3');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,t3,[-2:0.5:2],'EdgeColor','k');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading flat;axis ij;colormap(cmocean('balance'));colorbar
    caxis([-2.3 2.3])
    title('T (^oC), at x = 0 km')
    ylabel('Depth (km)');% xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(5,3,9)
    pcolor(yy/1000,-zz/1000,u3');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,u3,[-0.2:0.02:0],'k--');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,u3,[0:0.02:0.2],'EdgeColor','k');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading flat;axis ij;colormap(cmocean('balance'));colorbar
    caxis([-0.2 0.2])
    title('u (m/s), at x = 0 km')
    ylabel('Depth (km)');% xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);


    subplot(5,3,10)
    pcolor(yy/1000,-zz/1000,s4');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,s4,[32:0.3:35],'EdgeColor','k');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,s4,[34.66:0.03:35],'k--');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading flat;axis ij;colormap(cmocean('balance'));colorbar
    caxis([33.5 34.9]);
    title('S (psu), at x = 50 km')
    ylabel('Depth (km)');% xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(5,3,11)
    pcolor(yy/1000,-zz/1000,t4');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,t4,[-2:0.5:2],'EdgeColor','k');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading flat;axis ij;colormap(cmocean('balance'));colorbar
    caxis([-2.3 2.3])
    title('T (^oC), at x = 50 km')
    ylabel('Depth (km)');% xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(5,3,12)
    pcolor(yy/1000,-zz/1000,u4');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,u4,[-0.2:0.02:0],'k--');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,u4,[0:0.02:0.2],'EdgeColor','k');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading flat;axis ij;colormap(cmocean('balance'));colorbar
    caxis([-0.2 0.2])
    title('u (m/s), at x = 50 km')
    ylabel('Depth (km)');% xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);


    subplot(5,3,13)
    pcolor(yy/1000,-zz/1000,s5');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,s5,[32:0.3:35],'EdgeColor','k');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,s5,[34.66:0.03:35],'k--');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading flat;axis ij;colormap(cmocean('balance'));colorbar
    caxis([33.5 34.9]);
    title('S (psu), at x = 200 km')
    ylabel('Depth (km)'); xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(5,3,14)
    pcolor(yy/1000,-zz/1000,t5');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,t5,[-2:0.5:2],'EdgeColor','k');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading flat;axis ij;colormap(cmocean('balance'));colorbar
    caxis([-2.3 2.3])
    title('T (^oC), at x = 200 km')
    ylabel('Depth (km)'); xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(5,3,15)
    pcolor(yy/1000,-zz/1000,u5');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,u5,[-0.2:0.02:0],'k--');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,u5,[0:0.02:0.2],'EdgeColor','k');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    shading flat;axis ij;colormap(cmocean('balance'));colorbar
    caxis([-0.2 0.2])
    title('u (m/s), at x = 200 km')
    ylabel('Depth (km)'); xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    print('-dpng','-r150',[figdir 'Year' year '_fig9_cross_section.png']);



