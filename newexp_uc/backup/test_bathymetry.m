
  Nx = 400;
  Ny = 448;   
  m1km = 1000;
  Ws = 25*m1km; %%% Slope half-width
  Lx = 400*m1km; %%% Domain size in x 
  Ly = 450*m1km; %%% Domain size in y   
  H = 4000; %%% Domain size in z 

  use_trough = true;
  
  %%% Topographic parameters 
  Hshelf = 500; %%% Continental shelf depth
  Hs = H - Hshelf; %%% Shelf height
  Ys = 150*m1km; %%% Meridional slope position
  
  %%% Trough parameters
  N_trough = 4;
  H_trough = 300; %%% Positive for a trough, negative for a ridge
  H_bump = -H_trough;
  W_trough = Lx/N_trough/4; %%% Default 50*m1km

  X_trough = zeros(1,N_trough);
  X_bump = zeros(1,N_trough);
  for nrt = 1:N_trough
      X_trough(1,nrt) = (2*nrt-1-N_trough)/2*Lx/N_trough;
      X_bump(1,nrt)= (2*nrt-N_trough)/2*Lx/N_trough;
  end
  Y_trough = 0*m1km; %%% Southern edge of trough
  
  if(use_trough)
     Zs = 2250 + H_trough/2*N_trough; %%% Vertical slope position, 2850m  (Exponentials: Zs=1000; Tanh-like: 2250)
  else
     Zs = 2250; 
  end
  
  
  %%% Zonal grid
  dx = Lx/Nx;  
  xx = (1:Nx)*dx;
  xx = xx-mean(xx);
  
  %%% Uniform meridional grid   
  dy = (Ly/Ny)*ones(1,Ny);  
  yy = cumsum((dy + [0 dy(1:end-1)])/2);
 
  %%% Plotting mesh
  [Y,X] = meshgrid(yy,xx);
  

  z_topog = Zs * ones(size(X));
  h_topog = Hs * ones(size(X));
  if (use_trough)    
    for ntr = 1:N_trough
        h_trough = H_trough * exp(-((X-X_trough(ntr))/W_trough).^4);
        h_trough(Y<Y_trough) = 0;
        yidx = (yy>Y_trough) & (yy<Ys-Ws);
        h_trough(:,yidx) = h_trough(:,yidx) .* 0.5.*(1-cos(pi*(Y(:,yidx)-Y_trough)/(Ys-Ws-Y_trough)));
        z_topog =  (z_topog-0.5*H_trough).*ones(size(X)) + h_trough;
        h_topog = h_topog - 2 * h_trough;
    end 
  end  
  h = -z_topog - (h_topog/2).*tanh((Y-Ys)/Ws);  
  
  fontsize = 12;
  
  %%% Plot the bathymetry
    figure(1);
    clf;
    surf(X/1000,Y/1000,h,'EdgeColor','None');   
    xlabel('x (km)');
    ylabel('y (km)');
    zlabel('hb','Rotation',0);
%     plot(Y(1,:),h(1,:));
    title('Model bathymetry');
    set(gca,'fontsize',fontsize+2,'Ydir','reverse');
    PLOT = gcf;
    PLOT.Position = [248 284 655 442];  
