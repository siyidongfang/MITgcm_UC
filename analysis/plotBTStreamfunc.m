%%%
%%% plotBTStreamfunc.m
%%%
%%% Plots the time-mean barotropic streamfunction.
%%%

%%% Read experiment data
setTimeframe;
calcBTStreamfunc;

%%% Meshgrid for plotting
xx_u = [0 cumsum(delX)];
yy_v = [0 cumsum(delY)];
[YY_Psi,XX_Psi] = meshgrid(yy_v/1000,xx_u/1000);

%%% Plotting options
scrsz = get(0,'ScreenSize');
fontsize = 26;
framepos = [0 scrsz(4)/2 700 550];
plotloc = [0.15 0.15 0.7 0.75];

%%% Set plot limits
Psi_max = 20;
Psi_min = -130;

%%% Make the plot
handle = figure(12);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
set(gcf,'color','w');
contourf(XX_Psi,YY_Psi,Psi/1e6,[Psi_min:2.5:Psi_max],'EdgeColor','k');  

xlabel('x (km)');
ylabel('y (km)');   
handle=colorbar;
colormap jet;
caxis([Psi_min Psi_max]);
set(handle,'FontSize',fontsize);
set(gca,'Position',plotloc);
annotation('textbox',[0.8 0.05 0.25 0.05],'String','$\Psi_\mathrm{BT}$ (Sv)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
