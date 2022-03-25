%%%
%%% doubleRes_3DuvtspIce.m
%%%
%%% Takes an MITgcm experiment and doubles its resolution, producing input
%%% files for a new experiment at the higher resolution.
%%%
% 
% clear all;close all;
% expdir = '/data/MITgcm_ASF-csi/experiments/';
% expname_lores = 'lores_Ua-6Va18_Atide0.05_Hi1Ai1_Ws25';
% expname_hires = 'hires_Ua-6Va18_Atide0.05_Hi1Ai1_Ws25';
% expiter = 1791818;

function doubleRes_3DuvtspIce (expdir,expname_lores,expname_hires,expiter)

  %%% For file I/O
  addpath ../newexp_utils/
  addpath ../utils/matlab  

  %%% Load grid dimensions
  run(fullfile(expdir,expname_lores,'input','params.m'));
  Nx = length(delX);
  Ny = length(delY);
  Nr_in = length(delR);
  
  %%% Formatting
  ieee='b';
  prec='real*8';

  %%% Pull out u,v,t,p from pickup file
  A = rdmds(fullfile(expdir,expname_lores,'results/pickup'),expiter);
  uvtsp1 = A(:,:,[1:4*Nr_in 9*Nr_in+1]);

  %%% Create double-resolution arrays. Here we basically just use 
  %%% nearest-neighbour interpolation because it doesn't need to be 
  %%% a precise doubling of the resolution.
  uvtsp2 = zeros(2*Nx,2*Ny,4*Nr_in+1);
  for k=1:4*Nr_in+1
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
  for k=1:4*Nr_in+1
    uvtsp2(:,:,k) = inpaint_nans(uvtsp2(:,:,k));
  end

  %%% Load grid dimensions
  run(fullfile(expdir,expname_hires,'input','params.m'));
  Nr_out = length(delR);
  
  %%% Grid spacing increases with depth, but spacings exactly sum to H
  zidx_in = 1:Nr_in;
  gamma = 10;  
  alpha = 10;
  H = sum(delR);
  dz1_in = 2*H/Nr_in/(alpha+1);
  dz2_in = alpha*dz1_in;
  dz_in = dz1_in + ((dz2_in-dz1_in)/2)*(1+tanh((zidx_in-((Nr_in+1)/2))/gamma));
  zz_in = -cumsum((dz_in+[0 dz_in(1:end-1)])/2);

  zidx_out = 1:Nr_out;
  dz1_out = 2*H/Nr_out/(alpha+1);
  dz2_out = alpha*dz1_out;
  dz_out = dz1_out + ((dz2_out-dz1_out)/2)*(1+tanh((zidx_out-((Nr_out+1)/2))/gamma));
  zz_out = -cumsum((dz_out+[0 dz_out(1:end-1)])/2);

  
  %%% Vertical interpolation
  uvtsp3 = zeros(2*Nx,2*Ny,4*Nr_out+1);
  for n = 1:4
     for i=1:2*Nx
       for j=1:2*Ny    
            uvtsp3(i,j,(n-1)*Nr_out+1:n*Nr_out) = interp1(zz_in,...
                squeeze(uvtsp2(i,j,(n-1)*Nr_in+1:n*Nr_in))',zz_out,'linear')';
       end
     end
  end  
  
  uvtsp3(:,:,end) =  uvtsp2(:,:,end);
  uvtsp3(:,1,end) =  0; uvtsp3(:,end,end) =  0;

  %%% Create input arrays
  writeDataset(uvtsp3(:,:,1:Nr_out),fullfile(expdir,expname_hires,'input/uVelInitFile.bin'),ieee,prec);
  writeDataset(uvtsp3(:,:,Nr_out+1:2*Nr_out),fullfile(expdir,expname_hires,'input/vVelInitFile.bin'),ieee,prec);
  writeDataset(uvtsp3(:,:,2*Nr_out+1:3*Nr_out),fullfile(expdir,expname_hires,'input/hydrogThetaFile.bin'),ieee,prec);
  writeDataset(uvtsp3(:,:,3*Nr_out+1:4*Nr_out),fullfile(expdir,expname_hires,'input/hydrogSaltFile.bin'),ieee,prec);
  writeDataset(uvtsp3(:,:,4*Nr_out+1),fullfile(expdir,expname_hires,'input/pSurfInitFile.bin'),ieee,prec);

  
  
  
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

