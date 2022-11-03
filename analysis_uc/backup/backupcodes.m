
%  Um_dPhiX = rdmds([exppath,'/results/Um_dPhiX'],nIter(nn));
%  Um_Advec = rdmds([exppath,'/results/Um_Advec'],nIter(nn));
%  Um_Diss = rdmds([exppath,'/results/Um_Diss'],nIter(nn));
%  Um_Ext = rdmds([exppath,'/results/Um_Ext'],nIter(nn));
% 
%  Vm_dPhiY = rdmds([exppath,'/results/Vm_dPhiY'],nIter(nn));
%  Vm_Advec = rdmds([exppath,'/results/Vm_Advec'],nIter(nn));
%  Vm_Diss = rdmds([exppath,'/results/Vm_Diss'],nIter(nn));
%  Vm_Ext = rdmds([exppath,'/results/Vm_Ext'],nIter(nn));
% 
%  Um_Cori = rdmds([exppath,'/results/Um_Cori'],nIter(nn));
%  Vm_Cori = rdmds([exppath,'/results/Vm_Cori'],nIter(nn));
%  Um_AdvZ3 = rdmds([exppath,'/results/Um_AdvZ3'],nIter(nn));
%  Um_AdvRe = rdmds([exppath,'/results/Um_AdvRe'],nIter(nn));
%  Vm_AdvZ3 = rdmds([exppath,'/results/Vm_AdvZ3'],nIter(nn));
%  Vm_AdvRe = rdmds([exppath,'/results/Vm_AdvRe'],nIter(nn));






% zeta_dPhi_3D_vgrid = zeta_dPhi_3D;
% zeta_dPhi_3D_vgrid(2:Nx,:,:)= 0.5*(zeta_dPhi_3D(1:Nx-1,:,:)+zeta_dPhi_3D(2:Nx,:,:));
% zeta_Advec_3D_vgrid = zeta_Advec_3D;
% zeta_Advec_3D_vgrid(2:Nx,:,:)= 0.5*(zeta_Advec_3D(1:Nx-1,:,:)+zeta_Advec_3D(2:Nx,:,:));
% zeta_Diss_3D_vgrid = zeta_Diss_3D;
% zeta_Diss_3D_vgrid(2:Nx,:,:)= 0.5*(zeta_Diss_3D(1:Nx-1,:,:)+zeta_Diss_3D(2:Nx,:,:));
% zeta_Ext_3D_vgrid = zeta_Ext_3D;
% zeta_Ext_3D_vgrid(2:Nx,:,:)= 0.5*(zeta_Ext_3D(1:Nx-1,:,:)+zeta_Ext_3D(2:Nx,:,:));
% zeta_residual_3D_vgrid = zeta_residual_3D;
% zeta_residual_3D_vgrid(2:Nx,:,:)= 0.5*(zeta_residual_3D(1:Nx-1,:,:)+zeta_residual_3D(2:Nx,:,:));
% 
% zeta_dPhi = rho0.*sum(zeta_dPhi_3D_vgrid.*hFacS.*DZ,3,'omitnan');
% zeta_Advec = rho0.*sum(zeta_Advec_3D_vgrid.*hFacS.*DZ,3,'omitnan');
% zeta_Diss = rho0.*sum(zeta_Diss_3D_vgrid.*hFacS.*DZ,3,'omitnan');
% zeta_Ext = rho0.*sum(zeta_Ext_3D_vgrid.*hFacS.*DZ,3,'omitnan');
% zeta_residual = rho0.*sum(zeta_residual_3D_vgrid.*hFacS.*DZ,3,'omitnan');

% zeta_dPhi_3D_ugrid = zeta_dPhi_3D;
% zeta_dPhi_3D_ugrid(:,1:Ny-1,:)= 0.5*(zeta_dPhi_3D(:,1:Ny-1,:)+zeta_dPhi_3D(:,2:Ny,:));
% zeta_Advec_3D_ugrid = zeta_Advec_3D;
% zeta_Advec_3D_ugrid(:,1:Ny-1,:)= 0.5*(zeta_Advec_3D(:,1:Ny-1,:)+zeta_Advec_3D(:,2:Ny,:));
% zeta_Diss_3D_ugrid = zeta_Diss_3D;
% zeta_Diss_3D_ugrid(:,1:Ny-1,:)= 0.5*(zeta_Diss_3D(:,1:Ny-1,:)+zeta_Diss_3D(:,2:Ny,:));
% zeta_Ext_3D_ugrid = zeta_Ext_3D;
% zeta_Ext_3D_ugrid(:,1:Ny-1,:)= 0.5*(zeta_Ext_3D(:,1:Ny-1,:)+zeta_Ext_3D(:,2:Ny,:));
% zeta_residual_3D_ugrid = zeta_residual_3D;
% zeta_residual_3D_ugrid(:,1:Ny-1,:)= 0.5*(zeta_residual_3D(:,1:Ny-1,:)+zeta_residual_3D(:,2:Ny,:));
% 
% zeta_dPhi = rho0.*sum(zeta_dPhi_3D_ugrid.*hFacW.*DZ,3);
% zeta_Advec = rho0.*sum(zeta_Advec_3D_ugrid.*hFacW.*DZ,3);
% zeta_Diss = rho0.*sum(zeta_Diss_3D_ugrid.*hFacW.*DZ,3);
% zeta_Ext = rho0.*sum(zeta_Ext_3D_ugrid.*hFacW.*DZ,3);
% zeta_residual = rho0.*sum(zeta_residual_3D_ugrid.*hFacW.*DZ,3);


% zeta_dPhi_3D_tgrid = zeta_dPhi_3D;
% zeta_dPhi_3D_tgrid(1:Nx-1,1:Ny-1,:)= 0.25*(zeta_dPhi_3D(1:Nx-1,1:Ny-1,:)+zeta_dPhi_3D(1:Nx-1,2:Ny,:)+zeta_dPhi_3D(2:Nx,1:Ny-1,:)+zeta_dPhi_3D(2:Nx,2:Ny,:));
% zeta_Advec_3D_tgrid = zeta_Advec_3D;
% zeta_Advec_3D_tgrid(1:Nx-1,1:Ny-1,:)= 0.25*(zeta_Advec_3D(1:Nx-1,1:Ny-1,:)+zeta_Advec_3D(1:Nx-1,2:Ny,:)+zeta_Advec_3D(2:Nx,1:Ny-1,:)+zeta_Advec_3D(2:Nx,2:Ny,:));
% zeta_Diss_3D_tgrid = zeta_Diss_3D;
% zeta_Diss_3D_tgrid(1:Nx-1,1:Ny-1,:)= 0.25*(zeta_Diss_3D(1:Nx-1,1:Ny-1,:)+zeta_Diss_3D(1:Nx-1,2:Ny,:)+zeta_Diss_3D(2:Nx,1:Ny-1,:)+zeta_Diss_3D(2:Nx,2:Ny,:));
% zeta_Ext_3D_tgrid = zeta_Ext_3D;
% zeta_Ext_3D_tgrid(1:Nx-1,1:Ny-1,:)= 0.25*(zeta_Ext_3D(1:Nx-1,1:Ny-1,:)+zeta_Ext_3D(1:Nx-1,2:Ny,:)+zeta_Ext_3D(2:Nx,1:Ny-1,:)+zeta_Ext_3D(2:Nx,2:Ny,:));
% zeta_residual_3D_tgrid = zeta_residual_3D;
% zeta_residual_3D_tgrid(1:Nx-1,1:Ny-1,:)= 0.25*(zeta_residual_3D(1:Nx-1,1:Ny-1,:)+zeta_residual_3D(1:Nx-1,2:Ny,:)+zeta_residual_3D(2:Nx,1:Ny-1,:)+zeta_residual_3D(2:Nx,2:Ny,:));
% 
% zeta_dPhi = rho0.*sum(zeta_dPhi_3D_tgrid.*hFacC.*DZ,3);
% zeta_Advec = rho0.*sum(zeta_Advec_3D_tgrid.*hFacC.*DZ,3);
% zeta_Diss = rho0.*sum(zeta_Diss_3D_tgrid.*hFacC.*DZ,3);
% zeta_Ext = rho0.*sum(zeta_Ext_3D_tgrid.*hFacC.*DZ,3);
% zeta_residual = rho0.*sum(zeta_residual_3D_tgrid.*hFacC.*DZ,3);

