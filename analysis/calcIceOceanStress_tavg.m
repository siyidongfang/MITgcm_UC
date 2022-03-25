%%%
%%% calcIceOceanStress_tavg.m
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
  'dense-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25');

%%% For ice-ocean stress calculation
C_io = 5.5399/1000;          %%% Ice-ocean drag coefficient, dimensionless
rho_o = 1027;                %%% Water density, kg/m^3
Rio = 0; %%% SEAICE_waterTurnAngle


ne = 1
expname = strtrim(EXPNAME(ne,:))
loadexp;

tao_iox = zeros(size(EXPNAME,1),Nx,Ny);
tao_ioy = zeros(size(EXPNAME,1),Nx,Ny);

tao_iox_xavg = zeros(size(EXPNAME,1),Ny);
tao_ioy_xavg = zeros(size(EXPNAME,1),Ny);
SIuice_xavg = zeros(size(EXPNAME,1),Ny);
SIvice_xavg = zeros(size(EXPNAME,1),Ny);
Uo_surf_xavg = zeros(size(EXPNAME,1),Ny);
Vo_surf_xavg = zeros(size(EXPNAME,1),Ny);

tao_iox_avg = zeros(size(EXPNAME,1),1);
tao_ioy_avg = zeros(size(EXPNAME,1),1);
SIuice_avg = zeros(size(EXPNAME,1),1);
SIvice_avg = zeros(size(EXPNAME,1),1);
Uo_surf_avg = zeros(size(EXPNAME,1),1);
Vo_surf_avg = zeros(size(EXPNAME,1),1);

for ne = 1:size(EXPNAME,1)
    
expname = strtrim(EXPNAME(ne,:))
loadexp;
load([exppath '/' expname '_tavg_5yrs.mat']);

%%% Calculate the ice-ocean stress
%%% Note: correct only when ice-ocean turning angle = 0.
% Ai = squeeze(SIarea(:,:,1));
% ui = squeeze(SIuice(:,:,1));
% vi = squeeze(SIvice(:,:,1));
% uo = squeeze(UVEL(:,:,1));
% vo = squeeze(VVEL(:,:,1));
% absvol = sqrt((ui-uo).^2+(vi-vo).^2);
% tao_iox(ne,:,:) = Ai.*C_io*rho_o.*absvol.*(ui-uo);   %%% Ice-ocean stress in x direction, N/m2
% tao_ioy(ne,:,:) = Ai.*C_io*rho_o.*absvol.*(vi-vo);   %%% Ice-ocean stress in y direction, N/m2


tao_iox(ne,:,:) = oceTAUX;   %%% Ice-ocean stress in x direction, N/m2
tao_ioy(ne,:,:) = oceTAUY;  

tao_iox_xavg(ne,:) = squeeze(nanmean(tao_iox(ne,:,:)));%%% Zonal average
tao_ioy_xavg(ne,:) = squeeze(nanmean(tao_ioy(ne,:,:)));
SIuice_xavg(ne,:) = nanmean(SIuice(:,:,1),1);
SIvice_xavg(ne,:) = nanmean(SIvice(:,:,1),1);
Uo_surf_xavg(ne,:) = nanmean(UVEL(:,:,1),1);
Vo_surf_xavg(ne,:) = nanmean(VVEL(:,:,1),1);

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

absvolb = sqrt(uobot.^2+vobot.^2);

tau_bx = C_d*rho_o.*absvolb.*uobot; % estimated bottom stress in x direction
tau_by = C_d*rho_o.*absvolb.*vobot; 

tau_bx_xavg(ne,:) = nanmean(tau_bx,1);
tau_by_xavg(ne,:) = nanmean(tau_by,1);

Uo_bot_xavg(ne,:) = nanmean(uobot(:,:),1);
Vo_bot_xavg(ne,:) = nanmean(vobot(:,:),1);

tao_iox_avg = nanmean(tao_iox_xavg(ne,2:end-1),'all');%%% Domain-averaged, not include southern and northern boundaries
tao_ioy_avg = nanmean(tao_ioy_xavg(ne,2:end-1),'all');
tau_bx_avg = nanmean(tau_bx_xavg(ne,2:end-1),'all');
tau_by_avg = nanmean(tau_by_xavg(ne,2:end-1),'all');

SIuice_avg = nanmean(SIuice_xavg(ne,2:end-1),'all');
SIvice_avg = nanmean(SIvice_xavg(ne,2:end-1),'all');
Uo_surf_avg = nanmean(Uo_surf_xavg(ne,2:end-1),'all');
Vo_surf_avg = nanmean(Vo_surf_xavg(ne,2:end-1),'all');
Uo_bot_avg = nanmean(Uo_bot_xavg(ne,2:end-1),'all');
Vo_bot_avg = nanmean(Vo_bot_xavg(ne,2:end-1),'all');

end

%%% Store computed data for later
save([expdir '/data_poster/ice-ocn-stress.mat'],'EXPNAME','C_io','Rio','xx','yy',...
    'tao_iox_xavg','tao_iox_avg',...
    'tao_ioy_xavg','tao_ioy_avg',...
    'tau_bx_xavg','tau_bx_avg',...
    'tau_by_xavg','tau_by_avg',...
    'SIuice_xavg','SIuice_avg',...
    'SIvice_xavg','SIvice_avg',...
    'Uo_surf_xavg','Uo_surf_avg',...
    'Vo_surf_xavg','Vo_surf_avg'...
    );

