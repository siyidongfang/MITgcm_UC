%%%
%%% calcMomScalingMatrix.m
%%%
%%% Calculate and plot the scaling matrix of ice-ocean momentum budget 

%%% TODO:
%   'res-ws1NewSuvice2_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores5' 
%   'res3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores10'...   



clear all; close all

basedir = '/Users/csi/MITgcm_ASF-csi/analysis/';
addpath /Users/csi/MITgcm_ASF-csi/utils/matlab; 
addpath /Users/csi/MITgcm_ASF-csi/analysis;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps;

expdir = '/Users/csi/MITgcm_ASF-csi/experiments';
prodir = '/Volumes/si/MITgcm_ASF-csi/products-hires'

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
buoy = [33 33.59 34.17 34.38 34.59 34.69 34.79]-34.17; 

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



fontsize = 15;

imgname = 'scalingMatrix';

m1km = 1000;
dely = 1*m1km;

Ymin = [50 100 200]*m1km;
Ymax = [100 200 300]*m1km;
nymin = Ymin/dely+1; 
nymax = Ymax/dely;   

Lx = 400*m1km;
Ly = 450*m1km;
Ny = 448;
dy = Ly/Ny;  




load([prodir '/MomScalingMatrix_slope_ystart125km.mat'])
EXPNAME{30}='hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod';



%%
% for ne = [1:nExp]
 for ne = 30:30
expname = EXPNAME{ne}
calcMomBudget_ice_xint;
calcMomBudgetFromTendency_xint;

  yend = ystart(ne) + sloperange(ne);
  ymin = round(ystart(ne)/dy);
  ymax = round(yend/dy);
  yidx = ymin:ymax;
  AREA_slope = Lx*(yy(ymax)-yy(ymin))
  
   
    % Wind stress, N
    Windstress(ne) = sum(TAUai_xint(yidx).*delY(yidx))./AREA_slope;
    % Ice internal stress
    SIinternal(ne) = sum(internal_xint(yidx).*delY(yidx))./AREA_slope;
    % Topog. form stress
    Topogform(ne) = sum(Um_dPhiX_xzint(yidx).*delY(yidx))./AREA_slope;
    % Dissipation
    Dissipation(ne) = sum(Um_Diss_xzint(yidx).*delY(yidx))./AREA_slope;
    % Ocean Advection 
    OCN_AdvCor(ne) = sum(Um_Advec_xzint(yidx).*delY(yidx))./AREA_slope;
    % Ice coriolis force
    SI_cor(ne) = sum(coriolisforce(yidx).*delY(yidx))./AREA_slope;
 
%     RESIDUAL(ne) = -(Windstress(ne)+SIinternal(ne)+Topogform(ne)+Dissipation(ne)...
%         +OCN_AdvCor(ne)+SI_cor(ne))./AREA_slope;%%%??????? ERROR

    % Ice-ocean stress
    TAUoi(ne) = sum(TAUoi_xint(yidx).*delY(yidx))./AREA_slope;

    % partition
    pSIinternal(ne) = SIinternal(ne)/Windstress(ne);
    pTopogform(ne) = Topogform(ne)/Windstress(ne);
    pDissipation(ne) = Dissipation(ne)/Windstress(ne);
    pOCN_AdvCor(ne) = OCN_AdvCor(ne)/Windstress(ne);
    pSI_cor(ne) = SI_cor(ne)/Windstress(ne);
%     pRESIDUAL(ne) = RESIDUAL(ne)/Windstress(ne);

    pTAUoi(ne) = TAUoi(ne)/Windstress(ne);
    pWindstress(ne) = Windstress(ne)/Windstress(ne);


end

% % %%
% % load('/data/MITgcm_ASF-csi/products-hires/MomScalingMatrix_slope_ystart125km.mat')
% % for ne = 6:9
% % expname = EXPNAME{ne}
% % 
% %     % partition
% %     pSIinternal(ne) = SIinternal(ne)/(Windstress(ne)+OCN_AdvCor(ne));
% %     pTopogform(ne) = Topogform(ne)/(Windstress(ne)+OCN_AdvCor(ne));
% %     pDissipation(ne) = Dissipation(ne)/(Windstress(ne)+OCN_AdvCor(ne));
% %     pOCN_AdvCor(ne) = OCN_AdvCor(ne)/(Windstress(ne)+OCN_AdvCor(ne));
% %     pSI_cor(ne) = SI_cor(ne)/(Windstress(ne)+OCN_AdvCor(ne));
% % 
% %     pTAUoi(ne) = TAUoi(ne)/(Windstress(ne)+OCN_AdvCor(ne));
% %     pWindstress(ne) = Windstress(ne)/(Windstress(ne)+OCN_AdvCor(ne));
% % 
% % end

%%


save([prodir '/MomScalingMatrix_slope_ystart125km_new.mat'],'EXPNAME',...
    'Windstress','SIinternal','Topogform','Dissipation',...
    'OCN_AdvCor','SI_cor','TAUoi',...
           'pSIinternal','pTopogform','pDissipation',...
           'pWindstress','pOCN_AdvCor','pSI_cor','pTAUoi')


