%%%
%%% calc_BTvorticity.m
%%%
%%% Calculate the barotropic vorticity budget



    UU = sum(uu.*DZ.*hFacW,3); %%% Depth-integrated volume flux
    VV = sum(vv.*DZ.*hFacS,3);
    
    VV_vorgrid = zeros(Nx,Ny);  
    VV_vorgrid(1:Nx-1,:) = (VV(1:Nx-1,:)+ VV(2:Nx,:))/2; % vorticity-gird
    VV_vorgrid(Nx,:) = (VV(Nx,:)+0)/2;

    load([prodir expname '_tavg_5yrs.mat'],'PHIHYD');
    ZZ_3D = repmat(reshape(zz,[1 1 Nr]),[Nx Ny 1]);

    dp = PHIHYD; %%% pressure anomaly
    pp =  rhoConst*(-gravity*ZZ_3D + dp)/1e4; %%% 3D pressure, unit: dbar (1e4 kg/m/s^2)

    %%% Find bottom pressure
    pb = zeros(Nx,Ny);          % bottom pressure
    ss(ss==0) = NaN;            % make the topography (where dp==0) NaN values
    idx_topog = isnan(ss);      % The dry grids (topography): 1, wet grids: 0
    idxb = Nr-sum(idx_topog,3); % Find the vertical grid of bottom velocity
    for i = 1:Nx
        for j = 1:Ny
            if(idxb(i,j)~=0)
               pb(i,j) = pp(i,j,idxb(i,j));
            end
        end
    end
    pb(pb==0) = NaN;
    ss(isnan(ss)) = 0;          

    HH = -bathy; %%% t-grid

    dpbdx = zeros(Nx,Ny);
    dpbdy = zeros(Nx,Ny);
    dHdx = zeros(Nx,Ny);
    dHdy = zeros(Nx,Ny); 

%     dpbdx(2:Nx-1,:) = diff(pb,2,1)/dx; %%% Centered difference, on t-grid
%     dpbdy(:,2:Ny-1) = diff(pb,2,2)/dy; %%% Centered difference, on t-grid
%     dHdx(2:Nx-1,:)  = diff(HH,2,1)/dx; %%% Centered difference, on t-grid
%     dHdy(:,2:Ny-1)  = diff(HH,2,2)/dy; %%% Centered difference, on t-grid

    HH_vgrid = zeros(Nx,Ny);    
    HH_ugrid = zeros(Nx,Ny); 
    pb_vgrid = zeros(Nx,Ny); 
    pb_ugrid = zeros(Nx,Ny); 

    HH_vgrid(:,1) = HH(:,1);
    HH_vgrid(:,2:Ny) = (HH(:,1:Ny-1)+HH(:,2:Ny))/2; %%% v-grid
    pb_vgrid(:,1) = pb(:,1);
    pb_vgrid(:,2:Ny) = (pb(:,1:Ny-1)+pb(:,2:Ny))/2; %%% v-grid

    HH_ugrid(2:Nx,:) = 0.5.*(HH(1:Nx-1,:)+HH(2:Nx,:));
    pb_ugrid(2:Nx,:) = 0.5.*(pb(1:Nx-1,:)+pb(2:Nx,:));

    dpbdx(2:Nx,:) = diff(pb_vgrid)/dx; % vorticity-gird
    dHdx(2:Nx,:)  = diff(HH_vgrid)/dx; % vorticity-gird
    dpbdy(:,2:Ny) = diff(pb_ugrid,1,2)/dy; % vorticity-gird
    dHdy(:,2:Ny)  = diff(HH_ugrid,1,2)/dy; % vorticity-gird



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate the vorticity terms %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    %%% Planetary vorticity advection
    betaV = beta*VV_vorgrid;  % vorticity-gird

    %%% Bottom pressure torque
    pb_torq = 1/rhoConst*(dpbdx.*dHdy - dpbdy.*dHdx);  % vorticity-gird
%     pb_torq_tgrid = 1/rhoConst*(dpbdx.*dHdy - dpbdy.*dHdx); % t-grid
%     pb_torq = zeros(Nx,Ny);   % vorticity-gird
%     pb_torq(2:Nx,:) = 0.5*(pb_torq_tgrid(1:Nx-1,:)+pb_torq_tgrid(2:Nx,:));% u-grid
%     pb_torq(:,2:Ny) = 0.5*(pb_torq_tgrid(:,1:Ny-1)+pb_torq_tgrid(:,2:Ny));% vorticity-grid

    %%% Wind stress curl

    dtausdy = zeros(Nx,Ny);
    dtausdx = zeros(Nx,Ny);

    dtausdx(2:Nx,:) = diff(oceTAUY)/dx;  % vorticity-gird
    dtausdy(:,2:Ny) = diff(oceTAUX,1,2)/dy;  % vorticity-gird

    wind_curl = 1/rhoConst*(dtausdx-dtausdy);  % vorticity-gird

    
   
%     %%% Bottom frictional stress curl
%     fric_curl
%     
%     %%% Nonlinear torque
%     non_torq
%     
%     %%% Viscous torque
%     visc_torq
%     
%     
%     %%% Residual term
%     residual_BTvort = 
%     
    
    
figure(1)
subplot(1,3,1)
pcolor(betaV)
shading flat;colorbar;colormap(redblue);caxis([-2 2]/1e9);

subplot(1,3,2)
pcolor(pb_torq)
shading flat;colorbar;colormap(redblue);caxis([-2 2]/1e9);

subplot(1,3,3)
pcolor(wind_curl)
shading flat;colorbar;colormap(redblue);caxis([-2 2]/1e9);
      
    
%%%%%%%%%%%%%%%%%%%%%
%%% Save the data %%%
%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    

