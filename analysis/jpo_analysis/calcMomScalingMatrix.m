%%%
%%% calcMomScalingMatrix.m
%%%
%%% Calculate and plot the scaling matrix of ice-ocean momentum budget 

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

expnames = { ...
  'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2'
  
  'fresh02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
  'fresh02-td4_atide0.075Umax1.5Ua-6Va6Hi1Ai1_2kmNr30Ws25'
  'fresh02-td3umax2_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
    
  'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
  'ssurf33.5868_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws25' 
  'sdiff2_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
  'sdiff2.5_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
  'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
  
  'ws3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws75_lores2' 
  'ws5_Ua-6Va6_Atide0.05_Hi0Ai0_Ws125_lores2'
  
  'fresh02-bumps4depth600-Hi1Ai1Ua-6Va6atide0.05_2kmNr30Ws25-NewSuvice'
  'fresh02-bumps8depth300-Hi1Ai1Ua-6Va6atide0.05_2kmNr30Ws25-NewSuvice'
  
  'den02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'

  'fresh02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
  'fresh02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
  
  'fresh02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  'fresh02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  'fresh02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25'  
  'fresh02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
};


      
Nexp = length(expnames);
fontsize = 15;

imgname = 'scalingMatrix';

m1km = 1000;
Ys = 150*m1km; % Slope position
dely = 2*m1km;

Ymin = [50 100 200]*m1km;
Ymax = [100 200 300]*m1km;
nymin = Ymin/dely+1; 
nymax = Ymax/dely;   

Lx = 400*m1km;
AREA = Lx*(Ymax-Ymin);



for n=[1:9 12 13]
expname = expnames{n}
calcMomBudget_ice_xint;
calcMomBudgetFromTendency_xint;

    for j = 1:3
    % Wind stress, N
    Windstress(n,j) = sum(TAUai_xint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Ice internal stress
    SIinternal(n,j) = sum(iceResidual(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Topog. form stress
    Topogform(n,j) = sum(Um_dPhiX_xzint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Dissipation
    Dissipation(n,j) = sum(Um_Diss_xzint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Ocean Advection 
    OCN_AdvCor(n,j) = sum(Um_Advec_xzint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Ice coriolis force
    SI_cor(n,j) = sum(coriolisforce(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));

    RESIDUAL(n,j) = -(Windstress(n,j)+SIinternal(n,j)+Topogform(n,j)+Dissipation(n,j)...
        +OCN_AdvCor(n,j)+SI_cor(n,j))./(AREA(j));

    % Ice-ocean stress
    TAUoi(n,j) = sum(TAUoi_xint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));

    % partition
    pSIinternal(n,j) = SIinternal(n,j)/Windstress(n,j);
    pTopogform(n,j) = Topogform(n,j)/Windstress(n,j);
    pDissipation(n,j) = Dissipation(n,j)/Windstress(n,j);
    pOCN_AdvCor(n,j) = OCN_AdvCor(n,j)/Windstress(n,j);
    pSI_cor(n,j) = SI_cor(n,j)/Windstress(n,j);
    pRESIDUAL(n,j) = RESIDUAL(n,j)/Windstress(n,j);

    pTAUoi(n,j) = TAUoi(n,j)/Windstress(n,j);

    end

end



for n=Nexp-6:Nexp
expname = expnames{n}
calcMomBudget_ice_xint_noOCETAUX;
calcMomBudgetFromTendency_xint;

    for j = 1:3
    % Wind stress, calculated from wind speed
    Windstress(n,j) = sum(windStress_xint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Ice internal stress
    SIinternal(n,j) = sum(iceResidual(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Topog. form stress
    Topogform(n,j) = sum(Um_dPhiX_xzint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Dissipation
    Dissipation(n,j) = sum(Um_Diss_xzint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Ocean Advection 
    OCN_AdvCor(n,j) = sum(Um_Advec_xzint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Ice coriolis force
    SI_cor(n,j) = sum(coriolisforce(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));

    RESIDUAL(n,j) = -(Windstress(n,j)+SIinternal(n,j)+Topogform(n,j)+Dissipation(n,j)...
        +OCN_AdvCor(n,j)+SI_cor(n,j))./(AREA(j));

    % Ice-ocean stress, calculated from ocean external stress
    TAUoi(n,j) = -sum(Um_Ext_xzint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));

    % partition
    pSIinternal(n,j) = SIinternal(n,j)/Windstress(n,j);
    pTopogform(n,j) = Topogform(n,j)/Windstress(n,j);
    pDissipation(n,j) = Dissipation(n,j)/Windstress(n,j);
    pOCN_AdvCor(n,j) = OCN_AdvCor(n,j)/Windstress(n,j);
    pSI_cor(n,j) = SI_cor(n,j)/Windstress(n,j);
    pRESIDUAL(n,j) = RESIDUAL(n,j)/Windstress(n,j);

    pTAUoi(n,j) = TAUoi(n,j)/Windstress(n,j);

    end

end


%%

for n=10:10
    
Ys = 200*m1km; % Slope position
Ymin = [50 125 200]*m1km;
Ymax = [100 275 300]*m1km;
nymin = Ymin/dely+1; 
nymax = Ymax/dely;   
AREA = Lx*(Ymax-Ymin);


expname = expnames{n}
calcMomBudget_ice_xint;
calcMomBudgetFromTendency_xint;

    for j = 1:3
    % Wind stress, N
    Windstress(n,j) = sum(TAUai_xint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Ice internal stress
    SIinternal(n,j) = sum(iceResidual(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Topog. form stress
    Topogform(n,j) = sum(Um_dPhiX_xzint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Dissipation
    Dissipation(n,j) = sum(Um_Diss_xzint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Ocean Advection 
    OCN_AdvCor(n,j) = sum(Um_Advec_xzint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Ice coriolis force
    SI_cor(n,j) = sum(coriolisforce(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));

    RESIDUAL(n,j) = -(Windstress(n,j)+SIinternal(n,j)+Topogform(n,j)+Dissipation(n,j)...
        +OCN_AdvCor(n,j)+SI_cor(n,j))./(AREA(j));

    % Ice-ocean stress
    TAUoi(n,j) = sum(TAUoi_xint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));

    % partition
    pSIinternal(n,j) = SIinternal(n,j)/Windstress(n,j);
    pTopogform(n,j) = Topogform(n,j)/Windstress(n,j);
    pDissipation(n,j) = Dissipation(n,j)/Windstress(n,j);
    pOCN_AdvCor(n,j) = OCN_AdvCor(n,j)/Windstress(n,j);
    pSI_cor(n,j) = SI_cor(n,j)/Windstress(n,j);
    pRESIDUAL(n,j) = RESIDUAL(n,j)/Windstress(n,j);

    pTAUoi(n,j) = TAUoi(n,j)/Windstress(n,j);

    end

end



for n=11:11
    
Ys = 250*m1km; % Slope position
Ymin = [50 125 200]*m1km;
Ymax = [100 375 450]*m1km;
nymin = Ymin/dely+1; 
nymax = Ymax/dely;   
AREA = Lx*(Ymax-Ymin);

expname = expnames{n}
calcMomBudget_ice_xint;
calcMomBudgetFromTendency_xint;

    for j = 1:3
    % Wind stress, N
    Windstress(n,j) = sum(TAUai_xint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Ice internal stress
    SIinternal(n,j) = sum(iceResidual(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Topog. form stress
    Topogform(n,j) = sum(Um_dPhiX_xzint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Dissipation
    Dissipation(n,j) = sum(Um_Diss_xzint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Ocean Advection 
    OCN_AdvCor(n,j) = sum(Um_Advec_xzint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));
    % Ice coriolis force
    SI_cor(n,j) = sum(coriolisforce(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));

    RESIDUAL(n,j) = -(Windstress(n,j)+SIinternal(n,j)+Topogform(n,j)+Dissipation(n,j)...
        +OCN_AdvCor(n,j)+SI_cor(n,j))./(AREA(j));

    % Ice-ocean stress
    TAUoi(n,j) = sum(TAUoi_xint(nymin(j):nymax(j)).*delY(nymin(j):nymax(j)))./(AREA(j));

    % partition
    pSIinternal(n,j) = SIinternal(n,j)/Windstress(n,j);
    pTopogform(n,j) = Topogform(n,j)/Windstress(n,j);
    pDissipation(n,j) = Dissipation(n,j)/Windstress(n,j);
    pOCN_AdvCor(n,j) = OCN_AdvCor(n,j)/Windstress(n,j);
    pSI_cor(n,j) = SI_cor(n,j)/Windstress(n,j);
    pRESIDUAL(n,j) = RESIDUAL(n,j)/Windstress(n,j);

    pTAUoi(n,j) = TAUoi(n,j)/Windstress(n,j);

    end

end



save([prodir '/scalingMatrix/MomScalingMatrix_ws.mat'],'expnames',...
    'Windstress','SIinternal','Topogform','Dissipation',...
    'OCN_AdvCor','SI_cor','RESIDUAL','TAUoi',...
           'pSIinternal','pTopogform','pDissipation',...
           'pOCN_AdvCor','pSI_cor','pRESIDUAL','pTAUoi')


