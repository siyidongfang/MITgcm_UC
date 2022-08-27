%%%
%%% plot_BTStreamfunc.m
%%%
%%% Plots the time-mean barotropic streamfunction.
%%%



Psi = Psif;

%%% Meshgrid for plotting
% xx_u = [0 cumsum(delX)];
% yy_v = [0 cumsum(delY)];
% xx_u = xx+Lx/2;
% yy_v = yy;
xx_u = xxf+Lx/2;
yy_v = yyf;
[YY_Psi,XX_Psi] = meshgrid(yy_v/1000,xx_u/1000);
[YY,XX] = meshgrid(yy,xx-xx(1));

%%% Plotting options
scrsz = get(0,'ScreenSize');
fontsize = 17;
framepos = [0 scrsz(4)/2 900 550];
plotloc = [0.15 0.15 0.7 0.75];

%%% Set plot limits
Psi_max = 13;
Psi_min = -13;

%%% Make the plot
handle = figure(12);
set(handle,'Position',framepos);
clf;
set(gcf,'color','w');
contourf(XX_Psi,YY_Psi,Psi/1e6,[Psi_min:0.5:Psi_max],'EdgeColor','k');  
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',2,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
% pcolor(XX_Psi,YY_Psi,Psi/1e6);shading flat;
xlabel('Longitude, x (km)');
ylabel('Latitude, y (km)');
% title([num2str(ridge_height_batch(i)), 'm ridge, ', num2str(randtopog_height_batch(i)), 'm topog, $\kappa$ = ', num2str(kappa_max_batch(i)), ' $m^2/s$, $\tau$ = ', num2str(taue_max_batch(i)), ' $N/m^2$, $\theta_{AABW}$ = ',  num2str(AABW_temp_batch(i)), ' C'], 'interpreter','latex')
handle=colorbar;
colormap redblue;
% colormap(WhiteBlueGreenYellowRed(0));
caxis([Psi_min Psi_max]);
set(handle,'FontSize',fontsize);
set(gca,'FontSize',fontsize);
set(gca,'Position',plotloc);
set(gca,'XTick',[0:100:600]);
set(gca,'YTick',[0:100:400]);
annotation('textbox',[0.8 0.05 0.25 0.05],'String','$\Psi_\mathrm{BT}$ (Sv)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
% print('-djpeg','-r200', ['../../Figures/plotBTStreamfunc/', expname, '.jpg'])




%%% Set plot limits
Psi_max = 4;
Psi_min = -4;
%%% Make the plot
handle = figure(13);
set(handle,'Position',framepos);
clf;
set(gcf,'color','w');
contourf(XX_Psi,YY_Psi,Psi/1e6,[Psi_min:0.1:Psi_max],'EdgeColor','k');  
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',2,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',800);hold off;
xlabel('Longitude, x (km)');
ylabel('Latitude, y (km)');
% title([num2str(ridge_height_batch(i)), 'm ridge, ', num2str(randtopog_height_batch(i)), 'm topog, $\kappa$ = ', num2str(kappa_max_batch(i)), ' $m^2/s$, $\tau$ = ', num2str(taue_max_batch(i)), ' $N/m^2$, $\theta_{AABW}$ = ',  num2str(AABW_temp_batch(i)), ' C'], 'interpreter','latex')
handle=colorbar;
colormap redblue;
% colormap(WhiteBlueGreenYellowRed(0));
xlim([150 450]);ylim([0 250]);
caxis([Psi_min Psi_max]);
set(handle,'FontSize',fontsize);
set(gca,'FontSize',fontsize);
set(gca,'Position',plotloc);
set(gca,'XTick',[0:100:600]);
set(gca,'YTick',[0:100:400]);
annotation('textbox',[0.8 0.05 0.25 0.05],'String','$\Psi_\mathrm{BT}$ (Sv)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
% print('-djpeg','-r200', ['../../Figures/plotBTStreamfunc/', expname, '.jpg'])



