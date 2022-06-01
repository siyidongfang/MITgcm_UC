    %%% 
    %%% plotShelIce
    %%%
    %%% Plot melt rate and heat flux of the ice shelf, and momentum tendency from ice-shelf drag

%     clear;
    
    %%% Add path
    addpath functions/
    addpath colormaps;
    addpath colormaps/cmocean/;

%     expdir = '/Users/csi/MITgcm_UC/experiments/shelfice_double_orlanski/';
%     expname = 'res2km_Ua-4.4Va4.4_Atide0_Hi0Ai0_Ws30_tau_max-0.05_hoffman2';
%     loadexp;

    figdir = [exppath '/img/'];

    %%% Load data
    nIter = 733395;
    year = num2str(4);

    SHIfwFlx = rdmds([exppath,'/results/SHIfwFlx'],nIter);
    SHIhtFlx = rdmds([exppath,'/results/SHIhtFlx'],nIter);
    SHI_TauX = rdmds([exppath,'/results/SHI_TauX'],nIter);
    SHI_TauY = rdmds([exppath,'/results/SHI_TauY'],nIter);
    SHIForcT = rdmds([exppath,'/results/SHIForcT'],nIter);
    SHIForcS = rdmds([exppath,'/results/SHIForcS'],nIter);
    RAC = rdmds([exppath,'/results/RAC']);

    %%% Grid spacing matrices
    DX = repmat(delX',[1 Ny Nr]);
    DY = repmat(delY,[Nx 1 Nr]);
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    [YY,XX] = meshgrid(yy,xx);
    t1day = 86400;
    t1year = 365*t1day;

    %%% Calculate ice shelf melt rate
    totalMelt = -sum(sum(SHIfwFlx.*RAC))*t1year/1e12 %%% Gt/yr
    rho_i = 920;
    SHIfwFlx (SHIfwFlx==0)=NaN;
    MeltRate = -mean(SHIfwFlx/rho_i,'all','omitnan')*t1year %%% m/yr


    %%% Plot
    fontsize = 16;

    figure()
    clf;
    set(gcf,'Position',[226 1542 1397 843])
    subplot(3,2,1)
    pcolor(xx/1000,yy/1000,SHIfwFlx')
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap('redblue')
    ylabel('Latitude (km)');
    limc = max(max(abs(SHIfwFlx)));
    caxis([-limc limc])
    ylim([0 150]);xlim([-150 150])
    title('Ice shelf fresh water flux (kg/m^2/s), positive upward')
    set(gca,'FontSize',fontsize);

    subplot(3,2,2)
    pcolor(xx/1000,yy/1000,SHIhtFlx')
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap('redblue')
    ylabel('Latitude (km)');
    limc = max(max(abs(SHIhtFlx)));
    caxis([-limc limc])
    ylim([0 150]);xlim([-150 150])
    title('Ice shelf heat flux (W/m^2), positive upward')
    set(gca,'FontSize',fontsize);

    subplot(3,2,3)
    pcolor(xx/1000,yy/1000,SHIForcT')
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap('redblue')
    ylabel('Latitude (km)');
    limc = max(max(abs(SHIForcT)));
    caxis([-limc limc])
    ylim([0 150]);xlim([-150 150])
    title('Ice shelf forcing for theta (W/m^2), >0 increases theta')
    set(gca,'FontSize',fontsize);

    subplot(3,2,4)
    pcolor(xx/1000,yy/1000,SHIForcS')
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap('redblue')
    ylabel('Latitude (km)');
    limc = max(max(abs(SHIForcS)));
    caxis([-limc limc])
    ylim([0 150]);xlim([-150 150])
    title('Ice shelf forcing for salt (g/m^2/s), >0 increases salt')
    set(gca,'FontSize',fontsize);

    subplot(3,2,5)
    pcolor(xx/1000,yy/1000,SHI_TauX')
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap('redblue')
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    limc = max(max(abs(SHI_TauX)));
    caxis([-limc limc]/10)
    ylim([0 150]);xlim([-150 150])
    title('Ice shelf bottom stress, >0 increases uVel')
    set(gca,'FontSize',fontsize);

    subplot(3,2,6)
    pcolor(xx/1000,yy/1000,SHI_TauY')
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
    shading flat;colorbar;colormap('redblue')
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    limc = max(max(abs(SHI_TauY)));
    caxis([-limc limc]/10)
    ylim([0 150]);xlim([-150 150])
    title('Ice shelf bottom stress, >0 increases vVel')
    set(gca,'FontSize',fontsize);

    print('-dpng','-r150',[figdir 'Year' year '_ShelfIce.png']);

    