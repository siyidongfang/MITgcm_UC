%%%
%%% plotEKE.m
%%%
%%% Makes plots of EKE.
%%%

%%% NOTE: Doesn't account for u/v gridpoint locations

%%% Load experiment
loadexp;

%%% Frequency of diagnostic output - should match that specified in
%%% data.diagnostics.
dumpFreq = diag_frequency(1);
nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);

%%% Time averages
uu = readIters(exppath,'UVEL',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);
vv = readIters(exppath,'VVEL',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);
usq = readIters(exppath,'UVELSQ',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);
vsq = readIters(exppath,'VVELSQ',dumpIters,deltaT,tmin,tmax,Nx,Ny,Nr);

%%% Grid spacing matrices
DX = repmat(delX',[1 Ny Nr]);
DY = repmat(delY,[Nx 1 Nr]);
DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

%%% Mesh grids for plotting
[YY,XX] = meshgrid(yy/1000,xx/1000);

%%% Calculate EKE
EKE = 0.5*(usq-uu.^2+vsq-vv.^2);

%%% Depth-averaged EKE
EKE_zavg = sum(EKE.*DZ.*hFacC,3) ./ sum(DZ.*hFacC,3);

%%% Total EKE
EKEDV = EKE.*DX.*DY.*DZ.*hFacC;
sum(sum(sum(EKEDV(:,50:end,:))))

%%% Remove topography
EKE(EKE==0) = NaN;

%%% Plotting options
scrsz = get(0,'ScreenSize');
fontsize = 26;
framepos = [0 scrsz(4)/2 700 550];
plotloc = [0.15 0.15 0.7 0.75];

%%% Set up the figure
handle = figure(7);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
set(gcf,'color','w');
% contourf(XX,YY,log10(EKE(:,:,1)),30,'EdgeColor','None');  
% contourf(XX,YY,log10(EKE_zavg),30,'EdgeColor','None');  
% contourf(XX,YY,EKE(:,:,1),30,'EdgeColor','None');  
contourf(XX,YY,EKE_zavg,30,'EdgeColor','None');  
xlabel('x (km)');
ylabel('y (km)');
    
%%% Finish the plot
handle=colorbar;
set(handle,'FontSize',fontsize);
set(gca,'Position',plotloc);
colormap jet;
annotation('textbox',[0.7 0.04 0.3 0.05],'String','$\overline{\mathrm{EKE}}^z$ ($\mathrm{m}^2$/$\mathrm{s}^2$)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');