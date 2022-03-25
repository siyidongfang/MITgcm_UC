%%%
%%% avg_ASF.m
%%%
%%% Averages ECCO model output.
%%%
%%% imin --- Minimum i-index to average over, range 1-(imax-1)
%%% imax --- Maximum i-index to average over, range (imin+1)-N
%%% face --- LLC model face number, range 1-5
%%% N --- Gridpoints per LLC face, should be either 2160 or 4320
%%% start_date --- Date on which to start, in 'dd-mmm-yyyy' format
%%% end_date --- Date on which to end, in 'dd-mmm-yyyy' format
%%% step_len --- Length of step between data reads
%%% do_avg --- Set true to average data over each step
%%% avg_step --- Length of step to take within averages  
%%% cycle_iters --- Set true to cycle iterations depending on imax and imin - can be useful to prevent parallel processes from all accessing the same files
%%% restart --- Set true to pick up averaging from a previous run
%%% outfreq --- Frequency of output, i.e. number of steps between write
%%% output_suff --- String to append to output files to identify them
%%%
function avg_ASF (imin, imax, face, N, ...
                  start_date, end_date, step_len, ...
                  do_avg, avg_step, cycle_iters, ...
                  restart, outfreq, output_suff)

  %%% Paths to required matlab scripts
  if (~isdeployed)
    addpath FORTRAN_NAMELIST
    addpath /u/dmenemen/matlab
  end
 
  gn=['/u/dmenemen/llc_',num2str(N),'/grid/'];
  if (N == 2160)
    pn1=['/u/dmenemen/llc_',num2str(N),'/MITgcm/run_day49_624/'];
    pn2=['/u/dmenemen/llc_',num2str(N),'/MITgcm/run/'];
  end
  if (N == 4320)
    pn1=['/u/dmenemen/llc_',num2str(N),'/MITgcm/run/'];
    pn2=['/u/dmenemen/llc_',num2str(N),'/MITgcm/run_485568/'];
  end  
  outfn = ['/nobackup/astewar8/averages_llc',num2str(N),'_face',num2str(face),'_i',num2str(imin),'_',num2str(imax),output_suff,'.mat'];
  
  %%% Set false to use the old, first-order accurate estimate of vorticity
  %%% fluxes and stretching terms. Set true to use the exact model
  %%% discretization.
  use_exact_disc = true; 
  
  %%% Set true to include fourth-order vorticity advection terms
  use_fourth_vort = false;
  
  %%% Input parameter file - modified version that is compatible with
  %%% FORTRAN_NAMELIST software
  datafile = ['~/matlab/data_llc',num2str(N)];
  parm01 = read_namelist(datafile,'PARM01');
  parm02 = read_namelist(datafile,'PARM02');
  parm03 = read_namelist(datafile,'PARM03');
  parm04 = read_namelist(datafile,'PARM04');
  parm05 = read_namelist(datafile,'PARM05');

  %%% Parameters
  rho0 = parm01.rhonil;
  g = 9.81;
  Cd = parm01.bottomdragquadratic;
  rho_ice = 910; %%% Default MITgcm ice and snow densities
  rho_snow = 330;  
  calc_phi_from_top = false; %%% Set true to calculate pressure from top down, false to calculate from bottom up
  
  %%% Define domain box
  bb_l = imin;
  bb_r = imax;
  irange = bb_l:1:bb_r;
  Nx = length(irange);  
  bb_b = 1;
  if (face == 1)
    bb_b = floor(865*N/2160); %%% Lowest latitudinal points that contain data
  end
  if (face == 2)
    bb_b = floor(1153*N/2160);
%     bb_b = floor((1153+400)*N/2160); %%% FOR SMALL-BOX TEST
  end
  if (face == 4)
    bb_b = floor(433*N/2160);
  end
  if (face == 5)
    bb_b = floor(577*N/2160);    
%     bb_b = floor((577+650)*N/2160); %%% FOR SMALL-BOX TEST   
  end
  bb_t = N*(1-2/27);
%   bb_t = floor((1153+600)*N/2160); %%% FOR SMALL-BOX TEST
%   bb_t = floor((577+800)*N/2160); %%% FOR SMALL-BOX TEST
  jrange = bb_b:1:bb_t;
  Ny = length(jrange);
  krange = 1:86; %%% Maximum vertical index that is now available  
  Nr = length(krange);
  Nr_is_bot = (max(krange)==90); %%% LLC vertical grid has 90 levels
  
  %%% Vertical grids
  fid = fopen([gn 'RC.data'],'r','b');
  rc = fread(fid,max(krange),'real*4');
  rc = rc(krange);
  fclose(fid);
  fid = fopen([gn 'RF.data'],'r','b');
  rf = fread(fid,max(krange)+1,'real*4');
  rf = rf([krange krange(end)+1]);
  fclose(fid);
  fid = fopen([gn 'DRC.data'],'r','b');
  drc = fread(fid,max(krange)+1,'real*4');
  drc = drc([krange krange(end)+1]);
  fclose(fid);
  fid = fopen([gn 'DRF.data'],'r','b');
  drf = fread(fid,max(krange),'real*4');
  drf = drf(krange);
  fclose(fid);
%   fid = fopen([gn 'RhoRef.data'],'r','b');
%   rho_ref = fread(fid,max(krange),'real*4');
%   rho_ref = rho_ref(krange);
%   fclose(fid);
  
  %%% Indices of zonal "halo" points
  lidx = irange(1) - 1;
  ridx = irange(end) + 1;  

  %%% Extract grid
  dxc = zeros(Nx+2,Ny,1);
  dyc = zeros(Nx+2,Ny,1);
  dxg = zeros(Nx+2,Ny,1);
  dyg = zeros(Nx+2,Ny,1);
  hFacC = zeros(Nx+1,Ny,Nr);
  hFacS = zeros(Nx+2,Ny,Nr);
  hFacW = zeros(Nx+2,Ny,Nr);
  rac = zeros(Nx+1,Ny,1);
  raw = zeros(Nx,Ny,1);
  ras = zeros(Nx,Ny,1);
  raz = zeros(Nx+1,Ny,1);
  irange_ext_uv = irange;
  irange_ext_ts = irange;
  irange_ext_dx = irange;
  idx_uv = 2:Nx+1;
  idx_dx = 1:Nx;
  idx_ts = 2:Nx+1;
  if (irange(end) < N)
    irange_ext_uv = [irange_ext_uv ridx];
    irange_ext_dx = [irange_ext_dx ridx];
    idx_uv = [idx_uv Nx+2];
    idx_dx = [idx_dx Nx+1];
  end
  if (irange(1) > 1)
    irange_ext_uv = [lidx irange_ext_uv];
    irange_ext_ts = [lidx irange_ext_ts];
    idx_uv = [1 idx_uv];
    idx_ts = [1 idx_ts];
  end
  fn=[gn 'DXC.data'];
  dxc(idx_uv,:)=read_llc_fkij(fn,N,face,1,irange_ext_uv,jrange);
  fn=[gn 'DYC.data'];
  dyc(idx_uv,:)=read_llc_fkij(fn,N,face,1,irange_ext_uv,jrange);
  fn=[gn 'hFacC.data'];
  hFacC(idx_ts,:,:)=read_llc_fkij(fn,N,face,krange,irange_ext_ts,jrange);
  fn=[gn 'hFacS.data'];
  hFacS(idx_uv,:,:)=read_llc_fkij(fn,N,face,krange,irange_ext_uv,jrange);
  fn=[gn 'hFacW.data'];
  hFacW(idx_uv,:,:)=read_llc_fkij(fn,N,face,krange,irange_ext_uv,jrange);
  fn=[gn 'XC.data'];
  xc=read_llc_fkij(fn,N,face,1,irange,jrange);
  fn=[gn 'YC.data'];
  yc=read_llc_fkij(fn,N,face,1,irange,jrange);
  fn=[gn 'RAW.data'];
  raw=read_llc_fkij(fn,N,face,1,irange,jrange);
  fn=[gn 'RAS.data'];
  ras=read_llc_fkij(fn,N,face,1,irange,jrange);
  fn=[gn 'RAZ.data'];
  raz(idx_dx,:,:)= read_llc_fkij(fn,N,face,1,irange_ext_dx,jrange);
  fn=[gn 'RAC.data'];
  rac(idx_ts,:,:)=read_llc_fkij(fn,N,face,1,irange_ext_ts,jrange);
%   fn=[gn 'XG.data'];
%   xg=read_llc_fkij(fn,N,face,1,irange,jrange);
%   fn=[gn 'YG.data'];
%   yg=read_llc_fkij(fn,N,face,1,irange,jrange);  
  fn=[gn 'DXG.data'];
  dxg(idx_uv,:,1)=read_llc_fkij(fn,N,face,1,irange_ext_uv,jrange);
  fn=[gn 'DYG.data'];
  dyg(idx_uv,:,1)=read_llc_fkij(fn,N,face,1,irange_ext_uv,jrange);
%   fn=[gn 'rLowC.data'];
%   rLowC=read_llc_fkij(fn,N,face,1,irange,jrange);
%   fn=[gn 'rLowS.data'];
%   rLowS=read_llc_fkij(fn,N,face,1,irange,jrange);
%   fn=[gn 'rLowW.data'];
%   rLowW=read_llc_fkij(fn,N,face,1,irange,jrange);
%   fn=[gn 'rSurfC.data'];
%   rSurfC=read_llc_fkij(fn,N,face,1,irange,jrange);
%   fn=[gn 'rSurfS.data'];
%   rSurfS=read_llc_fkij(fn,N,face,1,irange,jrange);
%   fn=[gn 'rSurfW.data'];
%   rSurfW=read_llc_fkij(fn,N,face,1,irange,jrange);
%   fn=[gn 'AngleCS.data'];
%   AngleCS=read_llc_fkij(fn,N,face,1,irange,jrange);
%   fn=[gn 'AngleSN.data'];
%   AngleSN=read_llc_fkij(fn,N,face,1,irange,jrange);
%   fn=[gn 'Depth.data'];
%   depth=read_llc_fkij(fn,N,face,1,irange,jrange);

  %%% Grids are rotated on faces 4 and 5
  if (face==4 || face==5)
    tmp = dxc;    
    dxc(:,2:end) = dyc(:,1:end-1);
    dxc(:,1) = dxc(:,2); %%% This is a bit of a hack    
    dyc(:,2:end) = tmp(:,1:end-1);
    dyc(:,1) = dyc(:,2);  
    
    tmp = dyg;   
    dyg(:,2:end) = dxg(:,1:end-1);
    dyg(:,1) = dyg(:,2); %%% This is a bit of a hack
    dxg = tmp;
    
    tmp = hFacS;   
    hFacS(:,2:end) = hFacW(:,1:end-1);
    hFacS(:,1) = hFacS(:,2); %%% This is a bit of a hack
    hFacW = tmp;
  end
  
  %%% Find lowest grid index at each horizontal position
  kLowC = sum(ceil(hFacC),3);
  kLowW = sum(ceil(hFacW),3);
  kLowS = sum(ceil(hFacS),3);
  
  %%% 3D matrices for differentiation
  DXC = repmat(dxc,[1 1 Nr]);
  DYC = repmat(dyc,[1 1 Nr]);
  DXG = repmat(dxg,[1 1 Nr]);
  DYG = repmat(dyg,[1 1 Nr]);
  DRF = repmat(reshape(drf,[1 1 Nr]),[Nx Ny 1]);
  
  %%% Grid cell area on vorticity points
  recip_RAS = 1./ras;
  recip_RAS(ras==0) = 0;
  recip_RAS = repmat(recip_RAS,[1 1 Nr]);
  recip_RAW = 1./raw;
  recip_RAW(raw==0) = 0;
  recip_RAW = repmat(recip_RAW,[1 1 Nr]);
  recip_RAZ = 1./raz;
  recip_RAZ(raz==0) = 0;
  recip_RAZ = repmat(recip_RAZ,[1 1 Nr]);
  RAC = repmat(rac,[1 1 Nr]);
  
  %%% Reciprocal of hFacs
  recip_hFacW = 1 ./ hFacW;
  recip_hFacW(hFacW==0) = 0;
  recip_hFacS = 1 ./ hFacS;
  recip_hFacS(hFacS==0) = 0;
  
  %%% Pressure  
  pp = (-rho0*g*rc(krange))/1e4;
  PP = repmat(reshape(pp,[1 1 Nr]),[Nx+1 Ny 1]); %%% Includes zonal halo at western edge of tile

  %%% For storage    
  uz = zeros(Nx,Ny,Nr);
  vz = zeros(Nx,Ny,Nr);  
  vt = zeros(Nx,Ny,Nr);
  wt = zeros(Nx,Ny,Nr);
  vs = zeros(Nx,Ny,Nr);
  ws = zeros(Nx,Ny,Nr);    
  vp = zeros(Nx,Ny,Nr);
  wp = zeros(Nx,Ny,Nr);   
  vb = zeros(Nx,Ny,Nr);
  wb = zeros(Nx,Ny,Nr); 
  uv = zeros(Nx,Ny,Nr); 
  uw = zeros(Nx,Ny,Nr); 
  vw = zeros(Nx,Ny,Nr);     
  KE = zeros(Nx+2,Ny,Nr); %%% Needed to calculate bottom stress
  Fke_top = zeros(Nx,Ny,1);
  Fke_bot = zeros(Nx,Ny,1);
    
  %%% Define/load all quantities to be averaged  
  if (restart)
    load(outfn);
    n0 = n+1;       
  else
    Fke_top_avg = zeros(Nx,Ny);
    Fke_bot_avg = zeros(Nx,Ny);
    dragU_avg = zeros(Nx,Ny);
    dragV_avg = zeros(Nx,Ny);
    u_avg = zeros(Nx,Ny,Nr);
    v_avg = zeros(Nx,Ny,Nr);
    w_avg = zeros(Nx,Ny,Nr);
    t_avg = zeros(Nx,Ny,Nr);
    s_avg = zeros(Nx,Ny,Nr);
    z_avg = zeros(Nx,Ny,Nr);
    ut_avg = zeros(Nx,Ny,Nr);
    vt_avg = zeros(Nx,Ny,Nr);
    wt_avg = zeros(Nx,Ny,Nr);
    us_avg = zeros(Nx,Ny,Nr);
    vs_avg = zeros(Nx,Ny,Nr);
    ws_avg = zeros(Nx,Ny,Nr);
    usq_avg = zeros(Nx,Ny,Nr);
    vsq_avg = zeros(Nx,Ny,Nr);
    wsq_avg = zeros(Nx,Ny,Nr);
    tsq_avg = zeros(Nx,Ny,Nr);
    ssq_avg = zeros(Nx,Ny,Nr);
    uv_avg = zeros(Nx,Ny,Nr);
    uw_avg = zeros(Nx,Ny,Nr);
    vw_avg = zeros(Nx,Ny,Nr);
    uz_avg = zeros(Nx,Ny,Nr);
    vz_avg = zeros(Nx,Ny,Nr);
    phi_avg = zeros(Nx,Ny,Nr);
    up_avg = zeros(Nx,Ny,Nr);
    vp_avg = zeros(Nx,Ny,Nr);
    wp_avg = zeros(Nx,Ny,Nr);
    b_avg = zeros(Nx,Ny,Nr);
    ub_avg = zeros(Nx,Ny,Nr);
    vb_avg = zeros(Nx,Ny,Nr);
    wb_avg = zeros(Nx,Ny,Nr); 
    uusq_avg = zeros(Nx,Ny,Nr);
    uvsq_avg = zeros(Nx,Ny,Nr);
    vusq_avg = zeros(Nx,Ny,Nr);
    vvsq_avg = zeros(Nx,Ny,Nr);
    wusq_avg = zeros(Nx,Ny,Nr);
    wvsq_avg = zeros(Nx,Ny,Nr);
    wdu_dz_avg = zeros(Nx,Ny,Nr);
    wdv_dz_avg = zeros(Nx,Ny,Nr);    
    n0 = 1; %%% First iteration number
  end      

  %%% Define list of model iterations to average over
  if (N == 2160)
    start_iter = dte2ts(start_date,parm03.deltat,2011,1,17)
    end_iter = dte2ts(end_date,parm03.deltat,2011,1,17)
  end
  if (N == 4320)
    start_iter = dte2ts(start_date,parm03.deltat,2011,9,10)
    end_iter = dte2ts(end_date,parm03.deltat,2011,9,10)
  end
  dumpStep = parm03.dumpfreq/parm03.deltat;
  dumpIters = start_iter:dumpStep:end_iter-dumpStep;
  dumpIdxs = 1:step_len:length(dumpIters)-step_len+1;
  if (cycle_iters)
    dumpIdxs = circshift(dumpIdxs',round((imin-1)/(imax-imin+1)))'; %%% Avoids processes all trying to access the same files at the same time
  end
  nIters = length(dumpIdxs); 
    
  %%% Calculate tendency terms
  DT = parm03.deltat*(end_iter-start_iter);
  du_dt = (avg_llc_fkij(end_iter,'U',pn1,pn2,N,face,krange,irange,jrange) - avg_llc_fkij(start_iter,'U',pn1,pn2,N,face,krange,irange,jrange)) / DT;
  dv_dt = (avg_llc_fkij(end_iter,'V',pn1,pn2,N,face,krange,irange,jrange) - avg_llc_fkij(start_iter,'V',pn1,pn2,N,face,krange,irange,jrange)) / DT;  
  
  %%% Loop through model iterations
  for n=n0:nIters

    %%% Print to keep track of progress
    [n dumpIdxs(n) dumpIters(dumpIdxs(n))]

    %%% Start timer
    tstart = tic();

    %%% Iterations to average over
    if (do_avg)      
      iters = dumpIters(dumpIdxs(n):avg_step:dumpIdxs(n)+step_len-1);
    else      
      iters = dumpIters(dumpIdxs(n));
    end    
    
    %%% Extract fields adding zonal "halos" to the variables
    %%% in order to allow more accurate calculation of products
    %%% N.B. This searches for data files preferentially in 'pn2' over 'pn1'
    taux = zeros(Nx+2,Ny,1);
    tauy = zeros(Nx+2,Ny,1);
    eta = zeros(Nx+1,Ny,1);
    phibot = zeros(Nx+1,Ny,1);
    SIheff = zeros(Nx+1,Ny,1);
    SIhsnow = zeros(Nx+1,Ny,1);
    u = zeros(Nx+2,Ny,Nr);
    v = zeros(Nx+2,Ny,Nr);
    w = zeros(Nx+1,Ny,Nr);
    t = zeros(Nx+1,Ny,Nr);
    s = zeros(Nx+1,Ny,Nr);
    taux(idx_uv,:,:) = avg_llc_fkij(iters,'oceTAUX',pn1,pn2,N,face,1,[irange_ext_uv],jrange);
    tauy(idx_uv,:,:) = avg_llc_fkij(iters,'oceTAUY',pn1,pn2,N,face,1,[irange_ext_uv],jrange);      
    phibot(idx_ts,:) = avg_llc_fkij(iters,'PhiBot',pn1,pn2,N,face,1,[irange_ext_ts],jrange);        
    eta(idx_ts,:) = avg_llc_fkij(iters,'Eta',pn1,pn2,N,face,1,[irange_ext_ts],jrange);
    SIheff(idx_ts,:) = avg_llc_fkij(iters,'SIheff',pn1,pn2,N,face,1,[irange_ext_ts],jrange);
    SIhsnow(idx_ts,:) = avg_llc_fkij(iters,'SIhsnow',pn1,pn2,N,face,1,[irange_ext_ts],jrange);
    u(idx_uv,:,:) = avg_llc_fkij(iters,'U',pn1,pn2,N,face,krange,[irange_ext_uv],jrange);
    v(idx_uv,:,:) = avg_llc_fkij(iters,'V',pn1,pn2,N,face,krange,[irange_ext_uv],jrange); 
    w(idx_ts,:,:) = avg_llc_fkij(iters,'W',pn1,pn2,N,face,krange,[irange_ext_ts],jrange);
    t(idx_ts,:,:) = avg_llc_fkij(iters,'Theta',pn1,pn2,N,face,krange,[irange_ext_ts],jrange);
    s(idx_ts,:,:) = avg_llc_fkij(iters,'Salt',pn1,pn2,N,face,krange,[irange_ext_ts],jrange);
        
    %%% Calculate buoyancy
    b = -g*(densjmd95(s,t,PP)-rho0)/rho0;            
    
    %%% Compute pressure        
    phi = calcPhi ( b, phibot, eta, SIheff, SIhsnow, ...
                    g, rho0, rho_ice, rho_snow, ...
                    hFacC, rf, rc, drf, drc, Nx+1, Ny, Nr, ...
                    calc_phi_from_top, Nr_is_bot);     
    
    %%% Vectors need to be rotated on faces 4 and 5    
    if (face==4 || face==5) 
      tmp = v;
      v(:,1,:) = 0;
      v(:,2:end,:) = -u(:,1:end-1,:);
      u = tmp;

      tmp = tauy;
      tauy(:,1) = 0;
      tauy(:,2:end) = -taux(:,1:end-1);
      taux = tmp;
    end        
        
    %%% Bottom drag 
    KE(1:end-1,1:end-1,:) = 0.5 * (u(1:end-1,1:end-1,:).^2+u(2:end,1:end-1,:).^2+v(1:end-1,1:end-1,:).^2+v(1:end-1,2:end,:).^2);
    dragU = zeros(Nx+1,Ny,1); %%% Includes eastern "halo" to allow energy flux calculation
    dragV = zeros(Nx+1,Ny,1);
    v_bot = zeros(Nx+1,Ny,1);
    u_bot = zeros(Nx+1,Ny,1);        
    for i=1:Nx+1
      for j=2:Ny        
        if (kLowW(i+1,j) > 0)
          u_bot(i,j) = u(i+1,j,kLowW(i+1,j));
          dragU(i,j) = - Cd * sqrt(0.5*(KE(i+1,j,kLowW(i+1,j))+KE(i,j,kLowW(i+1,j)))) * u_bot(i,j);          
        end
        if (kLowS(i+1,j) > 0)
          v_bot(i,j) = v(i+1,j,kLowS(i+1,j));
          dragV(i,j) = - Cd * sqrt(0.5*(KE(i+1,j,kLowS(i+1,j))+KE(i+1,j-1,kLowS(i+1,j)))) * v_bot(i,j);          
        end        
      end      
    end     
    
    %%% Bottom energy flux    
    Fke_bot_x = dragU.*u_bot;
    Fke_bot_y = dragV.*v_bot;    
    Fke_bot(:,1:end-1) = 0.5*(Fke_bot_x(1:end-1,1:end-1)+Fke_bot_x(2:end,1:end-1)) ...
                       + 0.5*(Fke_bot_y(1:end-1,1:end-1)+Fke_bot_y(1:end-1,2:end));
                     
    %%% Surface energy flux    
    Fke_top_x = taux(2:end,:).*u(2:end,:,1) / rho0; 
    Fke_top_y = tauy(2:end,:).*v(2:end,:,1) / rho0; 
    Fke_top(:,2:end) = 0.5*(Fke_top_x(1:end-1,1:end-1)+Fke_top_x(2:end,1:end-1)) ...
                     + 0.5*(Fke_top_y(1:end-1,1:end-1)+Fke_top_y(1:end-1,2:end));
    
    %%% Remove halos
    dragU = dragU(1:end-1,:,:);
    dragV = dragV(1:end-1,:,:); 
  
    %%% Compute vorticity on cell corners, including an additional corner
    %%% along the eastern edge of the grid cells at i=Nx    
    zeta = zeros(Nx+1,Ny,Nr);
    zeta(1:Nx+1,2:Ny,:) = ( v(2:Nx+2,2:Ny,:) .* DYC(2:Nx+2,2:Ny,:) ...
                        - u(2:Nx+2,2:Ny,:) .* DXC(2:Nx+2,2:Ny,:) ...
                        - v(1:Nx+1,2:Ny,:) .* DYC(1:Nx+1,2:Ny,:) ...
                        + u(2:Nx+2,1:Ny-1,:) .* DXC(2:Nx+2,1:Ny-1,:) ) ...
                        .* recip_RAZ(1:Nx+1,2:Ny,:);                          
    
    %%% Momentum and vorticity fluxes    
    uv(:,2:end,:) = 0.5.*(u(2:end-1,1:end-1,:)+u(2:end-1,2:end,:)) ...
                 .* 0.5.*(v(1:end-2,2:end,:)+v(2:end-1,2:end,:));
    uw(:,:,2:end) = 0.5.*(u(2:end-1,:,1:end-1)+u(2:end-1,:,2:end)) ...
                 .* 0.5.*(w(1:end-1,:,2:end)+w(2:end,:,2:end));
    vw(:,2:end,2:end) = 0.5.*(v(2:end-1,2:end,1:end-1)+v(2:end-1,2:end,2:end)) ...
                     .* 0.5.*(w(2:end,1:end-1,2:end)+w(2:end,2:end,2:end));
                   
                   
    %%% Vorticity stretching terms
    if (use_exact_disc)
      wdu_dz = zeros(Nx,Ny,Nr+1);
      wdu_dz(:,:,2:Nr) = 0.5 * (RAC(1:Nx,:,2:Nr).*w(1:Nx,:,2:Nr) + RAC(2:Nx+1,:,2:Nr).*w(2:Nx+1,:,2:Nr));
      wdu_dz(:,:,2:Nr) = wdu_dz(:,:,2:Nr) .* (-diff(u(2:Nx+1,:,:),1,3));
      wdu_dz = 0.5 * (wdu_dz(:,:,1:Nr) + wdu_dz(:,:,2:Nr+1));
      wdu_dz = wdu_dz .* recip_RAW ./ DRF .* recip_hFacW(2:Nx+1,:,:);
      wdv_dz = zeros(Nx,Ny,Nr+1);
      wdv_dz(:,2:Ny,2:Nr) = 0.5 * (RAC(2:Nx+1,1:Ny-1,2:Nr).*w(2:Nx+1,1:Ny-1,2:Nr) + RAC(2:Nx+1,2:Ny,2:Nr).*w(2:Nx+1,2:Ny,2:Nr));
      wdv_dz(:,2:Ny,2:Nr) = wdv_dz(:,2:Ny,2:Nr) .* (-diff(v(2:Nx+1,2:Ny,:),1,3));
      wdv_dz = 0.5 * (wdv_dz(:,:,1:Nr) + wdv_dz(:,:,2:Nr+1));
      wdv_dz = wdv_dz .* recip_RAS ./ DRF .* recip_hFacS(2:Nx+1,:,:);
    else    
      %%% Old discretization
      wdu_dz(:,:,2:end) = -diff(u(2:end-1,:,:),1,3) ./ DRC(:,:,2:end-1) ...
                       .* 0.5.*(w(1:end-1,:,2:end)+w(2:end,:,2:end));
      wdv_dz(:,2:end,2:end) = -diff(v(2:end-1,2:end,:),1,3) ./ DRC(:,2:end,2:end-1) ...
                           .* 0.5.*(w(2:end,1:end-1,2:end)+w(2:end,2:end,2:end));    
    end
              
    %%% Vorticity fluxes    
    %%% NOTE: This follows the MITgcm discretization, and includes the
    %%% fourth-order correction term, which adds vorticities from two
    %%% gridpoints away
    %%% TODO fourth-order terms require a larger "halo"
    if (use_exact_disc)
      vz = v .* DXG .* hFacS;
      vz = 0.5 * (vz(1:Nx,:,:) + vz(2:Nx+1,:,:));
      vz(:,1:Ny-1,:) = 0.5 * (vz(:,1:Ny-1,:) + vz(:,2:Ny,:));
      
      if (use_fourth_vort)
        vz(:,2:Ny-2,:) = vz(:,2:Ny-2,:) .* 0.5 .* (  ...
                            zeta(1:Nx,2:Ny-2,:) + zeta(1:Nx,3:Ny-1,:) ...
                          + (1/12) .* (-zeta(1:Nx,1:Ny-3,:) + zeta(1:Nx,2:Ny-2,:) + zeta(1:Nx,3:Ny-1) - zeta(1:Nx,4:Ny)) ...
                       ) ./ DXC(2:Nx+1,2:Ny-2,:);
        vz(:,[1 Ny-1 Ny],:) = 0;
      else
        vz(:,1:Ny-1,:) = vz(:,1:Ny-1,:) .* 0.5 .* (zeta(1:Nx,1:Ny-1,:) + zeta(1:Nx,2:Ny,:)) ./ DXC(2:Nx+1,1:Ny-1,:);
        vz(:,Ny,:) = 0;
      end
      vz(hFacW(2:Nx+1,:,:)==0) = 0;
    else
      vz(1:end,:,:) = v(1:end,:,:) .* 0.5.*(zeta(1:end-1,:,:)+zeta(2:end,:,:));
    end
    
    if (use_exact_disc)
      uz = u .* DYG .* hFacW;
      uz = 0.5 * (uz(2:Nx+1,:,:) + uz(3:Nx+2,:,:));
      uz(:,2:Ny,:) = 0.5 * (uz(:,1:Ny-1,:) + uz(:,2:Ny,:));     
      if (use_fourth_vort)        
        uz(2:Nx-1,:,:) = uz(2:Nx-1,:,:) .* 0.5 .* ( ...
                      zeta(2:Nx-1,:,:) + zeta(3:Nx,:,:) ...
                    + (1/12) .* (-zeta(1:Nx-2,:,:) + zeta(2:Nx-1,:,:) + zeta(3:Nx,:,:) - zeta(4:Nx+1,:,:)) ...
                    ) ./ DYC(3:Nx,:,:);
        uz([1 Nx],:,:) = 0;
      else
        uz = uz .* 0.5 .* (zeta(1:Nx,:,:) + zeta(2:Nx+1,:,:)) ./ DYC(2:Nx+1,:,:);
      end
      uz(hFacS(2:Nx+1,:,:)==0) = 0;    
    else
      uz(:,1:end-1,:) = u(:,1:end-1,:) .* 0.5.*(zeta(1:end-1,1:end-1,:)+zeta(1:end-1,2:end,:));
    end
    
    %%% Remove velocity c    
    u = u(2:end-1,:,:);
    v = v(2:end-1,:,:);
    w = w(2:end,:,:);
    
    %%% Tracer fluxes    
    ut = u .* 0.5.*(t(1:end-1,:,:)+t(2:end,:,:));    
    vt(:,2:end,:) = v(:,2:end,:) .* 0.5.*(t(2:end,1:end-1,:)+t(2:end,2:end,:));
    wt(:,:,2:end) = w(:,:,2:end) .* 0.5.*(t(2:end,:,1:end-1)+t(2:end,:,2:end));
    us = u .* 0.5.*(s(1:end-1,:,:)+s(2:end,:,:));
    vs(:,2:end,:) = v(:,2:end,:) .* 0.5.*(s(2:end,1:end-1,:)+s(2:end,2:end,:));
    ws(:,:,2:end) = w(:,:,2:end) .* 0.5.*(s(2:end,:,1:end-1)+s(2:end,:,2:end));    
    ub = u .* 0.5.*(b(1:end-1,:,:)+b(2:end,:,:));
    vb(:,2:end,:) = v(:,2:end,:) .* 0.5.*(b(2:end,1:end-1,:)+b(2:end,2:end,:));
    wb(:,:,2:end) = w(:,:,2:end) .* 0.5.*(b(2:end,:,1:end-1)+b(2:end,:,2:end));
    up = u .* 0.5.*(phi(1:end-1,:,:)+phi(2:end,:,:));
    vp(:,2:end,:) = v(:,2:end,:) .* 0.5.*(phi(2:end,1:end-1,:)+phi(2:end,2:end,:));
    wp(:,:,2:end) = w(:,:,2:end) .* 0.5.*(phi(2:end,:,1:end-1)+phi(2:end,:,2:end));
    
    %%% Remove remaining halos    
    zeta = zeta(1:end-1,:,:);
    t = t(2:end,:,:);
    s = s(2:end,:,:);
    b = b(2:end,:,:);
    phi = phi(2:end,:,:);      

    %%% Squares
    usq = u.^2;
    vsq = v.^2;
    wsq = w.^2;
    tsq = t.^2;
    ssq = s.^2;                   
    
    %%% Calculate cubic products  
    %%% NOTE: This is just a first-order approximation
    uusq = u.*usq;
    uvsq = u.*vsq;
    vusq = v.*usq;
    vvsq = v.*vsq;
    wusq = w.*usq;
    wvsq = w.*vsq;
    
    %%% Add to average
    Fke_top_avg = Fke_top_avg + Fke_top/nIters;
    Fke_bot_avg = Fke_bot_avg + Fke_bot/nIters;
    dragU_avg = dragU_avg + dragU/nIters;
    dragV_avg = dragV_avg + dragV/nIters;
    u_avg = u_avg + u/nIters;
    v_avg = v_avg + v/nIters;
    w_avg = w_avg + w/nIters; 
    t_avg = t_avg + t/nIters; 
    s_avg = s_avg + s/nIters; 
    z_avg = z_avg + zeta/nIters;
    ut_avg = ut_avg + ut/nIters;
    vt_avg = vt_avg + vt/nIters;
    wt_avg = wt_avg + wt/nIters;
    us_avg = us_avg + us/nIters;
    vs_avg = vs_avg + vs/nIters;
    ws_avg = ws_avg + ws/nIters;
    usq_avg = usq_avg + usq/nIters;
    vsq_avg = vsq_avg + vsq/nIters;
    wsq_avg = wsq_avg + wsq/nIters;
    tsq_avg = tsq_avg + tsq/nIters;
    ssq_avg = ssq_avg + ssq/nIters;
    uv_avg = uv_avg + uv/nIters;
    uw_avg = uw_avg + uw/nIters;
    vw_avg = vw_avg + vw/nIters;  
    uz_avg = uz_avg + uz/nIters;
    vz_avg = vz_avg + vz/nIters;
    phi_avg = phi_avg + phi/nIters;
    up_avg = up_avg + up/nIters;
    vp_avg = vp_avg + vp/nIters;
    wp_avg = wp_avg + wp/nIters;
    b_avg = b_avg + b/nIters;
    ub_avg = ub_avg + ub/nIters;
    vb_avg = vb_avg + vb/nIters;
    wb_avg = wb_avg + wb/nIters;
    uusq_avg = uusq_avg + uusq/nIters;
    uvsq_avg = uvsq_avg + uvsq/nIters;
    vusq_avg = vusq_avg + vusq/nIters;
    vvsq_avg = vvsq_avg + vvsq/nIters;
    wusq_avg = wusq_avg + wusq/nIters;
    wvsq_avg = wvsq_avg + wvsq/nIters;
    wdu_dz_avg = wdu_dz_avg + wdu_dz/nIters;
    wdv_dz_avg = wdv_dz_avg + wdv_dz/nIters;

    %%% Print iteration time
    toc(tstart)
    
    %%% Save to output file
    if ((mod(n,outfreq)==0) || (n==nIters))      
      save(outfn, ...
        'n', ...
        'du_dt','dv_dt', ...
        'Fke_top_avg','Fke_bot_avg','dragU_avg','dragV_avg', ...
        'u_avg','v_avg','w_avg','t_avg','s_avg','z_avg', ...      
        'ut_avg','vt_avg','wt_avg', ...
        'us_avg','vs_avg','ws_avg', ...
        'usq_avg','vsq_avg','wsq_avg','tsq_avg','ssq_avg', ...
        'uv_avg','uw_avg','vw_avg', ... 
        'uz_avg','vz_avg', ... 
        'b_avg','ub_avg','vb_avg','wb_avg', ...        
        'phi_avg','up_avg','vp_avg','wp_avg', ...
        'uusq_avg','vusq_avg','wusq_avg', ...
        'uvsq_avg','vvsq_avg','wvsq_avg', ...
        'wdu_dz_avg','wdv_dz_avg');
    end

  end
  
  %%% Clear halos from hFac matrices and append to output file
  hFacC = hFacC(1:end-1,:,:);
  hFacW = hFacW(2:end-1,:,:);
  hFacS = hFacS(2:end-1,:,:);
  save(outfn,'hFacC','hFacS','hFacW','-append');

  %%% Terminate if this is being run in compiled mode
  if (isdeployed)
    exit;
  end

end