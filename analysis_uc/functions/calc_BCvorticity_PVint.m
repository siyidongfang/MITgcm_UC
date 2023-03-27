%%% 
%%% calc_BCvorticity_PVint.m
%%%
%%% Calculate potential vorticity of the CDW layer,
%%% select PV contours,
%%% cumulatively integrate the vorticity budget terms for that area


    load_colors;

    prodname_new = [prodir expname '_vorticity_cdw.mat'];
    load(prodname_new)

    %%% Calculate potential vorticity
    ff_vorgrid = f0+beta*(YY-1*m1km); %%% f on vorticity grid
    Hcdw_vorgrid = zeros(Nx,Ny);
    Hcdw_vorgrid(1:Nx-1,:) = (Hcdw_vgridf(1:Nx-1,:)+ Hcdw_vgridf(2:Nx,:))/2;  %%% CDW thickness on vorticity grid

    uu_cdw_zavg = UU_cdwf./Hcdw_ugridf;
    vv_cdw_zavg = VV_cdwf./Hcdw_vgridf;

    zeta_cdw = zeros(Nx,Ny);
    zeta_cdw(:,1:Ny-1) = - (uu_cdw_zavg(:,2:Ny)-uu_cdw_zavg(:,1:Ny-1))/dy;
    zeta_cdw = zeta_cdw + (vv_cdw_zavg([2:Nx 1],:)-vv_cdw_zavg)/dx;

    zeta_cdw_zint_v2 = zeros(Nx,Ny); %%%  Curl of the vertical integral, see calc_zeta_cdw for another version of zeta (integral of the curl)
    zeta_cdw_zint_v2(:,1:Ny-1) = - (UU_cdwf(:,2:Ny)-UU_cdwf(:,1:Ny-1))/dy;
    zeta_cdw_zint_v2 = zeta_cdw_zint_v2 + (VV_cdwf([2:Nx 1],:)-VV_cdwf)/dx;


    PV = (ff_vorgrid + zeta_cdw) ./Hcdw_vorgrid; %%% potential vorticity

    PV(PV==-Inf)=NaN;

    maxpv = max(max(PV)); minpv = min(min(PV));

    
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
    pvf = interp2(YY,XX,PV,YYf,XXf,'linear');
    zeta_BPTplusIPTf = interp2(YY,XX,zeta_BPTplusIPT,YYf,XXf,'linear');
    zeta_BPTf = interp2(YY,XX,zeta_BPT,YYf,XXf,'linear');
    zeta_IPTf = interp2(YY,XX,zeta_IPT,YYf,XXf,'linear');
    zeta_Advecf = interp2(YY,XX,zeta_Advec,YYf,XXf,'linear');
    zeta_Dissf = interp2(YY,XX,zeta_Diss,YYf,XXf,'linear');
    zeta_residualf = interp2(YY,XX,zeta_residual,YYf,XXf,'linear');

    zeta_Corif = interp2(YY,XX,zeta_Cori,YYf,XXf,'linear');
    zeta_AdvZ3f = interp2(YY,XX,zeta_AdvZ3,YYf,XXf,'linear');
    zeta_AdvRef = interp2(YY,XX,zeta_AdvRe,YYf,XXf,'linear');

    bathyf = interp2(YY,XX,bathy,YYf,XXf,'linear');


    %%% selected contours 
    %     Wmin = -3.5e-7;
    %     Wmax = -1e-7;
    %%% Find the nearest PV contours near h=-1500m (y~=239km) and h=-750m(y~=228km)
    %%% at x=-100km

    [nnnn xpvidx] = min(abs(xxf-(-100*m1km)));
    hselect = bathyf(xpvidx,:);
    [nnnn ypvidx1] = min(abs(hselect-(-1650)));
    Wmax = pvf(xpvidx,ypvidx1)

    [nnnn ypvidx2] = min(abs(hselect-(-740)));
    Wmin = pvf(xpvidx,ypvidx2)
    

    %%% Select f/hcdw contours  over the shelf and slope
    pv_select = Wmin:0.1e-7:Wmax;
    LL = length(pv_select);
    pv_select_mid = 0.5*(pv_select(1:end-1)+pv_select(2:end));
    mask_pv = ones(Nxf,Nyf);
    mask_pv(XXf<-120.*m1km)=NaN;
    mask_pv(XXf>70*m1km)=NaN;

    pvf(pvf<Wmin)=NaN;
    pvf(pvf>Wmax)=NaN;

    Amaskf = NaN.*zeros(Nxf,Nyf);
    for ii=1:Nxf
        for jj=1:Nyf
            if(~isnan(pvf(ii,jj)))
                Amaskf(ii,jj)=bathyf(ii,jj);
            end
            if XXf(ii,jj)<=-100*m1km ...
               ...% || (XXf(ii,jj)>=40*m1km && YYf(ii,jj)>=220*m1km)
                || (XXf(ii,jj)>=22*m1km && YYf(ii,jj)>=220*m1km)
                Amaskf(ii,jj)=NaN;
            end
        end
    end

    Amaskf(~isnan(Amaskf))=1;

    BPTplusIPT_Aint = cumsum(sum(zeta_BPTplusIPTf.*Amaskf*dxf*dyf,'omitnan'));
    BPT_Aint = cumsum(sum(zeta_BPTf.*Amaskf*dxf*dyf,'omitnan'));
    IPT_Aint = cumsum(sum(zeta_IPTf.*Amaskf*dxf*dyf,'omitnan'));
    Advec_Aint = cumsum(sum(zeta_Advecf.*Amaskf*dxf*dyf,'omitnan'));
    Diss_Aint = cumsum(sum(zeta_Dissf.*Amaskf*dxf*dyf,'omitnan'));
    residual_Aint = cumsum(sum(zeta_residualf.*Amaskf*dxf*dyf,'omitnan'));

    Cori_Aint = cumsum(sum(zeta_Corif.*Amaskf*dxf*dyf,'omitnan'));
    AdvZ3f_Aint = cumsum(sum(zeta_AdvZ3f.*Amaskf*dxf*dyf,'omitnan'));
    AdvRef_Aint = cumsum(sum(zeta_AdvRef.*Amaskf*dxf*dyf,'omitnan'));

    for kkk = 500:length(BPT_Aint)-1
        if(BPT_Aint(kkk+1)==BPT_Aint(kkk))
            BPTplusIPT_Aint(kkk+1:end)=NaN; 
            BPT_Aint(kkk+1:end)=NaN;
            IPT_Aint(kkk+1:end)=NaN;
            Advec_Aint(kkk+1:end)=NaN;
            Diss_Aint(kkk+1:end)=NaN;
            residual_Aint(kkk+1:end)=NaN;
            Cori_Aint(kkk+1:end)=NaN;
            AdvZ3f_Aint(kkk+1:end)=NaN;
            AdvRef_Aint(kkk+1:end)=NaN; 
        end
    end

    for kkk = 1:500
        if(BPT_Aint(kkk)==0)
            BPTplusIPT_Aint(kkk)=NaN; 
            BPT_Aint(kkk)=NaN; 
            IPT_Aint(kkk)=NaN; 
            Advec_Aint(kkk)=NaN; 
            Diss_Aint(kkk)=NaN; 
            residual_Aint(kkk)=NaN; 
            Cori_Aint(kkk)=NaN; 
            AdvZ3f_Aint(kkk)=NaN; 
            AdvRef_Aint(kkk)=NaN; 
        end
    end


    prodname = [prodir expname '_vortPVint-v3.mat'];
    save(prodname,...
        'XXf','YYf','XX','YY','xxf','yyf',...
        'PV','pvf','Amaskf','bathy',...
        'BPTplusIPT_Aint','Advec_Aint','Diss_Aint','residual_Aint',...
        'BPT_Aint','IPT_Aint','Cori_Aint','AdvZ3f_Aint','AdvRef_Aint',...
        'Wmin','Wmax','zeta_cdw','zeta_cdw_zint_v2')




if(showfigure)
    %%% plot pv contours 
    figure(1)
    clf;set(gcf,'color','w');
    contour(XX/1000,YY/1000,PV,(-20:0.1:0)*1e-7)
%     contour(XX/1000,YY/1000,PV,(minpv:-minpv/1000:0))
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
    hold off;
    colorbar; colormap(WhiteBlueGreenYellowRed(5));
    clim([-1e-6 0]);
%     clim([minpv/100 0])
    title('CDW potential vorticity (m^{-1}s^{-1})','FontSize',fontsize+3)
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);

    figure(2)
    clf;set(gcf,'color','w');
    contour(XX/1000,YY/1000,PV,Wmin:1e-8:Wmax)
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
    hold off;
    colorbar; colormap(WhiteBlueGreenYellowRed(5));
    clim([-4 -1]*1e-7);
    title('PV (m^{-1}s^{-1})','FontSize',fontsize+3)
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);


    figure(3)
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

    figure(10)
    clf;set(gcf,'color','w');
    hold on;
    contour(XX/1000,YY/1000,PV,(-20:0.1:0)*1e-7,'Color',gray)
    contour(XXf/1000,YYf/1000,pvf.*Amaskf,Wmin:1e-8:Wmax,'LineWidth',1.2)
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:-600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:1000:-1000],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
    hold off;
    colorbar; colormap(WhiteBlueGreenYellowRed(5));
    clim([-4 -1]*1e-7);
    title('CDW potential vorticity (m^{-1}s^{-1})','FontSize',fontsize+3)
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);
%     xlim([-110 110])
%     ylim([30 270])
    box on;



    figure(4)
    clf;set(gcf,'color','w');
    pcolor(XX/1000,YY/1000,zeta_cdw);shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off
    hold off;grid on;grid minor
    colorbar; 
    colormap(redblue);
    clim([-3 3]/1e5);
    title('CDW relative vorticity (s^{-1})','FontSize',fontsize+3)
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);

    

    figure(5)
    clf;set(gcf,'color','w');
    pcolor(XX/1000,YY/1000,zeta_cdw_zint_v2);shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off
    hold off;grid on;grid minor
    colorbar; 
    colormap(redblue);
    clim([-0.01 0.01]);
    title('CDW relative vorticity: vertical integral (m s^{-1})','FontSize',fontsize+3)
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);

end



