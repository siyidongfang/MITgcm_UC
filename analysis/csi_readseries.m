%%% Reads all iterations of a specified MITgcm output field
%%% between specified times
%%%
function series_yzt = csi_readseries (exppath,field,dumpIters,Nx,Ny,Nr)

      
      FULLFILE = fullfile(exppath,'results',field)
      series_xyzt = rdmds(FULLFILE,dumpIters);
      if (ndims(series_xyzt) == 4)
         series_yzt = zeros(Ny,Nr,length(dumpIters));
         series_yzt(:,:,:) = series_xyzt(2,:,:,:)
      else
         series_yzt = zeros(Ny,length(dumpIters));
         series_yzt(:,:) = series_xyzt(2,:,:) %ETAN??xy?????z
      end
end