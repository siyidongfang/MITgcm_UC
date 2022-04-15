  Nx = 200;
  Ny = 250;
  Nr = 100;

  m1km = 1000;
  H = 4000; %%% Domain size in z 
  Lx = 400*m1km; %%% Domain size in x 
  Ly = 450*m1km; %%% Domain size in y   

  %%% Topographic parameters 
  Wslope = 30*m1km; %%% Continental slope half-width
  Hshelf = 800; %%% Continental shelf depth
  Wshelf = 50*m1km; %%% Width of continental shelf
  Ycoast = 200*m1km; %%% Latitude of coastline
  Wcoast = 20*m1km; %%% Width of coastal wall slope
  Yshelfbreak = Ycoast+Wshelf; %%% Latitude of shelf break
  Yslope = Ycoast+Wshelf+Wslope; %%% Latitude of mid-continental slope
  Ydeep = 350*m1km; %%% Latitude of deep ocean
  Xeast = 275*m1km; %%% Longitude of eastern trough wall
  Xwest = 125*m1km; %%% Longitude of western trough wall
  Yicefront = 150*m1km; %%% Latitude of ice shelf face
  Hicefront = 200; %%% Depth of ice shelf frace
  Hbed = -500; %%% Change in bed elevation from shelf break to southern domain edge
  Hice = Hicefront-(Hshelf-Hbed); %%% Change in ice thickness from ice fromt to southern domain edge
  Htrough = 300; %%% Trough depth
  Wtrough = 15*m1km; %%% Trough width
  Xtrough = Lx/2; %%% Longitude of trough
  


  %%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% GRID SPACING %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%    

  %%% Zonal grid
  dx = Lx/Nx;  
  xx = (1:Nx)*dx;
  
  %%% Uniform meridional grid   
  dy = (Ly/Ny)*ones(1,Ny);  
  yy = cumsum((dy + [0 dy(1:end-1)])/2);
 
  %%% Plotting mesh
  [Y,X] = meshgrid(yy,xx);


  %%% Variable grid with high resolution at ice shelf cavity depths, very high in surface mixed layer    
  dz0 = 2;
  dz1 = 15; 
  dz2 = 20;
  dz3 = 100;
  dz4 = 200;  
  N0 = 1;
  N1 = 20; 
  N2 = 50;
  N3 = 15;
  N4 = 14;  
  nn_c = cumsum([N0 N1 N2 N3 N4]);
  dz_c = [dz0 dz1 dz2 dz3 dz4];
  nn = 1:(N1+N2+N3+N4+1);
  dz = interp1(nn_c,dz_c,nn,'pchip');

  zz = -cumsum((dz+[0 dz(1:end-1)])/2);
  if (length(zz) ~= Nr)
    error('Vertical grid size does not match vertical array dimension!');
  end
  Nr = length(zz);




  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%% BATHYMETRY AND ICE SHELF DRAFT %%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
  %%% Construct shelf/slope/deep ocean bathymetry profile via cubic
  %%% interpolation
  y_interp = [0 (Yslope-Wslope)/2 Yslope-Wslope Yslope Ydeep Ly];
  h_interp = [-Hshelf+Hbed -Hshelf+Hbed/2 -Hshelf -(Hshelf+H)/2 -H -H];
  h_profile = interp1(y_interp,h_interp,yy,'pchip');
  h = repmat(h_profile,[Nx 1]);
  
  
  %%% Add trough
  y_interp = [0 Yshelfbreak Yslope Ly];
  h_interp = [0 -Htrough 0 0];
  h_trough_profile = interp1(y_interp,h_interp,yy,'pchip');
  h_trough = repmat(h_trough_profile,[Nx 1]);
  h_trough = h_trough .* 1./(cosh((X-Xtrough)/Wtrough)).^2;
  h = h + h_trough;
  
    
  %%% Add coastal wall %%%
  h_coast = zeros(Nx,Ny);
  
  %%% Western coastline
  coastidx = (Y<Ycoast+Wcoast/2) & (Y>Ycoast-Wcoast/2) & (X<=Xwest-Wcoast/2);
  h_coast(coastidx) = h_coast(coastidx) - h(coastidx).*coastShape((Y(coastidx)-Ycoast+Wcoast/2)/Wcoast);
  landidx = find((Y<=Ycoast-Wcoast/2) & (X<=Xwest-Wcoast/2));
  h_coast(landidx) = -h(landidx);
  
  %%% Western corner
  R = sqrt((X-(Xwest-Wcoast/2)).^2+(Y-(Ycoast-Wcoast/2)).^2);
  coastidx = (Y>Ycoast-Wcoast/2) & (X>Xwest-Wcoast/2) & (R <= Wcoast);  
  h_coast(coastidx) = h_coast(coastidx) - h(coastidx).*coastShape((R(coastidx))/Wcoast);
  
  %%% Western trough wall
  coastidx = (Y<Ycoast-Wcoast/2) & (X<=Xwest+Wcoast/2) & (X>Xwest-Wcoast/2);
  h_coast(coastidx) = h_coast(coastidx) - h(coastidx).*coastShape((X(coastidx)-Xwest+Wcoast/2)/Wcoast);   
  
  %%% Eastern coastline
  coastidx = (Y<Ycoast+Wcoast/2) & (Y>Ycoast-Wcoast/2) & (X>=Xeast+Wcoast/2);
  h_coast(coastidx) = h_coast(coastidx) - h(coastidx).*coastShape((Y(coastidx)-Ycoast+Wcoast/2)/Wcoast);
  landidx = find((Y<=Ycoast-Wcoast/2) & (X>=Xeast+Wcoast/2));
  h_coast(landidx) = -h(landidx);
  
  %%% Eastern corner
  R = sqrt((X-(Xeast+Wcoast/2)).^2+(Y-(Ycoast-Wcoast/2)).^2);
  coastidx = (Y>Ycoast-Wcoast/2) & (X<Xeast+Wcoast/2) & (R <= Wcoast);  
  h_coast(coastidx) = h_coast(coastidx) - h(coastidx).*coastShape((R(coastidx))/Wcoast);
  
  %%% Eastern trough wall
  coastidx = (Y<Ycoast-Wcoast/2) & (X<Xeast+Wcoast/2) & (X>=Xeast-Wcoast/2);
  h_coast(coastidx) = h_coast(coastidx) - h(coastidx).*coastShape(-(X(coastidx)-Xeast-Wcoast/2)/Wcoast);   
  
  h = h + h_coast;

 
  %%% Construct ice shelf
  icedraft = zeros(Nx,Ny);
  iceidx = find(Y<=Yicefront);  
  icedraft(iceidx) = -Hicefront - (Y(iceidx)-Yicefront)/Yicefront * Hice;
  icedraft(icedraft<h) = h(icedraft<h);
  
  
  %%% Make sure there are no "holes" along the southern boundary, or MITgcm
  %%% will think it's supposed to be north/south periodic
  wallidx = find(icedraft(:,1)>h(:,1));
  h(wallidx,1) = icedraft(wallidx,1);
  
  %%% Remove water column thicknesses less than a specified minimum
  Hmin = 50;
  wct = icedraft - h;
  h(wct < Hmin) = icedraft(wct < Hmin);










  

  %%% Plot bathymetry and ice draft
  figure(1)
  clf;    

  %%% Bathymetry  
  p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,h(:,2:end-1));
  p.FaceColor = [11*16+9 9*16+12 6*16+11]/255;
  p.EdgeColor = 'none';

  %%% Modified ice draft to look good in the plot
  icedraft_plot = icedraft;
  icedraft_plot(icedraft==0) = NaN;
  icetop_plot = 0*icedraft_plot;
  for i=1:Nx
    j = find(~isnan(icetop_plot(i,:)),1,'last');
    if (isempty(j))
      continue;
    else
      icetop_plot(i,j+1) = max(-Hicefront,h(i,j+1));
    end
  end
 
  %%% Plot ice
  hold on;
  p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,icedraft_plot(:,2:end-1));
  p.FaceColor = [153, 255, 255]/255;
  p.EdgeColor = 'none';
  p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,icetop_plot(:,2:end-1));
  p.FaceColor = [153, 255, 255]/255;
  p.EdgeColor = 'none';
  hold off;

  xlabel('x (km)','interpreter','latex');
  ylabel('y (km)','interpreter','latex');
  zlabel('z (m)','interpreter','latex');

  
  %%% Decorations
  view(-206,14);
  axis tight;
  pbaspect([Lx/Ly 1 1]);
  camlight('headlight');
  lightangle(-206,34);
  lighting flat;




%%%
%%% Specifies shape of coastal walls. Must satisfy f=1 at x=0 and f=0 at
%%% x=1.
%%%
function f = coastShape (x)
 
  f = 0.5.*(1+cos(pi*x));
%   f = exp(-x);
%   f = 1-x;
  
end
  
 imgpath = '/Users/csi/MITgcm_UC/figures_uc/model/';
%  savefig([imgpath '/model_Garrett.fig']);
 saveas(gcf,[imgpath '/model_Garrett_2.png']);

