


%%% Load vorticity budget terms
prodname = [prodir expname '_vorticity_cdw.mat'];figname2 = 'cdw'
% prodname = [prodir expname '_BCvorticity_sw.mat'];figname2 = 'sw'
% prodname = [prodir expname '_BCvorticity_AllDepth.mat'];figname2 = 'AllDepth'
load(prodname)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot the area-integrated vorticity budget %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot the vorticity balance %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fontsize = 18;
load_colors;
YLIM = [0 400];
CLIM = [-1 1]/1e5;


figure(1)
set(gcf,'Position',[1 503 1839 1000])
clf;set(gcf,'color','w');
subplot(2,2,1)
pcolor(XXf/1000,YYf/1000,zeta_BPT)
shading flat;colorbar;colormap(cmocean('balance'));
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis(CLIM);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');
ylabel('Latitude, y (km)','Interpreter','latex')
title('Bottom pressure torque (Pa/m)','Interpreter','latex','FontSize',fontsize+3)



subplot(2,2,2)
pcolor(XXf/1000,YYf/1000,zeta_IPT)
shading flat;colorbar;colormap(cmocean('balance'));
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis(CLIM);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');
ylabel('Latitude, y (km)','Interpreter','latex')
title('Interfacial pressure torque (Pa/m)','Interpreter','latex','FontSize',fontsize+3)

subplot(2,2,3)
pcolor(XXf/1000,YYf/1000,zeta_BPT+zeta_IPT)
shading flat;colorbar;colormap(cmocean('balance'));
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis(CLIM);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');
ylabel('Latitude, y (km)','Interpreter','latex')
title('BPT+IPT (Pa/m)','Interpreter','latex','FontSize',fontsize+3)



subplot(2,2,4)
pcolor(XXf/1000,YYf/1000,zeta_BPTplusIPT)
shading flat;colorbar;colormap(cmocean('balance'));
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis(CLIM);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');
ylabel('Latitude, y (km)','Interpreter','latex')
title('BPTplusIPT (Pa/m)','Interpreter','latex','FontSize',fontsize+3)






subplot(2,2,2)
pcolor(XXf/1000,YYf/1000,zeta_Advec)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis(CLIM);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');
ylabel('Latitude, y (km)','Interpreter','latex')
title('Advection term = Coriolis + nonlinear  (Pa/m)','Interpreter','latex','FontSize',fontsize+3)


subplot(2,2,3)
pcolor(XXf/1000,YYf/1000,zeta_Diss)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis(CLIM);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
title('Dissipation term (Pa/m)','Interpreter','latex','FontSize',fontsize+3)

subplot(2,2,4)
pcolor(XXf/1000,YYf/1000,zeta_Ext)
shading flat;colorbar;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
caxis(CLIM);
set(gca,'FontSize',fontsize);
ylim(YLIM);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
title('Surface stress term (Pa/m)','Interpreter','latex','FontSize',fontsize+3)


if(savefigure)
print('-dpng','-r150',[figdir expname '_' figname2 '_vort.png']);
end




% figure(1)
% set(gcf,'Position',[1 503 1839 1000])
% clf;set(gcf,'color','w');
% subplot(2,2,1)
% pcolor(XXf/1000,YYf/1000,zeta_dPhi)
% shading flat;colorbar;colormap(cmocean('balance'));
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% caxis(CLIM);
% set(gca,'FontSize',fontsize);
% ylim(YLIM);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% % xlabel('Longitude, x (km)','Interpreter','latex');
% ylabel('Latitude, y (km)','Interpreter','latex')
% title('Pressure torque (Pa/m)','Interpreter','latex','FontSize',fontsize+3)
% 
% 
% subplot(2,2,2)
% pcolor(XXf/1000,YYf/1000,zeta_Advec)
% shading flat;colorbar;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% caxis(CLIM);
% set(gca,'FontSize',fontsize);
% ylim(YLIM);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% % xlabel('Longitude, x (km)','Interpreter','latex');
% ylabel('Latitude, y (km)','Interpreter','latex')
% title('Advection term = Coriolis + nonlinear  (Pa/m)','Interpreter','latex','FontSize',fontsize+3)
% 
% 
% subplot(2,2,3)
% pcolor(XXf/1000,YYf/1000,zeta_Diss)
% shading flat;colorbar;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% caxis(CLIM);
% set(gca,'FontSize',fontsize);
% ylim(YLIM);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% title('Dissipation term (Pa/m)','Interpreter','latex','FontSize',fontsize+3)
% 
% subplot(2,2,4)
% pcolor(XXf/1000,YYf/1000,zeta_Ext)
% shading flat;colorbar;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% caxis(CLIM);
% set(gca,'FontSize',fontsize);
% ylim(YLIM);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% title('Surface stress term (Pa/m)','Interpreter','latex','FontSize',fontsize+3)
% 
% 
% if(savefigure)
% print('-dpng','-r150',[figdir expname '_' figname2 '_vort.png']);
% end
% 
% 
% figure(11)
% pcolor(XXf/1000,YYf/1000,zeta_residual)
% shading flat;colorbar;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% caxis(CLIM);
% set(gca,'FontSize',fontsize);colormap(cmocean('balance'));
% ylim(YLIM);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% title('Residual (Pa/m)','Interpreter','latex','FontSize',fontsize+3)
% 
% 
% 
% figure(2)
% set(gcf,'Position',[62 305 1889 699])
% clf;set(gcf,'color','w');
% subplot(2,3,1)
% colormap(cmocean('balance'));
% pcolor(XX/1000,YY/1000,zeta_Cori)
% shading flat;colorbar;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% caxis(CLIM);
% title('Coriolis term (model diagnosed) (Pa/m)','Interpreter','latex')
% set(gca,'FontSize',fontsize);
% ylim(YLIM);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% 
% subplot(2,3,2)
% pcolor(XX/1000,YY/1000,zeta_AdvZ3)
% shading flat;colorbar;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% caxis(CLIM);
% title('Vorticity Advection (Pa/m)','Interpreter','latex')
% set(gca,'FontSize',fontsize);
% ylim(YLIM);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% 
% subplot(2,3,3)
% pcolor(XX/1000,YY/1000,zeta_AdvRe)
% shading flat;colorbar;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% caxis(CLIM);
% title('Vertical Advection (explicit part) (Pa/m)','Interpreter','latex')
% set(gca,'FontSize',fontsize);
% ylim(YLIM);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% 
% subplot(2,3,5)
% pcolor(XX/1000,YY/1000,zeta_Advec-(zeta_AdvRe+zeta_AdvZ3+zeta_Cori))
% shading flat;colorbar;colormap(cmocean('balance'));
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:200:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:200:0],'k:','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','on');clabel(C,h,'LabelSpacing',1000);hold off;
% caxis(CLIM);
% title('Total Adv - (Cori + Vort Adv + Vert Adv) (Pa/m)','Interpreter','latex')
% set(gca,'FontSize',fontsize);
% ylim(YLIM);xlim([-300 300])
% yticks(0:100:400);xticks(-300:100:300)
% xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
% 
% if(savefigure)
% print('-dpng','-r150',[figdir expname '_' figname2 '_decomposeAdv.png']);
% end

