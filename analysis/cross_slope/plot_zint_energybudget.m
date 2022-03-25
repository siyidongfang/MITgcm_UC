%%% Calculate the vertically integrated energy production, as a function of
%%% latitude

clear;close all;
addpath ..;
addpath ../colormaps;
addpath ../jpo_analysis-hires/;
expdir = '/Users/csi/MITgcm_ASF-csi/experiments/';
prodir = '/Users/csi/MITgcm_ASF-csi/products-hires/';

expname= 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod'
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
fontsize = 13;
boxcolor = [225 225 225]/255;
subplotsize = [0.88 0.27];

%%% Make the plot
clf;

%%
expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis'
load([prodir '/' expname,'_EnergyBudget_5yrs.mat'],'PE_EKE_zint', 'MKE_EKE_zint'); 
PE_EKE_zint_xavg  = sum(PE_EKE_zint*delX(1))/Lx;
MKE_EKE_zint_xavg = sum(MKE_EKE_zint*delX(1))/Lx;

figure(1)
clf;
plot(PE_EKE_zint_xavg);
hold on;
plot(MKE_EKE_zint_xavg);
ylim([-2 1.5]/1e4)



