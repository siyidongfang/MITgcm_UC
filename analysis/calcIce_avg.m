%%%
%%% calcIce_avg.m
%%%
%%% Calculate the zonally averaged and domain-averaged ice properties
%%%

clear all;
basedir = '/data/MITgcm_ASF-csi/newexp/analysis_new/';
addpath /data/MITgcm_ASF-csi/utils/matlab; 
addpath /data/MITgcm_ASF-csi/newexp/analysis;
expdir = '/data/MITgcm_ASF-csi/newexp/';
imgname = 'img_poster';

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

 
SIheff_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIarea_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIpress_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIzeta_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIeta_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIsig1_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIsig2_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIshear_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIdelta_xavg = zeros(size(EXPNAME,1),size(yy,2));
SItensil_xavg = zeros(size(EXPNAME,1),size(yy,2));
oceTAUX_xavg = zeros(size(EXPNAME,1),size(yy,2));
oceTAUY_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIempmr_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIqnet_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIatmQnt_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIareaPR_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIareaPT_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIheffPT_xavg = zeros(size(EXPNAME,1),size(yy,2));
ADVxHEFF_xavg = zeros(size(EXPNAME,1),size(yy,2));
ADVyHEFF_xavg = zeros(size(EXPNAME,1),size(yy,2));

SIdHbATC_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIdHbOCN_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIdHbATO_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIhsnow_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIhsalt_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIuice_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIvice_xavg = zeros(size(EXPNAME,1),size(yy,2));
SItaux_xavg = zeros(size(EXPNAME,1),size(yy,2));
SItauy_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIatmTx_xavg = zeros(size(EXPNAME,1),size(yy,2));
SIatmTy_xavg = zeros(size(EXPNAME,1),size(yy,2));
SItices_xavg = zeros(size(EXPNAME,1),size(yy,2));



SIheff_avg = zeros(size(EXPNAME,1),1);
SIarea_avg = zeros(size(EXPNAME,1),1);
SIpress_avg = zeros(size(EXPNAME,1),1);
SIzeta_avg = zeros(size(EXPNAME,1),1);
SIeta_avg = zeros(size(EXPNAME,1),1);
SIsig1_avg = zeros(size(EXPNAME,1),1);
SIsig2_avg = zeros(size(EXPNAME,1),1);
SIshear_avg = zeros(size(EXPNAME,1),1);
SIdelta_avg = zeros(size(EXPNAME,1),1);
SItensil_avg = zeros(size(EXPNAME,1),1);
oceTAUX_avg = zeros(size(EXPNAME,1),1);
oceTAUY_avg = zeros(size(EXPNAME,1),1);
SIempmr_avg = zeros(size(EXPNAME,1),1);
SIqnet_avg = zeros(size(EXPNAME,1),1);
SIatmQnt_avg = zeros(size(EXPNAME,1),1);
% SIfwSubl
SIareaPR_avg = zeros(size(EXPNAME,1),1);
SIareaPT_avg = zeros(size(EXPNAME,1),1);
SIheffPT_avg = zeros(size(EXPNAME,1),1);
ADVxHEFF_avg = zeros(size(EXPNAME,1),1);
ADVyHEFF_avg = zeros(size(EXPNAME,1),1);
SIdHbATC_avg = zeros(size(EXPNAME,1),1);
SIdHbOCN_avg = zeros(size(EXPNAME,1),1);
SIdHbATO_avg = zeros(size(EXPNAME,1),1);

SIdHbATC_avg = zeros(size(EXPNAME,1),1);
SIdHbOCN_avg = zeros(size(EXPNAME,1),1);
SIdHbATO_avg = zeros(size(EXPNAME,1),1);
SIhsnow_avg = zeros(size(EXPNAME,1),1);
SIhsalt_avg = zeros(size(EXPNAME,1),1);
SIuice_avg = zeros(size(EXPNAME,1),1);
SIvice_avg = zeros(size(EXPNAME,1),1);
SItaux_avg = zeros(size(EXPNAME,1),1);
SItauy_avg = zeros(size(EXPNAME,1),1);
SIatmTx_avg = zeros(size(EXPNAME,1),1);
SIatmTy_avg = zeros(size(EXPNAME,1),1);
SItices_avg = zeros(size(EXPNAME,1),1);

         
for ne = 1:size(EXPNAME,1)

expname = strtrim(EXPNAME(ne,:))
loadexp;
load([exppath '/' expname '_tavg_5yrs.mat']);



SIheff_xavg(ne,:) = nanmean(SIheff(:,:,1),1);%%% Zonal average
SIarea_xavg(ne,:) = nanmean(SIarea(:,:,1),1);
SIpress_xavg(ne,:) = nanmean(SIpress(:,:,1),1);
SIzeta_xavg(ne,:) = nanmean(SIzeta(:,:,1),1);
SIeta_xavg(ne,:) = nanmean(SIeta(:,:,1),1);
SIsig1_xavg(ne,:) = nanmean(SIsig1(:,:,1),1);
SIsig2_xavg(ne,:) = nanmean(SIsig2(:,:,1),1);
SIshear_xavg(ne,:) = nanmean(SIshear(:,:,1),1);
SIdelta_xavg(ne,:) = nanmean(SIdelta(:,:,1),1);
SItensil_xavg(ne,:) = nanmean(SItensil(:,:,1),1);
% oceTAUX_xavg(ne,:) = nanmean(oceTAUX(:,:,1),1);
% oceTAUY_xavg(ne,:) = nanmean(oceTAUY(:,:,1),1);
SIempmr_xavg(ne,:) = nanmean(SIempmr(:,:,1),1);
SIqnet_xavg(ne,:) = nanmean(SIqnet(:,:,1),1);
SIatmQnt_xavg(ne,:) = nanmean(SIatmQnt(:,:,1),1);
SIareaPR_xavg(ne,:) = nanmean(SIareaPR(:,:,1),1);
SIareaPT_xavg(ne,:) = nanmean(SIareaPT(:,:,1),1);
SIheffPT_xavg(ne,:) = nanmean(SIheffPT(:,:,1),1);
% ADVxHEFF_xavg(ne,:) = nanmean(ADVxHEFF(:,:,1),1);
% ADVyHEFF_xavg(ne,:) = nanmean(ADVyHEFF(:,:,1),1);
SIdHbATC_xavg(ne,:) = nanmean(SIdHbATC(:,:,1),1);
SIdHbOCN_xavg(ne,:) = nanmean(SIdHbOCN(:,:,1),1);
% SIdHbATO_xavg(ne,:) = nanmean(SIdHbATO(:,:,1),1);
SIhsnow_xavg(ne,:) = nanmean(SIhsnow(:,:,1),1);
SIhsalt_xavg(ne,:) = nanmean(SIhsalt(:,:,1),1);
SIuice_xavg(ne,:) = nanmean(SIuice(:,:,1),1);
SIvice_xavg(ne,:) = nanmean(SIvice(:,:,1),1);
% SItaux_xavg(ne,:) = nanmean(SItaux(:,:,1),1);
% SItauy_xavg(ne,:) = nanmean(SItauy(:,:,1),1);
% SIatmTx_xavg(ne,:) = nanmean(SIatmTx(:,:,1),1);
% SIatmTy_xavg(ne,:) = nanmean(SIatmTy(:,:,1),1);
SItices_xavg(ne,:) = nanmean(SItices(:,:,1),1);


SIheff_avg(ne) = nanmean(SIheff_xavg(ne,2:end-1),'all');%%% Domain-averaged
SIarea_avg(ne) = nanmean(SIarea_xavg(ne,2:end-1),'all');
SIpress_avg(ne) = nanmean(SIpress_xavg(ne,2:end-1),'all');
SIzeta_avg(ne) = nanmean(SIzeta_xavg(ne,2:end-1),'all');
SIeta_avg(ne) = nanmean(SIeta_xavg(ne,2:end-1),'all');
SIsig1_avg(ne) = nanmean(SIsig1_xavg(ne,2:end-1),'all');
SIsig2_avg(ne) = nanmean(SIsig2_xavg(ne,2:end-1),'all');
SIshear_avg(ne) = nanmean(SIshear_xavg(ne,2:end-1),'all');
SIdelta_avg(ne) = nanmean(SIdelta_xavg(ne,2:end-1),'all');
SItensil_avg(ne) = nanmean(SItensil_xavg(ne,2:end-1),'all');
% oceTAUX_avg(ne) = nanmean(oceTAUX_xavg(ne,2:end-1),'all');
% oceTAUY_avg(ne) = nanmean(oceTAUY_xavg(ne,2:end-1),'all');
SIempmr_avg(ne) = nanmean(SIempmr_xavg(ne,2:end-1),'all');
SIqnet_avg(ne) = nanmean(SIqnet_xavg(ne,2:end-1),'all');
SIatmQnt_avg(ne) = nanmean(SIatmQnt_xavg(ne,2:end-1),'all');
SIareaPR_avg(ne) = nanmean(SIareaPR_xavg(ne,2:end-1),'all');
SIareaPT_avg(ne) = nanmean(SIareaPT_xavg(ne,2:end-1),'all');
SIheffPT_avg(ne) = nanmean(SIheffPT_xavg(ne,2:end-1),'all');
% ADVxHEFF_avg(ne) = nanmean(ADVxHEFF_xavg(ne,2:end-1),'all');
% ADVyHEFF_avg(ne) = nanmean(ADVyHEFF_xavg(ne,2:end-1),'all');
SIdHbATC_avg(ne) = nanmean(SIdHbATC_xavg(ne,2:end-1),'all');
SIdHbOCN_avg(ne) = nanmean(SIdHbOCN_xavg(ne,2:end-1),'all');
% SIdHbATO_avg(ne) = nanmean(SIdHbATO_xavg(ne,2:end-1),'all');
SIhsnow_avg(ne) = nanmean(SIhsnow_xavg(ne,2:end-1),'all');
SIhsalt_avg(ne) = nanmean(SIhsalt_xavg(ne,2:end-1),'all');
SIuice_avg(ne) = nanmean(SIuice_xavg(ne,2:end-1),'all');
SIvice_avg(ne) = nanmean(SIvice_xavg(ne,2:end-1),'all');
% SItaux_avg(ne) = nanmean(SItaux_xavg(ne,2:end-1),'all');
% SItauy_avg(ne) = nanmean(SItauy_xavg(ne,2:end-1),'all');
SIatmTx_avg(ne) = nanmean(SIatmTx_xavg(ne,2:end-1),'all');
SIatmTy_avg(ne) = nanmean(SIatmTy_xavg(ne,2:end-1),'all');
SItices_avg(ne) = nanmean(SItices_xavg(ne,2:end-1),'all');


end

%%% Store computed data for later
save([expdir '/data_poster/ice_xAvg_domainAvg_5yrs.mat'],'EXPNAME',...
    'SIheff_xavg','SIheff_avg',...
    'SIarea_xavg','SIarea_avg',...
    'SIpress_xavg','SIpress_avg',...
    'SIzeta_xavg','SIzeta_avg',...
    'SIeta_xavg','SIeta_avg',...
    'SIsig1_xavg','SIsig1_avg',...
    'SIsig2_xavg','SIsig2_avg',...
    'SIshear_xavg','SIshear_avg',...
    'SIdelta_xavg','SIdelta_avg',...
    'SItensil_xavg','SItensil_avg',...
    'SIempmr_xavg','SIempmr_avg',...
    'SIqnet_xavg','SIqnet_avg',...
    'SIatmQnt_xavg','SIatmQnt_avg',...
    'SIareaPR_xavg','SIareaPR_avg',...
    'SIareaPT_xavg','SIareaPT_avg',...
    'SIheffPT_xavg','SIheffPT_avg',...
    'SIdHbATC_xavg','SIdHbATC_avg',...
    'SIdHbOCN_xavg','SIdHbOCN_avg',...
    'SIhsnow_xavg','SIhsnow_avg',...
    'SIhsalt_xavg','SIhsalt_avg',...
    'SIuice_xavg','SIuice_avg',...
    'SIvice_xavg','SIvice_avg',...
    'SItices_xavg','SItices_avg',...
    'xx','yy'); 
%     'oceTAUX_xavg','oceTAUX_avg',...
%     'oceTAUY_xavg','oceTAUY_avg',...
%     'ADVxHEFF_xavg','ADVxHEFF_avg',...
%     'ADVyHEFF_xavg','ADVyHEFF_avg',...
%     'SIdHbATO_xavg','SIdHbATO_avg',...
%     'SItaux_xavg','SItaux_avg',...
%     'SItauy_xavg','SItauy_avg',...
%     'SIatmTx_xavg','SIatmTx_avg',...
%     'SIatmTy_xavg','SIatmTy_avg',...

