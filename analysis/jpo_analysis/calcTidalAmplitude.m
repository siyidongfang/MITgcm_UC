%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Tidal Current Amplitude  %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

addpath /home/csi/research/CATS2008/TMD;
addpath /home/csi/research/CATS2008/TMD/DATA;

load /home/csi/research/etopo1/AntarcticCoastline.mat


[x,y,uamp_m2,uphase_m2]=tmd_get_coeff('Model_CATS2008','u','m2');
[x,y,vamp_m2,vphase_m2]=tmd_get_coeff('Model_CATS2008','v','m2');
x_lores = x(1:8:end);
y_lores = y(1:8:end);

[yy,xx]=meshgrid(y_lores,x_lores);
[lon,lat]=xy_ll_S(xx,yy,'B');

SDtime=[floor(datenum(now)):1/24:floor(datenum(now))+15];
[uu_tide,conList_u]=tmd_tide_pred_mapts('Model_CATS2008',SDtime,lat,lon,'u',[]);
[vv_tide,conList_v]=tmd_tide_pred_mapts('Model_CATS2008',SDtime,lat,lon,'v',[]);

speed_tide = sqrt(uu_tide.^2+vv_tide.^2);
meanspeed_tide = mean(speed_tide,3);
figure(2)
pcolor(meanspeed_tide);
shading interp;
colorbar;
caxis([0 30]);
title('1-year averaged tidal current speed (m/s)')

% [x,y,uamp_s2,uphase_s2]=tmd_get_coeff('Model_CATS2008','u','s2');
% [x,y,vamp_s2,vphase_s2]=tmd_get_coeff('Model_CATS2008','v','s2');
% 
% [x,y,uamp_n2,uphase_n2]=tmd_get_coeff('Model_CATS2008','u','n2');
% [x,y,vamp_n2,vphase_n2]=tmd_get_coeff('Model_CATS2008','v','n2');
% 
% [x,y,uamp_k2,uphase_k2]=tmd_get_coeff('Model_CATS2008','u','k2');
% [x,y,vamp_k2,vphase_k2]=tmd_get_coeff('Model_CATS2008','v','k2');
% 
% [x,y,uamp_k1,uphase_k1]=tmd_get_coeff('Model_CATS2008','u','k1');
% [x,y,vamp_k1,vphase_k1]=tmd_get_coeff('Model_CATS2008','v','k1');
% 
% [x,y,uamp_o1,uphase_o1]=tmd_get_coeff('Model_CATS2008','u','o1');
% [x,y,vamp_o1,vphase_o1]=tmd_get_coeff('Model_CATS2008','v','o1');
% 
% [x,y,uamp_p1,uphase_p1]=tmd_get_coeff('Model_CATS2008','u','p1');
% [x,y,vamp_p1,vphase_p1]=tmd_get_coeff('Model_CATS2008','v','p1');
% 
% [x,y,uamp_q1,uphase_q1]=tmd_get_coeff('Model_CATS2008','u','q1');
% [x,y,vamp_q1,vphase_q1]=tmd_get_coeff('Model_CATS2008','v','q1');
% 
% [x,y,uamp_mf,uphase_mf]=tmd_get_coeff('Model_CATS2008','u','mf');
% [x,y,vamp_mf,vphase_mf]=tmd_get_coeff('Model_CATS2008','v','mf');
% 
% [x,y,uamp_mm,uphase_mm]=tmd_get_coeff('Model_CATS2008','u','mm');
% [x,y,vamp_mm,vphase_mm]=tmd_get_coeff('Model_CATS2008','v','mm');
% 
% %%
% 
% uamp = uamp_m2 + uamp_s2 + uamp_n2 + uamp_k2 + uamp_k1 + uamp_o1 + uamp_p1 + uamp_q1 + uamp_mf + uamp_mm;
% vamp = vamp_m2 + vamp_s2 + vamp_n2 + vamp_k2 + vamp_k1 + vamp_o1 + vamp_p1 + vamp_q1 + vamp_mf + vamp_mm;
% 
% totalspeed = sqrt(uamp.^2+vamp.^2);
% 
% %%
% speed_m2 = sqrt(uamp_m2.^2+vamp_m2.^2);
% speed_s2 = sqrt(uamp_s2.^2+vamp_s2.^2);
% speed_n2 = sqrt(uamp_n2.^2+vamp_n2.^2);
% speed_k2 = sqrt(uamp_k2.^2+vamp_k2.^2);
% speed_k1 = sqrt(uamp_k1.^2+vamp_k1.^2);
% speed_o1 = sqrt(uamp_o1.^2+vamp_o1.^2);
% speed_p1 = sqrt(uamp_p1.^2+vamp_p1.^2);
% speed_q1 = sqrt(uamp_q1.^2+vamp_q1.^2);
% speed_mf = sqrt(uamp_mf.^2+vamp_mf.^2);
% speed_mm = sqrt(uamp_mm.^2+vamp_mm.^2);
% 
% totalspeed = speed_m2 + speed_s2 + speed_n2 + speed_k2 + speed_k1 + speed_o1 + speed_p1 + speed_q1 + speed_mf + speed_mm ;
% 




%% 



% lon = lon -70; %%%%% TO DOUBLECHECK



%%
save('/home/csi/research/CATS2008/TidalAmplitude_15days_lores.mat','meanspeed_tide','lon','lat','xx','yy',...
    'x_lores','y_lores','speed_tide','conList_u','conList_v');

