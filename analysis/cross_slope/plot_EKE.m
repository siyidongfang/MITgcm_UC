
addpath ../jpo_analysis-hires/
outdir = '/Users/csi/MITgcm_ASF-csi/cross_slope_exchange/figures_check_heatbudget/'
prodir = '/Volumes/si/MITgcm_ASF-csi/products_cross_slope/';
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_cross_slope/';
expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_0dS_prod'

fname = {'High-res,','fresh-shelf,','595-day mean'}
% fname = {'Low-res,','fresh-shelf,','5-year mean'}

loadexp;
load([prodir '/' expname '_tavg_595days.mat'],'UVEL','VVEL','WVEL','UVELSQ','VVELSQ');


vv=VVEL;
uu=UVEL;
ww=WVEL;
usq=UVELSQ;
vsq=VVELSQ;

%%% Grid spacing matrices
DX = repmat(delX',[1 Ny Nr]);
DY = repmat(delY,[Nx 1 Nr]);
DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
DZC = repmat(reshape(-diff(zz),[1 1 Nr-1]),[Nx Ny 1]);

%%% Mesh grids for plotting
[YY,XX] = meshgrid(yy/1000,xx/1000);


%%%%%%%%%%%%%%%%%%%%%
%%% Calculate EKE %%%
%%%%%%%%%%%%%%%%%%%%%

usq_eddy = usq-uu.^2;
vsq_eddy = vsq-vv.^2;
EKE = 0.5 * ( 0.5 * (usq_eddy(1:Nx,:,:) + usq_eddy([2:Nx 1],:,:)) + 0.5 * (vsq_eddy(:,1:Ny,:) + vsq_eddy(:,[2:Ny 1],:)) );
MKE = 0.5 * ( 0.5 * (uu(1:Nx,:,:).^2 + uu([2:Nx 1],:,:).^2) + 0.5 * (vv(:,1:Ny,:).^2 + vv(:,[2:Ny 1],:).^2) );
EKE_zavg = sum(EKE.*DZ.*hFacC,3) ./ sum(DZ.*hFacC,3); %%% Depth-averaged EKE
EKEDV = EKE.*DX.*DY.*DZ.*hFacC; 
EKE_tot = sum(sum(sum(EKEDV(:,50:end,:)))); %%% Total EKE in the ACC
EKE_xavg = EKE;
EKE_xavg(EKE_xavg==0) = NaN;
EKE_xavg = squeeze(nanmean(EKE_xavg));




%%%%%%%%%%%%%%%%%%%%%
%%% PLOT 
%%%%%%%%%%%%%%%%%%%%%

%%
fontsize = 12;

figure(3)
clf;
Tref = 0;
pcolor(yy/1000,-zz/1000,EKE_xavg');shading interp;axis ij;
% colormap(cmocean('balance',100));
colormap('jet');
colorbar;
caxis([0 0.14]);
xlim([0 450])
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2.5);
set(gca,'FontSize',fontsize)
xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
title('Zonal mean EKE','FontSize', fontsize+5,'interpreter','latex');
hold off;
annotation('textbox',[0.81 0.95 0.15 0.05],'String','($m^2/s^2$)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
text(30,2.8,fname,'FontSize', fontsize+4,'interpreter','latex')
set(gcf,'OuterPosition',[91 155 599 411])

print('-dpng','-r150',[outdir expname '_EKE.png']);