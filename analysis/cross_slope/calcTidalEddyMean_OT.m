%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% calc_decomposition_OT.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Decompose the overturning streamfunction into tidal, eddy, and mean components.

    clear;close all;

    addpath /data2/csi/MITgcm_ASF-csi/utils/matlab; 
    addpath /data2/csi/MITgcm_ASF-csi/analysis;
    addpath /data2/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires;

    expdir = '/data2/csi/MITgcm_ASF-csi/exps_ng/';

    expname = 'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
    outdir = '/data2/csi/MITgcm_ASF-csi/products_ng/MOC_ssurf34.12_3dS/';
    prodir = '/data2/csi/MITgcm_ASF-csi/products_ng/';

  
  %%%%%%% Calculate matrices for vertical interpolation  

  %%% Load experiment
  loadexp_caolila;
%   loadexp;

 
  %%% Density bins for MOC calculation  
  ptlevs = flip(layers_bounds(:,1));
  Npt = length(ptlevs)-1;
 
  %%% Frequency of diagnostic output - should match that specified in
  %%% data.diagnostics.
  %   dumpFreq = abs(diag_frequency(1));
  dumpFreq = 86400;
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
  
 
  g=9.81;   
  rhoConst = 999.8;
  refdepth = -zz(layers_krho(1));
  
  
  
    
%%%%%%% Calculate the G term for eddy and tidal overturning streamfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Output intervals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dumpFreq =86400; 
nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
navg = num2str(dumpIters,'%010d');

nEND =  length(dumpIters);
G = zeros(Ny,Npt+1);

for nI = 1:nEND
 
          nI
          Ntime = navg(nI*10-9:nI*10);  
          
          %%% Calculate time-averaged isopycnal flux, density and velocity 
          LaVH1RHO = rdmds([exppath,'/results/LaVH1RHO.' Ntime]);
          LaHs1RHO = rdmds([exppath,'/results/LaHs1RHO.' Ntime]);
          VVEL = rdmds([exppath,'/results/VVEL.' Ntime]);
          THETA = rdmds([exppath,'/results/THETA.' Ntime]);
          SALT = rdmds([exppath,'/results/SALT.' Ntime]);
          PHIHYD = rdmds([exppath,'/results/PHIHYD.' Ntime]);

          vflux_tavg = flip(LaVH1RHO,3);  
          h_pt_tavg = flip(LaHs1RHO,3);   
          vvel_tavg = VVEL;  
          theta_tavg = THETA;  
          salt_tavg = SALT;    
          pressure_tavg =PHIHYD; 

          %%% Calculate the potential density pt
          refpress = rhoConst*(g*refdepth + pressure_tavg(:,:,layers_krho(1)))/1e4; %%% unit: dbar

          for kk = 1:Nr
              pt_tavg(:,:,kk) = densmdjwf(salt_tavg(:,:,kk),theta_tavg(:,:,kk),refpress)-1000;
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
          vflux_m(:,:,Npt) = vflux_m(:,:,Npt) + sum(vdz.*(pt_f<ptlevs(Npt)),3);
          vflux_m(:,:,1) = vflux_m(:,:,1) + sum(vdz.*(pt_f>=ptlevs(2)),3);
          for m=2:Npt-1
            vflux_m(:,:,m) = vflux_m(:,:,m) + sum(vdz.*((pt_f<ptlevs(m)) & (pt_f>=ptlevs(m+1))),3);
          end   

          %%% Zonally integrate meridional fluxes
%           vflux_xint = zeros(Ny,Npt);
          vflux_m_xint = zeros(Ny,Npt);
          for i=1:Nx
%             vflux_xint = vflux_xint + delX(i)*squeeze(vflux_tavg(i,:,:));
            vflux_m_xint = vflux_m_xint + delX(i)*squeeze(vflux_m(i,:,:));
          end

          %%% Sum fluxes to obtain streamfunction
%           psi_pt = zeros(Ny,Npt+1);
          psim_pt = zeros(Ny,Npt+1);
          for m=1:Npt  
%             psi_pt(:,m) = sum(vflux_xint(:,m:Npt),2);     
            psim_pt(:,m) = sum(vflux_m_xint(:,m:Npt),2);     
          end
%           psi_pt = psi_pt/1e6;
          psim_pt = psim_pt/1e6;
%           psie_pt = psi_pt - psim_pt;

          G = G + psim_pt/nEND;
          
  save([outdir expname '_psim_pt_' num2str(nI) 'days.mat'],'yy','xx','psim_pt','ptlevs');

end
    
  





save([prodir expname '_tidalMOC_' num2str(nEND) 'days.mat'],'yy','xx','G','ptlevs');
    

