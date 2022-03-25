%%% 
%%% calcTransport_TbtTbc.m
%%%
%%% Calculate the barotropic and baroclinic components of the zonal transport
%%%
%%% expdir - Base directory containing experiment
%%% expname - Name of experiment
%%% Tbt: Barotropic transport
%%% Tbc: Baroclinic transport
%%% Ttotal: Total transport, Ttotal = Tbt + Tbc
%%%

function [Tbt,Tbc,Ttotal] = calcTransport_TbtTbc(expdir,expname)

    %%% load data
    loadexp;
    load([expdir, '/products/', expname, '_tavg.mat'], 'uu');

    %%% Grid spacing matrices
    DY_xy = repmat(delY,[Nx 1]);
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    
    %%% Declare variable
    u_bottom = zeros(Nx,Ny); % zonal velocity at the seafloor
    
    %%% Find the seafloor velocity
    uu(uu==0)=NaN;              % make the topography (where uu==0) NaN values
    idx_topog = isnan(uu);      % The dry grids (topography): 1, wet grids: 0
    idxb = Nr-sum(idx_topog,3); % The seafloor velocity is on the grid above the topography 

    for i = 1:Nx
        for j = 2:Ny-1
           u_bottom(i,j) = uu(i,j,idxb(i,j));
        end
    end
    
    %%% Exclude the sponge layers
    Nsponge = 50*1000/delY(1);     % The sponge layer thickness in grid points
    yy_idx = Nsponge+1:Ny-Nsponge; % The grid points in y direction excluding the sponge layers  
        
    %%% Westward barotropic transport, Sv
    Tbt = abs(mean(nansum(u_bottom(:,yy_idx).*abs(bathy(:,yy_idx)).*DY_xy(:,yy_idx),2))/1e6);
    
    %%% Total westward transport, Sv
    Ttotal = abs(mean(nansum(nansum(uu(:,yy_idx,:).*DZ(:,yy_idx,:).*hFacW(:,yy_idx,:),3).*DY_xy(:,yy_idx,:),2)/1e6));

    %%% Westward baroclinic transport, Sv
    Tbc = Ttotal- Tbt;


end