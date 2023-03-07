%%%
%%% plotCoastline.m
%%%
%%% Plots the coastline data created by smoothCoastline.m
%%%

%%% Load coastline data
load AntarcticCoastline.mat;
ncntr = 1;
cntr = cntrs{ncntr};
cntr_sub = cntrs_sub{ncntr};
cntr_bathy = cntrs_bathy{ncntr};
lon_mid = cntrs_lon_mid{ncntr};
lat_mid = cntrs_lat_mid{ncntr};
sec_len = cntrs_sec_len{ncntr};

%%% Plotting options
scrsz = get(0,'ScreenSize');
fontsize = 18;
plotloc = [0.08 0.17 0.78 0.8];
framepos = [scrsz(3)/3 scrsz(4)/2 scrsz(3)/2 scrsz(4)/3];

%%% First, compare the high-res contour to the piecewise-linear sections
handle = figure(1);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
plot(cntr_sub(1,:),cntr_sub(2,:));
hold on;
plot([cntr(1,end)+360 cntr(1,:)],[cntr(2,end) cntr(2,:)],'r-');
hold off;
axis([-180 180 -80 -60]);
set(gca,'Position',plotloc);
xlabel('Longitude ($^\circ$)','interpreter','latex','FontSize',fontsize);
ylabel('Latitude ($^\circ$)','interpreter','latex','FontSize',fontsize);
legend('full contour','sub-sample','Location','SouthEast');

%%% Plotting options
scrsz = get(0,'ScreenSize');
fontsize = 18;
plotloc = [0.17 0.17 0.78 0.75];
framepos = [scrsz(3)/3 scrsz(4)/2 scrsz(3)/4 scrsz(4)/3];

%%% Plot cross-slope sections in various regions

handle = figure(2);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
plot(-200:10:200,mean(cntr_bathy(:,244:248),2));
set(gca,'Position',plotloc);
xlabel('Cross-slope distance (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth (m)','interpreter','latex','FontSize',fontsize);
title('Western Weddell Sea');

handle = figure(2);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
plot(-200:10:200,mean(cntr_bathy(:,173:198),2));
set(gca,'Position',plotloc);
xlabel('Cross-slope distance (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth (m)','interpreter','latex','FontSize',fontsize);
title('Eastern Weddell Sea');

handle = figure(3);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
plot(-200:10:200,mean(cntr_bathy(:,216:241),2));
set(gca,'Position',plotloc);
xlabel('Cross-slope distance (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth (m)','interpreter','latex','FontSize',fontsize);
title('Southern Weddell Sea');

handle = figure(4);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
plot(-200:10:200,mean(cntr_bathy(:,294:308),2));
set(gca,'Position',plotloc);
xlabel('Cross-slope distance (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth (m)','interpreter','latex','FontSize',fontsize);
title('Central Bellingshausen Sea');

handle = figure(5);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
plot(-200:10:200,mean(cntr_bathy(:,318:328),2));
set(gca,'Position',plotloc);
xlabel('Cross-slope distance (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth (m)','interpreter','latex','FontSize',fontsize);
title('Central Amundsen Sea');

handle = figure(6);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
plot(-200:10:200,mean(cntr_bathy(:,350:394),2));
set(gca,'Position',plotloc);
xlabel('Cross-slope distance (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth (m)','interpreter','latex','FontSize',fontsize);
title('Southern Ross Sea');

handle = figure(7);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
plot(-200:10:200,mean(cntr_bathy(:,:),2));
set(gca,'Position',plotloc);
xlabel('Cross-slope distance (km)','interpreter','latex','FontSize',fontsize);
ylabel('Depth (m)','interpreter','latex','FontSize',fontsize);
title('Entire Antarctic Coastline');

%%% Plotting options
scrsz = get(0,'ScreenSize');
fontsize = 18;
plotloc = [0.08 0.17 0.78 0.8];
framepos = [scrsz(3)/3 scrsz(4)/2 scrsz(3)/2 scrsz(4)/3];

%%% Contours plot of all data

ll = cumsum(0.5*(sec_len + [0 sec_len(1:end-1)]))/1000;
[YY,XX] = meshgrid(-200:10:200,ll,30);
handle = figure(8);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
contourf(XX,YY,cntr_bathy')
set(gca,'Position',plotloc);
xlabel('Along-slope distance (km)','interpreter','latex','FontSize',fontsize);
ylabel('Cross-slope distance (km)','interpreter','latex','FontSize',fontsize);

[YY,XX] = meshgrid(-200:10:200,lon_mid,30);
handle = figure(9);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
contourf(XX,YY,cntr_bathy')
set(gca,'Position',plotloc);
xlabel('Longitude ($^\circ$)','interpreter','latex','FontSize',fontsize);
ylabel('Cross-slope distance (km)','interpreter','latex','FontSize',fontsize);