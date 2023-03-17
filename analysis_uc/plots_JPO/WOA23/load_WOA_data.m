%%%
%%% load_WOA_data.m
%%%
%%% Reads in WOA!* gridded climatology from NetCDF files and grids it.
%%%

%%% Raw data
% fnames = {'woa18_decav81B0_s00_04','woa18_decav81B0_s13_04','woa18_decav_s00_04'};
% datavar = {'s_an','s_an','s_an'};
% outvar = {'ss81_annual','ss81_winter','ss55_annual'};

fnames = {'woa23_decav91C0_t00_04'};
datavar = {'t_an'};
outvar = {'tt91_annual'};

for m=1:length(fnames)
% for m=1:1
  
  %%% I/O
  ncfname = [fnames{m},'.nc'];
  matfname = [outvar{m},'.mat'];
  
  %%% Load file data
  lat = ncread(ncfname,'lat');
  lon = ncread(ncfname,'lon');
  depth = ncread(ncfname,'depth');
  data = ncread(ncfname,datavar{m});
  
  lon = [-180;lon;180];
  mean_fillgap = mean(data([1,end],:,:),'omitnan');
  mean_fillgap(mean_fillgap==0)=NaN;
  data_fillgap = [mean_fillgap;data;mean_fillgap];
 
  eval([outvar{m},'=data_fillgap;']);
  
  %%% Save to .mat file
  save(matfname,'lon','lat','depth',outvar{m});
  
end
