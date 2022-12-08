


%%% Find (x,y,z) indices for CDW and surface water (SW)

mask_uc = NaN*zeros(Nx,Ny,Nr);
mask_uc (uu>0)=1;

tt_vgrid = tt;
tt_ugrid = tt;

tt_vgrid(:,2:Ny,:) = (tt(:,1:Ny-1,:)+tt(:,2:Ny,:))/2; %%% v-grid
tt_ugrid(2:Nx,:,:) = 0.5.*(tt(1:Nx-1,:,:)+tt(2:Nx,:,:));

mask_cdw_ugrid = NaN*zeros(Nx,Ny,Nr);
mask_cdw_vgrid = NaN*zeros(Nx,Ny,Nr);

mask_cdw_ugrid(tt_ugrid>=0)=1;
mask_cdw_vgrid(tt_vgrid>=0)=1;

mask_sw_ugrid = NaN*zeros(Nx,Ny,Nr);
mask_sw_vgrid = NaN*zeros(Nx,Ny,Nr);

mask_sw_ugrid(tt_ugrid<0)=1;
mask_sw_vgrid(tt_vgrid<0)=1;

excludedeepocean = find(zz<-600);
mask_sw_ugrid(:,:,excludedeepocean)= NaN;
mask_sw_vgrid(:,:,excludedeepocean)= NaN;

