%%% calcTidalEddyMeanTAUio.m 
%%% Decompose ice-ocean stress temporally into mean, eddy, tidal advection

expdir = '/data/MITgcm_ASF-csi/experiments/';
% expname = 'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2-daily';
expname = 'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25-daily'  % Nlayers=47
% expname = 'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25-daily'   % Nlayers=53

exppath = [expdir expname];

loadexp;

%%% load the data
load([exppath  '/tavg_5yrs16-20_TAUio.mat'],'SIuice','SIvice','oceTAUX');
load([exppath '/' expname '_tavg_5yrs16-20_momAdvec.mat'],'UVEL','VVEL');



rho0 = 1027;
Cio = 5.5399/1000; % SEAICE_waterDrag water-ice drag coefficient 

%%% Grid spacing matrices
DX_xy = repmat(delX',[1 Ny]);
DY_xy = repmat(delY,[Nx 1]);


%%% Total , 5-yr average
ui_5yr = SIuice(:,:,1);
vi_5yr = SIvice(:,:,1);
uo_5yr = UVEL(:,:,1);
vo_5yr = VVEL(:,:,1);
tauio_5yr = oceTAUX(:,:,1);

figure(1)
pcolor(tauio_5yr)
shading interp
colorbar
colormap redblue
caxis([-0.3 0.3])

%%% Mean component
tauio_mean = rho0*Cio ...
    .*sqrt((ui_5yr-uo_5yr).^2+(vi_5yr-vo_5yr).^2)...
    .*(ui_5yr-uo_5yr);

figure(2)
pcolor(tauio_mean)
shading interp
colorbar
colormap redblue
caxis([-0.3 0.3])


%%

dumpFreq = diag_frequency(10)
nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);
navg = num2str(dumpIters,'%010d');

sum_tauio_t = zeros(Nx,Ny);
  
for nI = 1:size(dumpIters,2)
    Ntime = navg(nI*10-9:nI*10);
    UO_daily = rdmds([exppath,'/results/UVEL.' Ntime]); % Daily-averaged data
    VO_daily = rdmds([exppath,'/results/VVEL.' Ntime]); 
    UI_daily = rdmds([exppath,'/results/SIuice.' Ntime]); 
    VI_daily = rdmds([exppath,'/results/SIvice.' Ntime]);
    uo_daily = UO_daily(:,:,1);
    vo_daily = VO_daily(:,:,1);
    ui_daily = UI_daily(:,:,1);
    vi_daily = VI_daily(:,:,1);
    
    %%%%% Double check!!!
    vo_daily = (vo_daily+ vo_daily([2:Nx 1],:))/2; % c-grid location: vorticity
    vo_daily(:,2:Ny) = (vo_daily(:,1:Ny-1)+vo_daily(:,2:Ny))/2; % c-grid location: u
    vo_daily(:,1)=vo_daily(:,1);   
    
    vi_daily = (vi_daily+ vi_daily([2:Nx 1],:))/2; % c-grid location: vorticity
    vi_daily(:,2:Ny) = (vi_daily(:,1:Ny-1)+vi_daily(:,2:Ny))/2; % c-grid location: u
    vi_daily(:,1)=vi_daily(:,1);   
 
    tauio_daily = rho0*Cio ...
    .*sqrt((ui_daily-uo_daily).^2+(vi_daily-vo_daily).^2)...
    .*(ui_daily-uo_daily);    % c-grid location: u

    sum_tauio_t = sum_tauio_t + tauio_daily;

end

tauio_t = sum_tauio_t/size(dumpIters,2);

%%% Eddy component
tauio_eddy = tauio_t-tauio_mean;

%%% Tidal component
tauio_tidal = tauio_5yr - tauio_t;


tauio_5yr_xint = sum(tauio_5yr.*DX_xy,1);
tauio_mean_xint = sum(tauio_mean.*DX_xy,1);
tauio_eddy_xint = sum(tauio_eddy.*DX_xy,1);
tauio_tidal_xint = sum(tauio_tidal.*DX_xy,1);
tauio_t_xint = sum(tauio_t.*DX_xy,1);

%%% Store computed data for later
save([exppath '/calcTidalEddyMeanTAUio.mat'],'xx','yy',...
    'tauio_5yr','tauio_mean','tauio_eddy','tauio_tidal','tauio_t',...
    'tauio_5yr_xint','tauio_mean_xint','tauio_eddy_xint','tauio_tidal_xint','tauio_t_xint');

%%
figure(3)
pcolor(tauio_tidal)
shading interp
colorbar
colormap redblue
caxis([-0.3 0.3])

figure(4)
pcolor(tauio_eddy)
shading interp
colorbar
colormap redblue
caxis([-0.3 0.3])


figure(10)
ltot = plot(yy,tauio_5yr_xint);
hold on;
lmean = plot(yy,tauio_mean_xint);
leddy = plot(yy,tauio_eddy_xint);
ltidal = plot(yy,tauio_tidal_xint);
plot(yy,tauio_t_xint,':');
hold off;
leg3 = legend([ltot,ltidal,leddy,lmean],...
    'Total ocean adv.','Tidal component','Eddy component','Mean component',...
    'FontSize', 12,'interpreter','latex'); 



