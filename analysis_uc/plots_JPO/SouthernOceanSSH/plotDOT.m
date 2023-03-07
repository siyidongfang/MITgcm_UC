%%% DOT: dynamic ocean topography (cm)
%%% SLA: Sea Level Anomalies (cm)
%%% MDT: mean dynamic topography (cm)

DOT = ncread('CS2_combined_Southern_Ocean_2011-2016.nc','DOT');
SLA = ncread('CS2_combined_Southern_Ocean_2011-2016.nc','SLA');
MDT = ncread('CS2_combined_Southern_Ocean_2011-2016.nc','MDT');
Latitude = ncread('CS2_combined_Southern_Ocean_2011-2016.nc','Latitude');
Longitude = ncread('CS2_combined_Southern_Ocean_2011-2016.nc','Longitude');
Y = ncread('CS2_combined_Southern_Ocean_2011-2016.nc','Y');
X = ncread('CS2_combined_Southern_Ocean_2011-2016.nc','X');
date = ncread('CS2_combined_Southern_Ocean_2011-2016.nc','date');

[YY,XX] = meshgrid(Y,X);

figure(1);
set(gcf,'Color','w');
M = moviein(length(date));
for n=1:length(date)
  pcolor(XX,YY,SLA(:,:,n));
  shading interp;
  colorbar;
  colormap jet;
%   caxis([-220 0]);
  caxis([-20 20])
%   colormap redblue;
  title(num2str(date(n)));
  M(n) = getframe(gcf);
%   pause(0.5)
end

% contourf(XX,YY,nanmean(DOT,3),-220:5:100);
% shading interp;
