
clear; close all

addpath /Users/csi/MITgcm_ASF-csi/utils/matlab/; 
addpath /Users/csi/MITgcm_ASF-csi/analysis/;
addpath /Users/csi/MITgcm_ASF-csi/newexp/;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps/;
addpath  /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis;
prodir = '/Volumes/si/MITgcm_ASF-csi/products-hires'
expdir = '/Users/csi/MITgcm_ASF-csi/experiments';

load([prodir '/icedrift_ystart125km.mat'])
expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod'

EXPNAME{30} = expname;

nExp = length(Ai_slope);

m1km = 1000;
sloperange = 50*m1km;
ystart = 125*m1km;
Lx = 400*m1km;
Ly = 450*m1km;



load([prodir '/' expname '_tavg_5yrs.mat'],'SIuice','SIvice','SIheff','SIarea');
    Ny = size(SIuice,2);
    dy = Ly/Ny; 

    yend = ystart + sloperange;
    ymin = round(ystart/dy);
    ymax = round(yend/dy);
    yidx = ymin:ymax;  % Slope index
    
ui_slope(30) = mean(SIuice(:,yidx,1),'all');
vi_slope(30) = mean(SIvice(:,yidx,1),'all');
hi_slope(30) = mean(SIheff(:,yidx,1),'all');
Ai_slope(30) = mean(SIarea(:,yidx,1),'all');


save([prodir '/icedrift_ystart125km_new.mat'],'EXPNAME','ui_slope','vi_slope','hi_slope','Ai_slope')


