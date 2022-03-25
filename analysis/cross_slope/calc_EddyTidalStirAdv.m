
%%% Decompose eddy heat flux into eddy stirring and eddy advection


clear;

addpath /Users/csi/MITgcm_ASF-csi/analysis/;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps/;
addpath  /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires;
prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/';
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng/';
figdir = '/Users/csi/MITgcm_ASF-csi/analysis/nature/figs_supp/';

expname =   'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
loadexp;

load([prodir expname '_heat_3650days.mat'],'Fmean_xzint','Feddy_xzint','Ftide_xzint');
Ftotal = Fmean_xzint+Feddy_xzint+Ftide_xzint;

load([prodir expname '_MOC_rho_Aocean.mat']);
load([prodir '/' expname,'_tidalMOCz_3650days.mat']);

load([prodir expname '_tavg_10yrs.mat'],'THETA');
THETA (THETA==0)=NaN;

rho_o = 1037;
cp_o = 3850;

DZ_yz = repmat(reshape(delR,[1 Nr]),[Ny 1]);

vte=zeros(Ny,Nr);
vte_adv =zeros(Ny,Nr);

ve = zeros(Ny,Nr);
ve_adv = zeros(Ny,Nr);
vt = zeros(Ny,Nr);
vt_adv = zeros(Ny,Nr);

Sv = 1e6;


for j=2:Ny
  for k=1:Nr
      
    tt_v = (THETA(:,j,k)+THETA(:,j-1,k))/2; 
    
    %%% Calculate flux due to eddy and tidal velocity
    vte(j,k) = - (psie_z(j,k)-psie_z(j,k+1))*Sv / (delR(k)*hFacS(51,j,k)); % Unit: m^2/s
    if (isnan(vte))
      vte(j,k) = 0;
    end
    vte_adv(j,k) = vte(j,k) .* nanmean(tt_v,1);
    
    
    %%% Calculate flux due to eddy velocity
    ve(j,k) = - (psi_eddy_z(j,k)-psi_eddy_z(j,k+1))*Sv / (delR(k)*hFacS(51,j,k)); % Unit: m^2/s
    if (isnan(ve))
      ve(j,k) = 0;
    end
    ve_adv(j,k) = ve(j,k) .* nanmean(tt_v,1);

    
    %%% Calculate flux due to "tidal" velocity
    vt(j,k) = - (psi_tide_z(j,k)-psi_tide_z(j,k+1))*Sv  / (delR(k)*hFacS(51,j,k)); % Unit: m^2/s
    if (isnan(vt))
      vt(j,k) = 0;
    end
    vt_adv(j,k) = vt(j,k) .* nanmean(tt_v,1);
    
  end
end
    

Fte_adv = nansum(vte_adv.*DZ_yz.*squeeze(hFacS(51,:,:)),2)';
Fte_stir= Feddy_xzint + Ftide_xzint - Fte_adv;

Feddy_adv = nansum(ve_adv.*DZ_yz.*squeeze(hFacS(51,:,:)),2)';
Feddy_stir= Feddy_xzint - Feddy_adv;

Ftide_adv = nansum(vt_adv.*DZ_yz.*squeeze(hFacS(51,:,:)),2)';
Ftide_stir= Ftide_xzint - Ftide_adv;


% figure(1)
% clf
% plot(Fe_adv)
% hold on;
% plot(Ft_adv)
% plot(Fe_stir,':')
% plot(Ft_stir,'--')
% plot(Fte_stir)
% plot(Fte_adv)
% 
% figure(2)
% plot(Ftide_xzint)
% hold on;
% plot(Feddy_xzint)


save([prodir expname,'_Feddy_adv_stir.mat'],'yy',  ...
    'Fmean_xzint','Feddy_xzint','Ftide_xzint','Ftotal', ...
    'Feddy_adv','Feddy_stir','Ftide_adv','Ftide_stir');
