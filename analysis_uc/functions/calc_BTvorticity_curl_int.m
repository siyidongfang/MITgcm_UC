%%%
%%% calc_BTvorticity_curl_int.m
%%%
%%% Calculate the barotropic vorticity budget using model diagnostics
%%% Take the curl first, then vertically integrate the vorticity budget terms


load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext',...
    'Vm_dPhiY','Vm_Advec','Vm_Diss','Vm_Ext','Um_Cori','Vm_Cori',...
    'Um_AdvZ3','Um_AdvRe','Vm_AdvZ3','Vm_AdvRe');

DXG = rdmds(fullfile(resultspath,'DXG'));
DYF = rdmds(fullfile(resultspath,'DYF'));
RAZ = rdmds(fullfile(resultspath,'RAZ'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate the vorticity terms %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zeta_dPhi_3D = zeros(Nx,Ny,Nr);
zeta_Advec_3D = zeros(Nx,Ny,Nr);
zeta_Diss_3D = zeros(Nx,Ny,Nr);
zeta_Ext_3D = zeros(Nx,Ny,Nr);

for k=1:Nr
    for i = 2:Nx
        for j = 2:Ny
            %%% Pressure torque
            zeta_dPhi_3D(i,j,k) = ( Um_dPhiX(i,j-1,k)*DXG(i,j-1) + Vm_dPhiY(i,j,k)*DYF(i,j) ...
                                  - Um_dPhiX(i,j,k)*DXG(i,j)     - Vm_dPhiY(i-1,j,k)*DYF(i-1,j) ) ./RAZ(i,j); 
            
            %%% Advection term
            zeta_Advec_3D(i,j,k) = ( Um_Advec(i,j-1,k)*DXG(i,j-1) + Vm_Advec(i,j,k)*DYF(i,j) ...
                                   - Um_Advec(i,j,k)*DXG(i,j)     - Vm_Advec(i-1,j,k)*DYF(i-1,j) ) ./RAZ(i,j); 
            
            %%% Dissipation term
            zeta_Diss_3D(i,j,k) = ( Um_Diss(i,j-1,k)*DXG(i,j-1) + Vm_Diss(i,j,k)*DYF(i,j) ...
                                   - Um_Diss(i,j,k)*DXG(i,j)     - Vm_Diss(i-1,j,k)*DYF(i-1,j) ) ./RAZ(i,j); 
           
            %%% Surface stress term
            zeta_Ext_3D(i,j,k) = ( Um_Ext(i,j-1,k)*DXG(i,j-1) + Vm_Ext(i,j,k)*DYF(i,j) ...
                                 - Um_Ext(i,j,k)*DXG(i,j)     - Vm_Ext(i-1,j,k)*DYF(i-1,j) ) ./RAZ(i,j);   
        end
    end
end
      
%%% Residual term
zeta_residual_3D = zeta_dPhi_3D + zeta_Advec_3D + zeta_Diss_3D + zeta_Ext_3D;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Decompose the vorticity balance %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zeta_Cori_3D = zeros(Nx,Ny,Nr);
zeta_AdvZ3_3D = zeros(Nx,Ny,Nr);
zeta_AdvRe_3D = zeros(Nx,Ny,Nr);

for k=1:Nr
    for i = 2:Nx
        for j = 2:Ny
            %%% Coriolis term (planetary vorticity advection)
            zeta_Cori_3D(i,j,k) = ( Um_Cori(i,j-1,k)*DXG(i,j-1) + Vm_Cori(i,j,k)*DYF(i,j) ...
                                  - Um_Cori(i,j,k)*DXG(i,j)     - Vm_Cori(i-1,j,k)*DYF(i-1,j) ) ./RAZ(i,j); 
    
            %%% Vorticity Advection
            zeta_AdvZ3_3D(i,j,k) = ( Um_AdvZ3(i,j-1,k)*DXG(i,j-1) + Vm_AdvZ3(i,j,k)*DYF(i,j) ...
                                   - Um_AdvZ3(i,j,k)*DXG(i,j)     - Vm_AdvZ3(i-1,j,k)*DYF(i-1,j) ) ./RAZ(i,j);
    
            %%% Vertical Advection (Explicit part)
            zeta_AdvRe_3D(i,j,k) = ( Um_AdvRe(i,j-1,k)*DXG(i,j-1) + Vm_AdvRe(i,j,k)*DYF(i,j) ...
                                   - Um_AdvRe(i,j,k)*DXG(i,j)     - Vm_AdvRe(i-1,j,k)*DYF(i-1,j) ) ./RAZ(i,j);
        end
    end
end

%%% Nonlinear advection term
zeta_nonLin_3D = zeta_Advec_3D - zeta_Cori_3D; 

%%% Ageostrophic term
zeta_ageo_3D = zeta_Advec_3D + zeta_dPhi_3D;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Depth-integrated vorticity budget %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





