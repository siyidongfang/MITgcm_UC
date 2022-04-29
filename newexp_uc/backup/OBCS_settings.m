 

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% NORTHERN TEMPERATURE/SALINITY PROFILES %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % % % % % MITgcm_ASF northern boundary condition:
    % % % %     %%% East Antarctica-like conditions: Kapp Norvegia climatology (Hattermann 2018) 
    % % % %     s_bot = 34.66;
    % % % %     pt_bot = -0.5;
    % % % %     ptemp_KN = ncread('KappNorvegiaCLM.nc','ptemp'); %%% at sea level pressure
    % % % %     salt_KN = ncread('KappNorvegiaCLM.nc','salt');
    % % % %     pres_KN = ncread('KappNorvegiaCLM.nc','pressure');
    % % % %     ptemp_North = [squeeze(mean(ptemp_KN(:,end,6:8),3))' pt_bot];
    % % % %     salt_North = [squeeze(mean(salt_KN(:,end,6:8),3))' s_bot];
    % % % %     depth_North = [-pres_KN' -H];
    % % % %     tNorth = interp1(depth_North,ptemp_North,zz,'PCHIP'); %%% reference pressure level: sea surface
    % % % %     sNorth = interp1(depth_North,salt_North,zz,'PCHIP');  %%% reference pressure level: sea surface


% % % % %   %%% Bottom properties offshore, taken from Meijers et al. (2010)
% % % % %   %%% measurements. We need these because the KN climatology only goes down
% % % % %   %%% to 2000m
% % % % %   %%% Modified by YS, based on Jacobs et al. (2011), doi 10.1038/NGEO1188
% % % % %   s_bot = 34.65;
% % % % %   pt_bot = 0.4;
% % % % %   s_mid = 34.67;
% % % % %   pt_mid = 3.5;
% % % % %   s_surf = 33.95;
% % % % %   pt_surf = -1.5;
% % % % %   Zsml = -50;
% % % % %   Zcdw_pt = -300;         %%% Default: -300
% % % % %   Zcdw_s = Zcdw_pt - 100;  %%% Default: Zcdw_pt -100
% % % % %                           %%% This is important - salinity maximum needs to 
% % % % %                           %%% be deeper or else you end up with very weak 
% % % % %                           %%% buoyancy frequency just below the pycnocline
% % % % %   
% % % % % 
% % % % %   %%% Artificially construct a hydrographic profile
% % % % %   depth_North_pt = [-H (-H+3*Zcdw_pt)/4 Zcdw_pt Zsml 0];
% % % % %   depth_North_s = [-H (-H+3*Zcdw_s)/4 Zcdw_s Zsml 0];
% % % % %   ptemp_North = [pt_bot (pt_bot+pt_mid)/2 pt_mid pt_surf pt_surf];
% % % % %   salt_North = [s_bot (s_bot+s_mid)/2 s_mid s_surf s_surf];
% % % % %  
% % % % %   
% % % % %   %%% Interpolate to model grid
% % % % %   tNorth = interp1(depth_North_pt,ptemp_North,zz,'PCHIP'); %%% reference pressure level: sea surface
% % % % %   sNorth = interp1(depth_North_s,salt_North,zz,'PCHIP');  %%% reference pressure level: sea surface 
  
  

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% SOUTHERN TEMPERATURE/SALINITY PROFILES %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % % % % MITgcm_ASF profiles
% % % %     tSouth =  tNorth(1).*single(ones(1,Nr)); %%% Set T profile to freezing temperature, reference pressure level: sea surface
% % % %     ssouth_surf=33;
% % % %     sSouth = ssouth_surf.*single(ones(1,Nr));


% % % % % % % %%% Use Amundsen-like relaxation profiles
% % % % % % %     addpath /Users/csi/MITgcm_UC/analysis_uc/woa;
% % % % % % %     load WOA81summer_Lon103W_LatS72.125S_latN69.875S.mat;
% % % % % % %     tNorth = interp1(-depth,tnorth_woa_smooth,zz,'PCHIP'); 
% % % % % % %     sNorth = interp1(-depth,snorth_woa_smooth,zz,'PCHIP');
% % % % % % %     tsouth_woa_fulldepth = [tsouth_woa_smooth tsouth_woa_smooth(end).*ones(1,length(depth)-Ndepth_south)];
% % % % % % %     ssouth_woa_fulldepth = [ssouth_woa_smooth ssouth_woa_smooth(end).*ones(1,length(depth)-Ndepth_south)];
% % % % % % %     tSouth = interp1(-depth,tsouth_woa_fulldepth,zz,'PCHIP');
% % % % % % %     sSouth = interp1(-depth,ssouth_woa_fulldepth,zz,'PCHIP');
% % % % % % % 
% % % % % % %     useFresherS = false;
% % % % % % %     if(useFresherS)
% % % % % % %         sSouth = sSouth -0.6;
% % % % % % %     end

% % %   %%% Bottom properties offshore, taken from Meijers et al. (2010)
% % %   %%% measurements. We need these because the KN climatology only goes down
% % %   %%% to 2000m
% % %   %%% Modified by YS, based on Jacobs et al. (2011), doi 10.1038/NGEO1188
% % % 
% % %   s_bot = 34.65;
% % %   pt_bot = 4;
% % %   s_mid = 34.62;
% % %   pt_mid = 3.5;
% % %   s_surf = 33.95;
% % %   pt_surf = -1.8;
% % %   Zsml = -100;             %%% Depth of the surface mixed layer
% % %   Zcdw_pt = -650;
% % %   Zcdw_s = Zcdw_pt - 100; %%% This is important - salinity maximum needs to 
% % %                           %%% be deeper or else you end up with very weak 
% % %                           %%% buoyancy frequency just below the pycnocline
% % %   useFresher = true;
% % %   if(useFresher)
% % %       s_bot = s_bot-0.3;
% % %       s_mid = s_mid-0.3;
% % %       s_surf = s_surf-0.3;
% % %   end
% % % 
% % %   %%% Artificially construct a hydrographic profile
% % %   depth_South_pt = [-H (-H+3*Zcdw_pt)/4 Zcdw_pt Zsml 0];
% % %   depth_South_s = [-H (-H+3*Zcdw_s)/4 Zcdw_s Zsml 0];
% % %   ptemp_South = [pt_bot (pt_bot+pt_mid)/2 pt_mid pt_surf pt_surf];
% % %   salt_South = [s_bot (s_bot+s_mid)/2 s_mid s_surf s_surf];
% % %   
% % %   %%% Interpolate to model grid
% % %   tSouth = interp1(depth_South_pt,ptemp_South,zz,'PCHIP'); %%% reference pressure level: sea surface
% % %   sSouth = interp1(depth_South_s,salt_South,zz,'PCHIP');  %%% reference pressure level: sea surface 
  