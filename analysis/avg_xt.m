%%%
%%% avg_xt.m
%%%
%%% Calculates the time average of the output fields from MITgcm runs.
%%%
savename = [exppath '/' expname '_tx_avg_5yrs.mat'];

load([exppath '/' expname '_tavg_5yrs.mat']);
% load([exppath '/' expname '_MOC_pt.mat']);

%%% Read experiment data
clear diag_fields;
clear diag_timePhase;
clear diag_fileNames;
clear diag_frequency;
loadexp;

%%% Frequency of diagnostic output - should match that specified in
%%% data.diagnostics.
dumpFreq = diag_frequency(1);
nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);

%%% Calculate zonal average for whichever fields are present
 
for m=1:length(diag_fields)
  if (m == 1) %%% N.B. This won't work if the first field isn't one of those listed below
    flag = '';
  else    
    flag = '-append';
  end
  var_name = diag_fields{m};
  if (diag_frequency(m) > 0)
    var_data = squeeze(nanmean(eval(var_name),1));    
    tempStruct.(var_name) = var_data;   
    save(savename,'-struct','tempStruct',var_name,flag);
  end
end

% 
% pt_xtavg = squeeze(nanmean(pt_tavg(:,:,:)));
% pt_f_xtavg = squeeze(nanmean(pt_f(:,:,:)));
% tempStruct.(var_name) = pt_xtavg;   
% save(savename,'-struct','tempStruct',var_name,flag)
% tempStruct.(var_name) = pt_f_xtavg;   
% save(savename,'-struct','tempStruct',var_name,flag)