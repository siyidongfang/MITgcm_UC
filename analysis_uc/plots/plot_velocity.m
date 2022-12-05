%%%
%%% plot_velocity.m
%%%
%%% Plot the boundary restoring velocity and mean zonal velocity
%%%


    clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    load_colors;
    n =1; % Load the reference experiment
    expname = EXPNAME{n}
    loadexp;
    fontsize = 17;
    ncolor=250; % Number of color contours
    m1km = 1000;
    load_data;

    nIter = 1298541;

    calc_basics;
    u_boundary = squeeze(uu(1,:,:));
    u_boundary(u_boundary==0)=NaN;

    subplotsize = [0.85 0.38];





Ua = -5;      %%% Reference value -5 (-4 with no ice shelf)
Va = 5;       %%% Reference value 5  ( 4 with no ice shelf)
Atide = 0;    %%% Reference value 0.02 (based on Jourdain et al. 2019)
Hi0 =1;       %%% Reference value 1
Ai0 =1;       %%% Reference value 1
m1km = 1000;
Ws =30*m1km;      %%% Reference value 30km, continental slope half-width

Hbed = 300;   %%% Change in bed elevation from shelf break to southern domain edge, ref 300
Htr = 200;    %%% Trough depth, ref 200
Zn = 350;     %%% CDW depth (thermocline) at the Northern boundary, ref 350
Zsb = 550;    %%% CDW depth (thermocline) over the shelf break, ref 550 (deeper: 750)
dZs = 150;    %%% The change in CDW depth from the shelfbreak to the Southern boundary (y=0), ref 150  (deeper: 250)


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% EASTERN BOUNDARY %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%

  s_bot = 34.65; 
  pt_bot = -0.3;
  s_mid = 34.75;
  pt_mid = 2; 
  s_surf = 33.95-0.25;
  pt_surf = -1.86; 
  Zsml = -50;  %%% Depth of the surface mixed layer

  tEast = zeros(Ny,Nr);
  sEast = zeros(Ny,Nr);
  uEast = zeros(Ny,Nr);
  N2_east = zeros(Ny,Nr-1);
  gamma_n_east = zeros(Ny,Nr);
  depth_East_pt = zeros(Ny,6);
  depth_East_s  = zeros(Ny,6);

  Zcdw_pt_deep = -Zn-20;
  Zcdw_pt_South = -Zsb - dZs;

  lat_Zcdw_pt = [0 Yshelfbreak Ydeep Ly];
  Zcdw_pt_2 = [Zcdw_pt_South -Zsb Zcdw_pt_deep -Zn]; %%% Piecewise function

  Zcdw_pt = interp1(lat_Zcdw_pt,Zcdw_pt_2,yy,'PCHIP'); 
  Zcdw_s = Zcdw_pt - 100; %%% This is important - salinity maximum needs to 
                          %%% be deeper or else you end up with very weak 
                          %%% buoyancy frequency just below the pycnocline

  dz_flat =250;
  yidx_sb = round(Yshelfbreak/delY(1));

  ds_flat = (s_mid - (s_bot+s_mid)/2)* dz_flat /(abs((-H+3*mean(Zcdw_s))/4)-abs(Zcdw_s(yidx_sb)));
  dpt_flat = (pt_mid - (pt_bot+pt_mid)/2)* dz_flat /(abs((-H+3*mean(Zcdw_pt))/4)-abs(Zcdw_pt(yidx_sb)));
 
  ptemp_East = [pt_bot (pt_bot+pt_mid)/2  pt_mid-dpt_flat  pt_mid pt_surf pt_surf];
  salt_East  = [s_bot  (s_bot+s_mid)/2    s_mid-ds_flat   s_mid   s_surf  s_surf];


  %%% Interpolate to model grid
  for jj = 1:Ny
      depth_East_pt(jj,:) = [-H  (-H+3*mean(Zcdw_pt))/4  Zcdw_pt(yidx_sb)-dz_flat  Zcdw_pt(jj)  Zsml 0];
      depth_East_s(jj,:)  = [-H  (-H+3*mean(Zcdw_s))/4   Zcdw_s(yidx_sb)-dz_flat   Zcdw_s(jj)   Zsml 0];
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
          if(zz(kk)<bathy(end,jj))
              bathy_east(jj,kk)=NaN;
          end
      end
  end


  %%% Calculate thermal-wind velocity and wind-driven velocity, assuming vEast==0 and zero bottom velocity.
    uEast_TWV = zeros(Ny,Nr); %%% Thermal-wind velocity

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

    rho0 = 1000;
    f = f0+beta*YY;
    f_mid = (f(2:end,:)+f(1:end-1,:))/2;

    rho_east_insitu  = gsw_rho(SA_east,CT_east,-zz); %%% in-situ density
    drhody = (rho_east_insitu(2:end,:)-rho_east_insitu(1:end-1,:))./delY(1);
    uEast_mid = gravity/rho0./f_mid.*cumsum(drhody.*delR,2,'reverse');
    uEast_TWV(2:end-1,:) = (uEast_mid(1:end-1,:)+uEast_mid(2:end,:))/2; %%% Thermal-wind velocity
    uEast = uEast_TWV;



    figure(1)
    set(gcf,'Position',[1  107 500 700])
%     clf;    

    ax1 = subplot('position',[0.1 0.58 subplotsize]);
    annotation('textbox',[0.015 0.955 0.05 0.05],'String','(b)','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');
    
    pcolor(yy/1000,-zz/1000,uEast'.*bathy_east')
    shading flat;axis ij;
    hold on;[M,c] = contour(YY/1000,-ZZ/1000,gamma_n_east.*bathy_east,[27:0.2:27.8 27.95:0.05:28.3],'LineColor','k','LineWidth',1);
    clabel(M,c,'LabelSpacing',200);hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',3);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',3);
    colormap(mycolormap);colorbar
    clim([-0.06 0.06])
    title('Zonal boundary restoring velocity (m/s)')
    ylabel('Depth (km)');xlabel('y (km)')
    set(gca,'XTick',[0:100:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);
    set(gca,'FontSize',fontsize);

    ax2 = subplot('position',[0.1 0.08 subplotsize]);
    annotation('textbox',[0.015 0.455 0.05 0.05],'String','(c)','FontSize',fontsize+2,'LineStyle','None','fontweight', 'bold');

    pcolor(yy/1000,-zz/1000,uu_xmean');
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
    hold on;[M,c] = contour(YY_yz/1000,-ZZ_yz/1000,gamma_n_xmean,[27:0.2:27.8 27.95:0.05:28.3],'LineColor','k','LineWidth',1);
    clabel(M,c,'LabelSpacing',200);hold off;
    shading interp;axis ij;colormap(mycolormap);colorbar
    clim([-0.05 0.05])
    title('Zonal-mean zonal velocity (m/s)')
    ylabel('Depth (km)');xlabel('y (km)')
    set(gca,'XTick',[0:20:300 round(Ly/1000)]);
    set(gca,'YTick',[0:1:4]);
    ylim([0.25 2])
    xlim([190 270])
    set(gca,'FontSize',fontsize);




