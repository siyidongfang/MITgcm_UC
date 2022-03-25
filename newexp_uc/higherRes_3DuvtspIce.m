%%%
%%% higherRes_3DuvtspIce.m
%%%
%%% Takes an MITgcm experiment, produces input
%%% files for a new experiment at the higher resolution.
%%%

% clear all;close all;
% expdir = '/data/MITgcm_ASF-csi/experiments/';
% expname_lores = 'lores_Ua-6Va6_Atide0.05_Hi1.4Ai1_Ws25_Nr30';
% expname_hires = 'hires_Ua-6Va6_Atide0.05_Hi1.4Ai1_Ws25'
% expiter = 1077677;


  
function higherRes_3DuvtspIce (expdir_lores,expdir,expname_lores,expname_hires,expiter)

  %%% For file I/O
  addpath ../newexp_utils/
  addpath ../utils/matlab  

  %%% Load grid dimensions
  run(fullfile(expdir_lores,expname_lores,'input','params.m'));
  Nx_in = length(delX);
  Ny_in = length(delY);
  Nr_in = length(delR);
  
  run(fullfile(expdir,expname_hires,'input','params.m'));
  Nx_out = length(delX);
  Ny_out = length(delY);
  Nr_out = length(delR);
  
  
  %%% Formatting
  ieee='b';
  prec='real*8';
  
  %%% Grid spacing increases with depth, but spacings exactly sum to H
  gamma = 10;  
  alpha = 10;
  H = sum(delR);
  
  zidx_in = 1:Nr_in;
  dz1_in = 2*H/Nr_in/(alpha+1);
  dz2_in = alpha*dz1_in;
  dz_in = dz1_in + ((dz2_in-dz1_in)/2)*(1+tanh((zidx_in-((Nr_in+1)/2))/gamma));
  zz_in = -cumsum((dz_in+[0 dz_in(1:end-1)])/2);

  zidx_out = 1:Nr_out;
  dz1_out = 2*H/Nr_out/(alpha+1);
  dz2_out = alpha*dz1_out;
  dz_out = dz1_out + ((dz2_out-dz1_out)/2)*(1+tanh((zidx_out-((Nr_out+1)/2))/gamma));
  zz_out = -cumsum((dz_out+[0 dz_out(1:end-1)])/2);
  
  %%% Grids for linear interpolation (this is rather crude)
  dx_in = 1.0/Nx_in;
  dy_in = 1.0/Ny_in;
  xx_in = 0.5*dx_in:dx_in:1-0.5*dx_in;
  yy_in = 0.5*dy_in:dy_in:1-0.5*dy_in;
  dx_out = 1.0/Nx_out;
  dy_out = 1.0/Ny_out;
  xx_out = 0.5*dx_out:dx_out:1-0.5*dx_out;
  yy_out = 0.5*dy_out:dy_out:1-0.5*dy_out;
  
  [YY_in2D,XX_in2D] = meshgrid(yy_in,xx_in);
  [YY_out2D,XX_out2D] = meshgrid(yy_out,xx_out);
  [YY_in3D,XX_in3D,ZZ_in3D] = meshgrid(yy_in,xx_in,zz_in/H);
  [YY_out3D,XX_out3D,ZZ_out3D] = meshgrid(yy_out,xx_out,zz_out/H);




  %%% Pull out u,v,t,p from pickup file
  A = rdmds(fullfile(expdir_lores,expname_lores,'results/pickup'),expiter);

  ulow = A(:,:,[1:Nr_in]);
  vlow = A(:,:,[1*Nr_in+1:2*Nr_in]);
  tlow = A(:,:,[2*Nr_in+1:3*Nr_in]);
  slow = A(:,:,[3*Nr_in+1:4*Nr_in]);
  etalow = A(:,:,9*Nr_in+1);

  %%% Mask land points with NaNs
  ulow(ulow==0) = NaN;
  vlow(vlow==0) = NaN;
  tlow(tlow==0) = NaN;
  slow(slow==0) = NaN;
  %%% Interpolation
  uhi = interp3(YY_in3D,XX_in3D,ZZ_in3D,ulow,YY_out3D,XX_out3D,ZZ_out3D,'nearest');
  vhi = interp3(YY_in3D,XX_in3D,ZZ_in3D,vlow,YY_out3D,XX_out3D,ZZ_out3D,'nearest');
  thi = interp3(YY_in3D,XX_in3D,ZZ_in3D,tlow,YY_out3D,XX_out3D,ZZ_out3D,'nearest');
  shi = interp3(YY_in3D,XX_in3D,ZZ_in3D,slow,YY_out3D,XX_out3D,ZZ_out3D,'nearest');
  etahi=interp2(YY_in2D,XX_in2D,etalow,YY_out2D,XX_out2D,'cubic');  
  %%% Surface boundary
  uhi(:,:,1)=uhi(:,:,3); uhi(:,:,2)=uhi(:,:,3);uhi(:,1,:)=uhi(:,2,:);uhi(:,end,:)=uhi(:,end-1,:);
  vhi(:,:,1)=vhi(:,:,3); vhi(:,:,2)=vhi(:,:,3);vhi(:,1,:)=vhi(:,2,:);vhi(:,end,:)=vhi(:,end-1,:);
  thi(:,:,1)=thi(:,:,3); thi(:,:,2)=thi(:,:,3);thi(:,1,:)=thi(:,2,:);thi(:,end,:)=thi(:,end-1,:);
  shi(:,:,1)=shi(:,:,3); shi(:,:,2)=shi(:,:,3);shi(:,1,:)=shi(:,2,:);shi(:,end,:)=shi(:,end-1,:);
  etahi(:,1) = 0; etahi(:,end) = 0;etahi(1,:) = etahi(2,:); etahi(end,:) = etahi(end-1,:);

  %%% Extrapolation
  uhi = inpaint_nans(uhi);
  vhi = inpaint_nans(vhi);
  thi = inpaint_nans(thi);
  shi = inpaint_nans(shi);
 
%   etahi = zeros(Nx_out,Ny_out);

  
  %%% Create input arrays
  writeDataset(uhi,fullfile(expdir,expname_hires,'input/uVelInitFile.bin'),ieee,prec);
  writeDataset(vhi,fullfile(expdir,expname_hires,'input/vVelInitFile.bin'),ieee,prec);
  writeDataset(thi,fullfile(expdir,expname_hires,'input/hydrogThetaFile.bin'),ieee,prec);
  writeDataset(shi,fullfile(expdir,expname_hires,'input/hydrogSaltFile.bin'),ieee,prec);
  writeDataset(etahi,fullfile(expdir,expname_hires,'input/pSurfInitFile.bin'),ieee,prec);

  
  

  
  
  
  %%%%% SEAICE
  %%% Pull out u,v,t,p from pickup file
  B = rdmds(fullfile(expdir_lores,expname_lores,'results/pickup_seaice'),expiter);
  
  arealow = B(:,:,8);
  hefflow = B(:,:,9);
  hsnowlow = B(:,:,10);
  hsaltlow = B(:,:,11);
  uicelow = B(:,:,12);
  vicelow = B(:,:,13);
  
  %%% Interpolation
  areahi = interp2(YY_in2D,XX_in2D,arealow,YY_out2D,XX_out2D,'cubic');  %%% Interpolation
  heffhi = interp2(YY_in2D,XX_in2D,hefflow,YY_out2D,XX_out2D,'cubic');  %%% Interpolation
  hsnowhi = interp2(YY_in2D,XX_in2D,hsnowlow,YY_out2D,XX_out2D,'cubic');  %%% Interpolation
  hsalthi = interp2(YY_in2D,XX_in2D,hsaltlow,YY_out2D,XX_out2D,'cubic');  %%% Interpolation
  uicehi = interp2(YY_in2D,XX_in2D,uicelow,YY_out2D,XX_out2D,'cubic');  %%% Interpolation
  vicehi = interp2(YY_in2D,XX_in2D,vicelow,YY_out2D,XX_out2D,'cubic');  %%% Interpolation
  %%% Extrapolation
  areahi = inpaint_nans(areahi); 
  heffhi = inpaint_nans(heffhi); 
  hsnowhi = inpaint_nans(hsnowhi); 
  hsalthi = inpaint_nans(hsalthi); 
  uicehi = inpaint_nans(uicehi); 
  vicehi = inpaint_nans(vicehi); 

  Negative2zero = areahi<0;
  areahi(Negative2zero) = 0;
  
  Negative2zero = heffhi<0;
  heffhi(Negative2zero) = 0;
  
  Negative2zero = hsnowhi<0;
  hsnowhi(Negative2zero) = 0;
  
  Negative2zero = hsalthi<0;
  hsalthi(Negative2zero) = 0;
        
  uicehi(:,end) = 0;
  vicehi(:,end) = 0;
  
  Hi0 = 1;
  Si0 = 6; % The salinity for 1m sea ice is about 6 g/kg. Cox et al., (1974). Salinity variations in sea ice. 
  rho_i = 920; % Density of sea ice
  hsalthi = (Si0*rho_i*Hi0).*ones(Nx_out,Ny_out);
  
  writeDataset(areahi,fullfile(expdir,expname_hires,'input/AreaFile.bin'),ieee,prec);
  writeDataset(heffhi,fullfile(expdir,expname_hires,'input/HeffFile.bin'),ieee,prec);
  writeDataset(hsnowhi,fullfile(expdir,expname_hires,'input/HsnowFile.bin'),ieee,prec);
  writeDataset(hsalthi,fullfile(expdir,expname_hires,'input/HsaltFile.bin'),ieee,prec);  
  writeDataset(uicehi,fullfile(expdir,expname_hires,'input/uIceFile.bin'),ieee,prec);
  writeDataset(vicehi,fullfile(expdir,expname_hires,'input/vIceFile.bin'),ieee,prec); 
  
  
  
end

