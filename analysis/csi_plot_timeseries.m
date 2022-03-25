EXPPATH_NAME = [exppath, expname]
A = open([EXPPATH_NAME,'_timeseries.mat'])
dumpFreq = abs(diag_frequency(6));
nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);


figure(1)
grid on; 
UVEL_PLOT=mean(A.UVEL(:,:,:),3)*100
[DDD,YYY]=meshgrid(zz,1:2:450)
contourf(YYY,DDD,UVEL_PLOT)
caxis([-2 2])
xlabel('Y (km)', 'FontSize', 17)
ylabel('Depth (m)','FontSize', 17)
set(gca,'fontsize',15)
axis ij;colorbar;colormap redblue;
set(gca,'YDir','normal'); 
title('Mean UVEL over a tidal cycle (cm/s)');
get(gca)

figure(2)
grid on; 
VVEL_PLOT=mean(A.VVEL_inst(:,:,988:997),3)*100
[DDD,YYY]=meshgrid(zz,1:2:450)
contourf(YYY,DDD,VVEL_PLOT)
caxis([-0.1 0.1])
xlabel('Y (km)', 'FontSize', 17)
ylabel('Depth (m)','FontSize', 17)
set(gca,'fontsize',15)
axis ij;colorbar;colormap redblue;
set(gca,'YDir','normal'); 
title('Mean VVEL over a tidal cycle (cm/s)');
get(gca)

figure(3)
grid on; 
THETA_PLOT=reshape(A.THETA_inst(90,1:17,:), [17,1000]) 
THETA_PLOT=THETA_PLOT-THETA_PLOT(:,1)
[DDD,TTT]=meshgrid(zz(1:17),1:1:1000)
contourf(TTT,DDD,THETA_PLOT')
xlabel('Time (days)', 'FontSize', 17)
set(gca,'xticklabel',[10 20 30 40 50])
ylabel('Depth (m)','FontSize', 17)
set(gca,'fontsize',15)
axis ij;colorbar;colormap redblue;
set(gca,'YDir','normal'); 
title('Time series of \theta(t)-\theta(0) (degC)');
get(gca)

figure(4)
grid on; 
THETA_PLOT=reshape(A.THETA_inst(112,1:17,:), [17,1000]) 
[DDD,TTT]=meshgrid(zz(1:17),1:1:1000)
contourf(TTT,DDD,THETA_PLOT',60)
caxis([11 13])
xlabel('Time (days)', 'FontSize', 17)
set(gca,'xticklabel',[10 20 30 40 50])
ylabel('Depth (m)','FontSize', 17)
set(gca,'fontsize',15)
axis ij;colorbar;colormap(flipud(haxby));
set(gca,'YDir','normal'); 
title('Time series of \theta (degC)');
get(gca)


figure(5)
grid on; 
SALT_PLOT=reshape(A.SALT_inst(112,1:17,:), [17,1000]) 
[DDD,TTT]=meshgrid(zz(1:17),1:1:1000)
contourf(TTT,DDD,SALT_PLOT')

xlabel('Time (days)', 'FontSize', 17)
set(gca,'xticklabel',[10 20 30 40 50])
ylabel('Depth (m)','FontSize', 17)
set(gca,'fontsize',15)
axis ij;colorbar;colormap(flipud(haxby));
set(gca,'YDir','normal'); 
title('Time series of salinity (psu)');
get(gca)


tdays =  dumpIters*deltaT/86400;
  
figure(6)
grid on; 
ETA_PLOT=A.ETAN_inst(:,978:997)
[YYY,TTT]=meshgrid(1:2:450,1:24/20:24)
contourf(YYY,TTT,ETA_PLOT')
caxis([-0.55 0.55])
% xticks([0 10 20 30 40 50])
% xlabel('Y (km)', 'FontSize', 17)
ylabel('Time (hours)', 'FontSize', 17)
xlabel('Y (km)','FontSize', 17)
set(gca,'fontsize',15)
axis ij;colorbar;colormap redblue;
title('Time series of \eta (m)');
get(gca)


figure(7)
grid on; 
THETA_PLOT=mean(A.THETA_inst(150/2:300/2,:,950:1000),3)
[DDD,YYY]=meshgrid(zz,150:2:300)
contourf(YYY,DDD,THETA_PLOT)
% caxis([11 13])
xlabel('Y (km)', 'FontSize', 17)
ylabel('Depth (m)','FontSize', 17)
set(gca,'fontsize',15)
axis ij;colorbar;colormap(flipud(haxby));
set(gca,'YDir','normal'); 
title('Mean potential temperature (degC)');
get(gca)
