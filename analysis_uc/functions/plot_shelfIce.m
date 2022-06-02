    %%% 
    %%% plot_shelIce.m
    %%%
    %%% Plot melt rate and heat flux of the ice shelf, and momentum tendency from ice-shelf drag

%     clear;
    
    %%% Add path
    addpath functions/
    addpath colormaps;
    addpath colormaps/cmocean/;

%     expdir = '/Users/csi/MITgcm_UC/experiments/shelfice_obcsE_orlanskiW/';
%     expname = 'res2km_Ua-5Va5_Atide0_Hi0Ai0_Ws30_CDWflatBot-tiltSurf_OBbalanceFacN-1_ardbeg';
%     loadexp;

    figdir = [exppath '/img/'];

%     %%% Load data
%     nIter = 556518;
%     year = num2str(3);

    %%% Grid spacing matrices
    DX = repmat(delX',[1 Ny Nr]);
    DY = repmat(delY,[Nx 1 Nr]);
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    [YY,XX] = meshgrid(yy,xx);
    t1day = 86400;
    t1year = 365*t1day;
    rho_i = 920;
    RAC = rdmds([exppath,'/results/RAC']);

    %%% Frequency of diagnostic output
    dumpFreq = abs(diag_frequency(1));
    nDumps = round(nTimeSteps*deltaT/dumpFreq);
    dumpIters = round((1:nDumps)*dumpFreq/deltaT);
    dumpIters = dumpIters(dumpIters > nIter0);
    nDumps = length(dumpIters);

    %%% Calculate timeseries of ice shelf melt rate
    ntime = zeros(1,nDumps);
    totalMelt_series = zeros(1,nDumps);
    MeltRate_series = zeros(1,nDumps);
    nT = 0;


    for n=1:nDumps
     
      ntime(n) =  dumpIters(n)*deltaT/86400; 
      fwflx = rdmds([exppath,'/results/SHIfwFlx'],dumpIters(n));
      if (isempty(fwflx))
        break;
      end

      RAC (fwflx==0)=NaN;
      fwflx (fwflx==0)=NaN;
      totalMelt_series(n) = -sum(fwflx.*RAC,'all','omitnan')*t1year/1e12;  %%% Gt/yr
      MeltRate_series(n)  = -sum(fwflx.*RAC,'all','omitnan')*t1year/rho_i/sum(RAC,'all','omitnan'); %%% m/yr
      nT = nT +1;
    end




    %%% Calculate ice shelf melt rate of one output file

    SHIfwFlx = rdmds([exppath,'/results/SHIfwFlx'],nIter);
    SHIhtFlx = rdmds([exppath,'/results/SHIhtFlx'],nIter);
    SHI_TauX = rdmds([exppath,'/results/SHI_TauX'],nIter);
    SHI_TauY = rdmds([exppath,'/results/SHI_TauY'],nIter);
    SHIForcT = rdmds([exppath,'/results/SHIForcT'],nIter);
    SHIForcS = rdmds([exppath,'/results/SHIForcS'],nIter);
    

    SHIfwFlx (SHIfwFlx==0)=NaN;
    totalMelt = -sum(SHIfwFlx.*RAC,'all','omitnan')*t1year/1e12; %%% Gt/yr
    MeltRate = -sum(SHIfwFlx.*RAC,'all','omitnan')*t1year/rho_i/sum(RAC,'all','omitnan'); %%% m/yr


    %%% Plot
    fontsize = 16;


    %%% plot timeseries of ice shelf melt rates
    figure()
    plot(ntime(1:nT)/365,MeltRate_series(1:nT),'LineWidth',2)
    axis tight;
    xlabel('t (years)');
    ylabel('Melt rate (m/yr)');
    set(gca,'FontSize',fontsize);

    print('-dpng','-r150',[figdir 'series_MeltRate.png']);


    %%% plot spatial pattern of ice shelf fluxes
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
    text(-140,140,['Melt rate = ' num2str(round(totalMelt)) ' Gt/yr, ' num2str(round(MeltRate,1)) ' m/yr'],'FontSize', fontsize+2);
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
    text(-140,140,['Melt rate = ' num2str(round(totalMelt)) ' Gt/yr, ' num2str(round(MeltRate,1)) ' m/yr'],'FontSize', fontsize+2);
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
    text(-140,140,['Melt rate = ' num2str(round(totalMelt)) ' Gt/yr, ' num2str(round(MeltRate,1)) ' m/yr'],'FontSize', fontsize+2);
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
    text(-140,140,['Melt rate = ' num2str(round(totalMelt)) ' Gt/yr, ' num2str(round(MeltRate,1)) ' m/yr'],'FontSize', fontsize+2);
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
    text(-140,140,['Melt rate = ' num2str(round(totalMelt)) ' Gt/yr, ' num2str(round(MeltRate,1)) ' m/yr'],'FontSize', fontsize+2);
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
    text(-140,140,['Melt rate = ' num2str(round(totalMelt)) ' Gt/yr, ' num2str(round(MeltRate,1)) ' m/yr'],'FontSize', fontsize+2);
    set(gca,'FontSize',fontsize);

    print('-dpng','-r150',[figdir 'Year' year '_ShelfIce.png']);





    