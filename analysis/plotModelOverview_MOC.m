%%%
%%% plotModelOverview_MOC.m
%%%
%%%%%%%%%%%%%%%%%%%%%
%%%%% MOC PANEL %%%%%
%%%%%%%%%%%%%%%%%%%%%


%%% Load experiment data
expname = 'TS_tau0.075_Ws75_Hs500_Ymax25_Ly450_Sflux2.5e-3_res1km';
expdir = 'TS_prod_batch';
loadexp;
backupfile = fullfile('backups',[expname,'_backup.mat']);
load(backupfile);

%%% Load mean neutral density
expname = 'TS_tau0.075_Ws75_Hs500_Ymax25_Ly450_Sflux2.5e-3_res1km_hifreq';
expdir = 'TS_prod_batch';
load(fullfile('MOC_output',[expname,'_xavgs.mat']));

%%% Bottom topography
hb = -bathy(1,:);

%%% Create mesh grid with vertical positions adjusted to sit on the bottom
%%% topography and at the surface
[ZZ,YY] = meshgrid(zz,yy);
hFacC_yz = zeros(Ny,Nr);
for j=1:Ny  
  hFacC_col = squeeze(hFacC(1,j,:));  
  hFacC_yz(j,:) = hFacC_col; 
  kmax = length(hFacC_col(hFacC_col>0));  
  zz_botface = -sum(hFacC_col.*delR');
  ZZ(j,1) = 0;
  if (kmax>0)
    ZZ(j,kmax) = zz_botface;
  end
end

%%% Meshgrid for psi plots
makePsiGrid;

%%% Compute overturning
TEM;
psi = psimean + psie_D1_e2;

%%% Free up some RAM
clear(backupfile);
  
%%% Plot overturning
ax5 = subplot('position',[0.6 0.05 0.33 0.35]);
[C,h]=contourf(YY_psi/1000,-ZZ_psi/1000,psi,[-.4:0.025:0],'EdgeColor',[0.5 0.5 0.5],'LineWidth',0.5);
set(gca,'YDir','reverse');
hold on;
[C,h]=contour(YY/1000,-ZZ/1000,g_mean,[28.1 28.45],'EdgeColor','k','LineStyle','-','LineWidth',1);
caxis([-0.4 0]);
clabel(C,h,'Color','k','FontSize',fontsize,'LabelSpacing',190);
plot(yy/1000,hb/1000,'k','LineWidth',3);      
hold off;
xlabel('Offshore distance (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth (km)','interpreter','latex','FontSize',fontsize);
set(gca,'FontSize',fontsize);
annotation('textbox',[0.91 0.02 0.3 0.01],'String','$\psi$ (Sv)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

handle = colorbar('peer',ax5);
set(handle,'FontSize',fontsize);
set(handle,'Position',[0.94 0.05 0.01 0.35]);
cmap = redblue(36);
colormap(ax5,cmap(3:18,:));
caxis([-0.4 0]);

annotation('textbox',[0.54 0.02 0.05 0.01],'String','(c)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
