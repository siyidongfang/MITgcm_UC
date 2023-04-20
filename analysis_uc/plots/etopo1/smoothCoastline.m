%%%
%%% smoothCoastline.m
%%%
%%% Creates a piecewise-linear representation of the Antarctic coastline.
%%%

%%% Load bathymetry data
ncfile = 'ETOPO1_Bed_g_gmt4.grd';
x = ncread(ncfile,'x');
y = ncread(ncfile,'y');
b = ncread(ncfile,'z');
y = y(1:3601);
b = b(:,1:3601);
[Y X] = meshgrid(y,x);

%%% Find the longest topographic contour: this is the Antarctic coastline
% cntrlevs = [-2000:500:-500];
cntrlevs = -1000;
cntrs = cell(length(cntrlevs));
cntrs_sub = cell(length(cntrlevs));
cntrs_bathy = cell(length(cntrlevs));
cntrs_lon_mid = cell(length(cntrlevs));
cntrs_lat_mid = cell(length(cntrlevs));
cntrs_sec_len = cell(length(cntrlevs));
handle = figure(101);
set (handle,'visible','off');
for n=1:length(cntrlevs)
  
  %%% Find the contour using matlab contour plotting utilities
  [C,h] = contour(X,Y,b,[cntrlevs(n) cntrlevs(n)],'EdgeColor','k','LineWidth',2);  
  idx = 1;
  maxlen = 0;
  maxidx = 2;
  while (idx < size(C,2))
    len = C(2,idx);
    if (maxlen<len ...
        && len~=41388 ... %%% Excludes a spurious contour that emerges if a depth of 700m is used
        && len~=55315) %%% Excludes a spurious contour that emerges if a depth of 500m is used
      maxlen = len;
      maxidx = idx + 1;
    end
    idx = idx + len + 1;
  end
  cntr = C(:,maxidx:maxidx+maxlen-1);
  
  %%% Subsample the data points to smooth the coastline a bit
%   subfac = 100;
%   cntr_sub = zeros(2,floor(size(cntr,2)/subfac));
%   cntr_len = size(cntr_sub,2);
%   for i=1:cntr_len
%     cntr_sub(:,i) = cntr(:,subfac*(i-1)+1);
%   end

  %%% Create a smoothed contour with fixed-length (lat/lon) linear splines
  seclen = 1;
  cntr_sub = 0*cntr;
  cntr_sub(:,1) = cntr(:,1);
  m = 1;
  for i = 1:maxlen
    dist = sqrt(sum((cntr(:,i)-cntr_sub(:,m)).^2));    
    if (dist >= seclen)
      m = m+1;
      cntr_sub(:,m) = cntr(:,i);
    end      
  end
  cntr_len = m;
  cntr_sub = cntr_sub(:,1:cntr_len);
  
  %%% Used for interpolating bathymetry
  lon_mid = 0.5 * (cntr_sub(1,1:cntr_len) + cntr_sub(1,[2:cntr_len 1])); 
  lon_mid(cntr_len) = 0.5 * (cntr_sub(1,cntr_len) + cntr_sub(1,1)-360); 
  lat_mid = 0.5 * (cntr_sub(2,1:cntr_len) + cntr_sub(2,[2:cntr_len 1])); 
  Rp = 6371000;
  L1deg_lat = 2*pi*Rp/360*ones(1,cntr_len);
  L1deg_lon = 2*pi*Rp/360*cos(2*pi*lat_mid/360);
  
  %%% Cross-slope grid definition
  Nn = 41; %%% Number of grid points (must be odd)
  dn = 10000; %%% Grid point spacing in m
  cntr_bathy = zeros(Nn,cntr_len);
  sec_len = zeros(1,cntr_len);
  
  %%% Now go through each linear section and obtain a profile of
  %%% cross-slope bathymetry    
  for m=1:cntr_len
    
    %%% Extract beginning and end points of linear section
    if (m < cntr_len)
      lon_end = cntr_sub(1,m+1);
    else
      lon_end = cntr_sub(1,1) - 360;
    end      
    lon_start = cntr_sub(1,m);
    if (m < cntr_len)
      lat_end = cntr_sub(2,m+1);
    else
      lat_end = cntr_sub(2,1);
    end
    lat_start = cntr_sub(2,m);
    sec_len(m) = sqrt( ((lon_end-lon_start)*L1deg_lon(m))^2 ...
                     + ((lat_end-lat_start)*L1deg_lat(m))^2 );

    %%% First, define an array of along-slope/cross-slope positions
    Nt = 20;       
    in_mid = (Nn-1)/2 + 1;        
    dlon_t = (lon_end-lon_start)/(Nt-1); %%% Increments along the section
    dlat_t = (lat_end-lat_start)/(Nt-1);   
    Llon_t = dlon_t * L1deg_lon(m); %%% Distance increments along the section
    Llat_t = dlat_t * L1deg_lat(m);
    Llon_n = Llat_t * dn/sqrt(Llon_t^2+Llat_t^2); %%% Distance increments perpendicular to section
    Llat_n = - Llon_t * dn/sqrt(Llon_t^2+Llat_t^2);
    dlon_n = Llon_n / L1deg_lon(m); %%% Increments perpendicular to section
    dlat_n = Llat_n / L1deg_lat(m);
    
    %%% Construct a small lon/lat grid surrounding the linear coastal
    %%% section
    glons = zeros(Nt,Nn);
    glats = zeros(Nt,Nn);
    gbathy = zeros(Nt,Nn);
    if (dlon_t==0)
      glons(:,in_mid) = lon_start;
    else
      glons(:,in_mid) = lon_start:dlon_t:lon_end;
    end
    if (dlat_t == 0)
      glats(:,in_mid) = lat_start;
    else     
      glats(:,in_mid) = lat_start:dlat_t:lat_end;
    end
    for in=1:Nn;
      glons(:,in) = glons(:,in_mid) + (in-in_mid)*dlon_n;
      glats(:,in) = glats(:,in_mid) + (in-in_mid)*dlat_n;
    end
    
    %%% Wrap around longitudes
    glons(glons>180) = glons(glons>180) - 360;
    glons(glons<-180) = glons(glons<-180) + 360;
    
    %%% Loop over along-slope/across-slope grid and interpolate bathymetry
    %%% to each point
    for it = 1:Nt
      for in = 1:Nn
        
        %%% Find nearest lat/lon positions on bathymetric grid        
        if (glons(it,in)==-180)
          iprev = 1;
          inext = 2;
        else
          iprev = ceil((glons(it,in)+180)*60);
          inext = ceil((glons(it,in)+180)*60+1);        
        end
        jprev = floor((glats(it,in)+90)*60+1);
        jnext = floor((glats(it,in)+90)*60+2);

        %%% Interpolate bathymetry
        xnext = X(inext,jnext); %%% j-index doesn't actually matter
        xprev = X(iprev,jprev);
        wt_ip_jp = (xnext-glons(it,in))*(Y(inext,jnext)-glats(it,in));
        wt_in_jp = (glons(it,in)-xprev)*(Y(iprev,jnext)-glats(it,in));
        wt_ip_jn = (xnext-glons(it,in))*(glats(it,in)-Y(inext,jprev));
        wt_in_jn = (glons(it,in)-xprev)*(glats(it,in)-Y(iprev,jprev));            
        wt_isum = wt_ip_jp + wt_in_jp + wt_ip_jn + wt_in_jn;
        gbathy(it,in) = wt_ip_jp*b(iprev,jprev) ...
                      + wt_in_jp*b(inext,jprev) ...
                      + wt_ip_jn*b(iprev,jnext) ...
                      + wt_in_jn*b(inext,jnext);
        gbathy(it,in) = gbathy(it,in) / wt_isum;
        
      end

    end    

    %%% Average bathymetry along section and store
    cntr_bathy(:,m) = mean(gbathy,1)';
    
  end
  
  %%% Save the computed contours
  cntrs{n} = cntr;
  cntrs_sub{n} = cntr_sub;
  cntrs_bathy{n} = cntr_bathy;
  cntrs_lon_mid{n} = lon_mid;
  cntrs_lat_mid{n} = lat_mid;
  cntrs_sec_len{n} = sec_len;
  
end

%%% Save the data 
save AntarcticCoastline_new.mat cntrlevs cntrs cntrs_sub cntrs_bathy cntrs_lon_mid cntrs_lat_mid cntrs_sec_len