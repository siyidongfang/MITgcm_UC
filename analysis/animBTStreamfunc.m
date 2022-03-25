%%%
%%% animBTStreamfunc.m
%%%
%%% Makes a movie of the barotropic streamfunction.
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

%%% Grid spacing matrices
DX = repmat(delX',[1 Ny Nr]);
DY = repmat(delY,[Nx 1 Nr]);
DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

%%% Meshgrid for plotting
xx_u = [0 cumsum(delX)]-Lx/2;
yy_v = [0 cumsum(delY)];
[YY_Psi,XX_Psi] = meshgrid(yy_v/1000,xx_u/1000);
[YY,XX] = meshgrid(yy,xx);

Psi_max = 150;
Psi_min = -100;


%%% Initialize movie
figure(8);
set(gcf,'Color','w');
M = moviein(nDumps);

%%% Loop through iterations
for n=1:nDumps
% for n=1:1
 
  tt(n) = dumpIters(n)*deltaT/86400/365;
  tt(n)
  
  %%% Attempt to load either instantaneous velocities or their squares
  uvel = rdmdsWrapper(fullfile(exppath,'/results/UVEL_inst'),dumpIters(n)) ;        
  if (isempty(uvel))   
    break;
  end

  %%% Calculate depth-averaged zonal velocity
  UU = sum(uvel.*DZ.*hFacW,3);

  %%% Calculate barotropic streamfunction
  Psi = zeros(Nx+1,Ny+1);
  Psi(1:Nx,1:Ny) = flipdim(cumsum(flipdim(UU.*DY(:,:,1),2),2),2);
  Psi(:,Ny+1) = 0;
  Psi(Nx+1,:) = Psi(1,:);

  %%% Plot the streamfunction 
  contourf(XX_Psi,YY_Psi,Psi/1e6,[Psi_min:2.5:Psi_max],'EdgeColor','k');    
  hold on;
  contour(XX/1000,YY/1000,-bathy,500:500:3500,'EdgeColor',[0.5 0.5 0.5]);
  hold off;
  caxis([Psi_min Psi_max]);
  colorbar;
  colormap jet;
  set(gca,'FontSize',16);
  xlabel('x (km)');
  ylabel('y (km)');
  annotation('textbox',[0.8 0.05 0.25 0.05],'String','$\Psi_\mathrm{BT}$ (Sv)','interpreter','latex','FontSize',16,'LineStyle','None');
  title(['t= ',num2str(round(tt(n)),'%3d'),' years']);

  M(n) = getframe(gcf);  
  
end