clear;
addpath /Users/csi/MITgcm_ASF-csi/utils/matlab; 
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps;
addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires/;
expdir='/Volumes/si/MITgcm_ASF-csi/exps_cross_slope/'


% lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf32.4_0dS_init

EXPNAME  = {...
'lores_Ua-6Va6_Atide0_Hi1Ai1_Ws25_ssurf33'
'lores_Ua-6Va6_Atide0.1_Hi1Ai1_Ws25_ssurf33'
'lores_Ua0Va0_Atide0.05_Hi1Ai1_Ws25_ssurf33'
...
'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_0dS_smag'
'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_0dS_smag2'
'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_1dS'
'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_1dS_testViscosity'
'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_1dS_viscAh_viscA4Grid'
'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_2dS'
'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_3dS'
'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_4dS'
...
'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_meanS33.59_dS0.26'
'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_meanS33.59_stratified'
'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33.59_1dS'
'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33.59_2dS'
'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33.59_3dS'
'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33.59_4dS'
...
'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_stratified'
...
'lores_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_sdiff3'
'lores_Ua-6Va6_Atide0.1_Hi1Ai1_Ws25_sdiff3'
'lores_Ua-6Va6_Atide0_Hi1Ai1_Ws25_sdiff3'
'lores_Ua0Va0_Atide0.05_Hi1Ai1_Ws25_sdiff3'
'lores_Ua0Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3'
'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf34.12_3dS_smag2'
...
'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf34.12_4dS'
};
Nexp = length(EXPNAME);

% NITER = [1791818 1791818 1791818 1473645 1791818 1791818 1791818 1791818 1791818 1791818 ...
%     1791818 1791818 1473645 1473645 1473645 1473645]; 

nIter = 1178916

for i=5:5
expname = EXPNAME{i};
% nIter = NITER(i);

loadexp;

figure(1)
clf;
subplot(2,2,1)
aaaa1 = rdmds([exppath,'/results/U'],nIter);
aaaa1(aaaa1==0)=NaN;
aaa1 = squeeze(nanmean(aaaa1));
pcolor(yy/1000,-zz/1000,aaa1');
hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
shading interp;axis ij;colormap('redblue');colorbar
caxis([-0.4 0.4])
title('Zonal velociy (m/s)')
ylabel('z (km)');xlabel('y (km)')

subplot(2,2,2)
aaaa1 = rdmds([exppath,'/results/T'],nIter);
aaa1 = squeeze(mean(aaaa1));
pcolor(yy/1000,-zz/1000,aaa1')
hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
shading interp;axis ij;colormap('redblue');colorbar
caxis([-1.8 1.8])
title('Potential temperature (degC)')
ylabel('z (km)');xlabel('y (km)')


subplot(2,2,3)
aaaa1 = rdmds([exppath,'/results/VVELTH'],nIter);
aaa1 = squeeze(mean(aaaa1));
pcolor(yy/1000,-zz/1000,aaa1')
hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
shading interp;axis ij;colormap('redblue');colorbar
caxis([-0.01 0.01])
title('Advective heat flux (degC.m/s)')
ylabel('z (km)');xlabel('y (km)')

subplot(2,2,4)
rho_o = 1037;
Lx = 400000;
cp_o = 3850;
VVELTH =  rdmds([exppath,'/results/VVELTH'],nIter);
DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
VVELTH_zint = sum(VVELTH.*DZ.*hFacS,3); %%% Depth-integrated 
VVELTH_zint_xavg = squeeze(nanmean(VVELTH_zint));%%% Zonally averaged, depth-integrated 
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg/10^12,'LineWidth',1.5)
title('Meridional Heat Transport')
ylabel('(10$^{12}$ W)','interpreter','latex');
xlabel('y (km)')
ylim([-0.5 0.5])
outdir = '/Users/csi/MITgcm_ASF-csi/cross_slope_exchange/test_exps_new/'
print('-dpng','-r150',[outdir expname '_' num2str(nIter) '.png']);
% print('-dpng','-r150',[outdir expname '_new.png']);


end