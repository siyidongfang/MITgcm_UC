%%%
%%% animVort3D.m
%%%
%%% Visualized vorticity in 3D.
%%%
%%% NOTE: Doesn't account for u/v gridpoint locations, and doesn't handle
%%% partial cells.
%%%

%%% Read experiment data
loadexp;

%%% Vertical grid spacing matrix
DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

%%% Diagnostic indix corresponding to instantaneous velocity
diagnum = length(diag_frequency);

%%% This needs to be set to ensure we are using the correct output
%%% frequency
diagfreq = diag_frequency(diagnum);

%%% Frequency of diagnostic output
dumpFreq = abs(diagfreq);
nDumps = round(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters >= nIter0);
nDumps = length(dumpIters);

%%% Plotting options
M = moviein(length(dumpIters)-1);
fontsize = 16;
figure(1);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 800 720]);
set(gcf,'Color','w');
  
%%% Loop through iterations
for n=1:length(dumpIters)-1
  
  %%% Read velocity data
  uvel = rdmdsWrapper(fullfile(exppath,'/results/UVEL_inst'),dumpIters(n));      
  vvel = rdmdsWrapper(fullfile(exppath,'/results/VVEL_inst'),dumpIters(n)); 
  tt =  (dumpIters(n)-dumpIters(1))*deltaT/86400
  
  %%% Calculate normalized vorticity
  [YY,XX,ZZ]=meshgrid(yy,xx,zz);
  ff = f0+beta*YY;
  XX = XX / 1000;
  YY = YY / 1000;
  vort = zeros(Nx,Ny,Nr);
  vort(:,1:Ny-1,:) = - (uvel(:,2:Ny,:)-uvel(:,1:Ny-1,:))/delY(1);
  vort = vort + (vvel([2:Nx 1],:,:)-vvel(:,:,:))/delX(1);
  vort(hFacS==0) = 0;
  vort(hFacW==0) = 0;
  vort(hFacC==0) = 0;
  vort(:,Ny-1,:) = 0;
  vort(:,2,:) = 0;
  vort = vort ./ abs(ff);

  %%% Bathymetry
  [Y,X] = meshgrid(yy,xx);  
  surf(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,bathy(:,2:end-1));
  cmap = haxby(100);
  colormap(cmap(20:95,:));
  shading interp;

  hold on;

  %%% Positive vorticity
  fv = isosurface(XX,YY,ZZ,vort,0.1);
  p = patch(fv);
  p.FaceColor = 'red';
  p.EdgeColor = 'none';
  alpha(p,0.5);

  %%% Negative vorticity
  fv = isosurface(XX,YY,ZZ,vort,-0.1);
  p = patch(fv);
  p.FaceColor = 'blue';
  p.EdgeColor = 'none';
  alpha(p,0.5);

  hold off;

  %%% Decorations
  view(135,70);
  axis tight;
  lighting gouraud;
  xlabel('x (km)');
  ylabel('y (km)');
  zlabel('z (m)');
  set(gca,'XLim',[-1000 1000]);
  set(gca,'XTick',[-1000:500:1000]);
  set(gca,'YLim',[0 2000]);
  set(gca,'YTick',[0:500:2000]);
  set(gca,'ZLim',[-4500 0]);
  set(gca,'ZTick',[-4500:2000:0]);
  set(gca,'FontSize',fontsize);
  camlight('headlight');
  title(['t = ',num2str(round(tt)),' days']);
  %%% Store in movie buffer
  M(n) = getframe(gcf);

end