%%%
%%% plotSurfaceSpeed.m
%%%
%%% Makes plots of surface speed.
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

%%% Mesh grids for plotting
[YY,XX] = meshgrid(yy/1000,xx/1000);

%%% Calculate surface speed
uabs = sqrt(uu(:,:,1).^2+vv(:,:,1).^2);

%%% Remove topography
uabs(uabs==0) = NaN;

%%% Plotting options
scrsz = get(0,'ScreenSize');
fontsize = 26;
framepos = [0 scrsz(4)/2 700 550];
plotloc = [0.15 0.15 0.7 0.75];

%%% Set up the figure
handle = figure(9);
set(handle,'Position',framepos);
clf;
axes('FontSize',fontsize);
set(gcf,'color','w');  
contourf(XX,YY,uabs,30,'EdgeColor','None');  
xlabel('x (km)');
ylabel('y (km)');
    
%%% Finish the plot
handle=colorbar;
set(handle,'FontSize',fontsize);
set(gca,'Position',plotloc);
colormap jet;
annotation('textbox',[0.7 0.04 0.3 0.05],'String','$|\overline{\bf{u}}|$ ($\mathrm{m}$/$\mathrm{s}$)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');