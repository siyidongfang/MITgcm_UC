%%%
%%% calcIsopStreamfunc.m
%%%
%%% Plots the time-mean barotropic streamfunction. Assumes an experiment
%%% has been loaded, e.g.:
%%%
%%% setExpname;
%%% setTimeframe;
%%% loadexp;
%%%

%%% Load experiment
loadexp;

%%% Density bins for MOC calculation  
ptlevs = layers_bounds;
Npt = length(ptlevs)-1;

%%% Frequency of diagnostic output - should match that specified in
%%% data.diagnostics.
dumpFreq = abs(diag_frequency(1));
nDumps = round(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
nDumps = length(dumpIters);

%%% Grid spacing matrices
DY = repmat(delY,[Nx 1]);

%%% Calculate time-averaged isopycnal flux, density and velocity
uflux_tavg = zeros(Nx,Ny,Npt);
navg = 0;
for n=1:length(dumpIters)
 
  tyears = dumpIters(n)*deltaT/86400/365;
 
  if ((tyears >= tmin) && (tyears <= tmax))    

    [tyears dumpIters(n)]
    uflux = rdmdsWrapper(fullfile(exppath,'results/LaUH1TH'),dumpIters(n));      
    
    if (isempty(uflux))
      ['Ran out of data at n=',num2str(n),'/',num2str(nDumps),' t=',num2str(tyears),' days.']
      break;
    else
      uflux_tavg = uflux_tavg + uflux;      
      navg = navg + 1;
    end
  end
   
end

%%% Calculate the time average
if (navg == 0)
  error('No data files found');
end
uflux_tavg = uflux_tavg/navg;

%%% Vertically integrate zonal fluxes
uflux_tot = sum(uflux_tavg,3);

%%% Integrate meridionally to obtain streamfunction
Psi = zeros(Nx+1,Ny+1);
Psi(1:Nx,1:Ny) = flipdim(cumsum(flipdim(uflux_tot.*DY,2),2),2);
Psi(:,Ny+1) = 0;
Psi(Nx+1,:) = Psi(1,:);