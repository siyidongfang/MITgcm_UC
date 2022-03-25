%%%
%%% plotBathy.m
%%%
%%% Makes a surface plot of the model bathymetry.
%%%

%%% Set up plot
fontsize = 18;
scrsz = get(0,'ScreenSize');
framepos = [0.25*scrsz(3) 0.15*scrsz(4) 250 600];

loadexp;
figure(1);
set(gcf,'Position',framepos);
set(gcf,'Color','w');
plot(zonalWind(1,:),yy/1000,'LineWidth',2);
hold on;
plot(0*yy,yy/1000,'k--','LineWidth',0.5);
hold off;
xlabel('\tau^x (N/m^2)','FontSize',18);
ylabel('y (km)','FontSize',18);
set(gca,'FontSize',18);
set(gca,'YTick',[0:1000:2000]);
set(gca,'XLim',[-0.06 0.16]);
