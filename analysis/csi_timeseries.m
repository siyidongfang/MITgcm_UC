%%%
%%% timeseries.m
%%%
%%% Calculates the time series of the output fields from MITgcm runs.
%%%
%%% Read experiment data
% clear diag_fields;
% clear diag_timePhase;
% clear diag_fileNames;
% clear diag_frequency;
% loadexp;

%%% Frequency of diagnostic output - should match that specified in
%%% data.diagnostics.
dumpFreq = abs(diag_frequency(6));
nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);

%%% Write the time series into .mat files for whichever fields are present
EXPPATH_NAME = [exppath, expname]


for m=1:length(diag_fields)
  if (m == 1) %%% N.B. This won't work if the first field isn't one of those listed below
    flag = '';
  else    
    flag = '-append';
  end
  
%     var_name = [diag_fields{m},'_inst']; 
    var_name = diag_fields{m};
  if (diag_frequency(m) > 0)
    var_data = csi_readseries(exppath,var_name,dumpIters,Nx,Ny,Nr);    
    tempStruct.(var_name) = var_data;   
    %%% sydf
   % save([expname,'_tavg.mat'],'-struct','tempStruct',var_name,flag);
    %save([EXPPATH_NAME,'_tavg.mat'],'-struct','tempStruct',var_name,flag);  
    save([EXPPATH_NAME,'_timeseries.mat'],'-struct','tempStruct',var_name,flag);
  end
end




    

