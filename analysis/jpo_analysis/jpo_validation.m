clear all;
% close ll;

%%% Plotting options
fontsize = 12;

%%% Initialize figure
figure(1);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 1200 680]);
set(gcf,'Color','w');

boxcolor = [0.85 0.85 0.85];

%%% colormap
addpath /data/MITgcm_ASF-csi/analysis/colormaps
addpath /data/MITgcm_ASF-csi/analysis/colormaps/customcolormap
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
boxcolor = [240 240 240]/255;

%%% Load reference experiment
expname = 'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2';
expdir = '/home/csi/MITgcm_ASF-experiments';
loadexp;

load([exppath '/' expname '_tavg_5yrs.mat'],'UVEL','SALT','THETA','PHIHYD',...
    'SIuice','SIarea','SIheff');
load([exppath '/' expname '_gamma_n.mat'])

% load([exppath '/' expname '_tx_avg_5yrs.mat'],...
%     'SIuice','SIarea','SIheff');

THETA(THETA==0) = NaN;
SALT(SALT==0) = NaN;
UVEL(UVEL==0) = NaN;
gamma_n(gamma_n==0) = NaN;

uos = squeeze(nanmean(UVEL,1));
uice = (nanmean(SIuice(:,:,1),1));
area = (nanmean(SIarea(:,:,1),1));
heff = (nanmean(SIheff(:,:,1),1));

nslice = 100;%125
theta = squeeze(THETA(nslice,:,:));
salt = squeeze(SALT(nslice,:,:));
uvel = squeeze(UVEL(nslice,:,:));
gamma = squeeze(gamma_n(nslice,:,:));

% uice = SIuice(nslice,:,1);
% area = SIarea(nslice,:,1);
% heff = SIheff(nslice,:,1);
% gamma = squeeze(nanmean(gamma_n,1));





yys = yy;
zzs = zz;
% zzs(end) = -H;

%%% Load the observation 
addpath /home/csi/research/au0603_ctd;
addpath /home/csi/research/au0603_ladcp;
load('EastAntarctica_CTD_jpo.mat','ss','tt','gam_f','yy_f','zz_i','yy','zz','zb_f');
load('EastAntarctica_LADCP_jpo.mat','uuf','YYf','ZZf');

%%% Fine-grid ss and tt
% ss_f = interp1(yy,ss,yy_f);
% tt_f = interp1(yy,tt,yy_f);
% 
% ss_fi = interp1(zz,ss_f',zz_i)';
% tt_fi = interp1(zz,tt_f',zz_i)';

GRAY = [180 180 180]/255;
GRAY2 = [160 160 160]/255;

%%% Interpolate onto fine grid
[YY,ZZ] = meshgrid(yy,zz);
[YY_f,ZZ_i] = meshgrid(yy_f,zz_i);
ss_fi = interp2(YY,ZZ,ss',YY_f,ZZ_i,'linear'); 
ss_fi = inpaint_nans(ss_fi,0);
tt_fi = interp2(YY,ZZ,tt',YY_f,ZZ_i,'linear'); 
tt_fi = inpaint_nans(tt_fi,0);

%%% Fine-grid topography
for j=1:size(yy_f,1)
  for k=1:size(zz_i,2)
    if (zz_i(k)<zb_f(j))
      ss_fi(k,j) = NaN;      
      tt_fi(k,j) = NaN;      
    end
  end
end

yy_f = yy_f(end)-flip(yy_f);
yy_f = flip(yy_f);

Noffset = 100; % 100 km
yy_f = yy_f + Noffset*1000;
yy_f = [yy_f;1000.*[Noffset-1:-1:0]'];
% zb_f = [zb_f;-H.*ones(Noffset,1)];
zb_f = [zb_f;NaN.*ones(Noffset,1)];

Nzz_f = size(ss_fi,1);
ss_fi = [ss_fi NaN.*ones(Nzz_f,Noffset)];
tt_fi = [tt_fi NaN.*ones(Nzz_f,Noffset)];
gam_f = [gam_f' NaN.*ones(Nzz_f,Noffset)]';

NZZf = size(ZZf,1);
uuf = [uuf NaN.*ones(NZZf,Noffset)];
%%

ax1 = subplot('position',[0.05 0.85 0.25 0.11]);
annotation('textbox',[0.04 0.945 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
plot(yys(1:Ny-25)/1000,heff(1:Ny-25),'color',[0.8500 0.3250 0.0980])
set(gca,'FontSize',fontsize-3)
title('$h_i$', 'FontSize', fontsize,'interpreter','latex');
% xlabel('y (km)', 'FontSize', fontsize-2,'interpreter','latex');
ylabel('(m)', 'FontSize', fontsize-2,'interpreter','latex');
xlim([0 400])

ax2 = subplot('position',[0.37 0.85 0.25 0.11]);
annotation('textbox',[0.36 0.945 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
plot(yys(1:Ny-25)/1000,area(1:Ny-25),'color',[0.8500 0.3250 0.0980])
set(gca,'FontSize',fontsize-3)
title('$A_i$', 'FontSize', fontsize,'interpreter','latex');
% xlabel('y (km)', 'FontSize', fontsize-2,'interpreter','latex');
xlim([0 400])

ax3 = subplot('position',[0.69 0.85 0.25 0.11]);
annotation('textbox',[0.68 0.945 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
plot(yys(1:Ny-12)/1000,uice(1:Ny-12),'color',[0.8500 0.3250 0.0980])
hold on;
plot(yys(1:Ny-12)/1000,uos(1:Ny-12,1),'color',[0 0.4470 0.7410])
set(gca,'FontSize',fontsize-3)
leg3 = legend('$u_i$','$u^s_o$','FontSize', fontsize-1,'interpreter','latex');
legend boxoff; set(leg3,'position',[0.85 0.905 0.05 0.05])
hold off;
title('$u_i$, $u^s_o$', 'FontSize', fontsize,'interpreter','latex');
% xlabel('y (km)', 'FontSize', fontsize-2,'interpreter','latex');
ylabel('(m/s)', 'FontSize', fontsize-2,'interpreter','latex');
xlim([0 400])

%%
ax4 = subplot('position',[0.05 0.475 0.25 0.28]);
annotation('textbox',[0.04 0.74 0.05 0.05],'String','(d)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
pcolor(yys(1:Ny-25)/1000,-zzs/1000,theta(1:Ny-25,:)');shading interp;axis ij;
hold on;
plot(yys/1000,-bathy(1,:)/1000,'k','LineWidth',1);
% plot(yys/1000,-bathy(25,:)/1000,'k','LineWidth',1);
colormap(mycolormap);freezeColors;
set(gca,'FontSize',fontsize-3)
[M,c] = contour(yys(1:Ny-25)/1000,-zzs/1000,gamma(1:Ny-25,:)',[27.60 28.03 28.27 28.35],'LineColor',GRAY2);
clabel(M,c,'FontSize', fontsize-2,'interpreter','latex');
hold off;
caxis([-2.1 1.2]);
ylim([0 4])
xlim([0 400])
c4 = colorbar;cbfreeze(c4);
set(c4,'Position',[0.31 0.475 0.01 0.28])
title('T ($^\circ$ C)','FontSize', fontsize,'interpreter','latex');
% xlabel('y (km)', 'FontSize', fontsize-2,'interpreter','latex');
ylabel('Depth (km)', 'FontSize', fontsize-2,'interpreter','latex');
set(gca,'color',boxcolor);
%%

ax5 = subplot('position',[0.37 0.475 0.25 0.28]);
annotation('textbox',[0.36 0.74 0.05 0.05],'String','(e)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
pcolor(yys(1:Ny-25)/1000,-zzs/1000,salt(1:Ny-25,:)');shading interp;axis ij;
hold on;
plot(yys/1000,-bathy(1,:)/1000,'k','LineWidth',1);
% plot(yys/1000,-bathy(25,:)/1000,'k','LineWidth',1);
[M,c] = contour(yys(1:Ny-25)/1000,-zzs/1000,gamma(1:Ny-25,:)',[27.60 28.03 28.27 28.35],'LineColor',GRAY2);
clabel(M,c,'FontSize', fontsize-2,'interpreter','latex');
hold off;
% colormap('default');freezeColors;
colormap(mycolormap);
caxis([33.5 34.9]);
ylim([0 4])
xlim([0 400])
c5 = colorbar;cbfreeze(c5);
set(gca,'FontSize',fontsize-3)
set(c5,'Position',[0.63 0.475 0.01 0.28])
title('S (psu)','FontSize', fontsize,'interpreter','latex');
% xlabel('y (km)', 'FontSize', fontsize-2,'interpreter','latex');
set(gca,'color',boxcolor);

ax6 = subplot('position',[0.69 0.475 0.25 0.28]);
annotation('textbox',[0.68 0.74 0.05 0.05],'String','(f)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
pcolor(yys(1:Ny-25)/1000,-zzs/1000,uvel(1:Ny-25,:)');shading interp;axis ij;
hold on;
plot(yys/1000,-bathy(1,:)/1000,'k','LineWidth',1);
% plot(yys/1000,-bathy(25,:)/1000,'k','LineWidth',1);
[M,c] = contour(yys(1:Ny-25)/1000,-zzs/1000,gamma(1:Ny-25,:)',[27.60 28.03 28.27 28.35],'LineColor',GRAY);
clabel(M,c,'FontSize', fontsize-2,'interpreter','latex');
hold off;
colormap(mycolormap);
caxis([-0.4 0.4]);
ylim([0 4])
xlim([0 400])
c6 = colorbar;cbfreeze(c6);
set(gca,'FontSize',fontsize-3)
set(c6,'Position',[0.95 0.475 0.01 0.28])
title('u (m/s)','FontSize', fontsize,'interpreter','latex');
% xlabel('y (km)', 'FontSize', fontsize-2,'interpreter','latex');
set(gca,'color',boxcolor);

%%



ax7 = subplot('position',[0.05 0.095 0.25 0.28]);
annotation('textbox',[0.04 0.36 0.05 0.05],'String','(g)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
pcolor(yy_f/1000,-zz_i/1000,tt_fi);shading interp;axis ij;
hold on;
plot(yy_f/1000,-zb_f/1000,'k','LineWidth',1);
[M,c] = contour(yy_f/1000,-zz_i/1000,gam_f',[27.60 28.03 28.27 28.35],'LineColor',GRAY2);
clabel(M,c,'FontSize', fontsize-2,'interpreter','latex');
rectangle(ax7,'Position',[4 0.02 93 3.96],'Curvature',0.2,'EdgeColor',[1 1 1], 'FaceColor', [1 1 1])
hold off;
% set(gca, 'XDir','reverse')
colormap(mycolormap);
caxis([-2.1 1.2]);
ylim([0 4])
xlim([0 400])
c7 = colorbar;cbfreeze(c7);
set(gca,'FontSize',fontsize-3)
set(c7,'Position',[0.31 0.095 0.01 0.28])
title('T$_{\mathrm{obs}}$ ($^\circ$ C)','FontSize', fontsize,'interpreter','latex');
xlabel('Offshore distance y (km)', 'FontSize', fontsize-2,'interpreter','latex');
ylabel('Depth (km)', 'FontSize', fontsize-2,'interpreter','latex');
set(gca,'color',boxcolor);

ax8 = subplot('position',[0.37 0.095 0.25 0.28]);
annotation('textbox',[0.36 0.36 0.05 0.05],'String','(h)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
pcolor(yy_f/1000,-zz_i/1000,ss_fi);shading interp;axis ij;
hold on;
plot(yy_f/1000,-zb_f/1000,'k','LineWidth',1);
[M,c] = contour(yy_f/1000,-zz_i/1000,gam_f',[27.60 28.03 28.27 28.35],'LineColor',GRAY2);
clabel(M,c,'FontSize', fontsize-2,'interpreter','latex');
rectangle(ax8,'Position',[4 0.02 93 3.96],'Curvature',0.2,'EdgeColor',[1 1 1], 'FaceColor', [1 1 1])
hold off;
% set(gca, 'XDir','reverse')
colormap(mycolormap);
caxis([33.5 34.9]);
ylim([0 4])
xlim([0 400])
c8 = colorbar;cbfreeze(c8);
set(gca,'FontSize',fontsize-3)
set(c8,'Position',[0.63 0.095 0.01 0.28])
xlabel('Offshore distance y (km)', 'FontSize', fontsize-2,'interpreter','latex');
title('S$_{\mathrm{obs}}$ (psu)','FontSize', fontsize,'interpreter','latex');
set(gca,'color',boxcolor);


ax9 = subplot('position',[0.69 0.095 0.25 0.28]);
annotation('textbox',[0.68 0.36 0.05 0.05],'String','(i)','interpreter','latex','FontSize',fontsize-1,'LineStyle','None');
pcolor(yy_f/1000,-ZZf(:,1)'/1000,uuf);shading interp;axis ij; 
hold on;
plot(yy_f/1000,-zb_f/1000,'k','LineWidth',1);
[M,c] = contour(yy_f/1000,-ZZf(:,1)'/1000,gam_f(:,1:size(ZZf,1))',[27.60 28.03 28.27 28.35],'LineColor',GRAY);
clabel(M,c,'FontSize', fontsize-2,'interpreter','latex');
rectangle(ax9,'Position',[4 0.02 93 3.96],'Curvature',0.2,'EdgeColor',[1 1 1], 'FaceColor', [1 1 1])
hold off;
colormap(mycolormap);
caxis([-0.4 0.4]);
ylim([0 4])
xlim([0 400])
c9 = colorbar;cbfreeze(c9);
set(gca,'FontSize',fontsize-3)
set(c9,'Position',[0.95 0.095 0.01 0.28])
xlabel('Offshore distance y (km)', 'FontSize', fontsize-2,'interpreter','latex');
title('u$_{\mathrm{obs}}$ (m/s)','FontSize', fontsize,'interpreter','latex');
set(gca,'color',boxcolor);

%%
print('-dpng','-r150','jpo_validation.png');
% saveas(gcf,'jpo_validation','epsc');