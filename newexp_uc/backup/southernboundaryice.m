%% Calculate ice velocities at the southern boundary using momentum equation
clear;
rho_a = 1.3;          %%% Air density, kg/m^3  
rho_o = 1027;         %%% Water density, kg/m^3
rho_i = 920;          %%% Ice density, kg/m^3  
f0 = -1.3e-4;         %%% Coriolis parameter, rad/s
SEAICE_drag = 2e-3;          %%% Air-ice drag coefficient, dimensionless
SEAICE_waterDrag = 5.5399/1000;          %%% Ice-ocean drag coefficient, dimensionless
Hi0 = 1;               %%% Sea ice thickness, m
Ua = -2;             %%% Wind velocity in x direction, m/s
Va = 2;              %%% Wind velocity in y direction, m/s
% tao_aix = -0.05;       %%% Air-ice stress in x direction, N/m2
% tao_aiy = 0.05;       %%% Air-ice stress in y direction, N/m2
% tao_aix = rho_a*SEAICE_drag*sqrt(Ua^2+Va^2)*Ua;       %%% Air-ice stress in x direction, N/m2
% tao_aiy = rho_a*SEAICE_drag*sqrt(Ua^2+Va^2)*Va;       %%% Air-ice stress in y direction, N/m2
    tao_aix = sign(Ua)*SEAICE_drag*rho_a*Ua^2;       %%% Air-ice stress in x direction, N/m2
    tao_aiy = sign(Va)*SEAICE_drag*rho_a*Va^2;       %%% Air-ice stress in y direction, N/m2

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

% vi = 0.005;
% syms ui
% eq1 =  rho_i*hi*f0*vi + tao_aix - rho_o*C_io*sqrt(ui^2+vi^2)*ui;
% eq2 = -rho_i*hi*f0*ui + tao_aiy - rho_o*C_io*sqrt(ui^2+vi^2)*vi;
% solui1 = solve(eq1,ui);
% solui2 = solve(eq2,ui);
% Sui1 = double(real(solui1))
% Sui2 = double(real(solui2))

%% Calculate the energy budget at open ocean surface when Hi0=0,Ai0=0
clear all;
ocn_e = 0.97;
Tfreez = -1.8862;
TaDegC = -10; 
Ta = 273.16+TaDegC; %%% Surface air temperature, degK   
Tos = 273.16+Tfreez; %%% surface water temperature
sigma = 5.67/10^8; %%% Stefan-Boltzman'n constant
Cp_air = 1004; %%% Heat capacity at constant pressure 1004 J K-1 kg-1
rho_a = 1.3;               %%% Air density, kg/m^3

LWup = ocn_e*sigma*Tos^4;
SH = rho_a*Cp_air*exf_iceCh.*Ur.*abs(Ta-Tis);










