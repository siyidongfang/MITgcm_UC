clear;
addpath ../.
addpath ../utils/matlab; 
addpath ../analysis/colormaps;
expdir='/Volumes/si/MITgcm_ASF-csi/exps_cross_slope/'
expname='hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_0dS'
% prodir = '/Volumes/si/MITgcm_ASF-csi/products-hires/'
% expdir='/Volumes/si/MITgcm_ASF-csi/experiments/'
% expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod'

loadexp;

nIter = 1971000

SALT = rdmds([exppath,'/results/SALT'],nIter);
THETA= rdmds([exppath,'/results/THETA'],nIter);
PHIHYD=rdmds([exppath,'/results/PHIHYD'],nIter);
% load([prodir expname '_tavg_5yrs.mat'],'THETA','SALT','PHIHYD');

theta_tavg = THETA;  
salt_tavg = SALT;    
pressure_tavg =PHIHYD; 
  
  %%% Calculate the potential density 
  g=9.81;
  rhoConst = 999.8;
  refdepth = -zz(51);
  refpress = rhoConst*(g*refdepth + pressure_tavg(:,:,51))/1e4; %%% unit: dbar
  

  
  for kk = 1:Nr
      pt_tavg(:,:,kk) = densmdjwf(salt_tavg(:,:,kk),theta_tavg(:,:,kk),refpress)-1000;
  end
  
    pt_tavg(SALT==0) = NaN;
    pt_xtavg = squeeze(nanmean(pt_tavg(:,:,:)));

    t_xavg = THETA;
    t_xavg(THETA==0) = NaN;
    t_xavg = squeeze(nanmean(t_xavg(:,:,:)));
    
 
%%


clear layers_bounds

     layers_bounds(:,1) = [0 35 ...
         35.8:0.05:36.3 ...
         36.4 36.54:0.02:36.66 ...
         36.7 36.73 36.76 36.8:0.1:37.1 ...
         37.13:0.02:37.17 37.18:0.004:37.206 ...
         37.21:0.003:37.3 37.5 40]; 
     layers_bounds(:,2) = [-10 -1.88:0.01:-1.78 -1.76:0.05:-1.2 -1.18:0.02:-1.16 -1.144:0.002:-1.18 -1.15:0.05:1 10];

     
     

[ZZ,YY] = meshgrid(zz,yy);

         
figure(1)
clf;
subplot(1,2,1)
pcolor(yy/1000,-zz/1000,pt_xtavg');
hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(51,:)/1000,'k','LineWidth',1.5);
[C,h]=contour(YY/1000,-ZZ/1000,pt_xtavg,layers_bounds(:,1),'EdgeColor','w','LineWidth',0.7);
hold off;
shading interp 
axis ij;colormap('jet');colorbar
caxis([35.6 37.4])
ylabel('z (km)');xlabel('y (km)')

subplot(1,2,2)
pcolor(yy/1000,-zz/1000,t_xavg');
hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(51,:)/1000,'k','LineWidth',1.5);
[C,h]=contour(YY/1000,-ZZ/1000,t_xavg,layers_bounds(:,2),'EdgeColor','w','LineWidth',0.7);
hold off;
shading interp 
axis ij;colormap('jet');colorbar
caxis([-2 1])
ylabel('z (km)');xlabel('y (km)')



