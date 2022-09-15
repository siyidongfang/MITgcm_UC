%%%
%%% calcMomBudgetFromTendency_xint.m
%%%
%%% Convenience script to calculate the momentum budget from momentum tendency diagnostics.
%%%

rho0 = 999.8;

loadexp;
load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext');
% load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext',...
% 'Um_Cori','Um_AdvZ3','Um_AdvRe');

%%% Grid spacing matrices

Um_dPhiX(Um_dPhiX==0)=NaN;
Um_Advec(Um_Advec==0)=NaN;
Um_Diss(Um_Diss==0)=NaN;
Um_Ext(Um_Ext==0)=NaN;


%%% U momentum tendency from surface pressure horizontal gradient == 0,
%%% integrated zonally

%%% U momentum tendency from Hydrostatic Pressure gradient
Um_dPhiX_zint = rho0.*sum(Um_dPhiX.*hFacW.*DZ,3,'omitnan');

%%% U momentum tendency from Advection terms
Um_Advec_zint = rho0.*sum(Um_Advec.*hFacW.*DZ,3,'omitnan');

%%% U momentum tendency from Dissipation
Um_Diss_zint = rho0.*sum(Um_Diss.*hFacW.*DZ,3,'omitnan');

%%% U momentum tendency from external forcing
Um_Ext_zint = rho0.*sum(Um_Ext.*hFacW.*DZ,3,'omitnan');


%%% TODO: Implicit vertical viscosity tendency (Vertical Viscous Flux of U momentum (Implicit part))


% %%% U momentum tendency from Vorticity Advection
% Um_AdvZ3_xzint = rho0.*sum(sum(Um_AdvZ3(xidx,:,:).*hFacW(xidx,:,:).*DZ(xidx,:,:).*DX(xidx,:,:),3,'omitnan'),1,'omitnan');
% 
% %%% U momentum tendency from vertical Advection (Explicit part)
% Um_AdvRe_xzint = rho0.*sum(sum(Um_AdvRe(xidx,:,:).*hFacW(xidx,:,:).*DZ(xidx,:,:).*DX(xidx,:,:),3,'omitnan'),1,'omitnan');
% 
% %%% U momentum tendency from Coriolis term
Um_Cori_zint = rho0.*sum(Um_Cori.*hFacW.*DZ,3,'omitnan');

% totalchange_tendency = Um_dPhiX_zint+Um_Advec_zint+Um_Diss_zint+Um_Ext_zint+AB_gU_zint;
totalchange_tendency = Um_dPhiX_zint+Um_Advec_zint+Um_Diss_zint+Um_Ext_zint;



if(useSEAICE)
    %%% Calculate wind stress from EXF wind speeds
    rho_a = 1.3;               %%% Air density, kg/m^3
    load ([exppath '/setParams'],'Ua','Va')
    Ua(Ua==0)=1e-8;
    uwind = [Ua:-Ua/(Ny-1):0].*ones(Nx,1); 
    vwind = [Va:-Va/(Ny-1):0].*ones(Nx,1);
    zonalWind = rho_a.*SEAICE_drag.*sqrt(uwind.^2+vwind.^2).*uwind; 
    meridWindFile = rho_a.*SEAICE_drag.*sqrt(uwind.^2+vwind.^2).*vwind;
else 
    %%% Load surface wind stress 
    fid = fopen(fullfile(exppath,'input','zonalWindFile.bin'),'r','b');
    zonalWind = fread(fid,[Nx Ny],'real*8');
    fclose(fid);
    fid = fopen(fullfile(exppath,'input','meridWindFile.bin'),'r','b');
    meridWind = fread(fid,[Nx Ny],'real*8');
    fclose(fid);
end

    windStress_xint = sum(zonalWind(xidx,:).*DX_xy(xidx,:),1);

    length_int = sum(DX_xy(xidx,1),1);

    