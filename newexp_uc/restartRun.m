%%%
%%% restartRun.m
%%%
%%% Sets up an MITgcm simulation to be restarted from the last checkpoint.
%%%
%%% expdir - full path to folder containing the experiment
%%% expname - name of the experiment
%%%
function restartRun (expdir,expname)

  %%% Directories containing simulation files
  resultsdir = fullfile(expdir,expname,'results');
  inputdir = fullfile(expdir,expname,'input');
  pchkptAFile = fullfile(resultsdir,'pickup.ckptA');
  pchkptBFile = fullfile(resultsdir,'pickup.ckptB');    
  datafile = fullfile(inputdir,'data');
  
  %%% Extract iteration numbers from checkpoint files
  timestepnumberA = readMetaFile([pchkptAFile '.meta']);
  timestepnumberB = readMetaFile([pchkptBFile '.meta']);
  
  %%% Figure out which checkpoint file is the latest one
  if (timestepnumberA > timestepnumberB)
    lastPickupFile = 'pickup.ckptA';
    lastPickupsomTFile = 'pickup_somT.ckptA';
    timestepnumber = timestepnumberA;
  else
    lastPickupFile = 'pickup.ckptB';
    lastPickupsomTFile = 'pickup_somT.ckptB';
    timestepnumber = timestepnumberB;
  end
    
  %%% Copy checkpoint file and rename using its iteration number
  copyfile(fullfile(resultsdir,[lastPickupFile '.meta']),fullfile(resultsdir,['pickup.',num2str(timestepnumber,'%.10d'),'.meta']));
  copyfile(fullfile(resultsdir,[lastPickupFile '.data']),fullfile(resultsdir,['pickup.',num2str(timestepnumber,'%.10d'),'.data']));
  copyfile(fullfile(resultsdir,[lastPickupsomTFile '.meta']),fullfile(resultsdir,['pickup_somT.',num2str(timestepnumber,'%.10d'),'.meta']));
  copyfile(fullfile(resultsdir,[lastPickupsomTFile '.data']),fullfile(resultsdir,['pickup_somT.',num2str(timestepnumber,'%.10d'),'.data']));
  
  %%% Set nIter0 to timestepnumber in the simulation's input data file
  fid = fopen(datafile,'r');
  if (fid == -1)
    error(['Could not open ',datafile]);
  end
  datastr = '';
  tline = fgetl(fid);
  while (ischar(tline))
    if isempty(strfind(tline,'nIter0'))
      datastr = [datastr,tline,'\n'];
    else
      datastr = [datastr,' nIter0=',num2str(timestepnumber),',\n'];
    end
    tline = fgetl(fid);
  end
  fclose(fid);
  fid = fopen(datafile,'w');
  fprintf(fid,datastr);
  
  %%% Restart simulation
  exec('cd 

end

%%%
%%% Convenience function to read the iteration number from a .meta file.
%%% This code is all copied directly from the localrdmds function within
%%% the MITgcm rdmds.m code file.
%%%
function timestepnumber = readMetaFile (fname)

  recnum = [];

  mname=strrep(fname,' ','');
  dname=strrep(mname,'.meta','.data');

  %- set default mapping from tile to global file:
  map2glob=[0 1];

  % Read and interpret Meta file
  fid = fopen(mname,'r');
  if (fid == -1)
   error(['File' mname ' could not be opened'])
  end

  % Scan each line of the Meta file
  allstr=' ';
  keepgoing = 1;
  while keepgoing > 0,
   line = fgetl(fid);
   if (line == -1)
    keepgoing=-1;
   else
  % Strip out "(PID.TID *.*)" by finding first ")"
  %old  ind=findstr([line ')'],')'); line=line(ind(1)+1:end);
    ind=findstr(line,')');
    if size(ind) ~= 0
      line=line(ind(1)+1:end);
    end
  % Remove comments of form //
    line=[line,' //']; ind=findstr(line,'//'); line=line(1:ind(1)-1);
  % Add to total string (without starting & ending blanks)
    while line(1:1) == ' ', line=line(2:end); end
    if strncmp(line,'map2glob',8), eval(line);
    else allstr=[allstr,deblank(line),' '];
    end
   end
  end

  % Close meta file
  fclose(fid);

  % Strip out comments of form /* ... */
  ind1=findstr(allstr,'/*'); ind2=findstr(allstr,'*/');
  if size(ind1) ~= size(ind2)
   error('The /* ... */ comments are not properly paired')
  end
  while size(ind1,2) > 0
   allstr=[deblank(allstr(1:ind1(1)-1)) allstr(ind2(1)+2:end)];
  %allstr=[allstr(1:ind1(1)-1) allstr(ind2(1)+3:end)];
   ind1=findstr(allstr,'/*'); ind2=findstr(allstr,'*/');
  end

  % This is a kludge to catch whether the meta-file is of the
  % old or new type. nrecords does not exist in the old type.
  nrecords = NaN;

  %- store the full string for output:
  M=strrep(allstr,'format','dataprec');

  % Everything in lower case
  allstr=lower(allstr);

  % Fix the unfortunate choice of 'format'
  allstr=strrep(allstr,'format','dataprec');

  % Evaluate meta information
  eval(allstr);

  N=reshape( dimlist , 3 , prod(size(dimlist))/3 );
  rep=[' dimList = [ ',sprintf('%i ',N(1,:)),']'];
  if ~isnan(nrecords) & nrecords > 1 & isempty(recnum)
   N=[N,[nrecords 1 nrecords]'];
  elseif ~isempty(recnum) & recnum>nrecords
   error('Requested record number is higher than the number of available records')
  end

  %- make "dimList" shorter (& fit output array size) in output "M":
   pat=' dimList = \[(\s*\d+\,?)*\s*\]';
   M=regexprep(M,pat,rep);
  %  and remove double space within sq.brakets:
  ind1=findstr(M,'['); ind2=findstr(M,']');
  if length(ind1) == length(ind2),
   for i=length(ind1):-1:1, if ind1(i) < ind2(i),
    M=[M(1:ind1(i)),regexprep(M(ind1(i)+1:ind2(i)-1),'(\s+)',' '),M(ind2(i):end)];
   end; end
  else error('The [ ... ] brakets are not properly paired')
  end

end