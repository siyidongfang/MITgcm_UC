%%%
%%% calcIcedrift.m
%%%

clear; close all

addpath /Users/csi/MITgcm_ASF-csi/utils/matlab/; 
addpath /Users/csi/MITgcm_ASF-csi/analysis/;
addpath /Users/csi/MITgcm_ASF-csi/newexp/;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps/;
addpath  /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis;
prodir = '/Volumes/si/MITgcm_ASF-csi/products-hires'
expdir = '/Users/csi/MITgcm_ASF-csi/experiments';

EXPNAME = {
    'hires_Ua-6Va6_Atide0_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.025_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.075_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.1_Hi1Ai1_Ws25_analysis'

    'hires_Ua0Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-4Va6_Atide0.05_Hi1Ai1_Ws25_analysis_new100s'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-8Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    
    'hires_Ua-6Va4_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va8_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va12_Atide0.05_Hi1Ai1_Ws25_analysis'
    
    'hires_Ua-6Va6_Atide0.05_Hi0.2Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi0.6Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1.4Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1.8Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi2.2Ai1_Ws25_analysis'
    
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws50_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws75_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws100_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws125_analysis'
    
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33.59_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff1_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff2_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod'
    
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2'
    'res-ws1NewSuvice2_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores5'
    'res3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores10'
};



nExp = length(EXPNAME);


nAtide  = 1:5;
Atide = [0 0.025 0.05 0.075 0.1];
nabs_ua = 6:9;
abs_ua = [0 4 6 8]; 
nva = 10:13;
va = [4 6 8 12];
nhi0 = 14:19;
hi0  = [0.2 0.6 1 1.4 1.8 2.2];
nws = 20:24;
ws = [25 50 75 100 125];
Ys = [150 175 200 225 250];
nbuoy = 25:30;
buoy = [33 33.59 34.17 34.38 34.59 34.79]-34.17; 
% Salinity differences (at z=-500m) between the continental shelf and the open ocean
nres = [31:34];
res = [1 2 5 10];


m1km = 1000;

% sloperange = 100.*ones(1,nExp);
% sloperange(20:24)=2*[25 50 75 100 125]+50; 
% sloperange = sloperange*m1km;
% 
% ystart = 100.*ones(1,nExp);
% ystart = ystart*m1km;

sloperange = 50.*ones(1,nExp);
sloperange(20:24)=2*[25 50 75 100 125]; 
sloperange = sloperange*m1km;

ystart = 125.*ones(1,nExp);
ystart = ystart*m1km;

Lx = 400*m1km;
Ly = 450*m1km;


% for ne=[1:6 8:11 13:nExp]
for ne=1:nExp
expname = EXPNAME{ne}
load([prodir '/' expname '_tavg_5yrs.mat'],'SIuice','SIvice','SIheff','SIarea');
    Ny = size(SIuice,2);
    dy = Ly/Ny; 

    yend = ystart(ne) + sloperange(ne);
    ymin = round(ystart(ne)/dy);
    ymax = round(yend/dy);
    yidx = ymin:ymax;  % Slope index
    
ui_slope(ne) = mean(SIuice(:,yidx,1),'all');
vi_slope(ne) = mean(SIvice(:,yidx,1),'all');
hi_slope(ne) = mean(SIheff(:,yidx,1),'all');
Ai_slope(ne) = mean(SIarea(:,yidx,1),'all');

end



save([prodir '/icedrift_ystart125km.mat'],'EXPNAME','ui_slope','vi_slope','hi_slope','Ai_slope')
