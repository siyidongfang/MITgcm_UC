%%%
%%% setParams.m
%%%
%%% Sets basic MITgcm parameters plus parameters for included packages, and
%%% writes out the appropriate input files.,
%%%
function [nTimeSteps,h,obsuice,obsvice,lwdown,...
    tNorth,sNorth,rho_north_surf,rho_north_sigma2,rho_north_sigma4,...
    tSouth,sSouth,rho_south_surf,rho_south_sigma2,rho_south_sigma4]...
    = setParams(exp_name,inputpath,codepath,imgpath,listterm,Nx,Ny,Nr,Ua,Va,Atide,Hi0,Ai0,Ws,is_ContinuedRun,useSEAICE)  

  addpath ../../Software/gsw_matlab_v3_06_11/thermodynamics_from_t/;
  addpath ../../Software/gsw_matlab_v3_06_11/library/;
  addpath ../../Software/gsw_matlab_v3_06_11/;
  addpath ../utils/;
  addpath ../newexp_utils/;
  addpath ../analysis_uc/;


  %%%%%%%%%%%%%%%%%%
  %%%%% SET-UP %%%%%
  %%%%%%%%%%%%%%%%%%      
  
  %%% If set true, plots of prescribed variables will be shown
  showplots = true;      
  fignum = 1;
  
  %%% Data format parameters
  ieee='b';
  prec='real*8';
  realdigits = 8;
  realfmt=['%.',num2str(realdigits),'e'];
  
  %%% Get parameter type definitions
  paramTypes;
      

  %%% To store parameter names and values
  parm01 = parmlist;
  parm02 = parmlist;
  parm03 = parmlist;
  parm04 = parmlist;
  parm05 = parmlist;
  PARM={parm01,parm02,parm03,parm04,parm05}; 
  
  %%% Seconds in one hour
  t1min = 60;
  %%% Seconds in one hour
  t1hour = 60*t1min;
  %%% hours in one day
  t1day = 24*t1hour;
  %%% Seconds in 1 year
  t1year = 365*t1day;  
  %%% Metres in one kilometre
  m1km = 1000; 
      
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% FIXED PARAMETER VALUES %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  simTime = 10*t1year; %%% Simulation time   
%   simTime = 60*t1day;
  nIter0 = 0; %%% Initial iteration 
  Lx = 400*m1km; %%% Domain size in x 
  Ly = 450*m1km; %%% Domain size in y   
%   Ls = 50*m1km; %%% Width of southern boundary region
  Ln = 20*m1km; %%% Width of northern boundary region
  H = 4000; %%% Domain size in z 
  g = 9.81; %%% Gravity
  Omega = 2*pi*366/365/86400;
  Rp = 6400*m1km; %%% Planetary radius
  lat0 = -70; %%% Latitude at southern boundary %%% Actually, lat0 to calc f0 and beta ~ 64S
  f0 = -1.3e-4; %%% Coriolis parameter
  beta = 1e-11; %%% Beta parameter      
  
  viscAh = 0; %%% Horizontal viscosity    
  viscA4 = 0; %%% Biharmonic viscosity
  viscAhGrid = 0; %%% Grid-dependent viscosity
  viscAr = 3e-4; %%% Vertical viscosity    
  diffKhT = 0; %%% Horizontal temp diffusion
  diffKhS = 0; %%% Horizontal salt diffusion
%   viscA4Grid = 0.1; %%% Grid-dependent biharmonic viscosity
%   viscC4smag = 0; %%% Smagorinsky biharmonic viscosity  
%   diffK4Tgrid = 0.1; %%% Grid-dependent biharmonic temp diffusivity
  diffKrT = 1e-5; %%% Vertical temp diffusion     
%   diffK4Sgrid = 0.1; %%% Grid-dependent biharmonic salt diffusivity
  diffKrS = 1e-5; %%% Vertical salt diffusion     
  viscA4Grid = 0;    %%%%% Update: 20210627
  viscC4smag = 4;    %%%%% Update: 20210627
  diffK4Tgrid = 0;   %%%%% Update: 20210627
%   diffKrT = 0;       %%%%% Update: 20210702
  diffK4Sgrid = 0;   %%%%% Update: 20210627
%   diffKrS = 0;       %%%%% Update: 20210702
%   viscAh = 12;       %%%%% Update: 20210630
%   viscA4Grid = 0.1;  %%%%% Update: 20210630

  
  
    % % % %   %%% MITgcm_ASF Topographic parameters 
    % % % %   use_trough = true;
    % % % %   Hshelf = 500; %%% Continental shelf depth
    % % % %   Hs = H - Hshelf; %%% Shelf height
    % % % %   Ys = Ws+125*m1km %%% Meridional slope position
    % % % %   
    % % % %   %%% Trough parameters
    % % % %   N_trough = 4;
    % % % %   H_trough = 300; %%% Positive for a trough, negative for a ridge
    % % % %   W_trough = Lx/N_trough/4; %%% Default 50*m1km
    % % % % %   N_trough = 1;
    % % % % %   H_trough = 500;
    % % % % %   W_trough = 50*m1km;
    % % % % %   X_trough = 0*m1km;
    % % % %   H_bump = -H_trough;
    % % % %   X_trough = zeros(1,N_trough);
    % % % %   X_bump = zeros(1,N_trough);
    % % % %   for nrt = 1:N_trough
    % % % %       X_trough(1,nrt) = (2*nrt-1-N_trough)/2*Lx/N_trough;
    % % % %       X_bump(1,nrt)= (2*nrt-N_trough)/2*Lx/N_trough;
    % % % %   end
    % % % %   Y_trough = 0; %%% Southern edge of trough
    % % % %   
    % % % %   if(use_trough)
    % % % % %      Zs = 2850; %%% Vertical slope position  (Exponentials: Zs=1000; Tanh-like: 2250)
    % % % %      Zs = 2250 + H_trough/2*N_trough;
    % % % %   else
    % % % %      Zs = 2250; 
    % % % %   end
    % % % % 

    %%% Topographic parameters 
%     Ws = 30*m1km; %%% Continental slope half-width
    Hshelf = 500; %%% Continental shelf depth
    Wshelf = 150*m1km; %%% Width of continental shelf
    Ycoast = 10*m1km; %%% Latitude of coastline
    Wcoast = 20*m1km; %%% Width of coastal wall slope
    Yshelfbreak = Ycoast+Wshelf; %%% Latitude of shelf break
    Yslope = Ycoast+Wshelf+Ws; %%% Latitude of mid-continental slope
    Ydeep = 300*m1km; %%% Latitude of deep ocean
    Xeast = 275*m1km; %%% Longitude of eastern trough wall
    Xwest = 125*m1km; %%% Longitude of western trough wall
    Yicefront = 0*m1km; %%% Latitude of ice shelf face
    Hicefront = 0; %%% Depth of ice shelf frace
    Hbed = -300; %%% Change in bed elevation from shelf break to southern domain edge
    Hice = Hicefront-(Hshelf-Hbed); %%% Change in ice thickness from ice fromt to southern domain edge
    Htrough = 300; %%% Trough depth
    Wtrough = 40*m1km; %%% Trough width %%%Default 40 km
    Xtrough = Lx/2; %%% Longitude of trough


 
  %%% Parameters related to periodic forcing
  periodicExternalForcing = false;
  externForcingCycle = simTime;  
  if (~periodicExternalForcing)
    externForcingPeriod = externForcingCycle;
    nForcingPeriods = 1;
  else
    externForcingPeriod = 30*t1day;
    nForcingPeriods = externForcingCycle/externForcingPeriod;
  end
  

  useEXF = true;
  varyingtidalphase = false; % Set true to include zonally (along-slope) varying tidal phase 
  useLAYERS = false;
  useRBCS = false; 
  useEXFwindstress = false; %%% apply wind speed in EXF package
  if(useSEAICE)
      EXFoption = 3; %%% Read-in atemp, aqh, swdown, lwdown,precip, and runoff. Compute hflux, swflux and sflux.
  else
      EXFoption = 1; %%% Read-in hflux, swflux and sflux.
  end
  
  %%% OBCS package options
  useOBCS = true;
  useOBCStides = true;
  useobcsNorth = true;
  useOrlanskiNorth = false;
  useOrlanskiSouth = false;
  % Zonal boundary condition
  use2Orlanski = false;
  useEobcsWorlanski = false; %%% OBCS to the east, and Orlanski to the west
  useEobcsWobcs = true;      %%% OBCS to the east and west
  if(use2Orlanski)
      useOrlanskiWest = true;
      useOrlanskiEast = true;
  end
  if(useEobcsWorlanski)      %%% OBCS to the east, and Orlanski to the west
      useOBCSeast = true;
      useOrlanskiWest = true;
      useOrlanskiEast = false;  
  end
  if(useEobcsWobcs)           %%% OBCS to the east and west
      useOBCSeast = true;
      useOBCSwest = true;
      useOrlanskiWest = false;
      useOrlanskiEast = false;  
  end

  
  %%% Flag for barotropic mode
  isBarotropic = Nr == 1;
  
  %%% PARM01
  %%% momentum scheme
  parm01.addParm('vectorInvariantMomentum',true,PARM_BOOL);
  parm01.addParm('implicSurfPress',0.6,PARM_REAL);
  parm01.addParm('implicDiv2DFlow',0.6,PARM_REAL); 
  %%% viscosity  
  parm01.addParm('viscAr',viscAr,PARM_REAL);
  parm01.addParm('viscA4',viscA4,PARM_REAL);
  parm01.addParm('viscAh',viscAh,PARM_REAL);
  parm01.addParm('viscA4Grid',viscA4Grid,PARM_REAL);
  parm01.addParm('viscAhGrid',viscAhGrid,PARM_REAL);
  parm01.addParm('viscA4GridMax',0.5,PARM_REAL);
  parm01.addParm('viscAhGridMax',1,PARM_REAL);
  parm01.addParm('useAreaViscLength',false,PARM_BOOL);
  parm01.addParm('useFullLeith',true,PARM_BOOL);
  parm01.addParm('viscC4smag',viscC4smag,PARM_REAL);    
  parm01.addParm('viscC4leith',0,PARM_REAL);
  parm01.addParm('viscC4leithD',0,PARM_REAL);  
  parm01.addParm('viscC2leith',0,PARM_REAL);
  parm01.addParm('viscC2leithD',0,PARM_REAL);  
  %%% diffusivity
  parm01.addParm('tempAdvScheme',80,PARM_INT);
  parm01.addParm('saltAdvScheme',80,PARM_INT);
  parm01.addParm('diffKrT',diffKrT,PARM_REAL);
  parm01.addParm('diffKhT',diffKhT,PARM_REAL);
  parm01.addParm('diffKrS',diffKrS,PARM_REAL);
  parm01.addParm('diffKhS',diffKhS,PARM_REAL);
  parm01.addParm('tempStepping',~isBarotropic,PARM_BOOL);
  parm01.addParm('saltStepping',~isBarotropic,PARM_BOOL);
  parm01.addParm('staggerTimeStep',true,PARM_BOOL);
  %%% equation of state
  parm01.addParm('eosType','MDJWF',PARM_STR); 
  %%% boundary conditions
  parm01.addParm('no_slip_sides',false,PARM_BOOL);
  parm01.addParm('no_slip_bottom',false,PARM_BOOL);
  parm01.addParm('bottomDragLinear',0,PARM_REAL);
  parm01.addParm('bottomDragQuadratic',2e-3,PARM_REAL);
  %%% physical parameters
  parm01.addParm('f0',f0,PARM_REAL);
  parm01.addParm('beta',beta,PARM_REAL);
  parm01.addParm('gravity',g,PARM_REAL);
  %%% full Coriolis force parameters
  parm01.addParm('quasiHydrostatic',false,PARM_BOOL);
  parm01.addParm('fPrime',0,PARM_REAL);
  %%% implicit diffusion and convective adjustment  
  parm01.addParm('ivdc_kappa',0,PARM_REAL);
  parm01.addParm('implicitDiffusion',true,PARM_BOOL);
  parm01.addParm('implicitViscosity',true,PARM_BOOL);
  %%% exact volume conservation
  parm01.addParm('exactConserv',true,PARM_BOOL);
  %%% C-V scheme for Coriolis term
  parm01.addParm('useCDscheme',false,PARM_BOOL);
  %%% partial cells for smooth topography
  if (isBarotropic)
    parm01.addParm('hFacMin',0,PARM_REAL);  
  else
    parm01.addParm('hFacMin',0.1,PARM_REAL);  
  end
  %%% file IO stuff
  parm01.addParm('readBinaryPrec',64,PARM_INT);
  parm01.addParm('useSingleCpuIO',true,PARM_BOOL);
  parm01.addParm('debugLevel',-1,PARM_INT);
  %%% Wet-point method at boundaries - may improve boundary stability
  parm01.addParm('useJamartWetPoints',true,PARM_BOOL);
  parm01.addParm('useJamartMomAdv',true,PARM_BOOL);
%   parm01.addParm('rhoConst',1000,PARM_REAL);
  parm01.addParm('useRealFreshWaterFlux',false,PARM_BOOL);
  %%% PARM02
  parm02.addParm('useSRCGSolver',true,PARM_BOOL);  
  parm02.addParm('cg2dMaxIters',1000,PARM_INT);  
  parm02.addParm('cg2dTargetResidual',1e-12,PARM_REAL);
 
  %%% PARM03
  parm03.addParm('alph_AB',1/2,PARM_REAL);
  parm03.addParm('beta_AB',5/12,PARM_REAL);
  parm03.addParm('forcing_In_AB',false,PARM_BOOL); 
      % This flag makes to model do a  separate (Eulerian?) time step 
      % for the tendencies due to surface forcing. This is sometime 
      % favorable for stability reasons (and some package such as 
      % seaice work only with this).
  parm03.addParm('nIter0',nIter0,PARM_INT);
  parm03.addParm('abEps',0.1,PARM_REAL);
  parm03.addParm('chkptFreq',t1year,PARM_REAL); % rolling 
  parm03.addParm('pChkptFreq',t1year,PARM_REAL); % permanent
  parm03.addParm('taveFreq',0,PARM_REAL); % it only works properly, if taveFreq is a multiple of the time step deltaT (or deltaTclock).
  parm03.addParm('dumpFreq',t1year,PARM_REAL); % interval to write model state/snapshot data (s)
  parm03.addParm('monitorFreq',1*t1year,PARM_REAL); % interval to write monitor output (s)
  parm03.addParm('dumpInitAndLast',true,PARM_BOOL);
  parm03.addParm('pickupStrictlyMatch',false,PARM_BOOL); 
  
  %%% PARM04
  parm04.addParm('usingCartesianGrid',true,PARM_BOOL);
%   parm04.addParm('usingCurvilinearGrid',true,PARM_BOOL);
  parm04.addParm('usingSphericalPolarGrid',false,PARM_BOOL);    
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% GRID SPACING %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%    
  
    % % % % % MITgcm_ASF grid spacing    
    % % % %   %%% Zonal grid
    % % % %   dx = Lx/Nx;  
    % % % %   xx = (1:Nx)*dx;
    % % % %   xx = xx-mean(xx);
    % % % %   
    % % % %   %%% Uniform meridional grid   
    % % % %   dy = (Ly/Ny)*ones(1,Ny);  
    % % % %   yy = cumsum((dy + [0 dy(1:end-1)])/2);
    % % % %  
    % % % %   %%% Plotting mesh
    % % % %   [Y,X] = meshgrid(yy,xx);
    % % % %   
    % % % %   %%% Grid spacing increases with depth, but spacings exactly sum to H
    % % % %   zidx = 1:Nr;
    % % % %   gamma = 10;  
    % % % %   alpha = 10;
    % % % %   dz1 = 2*H/Nr/(alpha+1);
    % % % %   dz2 = alpha*dz1;
    % % % %   dz = dz1 + ((dz2-dz1)/2)*(1+tanh((zidx-((Nr+1)/2))/gamma));
    % % % %   zz = -cumsum((dz+[0 dz(1:end-1)])/2);
    % % % % 
    % % % %   zz_idx = (-zz<= Hshelf);  
    % % % %   zzidx = sum(zz_idx);


  %%% Zonal grid
  dx = Lx/Nx;  
  xx = (1:Nx)*dx;
  
  %%% Uniform meridional grid   
  dy = (Ly/Ny)*ones(1,Ny);  
  yy = cumsum((dy + [0 dy(1:end-1)])/2);
 
  %%% Plotting mesh
  [Y,X] = meshgrid(yy,xx);


  %%% Variable grid with high resolution at ice shelf cavity depths, very high in surface mixed layer    
%   dz0 = 2;
%   dz1 = 15; 
%   dz2 = 20;
%   dz3 = 100;
%   dz4 = 200;  
%   N0 = 1;
%   N1 = 20; 
%   N2 = 50;
%   N3 = 15;
%   N4 = 14;  
  dz0 = 2*10/6;
  dz1 = 15*10/6; 
  dz2 = 20*10/6;
  dz3 = 100*10/6;
  dz4 = 200*10/6;  
  N0 = 1;
  N1 = 14; 
  N2 = 34;
  N3 = 11;
  N4 = 10;
  nn_c = cumsum([N0 N1 N2 N3 N4]);
  dz_c = [dz0 dz1 dz2 dz3 dz4];
  nn = 1:(N1+N2+N3+N4+1);
  dz = interp1(nn_c,dz_c,nn,'pchip');

  zz = -cumsum((dz+[0 dz(1:end-1)])/2);
  if (length(zz) ~= Nr)
    error('Vertical grid size does not match vertical array dimension!');
  end
  Nr = length(zz);



  %%% Thickness of sponge layers in gridpoints  
  spongeThicknessDim = 20*m1km;
  spongeThickness = round(spongeThicknessDim/dy(end));
  seaicespongeThicknessDim = 20*m1km; %%% Restore sea ice thickness and concentration for the whole domain
  seaiceSpongeThickness = round(seaicespongeThicknessDim/dy(end));
  

  %%% Store grid spacings
  parm04.addParm('delX',dx*ones(1,Nx),PARM_REALS);
  parm04.addParm('delY',dy,PARM_REALS);
  parm04.addParm('delR',dz,PARM_REALS);      
  
  %%% Don't allow partial cell height to fall below min grid spacing
  if (~isBarotropic)
    parm01.addParm('hFacMinDr',min(dz),PARM_REAL);
  end

  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% BATHYMETRY AND ICE SHELF DRAFT %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    % % % % % Bathymetry for MITgcm_ASF
    % % % %     z_topog = Zs * ones(size(X));
    % % % %     h_topog = Hs * ones(size(X));
    % % % %   if (use_trough)    
    % % % %     for ntr = 1:N_trough
    % % % %         h_trough = H_trough * exp(-((X-X_trough(ntr))/W_trough).^4);
    % % % %         h_trough(Y<Y_trough) = 0;
    % % % %         yidx = (yy>Y_trough) & (yy<Ys-Ws);
    % % % %         h_trough(:,yidx) = h_trough(:,yidx) .* 0.5.*(1-cos(pi*(Y(:,yidx)-Y_trough)/(Ys-Ws-Y_trough)));
    % % % %         z_topog =  (z_topog-0.5*H_trough).*ones(size(X)) + h_trough;
    % % % %         h_topog = h_topog - 2 * h_trough;
    % % % %     end 
    % % % %   end  
    % % % %   h = -z_topog - (h_topog/2).*tanh((Y-Ys)/Ws);  
    % % % % 
    % % % % fontsize = 12;
    % % % % 
    % % % %   %%% Plot the bathymetry
    % % % %   if (showplots)
    % % % %     figure(fignum);
    % % % %     fignum = fignum + 1;
    % % % %     clf;
    % % % %     surf(X/1000,Y/1000,h,'EdgeColor','None');   
    % % % %     xlabel('x (km)');
    % % % %     ylabel('y (km)');
    % % % %     zlabel('hb','Rotation',0);
    % % % % %     plot(Y(1,:),h(1,:));
    % % % %     title('Model bathymetry');
    % % % %     set(gca,'fontsize',fontsize+2,'Ydir','reverse');
    % % % %     PLOT = gcf;
    % % % %     PLOT.Position = [248 284 655 442];  
    % % % %   end
  
   
  %%% Construct shelf/slope/deep ocean bathymetry profile via cubic
  %%% interpolation
  y_interp = [0 (Yslope-Ws)/2 Yslope-Ws Yslope Ydeep Ly];
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


  %%% Plot bathymetry and ice draft
  figure(fignum);
  fignum = fignum + 1;
  clf;   
  fontsize = 12;

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



    %%% Save the figure
    savefig([imgpath '/bathymetry.fig']);
    saveas(gcf,[imgpath '/bathymetry.png']);
  
  %%% Save as a parameter
  writeDataset(h,fullfile(inputpath,'bathyFile.bin'),ieee,prec);
  parm05.addParm('bathyFile','bathyFile.bin',PARM_STR); 
  




  %%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%
  %%%%%%EXF PKG%%%%%
  %%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%

  %%% To store parameter names and values
  EXF_NML_01 = parmlist;
  EXF_NML_02 = parmlist;
  EXF_NML_03 = parmlist;
  EXF_NML_04 = parmlist;
  EXF_NML_OBCS = parmlist;
  EXF_PARM = {EXF_NML_01,EXF_NML_02,EXF_NML_03,EXF_NML_04,EXF_NML_OBCS}; 
    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% UWIND AND VWIND in EXF %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    exf_scal_BulkCdn  = 1.015;
 	exf_iprec         = 64;  
 	useExfYearlyFields= false;
 	useExfCheckRange  = false;
%  	useRelativeWind   = true;
 	useRelativeWind   = false;
    repeatPeriod      = 20*t1year;

  if (EXFoption ~= 5)
     EXF_NML_01.addParm('exf_scal_BulkCdn',exf_scal_BulkCdn,PARM_REAL);
  end

  EXF_NML_01.addParm('exf_iprec',exf_iprec,PARM_INT);
  EXF_NML_01.addParm('useExfYearlyFields',useExfYearlyFields,PARM_BOOL);
  EXF_NML_01.addParm('useExfCheckRange',useExfCheckRange,PARM_BOOL);
  if(~useEXFwindstress)
      EXF_NML_01.addParm('useRelativeWind',useRelativeWind,PARM_BOOL);
  end
  EXF_NML_01.addParm('repeatPeriod',repeatPeriod,PARM_REAL);
%   EXF_NML_03.addParm('exf_offset_atemp',exf_offset_atemp,PARM_REAL);
%   EXF_NML_03.addParm('exf_inscal_runoff',exf_inscal_runoff,PARM_REAL);
  if (useEXFwindstress)
     readStressOnCgrid = true;
     EXF_NML_01.addParm('readStressOnCgrid',readStressOnCgrid,PARM_BOOL);
  end
    
    rho_a = 1.3;               %%% Air density, kg/m^3
%     Ua = -6;
%     Va = 6;

  if (Ua~=0)
%     uwind = -sqrt(abs(tau_zonal)/rho_a/SEAICE_drag).*ones(Nx,Ny); % Zonal 10-m wind speed 
    uwind = [Ua:-Ua/(Ny-1):0].*ones(Nx,1); 
  else
    uwind = zeros(Nx,Ny); 
  end
  if (Va~=0)
%     vwind = sqrt(abs(tau_merid)/rho_a/SEAICE_drag).*ones(Nx,Ny); % Meridional 10-m wind speed
     vwind = [Va:-Va/(Ny-1):0].*ones(Nx,1); 
  else
    vwind = zeros(Nx,Ny); 
  end
  
   %%% Plot the wind speed 
  if (showplots)
    figure(fignum);
    fignum = fignum + 1;
    clf;
    plot(yy/1000,uwind(1,:),'LineWidth',1.5);
    xlabel('Offshore distance (km)');
    ylabel('u_a');
    title('Zonal wind velocity (m/s)');
    set(gca,'fontsize',fontsize-1);
    PLOT = gcf;
    PLOT.Position = [263 149 567 336];  
  end
    %%% Save the figure
    savefig([imgpath '/uwind.fig']);
    saveas(gcf,[imgpath '/uwind.png']);
    
   %%% Plot the wind speed 
  if (showplots)
    figure(fignum);
    fignum = fignum + 1;
    clf;
    plot(yy/1000,vwind(1,:),'LineWidth',1.5);
    xlabel('Offshore distance (km)');
    ylabel('v_a');
    title('Meridional wind velocity (m/s)');
    set(gca,'fontsize',fontsize-1);
    PLOT = gcf;
    PLOT.Position = [263 149 567 336];  
  end
    %%% Save the figure
    savefig([imgpath '/vwind.fig']);
    saveas(gcf,[imgpath '/vwind.png']);
    
    
if(useEXFwindstress)
    ustress = rho_a*SEAICE_drag.*sqrt(uwind.^2+vwind.^2).*uwind;    
    vstress = rho_a*SEAICE_drag.*sqrt(uwind.^2+vwind.^2).*vwind;     
    ustressfile = 'ustressfile.bin';
    vstressfile = 'vstressfile.bin';
    writeDataset(uwind,fullfile(inputpath,ustressfile),ieee,prec);
    writeDataset(vwind,fullfile(inputpath,vstressfile),ieee,prec);
    EXF_NML_02.addParm('ustressfile',ustressfile,PARM_STR);
    EXF_NML_02.addParm('vstressfile',vstressfile,PARM_STR);
              %%% Plot the wind stress 
              if (showplots)
                figure(fignum);
                fignum = fignum + 1;
                clf;
                plot(yy/1000,ustress(1,:),'LineWidth',1.5);
                xlabel('Offshore distance (km)');
                ylabel('\tau_a^x');
                title('Zonal wind stress (N/m^2)');
                set(gca,'fontsize',fontsize-1);
                PLOT = gcf;
                PLOT.Position = [263 149 567 336];  
              end
                %%% Save the figure
                savefig([imgpath '/ustress.fig']);
                saveas(gcf,[imgpath '/ustress.png']);

               %%% Plot the wind stress 
              if (showplots)
                figure(fignum);
                fignum = fignum + 1;
                clf;
                plot(yy/1000,vstress(1,:),'LineWidth',1.5);
                xlabel('Offshore distance (km)');
                ylabel('\tau_a^y');
                title('Meridional wind stress (N/m^2)');
                set(gca,'fontsize',fontsize-1);
                PLOT = gcf;
                PLOT.Position = [263 149 567 336];  
              end
                %%% Save the figure
                savefig([imgpath '/vstress.fig']);
                saveas(gcf,[imgpath '/vstress.png']);
    
else
%     Ur = sqrt((abs(tau_zonal)+abs(tau_merid))./rho_a./SEAICE_drag).*ones(Nx,Ny);
    uwindfile = 'uwindfile.bin';
    vwindfile = 'vwindfile.bin';
    writeDataset(uwind,fullfile(inputpath,uwindfile),ieee,prec);
    writeDataset(vwind,fullfile(inputpath,vwindfile),ieee,prec);
    EXF_NML_02.addParm('uwindfile',uwindfile,PARM_STR);
    EXF_NML_02.addParm('vwindfile',vwindfile,PARM_STR);
end   



if(useSEAICE)
    exf_albedo = 0.15; 
    
%     exf_offset_atemp =  273.16;
    %%%runoff from ERA is in hours, need to convert to seconds
%     exf_inscal_runoff = 1.14e-04;
  
  EXF_NML_01.addParm('exf_albedo',exf_albedo,PARM_INT);


% Read-in atemp, aqh, swdown, lwdown, precip, and runoff. Compute hflux, swflux and sflux.
    Kice = 2.1656; %%% Ice thermal conductivity, W/(m*degK)
    ice_abs = 1-SEAICE_dryIceAlb; %%% Ice absorption

% meanLWdown = zeros(1,size([-50:10],2));
%  for  TaDegC = -50:10
    TaDegC = -10;
    Ta = 273.16+TaDegC; %%% Surface air temperature, degK
    Tw = 273.16+double(tNorth(1)); %%% surface water temperature
    TisDegC = -0.65;
%     TisDegC = double(tNorth(1)); 
    Tis = 273.16+TisDegC; %%% Ice surface temperature
    SEAICE_emissivity = 0.970018; %%% Ice emissivity
    ocn_e = 5.50e-8 / 5.670e-8;  %%% Ocean emissivity, 0.97
    sigma = 5.67/10^8; %%% Stefan-Boltzman'n constant
    exf_iceCh = 1.63e-3; %%% sensible heat transfer coeff. over sea-ice   
    Cp_air = 1004; %%% Heat capacity at constant pressure 1004 J K-1 kg-1
    atemp = Ta.*ones(Nx,Ny); % Surface (2-m) air temperature in deg K
    aqh = 6.1094/(rho_a*287*Tis/100)*exp(17.625*TisDegC/(TisDegC+243.04)).*ones(Nx,Ny); % 0.0057, Surface (2m) specific humidity in kg/kg. Typical range: 0 < aqh < 0.02
    
   
    
    
if(EXFoption == 3)
    swdown = 0.*ones(Nx,Ny); 
    precip = 0.*ones(Nx,Ny); 
    runoff = 0.*ones(Nx,Ny);  
 
    CondHeat = 0.5*1/Hi0;  %%% SItice ~ -1.62 degC, Tio ~ -1.87 degC => Conductive heat flux from ice surface to ocean is about 0.5 W/m^2
    lwdown = (CondHeat/ice_abs+320)*ones(Nx,Ny);
    lwdown(1)
    
    if (Hi0==0)
        lwdown = 324.1085*ones(Nx,Ny);
        lwdown(1)
    end
    
    
    
  %%% Plot the downward longwave radiation in W/m^2
  if (showplots)
    figure(fignum);
    fignum = fignum + 1;
    clf;
    plot(yy/1000,squeeze(lwdown(1,:)),'LineWidth',1.5);
    xlabel('Offshore distance (km)');
    ylabel('LWdown (W/m^2)');
    title('Downward longwave radiation');
    set(gca,'fontsize',fontsize-1);
    PLOT = gcf;
    PLOT.Position = [263 149 567 336];  
  end
    %%% Save the figure
    savefig([imgpath '/LWdown.fig']);
    saveas(gcf,[imgpath '/LWdown.png']);
      
    atempfile  = 'atempfile.bin';
    aqhfile    = 'aqhfile.bin';
    swdownfile = 'swdownfile.bin';
    lwdownfile = 'lwdownfile.bin';
    precipfile = 'precipfile.bin'; 
    runofffile = 'runofffile.bin';
    writeDataset(atemp,fullfile(inputpath,atempfile),ieee,prec);
    writeDataset(aqh,fullfile(inputpath,aqhfile),ieee,prec);
    writeDataset(swdown,fullfile(inputpath,swdownfile),ieee,prec);
    writeDataset(lwdown,fullfile(inputpath,lwdownfile),ieee,prec);
    writeDataset(precip,fullfile(inputpath,precipfile),ieee,prec);
    writeDataset(runoff,fullfile(inputpath,runofffile),ieee,prec);
    EXF_NML_02.addParm('atempfile',atempfile,PARM_STR);
    EXF_NML_02.addParm('aqhfile',aqhfile,PARM_STR);
    EXF_NML_02.addParm('swdownfile',swdownfile,PARM_STR);
    EXF_NML_02.addParm('lwdownfile',lwdownfile,PARM_STR);
    EXF_NML_02.addParm('precipfile',precipfile,PARM_STR);
    EXF_NML_02.addParm('runofffile',runofffile,PARM_STR);

end

end







    %%% No sea ice
    if (EXFoption == 1)   
        hflux = 0.*ones(Nx,Ny);  
        sflux = 0.*ones(Nx,Ny);  
        swflux = 0.*ones(Nx,Ny);  
        hfluxfile  = 'hfluxfile.bin';
        sfluxfile    = 'sfluxfile.bin';
        swfluxfile  = 'swfluxfile.bin';
        writeDataset(hflux,fullfile(inputpath,hfluxfile),ieee,prec);
        writeDataset(sflux,fullfile(inputpath,sfluxfile),ieee,prec);
        writeDataset(swflux,fullfile(inputpath,swfluxfile),ieee,prec);
        EXF_NML_02.addParm('hfluxfile',hfluxfile,PARM_STR);
        EXF_NML_02.addParm('sfluxfile',sfluxfile,PARM_STR);
        EXF_NML_02.addParm('swfluxfile',swfluxfile,PARM_STR);
    end


  %%% Create the data.exf file
  write_data_exf(inputpath,EXF_PARM,listterm,realfmt);









  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% EASTERN BOUNDARY %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%

  s_bot = 34.65; 
  pt_bot = -0.3;
  s_mid = 34.75;
  pt_mid = 2; 
  s_surf = 33.95;
  pt_surf = -1.8; 
  Zsml = -50;  %%% Depth of the surface mixed layer

  tEast = zeros(Ny,Nr);
  sEast = zeros(Ny,Nr);
  uEast = zeros(Ny,Nr);
  N2_east = zeros(Ny,Nr-1);
  gamma_n_east = zeros(Ny,Nr);
  depth_East_pt = zeros(Ny,5);
  depth_East_s  = zeros(Ny,5);

  Zcdw_pt_shelf = -400; %%% CDW depth over the shelf
  Zcdw_pt_South = -200; %%% CDW depth at the southern boundary

  lat_Zcdw_pt = [0 Yshelfbreak Ydeep Ly];
  Zcdw_pt_2 = [Zcdw_pt_shelf Zcdw_pt_shelf Zcdw_pt_South Zcdw_pt_South]; %%% Piecewise function

  Zcdw_pt = interp1(lat_Zcdw_pt,Zcdw_pt_2,yy,'PCHIP'); 
  Zcdw_s = Zcdw_pt - 100; %%% This is important - salinity maximum needs to 
                          %%% be deeper or else you end up with very weak 
                          %%% buoyancy frequency just below the pycnocline


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

    rho0 = 1000;
    f = f0+beta*YY;
    f_mid = (f(2:end,:)+f(1:end-1,:))/2;

    rho_east_insitu  = gsw_rho(SA_east,CT_east,-zz); %%% in-situ density
    drhody = (rho_east_insitu(2:end,:)-rho_east_insitu(1:end-1,:))./dy(1);
    uEast_mid = g/rho0./f_mid.*cumsum(drhody,2,'reverse');
    uEast_TWV(2:end-1,:) = (uEast_mid(1:end-1,:)+uEast_mid(2:end,:))/2; %%% Thermal-wind velocity

    %     %%%%%% Calculate wind-driven velocity in the surface Ekman layer
    %     %%% Assume a constant vertical eddy viscosity (A_z = 0.1 m^2/s)
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
    %     tau_wind = rho_a*C_ao*abs(uwind(1,:).^2+vwind(1,:).^2)'; %%% Total surface wind stress
    %     a_EK = sqrt(abs(f(:,1))/2/A_z); %%% Constant 'a' in Ekman theory
    %     V0_EK = tau_wind./sqrt(rho_o.^2.*abs(f(:,1))*A_z);
    % 
    %     angle_uvwind = atan(abs(Va/Ua))/pi*180; %%% Angle of zonal and meridional wind, in degrees
    %     for jj = 1:Ny
    %         for kk=1:D_EK_idx(jj)
    %             az = a_EK(jj)*zz(kk);
    %             v_ek(jj,kk) = V0_EK(jj)*exp(az)*cos(pi/4+az); %%% Ekman velocity aligned with the direction of the surface wind stress
    %             u_ek(jj,kk) = V0_EK(jj)*exp(az)*sin(pi/4+az); %%% Ekman velocity perpendicular to the direction of the surface wind stress
    %             uEast_EK(jj,kk) = -(v_ek(jj,kk)*cos(angle_uvwind)+u_ek(jj,kk)*sin(angle_uvwind)); %%% Ekman velocity in the zonal direction
    %             if(uEast_EK(jj,kk)>0)
    %                 uEast_EK(jj,kk) = 0;
    %             end
    %         end
    %     end

    %%% Prescribe zonal velocity at the eastern boundary as the sum of wind-driven velocity 
    %%% in the Ekman layer and thermal-wind velocity
    %     uEast = uEast_TWV + uEast_EK; 
    uEast = uEast_TWV;

      
  if (showplots)
  figure(fignum);
  fignum = fignum + 1;
  pcolor(yy/1000,-zz/1000,uEast'.*bathy_east')
  shading flat;axis ij;
  hold on;[M,c] = contour(YY/1000,-ZZ/1000,gamma_n_east.*bathy_east,[27:0.2:27.8 27.95:0.05:28.3],'LineColor','k','LineWidth',1);
  clabel(M,c,'LabelSpacing',200);hold off;
  hold on;plot(yy/1000,-h(1,:)/1000,'k','LineWidth',3);plot(yy/1000,-h(round(Nx/2),:)/1000,'k--','LineWidth',3);
  colorbar;colormap('redblue');
  xlabel('y (km)');ylabel('Depth (km)');
  title('Eastern boundary restoring velocity (m/s)');
  set(gca,'fontsize',fontsize);
  caxis([-0.08 0.08]);
  savefig([imgpath '/Eastern_u.fig']);
  saveas(gcf,[imgpath '/Eastern_u.png']);

  figure(fignum);
  fignum = fignum + 1;
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
  savefig([imgpath '/Eastern_TS.fig']);
  saveas(gcf,[imgpath '/Eastern_TS.png']);

  figure(fignum);
  fignum = fignum + 1;
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
  savefig([imgpath '/Eastern_N2.fig']);
  saveas(gcf,[imgpath '/Eastern_N2.png']);


  figure(fignum);
  fignum = fignum + 1;
  plot(yy/1000,Zcdw_pt,'LineWidth',2)
  hold on
  plot(yy/1000,Zcdw_s,'LineWidth',2)
  hold off;
  ylabel('z (m)')
  xlabel('y (km)')
  legend('Depth of \theta_{max}','Depth of S_{max}')
  set(gca,'fontsize',fontsize);
  title('Eastern boundary CDW depth')
  savefig([imgpath '/Eastern_CDWdepth.fig']);
  saveas(gcf,[imgpath '/Eastern_CDWdepth.png']);

  end


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

  useFresher = true;
  if(useFresher)
    sSouth = sSouth-0.5;
  end


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
    plot(rho_north_sigma4,-zz,'LineWidth',1.5); axis ij;
    hold on;
    plot(rho_south_sigma4,-zz,'LineWidth',1.5); axis ij;
    hold off;
    xlabel('\rho_r_e_f (\circC)');
    ylabel('Depth (m)');
    title('Relaxation density (\sigma_4)');
    legend('Northern \rho','Southern \rho','Position',[0.3200 0.6468 0.3066 0.0738]);
    set(gca,'fontsize',fontsize);
    PLOT = gcf;
    PLOT.Position = [644 148 380 562];  
    %%% Save the figure
    savefig([imgpath '/RelaxationDensity_sigma4.fig']);
    saveas(gcf,[imgpath '/RelaxationDensity_sigma4.png']);
  end
    
    
    %%% Plot the relaxation density
  if (showplots)
    figure(fignum);
    fignum = fignum + 1;
    clf;
    plot(rho_north_sigma2,-zz,'LineWidth',1.5); axis ij;
    hold on;
    if (Nr > 1)
        plot(rho_south_sigma2,-zz,'-','LineWidth',1.5); axis ij;
    else 
        plot(rho_south_sigma2,-zz,':','LineWidth',1.5); axis ij;        
    end
    hold off;
    xlabel('\rho_r_e_f (\circC)');
    ylabel('Depth (m)');
    title('Relaxation density (\sigma_2)');
    legend('Northern \rho','Southern \rho','Position',[0.3200 0.6468 0.3066 0.0738]);
    set(gca,'fontsize',fontsize);
    PLOT = gcf;
    PLOT.Position = [644 148 380 562];  
    %%% Save the figure
    savefig([imgpath '/RelaxationDensity_sigma2.fig']);
    saveas(gcf,[imgpath '/RelaxationDensity_sigma2.png']);
  end
    
    
    
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
    %%% Save the figure
    savefig([imgpath '/RelaxationDensity_surf.fig']);
    saveas(gcf,[imgpath '/RelaxationDensity_surf.png']);
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
    %%% Save the figure
    savefig([imgpath '/RelaxationT.fig']);
    saveas(gcf,[imgpath '/RelaxationT.png']);
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
    %%% Save the figure
    savefig([imgpath '/RelaxationS.fig']);
    saveas(gcf,[imgpath '/RelaxationS.png']);
  end
    
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% DEFORMATION RADIUS %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  if (Nr > 1)
    %%% Check Brunt-Vaisala frequency using full EOS
    [N2_north, pp_mid_north] = gsw_Nsquared(SA_north,CT_north,-zz,latN);
    [N2_south, pp_mid_south] = gsw_Nsquared(SA_south,CT_south,-zz,latS);
    dzData = zz(1:end-1)-zz(2:end);

    %%% Calculate internal wave speed and first Rossby radius of deformation
    N = sqrt(N2_north);
    Cig = zeros(size(yy));
    for j=1:Ny    
      for k=1:length(dzData)
        if (zz(k) > h(1,j))        
          Cig(j) = Cig(j) + N(k)*min(dzData(k),zz(k)-h(1,j));
        end
      end
    end
    Rd = Cig./(pi*abs(f0+beta*Y(1,:)));

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
      %%% Save the figure
      savefig([imgpath '/BuoyancyFrequency.fig']);
      saveas(gcf,[imgpath '/BuoyancyFrequency.png']);
    end
    

    if (showplots)
      figure(fignum);
      fignum = fignum + 1;
      clf;
      plot(yy/1000,Rd/1000,'LineWidth',1.5);
      xlabel('Offshore distance (km)');
      ylabel('R_d (km)');
      title('First baroclinic Rossby deformation radius');
      set(gca,'fontsize',fontsize-1);
      PLOT = gcf;
      PLOT.Position = [263 149 567 336];  
      %%% Save the figure
      savefig([imgpath '/R_d.fig']);
      saveas(gcf,[imgpath '/R_d.png']);
    end
    
  
  else
    
    Cig = 0;
    
  end
  
  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% CALCULATE TIME STEP %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
  
  
  %%% These estimates are in no way complete, but they give at least some
  %%% idea of the time step needed to keep things stable. In complicated 
  %%% simulations, preliminary tests may be required to estimate the
  %%% parameters used to calculate these time steps.        
  
  %%% Gravity wave CFL

  %%% Upper bound for absolute horizontal fluid velocity (m/s)
  %%% At the moment this is just an estimate
%   Umax = 1
  Umax = 2
  %%% Max gravity wave speed
  cmax = max(Cig)
  %%% Max gravity wave speed using total ocean depth
  cgmax = Umax + cmax;
  %%% Advective CFL
  deltaT_adv = min([0.5*dx/cmax,0.5*dy/cmax]);
  %%% Gravity wave CFL
  deltaT_gw = min([0.5*dx/Umax,0.5*dy/Umax]);
  %%% CFL time step based on full gravity wave speed
  deltaT_fgw = min([0.5*dx/cgmax,0.5*dy/cgmax]);
    
  %%% Other stability conditions
  
  %%% Inertial CFL time step (Sf0<=0.5)
  deltaT_itl = 0.5/abs(f0);
  %%% Time step constraint based on horizontal diffusion 
  deltaT_Ah = 0.5*min([dx dy])^2/(4*viscAh);    
  %%% Time step constraint based on vertical diffusion
  deltaT_Ar = 0.5*min(dz)^2 / (4*viscAr);  
  %%% Time step constraint based on biharmonic viscosity 
  deltaT_A4 = 0.5*min([dx dy])^4/(32*viscA4);
  %%% Time step constraint based on horizontal diffusion of temp 
  deltaT_KhT = 0.4*min([dx dy])^2/(4*diffKhT);    
  %%% Time step constraint based on vertical diffusion of temp 
  deltaT_KrT = 0.4*min(dz)^2 / (4*diffKrT);
  
  %%% Time step size  
  deltaT = min([deltaT_fgw deltaT_gw deltaT_adv deltaT_itl deltaT_Ah deltaT_Ar deltaT_KhT deltaT_KrT deltaT_A4]);
  deltaT = round(deltaT) 
%   deltaT = 140
%   deltaT = round(deltaT/4)

  nTimeSteps = ceil(simTime/deltaT);
  simTimeAct = nTimeSteps*deltaT
  
  %%% Write end time and time step size  
  parm03.addParm('endTime',nIter0*deltaT+simTimeAct,PARM_INT);
  parm03.addParm('deltaT',deltaT,PARM_REAL); 

  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% INITIAL DATA %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%
    
  %%% Random noise amplitude
  tNoise = 0.01;  
  sNoise = 0.001;
      
  %%% Align initial temp with background
  hydroTh = ones(Nx,Ny,Nr);
  hydroSa = ones(Nx,Ny,Nr);
  for k=1:1:Nr
    hydroTh(:,:,k) = squeeze(hydroTh(:,:,k))*tNorth(k);
    hydroSa(:,:,k) = squeeze(hydroSa(:,:,k))*sNorth(k);
  end
  
  %%% Add some random noise
  if (~isBarotropic)
    hydroTh = hydroTh + tNoise*(2*rand(Nx,Ny,Nr)-1);
    hydroSa = hydroSa + sNoise*(2*rand(Nx,Ny,Nr)-1);
  end
  
  %%% Write to data files
  writeDataset(hydroTh,fullfile(inputpath,'hydrogThetaFile.bin'),ieee,prec); 
  parm05.addParm('hydrogThetaFile','hydrogThetaFile.bin',PARM_STR);
  writeDataset(hydroSa,fullfile(inputpath,'hydrogSaltFile.bin'),ieee,prec); 
  parm05.addParm('hydrogSaltFile','hydrogSaltFile.bin',PARM_STR); 
  
  %%% High-resolution runs must be restarted from the end of a
  %%% low-resolution run via doubleRes, which creates the initialization 
  %%% files indicated here
  if (is_ContinuedRun)
    parm05.addParm('uVelInitFile','uVelInitFile.bin',PARM_STR);  
    parm05.addParm('vVelInitFile','vVelInitFile.bin',PARM_STR);  
    parm05.addParm('pSurfInitFile','pSurfInitFile.bin',PARM_STR);  %initial free surface position
  end
    
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% TRACER DIFFUSION %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  %%% Set biharmonic diffusivities as a fraction of the maximum stable
  %%% grid-scale hyperdiffusion
  diffK4T = diffK4Tgrid * max([dx dy])^4 / (32*deltaT);
  diffK4S = diffK4Sgrid * max([dx dy])^4 / (32*deltaT);
  parm01.addParm('diffK4T',diffK4T,PARM_REAL); 
  parm01.addParm('diffK4S',diffK4S,PARM_REAL); 
  
  
  
  

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% WRITE THE 'data' FILE %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
  %%% Creates the 'data' file
  write_data(inputpath,PARM,listterm,realfmt);
 

  
  %%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%
  %%%%% RBCS %%%%%
  %%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%
  
  if(useRBCS)   
  %%%%%%%%%%%%%%%%%%%%%%%
  %%%%% RBCS SET-UP %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%
  
  %%% To store parameter names and values
  rbcs_parm01 = parmlist;
  rbcs_parm02 = parmlist;
  RBCS_PARM = {rbcs_parm01,rbcs_parm02};
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% RELAXATION PARAMETERS %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  useRBCtemp = true;
  useRBCsalt = false;
  useRBCuVel = false;
  useRBCvVel = false;
  tauRelaxT = 1*t1hour;
  rbcs_parm01.addParm('useRBCtemp',useRBCtemp,PARM_BOOL);
  rbcs_parm01.addParm('useRBCsalt',useRBCsalt,PARM_BOOL);
  rbcs_parm01.addParm('useRBCuVel',useRBCuVel,PARM_BOOL);
  rbcs_parm01.addParm('useRBCvVel',useRBCvVel,PARM_BOOL);
  rbcs_parm01.addParm('tauRelaxT',tauRelaxT,PARM_REAL);


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% RELAXATION TEMPERATURE/SALINITY %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  %%% Set relaxation temp/salt to the freezing temperature
  %%% of the northern boundary
  temp_relax = zeros(Nx,Ny,Nr);
  temp_relax(:,:,1) = tNorth(1); 
  
  %%% Save as parameters
  writeDataset(temp_relax,fullfile(inputpath,'sponge_temp.bin'),ieee,prec); 
  rbcs_parm01.addParm('relaxTFile','sponge_temp.bin',PARM_STR);
  
  %%%%%%%%%%%%%%%%%%%%%  
  %%%%% RBCS MASK %%%%%
  %%%%%%%%%%%%%%%%%%%%%  
  
  %%% Mask is zero everywhere by default, i.e. no relaxation
  mskT=zeros(Nx,Ny,Nr);
  mskT(:,:,1) = 1;  %%% only relax surface T
  temp_mask = mskT;
  
  %%% Save as parameters
  writeDataset(temp_mask,fullfile(inputpath,'rbcs_temp_mask.bin'),ieee,prec); 
  rbcs_parm01.addParm('relaxMaskFile(1)','rbcs_temp_mask.bin',PARM_STR);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% WRITE THE 'data.rbcs' FILE %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
  %%% Creates the 'data.rbcs' file
  write_data_rbcs(inputpath,RBCS_PARM,listterm,realfmt);
  end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%% SEA ICE   %%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
 if (useSEAICE)
  % to store parameter names and values
  seaice_parm01 = parmlist;
  SEAICE_PARM = {seaice_parm01};

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% SEA ICE  %%%%%%%%%%%%
    %%%%%%%% PARAMETERS %%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  SEAICEscaleSurfStress= true; % In the updated code (updated in Aug,2019),this issue has been solved. 20200121
                               % By default, the sea ice stresses are not 
                               % multiplied by the sea ice concentration. 
                               % http://mailman.mitgcm.org/pipermail/mitgcm-support/2017-August/011248.html
  SEAICEwriteState   = true;
  SEAICEuseDYNAMICS  = true;
  SEAICE_multDim     = 7;
  SEAICE_dryIceAlb   = 0.8783;
%   SEAICE_dryIceAlb   = 0.8509;
  SEAICE_wetIceAlb   = 0.7869;
%   SEAICE_wetIceAlb   = 0.7284;
  SEAICE_drySnowAlb  = 0.9482;
%   SEAICE_drySnowAlb  = 0.7754;
  SEAICE_wetSnowAlb  = 0.8216;
%   SEAICE_wetSnowAlb  = 0.7753;
  SEAICE_waterDrag   = 5.5399/1000; % water-ice drag coefficient (non-dim.)
  SEAICE_drag        = 0.002;   % air-ice drag coefficient (non-dim.)
  HO                 = 0.1; 
%   HO                 = .05;

  SEAICE_no_slip          = false;
%   SEAICE_no_slip          = true;

%   SEAICEadvScheme         = 7;
  SEAICEadvScheme         = 33;
  SEAICEmomAdvection      = false; % Default: false
  %%%SOSEdoesn't have a seaice dataset for salinity, they used this value
  %%%in their estimate
  
  LSR_ERROR               = 1.0e-5;  
  SEAICEnonLinIterMax     = 10;
  
  MIN_ATEMP               = -50;
  MIN_TICE                = -50;
  SEAICE_area_reg         = 0.15;
  SEAICE_hice_reg         = 0.1;
  IMAX_TICE               = 6;
  SEAICE_EPS		      = 1.0e-8;
%   SEAICE_EPS              = 2.0e-9;
  SEAICE_doOpenWaterMelt  = true;
  SEAICE_areaLossFormula  = 1;
  SEAICE_wetAlbTemp       = 0.0;
  SEAICE_saltFrac         = 0.3;
%   SEAICE_frazilFrac       = 0.003;
 SEAICE_frazilFrac       = 0.01;
%   SEAICE_frazilFrac       = 1.0; % frazil to sea ice conversion rate, as fraction (relative to the local freezing point of sea ice water)
  
 
  Hs0 = 0; % Initial snow thickness = 0.1 m
  Si0 = 6; % The salinity for 1m sea ice is about 6 g/kg. Cox et al., (1974). Salinity variations in sea ice. 
  rho_i = 920; % Density of sea ice

  
  % Initial fractional sea ice cover, range[0,1]; initializes variable AREA;
  Area = Ai0.*ones(Nx,Ny);
%   Area(:,Ny-seaiceSpongeThickness:Ny) = 0;
  % Initial sea ice thickness averaged over grid cell in meters; initializes variable HEFF;
  Heff = Hi0.*ones(Nx,Ny); 
%   Heff(:,Ny-seaiceSpongeThickness:Ny) = 0;
  % Initial snow thickness on sea ice averaged over grid cell in meters; initializes variable HSNOW;
  Hsnow = Hs0.*ones(Nx,Ny);
  % Initial salinity of sea ice averaged over grid cell in g/m^2; initializes variable HSALT;
  Hsalt = (Si0*rho_i*Hi0).*ones(Nx,Ny); 
  
  uIce = zeros(Nx,Ny); %%% Initial sea ice velosity
  vIce = zeros(Nx,Ny);
  
  AreaFile = 'AreaFile.bin';
  HeffFile = 'HeffFile.bin';
  HsnowFile = 'HsnowFile.bin';
  HsaltFile = 'HsaltFile.bin';
  uIceFile = 'uIceFile.bin';
  vIceFile = 'vIceFile.bin';  
  
  writeDataset(Area,fullfile(inputpath,AreaFile),ieee,prec);
  writeDataset(Heff,fullfile(inputpath,HeffFile),ieee,prec);
  writeDataset(Hsnow,fullfile(inputpath,HsnowFile),ieee,prec);
  writeDataset(Hsalt,fullfile(inputpath,HsaltFile),ieee,prec);  
  writeDataset(uIce,fullfile(inputpath,uIceFile),ieee,prec);
  writeDataset(vIce,fullfile(inputpath,vIceFile),ieee,prec); 
  
  seaice_parm01.addParm('SEAICEscaleSurfStress',SEAICEscaleSurfStress,PARM_BOOL);
  seaice_parm01.addParm('LSR_ERROR',LSR_ERROR,PARM_REAL);
  seaice_parm01.addParm('SEAICEnonLinIterMax',SEAICEnonLinIterMax,PARM_INT);
  seaice_parm01.addParm('SEAICEwriteState',SEAICEwriteState,PARM_BOOL);
  seaice_parm01.addParm('SEAICEuseDYNAMICS',SEAICEuseDYNAMICS,PARM_BOOL);
  seaice_parm01.addParm('SEAICE_multDim',SEAICE_multDim,PARM_INT);
  seaice_parm01.addParm('SEAICE_dryIceAlb',SEAICE_dryIceAlb,PARM_REAL);
  seaice_parm01.addParm('SEAICE_wetIceAlb',SEAICE_wetIceAlb,PARM_REAL);
  seaice_parm01.addParm('SEAICE_drySnowAlb',SEAICE_drySnowAlb,PARM_REAL);
  seaice_parm01.addParm('SEAICE_wetSnowAlb',SEAICE_wetSnowAlb,PARM_REAL);
  seaice_parm01.addParm('SEAICE_waterDrag',SEAICE_waterDrag,PARM_REAL);
  seaice_parm01.addParm('SEAICE_drag',SEAICE_drag,PARM_REAL);
  seaice_parm01.addParm('HO',HO,PARM_REAL);
  seaice_parm01.addParm('SEAICE_no_slip',SEAICE_no_slip,PARM_BOOL);
  seaice_parm01.addParm('SEAICEadvScheme',SEAICEadvScheme,PARM_INT);
  seaice_parm01.addParm('SEAICEmomAdvection',SEAICEmomAdvection,PARM_BOOL);
  seaice_parm01.addParm('MIN_ATEMP',MIN_ATEMP,PARM_REAL);
  seaice_parm01.addParm('MIN_TICE',MIN_TICE,PARM_REAL);
  seaice_parm01.addParm('SEAICE_area_reg',SEAICE_area_reg,PARM_REAL);
  seaice_parm01.addParm('SEAICE_hice_reg',SEAICE_hice_reg,PARM_REAL);
  seaice_parm01.addParm('IMAX_TICE',IMAX_TICE,PARM_INT);
  seaice_parm01.addParm('SEAICE_EPS',SEAICE_EPS,PARM_REAL);
  seaice_parm01.addParm('SEAICE_doOpenWaterMelt',SEAICE_doOpenWaterMelt,PARM_BOOL);
  seaice_parm01.addParm('SEAICE_areaLossFormula',SEAICE_areaLossFormula,PARM_INT);
  seaice_parm01.addParm('SEAICE_wetAlbTemp',SEAICE_wetAlbTemp,PARM_REAL);
  seaice_parm01.addParm('SEAICE_saltFrac',SEAICE_saltFrac,PARM_REAL);
  seaice_parm01.addParm('SEAICE_frazilFrac',SEAICE_frazilFrac,PARM_REAL);

  seaice_parm01.addParm('HeffFile',HeffFile,PARM_STR);
  seaice_parm01.addParm('AreaFile',AreaFile,PARM_STR);
  seaice_parm01.addParm('HsnowFile',HsnowFile,PARM_STR);
  seaice_parm01.addParm('HsaltFile',HsaltFile,PARM_STR);
  seaice_parm01.addParm('uIceFile',uIceFile,PARM_STR);
  seaice_parm01.addParm('vIceFile',vIceFile,PARM_STR);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% WRITE THE 'data.seaice' FILE %%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  write_data_seaice(inputpath,SEAICE_PARM,listterm,realfmt);  
 end
  

 
  %%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% LAYERS SET-UP %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%
  
 if (useLAYERS)

  %%% To store parameter names and values
  layers_parm01 = parmlist;
  LAYERS_PARM = {layers_parm01};
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% LAYERS PARAMETERS %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
  %%% Define parameters for layers package %%%
  

  %%% Number of fields for which to calculate layer fluxes
  % The number of possible layers coordinates (max number of tracer fields used for layer averaging)
  layers_maxNum = 2;
%   layers_maxNum = 1;

%   %%% Specify potential density
  layers_name = char('RHO','TH'); 
%     layers_name = char('RHO'); 

% % % %%% Hires, sdiff3, sdiff2.5, sdiff2
% % %      layers_bounds(:,1) = [0 30 36.4 36.54:0.02:36.66 ...
% % %          36.7 36.73 36.76 36.8:0.1:37.1 ...
% % %          37.13:0.02:37.17 37.19:0.004:37.206 ...
% % %          37.21:0.003:37.29 ...
% % %          37.295:0.015:37.4 ...
% % %          37.41 37.42 37.422:0.003:37.425 37.426 37.428 37.429 37.43 37.45 37.5 40]; 
% % %      layers_bounds(:,2) = [-10 -1.88:0.005:-1.83 -1.8:0.05:-1.2 -1.18:0.02:-1.16 -1.144:0.002:-1.18 -1.15:0.05:0.95 10];
     
     
% % % % % %%%%% Hires, ssurf33, surf33.56, surf34.12_0dS, surf34.12_1dS
     layers_bounds(:,1) = [0 35 ...
         35.8:0.05:36.3 ...
         36.4 36.54:0.02:36.66 ...
         36.7 36.73 36.76 36.8:0.1:37.1 ...
         37.13:0.02:37.17 37.18:0.004:37.206 ...
         37.21:0.003:37.3 37.5 40]; 
     layers_bounds(:,2) = [-10 -1.88:0.01:-1.78 -1.76:0.05:-1.2 -1.18:0.02:-1.16 -1.144:0.002:-1.18 -1.15:0.05:1 10];




  %%% Reference level for calculation of potential density
  layers_krho = [51 1];    %%% Pressure reference level, level indice k
  %   layers_krho = 51 % High-resolution zz (51)=-1.9943e+03 m;

  
  %%% If set true, the GM bolus velocity is added to the calculation
  layers_bolus = false;  
   
  %%% Layers
    for nl=1:layers_maxNum    
%       layers_parm01.addParm(['layers_bounds'],layers_bounds,PARM_REALS); 
%       layers_parm01.addParm(['layers_krho'],layers_krho,PARM_INT); 
%       layers_parm01.addParm(['layers_name'],strtrim(layers_name),PARM_STR); 
      layers_parm01.addParm(['layers_name(' num2str(nl) ')'],strtrim(layers_name(nl,:)),PARM_STR); 
      layers_parm01.addParm(['layers_krho(' num2str(nl) ')'],layers_krho(nl),PARM_INT); 
      layers_parm01.addParm(['layers_bounds(:,' num2str(nl) ')'],layers_bounds(:,nl),PARM_REALS); 
    end
      layers_parm01.addParm('layers_bolus',layers_bolus,PARM_BOOL); 

  
  
  %%z% Create the data.layers file
  write_data_layers(inputpath,LAYERS_PARM,listterm,realfmt);
  
  %%% Create the LAYERS_SIZE.h file
  createLAYERSSIZEh(codepath,length(layers_bounds)-1,layers_maxNum); 
  
 end
  
  

  %%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%
  %%%%% DIAGNOSTICS %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% DIAGNOSTICS SET-UP %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
   
  %%% To store parameter names and values
  diag_parm01 = parmlist;
  diag_parm02 = parmlist;
  DIAG_PARM = {diag_parm01,diag_parm02};
  diag_matlab_parm01 = parmlist;
  DIAG_MATLAB_PARM = {diag_matlab_parm01}; %%% Matlab parameters need to be different
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% DIAGNOSTICS PARAMETERS %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  
  
  %%% Stores total number of diagnostic quantities
  ndiags = 0;
       
  diag_parm01.addParm('diag_mnc',false,PARM_BOOL);  
  diag_parm01.addParm('diag_pickup_read',false,PARM_BOOL);  
  diag_parm01.addParm('diag_pickup_write',false,PARM_BOOL);  


%%% Annual mean diagnostics
diag_fields_avg = {...   
% % %     ... %%%%%%%%% for spin-up
    'UVEL','VVEL', 'WVEL',...
    'SALT','THETA',...
    'ETAN',...
    'UVELSQ','VVELSQ','WVELSQ'...
    'TOTTTEND','TFLUX','VVELTH','UVELTH','WVELTH','ADVy_TH',...
... % % %     'TOTTTEND','TFLUX','VVELTH','ADVy_TH','oceQnet','oceSflux',...
%       ... %%%%%%%%% for analysis
%       ... %%% Heat budget
%          'TOTTTEND','TFLUX','KPPg_TH','oceQsw','WTHMASS',...
%          'ADVr_TH','ADVx_TH','ADVy_TH','DFxE_TH','DFyE_TH','DFrI_TH','DFrE_TH',...
%          ...
%          'VVELTH', ...
%          'oceQnet','UVELTH','WVELTH',...
%       ... %%% Energy budget
%          'UVELSQ','VVELSQ','WVELSQ',...
%          'UV_VEL_Z','WU_VEL','WV_VEL',...
%          ...
%       ... %%% Salt budget
%          'TOTSTEND','SFLUX','KPPg_SLT','oceFWflx','WSLTMASS',...
%          'ADVr_SLT','ADVx_SLT','ADVy_SLT','DFrE_SLT','DFxE_SLT','DFyE_SLT','DFrI_SLT',...
%          ...
%          'VVELSLT',...
%          'oceSflux','UVELSLT','WVELSLT',...
%       ... %%% Momentum budget
%          'ETAN',...
%          'oceTAUX','oceTAUY',...
%      ... %%% Overturning streamfunction
%          'RHOAnoma','LaUH1RHO','LaHw1RHO','LaTr1RHO',... 
%                     'LaUH2TH','LaHw2TH',... 
%      ...
%          'Um_Diss','Um_Advec','Um_dPhiX','Um_Ext',...
%          'Vm_Diss','Vm_Advec','Vm_Cori','Vm_dPhiY','Vm_Ext','Vm_AdvZ3','Vm_AdvRe',...
%          'VISrI_Um','VISrI_Vm',...
     };
      
  numdiags_avg = length(diag_fields_avg);  
  diag_freq_avg = 1*t1year;
%   diag_freq_avg = 1*t1day;
%   diag_freq_avg = 2*t1day;


  diag_phase_avg = 0;    
      
  for n=1:numdiags_avg    
    ndiags = ndiags + 1;
    diag_parm01.addParm(['fields(1,',num2str(n),')'],diag_fields_avg{n},PARM_STR);  
    diag_parm01.addParm(['fileName(',num2str(n),')'],diag_fields_avg{n},PARM_STR);  
    diag_parm01.addParm(['frequency(',num2str(n),')'],diag_freq_avg,PARM_REAL);  
    diag_parm01.addParm(['timePhase(',num2str(n),')'],diag_phase_avg,PARM_REAL); 
    diag_matlab_parm01.addParm(['diag_fields{1,',num2str(n),'}'],diag_fields_avg{n},PARM_STR);  
    diag_matlab_parm01.addParm(['diag_fileNames{',num2str(n),'}'],diag_fields_avg{n},PARM_STR);  
    diag_matlab_parm01.addParm(['diag_frequency(',num2str(n),')'],diag_freq_avg,PARM_REAL);  
    diag_matlab_parm01.addParm(['diag_timePhase(',num2str(n),')'],diag_phase_avg,PARM_REAL);   
  end
  
  
  if(useSEAICE)
      diag_fields_avg2 = {...  
               'SIheff'
    %          'PHIHYD','LaVH1RHO','LaHs1RHO','LaVH2TH','LaHs2TH'...
             };
      numdiags_avg2 = length(diag_fields_avg2);  
      diag_freq_avg2 = 1*t1year;
      diag_phase_avg2 = 0;   
    

      diag_fields_avg3 = {...  
         'SIarea','SIheff','SIuice','SIvice','SIsig12',...
         'SItices','SIqnet','SIempmr','SIatmQnt',...
         'SItaux','SItauy','SIatmTx','SIatmTy',...   
             };
      numdiags_avg3 = length(diag_fields_avg2);  
      diag_freq_avg3 = 1*t1year;
      diag_phase_avg3 = 0;  



      for n=1:numdiags_avg2    
        ndiags = ndiags + 1;
        diag_parm01.addParm(['fields(1,',num2str(ndiags),')'],diag_fields_avg2{n},PARM_STR);  
        diag_parm01.addParm(['fileName(',num2str(ndiags),')'],diag_fields_avg2{n},PARM_STR);  
        diag_parm01.addParm(['frequency(',num2str(ndiags),')'],diag_freq_avg2,PARM_REAL);  
        diag_parm01.addParm(['timePhase(',num2str(ndiags),')'],diag_phase_avg2,PARM_REAL); 
        diag_matlab_parm01.addParm(['diag_fields{1,',num2str(ndiags),'}'],diag_fields_avg2{n},PARM_STR);  
        diag_matlab_parm01.addParm(['diag_fileNames{',num2str(ndiags),'}'],diag_fields_avg2{n},PARM_STR);  
        diag_matlab_parm01.addParm(['diag_frequency(',num2str(ndiags),')'],diag_freq_avg2,PARM_REAL);  
        diag_matlab_parm01.addParm(['diag_timePhase(',num2str(ndiags),')'],diag_phase_avg2,PARM_REAL);  
      end

      for n=1:numdiags_avg3   
        ndiags = ndiags + 1;
        diag_parm01.addParm(['fields(1,',num2str(ndiags),')'],diag_fields_avg3{n},PARM_STR);  
        diag_parm01.addParm(['fileName(',num2str(ndiags),')'],diag_fields_avg3{n},PARM_STR);  
        diag_parm01.addParm(['frequency(',num2str(ndiags),')'],diag_freq_avg3,PARM_REAL);  
        diag_parm01.addParm(['timePhase(',num2str(ndiags),')'],diag_phase_avg3,PARM_REAL); 
        diag_matlab_parm01.addParm(['diag_fields{1,',num2str(ndiags),'}'],diag_fields_avg3{n},PARM_STR);  
        diag_matlab_parm01.addParm(['diag_fileNames{',num2str(ndiags),'}'],diag_fields_avg3{n},PARM_STR);  
        diag_matlab_parm01.addParm(['diag_frequency(',num2str(ndiags),')'],diag_freq_avg3,PARM_REAL);  
        diag_matlab_parm01.addParm(['diag_timePhase(',num2str(ndiags),')'],diag_phase_avg3,PARM_REAL);  
      end

  end

  
diag_fields_inst = {...
%     'SALT','THETA',...
%   'ETAN', 'PHIHYD',...
%   'UVEL','VVEL', 'WVEL',,
%     'SIheff',...
%         'LaVH1RHO','LaHs1RHO','LaVH2TH','LaHs2TH', ...
%         'RHOAnoma','LaUH1RHO','LaHw1RHO','LaTr1RHO','LaUH2TH','LaHw2TH'...
      };
  numdiags_inst = length(diag_fields_inst);  
   diag_freq_inst = 30*t1day;
%   diag_freq_inst =1*t1year;
  diag_phase_inst = 0;
  
  for n=1:numdiags_inst    
    ndiags = ndiags + 1;
    diag_parm01.addParm(['fields(1,',num2str(ndiags),')'],diag_fields_inst{n},PARM_STR);  
    diag_parm01.addParm(['fileName(',num2str(ndiags),')'],[diag_fields_inst{n},'_inst'],PARM_STR);  
    diag_parm01.addParm(['frequency(',num2str(ndiags),')'],-diag_freq_inst,PARM_REAL);  
    diag_parm01.addParm(['timePhase(',num2str(ndiags),')'],diag_phase_inst,PARM_REAL); 
    diag_matlab_parm01.addParm(['diag_fields(1,',num2str(ndiags),')'],diag_fields_inst{n},PARM_STR);  
    diag_matlab_parm01.addParm(['diag_fileNames(',num2str(ndiags),')'],[diag_fields_inst{n},'_inst'],PARM_STR);  
    diag_matlab_parm01.addParm(['diag_frequency(',num2str(ndiags),')'],-diag_freq_inst,PARM_REAL);  
    diag_matlab_parm01.addParm(['diag_timePhase(',num2str(ndiags),')'],diag_phase_inst,PARM_REAL);     
  end
  



  %%% Create the data.diagnostics file
  write_data_diagnostics(inputpath,DIAG_PARM,listterm,realfmt);
  
  %%% Create the DIAGNOSTICS_SIZE.h file
  if(useLAYERS)
    createDIAGSIZEh(codepath,ndiags,max(Nr,length(layers_bounds)-1));
  else
    createDIAGSIZEh(codepath,ndiags,Nr);
  end
  



  %%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%
  %%%%% OBCS %%%%%
  %%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%
    
  %%%%%%%%%%%%%%%%%%%%%%%
  %%%%% OBCS SET-UP %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%
  
  
  %%% To store parameter names and values
  %%% Add 2-element cell arrays to this cell array in the form 
  %%%  OBCS_PARM{1} = addParameter(OBCS_PARM{1},'paramName',paramValue,parmType);
  %%% to specify additional parameters. The parameter type parmType must
  %%% take one of the integer values above.
    %%% To store parameter names and values
  obcs_parm01 = parmlist;
  obcs_parm02 = parmlist;
  obcs_parm03 = parmlist;
  obcs_parm04 = parmlist;
  obcs_parm05 = parmlist;
  OBCS_PARM = {obcs_parm01,obcs_parm02,obcs_parm03,obcs_parm05};  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% DEFINE OPEN BOUNDARY TYPES (OBCS_PARM01) %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%% Set boundary points that are open   
  if (useobcsNorth)
      OB_Jnorth= Ny*ones(1,Nx);
      obcs_parm01.addParm('OB_Jnorth',OB_Jnorth,PARM_INTS); 
      OB_Jsouth = ones(1,Nx);
      obcs_parm01.addParm('OB_Jsouth',OB_Jsouth,PARM_INTS); 
  else
      OB_Jsouth = Nx*0;   %%% Need to modify data.obcs (eg, OB_Jsouth=200*0,)
      obcs_parm01.addParm('OB_Jsouth',OB_Jsouth,PARM_INTS); 
  end

  if(use2Orlanski|useEobcsWorlanski|useEobcsWobcs)
      OB_Ieast= Nx*ones(1,Ny);
      obcs_parm01.addParm('OB_Ieast',OB_Ieast,PARM_INTS); 
      OB_Iwest= ones(1,Ny);
      obcs_parm01.addParm('OB_Iwest',OB_Iwest,PARM_INTS); 
  end
 
  
%   tidalPeriod= [43200,43200,43200,43200,43200,43200,43200,43200,43200,43200];
  tidalPeriod= [86400,86400,86400,86400,86400,86400,86400,86400,86400,86400];
%   tidalPeriod=[44714.16,43200.,45569.88,43081.92,86164.2,92949.48,86637.24,96726.24,1180295.64,2380716];
  obcs_parm01.addParm('useOBCStides',useOBCStides,PARM_BOOL);
  
  if (useOBCStides)
          obcs_parm01.addParm('tidalPeriod',tidalPeriod,PARM_INTS);    
     if (useobcsNorth)
          OBNamFile= 'OBNam.obcs';
          OBNphFile= 'OBNph.obcs';
          obcs_parm01.addParm('OBNamFile',OBNamFile,PARM_STR);  
          obcs_parm01.addParm('OBNphFile',OBNphFile,PARM_STR); 
     end
          OBSamFile= 'OBSam.obcs';
          OBSphFile= 'OBSph.obcs';
          obcs_parm01.addParm('OBSamFile',OBSamFile,PARM_STR);  
          obcs_parm01.addParm('OBSphFile',OBSphFile,PARM_STR); 



     % create tidal input files
        tidalComponents=10;
     if (useobcsNorth)
         OBns = {'N','S'};
     else
         OBns ={'S'};
     end
     
        for ob = OBns
            OBlength=Ny;
            if any(strcmp(ob,{'N','S'}))
                OBlength=Nx;
            end
            for fld={'am','ph'}
                fnm=['OB' ob{1} fld{1} '.obcs'];
                tmp=randn(OBlength,tidalComponents)/1000;

%                 Atide = 0.05;
                Phase = 2 * 3600;

                % specify (0.1 m/s, 2 hr) for North boundary tidal component 1
                if strcmp(ob,'N')
                    if strcmp(fld,'am')
                        tmp(:,1) = tmp(:,1) + Atide;
                    else
                        if(varyingtidalphase)
                            varyingphase = 0.5*t1hour;
                            for iPH = 1:Nx
                                tmp(iPH,1)=tmp(iPH,1)+(Phase-varyingphase/2)+varyingphase/Nx*iPH;
                            end
                        else
                            tmp(:,1) = tmp(:,1) + Phase;
                        end
                    end
                end
                % specify (0.1 m/s, 2 hr) for South boundary tidal component 1
                if strcmp(ob,'S')
                    if strcmp(fld,'am')
%                         tmp(:,1) = tmp(:,1) + Atide*H/Hshelf;
                        Atide_south =  Atide*H/(Hshelf-Hbed)*Lx/(Xeast-Xwest)
                        tmp(:,1) = tmp(:,1) + Atide_south;
                    else
                        if(varyingtidalphase)
                            varyingphase = 0.5*t1hour;
                            for iPH = 1:Nx
                                tmp(iPH,1)=tmp(iPH,1)+(Phase-varyingphase/2)+varyingphase/Nx*iPH;
                            end
                        else
                            tmp(:,1) = tmp(:,1) + Phase;
                        end
                    end
                end
                
                writeDataset(tmp,fullfile(inputpath,fnm),ieee,prec);
            end
        end

  else 
      Atide = 0;
  end
  
  
 
  
  %%% Enforces mass conservation across the northern boundary by adding a
  %%% barotropic inflow/outflow  
  useOBCSbalance = true;  
  obcs_parm01.addParm('useOBCSbalance',useOBCSbalance,PARM_BOOL);

  if (useobcsNorth)
    OBCS_balanceFacN = 1; %%% A value -1 balances an individual boundary
    OBCS_balanceFacS = 1;
    obcs_parm01.addParm('OBCS_balanceFacN',OBCS_balanceFacN,PARM_REAL); 
    obcs_parm01.addParm('OBCS_balanceFacS',OBCS_balanceFacS,PARM_REAL);  
  else 
    OBCS_balanceFacS = -1;
    obcs_parm01.addParm('OBCS_balanceFacS',OBCS_balanceFacS,PARM_REAL);  
  end

  if(use2Orlanski|useEobcsWorlanski|useEobcsWobcs)
      OBCS_balanceFacE = 1; %%% A value -1 balances an individual boundary
      OBCS_balanceFacW = 1;
      obcs_parm01.addParm('OBCS_balanceFacE',OBCS_balanceFacE,PARM_REAL); 
      obcs_parm01.addParm('OBCS_balanceFacW',OBCS_balanceFacW,PARM_REAL);  
  end

  
  %%% Enables/disables sponge layers   
  useOBCSsponge = true;
  obcs_parm01.addParm('useOBCSsponge',useOBCSsponge,PARM_BOOL);
    
  if(useSEAICE)
      useSeaiceSponge = true;
      obcs_parm01.addParm('useSeaiceSponge',useSeaiceSponge,PARM_BOOL);
  else 
      useSeaiceSponge = false;
  end
  
  %%% Set boundary velocities and temperatures to be consistent with the
  %%% streamfunction psi = alpha*x*y, u=-dpsi/dy, v=dpsi/dx
  useOBCSprescribe = true;  
  
  OBNt = ones(Nx,1)*tNorth;
  OBNs = ones(Nx,1)*sNorth;
  OBSt = ones(Nx,1)*tSouth;
  OBSs = ones(Nx,1)*sSouth;
  
%   %%% Write boundary variables to files  
  if (useobcsNorth)
      writeDataset(OBNt,fullfile(inputpath,'OBNtFile.bin'),ieee,prec);
      writeDataset(OBNs,fullfile(inputpath,'OBNsFile.bin'),ieee,prec);
  end
  writeDataset(OBSt,fullfile(inputpath,'OBStFile.bin'),ieee,prec);
  writeDataset(OBSs,fullfile(inputpath,'OBSsFile.bin'),ieee,prec);

  %%% Set OBCS prescription parameters
  obcs_parm01.addParm('useOBCSprescribe',useOBCSprescribe,PARM_BOOL);
  if (useobcsNorth)
      obcs_parm01.addParm('OBNtFile','OBNtFile.bin',PARM_STR);
      obcs_parm01.addParm('OBNsFile','OBNsFile.bin',PARM_STR);
  end
  obcs_parm01.addParm('OBStFile','OBStFile.bin',PARM_STR);
  obcs_parm01.addParm('OBSsFile','OBSsFile.bin',PARM_STR);

  if(useEobcsWorlanski) %%% OBCS to the east, and Orlanski to the west
      OBEt = tEast;
      OBEs = sEast;
      OBEu = uEast;
      %%%%%% Define OBCS Eastern boundary
      writeDataset(OBEt,fullfile(inputpath,'OBEtFile.bin'),ieee,prec);
      writeDataset(OBEs,fullfile(inputpath,'OBEsFile.bin'),ieee,prec);
      writeDataset(OBEu,fullfile(inputpath,'OBEuFile.bin'),ieee,prec);
      obcs_parm01.addParm('OBEtFile','OBEtFile.bin',PARM_STR);
      obcs_parm01.addParm('OBEsFile','OBEsFile.bin',PARM_STR);
      obcs_parm01.addParm('OBEuFile','OBEuFile.bin',PARM_STR);
  end

  if(useEobcsWobcs) %%% OBCS to the east and west
      OBEt = tEast;
      OBEs = sEast;
      OBEu = uEast;
      %%%%%% Define OBCS Eastern boundary
      writeDataset(OBEt,fullfile(inputpath,'OBEtFile.bin'),ieee,prec);
      writeDataset(OBEs,fullfile(inputpath,'OBEsFile.bin'),ieee,prec);
      writeDataset(OBEu,fullfile(inputpath,'OBEuFile.bin'),ieee,prec);
      obcs_parm01.addParm('OBEtFile','OBEtFile.bin',PARM_STR);
      obcs_parm01.addParm('OBEsFile','OBEsFile.bin',PARM_STR);
      obcs_parm01.addParm('OBEuFile','OBEuFile.bin',PARM_STR);
      %%%%%% Define OBCS Western boundary, the same as OBCS Eastern boundary
      writeDataset(OBEt,fullfile(inputpath,'OBWtFile.bin'),ieee,prec);
      writeDataset(OBEs,fullfile(inputpath,'OBWsFile.bin'),ieee,prec);
      writeDataset(OBEu,fullfile(inputpath,'OBWuFile.bin'),ieee,prec);
      obcs_parm01.addParm('OBWtFile','OBWtFile.bin',PARM_STR);
      obcs_parm01.addParm('OBWsFile','OBWsFile.bin',PARM_STR);
      obcs_parm01.addParm('OBWuFile','OBWuFile.bin',PARM_STR);
  end


    if(useSEAICE)

%%% Calculate free-drift ice velocities at the southern boundary, ignoring
%%% ice internal stress, pressure caused by sea surface hight variation.
%%% Assume zonal ocean velocity at the coast = 0, 
%%% meridional ocean at the coast averaged over tidal cycles = 0,            
%%% fractional ice cover Ai0 = 1.
    rho_o = 1027;         %%% Water density, kg/m^3
    tao_aix = rho_a*SEAICE_drag*sqrt(Ua^2+Va^2)*Ua;       %%% Air-ice stress in x direction, N/m2
    tao_aiy = rho_a*SEAICE_drag*sqrt(Ua^2+Va^2)*Va;       %%% Air-ice stress in y direction, N/m2
    syms ui vi
    eq1 =  rho_i*Hi0*f0*vi + tao_aix - rho_o*SEAICE_waterDrag*sqrt(ui^2+vi^2)*ui;
    eq2 = -rho_i*Hi0*f0*ui + tao_aiy - rho_o*SEAICE_waterDrag*sqrt(ui^2+vi^2)*vi;
    eqns = [eq1, eq2];
    [solui solvi] = solve(eqns,[ui vi]);
    Sui = double(real(solui));
    Svi = double(real(solvi));
    ui_idx = (Sui<0);
    obsuice = Sui(ui_idx)
    obsvice = Svi(ui_idx)
    

    if(Ua == 0 && Va == 0)
        obsuice = 0
        obsvice = 0
    end

    OBSa = Ai0.*ones(Nx,1);
    OBSh = Hi0.*ones(Nx,1);
    OBSsn = Hs0.*ones(Nx,1); %%% snow thickness
    OBSsl = Si0.*ones(Nx,1); %%% sea ice salinity
    OBSuice = obsuice.*ones(Nx,1); %%% Initial zonal ice velocity should be westward (negative!) or zero.
    OBSvice = obsvice.*ones(Nx,1);
    writeDataset(OBSa,fullfile(inputpath,'OBSaFile.bin'),ieee,prec);
    writeDataset(OBSh,fullfile(inputpath,'OBShFile.bin'),ieee,prec);
    writeDataset(OBSsn,fullfile(inputpath,'OBSsnFile.bin'),ieee,prec);
    writeDataset(OBSsl,fullfile(inputpath,'OBSslFile.bin'),ieee,prec);
    writeDataset(OBSuice,fullfile(inputpath,'OBSuiceFile.bin'),ieee,prec);
    writeDataset(OBSvice,fullfile(inputpath,'OBSviceFile.bin'),ieee,prec);
    obcs_parm01.addParm('OBSaFile','OBSaFile.bin',PARM_STR);
    obcs_parm01.addParm('OBShFile','OBShFile.bin',PARM_STR);
    obcs_parm01.addParm('OBSsnFile','OBSsnFile.bin',PARM_STR);
    obcs_parm01.addParm('OBSslFile','OBSslFile.bin',PARM_STR);
    obcs_parm01.addParm('OBSuiceFile','OBSuiceFile.bin',PARM_STR);
    obcs_parm01.addParm('OBSviceFile','OBSviceFile.bin',PARM_STR);
   
    
    OBNa = Ai0.*ones(Nx,1);
    OBNh = Hi0.*ones(Nx,1);
    OBNsn = Hs0.*ones(Nx,1); %%% snow thickness
    OBNsl = Si0.*ones(Nx,1); %%% sea ice salinity
    OBNuice = obsuice.*ones(Nx,1); %%% Initial zonal ice velocity should be westward (negative!) or zero.
    OBNvice = obsvice.*ones(Nx,1);
    
    writeDataset(OBNa,fullfile(inputpath,'OBNaFile.bin'),ieee,prec);
    writeDataset(OBNh,fullfile(inputpath,'OBNhFile.bin'),ieee,prec);
    writeDataset(OBNsn,fullfile(inputpath,'OBNsnFile.bin'),ieee,prec);
    writeDataset(OBNsl,fullfile(inputpath,'OBNslFile.bin'),ieee,prec);
    writeDataset(OBNuice,fullfile(inputpath,'OBNuiceFile.bin'),ieee,prec);
    writeDataset(OBNvice,fullfile(inputpath,'OBNviceFile.bin'),ieee,prec);
    obcs_parm01.addParm('OBNaFile','OBNaFile.bin',PARM_STR);
    obcs_parm01.addParm('OBNhFile','OBNhFile.bin',PARM_STR);
    obcs_parm01.addParm('OBNsnFile','OBNsnFile.bin',PARM_STR);
    obcs_parm01.addParm('OBNslFile','OBNslFile.bin',PARM_STR);
    obcs_parm01.addParm('OBNuiceFile','OBNuiceFile.bin',PARM_STR);
    obcs_parm01.addParm('OBNviceFile','OBNviceFile.bin',PARM_STR);
    
    
    end

    if(~useSEAICE)
        obsuice=NaN;
        obsvice=NaN;
        lwdown=NaN;
    end




  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% ORLANSKI OPTIONS (OBCS_PARM02) %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%% Enables/disables Orlanski radiation conditions at the boundaries -
  %%% allows waves to propagate out through the boundary with minimal
  %%% reflection  
  obcs_parm01.addParm('useOrlanskiNorth',useOrlanskiNorth,PARM_BOOL);
  obcs_parm01.addParm('useOrlanskiSouth',useOrlanskiSouth,PARM_BOOL);

  if(use2Orlanski|useEobcsWorlanski|useEobcsWobcs)
      obcs_parm01.addParm('useOrlanskiEast',useOrlanskiEast,PARM_BOOL);
      obcs_parm01.addParm('useOrlanskiWest',useOrlanskiWest,PARM_BOOL);
      %%% Velocity averaging time scale - must be larger than deltaT.
      %%% The Orlanski radiation condition computes the characteristic velocity
      %%% at the boundary by averaging the spatial derivative normal to the 
      %%% boundary divided by the time step over this period.
      %%% At the moment we're using the magic engineering factor of 3.
      cvelTimeScale = 3*deltaT; % Averaging period for phase speed (s)
      %%% Max dimensionless CFL for Adams-Basthforth 2nd-order method
      CMAX = 0.45; 
      
      obcs_parm02.addParm('cvelTimeScale',cvelTimeScale,PARM_REAL);
      obcs_parm02.addParm('CMAX',CMAX,PARM_REAL);
  end

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% SPONGE LAYER OPTIONS (OBCS_PARM03) %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   obcs_parm03.addParm('spongeThickness',spongeThickness,PARM_INT);

    Vrelaxobcsinner = 864000;
    Vrelaxobcsbound = 43200;
%   %% Relaxation time at meridional boundaries set to time for inflow to
%   %% cross the sponge layer
%   Vrelaxobcsbound = spongeThicknessDim/(abs(alpha)*Ly/2);
  
  obcs_parm03.addParm('Vrelaxobcsinner',Vrelaxobcsinner,PARM_REAL);
  obcs_parm03.addParm('Vrelaxobcsbound',Vrelaxobcsbound,PARM_REAL);

  if(useEobcsWorlanski|useEobcsWobcs)
        Urelaxobcsinner = 864000;
        Urelaxobcsbound = 43200;
        obcs_parm03.addParm('Urelaxobcsinner',Urelaxobcsinner,PARM_REAL);
        obcs_parm03.addParm('Urelaxobcsbound',Urelaxobcsbound,PARM_REAL);  
  end

  
    
  if (useSeaiceSponge)
       T_relaxinner = 864000/10;
       T_relaxbound = 43200/6;
    Arelaxobcsinner = T_relaxinner;
    Arelaxobcsbound = T_relaxbound;
    Hrelaxobcsinner = T_relaxinner;
    Hrelaxobcsbound = T_relaxbound;
    SLrelaxobcsinner = T_relaxinner;
    SLrelaxobcsbound = T_relaxbound;
    SNrelaxobcsinner = T_relaxinner;
    SNrelaxobcsbound = T_relaxbound;
    obcs_parm05.addParm('seaiceSpongeThickness',seaiceSpongeThickness,PARM_INT);
    obcs_parm05.addParm('Arelaxobcsinner',Arelaxobcsinner,PARM_REAL);
    obcs_parm05.addParm('Arelaxobcsbound',Arelaxobcsbound,PARM_REAL);
    obcs_parm05.addParm('Hrelaxobcsinner',Hrelaxobcsinner,PARM_REAL);
    obcs_parm05.addParm('Hrelaxobcsbound',Hrelaxobcsbound,PARM_REAL);
    obcs_parm05.addParm('SLrelaxobcsinner',SLrelaxobcsinner,PARM_REAL);
    obcs_parm05.addParm('SLrelaxobcsbound',SLrelaxobcsbound,PARM_REAL);
    obcs_parm05.addParm('SNrelaxobcsinner',SNrelaxobcsinner,PARM_REAL);
    obcs_parm05.addParm('SNrelaxobcsbound',SNrelaxobcsbound,PARM_REAL);
  end
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% WRITE THE 'data.obcs' FILE %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
  
  %%% Creates the 'data.obcs' file
  write_data_obcs(inputpath,OBCS_PARM,listterm,realfmt);

  
  
 



  
  %%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%
  %%%%% PACKAGES %%%%%
  %%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%
  
  packages = parmlist;
  PACKAGE_PARM = {packages};  
  
  packages.addParm('useDiagnostics',true,PARM_BOOL);    
  packages.addParm('useKPP',true,PARM_BOOL);
  packages.addParm('useRBCS',useRBCS,PARM_BOOL);        
  packages.addParm('useEXF',useEXF,PARM_BOOL);        
  packages.addParm('useCAL',useEXF,PARM_BOOL); 
  packages.addParm('useSEAICE',useSEAICE,PARM_BOOL);
  packages.addParm('useOBCS',useOBCS,PARM_BOOL);  
  packages.addParm('useLAYERS',useLAYERS,PARM_BOOL);  

  %%% Create the data.pkg file
  write_data_pkg(inputpath,PACKAGE_PARM,listterm,realfmt);
  
  
 
    
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% WRITE PARAMETERS TO A MATLAB FILE %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %%% Creates a matlab file defining all input parameters
  ALL_PARMS =[PARM PACKAGE_PARM DIAG_MATLAB_PARM];
  if (useRBCS)
      ALL_PARMS = [ALL_PARMS RBCS_PARM];
  end
  if (useEXF)
      ALL_PARMS = [ALL_PARMS EXF_PARM];
  end
  if (useSEAICE)
    ALL_PARMS = [ALL_PARMS SEAICE_PARM];
  end  
  if (useLAYERS)
    ALL_PARMS = [ALL_PARMS LAYERS_PARM];
  end  
  %%% Creates a matlab file defining all input parameters
  write_matlab_params(inputpath,ALL_PARMS,realfmt);
  
  

end






    %%% Specifies shape of coastal walls. Must satisfy f=1 at x=0 and f=0 at
    %%% x=1.
    %%%
    function f = coastShape (x)
     
      f = 0.5.*(1+cos(pi*x));
    %   f = exp(-x);
    %   f = 1-x;
      
    end

