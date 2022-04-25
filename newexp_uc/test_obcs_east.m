    
     
      addpath ../../Software/gsw_matlab_v3_06_11/thermodynamics_from_t/;
      addpath ../../Software/gsw_matlab_v3_06_11/library/;
      addpath ../../Software/gsw_matlab_v3_06_11/;
      addpath ../utils/;
      addpath ../newexp_utils/;
      addpath ../analysis_uc/;
    
    
      Nx = 200;
      Ny = 225;
      Nr = 60;
    
      m1km = 1000;
      H = 4000; %%% Domain size in z 
      Lx = 400*m1km; %%% Domain size in x 
      Ly = 450*m1km; %%% Domain size in y   
    
      showplots = false;
      fignum = 1;
      fontsize = 14;
    
      %%%%%%%%%%%%%%%%%%%%%%%%
      %%%%% GRID SPACING %%%%%
      %%%%%%%%%%%%%%%%%%%%%%%%    
    
      %%% Zonal grid
      dx = Lx/Nx;  
      xx = (1:Nx)*dx;
      
      %%% Uniform meridional grid   
      dy = (Ly/Ny)*ones(1,Ny);  
      yy = cumsum((dy + [0 dy(1:end-1)])/2);
     
      %%% Plotting mesh
      [Y,X] = meshgrid(yy,xx);
    
    
      dz0 = 2*10/6;
      dz1 = 15*10/6; 
      dz2 = 20*10/6;
      dz3 = 100*10/6;
      dz4 = 200*10/6;  
      N0 = 1;
      N1 = 12; 
      N2 = 30;
      N3 = 9;
      N4 = 8;
      nn_c = cumsum([N0 N1 N2 N3 N4]);
      dz_c = [dz0 dz1 dz2 dz3 dz4];
      nn = 1:(N1+N2+N3+N4+1);
      dz = interp1(nn_c,dz_c,nn,'pchip');
    
      zz = -cumsum((dz+[0 dz(1:end-1)])/2);
      if (length(zz) ~= Nr)
        error('Vertical grid size does not match vertical array dimension!');
      end
      Nr = length(zz);
    
    
    
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%% SOUTHERN TEMPERATURE/SALINITY PROFILES %%%%%
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% Use Amundsen-like relaxation profiles
        addpath /Users/csi/MITgcm_UC/analysis_uc/woa;
    %     load WOA81SouthernHWinter_Lon103W_LatS71.875S.mat;
        load WOA81SouthernHSummer_Lon103W_LatS71.875S.mat;
        tNorth = interp1(-depth,tnorth_woa_smooth,zz,'PCHIP'); 
        sNorth = interp1(-depth,snorth_woa_smooth,zz,'PCHIP');
        tsouth_woa_fulldepth = [tsouth_woa_smooth tsouth_woa_smooth(end).*ones(1,length(depth)-Ndepth_south)];
        ssouth_woa_fulldepth = [ssouth_woa_smooth ssouth_woa_smooth(end).*ones(1,length(depth)-Ndepth_south)];
        tSouth = interp1(-depth,tsouth_woa_fulldepth,zz,'PCHIP');
        sSouth = interp1(-depth,ssouth_woa_fulldepth,zz,'PCHIP');
    
        useFresherS = true;
        if(useFresherS)
            sSouth = sSouth -0.6;
        end
    
    
        ref_pres_surf = 0; 
        ref_pres_sigma4 = 4000;
        ref_pres_sigma2 = 2000;
    
        lon_sec = -12;
        latS = -70;
        latN = -64;
    
        SA_north = gsw_SA_from_SP(sNorth,ref_pres_surf,lon_sec,latN);  
        CT_north = gsw_CT_from_pt(SA_north,tNorth); 
        SA_south = gsw_SA_from_SP(sSouth,ref_pres_surf,lon_sec,latS);  
        CT_south = gsw_CT_from_pt(SA_south,tSouth); 
    
        rho_north_sigma4  = gsw_rho(SA_north,CT_north,ref_pres_sigma4); 
        rho_north_sigma2  = gsw_rho(SA_north,CT_north,ref_pres_sigma2); 
        rho_north_surf  = gsw_rho(SA_north,CT_north,ref_pres_surf); 
    
        rho_south_sigma4 = gsw_rho(SA_south,CT_south,ref_pres_sigma4);
        rho_south_sigma2 = gsw_rho(SA_south,CT_south,ref_pres_sigma2);
        rho_south_surf = gsw_rho(SA_south,CT_south,ref_pres_surf);
    
        
        %%% Plot the relaxation density
      if (showplots)
        figure(fignum);
        fignum = fignum + 1;
        clf;
        plot(rho_north_surf,-zz,'LineWidth',1.5); axis ij;
        hold on;
        if (Nr > 1)
            plot(rho_south_surf,-zz,'-','LineWidth',1.5); axis ij;
        else 
            plot(rho_south_surf,-zz,':','LineWidth',1.5); axis ij;        
        end
        hold off;
        xlabel('\rho_r_e_f (\circC)');
        ylabel('Depth (m)');
        title('Relaxation density (P_{ref} = 0)');
        legend('Northern \rho','Southern \rho','Position',[0.3200 0.6468 0.3066 0.0738]);
        set(gca,'fontsize',fontsize);
        PLOT = gcf;
        PLOT.Position = [644 148 380 562];  
      end
    
      
      %%% Plot the relaxation temperature
      if (showplots)
        figure(fignum);
        fignum = fignum + 1;
        clf;
        plot(tNorth,-zz,'LineWidth',1.5); axis ij;
        hold on;
        if (Nr > 1)
            plot(tSouth,-zz,'LineWidth',1.5); axis ij;
        else 
            plot(tSouth,-zz,'LineWidth',1.5); axis ij;        
        end
        hold off;
        xlabel('\theta_r_e_f (\circC)');
        ylabel('Depth (m)');
        title('Relaxation temperature');
        legend('Northern T','Southern T','Position',[0.3200 0.6468 0.3066 0.0738]);
        set(gca,'fontsize',fontsize);
        PLOT = gcf;
        PLOT.Position = [644 148 380 562];  
      end
        
      %%% Plot the relaxation salinity
      if (showplots)
        figure(fignum);
        fignum = fignum + 1;
        clf;
        plot(sNorth,-zz,'LineWidth',1.5);axis ij;
        hold on;
        if (Nr > 1)
            plot(sSouth,-zz,'LineWidth',1.5); axis ij;
        else 
            plot(sSouth,-zz,'LineWidth',1.5); axis ij;
        end
        hold off;
        xlabel('S_r_e_f (psu)');
        ylabel('Depth (m)');
    %     ylabel('z','Rotation',0);
        title('Relaxation salinity');
        legend('Northern S','Southern S','Position',[0.3200 0.6468 0.3066 0.0738]);
        set(gca,'fontsize',fontsize);
        PLOT = gcf;
        PLOT.Position = [644 148 380 562];  
      end
    
      
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%% DEFORMATION RADIUS %%%%%
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
        %%% Check Brunt-Vaisala frequency using full EOS
        [N2_north, pp_mid_north] = gsw_Nsquared(SA_north,CT_north,-zz,latN);
        [N2_south, pp_mid_south] = gsw_Nsquared(SA_south,CT_south,-zz,latS);
        dzData = zz(1:end-1)-zz(2:end);
    
    
        if (showplots)
          figure(fignum);
          fignum = fignum + 1;
          clf;
          semilogx(N2_north,pp_mid_north,'LineWidth',1.5);axis ij;
          hold on;
    %       semilogx(N2_south(1:zzidx),pp_mid_south(1:zzidx),'LineWidth',1.5);axis ij;
          semilogx(N2_south,pp_mid_south,'LineWidth',1.5);axis ij;
          hold off;
          legend('Northern N^2','Southern N^2','Position',[0.5181 0.6192 0.3313 0.0899]);
          xlabel('N^2 (s^-^2)');
          ylabel('Depth (m)');
    %       ylabel('z (km)','Rotation',0);
          title('Buoyancy frequency');
          set(gca,'fontsize',fontsize);
          PLOT = gcf;
          PLOT.Position = [644 148 380 562];  
        end
    
    
    
    
    
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %%%%% OBCS EASTERN BOUNDARY CONDITIONS %%%%%%%%%%%
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      %%% Define thermalcline depth at each latitude
    
      tEast = zeros(Ny,Nr);
      sEast = zeros(Ny,Nr);
    
      tEast(1,:) = tSouth;
      tEast(end,:) = tNorth;
   
      sEast(1,:) = sSouth;
      sEast(end,:) = sNorth;    
    

    
    
    
    
    
    
    
    
    
    

