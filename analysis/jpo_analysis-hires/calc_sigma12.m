
clear all; close all

addpath /data/MITgcm_ASF-csi/utils/matlab/; 
addpath /data/MITgcm_ASF-csi/analysis/;
addpath /data/MITgcm_ASF-csi/newexp/;
addpath /data/MITgcm_ASF-csi/analysis/colormaps/;
addpath  /data/MITgcm_ASF-csi/analysis/jpo_analysis;
prodir = '/data/MITgcm_ASF-csi/products-hires'
expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments';


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
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_analysis'
};

expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis';
loadexp;

nExp = length(EXPNAME);

sig12_xavg = zeros(nExp,Ny);
dsig12_dy = zeros(nExp,Ny-1);

for ne=1:nExp
    expname = EXPNAME{ne}
    load([prodir '/' expname '_tavg_5yrs.mat'],'SIsig12');
    sig12_xavg(ne,:) = mean(SIsig12(:,:,1),1);
    dsig12_dy(ne,:) = diff(sig12_xavg(ne,:))./delY(1);
end


save([prodir '/sig12.mat'],'EXPNAME','sig12_xavg','dsig12_dy');


