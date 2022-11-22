%%%
%%% calc_BTVorticity_fh_int
%%%
%%% Integrate the vorticity budget terms over closed f/h contours.
%%% This script should be run after calc_BTvorticity_curl_int


    %%% Calculate f/h
    ff = f0+beta*YY;

    %%% Find the depth of water column
    hh = sum(DZ.*hFacC,3);
    hh(hh==0)=NaN;
    hh([1 end],:,:) = NaN;
%     figure(4);clf;set(gcf,'color','w');
%     pcolor(hh);colorbar;shading flat;

    fh = -ff./hh;
    bathy(bathy==0)=NaN;
    
    %%% Find closed f/h contours
    
    min_fh = min(min(fh));
    max_fh = max(max(fh));
    
    %%% plot f/h contours 
    figure(5)
    clf;set(gcf,'color','w');
    contour(XX/1000,YY/1000,fh,(0:0.1:13)*1e-7)
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
    hold off;
    colorbar; colormap(WhiteBlueGreenYellowRed(0));caxis([0 5e-7]);
    title('f/h (m^{-1}s^{-1})','FontSize',fontsize+3)
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);

%     figure(6)
%     clf;set(gcf,'color','w');
%     pcolor(XX/1000,YY/1000,fh);shading flat;
%     hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
%     hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
%     hold off;
%     colorbar;
%     % colormap(jet);
%     colormap(WhiteBlueGreenYellowRed(0))
%     caxis([0 5e-7]);
%     title('f/h (m^{-1}s^{-1})','FontSize',fontsize+3)
%     xlabel('Longitude, x (km)');
%     ylabel('Latitude, y (km)');
%     set(gca,'FontSize',fontsize);

    %%% Select f/h contours  over the shelf and slope
    Wmin = 1e-7;
    Wmax = 2.6e-7;
    fh_select = Wmin:0.05e-7:Wmax;
    LL = length(fh_select);

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
    fhf = interp2(YY,XX,fh,YYf,XXf,'linear');
    zeta_dPhif = interp2(YY,XX,zeta_dPhi,YYf,XXf,'linear');
    zeta_Advecf = interp2(YY,XX,zeta_Advec,YYf,XXf,'linear');
    zeta_Dissf = interp2(YY,XX,zeta_Diss,YYf,XXf,'linear');
    zeta_Extf = interp2(YY,XX,zeta_Ext,YYf,XXf,'linear');
    zeta_residualf = interp2(YY,XX,zeta_residual,YYf,XXf,'linear');
    zeta_Corif = interp2(YY,XX,zeta_Cori,YYf,XXf,'linear');
    zeta_AdvZ3f = interp2(YY,XX,zeta_AdvZ3,YYf,XXf,'linear');
    zeta_AdvRef = interp2(YY,XX,zeta_AdvRe,YYf,XXf,'linear');

    %%% Calculate the area integral
    zeta_dPhi_fhint = zeros(1,LL);
    zeta_Advec_fhint = zeros(1,LL);
    zeta_Diss_fhint = zeros(1,LL);
    zeta_Ext_fhint = zeros(1,LL);
    zeta_residual_fhint = zeros(1,LL);

    zeta_Cori_fhint = zeros(1,LL);
    zeta_AdvZ3_fhint = zeros(1,LL);
    zeta_AdvRe_fhint = zeros(1,LL);

%     figure(7)
%     clf;set(gcf,'color','w');
%     contour(XX/1000,YY/1000,fh,fh_select)
%     hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
%     hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
%     colorbar;colormap(jet);caxis([Wmin Wmax])
%     xlabel('Longitude, x (km)');
%     ylabel('Latitude, y (km)');
%     set(gca,'FontSize',fontsize);
    
    %%% For west shelf/slope
    Wmaskf = ones(Nxf,Nyf); 
    Wmaskf(XXf>40*m1km)=NaN;
    Wmaskf(XXf<-278*m1km)=NaN;

    for i=1:Nxf
        for j=1:Nyf
            if (XXf(i,j)>10*m1km && fhf(i,j)>1.9e-7)
                Wmaskf(i,j)=NaN;
            end
            if (XXf(i,j)>10*m1km && YYf(i,j)>220*m1km && fhf(i,j)<=1.9e-7)
                Wmaskf(i,j)=NaN;
            end
            if (XXf(i,j)>-85*m1km && YYf(i,j)<110*m1km)
                Wmaskf(i,j)=NaN;
            end
            if (XXf(i,j)<-85*m1km && YYf(i,j)<140*m1km)
                Wmaskf(i,j)=NaN;
            end
        end
    end

    fh_westf = fhf.*Wmaskf;
    
    figure(8)
    clf;set(gcf,'color','w');
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

                    zeta_Cori_fhint(n) = zeta_Cori_fhint(n) + zeta_Corif(i,j)*dAf;
                    zeta_AdvZ3_fhint(n) = zeta_AdvZ3_fhint(n) + zeta_AdvZ3f(i,j)*dAf;
                    zeta_AdvRe_fhint(n) = zeta_AdvRe_fhint(n) + zeta_AdvRef(i,j)*dAf;
                end
            end
        end
    end




%     figure(9)
%     clf;set(gcf,'color','w');
%     pcolor(XXf/1000,YYf/1000,test(:,:,1));
%     colormap(WhiteBlueGreenYellowRed(0));
%     shading flat;
%     hold on;
%     for n=2:LL-1
%         pcolor(XXf/1000,YYf/1000,test(:,:,n));shading flat;
%         colormap(WhiteBlueGreenYellowRed(0));
%     end
%     hold off;
%     xlabel('Longitude, x (km)');
%     ylabel('Latitude, y (km)');
%     set(gca,'FontSize',fontsize);

    figure(10)
    clf;set(gcf,'color','w');
    plot(fh_select,zeta_dPhi_fhint/1e3,'LineWidth',2)
    hold on;
    plot(fh_select,zeta_Advec_fhint/1e3,'LineWidth',2)
    plot(fh_select,zeta_Diss_fhint/1e3,'LineWidth',2)
    plot(fh_select,zeta_Ext_fhint/1e3,'LineWidth',2)
    plot(fh_select,zeta_residual_fhint/1e3,'--','LineWidth',2,'Color',gray)
    leg1  = legend('Pressure torque','Advection','Dissipation','External','Residual');
    set(leg1,'Position', [0.6179 0.1548 0.2804 0.2524])
    set(gca,'FontSize',fontsize);
    xlim([min(fh_select) max(fh_select)])
    xlabel('Selected f/h contours, (m^{-1}s^{-1})');
    ylabel('(10^3 N/m)');
    title('Volume integrated vorticity budget of west shelf');
    grid on;
    figdir = '/Users/csi/MITgcm_UC/figures_uc/vorticity/westshelf/'
    print('-dpng','-r200',[figdir expname '_westshelf.png']);


    zeta_advresidual_fhint = zeta_Advec_fhint-zeta_Cori_fhint-zeta_AdvZ3_fhint-zeta_AdvRe_fhint;

    figure(11)
    clf;set(gcf,'color','w');
    plot(fh_select,zeta_Advec_fhint/1e3,'LineWidth',2)
    hold on;
    plot(fh_select,zeta_Cori_fhint/1e3,'-.','LineWidth',2)
    plot(fh_select,zeta_AdvZ3_fhint/1e3,'-.','LineWidth',2)
    plot(fh_select,zeta_AdvRe_fhint/1e3,'-.','LineWidth',2)
    plot(fh_select,zeta_advresidual_fhint/1e3,'--','LineWidth',2,'Color',gray)
    leg1  = legend('Total advection','Coriolis term','Vorticity advection','Vertical advection','Residual');
    set(leg1,'Position', [0.6179 0.1548 0.2804 0.2524])
    set(gca,'FontSize',fontsize);
    xlim([min(fh_select) max(fh_select)])
    xlabel('Selected f/h contours, (m^{-1}s^{-1})');
    ylabel('(10^3 N/m)');
    title('Volume integrated advection terms of west shelf');
    grid on;
    print('-dpng','-r200',[figdir expname '_westshelf_adv.png']);


