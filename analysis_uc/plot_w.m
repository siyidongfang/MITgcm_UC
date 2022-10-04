%%%
%%% plot_w.m
%%% 
%%% Plot the vertical velocity of the CDW layer

    clear;close all;
    addpath functions/;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    
    prodir = ['/Users/csi/MITgcm_UC/products_uc/' exp_group '/'];
    figdir = ['/Users/csi/MITgcm_UC/figures_uc/ww/' exp_group '/'];
    useSEAICE = true;
    savefigure = false;

    n=1

    expname = EXPNAME{n}
    loadexp;
%     load([prodir expname '_tavg_5yrs.mat'],'WVEL','THETA','WVELTH');
    load_data;

    [YY,XX] = meshgrid(yy,xx);


    mask_cdw = ones(Nx,Ny,Nr);
    mask_cdw(tt<0)=NaN; %%% Find the CDW layer: temperature above 0 degC
    tt_mask = tt.*mask_cdw;
    tt_mask(tt_mask==0)=NaN;

    ww_cdw = zeros(Nx,Ny);
    wt_cdw = zeros(Nx,Ny);
    zz_cdw = zeros(Nx,Ny);
    for i=1:Nx
        for j=1:Ny
            k_cdw = find(~isnan(tt_mask(i,j,:)),1);
            if(~isempty(k_cdw))
                zz_cdw(i,j)= zz(k_cdw);
                ww_cdw(i,j)= ww(i,j,k_cdw);
                wt_cdw(i,j)= wt(i,j,k_cdw);
            end
        end
    end

    ww_cdw(ww_cdw==0)=NaN;
    wt_cdw(wt_cdw==0)=NaN;
    zz_cdw(zz_cdw==0)=NaN;

    %%% Plotting options
    scrsz = get(0,'ScreenSize');
    fontsize = 17;
    framepos = [0 scrsz(4)/2 900 550];
    plotloc = [0.15 0.15 0.7 0.75];

    %%% Make the plot
    handle = figure(1);
    set(handle,'Position',framepos);
    clf;
    set(gcf,'color','w');
    pcolor(xx/1000,yy/1000,ww_cdw');colorbar;shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','off');hold off;
    caxis([-1 1]/2e4);
%     colormap(flip(cmocean('balance')))
    colormap(redblue);
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    set(gca,'FontSize',fontsize);
    title('Vertical velocity at the upper bound of the CDW layer (m/s)','FontSize',fontsize+3)
    set(gca,'Position',plotloc);
    ylim([0 400]);xlim([-300 300])
    xticks([-300:100:300]); yticks([0:100:400])

    if(savefigure)
    print('-dpng','-r150',[figdir expname '_ww.png']);
    end

    handle = figure(2);
    set(handle,'Position',framepos);
    clf;
    set(gcf,'color','w');
    pcolor(xx/1000,yy/1000,rho_o*cp_o*wt_cdw');colorbar;shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','off');hold off;
    caxis([-1 1]*30);
%     colormap(flip(cmocean('balance')))
    colormap(redblue);
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    set(gca,'FontSize',fontsize);
    title('Vertical heat flux at the upper bound of the CDW layer (W/m^2)','FontSize',fontsize+3)
    set(gca,'Position',plotloc);
    ylim([0 400]);xlim([-300 300])
    xticks([-300:100:300]); yticks([0:100:400])

    if(savefigure)
    print('-dpng','-r150',[figdir expname '_wt.png']);
    end


    handle = figure(3);
    set(handle,'Position',framepos);
    clf;
    set(gcf,'color','w');
    pcolor(xx/1000,yy/1000,zz_cdw');colorbar;shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','off');hold off;
    caxis([-900 -150]);
    colormap(flip(WhiteBlueGreenYellowRed(0)));
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    set(gca,'FontSize',fontsize);
    title('Depth of the upper bound of the CDW layer (m)','FontSize',fontsize+3)
    set(gca,'Position',plotloc);
    ylim([0 400]);xlim([-300 300])
    xticks([-300:100:300]); yticks([0:100:400])

    if(savefigure)
    print('-dpng','-r150',[figdir expname '_zz.png']);
    end




