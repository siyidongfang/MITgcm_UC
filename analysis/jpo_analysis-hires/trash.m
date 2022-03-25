%%% Check the stratification at the northern boundary


  addpath /data/Software/gsw_matlab_v3_06_11/pdf/;
  addpath /data/Software/gsw_matlab_v3_06_11/thermodynamics_from_t/;
  addpath /data/Software/gsw_matlab_v3_06_11/library/;
  addpath /data/Software/gsw_matlab_v3_06_11/html/;
  addpath /data/Software/gsw_matlab_v3_06_11/pdf/;
  addpath /data/Software/gsw_matlab_v3_06_11/;
  addpath /data/MITgcm_ASF-csi/utils/;
  addpath /data/MITgcm_ASF-csi/newexp_utils/;
  addpath /data/MITgcm_ASF-csi/analysis/;
  addpath /data/MITgcm_ASF-csi/newexp_utils/;

  test_bathymetry
  Nr = 70;
  f0 = -1.3e-4; %%% Coriolis parameter
  beta = 1e-11; %%% Beta parameter  
  
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
  
  ptemp = mean(ptemp_KN(:,20:end,6:8),3);
  
  ndis = 51;
  ptemp_North = [0.8*squeeze(mean(mean(ptemp_KN(:,ndis,6:8),2),3))' pt_bot];

  salt_North = [squeeze(mean(mean(salt_KN(:,ndis,6:8),2),3))' s_bot];
  depth_North = [-pres_KN' -H];
  
  %%% Interpolate to model grid
  tNorth = interp1(depth_North,ptemp_North,zz,'PCHIP');
  sNorth = interp1(depth_North,salt_North,zz,'PCHIP');  
  
  tNorth(1) = -1.87;
  
  ptemp_North_old = [squeeze(mean(mean(ptemp_KN(:,51,6:8),2),3))' pt_bot];
  tNorth_old = interp1(depth_North,ptemp_North_old,zz,'PCHIP');
  tNorth_old(1) = -1.87;

    
  pp0 = - zz; % This pressure is approximate, using a constant density
  pp = pp0;
  
  pp_mid_north=0.5*(pp(1:Nr-1)+pp(2:Nr));

  prodir = '/data/MITgcm_ASF-csi/products-hires';
  load([prodir '/' 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis' ...
        '_tavg_5yrs.mat'],'THETA','SALT');  
  
    
  ref_pres = 0;
 
  pd_north_old_0 = densmdjwf(sNorth,tNorth_old,ref_pres)';
  pd_north_0 = densmdjwf(sNorth,tNorth,ref_pres)';
  N2_north_0 = diff(pd_north_0).*9.8/1000;
  rho_ref_0 = densmdjwf(SALT,THETA,ref_pres*ones(Nx,Ny,Nr));

  ref_pres = 1000;
 
  pd_north_old_1 = densmdjwf(sNorth,tNorth_old,ref_pres)';
  pd_north_1 = densmdjwf(sNorth,tNorth,ref_pres)';
  N2_north_1 = diff(pd_north_1).*9.8/1000;
  rho_ref_1 = densmdjwf(SALT,THETA,ref_pres*ones(Nx,Ny,Nr));
  
  ref_pres = 2000;
 
  pd_north_old_2 = densmdjwf(sNorth,tNorth_old,ref_pres)';
  pd_north_2 = densmdjwf(sNorth,tNorth,ref_pres)';
  N2_north_2 = diff(pd_north_2).*9.8/1000;
  rho_ref_2 = densmdjwf(SALT,THETA,ref_pres*ones(Nx,Ny,Nr));
  
  ref_pres = 3000;
 
  pd_north_old_3 = densmdjwf(sNorth,tNorth_old,ref_pres)';
  pd_north_3 = densmdjwf(sNorth,tNorth,ref_pres)';
  N2_north_3 = diff(pd_north_3).*9.8/1000;
  rho_ref_3 = densmdjwf(SALT,THETA,ref_pres*ones(Nx,Ny,Nr));
  
  ref_pres = 4000;
 
  pd_north_old_4 = densmdjwf(sNorth,tNorth_old,ref_pres)';
  pd_north_4 = densmdjwf(sNorth,tNorth,ref_pres)';
  N2_north_4 = diff(pd_north_4).*9.8/1000;
  rho_ref_4 = densmdjwf(SALT,THETA,ref_pres*ones(Nx,Ny,Nr));

    T_innerbound = squeeze(mean(THETA(:,428,:)));  
    S_innerbound = squeeze(mean(SALT(:,428,:)));  
    
   
    
    figure(1)
    semilogx(N2_north_0,-pp_mid_north/1000,'Color','green');
    title('N^2 (s^-^2)','fontsize',fontsize);

    
    

%     figure(1)
%     clf;
%     subplot(2,4,1)
%     plot(T_innerbound,zz/1000)
%     ylabel('z (km)','fontsize',fontsize)
%     title('\theta (^\circC)','fontsize',fontsize)
%     hold on;
%     plot(tNorth,zz/1000)
%     plot(tNorth_old,zz/1000)
%     legend('Ref. exp. (inner bound)','New relaxation profile','Old relaxation profile',...
%         'fontsize',fontsize,'Position',[0.0696 0.8199 0.1527 0.0513])
%     
%     subplot(2,4,2)
%     plot(S_innerbound,zz/1000)
%     hold on;
%     plot(sNorth,zz/1000)
%     title('S (psu)','fontsize',fontsize)
% 
%     subplot(2,4,3)
%     semilogx(N2_north_0,-pp_mid_north/1000,'Color','green');
%     hold on;
%     semilogx(N2_north_1,-pp_mid_north/1000,'Color','black');
%     semilogx(N2_north_2,-pp_mid_north/1000,'Color','red');
% %     semilogx(N2_north_3,-pp_mid_north/1000);
% %     semilogx(N2_north_4,-pp_mid_north/1000);
%     title('N^2 (s^-^2)','fontsize',fontsize);
%     legend('P_{ref} = 0','P_{ref} = 1000 dbar','P_{ref} = 2000 dbar',...
%         'fontsize',fontsize,'Position',[0.4297 0.6395 0.1527 0.0703])
% 
%     
%     subplot(2,4,4)   
%     rho_innerbound = squeeze(mean(rho_ref_0(:,428,:)));  
%     plot(rho_innerbound,zz/1000)
%     hold on;
%     plot(pd_north_0,zz/1000)
%     plot(pd_north_old_0,zz/1000)
%     title('\sigma_0','fontsize',fontsize)
%     
%     subplot(2,4,5)   
%     rho_innerbound = squeeze(mean(rho_ref_1(:,428,:)));  
%     plot(rho_innerbound,zz/1000)
%     hold on;
%     plot(pd_north_1,zz/1000)
%     plot(pd_north_old_1,zz/1000)
%     ylabel('z (km)','fontsize',fontsize)
%     title('\sigma_1','fontsize',fontsize)
%     
%     subplot(2,4,6)   
%     rho_innerbound = squeeze(mean(rho_ref_2(:,428,:)));  
%     plot(rho_innerbound,zz/1000)
%     hold on;
%     plot(pd_north_2,zz/1000)
%     plot(pd_north_old_2,zz/1000)
%     title('\sigma_2','fontsize',fontsize)
%     
%     subplot(2,4,7)   
%     rho_innerbound = squeeze(mean(rho_ref_3(:,428,:)));  
%     plot(rho_innerbound,zz/1000)
%     hold on;
%     plot(pd_north_3,zz/1000)
%     plot(pd_north_old_3,zz/1000)
%     title('\sigma_3','fontsize',fontsize)
%     
%     subplot(2,4,8)   
%     rho_innerbound = squeeze(mean(rho_ref_4(:,428,:)));  
%     plot(rho_innerbound,zz/1000)
%     hold on;
%     plot(pd_north_4,zz/1000)
%     plot(pd_north_old_4,zz/1000)
%     title('\sigma_4','fontsize',fontsize)
%     set(gca,'fontsize',fontsize);
%       
%       
      
    
    
      
      
      
        
%       figure(2);
%       clf;
%       semilogx(N2_north,pp_mid_north,'LineWidth',1.5);axis ij;
% %       plot(N2_north,pp_mid_north,'LineWidth',1.5);axis ij;
%       legend('Northern N^2','Position',[0.5181 0.6192 0.3313 0.0899]);
%       xlabel('N^2 (s^-^2)');
%       ylabel('Depth (m)');
%       title('Buoyancy frequency');
%       set(gca,'fontsize',fontsize);
%       PLOT = gcf;
%       PLOT.Position = [644 148 380 562];  

      
      
      
      
      
      
% 
%   %%% Calculate the relaxation density profile using GSW toolbox
%    SA_north = gsw_SA_from_SP(sNorth,ref_pres,-12,-64);  
%    CT_north = gsw_CT_from_pt(SA_north,tNorth); 
%    rho_north  = gsw_rho(SA_north,CT_north,ref_pres); % Potential density       
% 
%     
%     %%% Check Brunt-Vaisala frequency using full EOS
%     [N2_north, pp_mid_north] = gsw_Nsquared(SA_north,CT_north,pp,-64);
%     dzData = zz(1:end-1)-zz(2:end);
% 
%     %%% Calculate internal wave speed and first Rossby radius of deformation
%     N = sqrt(N2_north);
%     Cig = zeros(size(yy));
%     for j=1:Ny    
%       for k=1:length(dzData)
%         if (zz(k) > h(1,j))        
%           Cig(j) = Cig(j) + N(k)*min(dzData(k),zz(k)-h(1,j));
%         end
%       end
%     end
%     Rd = Cig./(pi*abs(f0+beta*Y(1,:)));

%       figure(2);
%       clf;
%       semilogx(N2_north,pp_mid_north,'LineWidth',1.5);axis ij;
%       legend('Northern N^2','Position',[0.5181 0.6192 0.3313 0.0899]);
%       xlabel('N^2 (s^-^2)');
%       ylabel('Depth (m)');
%       title('Buoyancy frequency');
%       set(gca,'fontsize',fontsize);
%       PLOT = gcf;
%       PLOT.Position = [644 148 380 562];  
   
