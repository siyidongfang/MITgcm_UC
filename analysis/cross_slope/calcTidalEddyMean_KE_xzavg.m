%%% Calculate zonal/vertical average of the kinetic energy decomposition
%%% KE: Total kinetic energy
%%% MKE: Mean component of the total KE
%%% EKE: Eddy component
%%% TKE: Tidal component
%%% G = 0.5 * \overline{ \overline{ \bm{u}^T^2 }^E, a conversion term

clear;close all;
addpath  ..
addpath  ../colormaps;
addpath  ../jpo_analysis/;
addpath  ../jpo_analysis-hires/;
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng/';
prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/';

%%%%%%
expname = 'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
loadexp;

DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

DRC = rdmds(fullfile(resultspath,'DRC')); % Nr+1
DZ_drc_xyz = repmat(reshape(squeeze(DRC(2:Nr+1))',[1 1 Nr]),[Nx Ny 1]);

nEND=3650;
load([prodir expname,'_KE_' num2str(nEND) 'days.mat'],'yy','xx','zz',...
'KEuv','KEw','MKEuv','MKEw','TKEuv','TKEw','EKEuv','EKEw','Guv','Gw'...
  );


meanX_vorgrid = sum(sum(hFacS.*DX_xyz,3),1);% Total width of the wet grids as a function of latitude , averaged vertically

KEuv_xzavg = sum(sum(KEuv.*hFacS.*DZ_xyz.*DX_xyz,3)./ sum(DZ_xyz.*hFacS,3),1)./meanX_vorgrid; % Vorticity grid
EKEuv_xzavg = sum(sum(EKEuv.*hFacS.*DZ_xyz.*DX_xyz,3)./ sum(DZ_xyz.*hFacS,3),1)./meanX_vorgrid;
MKEuv_xzavg = sum(sum(MKEuv.*hFacS.*DZ_xyz.*DX_xyz,3)./ sum(DZ_xyz.*hFacS,3),1)./meanX_vorgrid;
TKEuv_xzavg = sum(sum(TKEuv.*hFacS.*DZ_xyz.*DX_xyz,3)./ sum(DZ_xyz.*hFacS,3),1)./meanX_vorgrid;

meanX_wgrid = sum(sum(hFacC.*DX_xyz,3),1);% Total width of the wet grids as a function of latitude , averaged vertically

KEw_xzavg = sum(sum(KEw.*DZ_drc_xyz.*DX_xyz,3)./ sum(DZ_drc_xyz,3),1)./meanX_wgrid ; % on wvel grid
EKEw_xzavg = sum(sum(EKEw.*DZ_drc_xyz.*DX_xyz,3)./ sum(DZ_drc_xyz,3),1)./meanX_wgrid ; 
MKEw_xzavg = sum(sum(MKEw.*DZ_drc_xyz.*DX_xyz,3)./ sum(DZ_drc_xyz,3),1)./meanX_wgrid ; 
TKEw_xzavg = sum(sum(TKEw.*DZ_drc_xyz.*DX_xyz,3)./ sum(DZ_drc_xyz,3),1)./meanX_wgrid ; 


EKEuv(EKEuv==0)=NaN;
EKEuv_xavg = squeeze(nanmean(EKEuv,1));

EKEw(EKEw==0)=NaN;
EKEw_xavg = squeeze(nanmean(EKEw,1));


save([prodir expname,'_KE_' num2str(nEND) 'days_xzavg.mat'],'yy','xx','zz',...
'KEuv_xzavg','KEw_xzavg','MKEuv_xzavg','MKEw_xzavg','TKEuv_xzavg','TKEw_xzavg','EKEuv_xzavg','EKEw_xzavg',...
'EKEuv_xavg','EKEw_xavg'...
);







% KEuv_xint = squeeze(sum(KEuv.*DX_xyz,1)); 
% KEw_xint = squeeze(sum(KEw.*DX_xyz,1)); 
% 
% KEuv_zint = sum(KEuv.*hFacC.*DZ_xyz,3);
% KEuv_xzint = sum(sum(KEuv.*hFacC.*DZ_xyz.*DX_xyz,3),1);


% Guv_zavg = zeros(Nx,Ny);
% Gw_zavg = zeros(Nx,Ny);
% 
% Guv_zavg = Guv_zavg +(sum(Gxy.*hFacC.*DZ_xyz,3)./ sum(DZ_xyz.*hFacC,3))/nEND;     
% Gw_zavg  = Gw_zavg + (sum(Gw.*DZ_drc_xyz,3)./ sum(DZ_drc_xyz,3))/nEND;
%       
% 
% KEuv_zavg = sum(KEuv.*hFacC.*DZ_xyz,3)./ sum(DZ_xyz.*hFacC,3);
% KEw_zavg =sum(KEw.*DZ_drc_xyz,3)./ sum(DZ_drc_xyz,3);
% KE_zavg = KEuv_zavg + KEw_zavg;
% KEuv_xzavg = sum(KEuv_zavg.*dx)./Lx;       
% KEw_xzavg = sum(KEw_zavg.*dx)./Lx;       
% KE_xzavg = sum(KE_zavg.*dx)./Lx;     
% 
% MKEuv_zavg = sum(MKEuv.*hFacC.*DZ_xyz,3)./ sum(DZ_xyz.*hFacC,3);
% MKEw_zavg =sum(MKEw.*DZ_drc_xyz,3)./ sum(DZ_drc_xyz,3);
% MKE_zavg = MKEuv_zavg + MKEw_zavg;
% MKEuv_xzavg = sum(MKEuv_zavg.*dx)./Lx;       
% MKEw_xzavg = sum(MKEw_zavg.*dx)./Lx;      
% MKE_xzavg = sum(MKE_zavg.*dx)./Lx;      
% 
% G_zavg = Guv_zavg + Gw_zavg;
% Guv_xzavg = sum(Guv_zavg.*dx)./Lx;       
% Gw_xzavg = sum(Gw_zavg.*dx)./Lx;  
% G_xzavg = sum(G_zavg.*dx)./Lx;
%     
% TKE_zavg = KE_zavg - G_zavg;
% TKEuv_xzavg = KEuv_xzavg - Guv_xzavg;
% TKEw_xzavg = KEw_xzavg - Gw_xzavg;
% TKE_xzavg = KE_xzavg - G_xzavg;
% 
% EKE_zavg = G_zavg - MKE_zavg;
% EKEuv_xzavg = Guv_xzavg - MKEuv_xzavg;
% EKEw_xzavg = Gw_xzavg - MKEw_xzavg;
% EKE_xzavg = G_xzavg - MKE_xzavg;
  

% save([expname,'_KE_' num2str(nEND) 'days.mat'],'yy','xx',...
%   'KE_xavg','KE_zavg', 'KEuv_xzavg', 'KEw_xzavg', 'KE_xzavg',...
%   'TKE_xavg','TKE_zavg','TKEuv_xzavg','TKEw_xzavg','TKE_xzavg',...
%   'EKE_xavg','EKE_zavg','EKEuv_xzavg','EKEw_xzavg','EKE_xzavg',...
%   'MKE_xavg','MKE_zavg','MKEuv_xzavg','MKEw_xzavg','MKE_xzavg',...
%   'G_xavg', 'G_zavg',  'Guv_xzavg',  'Gw_xzavg',  'G_xzavg'...
%   );

