%%%
%%% calcFlux_zInteg.m
%%%
%%% Calculate vertical integral of T/S fluxes
%%%

clear;
addpath /Users/csi/MITgcm_ASF-csi/utils/matlab; 
addpath /Users/csi/MITgcm_ASF-csi/analysis;
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng';
prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/'


% %   'fresh02-td5_atide0.125Umax1.75Ua-6Va6Hi1Ai1_2kmNr30Ws25',...  
% 
% %   'res3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores10',...   
% %   'res-ws1NewSuvice2_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores5',... 
% EXPNAME = char( ...
%   'fresh02-td4_atide0.075Umax1.5Ua-6Va6Hi1Ai1_2kmNr30Ws25',...  
%   'ssurf33.5868_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws25',...  
%   'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2',... 
%   'ws3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws75_lores2',...  
%   'ws5_Ua-6Va6_Atide0.05_Hi0Ai0_Ws125_lores2',... 
%   'den02uniformS_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws2',... 
%   'sdiff2.5_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',... 
%   ...
%   'fresh02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'fresh02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
%   'fresh02-td3umax2_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
%   'fresh02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'fresh02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'fresh02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'fresh02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
%   'fresh02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
%   ...
%   'den02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'den02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
%   'den02-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
%   'den02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'den02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'den02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'den02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'den02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
%   'den02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
%   ...
%   'dense_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'dense-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
%   'dense-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
%   ...
%   'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',...
%   'sdiff2_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',... 
%   'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',... 
%   ...
%   'fresh02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25'...
%   );


% EXPNAME = {
%     'hires_Ua-6Va6_Atide0_Hi1Ai1_Ws25_analysis'
%     'hires_Ua-6Va6_Atide0.025_Hi1Ai1_Ws25_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
%     'hires_Ua-6Va6_Atide0.075_Hi1Ai1_Ws25_analysis'
%     'hires_Ua-6Va6_Atide0.1_Hi1Ai1_Ws25_analysis'
% 
%     'hires_Ua0Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
%     'hires_Ua-4Va6_Atide0.05_Hi1Ai1_Ws25_analysis_new100s'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
%     'hires_Ua-8Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
%     
%     'hires_Ua-6Va4_Atide0.05_Hi1Ai1_Ws25_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
%     'hires_Ua-6Va8_Atide0.05_Hi1Ai1_Ws25_analysis'
%     'hires_Ua-6Va12_Atide0.05_Hi1Ai1_Ws25_analysis'
%     
%     'hires_Ua-6Va6_Atide0.05_Hi0.2Ai1_Ws25_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi0.6Ai1_Ws25_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1.4Ai1_Ws25_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1.8Ai1_Ws25_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi2.2Ai1_Ws25_analysis'
%     
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws50_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws75_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws100_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws125_analysis'
%     
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33.59_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff1_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff2_analysis'
%     'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_analysis'
% };


      
% EXPNAME = {...
% 'den02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25' 
% 'den02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
% 'den02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
% 'den02-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
% 'den02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% 'den02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% 'den02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% 'den02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% 'den02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% 'dense-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
% 'dense-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
% 'dense_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% 'fresh02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
% 'fresh02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
% 'fresh02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
% 'fresh02-td3umax2_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
% 'fresh02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% 'fresh02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% 'fresh02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% 'fresh02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% 'sdiff2.5_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
% 'sdiff2_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
% 'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
% 'ssurf33.5868_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws25'
% 'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
% 'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2'};




EXPNAME = {'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
    'ssurf34.12_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
    'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
    'ssurf34.12_2dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
    'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
    'ssurf34.12_3dS_lores_Ua-4Va6_Atide0.05_Hi1Ai1_Ws25'};


expname = 'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25';
loadexp;
    
    
% Nx=400;Ny=448;
% Nx=200;Ny=225;

Nexp = length(EXPNAME);
VVELTH_zint = zeros(Nexp,Nx,Ny);
VVELTH_zint_xavg = zeros(Nexp,Ny);
% VVELSLT_zint = zeros(Nexp,Nx,Ny);
% VVELSLT_zint_xavg = zeros(Nexp,Ny);


for ne = 1:Nexp  
    
expname = EXPNAME{ne}
loadexp;
% load([prodir '/' expname '_tavg_5yrs.mat'],'VVELTH','VVELSLT');
load([prodir '/' expname '_tavg_5yrs.mat'],'VVELTH');

DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

% VVELTH_zint(ne,:,:) = sum(VVELTH.*DZ.*hFacS,3); %%% Depth-integrated 
% VVELTH_zint_xavg(ne,:) = squeeze(nanmean(VVELTH_zint(ne,:,:)));%%% Zonally averaged, depth-integrated 
VVELTH_zint_xavg(ne,:) = squeeze(nanmean(sum(VVELTH.*DZ.*hFacS,3)));%%% Zonally averaged, depth-integrated 

% VVELSLT_zint(ne,:,:) = sum(VVELSLT.*DZ.*hFacS,3); %%% Depth-integrated 
% VVELSLT_zint_xavg(ne,:) = squeeze(nanmean(VVELSLT_zint(ne,:,:)));%%% Zonally averaged, depth-integrated 

% TFLUX_zint = sum(TFLUX.*DZ.*hFacC,3); %%% Depth-integrated 
% TFLUX_zavg = TFLUX_zint ./ sum(DZ.*hFacC,3); %%% Depth-averaged 
% TFLUX_xavg = TFLUX;
% TFLUX_xavg(TFLUX_xavg==0) = NaN;
% TFLUX_xavg = squeeze(nanmean(TFLUX_xavg));%%% Zonally averaged
% TFLUX_xzavg = squeeze(nanmean(TFLUX_zavg));%%% Depth-and-zonal-averaged
% 
% SFLUX_zint = sum(SFLUX.*DZ.*hFacC,3); %%% Depth-integrated 
% SFLUX_zavg = SFLUX_zint ./ sum(DZ.*hFacC,3); %%% Depth-averaged 
% SFLUX_xavg = SFLUX;
% SFLUX_xavg(SFLUX_xavg==0) = NaN;
% SFLUX_xavg = squeeze(nanmean(SFLUX_xavg));%%% Zonally averaged
% SFLUX_xzavg = squeeze(nanmean(SFLUX_zavg));%%% Depth-and-zonal-averaged
end

%%% Store computed data for later
save(fullfile(prodir,'Flux_zInteg_lores.mat'), ...
  'EXPNAME','VVELTH_zint','VVELTH_zint_xavg','xx','yy'); 
%   'EXPNAME','VVELTH_zint','VVELTH_zint_xavg','VVELSLT_zint','VVELSLT_zint_xavg','xx','yy'); 