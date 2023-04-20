%%%  
%%% extractDOT.m
%%%
%%% Extracts DOT climatology for specified months.
%%%

%%% Months to average over
months = [1:12];
% years = [2011:2013];
 years = [2014:2016];

%%% Extract DOT and grid variables
DOT = ncread('CS2_combined_Southern_Ocean_2011-2016.nc','DOT');
Latitude = ncread('CS2_combined_Southern_Ocean_2011-2016.nc','Latitude');
Longitude = ncread('CS2_combined_Southern_Ocean_2011-2016.nc','Longitude');
Y = ncread('CS2_combined_Southern_Ocean_2011-2016.nc','Y');
X = ncread('CS2_combined_Southern_Ocean_2011-2016.nc','X');
dates = ncread('CS2_combined_Southern_Ocean_2011-2016.nc','date');

%%% Loop over months and years to average into a climatology
DOT_clim = 0*DOT(:,:,1);
n_avg = 0*DOT(:,:,1);
for year = years
  for month = months
    date = str2num([num2str(year) num2str(month,'%.02d')]);
    idx = find(dates==int32(date));
    if (isempty(idx))
      error(['Could not find date: ',num2str(date)]);
    end
    DOT_month = DOT(:,:,idx);
    addidx = ~isnan(DOT_month);
    DOT_clim(addidx) = DOT_clim(addidx) + DOT_month(addidx);
    n_avg(addidx) = n_avg(addidx) + 1;
  end
end
n_avg_recip = 1./n_avg;
n_avg_recip(n_avg==0) = 0;
DOT_clim = DOT_clim .* n_avg_recip;

%%% Write to .mat file
save('DOT_climatology_2014-2016.mat','X','Y','months','years','Latitude','Longitude','DOT_clim');
