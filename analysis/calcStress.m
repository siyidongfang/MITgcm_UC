%%%
%%% calcStress.m
%%%
%%% Script to calculate the ice-ocean stress using 5-year averaged output.
%%%
clear all;

basedir = '/data/MITgcm_ASF-csi/newexp/analysis_new/';
addpath /data/MITgcm_ASF-csi/utils/matlab; 
addpath /data/MITgcm_ASF-csi/newexp/analysis;
expdir = '/data/MITgcm_ASF-csi/newexp/';

EXPNAME = char('fresh02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-td3umax2_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  'fresh02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  ...
  'den02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
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
  'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',...
  'sdiff2_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',... 
  'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25');

%%% For ice-ocean stress calculation
C_io = 5.5399/1000;          %%% Ice-ocean drag coefficient, dimensionless
C_d = 2e-3;   %%% 'bottomDragQuadratic',2e-3
rho_o = 1027;                %%% Water density, kg/m^3
Rio = 0; %%% SEAICE_waterTurnAngle

ne = 1
expname = strtrim(EXPNAME(ne,:))
loadexp;


%%% Grid spacing matrices
DX = repmat(delX',[1 Ny Nr]);
DY = repmat(delY,[Nx 1 Nr]);
DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
DZC = repmat(reshape(-diff(zz),[1 1 Nr-1]),[Nx Ny 1]);

%%% Mesh grids for plotting
[YY,XX] = meshgrid(yy/1000,xx/1000);


for ne = 1:size(EXPNAME,1)
% for ne = [1]
    
expname = strtrim(EXPNAME(ne,:))
loadexp
load([exppath '/' expname '_tavg_5yrs.mat']);

%%% Surface wind stress over Ocean+SeaIce
SIatmTx_xavg(ne,:) = nanmean(SIatmTx(:,:,1));
SIatmTy_xavg(ne,:) = nanmean(SIatmTy(:,:,1));

%%% Ice-ocean stress
oceTAUX_xavg(ne,:) = nanmean(oceTAUX(:,:,1));
oceTAUY_xavg(ne,:) = nanmean(oceTAUY(:,:,1));

%%% Momentum tendency
Um_Diss_zint(ne,:,:) = sum(Um_Diss.*DZ.*hFacW,3); %%% Depth-integrated 
Vm_Diss_zint(ne,:,:) = sum(Um_Diss.*DZ.*hFacW,3); 
Um_Advec_zint(ne,:,:) = sum(Um_Advec.*DZ.*hFacW,3); 
Vm_Advec_zint(ne,:,:) = sum(Vm_Advec.*DZ.*hFacW,3); 
Um_Cori_zint(ne,:,:) = sum(Um_Cori.*DZ.*hFacW,3); 
Vm_Cori_zint(ne,:,:) = sum(Vm_Cori.*DZ.*hFacW,3); 
Um_dPhiX_zint(ne,:,:) = sum(Um_dPhiX.*DZ.*hFacW,3); 
Vm_dPhiY_zint(ne,:,:) = sum(Vm_dPhiY.*DZ.*hFacW,3); 
Um_Ext_zint(ne,:,:) = sum(Um_Ext.*DZ.*hFacW,3); 
Vm_Ext_zint(ne,:,:) = sum(Vm_Ext.*DZ.*hFacW,3); 
Um_AdvZ3_zint(ne,:,:) = sum(Um_AdvZ3.*DZ.*hFacW,3); 
Vm_AdvZ3_zint(ne,:,:) = sum(Vm_AdvZ3.*DZ.*hFacW,3); 
Um_AdvRe_zint(ne,:,:) = sum(Um_AdvRe.*DZ.*hFacW,3); 
Vm_AdvRe_zint(ne,:,:) = sum(Vm_AdvRe.*DZ.*hFacW,3); 

Um_Diss_zint_xavg(ne,:) = squeeze(nanmean(Um_Diss_zint(ne,:,:)));%%% Zonally averaged, depth-integrated 
Vm_Diss_zint_xavg(ne,:) = squeeze(nanmean(Vm_Diss_zint(ne,:,:)));
Um_Advec_zint_xavg(ne,:) = squeeze(nanmean(Um_Advec_zint(ne,:,:)));
Vm_Advec_zint_xavg(ne,:) = squeeze(nanmean(Vm_Advec_zint(ne,:,:)));
Um_Cori_zint_xavg(ne,:) = squeeze(nanmean(Um_Cori_zint(ne,:,:)));
Vm_Cori_zint_xavg(ne,:) = squeeze(nanmean(Vm_Cori_zint(ne,:,:)));
Um_dPhiX_zint_xavg(ne,:) = squeeze(nanmean(Um_dPhiX_zint(ne,:,:)));
Vm_dPhiY_zint_xavg(ne,:) = squeeze(nanmean(Vm_dPhiY_zint(ne,:,:)));
Um_Ext_zint_xavg(ne,:) = squeeze(nanmean(Um_Ext_zint(ne,:,:)));
Vm_Ext_zint_xavg(ne,:) = squeeze(nanmean(Vm_Ext_zint(ne,:,:)));
Um_AdvZ3_zint_xavg(ne,:) = squeeze(nanmean(Um_AdvZ3_zint(ne,:,:)));
Vm_AdvZ3_zint_xavg(ne,:) = squeeze(nanmean(Vm_AdvZ3_zint(ne,:,:)));
Um_AdvRe_zint_xavg(ne,:) = squeeze(nanmean(Um_AdvRe_zint(ne,:,:)));
Vm_AdvRe_zint_xavg(ne,:) = squeeze(nanmean(Vm_AdvRe_zint(ne,:,:)));

%%% Estimated Ocean bottom drag
for i = 1:size(UVEL,1)
    for j = 2:size(UVEL,2)-1
        n_bot = UVEL(i,j,:)~=0;
        idx_bot(i,j) = sum(n_bot);
        uobot(i,j) = squeeze(UVEL(i,j,idx_bot(i,j)));
        vobot(i,j) = squeeze(VVEL(i,j,idx_bot(i,j)));
    end
    uobot(i,225) = 0;
    vobot(i,225) = 0;
end

vobot(2:Nx,:) = (vobot(1:Nx-1,:)+vobot(2:Nx,:))/2;
vobot(1,:) = (vobot(1,:)+vobot(Nx,:))/2;

absvolb = sqrt(uobot.^2+vobot.^2);
tau_bx = C_d*rho_o.*absvolb.*uobot; % estimated bottom stress in x direction
tau_by = C_d*rho_o.*absvolb.*vobot; 
tau_bx_xavg(ne,:) = nanmean(tau_bx);
tau_by_xavg(ne,:) = nanmean(tau_by);

%%% Vertical integrated and zonally averaged Divergence of lateral eddy momentum flux
%%% Compute eddy terms
uvel(:,2:Ny,:) = (UVEL(:,1:Ny-1,:)+ UVEL(:,2:Ny,:))/2; % c-grid location: vorticity
uvel(:,1,:) = 0;
vvel(2:Nx,:,:) = (VVEL(1:Nx-1,:,:)+ VVEL(2:Nx,:,:))/2; % c-grid location: vorticity
vvel(1,:,:) = (VVEL(1,:,:)+VVEL(Nx,:,:))/2;
uv_eddy =  UV_VEL_Z - uvel.*vvel; % c-grid location: vorticity
%%% Is this correct???
hFac_uv = (hFacS+hFacW)/2;
%%% d(uv_eddy)/dy
DuveddyDy_zint(ne,:,:) = sum((uv_eddy./DY).*DZ.*hFac_uv,3); 
DuveddyDy_zint_xavg(ne,:) = nanmean(DuveddyDy_zint(ne,:,:),2);

end


%%% Store computed data for later
save([expdir '/data_poster/stress2.mat'],'EXPNAME','C_io','C_d','Rio','xx','yy',...
    'SIatmTx_xavg','SIatmTy_xavg','oceTAUX_xavg','oceTAUY_xavg',...
    'tau_bx_xavg','tau_by_xavg','Um_Diss_zint_xavg','Vm_Diss_zint_xavg',...
    'Um_Advec_zint_xavg','Vm_Advec_zint_xavg','Um_Cori_zint_xavg','Vm_Cori_zint_xavg',...
    'Um_dPhiX_zint_xavg','Vm_dPhiY_zint_xavg','Um_Ext_zint_xavg','Vm_Ext_zint_xavg',...
    'Um_AdvZ3_zint_xavg','Vm_AdvZ3_zint_xavg','Um_AdvRe_zint_xavg','Vm_AdvRe_zint_xavg',...
    'DuveddyDy_zint_xavg');

