%%% setReadvariables.m
%%% 
%%% Read the variables needed by calcEnergyBudget.m

%%% Load experiment
loadexp;

%%% Frequency of diagnostic output - should match that specified in
%%% data.diagnostics.
dumpFreq = diag_frequency(64);
nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);

%%% Time averages
uu = readIters(exppath,'UVEL',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);
vv = readIters(exppath,'VVEL',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);
ww = readIters(exppath,'WVEL',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);
tt = readIters(exppath,'THETA',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);
ss = readIters(exppath,'SALT',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);
usq = readIters(exppath,'UVELSQ',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);
vsq = readIters(exppath,'VVELSQ',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);
wt = readIters(exppath,'WVELTH',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);   % Vertical Transport of Pot Temp
ws = readIters(exppath,'WVELSLT',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);   % Vertical Transport of Salinity
uv = readIters(exppath,'UV_VEL_Z',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr); % Meridional Transport of Zonal Momentum (m^2/s^2)
uw = readIters(exppath,'WU_VEL',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);   % Vertical Transport of Zonal Momentum
vw = readIters(exppath,'WV_VEL',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);   % Vertical Transport of Meridional Momentum
tAlpha = 2e-4; % linear EOS thermal expansion coefficient (1/degC)
sBeta = 7.4e-4; % linear EOS haline contraction coefficient (1/psu)

load ([exppath '/input/setParams'],'Ua','Va')
uwind = [Ua:-Ua/(Ny-1):0].*ones(Nx,1); 
vwind = [Va:-Va/(Ny-1):0].*ones(Nx,1); 
rho_a = 1.3;               %%% Air density, kg/m^3
zonalWind = rho_a.*SEAICE_drag.*sqrt(uwind.^2+vwind.^2).*uwind;
meridionalWind = rho_a.*SEAICE_drag.*sqrt(uwind.^2+vwind.^2).*vwind;


%%% Store computed data for later
save([prodir '/' expname,'_variables_5yrs.mat'],'dumpFreq','nDumps','dumpIters','uu','vv','ww','tt','usq','vsq','wt', ... 
  'uv','uw','vw','tAlpha','zonalWind','meridionalWind'); 

% save([prodir '/' expname,'_variables_595days.mat'],'uu','tt','ss'); 