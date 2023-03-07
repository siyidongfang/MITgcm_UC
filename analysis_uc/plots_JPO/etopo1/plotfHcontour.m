%%%
%%% plotfHcontour.m
%%%
%%% Extracts and plots f/H contours around Antarctica
%%%

%%% Load bathymetry data
ncfile = 'ETOPO1_Bed_g_gmt4.grd';
x = ncread(ncfile,'x');
y = ncread(ncfile,'y');
b = ncread(ncfile,'z');
y = y(1:3601);
b = b(:,1:3601);

%%% Switch to lon in [0,360]
idx1 = find(x<0);
idx2 = find(x>=0);
x = [x(idx2) ;x(idx1)+360];
b = [b(idx2,:); b(idx1,:)];

%%% Earth parameters
Rp = 6380000;
Omega = 2*pi*366/365/86400;

%%% Calculate planetary PV
[Y X] = meshgrid(y,x);
f = 2*Omega*sind(Y);
pv = f ./ (-b);

%%% Find the longest topographic contour: this is the Antarctic coastline
cntrlevs = -3.75e-8;
cntrs = cell(length(cntrlevs));

handle = figure(101);
set (handle,'visible','off');
for n=1:length(cntrlevs)
  
  %%% Find the contour using matlab contour plotting utilities
  [C,h] = contour(X,Y,pv,[cntrlevs(n) cntrlevs(n)],'EdgeColor','k','LineWidth',2);  
  idx = 1;
  maxlen = 0;
  maxidx = 2;
  while (idx < size(C,2))
    len = C(2,idx);
    if (maxlen<len ...
        && len~=96686 ... %%% Excludes spurious contours
        && len~=102121) 
      maxlen = len;
      maxidx = idx + 1;
    end
    idx = idx + len + 1;
  end
  cntr = C(:,maxidx:maxidx+maxlen-1);
  
  %%% Save the computed contours
  cntrs{n} = cntr;
  
end

%%% Plot the contour
figure(2)
plot(cntr(1,:),cntr(2,:))