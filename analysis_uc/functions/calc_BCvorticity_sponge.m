%%%
%%% calc_BCvorticity_sponge.m
%%%
%%% Calculate the vorticity fluxes at the edge of the sponge layers for 
%%% the CDW layer, surface layer, and all depth.


%%% Indices of the sponge layers
spongeThicknessDim = 20*m1km;
spongeThickness = round(spongeThicknessDim/dy);

xidx_eastsponge = spongeThickness+1;
xidx_westsponge = Nx-spongeThickness;
yidx_northsponge = Ny-spongeThickness;

%%% Load vorticity budget terms
prodname = [prodir expname '_BCvorticity_cdw.mat'];
% prodname = [prodir expname '_BCvorticity_sw.mat'];
% prodname = [prodir expname '_BCvorticity_AllDepth.mat'];
load(prodname)

xidx_sponge = xidx_eastsponge;
east_Um_dPhiX_zint = Um_dPhiX_zint(xidx_sponge,:);
east_Vm_dPhiY_zint = Vm_dPhiY_zint(xidx_sponge,:);
east_Um_Advec_zint = Um_Advec_zint(xidx_sponge,:);
east_Vm_Advec_zint = Vm_Advec_zint(xidx_sponge,:);
east_Um_Diss_zint = Um_Diss_zint(xidx_sponge,:);
east_Vm_Diss_zint = Vm_Diss_zint(xidx_sponge,:);
east_Um_Ext_zint = Um_Ext_zint(xidx_sponge,:);
east_Vm_Ext_zint = Vm_Ext_zint(xidx_sponge,:);

xidx_sponge = xidx_westsponge;
west_Um_dPhiX_zint = Um_dPhiX_zint(xidx_sponge,:);
west_Vm_dPhiY_zint = Vm_dPhiY_zint(xidx_sponge,:);
west_Um_Advec_zint = Um_Advec_zint(xidx_sponge,:);
west_Vm_Advec_zint = Vm_Advec_zint(xidx_sponge,:);
west_Um_Diss_zint = Um_Diss_zint(xidx_sponge,:);
west_Vm_Diss_zint = Vm_Diss_zint(xidx_sponge,:);
west_Um_Ext_zint = Um_Ext_zint(xidx_sponge,:);
west_Vm_Ext_zint = Vm_Ext_zint(xidx_sponge,:);

north_Um_dPhiX_zint = Um_dPhiX_zint(:,yidx_northsponge);
north_Vm_dPhiY_zint = Vm_dPhiY_zint(:,yidx_northsponge);
north_Um_Advec_zint = Um_Advec_zint(:,yidx_northsponge);
north_Vm_Advec_zint = Vm_Advec_zint(:,yidx_northsponge);
north_Um_Diss_zint = Um_Diss_zint(:,yidx_northsponge);
north_Vm_Diss_zint = Vm_Diss_zint(:,yidx_northsponge);
north_Um_Ext_zint = Um_Ext_zint(:,yidx_northsponge);
north_Vm_Ext_zint = Vm_Ext_zint(:,yidx_northsponge);

figure(1)
set(gcf,'color','w')
subplot(1,2,1)
l1 = plot(yy/1000,east_Um_dPhiX_zint);
hold on;
l2 = plot(yy/1000,east_Um_Advec_zint);
l3 = plot(yy/1000,east_Um_Diss_zint);
l4 = plot(yy/1000,east_Um_Ext_zint);
% l5 = plot(yy/1000,east_zeta_residual,'k--');
hold off;
legend('dPhi','Advec','Diss','Ext')
title('Vorticity fluxes: eastern sponge layer (U terms)')
ylabel('(m^2/s^2)')
xlabel('Latitude, y (km)')
set(gca,'FontSize',fontsize)

subplot(1,2,2)
l1 = plot(yy/1000,east_Vm_dPhiY_zint);
hold on;
l2 = plot(yy/1000,east_Vm_Advec_zint);
l3 = plot(yy/1000,east_Vm_Diss_zint);
l4 = plot(yy/1000,east_Vm_Ext_zint);
% l5 = plot(yy/1000,east_zeta_residual,'k--');
hold off;
legend('dPhi','Advec','Diss','Ext')
title('Vorticity fluxes: eastern sponge layer (V terms)')
ylabel('(m^2/s^2)')
xlabel('Latitude, y (km)')
set(gca,'FontSize',fontsize)
ylim([-20 20])





figure(2)
set(gcf,'color','w')
subplot(1,2,1)
l1 = plot(yy/1000,west_Um_dPhiX_zint);
hold on;
l2 = plot(yy/1000,west_Um_Advec_zint);
l3 = plot(yy/1000,west_Um_Diss_zint);
l4 = plot(yy/1000,west_Um_Ext_zint);
hold off;
legend('dPhi','Advec','Diss','Ext')
title('Vorticity fluxes: western sponge layer (U terms)')
ylabel('(m^2/s^2)')
xlabel('Latitude, y (km)')
set(gca,'FontSize',fontsize)

subplot(1,2,2)
l1 = plot(yy/1000,west_Vm_dPhiY_zint);
hold on;
l2 = plot(yy/1000,west_Vm_Advec_zint);
l3 = plot(yy/1000,west_Vm_Diss_zint);
l4 = plot(yy/1000,west_Vm_Ext_zint);
hold off;
legend('dPhi','Advec','Diss','Ext')
title('Vorticity fluxes: western sponge layer (V terms)')
ylabel('(m^2/s^2)')
xlabel('Latitude, y (km)')
set(gca,'FontSize',fontsize)
ylim([-20 20])


% Um_dPhiX_zint(Um_dPhiX_zint==0)=NaN;
% pcolor(Um_dPhiX_zint)
% shading flat;
% colorbar;colormap(redblue);
% clim([-10 10])
% 
% Vm_dPhiY_zint(Vm_dPhiY_zint==0)=NaN;
% pcolor(Vm_dPhiY_zint)
% shading flat;
% colorbar;colormap(redblue);
% clim([-10 10])
% 
% Um_Advec_zint(Um_Advec_zint==0)=NaN;
% pcolor(Um_Advec_zint)
% shading flat;
% colorbar;colormap(redblue);
% clim([-10 10])
% 
% Vm_Advec_zint(Vm_Advec_zint==0)=NaN;
% pcolor(Vm_Advec_zint)
% shading flat;
% colorbar;colormap(redblue);
% clim([-10 10])


%%

%%% Calculate the budgets at the sponge layers
xidx_sponge = xidx_eastsponge;
east_zeta_dPhi = zeta_dPhi(xidx_sponge,:);
east_zeta_Advec = zeta_Advec(xidx_sponge,:);
east_zeta_Diss = zeta_Diss(xidx_sponge,:);
east_zeta_Ext = zeta_Ext(xidx_sponge,:);
east_zeta_residual = zeta_residual(xidx_sponge,:);

xidx_sponge = xidx_westsponge;
west_zeta_dPhi = zeta_dPhi(xidx_sponge,:);
west_zeta_Advec = zeta_Advec(xidx_sponge,:);
west_zeta_Diss = zeta_Diss(xidx_sponge,:);
west_zeta_Ext = zeta_Ext(xidx_sponge,:);
west_zeta_residual = zeta_residual(xidx_sponge,:);

north_zeta_dPhi = zeta_dPhi(:,yidx_northsponge);
north_zeta_Advec = zeta_Advec(:,yidx_northsponge);
north_zeta_Diss = zeta_Diss(:,yidx_northsponge);
north_zeta_Ext = zeta_Ext(:,yidx_northsponge);
north_zeta_residual = zeta_residual(:,yidx_northsponge);

fontsize = 17;

if(showfigure)
figure(1)
set(gcf,'color','w')
l1 = plot(yy/1000,east_zeta_dPhi);
hold on;
l2 = plot(yy/1000,east_zeta_Advec);
l3 = plot(yy/1000,east_zeta_Diss);
l4 = plot(yy/1000,east_zeta_Ext);
l5 = plot(yy/1000,east_zeta_residual,'k--');
hold off;
legend('dPhi','Advec','Diss','Ext')
title('Vorticity budget: eastern sponge layer')
ylabel('(Pa/m)')
xlabel('Latitude, y (km)')
set(gca,'FontSize',fontsize)


figure(2)
set(gcf,'color','w')
l1 = plot(yy/1000,west_zeta_dPhi);
hold on;
l2 = plot(yy/1000,west_zeta_Advec);
l3 = plot(yy/1000,west_zeta_Diss);
l4 = plot(yy/1000,west_zeta_Ext);
l5 = plot(yy/1000,west_zeta_residual,'k--');
hold off;
legend('dPhi','Advec','Diss','Ext')
title('Vorticity budget: western sponge layer')
ylabel('(Pa/m)')
xlabel('Latitude, y (km)')
set(gca,'FontSize',fontsize)


figure(3)
set(gcf,'color','w')
l1 = plot(xx/1000,north_zeta_dPhi);
hold on;
l2 = plot(xx/1000,north_zeta_Advec);
l3 = plot(xx/1000,north_zeta_Diss);
l4 = plot(xx/1000,north_zeta_Ext);
l5 = plot(xx/1000,north_zeta_residual,'k--');
hold off;
legend('dPhi','Advec','Diss','Ext')
title('Vorticity budget: northern sponge layer')
ylabel('(Pa/m)')
xlabel('Longitude, x (km)')
set(gca,'FontSize',fontsize)
ylim([-0.8 0.8]*1e-5)
end

