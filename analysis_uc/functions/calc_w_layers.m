%%%
%%% calc_w_layers.m
%%% 
%%% Calculate upwelling velocity across the zero degree isotherm (CDW/SW interface)


ptlevs = layers_bounds(:,2);
Npt = length(ptlevs)-1;

load([prodir expname '_tavg_5yrs.mat'],'LaUH2TH','LaVH2TH');
uflux_tavg = LaUH2TH; %%% Layer Integrated zonal Transport (UH, m^2/s)
vflux_tavg = LaVH2TH; %%% Layer Integrated merid. Transport (VH, m^2/s)

% Calculate depth-integrated (time-averaged) zonal, meridional isopycnal fluxes
UFLUXZ = cumsum(uflux_tavg, 3, 'forward');
VFLUXZ = cumsum(vflux_tavg, 3, 'forward');

%%% Grid spacing matrices
DXpt = repmat(delX', [1 Ny Npt]);
DYpt = repmat(delY,[Nx 1 Npt]);

%%% calculate diapycnal upwelling rate
w_dia =  ((UFLUXZ([2:Nx 1],:,:) - UFLUXZ(1:Nx,:,:)) ./ DXpt) ...
    + ((VFLUXZ(:,[2:Ny 1],:) - VFLUXZ(:,1:Ny,:)) ./ DYpt);
    
kidx = find(ptlevs==0); %%% index of the zero degree isotherm in ptlevs
w_cdw_dia = w_dia(:,:,kidx);


figure(1)
clf;set(gcf,'color','w');
pcolor(xx/1000,yy/1000,w_cdw_dia');
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
hold off;
shading flat;colorbar;colormap(redblue);
clim([-5 5]/1e5)
xlim([-250 250])
ylim([0 380])
title('Diapycnal upwelling across the 0$^\circ$C isotherm (m/s)','Interpreter','latex','FontSize',24)
% set(gca,'FontSize',fontsize);
% ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')


