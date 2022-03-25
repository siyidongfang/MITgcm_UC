%%%
%%% plotSurfPres.m
%%%
%%% Makes plots of surface pressure.
%%%

%%% NOTE: Doesn't account for u/v gridpoint locations

%%% Select topography
topog = 'bump';

%%% Read experiment data
expname = ['FS_taue0.15_tauw0.05_Q10_res4km_',topog,'_kpp'];
setTimeframe;
loadexp;
pp_ref = readIters(exppath,'PHIHYD',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);
expname = ['FS_taue0.15_tauw0_Q10_res4km_',topog,'_kpp_noaabw'];
setTimeframe;
loadexp;
pp_noaabw = readIters(exppath,'PHIHYD',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);
expname = ['FS_taue0.075_tauw0.05_Q10_res4km_',topog,'_kpp'];
setTimeframe;
loadexp;
pp_weaksam = readIters(exppath,'PHIHYD',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);

%%% Meshgrid for plotting
[YY,XX] = meshgrid(yy/1000,xx/1000);
kmax = sum(ceil(hFacC),3);
kmax(kmax==0) = 1;

%%% Plotting options
scrsz = get(0,'ScreenSize');
fontsize = 26;
framepos = [0 scrsz(4)/2 700 550];
plotloc = [0.15 0.15 0.7 0.75];

%%% Extract surface pressure and subtract northern boundary pressure
eta_ref = pp_ref(:,:,1)/gravity;
eta_ref(eta_ref==0) = NaN;
eta_ref = eta_ref - mean(eta_ref(:,end-1));
eta_noaabw = pp_noaabw(:,:,1)/gravity;
eta_noaabw(eta_noaabw==0) = NaN;
eta_noaabw = eta_noaabw - mean(eta_noaabw(:,end-1));
eta_weaksam = pp_weaksam(:,:,1)/gravity;
eta_weaksam(eta_weaksam==0) = NaN;
eta_weaksam = eta_weaksam - mean(eta_weaksam(:,end-1));

%%% Make the plot
handle = figure(12);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
set(gcf,'color','w');
contourf(XX,YY,eta_ref,[-1.2:0.025:.2],'EdgeColor','k');  
xlabel('x (km)');
ylabel('y (km)');   
handle=colorbar;
colormap haxby;
set(handle,'FontSize',fontsize);
set(gca,'Position',plotloc);
annotation('textbox',[0.8 0.05 0.25 0.05],'String','SSH (m)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
title('Reference case');

%%% Make the plot
handle = figure(13);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
set(gcf,'color','w');
contourf(XX,YY,eta_ref-eta_noaabw,[-1:0.025:.2],'EdgeColor','k');  
xlabel('x (km)');
ylabel('y (km)');   
handle=colorbar;
colormap redblue;
caxis([-.2 .2]);
set(handle,'FontSize',fontsize);
set(gca,'Position',plotloc);
annotation('textbox',[0.8 0.05 0.25 0.05],'String','SSH (m)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
title('Reference case - no AABW');

%%% Make the plot
handle = figure(14);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
set(gcf,'color','w');
contourf(XX,YY,eta_ref-eta_weaksam,[-1:0.025:.2],'EdgeColor','k');  
xlabel('x (km)');
ylabel('y (km)');   
handle=colorbar;
colormap redblue;
caxis([-.2 .2]);
set(handle,'FontSize',fontsize);
set(gca,'Position',plotloc);
annotation('textbox',[0.8 0.05 0.25 0.05],'String','SSH (m)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
title('Reference case - weak westerlies');
