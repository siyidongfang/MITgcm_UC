%%% 
%%% calc_CDW_quasi_stfn.m
%%%
%%% Calculate the quasi-streamfunction of the CDW layer

ptlevs = layers_bounds(:,2);
Npt = length(ptlevs)-1;

load([prodir expname '_tavg_5yrs.mat'],'LaUH2TH','LaVH2TH');
uflux_tavg = LaUH2TH; %%% Layer Integrated zonal Transport (UH, m^2/s)
vflux_tavg = LaVH2TH; %%% Layer Integrated merid. Transport (VH, m^2/s)

% Calculate depth-integrated (time-averaged) zonal, meridional isopycnal fluxes
UFLUXZ = cumsum(uflux_tavg, 3, 'forward');
VFLUXZ = cumsum(vflux_tavg, 3, 'forward');

kidx = find(ptlevs==0); %%% index of the zero degree isotherm in ptlevs
UFLUXZ_CDW = UFLUXZ(:,:,kidx);
VFLUXZ_CDW = VFLUXZ(:,:,kidx);

%%% Grid spacing matrices
DXpt = repmat(delX', [1 Ny Npt]);
DYpt = repmat(delY,[Nx 1 Npt]);