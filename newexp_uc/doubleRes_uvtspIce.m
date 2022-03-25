%%%
%%% doubleRes_uvtsp.m
%%%
%%% Takes an MITgcm experiment and doubles its resolution, producing input
%%% files for a new experiment at the higher resolution.
%%%

% expdir = '/data/MITgcm_ASF-csi/experiments/';
% expname_lores = 'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2';
% expname_hires = 'hires-ref_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25';
% expiter = 1695484;

  
function doubleRes_uvtspIce (expdir,expname_lores,expname_hires,expiter)

  %%% For file I/O
  addpath ../newexp_utils/
  addpath ../utils/matlab  

  %%% Load grid dimensions
  run(fullfile(expdir,expname_lores,'input','params.m'));
  Nx = length(delX);
  Ny = length(delY);
  Nr = length(delR);
  
  %%% Formatting
  ieee='b';
  prec='real*8';

  %%% Pull out u,v,t,p from pickup file
  A = rdmds(fullfile(expdir,expname_lores,'results/pickup'),expiter);
  uvtsp1 = A(:,:,[1:4*Nr 9*Nr+1]);

  %%% Create double-resolution arrays. Here we basically just use 
  %%% nearest-neighbour interpolation because it doesn't need to be 
  %%% a precise doubling of the resolution.
  uvtsp2 = zeros(2*Nx,2*Ny,4*Nr+1);
  for k=1:4*Nr+1
    for i=1:Nx
      for j=2:Ny-1      
        uvtsp2(2*i-1,2*j-1,k) = uvtsp1(i,j,k);
        uvtsp2(2*i-1,2*j,k) = uvtsp1(i,j,k);
        uvtsp2(2*i,2*j-1,k) = uvtsp1(i,j,k);
        uvtsp2(2*i,2*j,k) = uvtsp1(i,j,k);
      end
    end        
  end

  %%% It turns out we need to fill wet cells with non-zero values, so just inpaint nans 
  uvtsp2(uvtsp2==0) = NaN;  
  for k=1:4*Nr+1
    uvtsp2(:,:,k) = inpaint_nans(uvtsp2(:,:,k));
  end

  %%% Create input arrays
  writeDataset(uvtsp2(:,:,1:Nr),fullfile(expdir,expname_hires,'input/uVelInitFile.bin'),ieee,prec);
  writeDataset(uvtsp2(:,:,Nr+1:2*Nr),fullfile(expdir,expname_hires,'input/vVelInitFile.bin'),ieee,prec);
  writeDataset(uvtsp2(:,:,2*Nr+1:3*Nr),fullfile(expdir,expname_hires,'input/hydrogThetaFile.bin'),ieee,prec);
  writeDataset(uvtsp2(:,:,3*Nr+1:4*Nr),fullfile(expdir,expname_hires,'input/hydrogSaltFile.bin'),ieee,prec);
  writeDataset(uvtsp2(:,:,4*Nr+1),fullfile(expdir,expname_hires,'input/pSurfInitFile.bin'),ieee,prec);

  
  %%%%% SEAICE
  B = rdmds(fullfile(expdir,expname_lores,'results/pickup_seaice'),expiter);
  ice1 = B(:,:,8:13);
  
  ice2 = zeros(2*Nx,2*Ny,6);
  for k=1:6
    for i=1:Nx
      for j=2:Ny-1      
        ice2(2*i-1,2*j-1,k) = ice1(i,j,k);
        ice2(2*i-1,2*j,k) = ice1(i,j,k);
        ice2(2*i,2*j-1,k) = ice1(i,j,k);
        ice2(2*i,2*j,k) = ice1(i,j,k);
      end
        ice2(2*i-1,1,k) = ice1(i,1,k);
        ice2(2*i-1,2,k) = ice1(i,1,k);
        ice2(2*i,1,k) = ice1(i,1,k);
        ice2(2*i,2,k) = ice1(i,1,k);
    end
  end
  
  %%% Create input arrays
  writeDataset(ice2(:,:,1),fullfile(expdir,expname_hires,'input/AreaFile.bin'),ieee,prec);
  writeDataset(ice2(:,:,2),fullfile(expdir,expname_hires,'input/HeffFile.bin'),ieee,prec);
  writeDataset(ice2(:,:,3),fullfile(expdir,expname_hires,'input/HsnowFile.bin'),ieee,prec);
  writeDataset(ice2(:,:,4),fullfile(expdir,expname_hires,'input/HsaltFile.bin'),ieee,prec);  
  writeDataset(ice2(:,:,5),fullfile(expdir,expname_hires,'input/uIceFile.bin'),ieee,prec);
  writeDataset(ice2(:,:,6),fullfile(expdir,expname_hires,'input/vIceFile.bin'),ieee,prec); 
  
    
end

