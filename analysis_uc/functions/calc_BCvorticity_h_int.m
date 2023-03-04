

%%% Integrate the vorticity budget following closed bathymetric contours

    bathy(bathy==0)=NaN;

    %%% Select hh contours over the shelf and slope
    h_select = [-845:1:-700];
%     h_select = [-845:1:-763];
    LL = length(h_select);
    fh_select_mid = 0.5*(h_select(1:end-1)+h_select(2:end));

    hh_contour = bathy;
    hh_contour(YY>=219*m1km)=NaN;
    hh_contour(YY<=5*m1km)=NaN;

    %%% plot bathymetric contours 
    figure(7)
    clf;set(gcf,'color','w');
    contour(XX/1000,YY/1000,hh_contour,h_select)
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off
    hold off;grid on;grid minor
    colorbar; colormap(WhiteBlueGreenYellowRed(0));
    clim([-850 -700]);
    title('Bathymetric contours (m)','FontSize',fontsize+3)
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
    hh_contourf = interp2(YY,XX,hh_contour,YYf,XXf,'linear');

    zeta_BPTf = interp2(YY,XX,zeta_BPT,YYf,XXf,'linear');
    zeta_IPTf = interp2(YY,XX,zeta_IPT,YYf,XXf,'linear');
    zeta_Advecf = interp2(YY,XX,zeta_Advec,YYf,XXf,'linear');
    zeta_Dissf = interp2(YY,XX,zeta_Diss,YYf,XXf,'linear');
    zeta_residualf = interp2(YY,XX,zeta_residual,YYf,XXf,'linear');

    zeta_Corif = interp2(YY,XX,zeta_Cori,YYf,XXf,'linear');
    zeta_AdvZ3f = interp2(YY,XX,zeta_AdvZ3,YYf,XXf,'linear');
    zeta_AdvRef = interp2(YY,XX,zeta_AdvRe,YYf,XXf,'linear');

    zeta_BPTf(isnan(zeta_BPTf))=0;
    zeta_IPTf(isnan(zeta_IPTf))=0;
    zeta_Advecf(isnan(zeta_Advecf))=0;
    zeta_Dissf(isnan(zeta_Dissf))=0;
    zeta_residualf(isnan(zeta_residualf))=0;
    zeta_Corif(isnan(zeta_Corif))=0;
    zeta_AdvZ3f(isnan(zeta_AdvZ3f))=0;
    zeta_AdvRef(isnan(zeta_AdvRef))=0;
   

    %%

    load_colors;

    %%% Calculate the area integral
    zeta_BPT_hint = zeros(1,LL-1);
    zeta_IPT_hint = zeros(1,LL-1);
    zeta_Advec_hint = zeros(1,LL-1);
    zeta_Diss_hint = zeros(1,LL-1);
    zeta_residual_hint = zeros(1,LL-1);

    zeta_Cori_hint = zeros(1,LL-1);
    zeta_AdvZ3_hint = zeros(1,LL-1);
    zeta_AdvRe_hint = zeros(1,LL-1);

    dAf = dxf*dyf;

    test = NaN.*zeros(Nxf,Nyf,LL-1);
    area = zeros(1,LL-1);

    for n=1:LL-1
        h_a = h_select(n);
        h_b = h_select(n+1);
        for i=1:Nxf
            for j=1:Nyf
                if  (hh_contourf(i,j)<h_b) && (hh_contourf(i,j)>=h_a) 
                    test(i,j,n) = 1;
                    zeta_BPT_hint(n) =  zeta_BPT_hint(n) + zeta_BPTf(i,j)*dAf;
                    zeta_IPT_hint(n) =  zeta_IPT_hint(n) + zeta_IPTf(i,j)*dAf;
                    zeta_Advec_hint(n) =  zeta_Advec_hint(n) + zeta_Advecf(i,j)*dAf;
                    zeta_Diss_hint(n) =  zeta_Diss_hint(n) + zeta_Dissf(i,j)*dAf;
                    zeta_residual_hint(n) =  zeta_residual_hint(n) + zeta_residualf(i,j)*dAf;

                    zeta_Cori_hint(n) = zeta_Cori_hint(n) + zeta_Corif(i,j)*dAf;
                    zeta_AdvZ3_hint(n) = zeta_AdvZ3_hint(n) + zeta_AdvZ3f(i,j)*dAf;
                    zeta_AdvRe_hint(n) = zeta_AdvRe_hint(n) + zeta_AdvRef(i,j)*dAf;
                end
            end
        end
        area(n) = sum(test(:,:,n)*dAf,'all','omitnan'); 
    end

    area(area==0)=NaN;


    figure(10)
    clf;set(gcf,'color','w');
    plot(fh_select_mid,zeta_BPT_hint,'-.','LineWidth',2)
    hold on;
    plot(fh_select_mid,zeta_IPT_hint,'-.','LineWidth',2)
    plot(fh_select_mid,zeta_BPT_hint+zeta_IPT_hint,'LineWidth',2)
    plot(fh_select_mid,zeta_Advec_hint,'LineWidth',2)
    plot(fh_select_mid,zeta_Diss_hint,'LineWidth',2)
    plot(fh_select_mid,zeta_residual_hint,'--','LineWidth',2,'Color',gray)
    leg1  = legend('Bottom pressure torque','Interfacial pressure torque','BPT+IPT','Advection','Dissipation','Residual');
    set(leg1,'Position', [0.6179 0.1548 0.2804 0.2524])
    set(gca,'FontSize',fontsize);
%     xlim([min(min(fh)) max(h_select)])
    xlabel('Selected bathymetric contours, (m)');
    ylabel('(N/m)');
    title('Area-integrated vorticity budget');
    grid on;



    %%% Calculate the cummulative vorticity budget

%     BPT_cumsum = cumsum (flip(zeta_BPT_fhint));
%     IPT_cumsum = cumsum (flip(zeta_IPT_fhint));
%     Advec_cumsum = cumsum (flip(zeta_Advec_fhint));
%     Diss_cumsum = cumsum (flip(zeta_Diss_fhint));
%     residual_cumsum = cumsum (flip(zeta_residual_fhint));
%     
%     flip_fh = flip(fh_select_mid);

    BPT_cumsum = cumsum ((zeta_BPT_hint));
    IPT_cumsum = cumsum ((zeta_IPT_hint));
    Advec_cumsum = cumsum ((zeta_Advec_hint));
    Diss_cumsum = cumsum ((zeta_Diss_hint));
    residual_cumsum = cumsum ((zeta_residual_hint));
%     
    flip_fh = (fh_select_mid);



    figure(12)
    clf;set(gcf,'color','w');
    plot(flip_fh,BPT_cumsum,'-.','LineWidth',2)
    hold on;
    plot(flip_fh,IPT_cumsum,'-.','LineWidth',2)
    plot(flip_fh,BPT_cumsum+IPT_cumsum,'LineWidth',2)
    plot(flip_fh,Advec_cumsum,'LineWidth',2)
    plot(flip_fh,Diss_cumsum,'LineWidth',2)
    plot(flip_fh,residual_cumsum,'--','LineWidth',2,'Color',gray)
    leg1  = legend('Bottom pressure torque','Interfacial pressure torque','BPT+IPT','Advection','Dissipation','Residual');
    set(leg1,'Position', [0.6179 0.1548 0.2804 0.2524])
    set(gca,'FontSize',fontsize);
    xlabel('Selected bathymetric contours, (m)');
    ylabel('(N/m)');
    set(gca, 'XDir','reverse')
    title('Cummulatively integrated vorticity budget');
    grid on;
