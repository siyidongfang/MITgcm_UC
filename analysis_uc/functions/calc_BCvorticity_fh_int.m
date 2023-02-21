

    %%% Calculate f/h
    ff = f0+beta*YY;

%     %%% Find the depth of water column
%     hh = sum(DZ.*hFacC,3);
%     hh(hh==0)=NaN;
%     hh([1 end],:,:) = NaN;
%     figure(4);clf;set(gcf,'color','w');
%     pcolor(hh);colorbar;shading flat;
% 
%     fh = -ff./hh;
%     bathy(bathy==0)=NaN;
%     
%     %%% Find closed f/h contours
%     min_fh = min(min(fh));
%     max_fh = max(max(fh));
%     
%     %%% plot f/h contours 
%     figure(5)
%     clf;set(gcf,'color','w');
%     contour(XX/1000,YY/1000,fh,(0:0.1:13)*1e-7)
%     hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
%     hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
%     hold off;
%     colorbar; colormap(WhiteBlueGreenYellowRed(0));clim([0 1e-6]);
%     title('f/h (m^{-1}s^{-1})','FontSize',fontsize+3)
%     xlabel('Longitude, x (km)');
%     ylabel('Latitude, y (km)');
%     set(gca,'FontSize',fontsize);


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
    title('f/h_{CDW} (m^{-1}s^{-1})','FontSize',fontsize+3)
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


    %%
    %%% Select f/hcdw contours  over the shelf and slope
    Wmin = 0.55e-7;
    Wmax = 4.05e-7;
    fh_select = Wmin:0.05e-7:Wmax;
    LL = length(fh_select);
    fh_select_mid = 0.5*(fh_select(1:end-1)+fh_select(2:end));
    mask_fhcdw = ones(Nxf,Nyf);
    mask_fhcdw(YYf>300.*m1km)=NaN;
    mask_fhcdw(XXf<-200.*m1km)=NaN;
    mask_fhcdw(XXf>100*m1km)=NaN;
% mask_fhcdw(YYf>220.*m1km)=NaN;

    fh = fhcdwf.*mask_fhcdw;


    figure(8)
    clf;set(gcf,'color','w');
    contour(XXf/1000,YYf/1000,fh,fh_select)
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
    colorbar;colormap(jet);caxis([Wmin Wmax])
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);



    load_colors;

    %%% Calculate the area integral
    zeta_BPT_fhint = zeros(1,LL-1);
    zeta_IPT_fhint = zeros(1,LL-1);
    zeta_Advec_fhint = zeros(1,LL-1);
    zeta_Diss_fhint = zeros(1,LL-1);
    zeta_residual_fhint = zeros(1,LL-1);

    zeta_Cori_fhint = zeros(1,LL-1);
    zeta_AdvZ3_fhint = zeros(1,LL-1);
    zeta_AdvRe_fhint = zeros(1,LL-1);


    dAf = dxf*dyf;

    test = NaN.*zeros(Nxf,Nyf,LL-1);
    area = zeros(1,LL-1);

    for n=1:LL-1
        fh_a = fh_select(n);
        fh_b = fh_select(n+1);
        for i=1:Nxf
            for j=1:Nyf
                if  (fh(i,j)<fh_b) && (fh(i,j)>=fh_a) 
                    test(i,j,n) = 1;
                    zeta_BPT_fhint(n) =  zeta_BPT_fhint(n) + zeta_BPTf(i,j)*dAf;
                    zeta_IPT_fhint(n) =  zeta_IPT_fhint(n) + zeta_IPTf(i,j)*dAf;
                    zeta_Advec_fhint(n) =  zeta_Advec_fhint(n) + zeta_Advecf(i,j)*dAf;
                    zeta_Diss_fhint(n) =  zeta_Diss_fhint(n) + zeta_Dissf(i,j)*dAf;
                    zeta_residual_fhint(n) =  zeta_residual_fhint(n) + zeta_residualf(i,j)*dAf;

                    zeta_Cori_fhint(n) = zeta_Cori_fhint(n) + zeta_Corif(i,j)*dAf;
                    zeta_AdvZ3_fhint(n) = zeta_AdvZ3_fhint(n) + zeta_AdvZ3f(i,j)*dAf;
                    zeta_AdvRe_fhint(n) = zeta_AdvRe_fhint(n) + zeta_AdvRef(i,j)*dAf;
                end
            end
        end
        area(n) = sum(test(:,:,n)*dAf,'all','omitnan'); 
    end

    area(area==0)=NaN;


    figure(10)
    clf;set(gcf,'color','w');
    plot(fh_select_mid,zeta_BPT_fhint,'-.','LineWidth',2)
    hold on;
    plot(fh_select_mid,zeta_IPT_fhint,'-.','LineWidth',2)
    plot(fh_select_mid,zeta_BPT_fhint+zeta_IPT_fhint,'LineWidth',2)
    plot(fh_select_mid,zeta_Advec_fhint,'LineWidth',2)
    plot(fh_select_mid,zeta_Diss_fhint,'LineWidth',2)
    plot(fh_select_mid,zeta_residual_fhint,'--','LineWidth',2,'Color',gray)
    leg1  = legend('Bottom pressure torque','Interfacial pressure torque','BPT+IPT','Advection','Dissipation','Residual');
    set(leg1,'Position', [0.6179 0.1548 0.2804 0.2524])
    set(gca,'FontSize',fontsize);
    xlim([min(min(fh)) max(fh_select)])
    xlabel('Selected f/h_{CDW} contours, (m^{-1}s^{-1})');
    ylabel('(N/m)');
    title('Volume integrated vorticity budget of west shelf');
    grid on;



    %%% Calculate the cummulative vorticity budget

    BPT_cumsum = cumsum (flip(zeta_BPT_fhint));
    IPT_cumsum = cumsum (flip(zeta_IPT_fhint));
    Advec_cumsum = cumsum (flip(zeta_Advec_fhint));
    Diss_cumsum = cumsum (flip(zeta_Diss_fhint));
    residual_cumsum = cumsum (flip(zeta_residual_fhint));
    
    flip_fh = flip(fh_select_mid);

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
    xlim([min(min(fh)) max(fh_select)])
    xlabel('Selected f/h_{CDW} contours, (m^{-1}s^{-1})');
    ylabel('(N/m)');
    set(gca, 'XDir','reverse')
    title('Cummulatively integrated vorticity budget');
    grid on;
