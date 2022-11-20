%%%
%%% calc_BTVorticity_fh_int
%%%
%%% Integrate the vorticity budget terms over closed f/h contours.
%%% This script should be run after calc_BTvorticity_curl_int


    %%% Calculate f/h
    ff = f0+beta*YY;
    fh = -ff./abs(bathy);
    bathy(bathy==0)=NaN;
    
    %%% Find closed f/h contours
    
    min_fh = min(min(fh));
    max_fh = max(max(fh));
    
    %%% plot f/h contours 
    figure(4)
    clf
    contour(XX/1000,YY/1000,fh,(0:0.05:3)*1e-7)
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
    hold off;
    colorbar;colormap(jet);caxis([0 3e-7])
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);

    %%% Select f/h contours  over the shelf and slope
    Wmin = 2.1e-7;
    Wmax = 2.6e-7;
    fh_select = Wmin:0.05e-7:Wmax;
    LL = length(fh_select);

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


    %%% Interpolate the vorticity terms onto this new grid
    zeta_dPhif = interp2(YY,XX,zeta_dPhi,YYf,XXf,'linear');
    zeta_Advecf = interp2(YY,XX,zeta_Advec,YYf,XXf,'linear');
    zeta_Dissf = interp2(YY,XX,zeta_Diss,YYf,XXf,'linear');
    zeta_Extf = interp2(YY,XX,zeta_Ext,YYf,XXf,'linear');
    zeta_residualf = interp2(YY,XX,zeta_residual,YYf,XXf,'linear');
    fhf = interp2(YY,XX,fh,YYf,XXf,'linear');
    


    %%% Calculate the area integral
    zeta_dPhi_fhint = zeros(1,LL);
    zeta_Advec_fhint = zeros(1,LL);
    zeta_Diss_fhint = zeros(1,LL);
    zeta_Ext_fhint = zeros(1,LL);
    zeta_residual_fhint = zeros(1,LL);

    figure(5)
    clf;
    contour(XX/1000,YY/1000,fh,fh_select)
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
    colorbar;colormap(jet);caxis([Wmin Wmax])
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);
    
    %%% For west shelf/slope
    Wmaskf = ones(Nxf,Nyf); 
    Wmaskf(XXf>0)=NaN;
    Wmaskf(YYf<130*m1km)=NaN;
    
    fh_westf = fhf.*Wmaskf;
    
    figure(6)
    clf;
    contour(XXf/1000,YYf/1000,fh_westf,fh_select)
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
    colorbar;colormap(jet);caxis([Wmin Wmax])
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);

    dAf = dxf*dyf;

    test = NaN.*zeros(Nxf,Nyf,LL-1);

    for n=1:LL-1
        fh_a = fh_select(n);
        fh_b = fh_select(n+1);
        for i=1:Nxf
            for j=1:Nyf
                if (~isnan(Wmaskf(i,j)) && fhf(i,j)<fh_b) && (fhf(i,j)>=fh_a) 
                    test(i,j,n) = n;
                    zeta_dPhi_fhint(n) =  zeta_dPhi_fhint(n) + zeta_dPhif(i,j)*dAf;
                    zeta_Advec_fhint(n) =  zeta_Advec_fhint(n) + zeta_Advecf(i,j)*dAf;
                    zeta_Diss_fhint(n) =  zeta_Diss_fhint(n) + zeta_Dissf(i,j)*dAf;
                    zeta_Ext_fhint(n) =  zeta_Ext_fhint(n) + zeta_Extf(i,j)*dAf;
                    zeta_residual_fhint(n) =  zeta_residual_fhint(n) + zeta_residualf(i,j)*dAf;
                end
            end
        end
    end


    figure(13)
    clf;
    pcolor(XXf/1000,YYf/1000,test(:,:,1));
    shading flat;
    hold on;
    for n=2:LL-1
        pcolor(XXf/1000,YYf/1000,test(:,:,n));shading flat;
    end
    hold off;


    figure(14)
    clf;
    plot(fh_select,zeta_dPhi_fhint)
    hold on;
    plot(fh_select,zeta_Advec_fhint)
    plot(fh_select,zeta_Diss_fhint)
    plot(fh_select,zeta_Ext_fhint)
    plot(fh_select,zeta_residual_fhint)




