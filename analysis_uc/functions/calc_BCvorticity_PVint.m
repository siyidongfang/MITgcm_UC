

    clear;close all;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    
    prodir = ['/Users/csi/MITgcm_UC/products/' exp_group '/'];
    useSEAICE = true;
    showfigrue = true;
    savefigure = false;

    ne=1;
    expname = EXPNAME{ne}
    loadexp;
    load_data;
    load_spacing;
    load_colors;

    prodname_new = [prodir expname '_vorticity_cdw.mat'];
    load(prodname_new)

    %%% Calculate f/h
    ff = f0+beta*YY;

    %%% Calculate CDW depth on vorticity grid
    prodname_new = [prodir expname '_vorticity_cdw.mat'];
    load(prodname_new)
    Hcdw_vorgrid = zeros(Nx,Ny);
    Hcdw_vorgrid(1:Nx-1,:) = (Hcdw_vgridf(1:Nx-1,:)+ Hcdw_vgridf(2:Nx,:))/2; % vorticity-gird
    %     Hcdw_vorgrid(:,2:Ny) = (Hcdw_ugridf(:,1:Ny-1)+ Hcdw_ugridf(:,2:Ny))/2; % vorticity-gird
    Hcdw_vorgrid(Hcdw_vorgrid==0)=NaN;

    %     figure(6);clf;set(gcf,'color','w');
    %     pcolor(Hcdw_vorgrid);colorbar;shading flat;

    fhcdw = -ff./Hcdw_vorgrid;
    bathy(bathy==0)=NaN;
    
    %%% Find closed f/hcdw contours
    min_fhcdw = min(min(fhcdw));
    max_fhcdw = max(max(fhcdw));
    
    %%% plot f/hcdw contours 
    figure(7)
    clf;set(gcf,'color','w');
    contour(XX/1000,YY/1000,fhcdw,(0:0.1:13)*1e-7)
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
    hold off;
    colorbar; colormap(WhiteBlueGreenYellowRed(0));clim([0 1e-6]);
    title('|f|/h_{CDW} (m^{-1}s^{-1})','FontSize',fontsize+3)
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);

    %%% Create a finer horizontal grid
    ffac = 7;
    Nxf = ffac*Nx;
    Nyf = ffac*Ny;
    delXf = zeros(1,Nxf); 
    delYf = zeros(1,Nyf); 
    for n=1:Nx
        for m=1:ffac
            delXf((n-1)*ffac+m) = delX(n)/ffac;
        end
    end
    for n=1:Ny
        for m=1:ffac
            delYf((n-1)*ffac+m) = delY(n)/ffac;
        end
    end

    dxf = delXf(1); dyf = delYf(1);
    xx  = cumsum((delX +  [0 delX(1:Nx-1)])/2)  -Lx/2;
    xxf= cumsum((delXf + [0 delXf(1:Nxf-1)])/2)-Lx/2;
    
    yy  = cumsum((delY +  [0 delY(1:Ny-1)])/2);
    yyf= cumsum((delYf + [0 delYf(1:Nyf-1)])/2);

    [YY,XX] = meshgrid(yy,xx);
    [YYf,XXf] = meshgrid(yyf,xxf);


    %%% Interpolate the vorticity terms onto this new grid
    fhcdwf = interp2(YY,XX,fhcdw,YYf,XXf,'linear');
    zeta_BPTf = interp2(YY,XX,zeta_BPT,YYf,XXf,'linear');
    zeta_IPTf = interp2(YY,XX,zeta_IPT,YYf,XXf,'linear');
    zeta_Advecf = interp2(YY,XX,zeta_Advec,YYf,XXf,'linear');
    zeta_Dissf = interp2(YY,XX,zeta_Diss,YYf,XXf,'linear');
    zeta_residualf = interp2(YY,XX,zeta_residual,YYf,XXf,'linear');

    zeta_Corif = interp2(YY,XX,zeta_Cori,YYf,XXf,'linear');
    zeta_AdvZ3f = interp2(YY,XX,zeta_AdvZ3,YYf,XXf,'linear');
    zeta_AdvRef = interp2(YY,XX,zeta_AdvRe,YYf,XXf,'linear');

    bathyf = interp2(YY,XX,bathy,YYf,XXf,'linear');

    %%% Select f/hcdw contours  over the shelf and slope
    Wmin = 2.5e-7;
    Wmax = 3.7e-7;

    fh_select = Wmin:0.1e-7:Wmax;
    LL = length(fh_select);
    fh_select_mid = 0.5*(fh_select(1:end-1)+fh_select(2:end));
    mask_fhcdw = ones(Nxf,Nyf);
    mask_fhcdw(XXf<-120.*m1km)=NaN;
    mask_fhcdw(XXf>70*m1km)=NaN;

    fh = fhcdwf.*mask_fhcdw;
    fh(fh<Wmin)=NaN;
    fh(fh>Wmax)=NaN;

    figure(8)
    clf;set(gcf,'color','w');
    contour(XXf/1000,YYf/1000,fh,fh_select)
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:500:-1000],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
    colorbar;colormap(jet);caxis([Wmin Wmax])
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);

    figure(9)
    clf;set(gcf,'color','w');
    pcolor(XXf/1000,YYf/1000,fh);shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:500:-1000],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
    colorbar;colormap(jet);caxis([Wmin Wmax])
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);


    Amaskf = NaN.*zeros(Nxf,Nyf);
    for ii=1:Nxf
        for jj=1:Nyf
            if(~isnan(fh(ii,jj)))
                Amaskf(ii,jj)=bathyf(ii,jj);
            end
            if(XXf(ii,jj)<=70*m1km && XXf(ii,jj)>=-150*m1km ...
                    && YYf(ii,jj)<=240*m1km && YYf(ii,jj)>=225*m1km ...
                    && bathyf(ii,jj)>=-1500 && bathyf(ii,jj)<=-700 )
                Amaskf(ii,jj)=bathyf(ii,jj);
            end
            if(YYf(ii,jj)>=220*m1km && XXf(ii,jj)>=50*m1km) ...
                Amaskf(ii,jj)=NaN;
            end
        end
    end
    
    figure(1)
    clf;set(gcf,'color','w');
    pcolor(XXf/1000,YYf/1000,Amaskf);shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off
    hold off;grid on;grid minor
    colorbar; 
    colormap(flip(WhiteBlueGreenYellowRed(0)));
    clim([-1500 -400]);
    title('Bathymetric contours (m)','FontSize',fontsize+3)
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);


    Amaskf(~isnan(Amaskf))=1;

    BPT_Aint = cumsum(sum(zeta_BPTf.*Amaskf*dxf*dyf,'omitnan'));
    IPT_Aint = cumsum(sum(zeta_IPTf.*Amaskf*dxf*dyf,'omitnan'));
    Advec_Aint = cumsum(sum(zeta_Advecf.*Amaskf*dxf*dyf,'omitnan'));
    Diss_Aint = cumsum(sum(zeta_Dissf.*Amaskf*dxf*dyf,'omitnan'));
    residual_Aint = cumsum(sum(zeta_residualf.*Amaskf*dxf*dyf,'omitnan'));

    for kkk = 500:length(BPT_Aint)-1
        if(BPT_Aint(kkk+1)==BPT_Aint(kkk))
            BPT_Aint(kkk+1:end)=NaN;
            IPT_Aint(kkk+1:end)=NaN;
            Advec_Aint(kkk+1:end)=NaN;
            Diss_Aint(kkk+1:end)=NaN;
            residual_Aint(kkk+1:end)=NaN;
        end
    end

    figure(12)
    clf;set(gcf,'color','w');
    plot(yyf/1000,BPT_Aint,'-.','LineWidth',2)
    hold on;
    plot(yyf/1000,IPT_Aint,'-.','LineWidth',2)
    plot(yyf/1000,BPT_Aint+IPT_Aint,'LineWidth',2)
    plot(yyf/1000,Advec_Aint,'LineWidth',2)
    plot(yyf/1000,Diss_Aint,'LineWidth',2)
    plot(yyf/1000,residual_Aint,'--','LineWidth',2,'Color',gray)
    leg1  = legend('Bottom pressure torque','Interfacial pressure torque','BPT+IPT','Advection','Dissipation','Residual');
    set(leg1,'Position', [0.6179 0.1548 0.2804 0.2524])
    set(gca,'FontSize',fontsize);
    xlabel('Latitude, y (km)');
    ylabel('(N/m)');
    title('Cummulatively integrated vorticity budget');
    xlim([50 245])
    grid on;grid minor;













