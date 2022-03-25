%%%
%%% plot3Dsnapshot_NSF.m
%%%
%%% Makes a 3D plot of our model setup with a snapshot for our NSF
%%% proposal.
%%%
%%% NOTE: Doesn't account for u/v gridpoint locations, and doesn't handle
%%% partial cells.
%%%
addpath /data/MITgcm_ASF-csi/newexp/analysis;

%%% Select potential temperature surface
theta_plot = 0;

%%% Select simulation
% proddir = '/data/MITgcm_ASF-csi/newexp/';
expdir = '/home/csi/MITgcm_ASF-experiments';
expname = 'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2';
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps;

%%% Read experiment data
expname_tavg = expname;
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

n = 15;  
nIters = dumpIters(n);

%%% Plotting options
fontsize = 12;
figlabel = '(a)';

%%% Read snapshot
theta = rdmdsWrapper(fullfile(exppath,'/results/T'),nIters);    
salt = rdmdsWrapper(fullfile(exppath,'/results/S'),nIters);    
uvel = rdmdsWrapper(fullfile(exppath,'/results/U'),nIters);         
vvel = rdmdsWrapper(fullfile(exppath,'/results/V'),nIters);
siheff = rdmdsWrapper(fullfile(exppath,'/results/SIheff'),nIters);

tt =  (dumpIters(n)-dumpIters(1))*deltaT/86400/365

% %%% Load time-mean output
% load(fullfile(proddir,[expname_tavg,'_tavg.mat']),'pp');
% eta = pp(:,:,1)/gravity;
% eta(:,1) = NaN;
% eta(:,end) = NaN;
% eta = eta - mean(eta(:,end-1));

%%% Remove topography
theta(hFacC==0) = NaN;
eta(hFacC(:,:,1)==0) = NaN;

figure(1);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 600 600]);
set(gcf,'Color','w');
[YY,XX,ZZ]=meshgrid(yy,xx,zz);
XX = XX / 1000;
YY = YY / 1000;
ZZ = ZZ / 1000;

% %%% Calculate vorticity
% ff = f0+beta*YY;
% vort = zeros(Nx,Ny,Nr);
% vort(:,1:Ny-1,:) = - (uvel(:,2:Ny,:)-uvel(:,1:Ny-1,:))/delY(1);
% vort = vort + (vvel([2:Nx 1],:,:)-vvel(:,:,:))/delX(1);
% vort(hFacS==0) = 0;
% vort(hFacW==0) = 0;
% vort(hFacC==0) = 0;
% vort(:,Ny-1,:) = 0;
% vort(:,2,:) = 0;
% vort = vort ./ abs(ff);

%%% Bathymetry
[Y,X] = meshgrid(yy,xx);  
% surf(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,bathy(:,2:end-1));
p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,bathy(:,2:end-1)/1000);
% p.FaceColor = [8*16+5 5*16+7 2*16+3]/255;
% p.FaceColor = [11*16+9 9*16+12 6*16+11]/255;
% p.FaceColor = [144 149 159]/255;
% p.FaceColor = [139 156 136]/255;
% p.FaceColor = [110 124 132]/255;
% p.FaceColor = [169 183 193]/255;
p.FaceColor = [164 176 183]/255;

p.EdgeColor = 'none';       

hold on;

% z_idx = -zz<= 100;  
% zidx = sum(z_idx);
zidx = 1;

%%% Plot SSS
p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,0*X(:,2:end-1),salt(:,2:end-1,zidx));
caxis([min(min(salt(:,2:end-1,zidx)))-0.2 max(max(salt(:,2:end-1,zidx)))+0.2]);
% caxis([33.6 34.4]);
colormap(pmkmp(28,'LinearL'));
set(p,'FaceColor','texturemap','EdgeColor','none')
alpha(p,0.8);
freezeColors;


% %%% Plot the surface relative vorticity  
% vort = zeros(Nx,Ny);
% zlev = 1;
% vort(:,2:Ny) = - (uvel(:,2:Ny,zlev)-uvel(:,1:Ny-1,zlev))/delY(1);
% vort = vort + (vvel([2:Nx 1],:,zlev)-vvel(:,:,zlev))/delX(1);
% %   ubt = sum(uvel.*DZ.*hFacW,3) ./ sum(DZ.*hFacW,3);
% %   vbt = sum(vvel.*DZ.*hFacS,3) ./ sum(DZ.*hFacS,3);
% %   vort(:,2:Ny) = - (ubt(:,2:Ny)-ubt(:,1:Ny-1))/delY(1);
% %   vort = vort + (vbt([2:Nx 1],:)-vbt(:,:))/delX(1);  
% ff = f0+beta*Y;
% p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,0*X(:,2:end-1),vort(:,2:end-1)./abs(ff(:,2:end-1)));
% caxis([-0.1 0.1]);
% colormap redblue;
% set(p,'FaceColor','texturemap','EdgeColor','none')
% alpha(p,0.8);
% freezeColors;

  

%%% Plot ocean surface current
u_surf = squeeze(uvel(:,:,zidx));
v_surf = squeeze(vvel(:,:,zidx));
svx = 17;  % Step
svy = 15;
curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:end)'/1000, ...
    u_surf(1:svx:end,1:svy:end)',v_surf(1:svx:end,1:svy:end)');
curr.Color = 'k';
curr.LineWidth = 0.9;

% %%% Plot sea ice thickness
% % p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,300*siheff(:,2:end-1,1)+zeros(size(X(:,2:end-1))),siheff(:,2:end-1,1));
% p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,300+zeros(size(X(:,2:end-1))),siheff(:,2:end-1,1));
% % caxis([0 1.2]);
% colormap('gray');
% set(p,'FaceColor','texturemap','EdgeColor','none')
% alpha(p,0.5);

% %%% Positive vorticity
% fv = isosurface(XX,YY,ZZ,vort,0.1);
% p = patch(fv);
% p.FaceColor = 'red';
% p.EdgeColor = 'none';
% alpha(p,0.5);
% 
% %%% Negative vorticity
% fv = isosurface(XX,YY,ZZ,vort,-0.1);
% p = patch(fv);
% p.FaceColor = 'blue';
% p.EdgeColor = 'none';
% alpha(p,0.5);

%%% Isopycnal
fv = isosurface(XX(:,2:end-1,:),YY(:,2:end-1,:),ZZ(:,2:end-1,:),theta(:,2:end-1,:),theta_plot);
p = patch(fv);
% p.FaceColor = 'blue';
% p.FaceColor = [79 66 181]/255;
p.FaceColor = [87 151 246]/255;
% p.FaceColor = [90 144 252]/255;
p.EdgeColor = 'none';
alpha(p,0.5);


% %%% Surface streamlines
% eta_cntrs = [-1 -0.8 -0.6 -0.4 -0.2 0 0.2 0.4];
% contour(XX(:,:,1),YY(:,:,1),eta,eta_cntrs,'EdgeColor',[0.3 0.3 0.3],'LineWidth',1.5);

hold off;

%%% Decorations
view(50,38);
axis tight;
xlabel('x (km)','interpreter','latex');
ylabel('y (km)','interpreter','latex');
zlabel('z (m)','interpreter','latex');
set(gca,'XLim',[-200 200]);
set(gca,'XTick',[-200:100:200]);
set(gca,'YLim',[0 450]);
set(gca,'YTick',[0:100:450]);
set(gca,'ZLim',[-4 0]);
set(gca,'ZTick',[-4:2:0]);
set(gca,'FontSize',fontsize);
pbaspect([Lx/Ly 1 0.75]);
set(gca,'Position',[ 0.082   0.1100    0.8850    0.8150]);
handle = colorbar;
% set(handle,'Position',[0.9337 0.1100 0.02 0.8150]);
set(handle,'Position',[0.9199    0.6983    0.0201    0.2117]);
% annotation('textbox',[0.01 0.05 0.05 0.01],'String',figlabel,'FontSize',fontsize+2,'LineStyle','None','interpreter','latex');
annotation('textbox',[0.73 0.9 0.15 0.01],'String',{'Surface';'salinity';'(psu)'},'FontSize',fontsize,'LineStyle','None','interpreter','latex');
annotation('textbox',[0.73 0.6 0.15 0.01],'String',{'$0^\circ$C isotherm'},'FontSize',fontsize,'LineStyle','None','interpreter','latex');
camlight('headlight');
lightangle(50,38);
lighting gouraud;

% saveas(gcf,[exppath '/img/3Dsnapshot_freshshelf_ref.png']);
% saveas(gcf,[exppath '/img/3Dsnapshot_freshshelf_ref.fig']);
