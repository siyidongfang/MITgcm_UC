    %%% Check the stratification at the northern boundary


    addpath /Volumes/si/Software/gsw_matlab_v3_06_11/thermodynamics_from_t/;
    addpath /Volumes/si/Software/gsw_matlab_v3_06_11/library/;
    addpath /Volumes/si/Software/gsw_matlab_v3_06_11/;
    addpath /Users/csi/MITgcm_ASF-csi/utils/;
    addpath /Users/csi/MITgcm_ASF-csi/newexp_utils/;
    addpath /Users/csi/MITgcm_ASF-csi/analysis/;
    addpath /Users/csi/MITgcm_ASF-csi/newexp_utils/;
    addpath /Users/csi/MITgcm_ASF-csi/newexp/;

    test_bathymetry
    Nr = 70;
    f0 = -1.3e-4; %%% Coriolis parameter
    beta = 1e-11; %%% Beta parameter  
    rho0 = 999.8;
    is_hires = true;
    %%% Grid spacing increases with depth, but spacings exactly sum to H
    zidx = 1:Nr;
    gamma = 10;  
    alpha = 10;
    dz1 = 2*H/Nr/(alpha+1);
    dz2 = alpha*dz1;
    dz = dz1 + ((dz2-dz1)/2)*(1+tanh((zidx-((Nr+1)/2))/gamma));
    zz = -cumsum((dz+[0 dz(1:end-1)])/2);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% NORTHERN TEMPERATURE/SALINITY PROFILES %%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%% Bottom properties offshore, taken from Meijers et al. (2010)
    %%% measurements. We need these because the KN climatology only goes down
    %%% to 2000m
    s_bot = 34.66;
    pt_bot = -0.5;

    %%% Load sections from Kapp Norvegia climatology (Hattermann 2018) 
    ptemp_KN = ncread('KappNorvegiaCLM.nc','ptemp');
    salt_KN = ncread('KappNorvegiaCLM.nc','salt');
    pres_KN = ncread('KappNorvegiaCLM.nc','pressure');

    salt_KN_tavg = mean(salt_KN(:,:,6:8),3)';
    ptemp_KN_tavg = mean(ptemp_KN(:,:,6:8),3)';
    figure(2)
%     pcolor(sptemp_KN_tavg)
    pcolor(salt_KN_tavg)

    N_offshore = 51;
    
    %%% Winter means at offshore boundary
    ptemp_North = [squeeze(mean(ptemp_KN(:,N_offshore,6:8),3))' pt_bot];
    salt_North = [squeeze(mean(salt_KN(:,N_offshore,6:8),3))' s_bot];
    depth_North = [-pres_KN' -H];

     pp = - zz;
    %     pp = 1026*9.81*(-zz)/10000;
    
    %%% Interpolate to model grid
    ptemp_North(1) = -1.87;
    ptemp_North(2) = -1.85;
    tNorth = interp1(depth_North,ptemp_North,zz,'PCHIP'); %%% reference pressure level: sea surface
    sNorth = interp1(depth_North,salt_North,zz,'PCHIP');  %%% reference pressure level: sea surface
    tNorth(1) = -1.87;
    tNorth_diff= tNorth(3)-tNorth(1);
    tNorth(2)= tNorth(1) + tNorth_diff/(zz(3)-zz(1))*(zz(2)-zz(1));
    
    ref_pres_surf = 0;
    SA_north = gsw_SA_from_SP(sNorth,ref_pres_surf,-12,-64);  
    CT_north = gsw_CT_from_pt(SA_north,tNorth); 
    
    %%% Check Brunt-Vaisala frequency using full EOS
    [N2_north, pp_mid_north] = gsw_Nsquared(SA_north,CT_north,pp,-64);
    rho_north  = gsw_rho(SA_north,CT_north,500); 

    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%% New restoring profile
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   

  s_bot = 34.66;
  pt_bot = -0.5;
  
%   %%% Load sections from Kapp Norvegia climatology (Hattermann 2018) 
  ptemp_KN = ncread('KappNorvegiaCLM.nc','ptemp'); %%% at sea level pressure
  salt_KN = ncread('KappNorvegiaCLM.nc','salt');
  pres_KN = ncread('KappNorvegiaCLM.nc','pressure');
  
  N_offshore = 40:45;

  %%% Winter means at offshore boundary
  ptemp_North = [squeeze(mean(mean(ptemp_KN(:,N_offshore,6:8),3),2))' pt_bot];
  salt_North = [squeeze(mean(mean(salt_KN(:,N_offshore,6:8),3),2))' s_bot];
  depth_North = [-pres_KN' -H];
  
  
  
  %%% Interpolate to model grid
%   ptemp_North(1) = -1.88;
%   ptemp_North(2) = -1.83;
%   ptemp_North(3) = -1.7; 
  tNorth_new = interp1(depth_North,ptemp_North,zz,'PCHIP'); %%% reference pressure level: sea surface
  sNorth_new = interp1(depth_North,salt_North,zz,'PCHIP');  %%% reference pressure level: sea surface
  
%   tNorth_new(1) = -1.87;
  
  
  
%   sNorth_new = zeros(1,70);
%   
%   zidx = find(sNorth==max(sNorth));
%   sNorth_new(1)=34;
%   sNorth_new(1:zidx) = sNorth(1:zidx);
%      sNorth_new = sNorth;
%   ds = sNorth(zidx+1:end)-max(sNorth);
%   ds = ds*0.5;
%   sNorth_new(zidx+1:end) =  0.5*(sNorth(zidx+1:end)+max(sNorth));
%   sNorth_new(zidx+1:end) = max(sNorth);
%   ds = 0.005;


    ref_pres_surf = 0;
    SA_north_new = gsw_SA_from_SP(sNorth_new,ref_pres_surf,-12,-64);  
    CT_north_new = gsw_CT_from_pt(SA_north_new,tNorth_new); 
  [N2_north_new, pp_mid_north] = gsw_Nsquared(SA_north_new,CT_north_new,pp,-64);

  rho_north_new  = gsw_rho(SA_north_new,CT_north_new,500); 

  
%%%%%%% Re-calculate the buoyancy frequency
N2 = zeros(1,69);
N2_new = zeros(1,69);

g=9.81;


for i = 1:69
    pp_mid = -0.5*(zz(i+1)+zz(i));
    rho_local_up = densmdjwf(sNorth(i),tNorth(i),pp_mid);
    rho_local_low = densmdjwf(sNorth(i+1),tNorth(i+1),pp_mid);
    rho_mid = 0.5*(rho_local_up+rho_local_low);
    N2(i)=-g/rho_mid*(rho_local_low-rho_local_up)./(zz(i+1)-zz(i));
    
    rho_local_up_new = densmdjwf(sNorth_new(i),tNorth_new(i),pp_mid);
    rho_local_low_new = densmdjwf(sNorth_new(i+1),tNorth_new(i+1),pp_mid);
    rho_mid_new = 0.5*(rho_local_up_new+rho_local_low_new);
    N2_new(i)=-g/rho_mid_new*(rho_local_low_new-rho_local_up_new)./(zz(i+1)-zz(i));
end



 

    figure(20)
    subplot(1,4,1)
    plot(tNorth,zz,'LineWidth',1.5);hold on;plot(tNorth_new,zz,'--','LineWidth',1.5);hold off;
    subplot(1,4,2)
    plot(sNorth,zz,'LineWidth',1.5);hold on;plot(sNorth_new,zz,'--','LineWidth',1.5);hold off;
    subplot(1,4,3)
    semilogx(N2_north,pp_mid_north,'LineWidth',1.5);
    hold on;
    semilogx(N2_north_new,pp_mid_north,'--','LineWidth',1.5);
%     semilogx(N2,pp_mid_north,'Color',[0,0.7,0.9],'LineWidth',1.5);
%     semilogx(N2_new,pp_mid_north,'--','Color',[0,0.7,0.9],'LineWidth',1.5);
    hold off;axis ij;
    xlabel('N^2 (s^-^2)');
    title('Buoyancy frequency');
    subplot(1,4,4)
    plot(rho_north,zz,'LineWidth',1.5);hold on;plot(rho_north_new,zz,'--','LineWidth',1.5);hold off;

    
    
    
    
    
    
%% Calculate 5-year mean T, S close to the northern boundary (400-420km)

addpath /Volumes/si/MITgcm_ASF-csi/products_cross_slope
addpath /Volumes/si/MITgcm_ASF-csi/products-hires
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_cross_slope';
expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod';
loadexp;

exp_fresh_smag = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_0dS_prod_60s';
exp_fresh = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis';
exp_ref = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis';
exp_dense = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_analysis';
exp_tide = 'hires_Ua-6Va6_Atide0.1_Hi1Ai1_Ws25_analysis';
exp_ice = 'hires_Ua-6Va6_Atide0.05_Hi0.2Ai1_Ws25_analysis';
exp_ua = 'hires_Ua-8Va6_Atide0.05_Hi1Ai1_Ws25_analysis';
exp_va = 'hires_Ua-6Va12_Atide0.05_Hi1Ai1_Ws25_analysis';

yidx = 400:420;

load([exp_fresh_smag '_tavg_5yrs.mat'],'THETA','SALT')
Tnorth_exp_fresh_smag = squeeze(mean(THETA(:,yidx,:),[1 2]));
Snorth_exp_fresh_smag = squeeze(mean(SALT(:,yidx,:),[1 2]));
load([exp_fresh '_tavg_5yrs.mat'],'THETA','SALT')
Tnorth_exp_fresh = squeeze(mean(THETA(:,yidx,:),[1 2]));
Snorth_exp_fresh = squeeze(mean(SALT(:,yidx,:),[1 2]));
load([exp_ref '_tavg_5yrs.mat'],'THETA','SALT')
Tnorth_exp_ref = squeeze(mean(THETA(:,yidx,:),[1 2]));
% Tnorth_exp_ref (1)=-1.87;
Snorth_exp_ref = squeeze(mean(SALT(:,yidx,:),[1 2]));
load([exp_dense '_tavg_5yrs.mat'],'THETA','SALT')
Tnorth_exp_dense = squeeze(mean(THETA(:,yidx,:),[1 2]));
Snorth_exp_dense = squeeze(mean(SALT(:,yidx,:),[1 2]));
load([exp_tide '_tavg_5yrs.mat'],'THETA','SALT')
Tnorth_exp_tide = squeeze(mean(THETA(:,yidx,:),[1 2]));
Snorth_exp_tide = squeeze(mean(SALT(:,yidx,:),[1 2]));
load([exp_ice '_tavg_5yrs.mat'],'THETA','SALT')
Tnorth_exp_ice = squeeze(mean(THETA(:,yidx,:),[1 2]));
Snorth_exp_ice = squeeze(mean(SALT(:,yidx,:),[1 2]));
load([exp_ua '_tavg_5yrs.mat'],'THETA','SALT')
Tnorth_exp_ua = squeeze(mean(THETA(:,yidx,:),[1 2]));
Snorth_exp_ua = squeeze(mean(SALT(:,yidx,:),[1 2]));
load([exp_va '_tavg_5yrs.mat'],'THETA','SALT')
Tnorth_exp_va = squeeze(mean(THETA(:,yidx,:),[1 2]));
Snorth_exp_va = squeeze(mean(SALT(:,yidx,:),[1 2]));




for i = 1:69
    pp_mid = -0.5*(zz(i+1)+zz(i));
    
    rho_local_up = densmdjwf(sNorth(i),tNorth(i),pp_mid);
    rho_local_low = densmdjwf(sNorth(i+1),tNorth(i+1),pp_mid);
    rho_mid = 0.5*(rho_local_up+rho_local_low);
    N2_restored(i)=-g/rho_mid*(rho_local_low-rho_local_up)./(zz(i+1)-zz(i));
    
    rho_local_up = densmdjwf(Snorth_exp_fresh_smag(i),Tnorth_exp_fresh_smag(i),pp_mid);
    rho_local_low = densmdjwf(Snorth_exp_fresh_smag(i+1),Tnorth_exp_fresh_smag(i+1),pp_mid);
    rho_mid = 0.5*(rho_local_up+rho_local_low);
    N2_exp_fresh_smag(i)=-g/rho_mid*(rho_local_low-rho_local_up)./(zz(i+1)-zz(i));
    
    rho_local_up = densmdjwf(Snorth_exp_fresh(i),Tnorth_exp_fresh(i),pp_mid);
    rho_local_low = densmdjwf(Snorth_exp_fresh(i+1),Tnorth_exp_fresh(i+1),pp_mid);
    rho_mid = 0.5*(rho_local_up+rho_local_low);
    N2_exp_fresh(i)=-g/rho_mid*(rho_local_low-rho_local_up)./(zz(i+1)-zz(i));
 
    rho_local_up = densmdjwf(Snorth_exp_ref(i),Tnorth_exp_ref(i),pp_mid);
    rho_local_low = densmdjwf(Snorth_exp_ref(i+1),Tnorth_exp_ref(i+1),pp_mid);
    rho_mid = 0.5*(rho_local_up+rho_local_low);
    N2_exp_ref(i)=-g/rho_mid*(rho_local_low-rho_local_up)./(zz(i+1)-zz(i));
    
    rho_local_up = densmdjwf(Snorth_exp_dense(i),Tnorth_exp_dense(i),pp_mid);
    rho_local_low = densmdjwf(Snorth_exp_dense(i+1),Tnorth_exp_dense(i+1),pp_mid);
    rho_mid = 0.5*(rho_local_up+rho_local_low);
    N2_exp_dense(i)=-g/rho_mid*(rho_local_low-rho_local_up)./(zz(i+1)-zz(i));
   
    
    rho_local_up = densmdjwf(Snorth_exp_tide(i),Tnorth_exp_tide(i),pp_mid);
    rho_local_low = densmdjwf(Snorth_exp_tide(i+1),Tnorth_exp_tide(i+1),pp_mid);
    rho_mid = 0.5*(rho_local_up+rho_local_low);
    N2_exp_tide(i)=-g/rho_mid*(rho_local_low-rho_local_up)./(zz(i+1)-zz(i));
   
    
    
    rho_local_up = densmdjwf(Snorth_exp_ice(i),Tnorth_exp_ice(i),pp_mid);
    rho_local_low = densmdjwf(Snorth_exp_ice(i+1),Tnorth_exp_ice(i+1),pp_mid);
    rho_mid = 0.5*(rho_local_up+rho_local_low);
    N2_exp_ice(i)=-g/rho_mid*(rho_local_low-rho_local_up)./(zz(i+1)-zz(i));
   
    
    
    rho_local_up = densmdjwf(Snorth_exp_ua(i),Tnorth_exp_ua(i),pp_mid);
    rho_local_low = densmdjwf(Snorth_exp_ua(i+1),Tnorth_exp_ua(i+1),pp_mid);
    rho_mid = 0.5*(rho_local_up+rho_local_low);
    N2_exp_ua(i)=-g/rho_mid*(rho_local_low-rho_local_up)./(zz(i+1)-zz(i));
   
    rho_local_up = densmdjwf(Snorth_exp_va(i),Tnorth_exp_va(i),pp_mid);
    rho_local_low = densmdjwf(Snorth_exp_va(i+1),Tnorth_exp_va(i+1),pp_mid);
    rho_mid = 0.5*(rho_local_up+rho_local_low);
    N2_exp_va(i)=-g/rho_mid*(rho_local_low-rho_local_up)./(zz(i+1)-zz(i));
   
      
    
end


%%
figure(1)

subplot(1,3,1)
plot(tNorth,zz,'--','LineWidth',2)
hold on;
plot(Tnorth_exp_fresh_smag,zz,'LineWidth',3)
plot(Tnorth_exp_fresh,zz,'LineWidth',1.5)
plot(Tnorth_exp_dense,zz,'LineWidth',1.5)
plot(Tnorth_exp_tide,zz,'LineWidth',1.5)
plot(Tnorth_exp_ice,zz,'LineWidth',1.5)
plot(Tnorth_exp_ua,zz,'LineWidth',1.5)
plot(Tnorth_exp_va,zz,'LineWidth',1.5)
plot(Tnorth_exp_ref,zz,'k','LineWidth',3)
% plot(tNorth_new,zz,'--','LineWidth',2)
hold off;
leg1 = legend('Restored T at y=450km','Fresh (Smag.), y=400-420km','Fresh, y=400-420km','Dense, y=400-420km',...
    'Atide=0.1m/s, y=400-420km','Hi0=0.2m, y=400-420km','Ua=-8m/s, y=400-420km','Va=12m/s, y=400-420km','Ref., y=400-420km',...
    'Position',[0.09 0.6048 0.1761 0.2144]);
set(gca,'FontSize',15)
xlabel('T (degC)');
ylabel('z (m)');


subplot(1,3,2)
plot(sNorth,zz,'--','LineWidth',2)
hold on;
plot(Snorth_exp_fresh_smag,zz,'LineWidth',3)
plot(Snorth_exp_fresh,zz,'LineWidth',1.5)
plot(Snorth_exp_dense,zz,'LineWidth',1.5)
plot(Snorth_exp_tide,zz,'LineWidth',1.5)
plot(Snorth_exp_ice,zz,'LineWidth',1.5)
plot(Snorth_exp_ua,zz,'LineWidth',1.5)
plot(Snorth_exp_va,zz,'LineWidth',1.5)
plot(Snorth_exp_ref,zz,'k','LineWidth',3)
hold off;
leg2 = legend('Restored S at y=450km','Fresh (Smag.), y=400-420km','Fresh, y=400-420km','Dense, y=400-420km',...
    'Atide=0.1m/s, y=400-420km','Hi0=0.2m, y=400-420km','Ua=-8m/s, y=400-420km','Va=12m/s, y=400-420km','Ref., y=400-420km',...
    'Position',[0.4 0.6048 0.1761 0.2144]);
set(gca,'FontSize',15)
xlabel('S (psu)');
ylabel('z (m)');


subplot(1,3,3)
semilogx(N2_restored,-pp_mid_north,'--','LineWidth',2)
hold on;
semilogx(N2_exp_fresh_smag,-pp_mid_north,'LineWidth',3)
semilogx(N2_exp_fresh,-pp_mid_north,'LineWidth',1.5)
semilogx(N2_exp_dense,-pp_mid_north,'LineWidth',1.5)
semilogx(N2_exp_tide,-pp_mid_north,'LineWidth',1.5)
semilogx(N2_exp_ice,-pp_mid_north,'LineWidth',1.5)
semilogx(N2_exp_ua,-pp_mid_north,'LineWidth',1.5)
semilogx(N2_exp_va,-pp_mid_north,'LineWidth',1.5)
semilogx(N2_exp_ref,-pp_mid_north,'k','LineWidth',3)
hold off;
% leg3 = legend('Restored S at y=450km','Fresh (Smag.), y=400-420km','Fresh, y=400-420km','Dense, y=400-420km',...
%     'Atide=0.1m/s, y=400-420km','Hi0=0.2m, y=400-420km','Ua=-8m/s, y=400-420km','Va=12m/s, y=400-420km','Ref., y=400-420km',...
%     'Position',[0.6 0.6048 0.1761 0.2144]);
set(gca,'FontSize',15);
xlabel('N^2 (s^-^2)');
% title('Buoyancy frequency');
ylabel('z (m)');


    
    