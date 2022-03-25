%%%
%%% calcIcedrift.m
%%%

%%% TODO:
%   'res-ws1NewSuvice2_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores5' 
%   'res3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores10'...   


clear all; close all

basedir = '/data/MITgcm_ASF-csi/newexp/analysis/';
addpath /data/MITgcm_ASF-csi/utils/matlab; 
addpath /data/MITgcm_ASF-csi/newexp/analysis;
addpath /data/MITgcm_ASF-csi/experiments/products;
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps;
addpath ~/MITgcm_ASF-experiments/;

% expdir = '/data/MITgcm_ASF-csi/experiments/';
expdir = '~/MITgcm_ASF-experiments/';
prodir = '/data/MITgcm_ASF-csi/experiments/products';

EXPNAME = {...
  'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',...
  'ssurf33.5868_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws25',... 
  'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2',... 
  'den02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'sdiff2_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',... 
  'sdiff2.5_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',... 
  'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'... 
  ...
  'fresh02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  'fresh02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  ...
  'fresh02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...   
  'fresh02-td4_atide0.075Umax1.5Ua-6Va6Hi1Ai1_2kmNr30Ws25',... 
  'fresh02-td3umax2_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  ...
  'fresh02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  ...
  'den02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  'den02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  ...
  'dense_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'dense-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'dense-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  ...
  'ws3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws75_lores2',...  
  'ws5_Ua-6Va6_Atide0.05_Hi0Ai0_Ws125_lores2',... 
  ...
  'fresh02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  ...
  'res-ws1NewSuvice2_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores5',...
  'res3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores10'...   
  };


      
Nexp = length(EXPNAME);

m1km = 1000;
Ys = 150*m1km; % Slope position
dely = 2*m1km;

Ymin = [50 100 200]*m1km;
Ymax = [100 200 300]*m1km;
nymin = Ymin/dely+1; 
nymax = Ymax/dely;   
slopeymin = nymin(2);
slopeymax = nymax(2);

Lx = 400*m1km;
AREA = Lx*(Ymax-Ymin);


for n=1:Nexp-2
expname = EXPNAME{n}
load([prodir '/' expname '_tavg_5yrs.mat'],'SIuice','SIvice','SIheff','SIarea');

ui_slope(n) = mean(SIuice(:,slopeymin:slopeymax,1),'all');
vi_slope(n) = mean(SIvice(:,slopeymin:slopeymax,1),'all');
hi_slope(n) = mean(SIheff(:,slopeymin:slopeymax,1),'all');
Ai_slope(n) = mean(SIarea(:,slopeymin:slopeymax,1),'all');

end

for n=27:27
    
Ys = 200*m1km; % Slope position
Ymin = [50 125 200]*m1km;
Ymax = [100 275 300]*m1km;
nymin = Ymin/dely+1; 
nymax = Ymax/dely;   
slopeymin = nymin(2)+0.5;
slopeymax = nymax(2)-0.5;
AREA = Lx*(Ymax-Ymin);

expname = EXPNAME{n}
load([prodir '/' expname '_tavg_5yrs.mat'],'SIuice','SIvice','SIheff','SIarea');
ui_slope(n) = mean(SIuice(:,slopeymin:slopeymax,1),'all');
vi_slope(n) = mean(SIvice(:,slopeymin:slopeymax,1),'all');
hi_slope(n) = mean(SIheff(:,slopeymin:slopeymax,1),'all');
Ai_slope(n) = mean(SIarea(:,slopeymin:slopeymax,1),'all');

end

for n=28:28
    
Ys = 250*m1km; % Slope position
Ymin = [50 125 200]*m1km;
Ymax = [100 375 450]*m1km;
nymin = Ymin/dely+1; 
nymax = Ymax/dely;   
slopeymin = nymin(2)+0.5;
slopeymax = nymax(2)-0.5;
AREA = Lx*(Ymax-Ymin);

expname = EXPNAME{n}
load([prodir '/' expname '_tavg_5yrs.mat'],'SIuice','SIvice','SIheff','SIarea');
ui_slope(n) = mean(SIuice(:,slopeymin:slopeymax,1),'all');
vi_slope(n) = mean(SIvice(:,slopeymin:slopeymax,1),'all');
hi_slope(n) = mean(SIheff(:,slopeymin:slopeymax,1),'all');
Ai_slope(n) = mean(SIarea(:,slopeymin:slopeymax,1),'all');

end

for n=Nexp-1:Nexp-1
expname = EXPNAME{n}
load([prodir '/' expname '_tavg_5yrs.mat'],'SIuice','SIvice','SIheff','SIarea');

Ys = 150*m1km; % Slope position
dely = 5*m1km;

Ymin = [50 100 200]*m1km;
Ymax = [100 200 300]*m1km;
nymin = Ymin/dely+1; 
nymax = Ymax/dely;   
slopeymin = nymin(2);
slopeymax = nymax(2);

ui_slope(n) = mean(SIuice(:,slopeymin:slopeymax,1),'all');
vi_slope(n) = mean(SIvice(:,slopeymin:slopeymax,1),'all');
hi_slope(n) = mean(SIheff(:,slopeymin:slopeymax,1),'all');
Ai_slope(n) = mean(SIarea(:,slopeymin:slopeymax,1),'all');

end

for n=Nexp:Nexp
expname = EXPNAME{n}
load([prodir '/' expname '_tavg_5yrs.mat'],'SIuice','SIvice','SIheff','SIarea');

Ys = 150*m1km; % Slope position
dely = 10*m1km;

Ymin = [50 100 200]*m1km;
Ymax = [100 200 300]*m1km;
nymin = Ymin/dely+1; 
nymax = Ymax/dely;   
slopeymin = nymin(2);
slopeymax = nymax(2);

ui_slope(n) = mean(SIuice(:,slopeymin:slopeymax,1),'all');
vi_slope(n) = mean(SIvice(:,slopeymin:slopeymax,1),'all');
hi_slope(n) = mean(SIheff(:,slopeymin:slopeymax,1),'all');
Ai_slope(n) = mean(SIarea(:,slopeymin:slopeymax,1),'all');

end
%%



save([prodir '/icedrift.mat'],'EXPNAME','ui_slope','vi_slope','hi_slope','Ai_slope')
