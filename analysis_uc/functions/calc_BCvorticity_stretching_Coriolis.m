
%%% Calculate the stretching term and the Coriolis term at the CDW/surface
%%% water interface and ocean bottom


calcCDW = true;
mask_interpolate;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% The stretching terms %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Calculate the Coriolis parameter


%%% Find bottom vertical velocity


wwf = zeros(Nx,Ny,Nrf);
for i=1:Nx
    for j=1:Ny   
        wwf(i,j,:) = interp1(zz,squeeze(ww(i,j,:))',zzf,'linear','extrap');
        clear vertical_cdwidx;
        vertical_cdwidx = find(mask_cdw_tgridf(i,j,:)==1);
        if(~isnan(vertical_cdwidx))
            bot_idx(i,j) = vertical_cdwidx(end);%%% vertical index of the bottom layer
            interf_idx(i,j) = vertical_cdwidx(1);%%% vertical index of the interface
        else
            bot_idx(i,j) = NaN;
            interf_idx(i,j) = NaN;
        end
    end
end

ww_bot = zeros(Nx,Ny);
ww_interf = zeros(Nx,Ny);
for i=1:Nx
    for j=1:Ny  
        if(~isnan(bot_idx(i,j)))
            ww_bot(i,j) = ww(i,j,bot_idx(i,j));
            ww_interf(i,j) = ww(i,j,interf_idx(i,j));
        else
            ww_bot(i,j) = NaN;
            ww_interf(i,j) = NaN;
        end
    end
end


YLIM = [0 250]
figure(5)
clf;set(gcf,'color','w');
set(gcf,'Position', [89 224 572 356])
pcolor(XX/1000,YY/1000,ww_bot)
shading flat;colorbar;colormap(cmocean('balance'));
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
clim([-1 1]/1e4)
set(gca,'FontSize',fontsize);
title({'Vertical velocity (m/s) at','ocean bottom'},'Interpreter','latex','FontSize',fontsize+4)
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

figdir = '/Users/csi/Desktop/2022_AGU_posters/'
print('-dpng','-r300',[figdir 'ww_bot.png']);

figure(6)
clf;set(gcf,'color','w');
set(gcf,'Position', [89 224 572 356])
% pcolor(XX/1000,YY/1000,ww_interf)
pcolor(XX/1000,YY/1000,ww_cdw-ww_bot)

shading flat;colorbar;colormap(cmocean('balance'));
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
clim([-1 1]/1e4)
set(gca,'FontSize',fontsize);
title({'Vertical velocity (m/s) at the','upper bound of the CDW layer'},'Interpreter','latex','FontSize',fontsize+3)
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

figdir = '/Users/csi/Desktop/2022_AGU_posters/'
print('-dpng','-r300',[figdir 'ww_interf.png']);


%%% Find the vertical velocity at the interface between the CDW layer and
%%% the surface layer





%%% Stretching of the CDW water column at seafloor due to the change in 
%%% topography along the flow



%%% Stretching of the CDW water column at CDW upper bound, due to the
%%% change in isopycnal slope along the flow









%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% The Coriolis term %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

VV = sum(mask_vgrid.*vv.*hFacS.*DZ,3,'omitnan');
zeta_Cori_betaV = -rho0*beta.*VV;
zeta_Cori_betaV(zeta_Cori_betaV==0)=NaN;

YLIM = [0 400];
CLIM = [-1 1]/1e5;

figure(4)
clf;set(gcf,'color','w');
set(gcf,'Position',[704 169 1000 500])
pcolor(XX/1000,YY/1000,zeta_Cori_betaV)
shading flat;colorbar;colormap(cmocean('balance'));
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
clim(CLIM);
title('$-\rho_0 \beta \int v\, \mathrm{d}z $ (Pa/m)','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')

if(savefigure)
print('-dpng','-r150',[figdir expname '_cdw_betaV.png']);
end
