%%% 
%%% plot_seaice.m
%%%
%%% Plot sea ice properties



%     clear;
    
    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;

%     expdir = '/Users/csi/MITgcm_UC/experiments/shelfice_double_obcs/';
%     expname = 'res2km_Ua-4Va4_Atide0_Hi1Ai1_Ws40_seaice_flatIsopyc_stempede2';
%     loadexp;
% 
%     nIter = 1191767;
%     year = num2str(6.5);

    SIuice = rdmds([exppath,'/results/SIuice'],nIter);
    SIvice = rdmds([exppath,'/results/SIvice'],nIter);
    SIheff = rdmds([exppath,'/results/SIheff'],nIter);
    SIarea = rdmds([exppath,'/results/SIarea'],nIter);

%         THETA = rdmds([exppath,'/results/THETA'],nIter);
%         aaa = squeeze(THETA(1,:,:));
%         pcolor(aaa);shading flat;colorbar;

    [YY,XX] = meshgrid(yy,xx);
    fontsize = 16;
    
    SIuice(SIheff==0)=NaN;
    SIvice(SIheff==0)=NaN;
    SIarea(SIheff==0)=NaN;
    SIheff(SIheff==0)=NaN;

    figure()
    clf;
    set(gcf,'Position',[-35   211  1638  901]);
    subplot(2,2,1)
    pcolor(xx/1000,yy/1000,SIheff')
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap(flip(WhiteBlueGreenYellowRed(4)));
    ylabel('Latitude (km)');
    caxis([0.6 1.2])
    title('Sea ice thickness (m)')
    set(gca,'FontSize',fontsize);

    subplot(2,2,2)
    pcolor(xx/1000,yy/1000,SIarea')
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;
    ylabel('Latitude (km)');
    caxis([0.6 1])
    title('Sea ice fraction')
    set(gca,'FontSize',fontsize);

    subplot(2,2,3)
    pcolor(xx/1000,yy/1000,SIuice')
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;
    ylabel('Latitude (km)');
    caxis([-0.09 0])
    title('Zonal ice velocity (m/s)')
    set(gca,'FontSize',fontsize);

    subplot(2,2,4)
    pcolor(xx/1000,yy/1000,SIvice')
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;
    ylabel('Latitude (km)');
    caxis([-0.01 0])
    title('Meridional ice velocity (m/s)')
    set(gca,'FontSize',fontsize);

    print('-dpng','-r150',[figdir 'Year' year '_seaice.png']);



