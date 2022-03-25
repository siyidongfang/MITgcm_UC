%%%
%%% initialize_3DuvtspIce.m
%%%
%%% Takes an MITgcm experiment, produces input
%%% files for a new experiment at the same resolution.
%%%

 
function initialize_3DuvtspIce (expdir,expname_old,expname_new,expiter,useSEAICE)

  %%% For file I/O
  addpath ../newexp_utils/
  addpath ../utils/matlab  

  %%% Load grid dimensions
  run(fullfile(expdir,expname_old,'input','params.m'));
  Nx_in = length(delX);
  Ny_in = length(delY);
  Nr_in = length(delR);
  
  clear layers_name layers_bounds
  
  run(fullfile(expdir,expname_new,'input','params.m'));
  Nx_out = length(delX);
  Ny_out = length(delY);
  Nr_out = length(delR);
  
  if ((Nx_in~=Nx_out) | (Ny_in~=Ny_out) | (Nr_in~=Nr_out))
      'The numbers of grid points of the old and the new experiments are not the same'
      return
  else 
      Nx = Nx_out; Ny = Ny_out; Nr = Nr_out;
  end
  
  %%% Formatting
  ieee='b';
  prec='real*8';
  

  u_new = rdmds(fullfile(expdir,expname_old,'results/U'),expiter);
  v_new = rdmds(fullfile(expdir,expname_old,'results/V'),expiter);
  t_new = rdmds(fullfile(expdir,expname_old,'results/T'),expiter);
  s_new = rdmds(fullfile(expdir,expname_old,'results/S'),expiter);
  eta_new = rdmds(fullfile(expdir,expname_old,'results/Eta'),expiter);


  %%% Create input arrays
  writeDataset(u_new,fullfile(expdir,expname_new,'input/uVelInitFile.bin'),ieee,prec);
  writeDataset(v_new,fullfile(expdir,expname_new,'input/vVelInitFile.bin'),ieee,prec);
  writeDataset(t_new,fullfile(expdir,expname_new,'input/hydrogThetaFile.bin'),ieee,prec);
  writeDataset(s_new,fullfile(expdir,expname_new,'input/hydrogSaltFile.bin'),ieee,prec);
  writeDataset(eta_new,fullfile(expdir,expname_new,'input/pSurfInitFile.bin'),ieee,prec);

  
if (useSEAICE==true)
  area_new = rdmds(fullfile(expdir,expname_old,'results/AREA'),expiter);
  heff_new = rdmds(fullfile(expdir,expname_old,'results/HEFF'),expiter);
  hsnow_new = rdmds(fullfile(expdir,expname_old,'results/HSNOW'),expiter);
  hsalt_new = rdmds(fullfile(expdir,expname_old,'results/HSALT'),expiter);
  uice_new = rdmds(fullfile(expdir,expname_old,'results/UICE'),expiter);
  vice_new = rdmds(fullfile(expdir,expname_old,'results/VICE'),expiter);
  
  writeDataset(area_new,fullfile(expdir,expname_new,'input/AreaFile.bin'),ieee,prec);
  writeDataset(heff_new,fullfile(expdir,expname_new,'input/HeffFile.bin'),ieee,prec);
  writeDataset(hsnow_new,fullfile(expdir,expname_new,'input/HsnowFile.bin'),ieee,prec);
  writeDataset(hsalt_new,fullfile(expdir,expname_new,'input/HsaltFile.bin'),ieee,prec);  
  writeDataset(uice_new,fullfile(expdir,expname_new,'input/uIceFile.bin'),ieee,prec);
  writeDataset(vice_new,fullfile(expdir,expname_new,'input/vIceFile.bin'),ieee,prec); 
end 
  
end

