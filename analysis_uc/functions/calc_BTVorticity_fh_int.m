%%%
%%% calc_IntVorticity_FoverH
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
    fh_select = Wmin:0.025e-7:Wmax;
    LL = length(fh_select);

%%% Interpolate the vorticity budget terms onto finer horizontal grid


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
Wmask = ones(Nx,Ny); 
Wmask(XX>0)=NaN;
Wmask(YY<130*m1km)=NaN;

fh_west = fh.*Wmask;
figure(6)
clf;
contour(XX/1000,YY/1000,fh_west,fh_select)
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
colorbar;colormap(jet);caxis([Wmin Wmax])
xlabel('Longitude, x (km)');
ylabel('Latitude, y (km)');
set(gca,'FontSize',fontsize);


for n=1:LL-1
    fh_a = fh_select(n);
    fh_b = fh_select(n+1);
    for i=1:Nx
        for j=1:Ny
            if (isnan(Wmask(i,j)) && fh(i,j)<fh_b) && (fh(i,j)>=fh_a) 
                zeta_dPhi_fhint(n) =  zeta_dPhi_fhint(n) + zeta_dPhi(i,j);
                zeta_Advec_fhint(n) =  zeta_Advec_fhint(n) + zeta_Advec(i,j);
                zeta_Diss_fhint(n) =  zeta_Diss_fhint(n) + zeta_Diss(i,j);
                zeta_Ext_fhint(n) =  zeta_Ext_fhint(n) + zeta_Ext(i,j);
                zeta_residual_fhint(n) =  zeta_residual_fhint(n) + zeta_residual(i,j);
            end
        end
    end
end



figure(14)
clf;
plot(fh_select,zeta_dPhi_fhint)
hold on;
plot(fh_select,zeta_Advec_fhint)
plot(fh_select,zeta_Diss_fhint)
plot(fh_select,zeta_Ext_fhint)
plot(fh_select,zeta_residual_fhint)




