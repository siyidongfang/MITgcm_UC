clear;


addpath /Users/csi/MITgcm_ASF-csi/utils/matlab; 
addpath /Users/csi/MITgcm_ASF-csi/analysis;
addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires;
addpath /Users/csi/MITgcm_ASF-csi/products-hires;

% expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments';
% expdir = '/home/csi/MITgcm_ASF-experiments';
% expdir = '/Volumes/si/MITgcm_ASF-csi/experiments/'

prodir = '/Volumes/si/MITgcm_ASF-csi/products-lores/'
figureloc = '/Users/csi/MITgcm_ASF-csi/cross_slope_exchange/figures_mixinglength/'

expdir = '/Volumes/si/MITgcm_ASF-csi/exps_lores/';



% EXPNAME = { ...
%   'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2'
% %   'ws3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws75_lores2' 
% %   'ws5_Ua-6Va6_Atide0.05_Hi0Ai0_Ws125_lores2'
% %   'res-ws1NewSuvice2_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores5'
% %   'res3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores10'
%   ...
%   ...
%   'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
%   'ssurf33.5868_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws25'
% %   'den02uniformS_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws2'
%   'sdiff2_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25' 
%   'sdiff2.5_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
%   'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
%   ...
%   ...
%   ...
%   'fresh02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
%   'fresh02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
% %   'fresh02-td4_atide0.075Umax1.5Ua-6Va6Hi1Ai1_2kmNr30Ws25'
% %   'fresh02-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
% %   'fresh02-td3umax2_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
%   'fresh02-td5_atide0.125Umax1.75Ua-6Va6Hi1Ai1_2kmNr30Ws25'
%   ...
%   'fresh02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
%   'fresh02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
%   'fresh02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
%   'fresh02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
%   ...
%   'fresh02-ice5_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Ws25-NewSuviceLWDOWN'
%   'fresh02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
%   'fresh02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
%   'fresh02-ice4_Hi1.8Ai1Ua-6Va6atide0.05_2kmNr30Ws25-NewSuviceLWDOWN'
%   ...
%   'fresh02-bumps4depth600-Hi1Ai1Ua-6Va6atide0.05_2kmNr30Ws25-NewSuvice'
%   'fresh02-bumps8depth300-Hi1Ai1Ua-6Va6atide0.05_2kmNr30Ws25-NewSuvice'
%   ...
%   ...
%   ...
%   'den02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
%   'den02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
%   'den02-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
%   ...
%   'den02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
%   'den02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
%   'den02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
%   'den02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
%   ...
%   'den02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
%   'den02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
%   ...
%   ...
%   ...
%   'dense-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
%   'dense_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
%   'dense-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
%   ...
%   'dense-wd2_Ua-4Va6Hi1Ai1atide0.05_2kmNr30Nly36Ws25'
%   'dense-wd3_Ua-8Va6Hi1Ai1atide0.05_2kmNr30Nly36Ws25'
%   'dense-wd4_Ua-6Va4Hi1Ai1atide0.05_2kmNr30Nly36Ws25'
%   ...
%   'dense-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
%   'dense-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
%   };





EXPNAME = {...
'den02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25' 
'den02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
'den02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
'den02-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
'den02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
'den02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
'den02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
'den02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
'den02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
'dense-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
'dense-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
'dense_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
'fresh02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
'fresh02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
'fresh02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
'fresh02-td3umax2_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
'fresh02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
'fresh02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
'fresh02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
'fresh02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
'sdiff2.5_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
'sdiff2_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
'ssurf33.5868_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws25'
'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2'};

% 'ws3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws75_lores2'
% 'ws5_Ua-6Va6_Atide0.05_Hi0Ai0_Ws125_lores2'
%%% Need to change hFacC for the two cases above!!!


% TMIN = [11*ones(1,9) 17 17 16 12 11 11 11 15 11*ones(1,15)];
% TMAX = [15*ones(1,9) 21 21 21 16 15 15 15 19 15*ones(1,15)];
% WS = [25 75 125 25*ones(1,29)]*1000;
% YS = [150 200 250 150*ones(1,29)]*1000;


% EXPNAME = { ...
% %   'ws3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws75_lores2',...  
% %   'ws5_Ua-6Va6_Atide0.05_Hi0Ai0_Ws125_lores2',... 
%   ...
%   'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',...
%   'ssurf33.5868_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws25',...
%   'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2',... 
%   'den02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
%   'sdiff2_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',... 
%   'sdiff2.5_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',... 
%   'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'... 
%   };

% WS = [75 125 25*ones(1,7)]*1000;
% YS = [200 250 150*ones(1,7)]*1000;
WS = 25*ones(1,40).*1000;
YS = 150*ones(1,40).*1000;

Nexp=length(EXPNAME);

for ne =1:Nexp
expname = EXPNAME{ne}
[betat_test(ne),betat(ne),h_cdw_slopeavg(ne),dhcdwdy_slopeavg(ne),Fcdw_simulation(ne),...
    Aslope_test(ne),EKE_slope_total_test(ne),tidalEKE_slope_test(ne),EKE_slope_test(ne),Ueddy_test(ne),ls(ne),lRh_test(ne),ks_test(ne),kRh_test(ne),Fcdw_test_s(ne),Fcdw_test_Rh(ne),...
    Aslope(ne),EKE_slope_total(ne),tidalEKE_slope(ne),EKE_slope(ne),Ueddy_theory(ne),lRh(ne),ks(ne),kRh(ne),Fcdw_theory_s(ne),Fcdw_theory_Rh(ne)]...
    = calcFcdw_MixingLength(expdir,expname,prodir,WS(ne),YS(ne));
end


%%% Store computed data for later
save(fullfile(prodir,['calcFcdw_MixingLength_-0.5degC.mat']), ...
    'EXPNAME','WS','YS','betat','betat_test',...
    'h_cdw_slopeavg','dhcdwdy_slopeavg','Fcdw_simulation',...
    'Aslope_test','EKE_slope_total_test','tidalEKE_slope_test','EKE_slope_test','Ueddy_test','ls','lRh_test','ks_test','kRh_test','Fcdw_test_s','Fcdw_test_Rh',...
    'Aslope','EKE_slope_total','tidalEKE_slope','EKE_slope','Ueddy_theory','lRh','ks','kRh','Fcdw_theory_s','Fcdw_theory_Rh');

