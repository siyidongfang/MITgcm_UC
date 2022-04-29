clear;
addpath ../.
addpath ../utils/matlab; 
addpath ../analysis/colormaps;
addpath ../analysis/jpo_analysis-hires/;
expdir = '/Users/csi/MITgcm_UC/exps_test/';
expname = 'res2km_Ua-1Va0.5_Atide0_Hi0Ai0_Ws30_fresher0.5psu_hoffman2';
loadexp;
nIter = 13593;

[ZZ,YY] = meshgrid(zz,yy);

    figure(11)
    subplot(1,2,1)
    aaaa1 = rdmds([exppath,'/results/SALT'],nIter);
    aaa1 = squeeze(mean(aaaa1));
    aaa1(aaa1==0)=NaN;
%     aaa1 = squeeze(aaaa1(:,:,3));
    pcolor(yy/1000,-zz/1000,aaa1')
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,aaa1,[32:0.1:35],'EdgeColor','k');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(40,:)/1000,'k','LineWidth',1.5);

    shading interp;
    axis ij;colormap('jet');colorbar
    caxis([33.8 34.7]);
    xlim([0 450])
    title('Salinity (psu)')
    ylabel('z (km)');xlabel('y (km)')
    set(gca,'FontSize',15)

    

    subplot(1,2,2)
    aaaa1 = rdmds([exppath,'/results/THETA'],nIter);
    aaa1 = squeeze(mean(aaaa1));
    pcolor(yy/1000,-zz/1000,aaa1');
    hold on;[C,h]=contour(YY/1000,-ZZ/1000,aaa1,[-4:0.4:4],'EdgeColor','k');hold off;
    hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(40,:)/1000,'k','LineWidth',1.5);

    shading interp;
    axis ij;
    colormap('redblue');
    colorbar
    caxis([-4 4]);xlim([0 450])
    title('Potential temperature (degC)')
    ylabel('z (km)');xlabel('y (km)')
 set(gca,'FontSize',15)
   

% figure(3)
% bb = rdmds([exppath,'/results/SIheff'],nIter);
% pcolor(bb')
% shading interp;axis ij;colormap('gray');colorbar;
% caxis([0 1])






figure(1)
clf;
subplot(2,2,1)
aaaa1 = rdmds([exppath,'/results/UVEL'],nIter);
aaaa1(aaaa1==0)=NaN;
aaa1 = squeeze(nanmean(aaaa1));
pcolor(yy/1000,-zz/1000,aaa1');
hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(40,:)/1000,'k','LineWidth',1.5);
shading interp;axis ij;colormap('redblue');colorbar
caxis([-0.4 0.4])
title('Transient zonal velociy (m/s)')
ylabel('z (km)');xlabel('y (km)')
 set(gca,'FontSize',15)


% subplot(2,2,2)
% aaaa1 = rdmds([exppath,'/results/T'],nIter);
% aaa1 = squeeze(mean(aaaa1));
% pcolor(yy/1000,-zz/1000,aaa1')
% hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
% shading interp;axis ij;colormap('redblue');colorbar
% caxis([-1.8 1.8])
% title('Potential temperature (degC)')
% ylabel('z (km)');xlabel('y (km)')

%%
subplot(2,2,3)
aaaa1 = rdmds([exppath,'/results/VVELTH'],nIter);
aaa1 = squeeze(mean(aaaa1));
pcolor(yy/1000,-zz/1000,aaa1')
hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
shading interp;axis ij;colormap('redblue');colorbar
caxis([-0.01 0.01])
title('Advective heat flux (degC.m/s)')
ylabel('z (km)');xlabel('y (km)')

subplot(2,2,4)
rho_o = 1037;
Lx = 400000;
cp_o = 3850;
VVELTH =  rdmds([exppath,'/results/VVELTH'],nIter);
DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
VVELTH_zint = sum(VVELTH.*DZ.*hFacS,3); %%% Depth-integrated 
VVELTH_zint_xavg = squeeze(nanmean(VVELTH_zint));%%% Zonally averaged, depth-integrated 
plot(yy/1000,cp_o*rho_o*Lx*VVELTH_zint_xavg/10^12,'LineWidth',1.5)
title('Meridional Heat Transport')
ylabel('(10$^{12}$ W)','interpreter','latex');
xlabel('y (km)')
ylim([-1 0.5])
outdir = '/Users/csi/MITgcm_ASF-csi/cross_slope_exchange/test_exps_new/'
% print('-dpng','-r150',[outdir expname '_' num2str(nIter) '.png']);
% print('-dpng','-r150',[outdir expname '.png']);



% 
% figure(2)
% bb = rdmds([exppath,'/results/SIheff'],nIter);
% pcolor(bb')
% shading interp;axis ij;colormap('default');colorbar
























%%

THETA = rdmds([exppath,'/results/THETA'],nIter);
SALT = rdmds([exppath,'/results/SALT'],nIter);
PHIHYD = rdmds([exppath,'/results/PHIHYD'],nIter);
THETA(THETA==0)=NaN;
SALT(SALT==0)=NaN;
PHIHYD(PHIHYD==0)=NaN;

  g=9.81;
  rhoConst = 999.8;
  refdepth = -zz(layers_krho(1));
  refpress = rhoConst*(g*refdepth + PHIHYD(:,:,layers_krho(1)))/1e4; %%% unit: dbar
  for kk = 1:Nr
      pt_tavg(:,:,kk) = densmdjwf(SALT(:,:,kk),THETA(:,:,kk),refpress)-1000;
  end

 
  %%
test_bounds = [0 30 36.4 36.54:0.02:36.66 36.7 36.73 36.76 36.8:0.1:37.1 37.13:0.02:37.17 37.19:0.004:37.206 ...
    37.21:0.003:37.29 ...
    37.295:0.015:37.4 ...
    37.41 37.42 37.422:0.003:37.425 37.426 37.428 37.429 37.43 37.45 37.5 40]
     
figure(7)
clf;
pt_xavg = squeeze(nanmean(pt_tavg));
pcolor(yy/1000,-zz/1000,pt_xavg');axis ij;
shading interp;axis ij;colormap('jet');colorbar
hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(50,:)/1000,'k','LineWidth',1.5);
contour(yy/1000,-zz/1000,pt_xavg',test_bounds,'EdgeColor','w');
contour(yy/1000,-zz/1000,pt_xavg',36.7:0.1:37.1,'EdgeColor','k');hold off;
caxis([36.5 37.6])

%% Test: overturning circulation

loadexp;


  %%% Density bins for MOC calculation  
  ptlevs = flip(layers_bounds(:,1));
  Npt = length(ptlevs)-1;
 
  %%% Frequency of diagnostic output - should match that specified in
  %%% data.diagnostics.
  dumpFreq = abs(diag_frequency(1));
  nDumps = round(nTimeSteps*deltaT/dumpFreq);
  dumpIters = round((1:nDumps)*dumpFreq/deltaT);
  dumpIters = dumpIters(dumpIters > nIter0);
 
  %%% Create a finer vertical grid
  ffac = 10;
  Nrf = ffac*Nr;
  delRf = zeros(1,Nrf); 
  for n=1:Nr
    for m=1:ffac
      delRf((n-1)*ffac+m) = delR(n)/ffac;
    end
  end
  zz = - cumsum((delR + [0 delR(1:Nr-1)])/2);
  zz_f = - cumsum((delRf + [0 delRf(1:Nrf-1)])/2);
 
  %%% Partial cell heights on fine grid
  hFacS_f = zeros(Nx,Ny,Nrf);
  for k=1:Nr
    hFacS_f(:,:,ffac*(k-1)+1:ffac*k) = hFacS(:,:,k*ones(1,ffac));              
  end
 
  %%% Grid of actual vertical positions, accounting for partial cells
  ZZ = zeros(Nx,Ny,Nr);
  ZZ_f = zeros(Nx,Ny,Nrf);
  DZ = zeros(Nx,Ny,Nr);
  DZ_f = zeros(Nx,Ny,Nrf);
  PP = zeros(Nx,Ny,Nr);
  ZZ(:,:,1) = - delR(1)*hFacS(:,:,1)/2;
  for k=2:Nr
    ZZ(:,:,k) = ZZ(:,:,k-1) - 0.5*delR(k-1)*hFacS(:,:,k-1) - 0.5*delR(k)*hFacS(:,:,k);
  end       
  ZZ_f(:,:,1) = - delRf(1)*hFacS_f(:,:,1)/2;
  for k=2:Nrf 
    ZZ_f(:,:,k) = ZZ_f(:,:,k-1) - 0.5*delRf(k-1)*hFacS_f(:,:,k-1) - 0.5*delRf(k)*hFacS_f(:,:,k);      
  end
  for k=1:Nr
    DZ(:,:,k) = delR(k);
  end   
  for k=1:Nrf
    DZ_f(:,:,k) = delRf(k);
  end   
  for k=1:Nr
    PP(:,:,k) = -delR(k);
  end   
 
  %%% Matrices for vertical interpolation  
  k_p = zeros(Nx,Ny,Nrf);
  k_n = zeros(Nx,Ny,Nrf);
  w_n = zeros(Nx,Ny,Nrf);
  w_p = zeros(Nx,Ny,Nrf);
  is_wet_col = zeros(Nx,Ny);
  for i=1:Nx
    for j=1:Ny
 
      %%% Indices of the lowest cells
      kmax = sum(squeeze(hFacS(i,j,:))~=0);
      kmax_f = ffac*kmax;
      is_wet_col(i,j) = (kmax~=0);
 
      for k=1:Nrf
 
        %%% Previous and next interpolation indices
        k_p(i,j,k) = ceil(k/ffac-0.5);
        k_n(i,j,k) = k_p(i,j,k) + 1;
 
        %%% Fine grid cell is above highest coarse grid cell, so fine grid
        %%% gamma will just be set equal to uppermost coarse grid gamma
        if (k_p(i,j,k) <= 0)
 
          k_p(i,j,k) = 1;
          w_p(i,j,k) = 0;
          w_n(i,j,k) = 1;
 
        else
 
          %%% Fine grid cell is below lowest coarse grid cell, so fine grid
          %%% gamma will just be set equal to lowermost coarse grid gamma
          if (k_n(i,j,k) > kmax)
 
            k_n(i,j,k) = kmax;
            w_n(i,j,k) = 0;
            w_p(i,j,k) = 1;
 
          %%% Otherwise set weights to interpolate linearly between neighboring
          %%% coarse-grid gammas
          else
 
            w_p(i,j,k) = (ZZ(i,j,k_n(i,j,k))-ZZ_f(i,j,k))./(ZZ(i,j,k_n(i,j,k))-ZZ(i,j,k_p(i,j,k)));
            w_n(i,j,k) = 1 - w_p(i,j,k);
 
          end
 
        end
 
      end
 
    end
  end
 
  %%% Calculate time-averaged isopycnal flux, density and velocity 
%   load([prodir expname '_tavg_5yrs.mat'],'LaVH1RHO','LaHs1RHO','VVEL','THETA','SALT','PHIHYD');
 LaVH1RHO = rdmds([exppath,'/results/LaVH1RHO'],nIter);
 LaHs1RHO = rdmds([exppath,'/results/LaHs1RHO'],nIter);
 VVEL = rdmds([exppath,'/results/VVEL'],nIter);
 THETA = rdmds([exppath,'/results/THETA'],nIter);
 SALT = rdmds([exppath,'/results/SALT'],nIter);
 PHIHYD = rdmds([exppath,'/results/PHIHYD'],nIter);


  vflux_tavg = flip(LaVH1RHO,3);  
  h_pt_tavg = flip(LaHs1RHO,3);   
  vvel_tavg = VVEL;  
  temp_tavg = THETA;  
  salt_tavg = SALT;    
  pressure_tavg =PHIHYD; 
   
%   temp_tavg(SALT==0) = NaN;
%   salt_tavg(SALT==0) = NaN;
%   pressure_tavg(SALT==0) = NaN;

  %%% Calculate the potential density pt
  g=9.81;
  rhoConst = 999.8;
  refdepth = -zz(layers_krho(1));
  refpress = rhoConst*(g*refdepth + pressure_tavg(:,:,layers_krho(1)))/1e4; %%% unit: dbar
  
   
  for kk = 1:Nr
      pt_tavg(:,:,kk) = densmdjwf(salt_tavg(:,:,kk),temp_tavg(:,:,kk),refpress)-1000;
  end
  
  
  pt_tavg(SALT==0) = NaN;

 
  %%% Interpolate potential temperature to v-gridpoints  
  pt_v = NaN*pt_tavg;
  pt_v(:,2:Ny,:) = 0.5* (pt_tavg(:,1:Ny-1,:) + pt_tavg(:,2:Ny,:));    
 
  %%% Interpolate onto a finer grid         
  vvel_f = zeros(Nx,Ny,Nrf);
  pt_f = NaN*zeros(Nx,Ny,Nrf);
  if (ffac == 1)
 
    %%% Shortcut if fine grid resolution = coarse grid resolution
    vvel_f = vvel_tavg;        
    pt_f = pt_v;
 
  else   
 
    %%% Velocity uniform throughout each coarse grid cell to preserve
    %%% mass conservation
    for k=1:Nr
      vvel_f(:,:,ffac*(k-1)+1:ffac*k) = vvel_tavg(:,:,k*ones(1,ffac));          
    end
 
    %%% Linearly interpolate density
    for i=1:Nx
      for j=1:Ny %%% Restrict to wet grid cells  
        if (is_wet_col(i,j))
          pt_f(i,j,:) = w_p(i,j,:).*pt_v(i,j,squeeze(k_p(i,j,:))) + w_n(i,j,:).*pt_v(i,j,squeeze(k_n(i,j,:)));
        end
      end
    end
 
  end            
 
  %%% Calculate mean fluxes within mean density surfaces
  vflux_m = 0*vflux_tavg;
  vdz = vvel_f.*hFacS_f.*DZ_f;
%   flip_ptlevs = flip(ptlevs);
  vflux_m(:,:,Npt) = vflux_m(:,:,Npt) + sum(vdz.*(pt_f<ptlevs(Npt)),3);
  vflux_m(:,:,1) = vflux_m(:,:,1) + sum(vdz.*(pt_f>=ptlevs(2)),3);
  for m=2:Npt-1
    vflux_m(:,:,m) = vflux_m(:,:,m) + sum(vdz.*((pt_f<ptlevs(m)) & (pt_f>=ptlevs(m+1))),3);
  end   
  
  
  %%% Zonally integrate meridional fluxes
  vflux_xint = zeros(Ny,Npt);
  vflux_m_xint = zeros(Ny,Npt);
  for i=1:Nx
    vflux_xint = vflux_xint + delX(i)*squeeze(vflux_tavg(i,:,:));
    vflux_m_xint = vflux_m_xint + delX(i)*squeeze(vflux_m(i,:,:));
  end
 
%   vflux_m_xint = flip(vflux_m_xint,2);
  
  %%% Sum fluxes to obtain streamfunction
  psi_pt = zeros(Ny,Npt+1);
  psim_pt = zeros(Ny,Npt+1);
  for m=1:Npt  
    psi_pt(:,m) = sum(vflux_xint(:,m:Npt),2);     
    psim_pt(:,m) = sum(vflux_m_xint(:,m:Npt),2);     
  end
  psi_pt = psi_pt/1e6;
  psim_pt = psim_pt/1e6;
  psie_pt = psi_pt - psim_pt;
 
  %%% Calculate mean density surface heights
  h_pt_xtavg = squeeze(nanmean(h_pt_tavg));
  z_pt = 0*h_pt_xtavg;
  for m=1:Npt
    z_pt(:,m) = - sum(h_pt_xtavg(:,1:m-1),2);
  end
  
  
  %%% Calculate zonal-mean potential temperature
  pt_xtavg = squeeze(nanmean(pt_tavg(:,:,:)));
  pt_f_xtavg = squeeze(nanmean(pt_f(:,:,:)));
  
%   figure(13)
%     PSIlim=[-1.5 1.5];    YLIM = [36.4 37.5];
%     subplot(1,3,1)
%     pcolor(yy/1000,ptlevs,psi_pt');
%     shading interp;colormap('redblue');colorbar;caxis(PSIlim);axis ij;
%     ylim(YLIM);
%     xlabel('y (km)');ylabel('Potential density (kg/m^3)');
%     title('\psi (Sv) in PT space')
%     subplot(1,3,2)
%     pcolor(yy/1000,ptlevs,psim_pt');
%     shading interp;colormap('redblue');colorbar;caxis(PSIlim);axis ij;
%     xlabel('y (km)');ylabel('z (m)');    ylim(YLIM);
%     title('\psi_{mean} (Sv) in PT space')
%     subplot(1,3,3)
%     pcolor(yy/1000,ptlevs,psie_pt');
%     shading interp;colormap('redblue');colorbar;caxis(PSIlim);axis ij;
%     xlabel('y (km)');ylabel('z (m)');    ylim(YLIM);
%     title('\psi_{eddy} (Sv) in PT space')
  
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%% CALCULATE ISOPYCNAL DEPTHS %%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 

    Aocean = zeros(Ny,Nr+1);
    Aisop = zeros(Ny,Npt+1);

    %%% Grid spacing matrices
    DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
    DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    DX_xypt = repmat(reshape(delX,[Nx 1 1]),[1 Ny Npt]);


    Aocean_xint = squeeze(sum(DX_xyz.*DZ_xyz.*hFacS,1)); %%% Integrate the ocean area in the x-direction, on v-grid
    Aocean(:,1:Nr) = cumsum(Aocean_xint,2,'reverse'); %%% Integrate the ocean area in the z-direction from bottom to top

    Aisop_xint = squeeze(nansum(DX_xypt.*h_pt_tavg,1));
    Aisop(:,2:Npt+1) = cumsum(Aisop_xint,2);
    zzf = -[0 cumsum(delR)];

    figure(30)
%     YLIM = [37 37.25];
    subplot(1,2,1)
    pcolor(yy/1000,zzf,Aocean'/Lx);
    shading interp;colormap('default');colorbar;
    xlabel('y (km)');ylabel('z (m)');
    title('Aocean/Lx (m)')
    subplot(1,2,2)
    pcolor(yy/1000,ptlevs(1:Npt+1),Aisop'/Lx);
    shading interp;colormap('default');colorbar;
    xlabel('y (km)');ylabel('Potential density (kg/m^3)');
    title('Aisop/Lx (m)');
%     ylim([35.5 37.2]);
    ylim(YLIM);
    axis ij

    %%% The maximum of Aisop should be approximately the same as Aocean
    diff_Aocean_Aisop = (Aocean(:,1)-Aisop(:,end))/Lx; 

    psi_z = zeros(Ny,Nr+1);
    psim_z = zeros(Ny,Nr+1);
    psie_z = zeros(Ny,Nr+1);
    Zisop = zeros(Ny,Npt+1);
    
    for j = 1:Ny
        %%% No ocean here so can't interpolate
        if (Aocean(j,1)==0) 
            continue;
        end
        %%% Truncate Aisop and psi_pt vectors to remove repeated entries at the ends
        %%% of the Aisop vector
        [Aisop_trunc,idx] = unique(Aisop(j,:));
        psi_pt_trunc = psi_pt(j,idx);
        psim_pt_trunc = psim_pt(j,idx);
        %%% Interpolate vertically. Note that Aisop(k) is the total area over
        %%% density bins 1 through k, i.e. it corresponds to the density level
        %%% k+1/2.
        psi_z(j,:) = interp1(Aisop_trunc,psi_pt_trunc,Aocean(j,:),'linear','extrap');
        psim_z(j,:) = interp1(Aisop_trunc,psim_pt_trunc,Aocean(j,:),'linear','extrap');
        
        
        %%% Truncate Aocean and zzf vectors to remove repeated entries at the ends
        %%% of the Aocean vector
        [Aocean_trunc,idx_aocean] = unique(Aocean(j,:));
        zzf_trunc = zzf(idx_aocean);       
        Zisop(j,:) = interp1(Aocean_trunc,zzf_trunc,Aisop(j,:),'linear','extrap');
    end
    
    psie_z = psi_z - psim_z;

    [DD,LL] = meshgrid(ptlevs,yy);

    figure(32)
    PSIlim=[-1.5 1.5];
    subplot(2,3,1)
    pcolor(yy/1000,ptlevs,psi_pt');
    shading interp;colormap('redblue');colorbar;caxis(PSIlim);
    ylim(YLIM);
    xlabel('y (km)');ylabel('Potential density (kg/m^3)');
    title('\psi (Sv) in PT space')
    subplot(2,3,2)
    pcolor(yy/1000,zzf,psi_z');
    shading interp;colormap('redblue');colorbar;caxis(PSIlim);
    xlabel('y (km)');ylabel('z (m)');
    title('\psi (Sv), interpolating the streamfunction')
    subplot(2,3,3)
    pcolor(yy/1000,zzf,psim_z');
    shading interp;colormap('redblue');colorbar;caxis(PSIlim);
    xlabel('y (km)');ylabel('z (m)');
    title('\psi_{mean} (Sv), interpolating the streamfunction')
    subplot(2,3,4)
    pcolor(LL/1000,Zisop,psi_pt);
    shading interp;colormap('redblue');colorbar;caxis(PSIlim);
    hold on;
    contour(LL/1000,Zisop,DD, flip(ptlevs),'EdgeColor','w');
    hold off;
    xlabel('y (km)');ylabel('z (m)');
    title('\psi (Sv), interpolating Zisop (with isotherms)')
    subplot(2,3,5)
    pcolor(LL/1000,Zisop,psim_pt);
    shading interp;colormap('redblue');colorbar;caxis(PSIlim);
    xlabel('y (km)');ylabel('z (m)');
    title('\psi_{mean} (Sv), interpolating Zisop')
    subplot(2,3,6)
    pcolor(LL/1000,Zisop,psie_pt);
    shading interp;colormap('redblue');colorbar;caxis(PSIlim);
    xlabel('y (km)');ylabel('z (m)');
    title('\psi_{eddy} (Sv), interpolating Zisop')
%     






%% Test: overturning circulation in temperature space

  %%% Load experiment
  loadexp;

  %%% Density bins for MOC calculation  
  ptlevs = layers_bounds(:,2);
  Npt = length(ptlevs)-1;

  %%% Frequency of diagnostic output - should match that specified in
  %%% data.diagnostics.
  dumpFreq = abs(diag_frequency(1));
  nDumps = round(nTimeSteps*deltaT/dumpFreq);
  dumpIters = round((1:nDumps)*dumpFreq/deltaT);
  dumpIters = dumpIters(dumpIters > nIter0);

  %%% Create a finer vertical grid
  ffac = 5;
  Nrf = ffac*Nr;
  delRf = zeros(1,Nrf); 
  for n=1:Nr
    for m=1:ffac
      delRf((n-1)*ffac+m) = delR(n)/ffac;
    end
  end
  zz = - cumsum((delR + [0 delR(1:Nr-1)])/2);
  zz_f = - cumsum((delRf + [0 delRf(1:Nrf-1)])/2);

  %%% Partial cell heights on fine grid
  hFacS_f = zeros(Nx,Ny,Nrf);
  for k=1:Nr
    hFacS_f(:,:,ffac*(k-1)+1:ffac*k) = hFacS(:,:,k*ones(1,ffac));              
  end

  %%% Grid of actual vertical positions, accounting for partial cells
  ZZ = zeros(Nx,Ny,Nr);
  ZZ_f = zeros(Nx,Ny,Nrf);
  DZ = zeros(Nx,Ny,Nr);
  DZ_f = zeros(Nx,Ny,Nrf);
  PP = zeros(Nx,Ny,Nr);
  ZZ(:,:,1) = - delR(1)*hFacS(:,:,1)/2;
  for k=2:Nr
    ZZ(:,:,k) = ZZ(:,:,k-1) - 0.5*delR(k-1)*hFacS(:,:,k-1) - 0.5*delR(k)*hFacS(:,:,k);
  end       
  ZZ_f(:,:,1) = - delRf(1)*hFacS_f(:,:,1)/2;
  for k=2:Nrf 
    ZZ_f(:,:,k) = ZZ_f(:,:,k-1) - 0.5*delRf(k-1)*hFacS_f(:,:,k-1) - 0.5*delRf(k)*hFacS_f(:,:,k);      
  end
  for k=1:Nr
    DZ(:,:,k) = delR(k);
  end   
  for k=1:Nrf
    DZ_f(:,:,k) = delRf(k);
  end   
  for k=1:Nr
    PP(:,:,k) = -delR(k);
  end   

  %%% Matrices for vertical interpolation  
  k_p = zeros(Nx,Ny,Nrf);
  k_n = zeros(Nx,Ny,Nrf);
  w_n = zeros(Nx,Ny,Nrf);
  w_p = zeros(Nx,Ny,Nrf);
  is_wet_col = zeros(Nx,Ny);
  for i=1:Nx
    for j=1:Ny

      %%% Indices of the lowest cells
      kmax = sum(squeeze(hFacS(i,j,:))~=0);
      kmax_f = ffac*kmax;
      is_wet_col(i,j) = (kmax~=0);

      for k=1:Nrf

        %%% Previous and next interpolation indices
        k_p(i,j,k) = ceil(k/ffac-0.5);
        k_n(i,j,k) = k_p(i,j,k) + 1;

        %%% Fine grid cell is above highest coarse grid cell, so fine grid
        %%% gamma will just be set equal to uppermost coarse grid gamma
        if (k_p(i,j,k) <= 0)

          k_p(i,j,k) = 1;
          w_p(i,j,k) = 0;
          w_n(i,j,k) = 1;

        else

          %%% Fine grid cell is below lowest coarse grid cell, so fine grid
          %%% gamma will just be set equal to lowermost coarse grid gamma
          if (k_n(i,j,k) > kmax)

            k_n(i,j,k) = kmax;
            w_n(i,j,k) = 0;
            w_p(i,j,k) = 1;

          %%% Otherwise set weights to interpolate linearly between neighboring
          %%% coarse-grid gammas
          else

            w_p(i,j,k) = (ZZ(i,j,k_n(i,j,k))-ZZ_f(i,j,k))./(ZZ(i,j,k_n(i,j,k))-ZZ(i,j,k_p(i,j,k)));
            w_n(i,j,k) = 1 - w_p(i,j,k);

          end

        end

      end

    end
  end

  %%% Calculate time-averaged isopycnal flux, density and velocity
%   vflux_tavg = readIters(exppath,'LaVH1TH',dumpIters,deltaT,tmin,tmax,Nx,Ny,Npt);    
%   h_pt_tavg = readIters(exppath,'LaHs1TH',dumpIters,deltaT,tmin,tmax,Nx,Ny,Npt);    
%   pt_tavg = readIters(exppath,'THETA',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);    
%   vvel_tavg = readIters(exppath,'VVEL',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);    

 vflux_tavg = rdmds([exppath,'/results/LaVH2TH'],nIter);
 h_pt_tavg = rdmds([exppath,'/results/LaHs2TH'],nIter);
 vvel_tavg = rdmds([exppath,'/results/VVEL'],nIter);
 pt_tavg = rdmds([exppath,'/results/THETA'],nIter);

  %%% Interpolate potential temperature to v-gridpoints  
  pt_v = NaN*pt_tavg;
  pt_v(:,2:Ny,:) = 0.5* (pt_tavg(:,1:Ny-1,:) + pt_tavg(:,2:Ny,:));    

  %%% Interpolate onto a finer grid         
  vvel_f = zeros(Nx,Ny,Nrf);
  pt_f = NaN*zeros(Nx,Ny,Nrf);
  if (ffac == 1)

    %%% Shortcut if fine grid resolution = coarse grid resolution
    vvel_f = vvel_tavg;        
    pt_f = pt_v;

  else   

    %%% Velocity uniform throughout each coarse grid cell to preserve
    %%% mass conservation
    for k=1:Nr
      vvel_f(:,:,ffac*(k-1)+1:ffac*k) = vvel_tavg(:,:,k*ones(1,ffac));          
    end

    %%% Linearly interpolate density
    for i=1:Nx
      for j=1:Ny %%% Restrict to wet grid cells  
        if (is_wet_col(i,j))
          pt_f(i,j,:) = w_p(i,j,:).*pt_v(i,j,squeeze(k_p(i,j,:))) + w_n(i,j,:).*pt_v(i,j,squeeze(k_n(i,j,:)));
        end
      end
    end

  end            

  %%% Calculate mean fluxes within mean density surfaces
  vflux_m = 0*vflux_tavg;
  vdz = vvel_f.*hFacS_f.*DZ_f;
  vflux_m(:,:,Npt) = vflux_m(:,:,Npt) + sum(vdz.*(pt_f>ptlevs(Npt)),3);
  vflux_m(:,:,1) = vflux_m(:,:,1) + sum(vdz.*(pt_f<=ptlevs(2)),3);
  for m=2:Npt-1
    vflux_m(:,:,m) = vflux_m(:,:,m) + sum(vdz.*((pt_f>ptlevs(m)) & (pt_f<=ptlevs(m+1))),3);
  end   

  %%% Zonally integrate meridional fluxes
  vflux_xint = zeros(Ny,Npt);
  vflux_m_xint = zeros(Ny,Npt);
  for i=1:Nx
    vflux_xint = vflux_xint + delX(i)*squeeze(vflux_tavg(i,:,:));
    vflux_m_xint = vflux_m_xint + delX(i)*squeeze(vflux_m(i,:,:));
  end

  %%% Sum fluxes to obtain streamfunction
  psi_pt = zeros(Ny,Npt+1);
  psim_pt = zeros(Ny,Npt+1);
  for m=1:Npt  
    psi_pt(:,m) = sum(vflux_xint(:,m:Npt),2);     
    psim_pt(:,m) = sum(vflux_m_xint(:,m:Npt),2);     
  end
  psi_pt = psi_pt/1e6;
  psim_pt = psim_pt/1e6;
  psie_pt = psi_pt - psim_pt;

  %%% Calculate mean density surface heights
  h_pt_xtavg = squeeze(nanmean(h_pt_tavg));
  z_pt = 0*h_pt_xtavg;
  for m=1:Npt
    z_pt(:,m) = - sum(h_pt_xtavg(:,1:m-1),2); % equivalent to zisop_mean
  end
  
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%% CALCULATE ISOPYCNAL DEPTHS %%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 

    Aocean = zeros(Ny,Nr+1);
    Aisop = zeros(Ny,Npt+1);

    %%% Grid spacing matrices
    DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
    DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    DX_xypt = repmat(reshape(delX,[Nx 1 1]),[1 Ny Npt]);


    Aocean_xint = squeeze(sum(DX_xyz.*DZ_xyz.*hFacS,1)); %%% Integrate the ocean area in the x-direction, on v-grid
    Aocean(:,1:Nr) = cumsum(Aocean_xint,2,'reverse'); %%% Integrate the ocean area in the z-direction from bottom to top

    Aisop_xint = squeeze(nansum(DX_xypt.*h_pt_tavg,1));
    Aisop(:,2:Npt+1) = cumsum(Aisop_xint,2);

    zzf = -[0 cumsum(delR)];

    figure(30)
    subplot(1,2,1)
    pcolor(yy/1000,zzf,Aocean'/Lx);
    shading interp;colormap('default');colorbar;
    xlabel('y (km)');ylabel('z (m)');
    title('Aocean/Lx (m)')
    subplot(1,2,2)
    pcolor(yy/1000,ptlevs(1:Npt+1),Aisop'/Lx);
    shading interp;colormap('default');colorbar;
    xlabel('y (km)');ylabel('Potential temperature (degC)');
    title('Aisop/Lx (m)')

    %%% The maximum of Aisop should be approximately the same as Aocean
    diff_Aocean_Aisop = (Aocean(:,1)-Aisop(:,end))/Lx; 

    psi_z_new = zeros(Ny,Nr+1);
    psim_z_new = zeros(Ny,Nr+1);
    psie_z_new = zeros(Ny,Nr+1);
    Zisop = zeros(Ny,Npt+1);
    
    for j = 1:Ny
        %%% No ocean here so can't interpolate
        if (Aocean(j,1)==0) 
            continue;
        end
        %%% Truncate Aisop and psi_pt vectors to remove repeated entries at the ends
        %%% of the Aisop vector
        [Aisop_trunc,idx] = unique(Aisop(j,:));
        psi_pt_trunc = psi_pt(j,idx);
        psim_pt_trunc = psim_pt(j,idx);
        %%% Interpolate vertically. Note that Aisop(k) is the total area over
        %%% density bins 1 through k, i.e. it corresponds to the density level
        %%% k+1/2.
        psi_z_new(j,:) = interp1(Aisop_trunc,psi_pt_trunc,Aocean(j,:),'linear','extrap');
        psim_z_new(j,:) = interp1(Aisop_trunc,psim_pt_trunc,Aocean(j,:),'linear','extrap');
        
        
        %%% Truncate Aocean and zzf vectors to remove repeated entries at the ends
        %%% of the Aocean vector
        [Aocean_trunc,idx_aocean] = unique(Aocean(j,:));
        zzf_trunc = zzf(idx_aocean);       
        Zisop(j,:) = interp1(Aocean_trunc,zzf_trunc,Aisop(j,:),'linear','extrap');
    end
    
    psie_z_new = psi_z_new - psim_z_new;

    [DD,LL] = meshgrid(ptlevs,yy);

    figure(31)
    subplot(2,2,1)
    pcolor(yy/1000,ptlevs,psi_pt');
    shading interp;colormap('redblue');colorbar;caxis([-2 2]);
    ylim([-2 1]);
    xlabel('y (km)');ylabel('Potential temperature (degC)');
    title('\psi (Sv) in PT space')
    subplot(2,2,2)
    pcolor(yy/1000,zzf,psi_z_new');
    shading interp;colormap('redblue');colorbar;caxis([-5 5]);
    xlabel('y (km)');ylabel('z (m)');
    title('\psi (Sv), interpolating the streamfunction')
    subplot(2,2,3)
    pcolor(LL/1000,Zisop,psi_pt);
    shading interp;colormap('redblue');colorbar;caxis([-5 5]);
    xlabel('y (km)');ylabel('z (m)');
    title('\psi (Sv), interpolating Zisop')
    subplot(2,2,4)
    pcolor(LL/1000,Zisop,psi_pt);
    shading interp;colormap('redblue');colorbar;caxis([-5 5]);
    hold on;
    contour(LL/1000,Zisop,DD,ptlevs,'EdgeColor','w');
    hold off;
    xlabel('y (km)');ylabel('z (m)');
    title('\psi (Sv), interpolating Zisop (with isotherms)')
