%%%
%%% calcNeutralDensity.m
%%%
%%% Calculates the neutral density using eos80_legacy_gamma_n
%%%


addpath /Users/csi/Software/eos80_legacy_gamma_n/;
addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
addpath /Users/csi/Software/gsw_matlab_v3_06_11;
addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;
addpath /Users/csi/MITgcm_ASF-csi/newexp_utils/;
 

loadexp;

long = ncread('KappNorvegiaCLM.nc','lon'); % -17
lat = ncread('KappNorvegiaCLM.nc','lat');  % -71
%  long  =  longitude in decimal degrees                     [ 0 ... +360 ]
%                                                      or [ -180 ... +180 ]
%  lat   =  latitude in decimal degrees north               [ -90 ... +90 ]

% SP = ncread('KappNorvegiaCLM.nc','salt');
% t = ncread('KappNorvegiaCLM.nc','ptemp');
% p = ncread('KappNorvegiaCLM.nc','pressure');

%  SP    =  Practical Salinity                                 [ unitless ]
%  t     =  in-situ temperature (ITS-90)                          [ deg C ]
%  p     =  sea pressure                                           [ dbar ] 
%          ( i.e. absolute pressure - 10.1325 dbar )
%  p, lat & long may have dimensions 1x1 or Mx1 or 1xN or MxN,
%  where SP & t is MxN.
%  SA  =  Absolute Salinity                                        [ g/kg ]
%  pt0 =  potential temperature with reference pressure = 0 dbar  [ deg C ]

rho0 = 999.8; % Is this right? %%% in model/src/set_defaults.F, rhoNil = 999.8 _d 0
pt0 = THETA;
pt0(pt0==0)=NaN;
SP = SALT;
SP(SP==0)=NaN;
p = repmat(reshape(-zz,[1 1 Nr]),[Nx Ny 1])+PHIHYD*rho0/1e4;

pt0_reshape = reshape(pt0,[Nx Ny*Nr]);
SP_reshape = reshape(SP,[Nx Ny*Nr]);
p_reshape = reshape(p,[Nx Ny*Nr]);
[SA_reshape, in_ocean] = gsw_SA_from_SP(SP_reshape,p_reshape,long,lat);
t_reshape = gsw_t_from_pt0(SA_reshape,pt0_reshape,p_reshape);
t = reshape(t_reshape,[Nx Ny Nr]);
%%% Calculates the neutral density gamma_n
% [gamma_n, gamma_error_lower, gamma_error_upper] = eos80_legacy_gamma_n(SP,t,p,long,lat);
gamma_n = eos80_legacy_gamma_n(SP,t,p,long,lat);

% save([prodir expname '_gamma_n.mat'],'t','p','gamma_n','gamma_error_lower','gamma_error_upper')
 save([prodir expname '_gamma_n.mat'],'gamma_n');
 
figure(1)
pcolor(squeeze(mean(t,1))');shading interp;axis ij;colorbar

figure(2)
pcolor(SP(:,:,1));shading interp;axis ij;colorbar
figure(3)
pcolor(gamma_n(:,:,1));shading interp;axis ij;colorbar
