%%%
%%% plotOverturning.m
%%%
%%% Plots the overturning circulation in potential density space.
%%%

%%% Load experiment and pre-computed MOC data
loadexp;
load([expname,'_MOC_theta.mat']);

%%% Plotting options
mac_plots = 1;
scrsz = get(0,'ScreenSize');
fontsize = 26;
framepos = [scrsz(3)/4 scrsz(4)/4 1000 800];
psimin = -2;
psimax = 2;

%%% Calculate zonal-mean density
pt_xtavg = squeeze(nanmean(pt_tavg(:,:,:)));
pt_f_xtavg = squeeze(nanmean(pt_f(:,:,:)));
vflux_xint = squeeze(nanmean(vflux(:,:,:)))*Lx;
vflux_m_xint = squeeze(nanmean(vflux_m(:,:,:)))*Lx;

%%% y/z grid for streamfunction plots
zz_psi = zz_f;
yy_psi = yy;
[ZZ_psi,YY_psi] = meshgrid(zz_psi,yy_psi);
for j=1:Ny      
  
  %%% Adjust height of top point
  ZZ_psi(j,1) = 0;
  
  %%% Calculate depth of bottom cell  
  hFacS_col = squeeze(hFacS_f(1,j,:));  
  kmax = length(hFacS_col(hFacS_col>0)); 
  if (kmax > 0)
    ZZ_psi(j,kmax) = - sum(delRf.*hFacS_col');
  end
  
  %%% Force streamfunction to be zero at boundaries
  psi_z(j,1) = 0;
  psie_z(j,1) = 0;
  psim_z(j,1) = 0;
  if (kmax > 0)
    psi_z(j,kmax) = 0;  
    psie_z(j,kmax) = 0;  
    psim_z(j,kmax) = 0;
  end
  
end

%%% Mesh grid for temperature plot
[ZZ YY] = meshgrid(zz_f,yy);

%%% Plot the residual overturning in y/z space
handle = figure(10);
clf;
set(handle,'Position',framepos);

subplot(3,1,1);
plot(yy/1000,surfQ(1,:),'r-','LineWidth',2);
hold on;
plot(yy([1 end])/1000,0*yy([1 end]),'k--','LineWidth',0.5);
hold off;
set(gca,'Position',[0.12 0.81 0.8 0.16]);     
set(gca,'FontSize',fontsize);
set(gca,'XTick',[500 1000 1500]);
set(gca,'YLim',[-11 6]);
ylabel('Q_s_u_r_f (W/m^2)','FontSize',fontsize);
xlabel('');

subplot(3,1,2);
plot(yy/1000,zonalWind(1,:),'b-','LineWidth',2);
hold on;
plot(yy([1 end])/1000,0*yy([1 end]),'k--','LineWidth',0.5);
hold off;
set(gca,'Position',[0.12 0.6 0.8 0.16]);     
set(gca,'FontSize',fontsize);
set(gca,'XTick',[500 1000 1500]);
set(gca,'YLim',[-0.06 0.16]);
xlabel('');
ylabel('\tau_s_u_r_f (N/m^2)','FontSize',fontsize);

subplot(3,1,3);
[C,h]=contourf(YY_psi/1000,-ZZ_psi/1000,psi_z,[psimin:0.1:psimax],'EdgeColor','None');  
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',3);
[C,h]=contour(YY/1000,-ZZ/1000,pt_f_xtavg,[-0.5:0.5:1 2:2:6 8:2:12],'EdgeColor','k');
plot([50 50],[0 0.5],'k--','LineWidth',1.5);
hold off;
axis([0 2000 0 4]);
handle=colorbar;
set(handle,'FontSize',fontsize);
caxis([psimin -psimin]);
colormap(gca,redblue(200));
set(gca,'YDir','reverse');
xlabel('Offshore (km)','FontSize',fontsize);
ylabel('Depth (km)','FontSize',fontsize);
set(gca,'Position',[0.12 0.1 0.8 0.43]);     
set(gca,'clim',[psimin -psimin]);
set(gca,'FontSize',fontsize);
set(gca,'XTick',[500 1000 1500]);

annotation('textbox',[0.8 0.02 0.3 0.05],'String','$\psi_{\mathrm{res}}$ (Sv)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

if (force_aabw)
  annotation('arrow',[0.148959474260679 0.136332968236583],...
  [0.42728297632469 0.475394588500564],'LineWidth',2);
  annotation('textbox',...
    [0.12157721796276 0.381187147688838 0.127601314348302 0.0462232243517475],...
    'String',{'Cooling'},...
    'FontSize',24,...
    'LineStyle','none');
end
