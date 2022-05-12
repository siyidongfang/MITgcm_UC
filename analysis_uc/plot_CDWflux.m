    %%%
    %%% Plot volume flux and heat flux of CDW (pt>0.5 degC) as a function of 
    %%% latitude and longitude
    %%%
    
    
    clear;
    
    %%% Add path
    addpath ../analysis/colormaps;
    addpath ../analysis/jpo_analysis-hires/;
    addpath ../analysis/colormaps/cmocean/;
    expdir = '/Users/csi/MITgcm_UC/experiments/shelfice_double_obcs/';
    expname = 'res2km_Ua-2Va1_Atide0_Hi0Ai0_Ws30_ardbeg';
    loadexp;

    figdir = [exppath '/img/'];
    year = num2str(8);

    %%% Load data
    nIter = 1341957;
    tt = rdmds([exppath,'/results/THETA'],nIter);
    ss = rdmds([exppath,'/results/SALT'],nIter);
    uu = rdmds([exppath,'/results/UVEL'],nIter);
    vv = rdmds([exppath,'/results/VVEL'],nIter);
    %     ut = 
    vt = rdmds([exppath,'/results/VVELTH'],nIter);
    
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
    tt_cdw(tt<0.5)=NaN; %%% Find the CDW layer: temperature above 0.5 degC
    ss_cdw = ss;
    ss_cdw(tt<0.5)=NaN;
    
    idx_cdw = tt_cdw./tt_cdw;
    uu_cdw = uu_tgrid.*idx_cdw; %%% zonal velocity of the CDW layer
    vv_cdw = vv_tgrid.*idx_cdw; %%% meridional velocity of the CDW layer
    vt_cdw = vt_tgrid.*idx_cdw;

    HH = sum(idx_cdw.*DZ.*hFacC,3,'omitnan'); %%% CDW thickness
    HH(HH==0)=NaN;
    TT = sum(tt_cdw.*DZ.*hFacC,3,'omitnan')./HH; %%% Depth-averaged temperature of the CDW layer
    SS = sum(ss_cdw.*DZ.*hFacC,3,'omitnan')./HH; %%% Depth-averaged salinity of the CDW layer
    
    %%% Vertically integrate uu_cdw and vv_cdw to get the volume flux
    UU = sum(uu_cdw.*DZ.*hFacC,3,'omitnan');
    VV = sum(vv_cdw.*DZ.*hFacC,3,'omitnan');
    
    %%% Calculate vertically integrated heat flux of the CDW layer
    Fheat = rho_o*cp_o*sum(vt_cdw.*DZ.*hFacC,3,'omitnan'); % in W/m
    Fheat_xz = rho_o*cp_o*squeeze(sum(sum(vt.*delX(1).*DZ.*hFacS,3)))/1e12;%%% Zonally and depth-integrated, in TW
    
    %%% Make plots!
    fontsize = 16;
    
    figure(1)
    %     set(gcf,'Position',[-104 254 1712 396])
    set(gcf,'Position',[-42 576 1684 278])
    subplot(1,3,1)
    pcolor(xx/1000,yy/1000,TT');
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap(cmocean('delta'));
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title('Depth-averaged PT of the CDW layer (^oC)')
    set(gca,'FontSize',fontsize);
    caxis([0.5 2])
    
    subplot(1,3,2)
    pcolor(xx/1000,yy/1000,SS');
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap(WhiteBlueGreenYellowRed(0))
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title('Depth-averaged salinity of the CDW layer (psu)')
    set(gca,'FontSize',fontsize);
    caxis([34.3 34.9])
    
    subplot(1,3,3)
    pcolor(xx/1000,yy/1000,HH');
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap(WhiteBlueGreenYellowRed(0))
    % colormap(cmocean('delta'));
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title('CDW thickness (m)')
    set(gca,'FontSize',fontsize);
    caxis([0 2000])

    
    print('-dpng','-r150',[figdir 'Year' year '_fig1_CDW.png']);

    
    figure(2)
    %     set(gcf,'Position',[284 349 580 511])
    set(gcf,'Position',[25 367 805 426])
    pcolor(xx/1000,yy/1000,-Fheat'/1e9);
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    hold on;
    svx = 8; svy = 8;
    curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:end)'/1000, ...
    UU(1:svx:end,1:svy:end)',VV(1:svx:end,1:svy:end)');
    curr.Color = [0 102 0]/255;
    curr.LineWidth = 1.5;
    hold off;
    shading flat;colorbar;colormap('redblue')
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title({'Shoreward CDW heat flux (color, GW/m)', 'and CDW volume flux (vector)'})
    set(gca,'FontSize',fontsize);
     caxis([-1 1])
    %     caxis([-max(max(abs(Fheat/1e9))) max(max(abs(Fheat/1e9)))])

    print('-dpng','-r150',[figdir 'Year' year '_fig2_heat_flux.png']);

    
    figure(3)
    %     set(gcf,'Position',[284 349 636*2 511])
    set(gcf,'Position',[1 203 1446 346])
    subplot(1,2,1)
    pcolor(xx/1000,yy/1000,-VV');
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap('redblue')
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title('Shoreward CDW volume flux (m^2/s), -V')
    set(gca,'FontSize',fontsize);
    caxis([-1 1]*300)

    subplot(1,2,2)
    pcolor(xx/1000,yy/1000,UU');
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap('redblue')
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    title('Eastward CDW volume flux (m^2/s), U')
    set(gca,'FontSize',fontsize);
    caxis([-1 1]*300)
    %     caxis([-max(max(abs(Fheat/1e9))) max(max(abs(Fheat/1e9)))])

    print('-dpng','-r150',[figdir 'Year' year '_fig3_volume_flux.png']);
%%
    
    figure(4)
        set(gcf,'Position',[284 349 636*2 400])
    clf;
    subplot(1,2,1)
    uu(uu==0)=NaN;
    aaa1 = squeeze(mean(uu,'omitnan'));
    pcolor(yy/1000,-zz/1000,aaa1');
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(125,:)/1000,'k','LineWidth',2);plot(yy(1:70)/1000,-bathy(150,1:70)/1000,'k--','LineWidth',1.5);
    shading interp;axis ij;colormap('redblue');colorbar
    caxis([-0.4 0.4]/2)
    title('Zonal velocity (m/s)')
    ylabel('Depth (km)');xlabel('y (km)')
    set(gca,'XTick',[0:100:400]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(1,2,2) 
    vtheta_xavg = squeeze(mean(vt,1,'omitnan'));
    vtheta_xavg(vtheta_xavg==0)=NaN;
    pcolor(yy/1000,-zz/1000,1000*vtheta_xavg');shading interp
    caxis([-80 80]/2);colorbar
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(125,:)/1000,'k','LineWidth',2);plot(yy(1:70)/1000,-bathy(150,1:70)/1000,'k--','LineWidth',1.5);
    set(gca,'FontSize',fontsize)
    title('Advective heat flux {\it F}_{total} (blue = shoreward)','FontSize', fontsize+2,'FontWeight','normal');
    ylabel('Depth (km)');xlabel('y (km)')
    ylim([0 4]) 
    set(gca,'YDir','reverse');
    set(gca,'XTick',[0:100:400]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);
    print('-dpng','-r150',[figdir 'Year' year '_fig4_zonal_u_vt.png']);
    

    figure(5)
    [ZZ,YY] = meshgrid(zz,yy);
    set(gcf,'Position',[284 349 636*2 400])
    clf;
    subplot(1,2,1)
    aaa1 = zeros(Ny,Nr);
    aaa1(2:end,:) = squeeze(mean(tt(1:end-1,2:end,:)));
    aaa1(aaa1==0)=NaN;
    pcolor(yy/1000,-zz/1000,aaa1');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,aaa1,[-2:0.2:2],'EdgeColor','k');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(125,:)/1000,'k','LineWidth',2);plot(yy(1:70)/1000,-bathy(150,1:70)/1000,'k--','LineWidth',1.5);
    shading flat;axis ij;colormap('redblue');colorbar
    caxis([-2 2])
    title('Zonal-average potential temperature (^oC)')
    ylabel('Depth (km)');xlabel('y (km)')
    set(gca,'XTick',[0:100:400]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);

    subplot(1,2,2)
    aaa1 = zeros(Ny,Nr);
    aaa1(2:end,:) = squeeze(mean(ss(1:end-1,2:end,:)));
    aaa1(aaa1==0)=NaN;
    pcolor(yy/1000,-zz/1000,aaa1');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,aaa1,[32:0.1:35],'EdgeColor','k');hold off;
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,aaa1,[34.66:0.01:35],'k--');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(125,:)/1000,'k','LineWidth',2);plot(yy(1:70)/1000,-bathy(150,1:70)/1000,'k--','LineWidth',1.5);
    shading flat;axis ij;colormap('redblue');colorbar
    caxis([33.5 34.9]);
    title('Zonal-average salinity (psu)')
    ylabel('Depth (km)');xlabel('y (km)')
    set(gca,'XTick',[0:100:400]);
    set(gca,'YTick',[0:1:4]);ylim([0 4])
    set(gca,'FontSize',fontsize);


    print('-dpng','-r150',[figdir 'Year' year '_fig5_zonal_T_S.png']);
