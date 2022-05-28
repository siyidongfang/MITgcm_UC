
clear;close all;
addpath /Users/csi/Software/eos80_legacy_gamma_n/;
addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
addpath /Users/csi/Software/gsw_matlab_v3_06_11;
addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;
addpath /Users/csi/MITgcm_UC/analysis/colormaps/

fontsize = 14;

  Nx = 200;
  Ny = 225;
  Nr = 60;

  m1km = 1000;
  H = 4000; %%% Domain size in z 
  Lx = 600*m1km; %%% Domain size in x 
  Ly = 370*m1km; %%% Domain size in y   

  %%% Topographic parameters 

%   Wslope = 30*m1km; %%% Continental slope half-width
%   Hshelf = 800; %%% Continental shelf depth
%   Wshelf = 150*m1km; %%% Width of continental shelf
%   Ycoast = 30*m1km; %%% Latitude of coastline
%   Wcoast = 20*m1km; %%% Width of coastal wall slope
%   Yshelfbreak = Ycoast+Wshelf; %%% Latitude of shelf break
%   Yslope = Ycoast+Wshelf+Wslope; %%% Latitude of mid-continental slope
%   Ydeep = 300*m1km; %%% Latitude of deep ocean
%   Xeast = 275*m1km; %%% Longitude of eastern trough wall
%   Xwest = 125*m1km; %%% Longitude of western trough wall
%   Yicefront = 100*m1km; %%% Latitude of ice shelf face
%   Hicefront = 200; %%% Depth of ice shelf frace
%   Hbed = -300; %%% Change in bed elevation from shelf break to southern domain edge
%   Hice = Hicefront-(Hshelf-Hbed); %%% Change in ice thickness from ice fromt to southern domain edge
%   Htrough = 300; %%% Trough depth
%   Wtrough = 40*m1km; %%% Trough width
%   Xtrough = Lx/2; %%% Longitude of trough
  

  Wslope = 40*m1km; %%% Continental slope half-width
  Hshelf = 500; %%% Continental shelf depth
  Wshelf = 100*m1km; %%% Width of continental shelf
  Ycoast = 120*m1km; %%% Latitude of coastline
  Wcoast = 20*m1km; %%% Width of coastal wall slope
  Yshelfbreak = Ycoast+Wshelf; %%% Latitude of shelf break
  Yslope = Ycoast+Wshelf+Wslope; %%% Latitude of mid-continental slope
  Ydeep = Ycoast+Wshelf+Wslope*3; %%% Latitude of deep ocean
  Xeast = 400*m1km; %%% Longitude of eastern trough wall
  Xwest = 200*m1km; %%% Longitude of western trough wall
  Yicefront = 100*m1km; %%% Latitude of ice shelf face
  Hicefront = 200; %%% Depth of ice shelf frace
  Hbed = -180; %%% Change in bed elevation from shelf break to southern domain edge
  Hice = Hicefront-(Hshelf-Hbed); %%% Change in ice thickness from ice fromt to southern domain edge
  Htrough = 180; %%% Trough depth
  Wtrough = 30*m1km; %%% Trough width
  Xtrough = (Xeast+Xwest)/2; %%% Longitude of trough


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


  %%% Variable grid with high resolution at ice shelf cavity depths, very high in surface mixed layer    
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




  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% BATHYMETRY AND ICE SHELF DRAFT %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
  %%% Construct shelf/slope/deep ocean bathymetry profile via cubic
  %%% interpolation
  y_interp = [0 (Yslope-Wslope)/2 Yslope-Wslope Yslope Ydeep Ly];
  h_interp = [-Hshelf+Hbed -Hshelf+Hbed/2 -Hshelf -(Hshelf+H)/2 -H -H];
  h_profile = interp1(y_interp,h_interp,yy,'pchip');
  h = repmat(h_profile,[Nx 1]);
  
  
  %%% Add trough
  y_interp = [0 Yshelfbreak Yslope Ly];
  h_interp = [0 -Htrough 0 0];
  h_trough_profile = interp1(y_interp,h_interp,yy,'pchip');
  h_trough = repmat(h_trough_profile,[Nx 1]);
  h_trough = h_trough .* 1./(cosh((X-Xtrough)/Wtrough)).^2;
  h = h + h_trough;
  
    
  %%% Add coastal wall %%%
  h_coast = zeros(Nx,Ny);
  
  %%% Western coastline
  coastidx = (Y<Ycoast+Wcoast/2) & (Y>Ycoast-Wcoast/2) & (X<=Xwest-Wcoast/2);
  h_coast(coastidx) = h_coast(coastidx) - h(coastidx).*coastShape((Y(coastidx)-Ycoast+Wcoast/2)/Wcoast);
  landidx = find((Y<=Ycoast-Wcoast/2) & (X<=Xwest-Wcoast/2));
  h_coast(landidx) = -h(landidx);
  
  %%% Western corner
  R = sqrt((X-(Xwest-Wcoast/2)).^2+(Y-(Ycoast-Wcoast/2)).^2);
  coastidx = (Y>Ycoast-Wcoast/2) & (X>Xwest-Wcoast/2) & (R <= Wcoast);  
  h_coast(coastidx) = h_coast(coastidx) - h(coastidx).*coastShape((R(coastidx))/Wcoast);
  
  %%% Western trough wall
  coastidx = (Y<Ycoast-Wcoast/2) & (X<=Xwest+Wcoast/2) & (X>Xwest-Wcoast/2);
  h_coast(coastidx) = h_coast(coastidx) - h(coastidx).*coastShape((X(coastidx)-Xwest+Wcoast/2)/Wcoast);   
  
  %%% Eastern coastline
  coastidx = (Y<Ycoast+Wcoast/2) & (Y>Ycoast-Wcoast/2) & (X>=Xeast+Wcoast/2);
  h_coast(coastidx) = h_coast(coastidx) - h(coastidx).*coastShape((Y(coastidx)-Ycoast+Wcoast/2)/Wcoast);
  landidx = find((Y<=Ycoast-Wcoast/2) & (X>=Xeast+Wcoast/2));
  h_coast(landidx) = -h(landidx);
  
  %%% Eastern corner
  R = sqrt((X-(Xeast+Wcoast/2)).^2+(Y-(Ycoast-Wcoast/2)).^2);
  coastidx = (Y>Ycoast-Wcoast/2) & (X<Xeast+Wcoast/2) & (R <= Wcoast);  
  h_coast(coastidx) = h_coast(coastidx) - h(coastidx).*coastShape((R(coastidx))/Wcoast);
  
  %%% Eastern trough wall
  coastidx = (Y<Ycoast-Wcoast/2) & (X<Xeast+Wcoast/2) & (X>=Xeast-Wcoast/2);
  h_coast(coastidx) = h_coast(coastidx) - h(coastidx).*coastShape(-(X(coastidx)-Xeast-Wcoast/2)/Wcoast);   
  
  h = h + h_coast;

 
  %%% Construct ice shelf
  icedraft = zeros(Nx,Ny);
  iceidx = find(Y<=Yicefront);  
  icedraft(iceidx) = -Hicefront - (Y(iceidx)-Yicefront)/Yicefront * Hice;
  icedraft(icedraft<h) = h(icedraft<h);
  
  
  %%% Make sure there are no "holes" along the southern boundary, or MITgcm
  %%% will think it's supposed to be north/south periodic
  wallidx = find(icedraft(:,1)>h(:,1));
  h(wallidx,1) = icedraft(wallidx,1);
  
  %%% Remove water column thicknesses less than a specified minimum
  Hmin = 50;
  wct = icedraft - h;
  h(wct < Hmin) = icedraft(wct < Hmin);


  
      figure(15);
    clf;
    surf(X/1000,Y/1000,h,'EdgeColor','None');   
    xlabel('x (km)');
    ylabel('y (km)');
    zlabel('hb','Rotation',0);
%     plot(Y(1,:),h(1,:));
    title('Model bathymetry');
    set(gca,'fontsize',fontsize+2);
    PLOT = gcf;
    PLOT.Position = [248 284 655 442];  
    

  %%% Plot bathymetry and ice draft
  figure(1)
  clf;    

  %%% Bathymetry  
  p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,h(:,2:end-1));
  p.FaceColor = [11*16+9 9*16+12 6*16+11]/255;
  p.EdgeColor = 'none';

  %%% Modified ice draft to look good in the plot
  icedraft_plot = icedraft;
  icedraft_plot(icedraft==0) = NaN;
  icetop_plot = 0*icedraft_plot;
  for i=1:Nx
    j = find(~isnan(icetop_plot(i,:)),1,'last');
    if (isempty(j))
      continue;
    else
      icetop_plot(i,j+1) = max(-Hicefront,h(i,j+1));
    end
  end
 
  %%% Plot ice
  hold on;
  p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,icedraft_plot(:,2:end-1));
  p.FaceColor = [153, 255, 255]/255;
  p.EdgeColor = 'none';
  p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,icetop_plot(:,2:end-1));
  p.FaceColor = [153, 255, 255]/255;
  p.EdgeColor = 'none';
  hold off;

  
  %%% Decorations
  view(-206,14);
  xlabel('x (km)','interpreter','latex');
  ylabel('y (km)','interpreter','latex');
  zlabel('z (m)','interpreter','latex');
  axis tight;
  pbaspect([Lx/Ly 1 1]);
  camlight('headlight');
  lightangle(-206,34);
  lighting flat;

%  imgpath = '/Users/csi/MITgcm_UC/figures_uc/model/';
%  savefig([imgpath '/model_UC.fig']);
%  saveas(gcf,[imgpath '/model_UC.png']);



showplots = true;
fignum = 2;
fontsize = 16;




%%

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% EASTERN BOUNDARY %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%

  s_bot = 34.65; 
  pt_bot = -0.3;
  s_mid = 34.75;
  pt_mid = 2; 
  s_surf = 33.95;
  pt_surf = -1.86; 
  Zsml = -50;  %%% Depth of the surface mixed layer

  tEast = zeros(Ny,Nr);
  sEast = zeros(Ny,Nr);
  uEast = zeros(Ny,Nr);
  N2_east = zeros(Ny,Nr-1);
  gamma_n_east = zeros(Ny,Nr);
  depth_East_pt = zeros(Ny,5);
  depth_East_s  = zeros(Ny,5);


  Zcdw_pt_North = -380; %%% CDW depth at the southern boundary
  Zcdw_pt_deep = Zcdw_pt_North-20;
  Zcdw_pt_shelfbreak = -530; %%% CDW depth over the shelf
  Zcdw_pt_South = Zcdw_pt_shelfbreak - 150;
  
  lat_Zcdw_pt = [0 Yshelfbreak Ydeep Ly];
  Zcdw_pt_2 = [Zcdw_pt_South Zcdw_pt_shelfbreak Zcdw_pt_deep Zcdw_pt_North]; %%% Piecewise function

  Zcdw_pt = interp1(lat_Zcdw_pt,Zcdw_pt_2,yy,'PCHIP'); 
  Zcdw_s = Zcdw_pt - 100;


  %%% Artificially construct a hydrographic profile
  ptemp_East = [pt_bot (pt_bot+pt_mid)/2 pt_mid pt_surf pt_surf];
  salt_East = [s_bot (s_bot+s_mid)/2 s_mid s_surf s_surf];
 
  
  %%% Interpolate to model grid
  for jj = 1:Ny
      depth_East_pt(jj,:) = [-H (-H+3*Zcdw_pt(jj))/4 Zcdw_pt(jj) Zsml 0];
      depth_East_s(jj,:) = [-H (-H+3*Zcdw_s(jj))/4 Zcdw_s(jj) Zsml 0];
      tEast(jj,:) = interp1(depth_East_pt(jj,:),ptemp_East,zz,'PCHIP'); %%% reference pressure level: sea surface
      sEast(jj,:) = interp1(depth_East_s(jj,:),salt_East,zz,'PCHIP');  %%% reference pressure level: sea surface 
  end

  lon_sec = -115;
  lat_sec = -71;

  %%% Calculate the neutral density of the eastern boundary
  [ZZ,YY] = meshgrid(zz,yy);
  [SA_east, in_ocean] = gsw_SA_from_SP(sEast,-ZZ,lon_sec,lat_sec);
  T_insitu = gsw_t_from_pt0(SA_east,tEast,-ZZ);
  CT_east = gsw_CT_from_pt(SA_east,tEast); 

  for jj = 1:Ny
      [gamma_n_east(jj,:)] = eos80_legacy_gamma_n(sEast(jj,:),T_insitu(jj,:),-zz,lon_sec,lat_sec);
      [N2_east(jj,:), pp_mid_east] = gsw_Nsquared(SA_east(jj,:),CT_east(jj,:),-zz,lat_sec);
  end


  bathy_east = ones(Ny,Nr);
  for jj = 1:Ny
      for kk = 1:Nr
          if(zz(kk)<h(kk,jj))
              bathy_east(jj,kk)=NaN;
          end
      end
  end


  %%% Calculate thermal-wind velocity and wind-driven velocity, assuming vEast==0 and zero bottom velocity.
    uEast = zeros(Ny,Nr);
    uEast_TWV = zeros(Ny,Nr); %%% Thermal-wind velocity
    uEast_EK = zeros(Ny,Nr);  %%% Wind-driven velocity, based on Ekman theory

    %%%%%% Calculate thermal-wind velocity
    bot_idx = zeros(Ny,1);
    for jj = 1:Ny
        if(find(isnan(bathy_east(jj,:)),1,'first')==1)
            bot_idx(jj) = NaN;
        elseif (find(isnan(bathy_east(jj,:)),1,'first')>1)
            bot_idx(jj) = find(isnan(bathy_east(jj,:)),1,'first')-1;
        else
            bot_idx(jj) = Nr;
        end
    end

    g = 9.81;
    rho0 = 1000;
    f0 = -1.3e-4; %%% Coriolis parameter
    beta = 1e-11; %%% Beta parameter  
    

    f = f0+beta*YY;
    f_mid = (f(2:end,:)+f(1:end-1,:))/2;

    rho_east_insitu  = gsw_rho(SA_east,CT_east,-zz); %%% in-situ density
    drhody = (rho_east_insitu(2:end,:)-rho_east_insitu(1:end-1,:))./dy(1);
    uEast_mid = g/rho0./f_mid.*cumsum(drhody.*dz,2,'reverse');
    uEast_TWV(2:end-1,:) = (uEast_mid(1:end-1,:)+uEast_mid(2:end,:))/2; %%% Thermal-wind velocity


    %     %%%%%% Calculate wind-driven velocity in the surface Ekman layer
    %     A_z = 0.1; 
    %     D_EK = sqrt(2*pi^2*A_z./abs(f(:,1))); %%% Ekman-layer depth for each latitude
    %     for jj=1:Ny
    %         D_EK_idx(jj,1) = max(find(zz>=-D_EK(jj))); %%% Vertical index of Ekman-layer for each latitude
    %     end
    % 
    %     rho_a = 1.3; 
    %     C_ao = 1e-3; %%% Air-ocean drag coefficient
    %     rho_o = 1027;
    % 
    %     Ua = -1;Va=0.5;
    %     uwind = [Ua:-Ua/(Ny-1):0].*ones(Nx,1); 
    %     vwind = [Va:-Va/(Ny-1):0].*ones(Nx,1); 
    %     tau_wind = rho_a*C_ao*abs(uwind(1,:).^2+vwind(1,:).^2)'; %%% Total surface wind stress
    %     a_EK = sqrt(abs(f(:,1))/2/A_z); %%% Constant 'a' in Ekman theory
    %     V0_EK = tau_wind./sqrt(rho_o.^2.*abs(f(:,1))*A_z);
    % 
    %     angle_uvwind = atan(abs(Va/Ua))/pi*180; %%% Angle of zonal and meridional wind, in degrees
    % 
    %     for jj = 1:Ny
    %         for kk=1:D_EK_idx(jj)
    %             az = a_EK(jj)*zz(kk);
    %             v_ek(jj,kk) = V0_EK(jj)*exp(az)*cos(pi/4+az); %%% Ekman velocity aligned with the direction of the surface wind stress
    %             u_ek(jj,kk) = V0_EK(jj)*exp(az)*sin(pi/4+az); %%% Ekman velocity perpendicular to the direction of the surface wind stress
    %             uEast_EK(jj,kk) = -(v_ek(jj,kk)*cos(angle_uvwind)+u_ek(jj,kk)*sin(angle_uvwind)); %%% Ekman velocity in the zonal direction
    %         end
    %     end

    %%% Prescribe zonal velocity at the eastern boundary as the sum of wind-driven velocity 
    %%% in the Ekman layer and thermal-wind velocity
    %     uEast = uEast_TWV + uEast_EK; 
    uEast = uEast_TWV;

    figure(23)
    pcolor(yy/1000,-zz/1000,uEast'.*bathy_east')
    shading flat;axis ij;
    hold on;[M,c] = contour(YY/1000,-ZZ/1000,gamma_n_east.*bathy_east,[27:0.2:27.8 27.95:0.05:28.3],'LineColor','k','LineWidth',1);
    clabel(M,c,'LabelSpacing',200);hold off;
    hold on;plot(yy/1000,-h(1,:)/1000,'k','LineWidth',3);plot(yy/1000,-h(round(Nx/2),:)/1000,'k--','LineWidth',3);
    colorbar;colormap('redblue');
    xlabel('y (km)');ylabel('Depth (km)');
    title('Eastern boundary restoring velocity (m/s)');
    set(gca,'fontsize',fontsize);
    caxis([-0.03 0.03]);





  figure(20)
  subplot(1,2,1)
  pcolor(yy/1000,-zz/1000,tEast'.*bathy_east')
  shading flat;axis ij;
  hold on;[M,c] = contour(YY/1000,-ZZ/1000,gamma_n_east.*bathy_east,[27:0.2:27.8 27.95:0.05:28.3],'LineColor','k','LineWidth',1);
  clabel(M,c,'LabelSpacing',200);hold off;
  hold on;plot(yy/1000,-h(1,:)/1000,'k','LineWidth',3);plot(yy/1000,-h(round(Nx/2),:)/1000,'k--','LineWidth',3);
  colorbar;colormap(jet);
  xlabel('y (km)');ylabel('Depth (km)');
  title('Eastern boundary restoring temperature (^oC)');
  set(gca,'fontsize',fontsize);
  caxis([-2 2])
  subplot(1,2,2)
  pcolor(yy/1000,-zz/1000,sEast'.*bathy_east')
  shading flat;axis ij;
  hold on;[M,c] = contour(YY/1000,-ZZ/1000,gamma_n_east.*bathy_east,[27:0.2:27.8 27.95:0.05:28.3],'LineColor','k','LineWidth',1);
  clabel(M,c,'LabelSpacing',200);hold off;
  hold on;plot(yy/1000,-h(1,:)/1000,'k','LineWidth',3);plot(yy/1000,-h(round(Nx/2),:)/1000,'k--','LineWidth',3);
  colorbar;colormap(jet);
  xlabel('y (km)');ylabel('Depth (km)');
  title('Eastern boundary restoring salinity (psu)');
  set(gca,'fontsize',fontsize);
  caxis([33.3 34.7])
  set(gcf,'Position',[-54 249 1285 459]);



  figure(21)
  bathy_mid = (bathy_east(:,[1:end-1])+bathy_east(:,[2:end]))/2;
  pcolor(yy/1000,pp_mid_east/1000,N2_east'.*bathy_mid')
  shading flat;axis ij;
  hold on;[M,c] = contour(YY/1000,-ZZ/1000,gamma_n_east.*bathy_east,[27:0.2:27.8 27.95:0.05:28.3],'LineColor','k','LineWidth',1);
  clabel(M,c,'LabelSpacing',200);hold off;
  hold on;plot(yy/1000,-h(1,:)/1000,'k','LineWidth',3);plot(yy/1000,-h(round(Nx/2),:)/1000,'k--','LineWidth',3);
  colorbar;colormap('default');
  caxis([0 3]/1e5)
  xlabel('y (km)');ylabel('Depth (km)');
  title('Eastern boundary N^2');
  set(gca,'fontsize',fontsize);
  set(gcf,'Position',[-54 249 1285/2 459]);


  figure(22)
  plot(yy/1000,Zcdw_pt,'LineWidth',2)
  hold on
  plot(yy/1000,Zcdw_s,'LineWidth',2)
  hold off;
  ylabel('z (m)')
  xlabel('y (km)')
  legend('Depth of \theta_{max}','Depth of S_{max}')
  set(gca,'fontsize',fontsize);
  title('Eastern boundary CDW depth')



  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% NORTHERN TEMPERATURE/SALINITY PROFILES %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
  tNorth = tEast(end,:);
  sNorth = sEast(end,:);



  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% SOUTHERN TEMPERATURE/SALINITY PROFILES %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  tSouth = tEast(1,:);
  sSouth = sEast(1,:);

  useFresher = false;
  if(useFresher)
    sSouth = sSouth-0.5;
  end


%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% Calculate density and make plots %%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        ref_pres_surf = 0; 
        ref_pres_sigma4 = 4000;
        ref_pres_sigma2 = 2000;
    
        lon_sec = -115;
        latS = -71.5;
        latN = -67;
    
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
    

        Umax = max(max(abs(uEast)))






%%% Specifies shape of coastal walls. Must satisfy f=1 at x=0 and f=0 at
%%% x=1.
%%%
function f = coastShape (x)
 
  f = 0.5.*(1+cos(pi*x));
%   f = exp(-x);
%   f = 1-x;
  
end

