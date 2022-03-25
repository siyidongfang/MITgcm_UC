%%%
%%% plotTidalEddyMeanAdvec_new.m
%%%

clear all;close all;
addpath /data/MITgcm_ASF-csi/analysis
addpath /data/MITgcm_ASF-csi/analysis/colormaps;
addpath ../jpo_analysis/
expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments/';
prodir = '/data/MITgcm_ASF-csi/products-hires/';
expname= 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
loadexp;

blue = [0 0.4470 0.7410];
orange = [0.8500 0.3250 0.0980];
coral = [255 127 80]/255;
yellow = [0.9290 0.6940 0.1250];
gold = [255 215 0]/255;
lightblue = [0.3010 0.7450 0.9330];
purple = [0.4940 0.1840 0.5560];
green = [0.4660 0.6740 0.1880];
red = [0.6350 0.0780 0.1840];
gray = [225 225 225]/255;
pink = [255 153 204]/255;
brown = [153 102 51]/255;
olive = [107 142 35]/255;
lightred = [249 102 102]/255;
seagreen = [46 139 87]/255;

%%% Initialize figure
figure(2);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.05*scrsz(3) 0.15*scrsz(4) 600 900]);
set(gcf,'Color','w');

%%% Plotting options
fontsize = 11;
boxcolor = [225 225 225]/255;
subplotsize = [0.86 0.27];

%%% Make the plot
clf;
%%

% %%%%%%
load([prodir 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis_tidalEddyMeanAdvec_new_1350days.mat'])
%%%%%%

ax1 = subplot('position',[0.13 0.7 subplotsize]);
annotation('textbox',[0.93 0.685 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
ltot = plot(yy/1000,-duv_mdy_xzint/1e4,'Color',pink,'LineWidth',1.5);
hold on
leddy = plot(yy/1000,-dutvtdy_xzint/1e4+dumvmdy_xzint/1e4,'-.','Color',orange,'LineWidth',1);
lmean = plot(yy/1000,-dumvmdy_xzint/1e4,'-.','Color',blue,'LineWidth',1);
ltidal = plot(yy/1000,-duv_mdy_xzint/1e4+dutvtdy_xzint/1e4,'-.','Color',yellow,'LineWidth',1);
plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1);
% ltot_MITgcm = plot(yy/1000,totalAdvec_MITgcm_xzint/1e4,'Color',pink,'LineWidth',1.5);

yup = -5;
ydown = 2.5;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,yup+0.5,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(130,yup+0.5,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(260,yup+0.5,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(25,ydown-0.5,'Ref.','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
hold off;
axis ij
set(gca,'fontsize',fontsize);
ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
% xlabel('Offshore distsance (km)', 'FontSize', fontsize+1,'interpreter','latex');
leg3 = legend([ltot,ltidal,leddy,lmean],...
    'Total ocean advection','Tidal component','Eddy component','Mean component',...
    'FontSize', fontsize,'interpreter','latex'); 
% 'Total ocean adv.','Tidal advection','Eddy advection','Mean advection',...
set(leg3,'position',[0.5762    0.8244    0.3277    0.1040])
xlim([20,430])
title('Decomposition of the total advection','FontSize',fontsize+2,'interpreter','latex');



%%

%%%%%%
load([prodir 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_analysis_tidalEddyMeanAdvec_new_675days.mat'])
%%%%%%

ax2 = subplot('position',[0.13 0.38 subplotsize]);
annotation('textbox',[0.93 0.365 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
ltot = plot(yy/1000,-duv_mdy_xzint/1e4,'Color',pink,'LineWidth',1.5);
hold on
leddy = plot(yy/1000,-dutvtdy_xzint/1e4+dumvmdy_xzint/1e4,'-.','Color',orange,'LineWidth',1);
lmean = plot(yy/1000,-dumvmdy_xzint/1e4,'-.','Color',blue,'LineWidth',1);
ltidal = plot(yy/1000,-duv_mdy_xzint/1e4+dutvtdy_xzint/1e4,'-.','Color',yellow,'LineWidth',1);
plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1);
% ltot_MITgcm = plot(yy/1000,totalAdvec_MITgcm_xzint/1e4,'Color',pink,'LineWidth',1.5);


yup = -13;
ydown = 12;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,yup+1.5,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(130,yup+1.5,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(260,yup+1.5,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(25,ydown-1.5,'$\Delta\mathrm{S}=0.62$ psu','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
hold off;
axis ij
set(gca,'fontsize',fontsize);
ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
xlim([20,430])


%%

%%%%%%
load([prodir 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis_tidalEddyMeanAdvec_new_540days.mat'])
%%%%%%

ax3 = subplot('position',[0.13 0.06 subplotsize]);
annotation('textbox',[0.93 0.045 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
ltot = plot(yy/1000,-duv_mdy_xzint/1e4,'Color',pink,'LineWidth',1.5);
hold on
leddy = plot(yy/1000,-dutvtdy_xzint/1e4+dumvmdy_xzint/1e4,'-.','Color',orange,'LineWidth',1);
lmean = plot(yy/1000,-dumvmdy_xzint/1e4,'-.','Color',blue,'LineWidth',1);
ltidal = plot(yy/1000,-duv_mdy_xzint/1e4+dutvtdy_xzint/1e4,'-.','Color',yellow,'LineWidth',1);
plot(yy/1000,zeros(1,Ny),':','Color',gray,'LineWidth',1);
% ltot_MITgcm = plot(yy/1000,totalAdvec_MITgcm_xzint/1e4,'Color',pink,'LineWidth',1.5);

yup = -5;
ydown = 2.5;
ylim([yup ydown]);
line([125 125],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([175 175],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(60,yup+0.5,'Shelf','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(130,yup+0.5,'Slope','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(260,yup+0.5,'Deep ocean','FontSize',fontsize,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(25,ydown-0.5,'$\Delta\mathrm{S}=-1.17$ psu','FontSize',fontsize+1,'Color',[0 0 0],'interpreter','latex');
hold off;
axis ij
set(gca,'fontsize',fontsize);
ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
xlabel('y (km)', 'FontSize', fontsize+1,'interpreter','latex');
% xlabel('Offshore distsance (km)', 'FontSize', fontsize+1,'interpreter','latex');

xlim([20,430])

%% Write to file
% print('-dpng','-r150','TidalEddyMeanAdvec_new.png');

% load([prodir 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis_tidalEddyMeanAdvec_new_540days.mat'])
% 
% expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis'
% loadexp;
% load([prodir expname '_tavg_5yrs.mat'],'UV_VEL_Z','UVELSQ','WU_VEL');
% 
% dy = delY(1);
% dx = delX(1);
% DX_xy = repmat(delX',[1 Ny]);
% DY_xy = repmat(delY,[Nx 1]);
% DY = repmat(delY',[1 Nr]);
% DZ = repmat(delR,[Ny 1]);
% DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
% DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
% DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
% 
% 
% rho0 = 999.8;
% uv_m = UV_VEL_Z; % on vorticity-grid
% uu_m = UVELSQ;
% uw_m = WU_VEL;   % on u-grid, model level -1/2
% 
% duv_mdy = zeros(Nx,Ny,Nr); 
% duu_mdx = zeros(Nx,Ny,Nr); 
% 
% 
% 
% duv_mdy(:,1:Ny-1,:) = diff(uv_m,1,2)./dy;  % on u grid
% duv_mdy(:,Ny,:) = (0-uv_m(:,Ny,:))./dy;
% 
% duw_mdz(:,:,2:Nr) = diff(uw_m,1,3)./DRF(:,:,2:Nr); % on u grid
% duw_mdz(:,:,1) = (uw_m(:,:,1)-0)./DRF(:,:,1);
% 
% duu_mdx = (uu_m([2:Nx 1],:,:)-uu_m([Nx 1:Nx-1],:,:))./(2*dx);   % Centered difference, on u grid
% 
% duv_mdy_xzint = rho0.*sum(sum(duv_mdy.*hFacW.*DZ_xyz.*DX_xyz,3),1);
% duw_mdz_xzint = rho0.*sum(sum(duw_mdz.*hFacW.*DZ_xyz.*DX_xyz,3),1);
% duu_mdx_xzint = rho0.*sum(sum(duu_mdx.*hFacW.*DZ_xyz.*DX_xyz,3),1);
% 
% 
% figure(2)
% clf
% plot(yy/1000,(-dumvmdy_xzint + dumwmdz_xzint - dumumdx_xzint)/1e4) % mean
% hold on;
% plot(yy/1000,(-dutvtdy_xzint +dutwtdz_xzint -dututdx_xzint - dumvmdy_xzint + dumwmdz_xzint - dumumdx_xzint)/1e4) % Eddy
% plot(yy/1000,(-duv_mdy_xzint +duw_mdz_xzint  -duu_mdx_xzint  +dutvtdy_xzint  -dutwtdz_xzint  +dututdx_xzint )/1e4) % Tidal 
% plot(yy/1000,(-duv_mdy_xzint +duw_mdz_xzint  -duu_mdx_xzint)/1e4) % Total
% % plot(yy/1000,(dumvmdy_xzint)/1e4) % mean
% % hold on;
% % plot(yy/1000,(-dutvtdy_xzint - dumvmdy_xzint)/1e4) % Eddy
% % plot(yy/1000,(-duv_mdy_xzint + dutvtdy_xzint)/1e4) % Tidal 
% % plot(yy/1000,(-duv_mdy_xzint)/1e4) % Total
% plot(yy/1000,totalAdvec_MITgcm_xzint/1e4,'Color',pink,'LineWidth',1.5);
% hold off;
% ylim([-6 4]);
% legend('Mean','Eddy','Tidal','Total: csi','Total: MITgcm')
