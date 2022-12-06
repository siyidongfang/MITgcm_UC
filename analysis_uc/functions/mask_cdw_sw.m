
%%% Find (x,y,z) indices for CDW and surface water (SW)


tt_vgrid = tt;
tt_ugrid = tt;

tt_vgrid(:,2:Ny,:) = (tt(:,1:Ny-1,:)+tt(:,2:Ny,:))/2; %%% v-grid
tt_ugrid(2:Nx,:,:) = 0.5.*(tt(1:Nx-1,:,:)+tt(2:Nx,:,:));



mask_cdw_ugrid = nan(Nx,Ny,Nr);
mask_cdw_vgrid = nan(Nx,Ny,Nr);

mask_cdw_ugrid(tt_ugrid>=0)=1;
mask_cdw_vgrid(tt_vgrid>=0)=1;

mask_sw_ugrid = nan(Nx,Ny,Nr);
mask_sw_vgrid = nan(Nx,Ny,Nr);

mask_sw_ugrid(tt_ugrid<0)=1;
mask_sw_vgrid(tt_vgrid<0)=1;


