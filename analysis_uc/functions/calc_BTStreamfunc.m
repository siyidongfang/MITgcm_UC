%%%
%%% calc_BTStreamfunc.m
%%%
%%% Calculates the time-mean barotropic streamfunction.
%%%

    %%% Grid spacing matrices
    DX = repmat(delX',[1 Ny Nr]);
    DY = repmat(delY,[Nx 1 Nr]);
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    
    %%% Calculate depth-averaged zonal velocity
    UU = sum(uu.*DZ.*hFacW,3); %%% u-grid
    
    %%% Calculate barotropic streamfunction
    Psi = zeros(Nx+1,Ny+1);
    Psi(1:Nx,1:Ny) = flipdim(cumsum(flipdim(UU.*DY(:,:,1),2),2),2);
    Psi(:,Ny+1) = 0;
    Psi(Nx+1,:) = Psi(1,:);
    
%     Psi(1:Nx,2:Ny+1) = -cumsum(UU.*DY(:,:,1),2);
%     Psi(Nx+1,:) = Psi(1,:);
%     Psi(:,1) = 0;
