


    dxg = rdmds(fullfile(resultspath,'DXG'));
    dyf = rdmds(fullfile(resultspath,'DYF'));
    raz = rdmds(fullfile(resultspath,'RAZ'));  
    DXG = dxg;
    DYF = dyf;
    RAZ = raz;

    %%% Create a finer horizontal grid
    ffac = 1;
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

    DXGf = zeros(Nxf,Nyf);
    DYFf = zeros(Nxf,Nyf);
    RAZf = zeros(Nxf,Nyf);
    %%% Piecewise-constant interpolation
    for i=1:Nx
        for j=1:Ny
            DXGf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac) = DXG(i,j);
            DYFf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac) = DYF(i,j);
            RAZf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac) = RAZ(i,j);
        end
    end


    %%% Create a finer vertical grid
    ffacZ = 50;
    Nrf = ffacZ*Nr;
    delRf = zeros(1,Nrf); 
    for n=1:Nr
        for m=1:ffacZ
            delRf((n-1)*ffacZ+m) = delR(n)/ffacZ;
        end
    end

    zzf  = -cumsum((delRf +  [0 delRf(1:Nrf-1)])/2);
    DZf = repmat(reshape(delRf,[1 1 Nrf]),[Nxf Nyf 1]);


    hFacWf = zeros(Nxf,Nyf,Nrf);
    hFacSf = zeros(Nxf,Nyf,Nrf);
    hFacCf = zeros(Nxf,Nyf,Nrf);

    %%% Piecewise-constant interpolation for hFac
     for i=1:Nx
        for j=1:Ny
            for k=1:Nr
                hFacWf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = hFacW(i,j,k);
                hFacSf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = hFacS(i,j,k);
                hFacCf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = hFacC(i,j,k);
            end
        end
     end

    %%% Linear interpolation for temperature
    ttf_mid = zeros(Nx,Ny,Nrf);
    ttf = zeros(Nxf,Nyf,Nrf);
    for i=1:Nx
        for j=1:Ny   
            ttf_mid(i,j,:) = interp1(zz,squeeze(tt(i,j,:))',zzf,'linear','extrap');
        end
    end

    for k=1:Nrf
        ttf(:,:,k) = interp2(YY,XX,ttf_mid(:,:,k),YYf,XXf,'linear');
    end

    ttf(hFacCf==0)=NaN;

    tt_vgridf = ttf;
    tt_ugridf = ttf;
    
    tt_vgridf(:,2:Nyf,:) = (ttf(:,1:Nyf-1,:)+ttf(:,2:Nyf,:))/2; %%% v-grid
    tt_ugridf(2:Nxf,:,:) = 0.5.*(ttf(1:Nxf-1,:,:)+ttf(2:Nxf,:,:)); %%% u-grid
    
    mask_cdw_ugridf = NaN*zeros(Nxf,Nyf,Nrf);
    mask_cdw_vgridf = NaN*zeros(Nxf,Nyf,Nrf);
    mask_cdw_tgridf = NaN*zeros(Nxf,Nyf,Nrf);
    
    mask_cdw_ugridf(tt_ugridf>=0)=1;
    mask_cdw_vgridf(tt_vgridf>=0)=1;
    mask_cdw_tgridf(ttf>=0)=1;
    
    mask_sw_ugridf = NaN*zeros(Nxf,Nyf,Nrf);
    mask_sw_vgridf = NaN*zeros(Nxf,Nyf,Nrf);
    mask_sw_tgridf = NaN*zeros(Nxf,Nyf,Nrf);
    
    mask_sw_ugridf(tt_ugridf<0)=1;
    mask_sw_vgridf(tt_vgridf<0)=1;
    mask_sw_tgridf(ttf<0)=1;
    
    excludedeepocean = find(zzf<-600);
    mask_sw_ugridf(:,:,excludedeepocean)= NaN;
    mask_sw_vgridf(:,:,excludedeepocean)= NaN;


    Hcdw_ugridf = sum(mask_cdw_ugridf.*hFacWf.*DZf,3,'omitnan');
    Hcdw_ugridf(Hcdw_ugridf==0)=NaN;

    Hcdw_vgridf = sum(mask_cdw_vgridf.*hFacSf.*DZf,3,'omitnan');
    Hcdw_vgridf(Hcdw_vgridf==0)=NaN;

    Hcdw_tgridf = sum(mask_cdw_tgridf.*hFacCf.*DZf,3,'omitnan');
    Hcdw_tgridf(Hcdw_tgridf==0)=NaN;

    Hsw_tgridf = sum(mask_sw_tgridf.*hFacCf.*DZf,3,'omitnan');
    Hsw_tgridf(Hsw_tgridf==0)=NaN;

    tt_cdwf = sum(mask_cdw_tgridf.*ttf.*hFacCf.*DZf,3,'omitnan')./Hcdw_tgridf;
    tt_cdwf(tt_cdwf==0)=NaN;
    tt_swf = sum(mask_sw_tgridf.*ttf.*hFacCf.*DZf,3,'omitnan')./Hsw_tgridf;
    tt_swf(tt_swf==0)=NaN;
    
    figure(10)
    pcolor(XXf/1000,YYf/1000,Hcdw_ugridf);shading flat; colorbar;
    colormap(jet)
    clim([100 500])
    ylim([0 230])
    title('CDW thickness (m)')
    set(gca,'FontSize',fontsize);

