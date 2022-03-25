
clear all;close all;

%%% Load EOS utilities
addpath /data/Software/gsw_matlab_v3_06_11/thermodynamics_from_t/;
addpath /data/Software/gsw_matlab_v3_06_11/library/;
addpath /data/Software/gsw_matlab_v3_06_11/;
  
%%% Select simulation
addpath /data/MITgcm_ASF-csi/analysis;
addpath /data/MITgcm_ASF-csi/analysis/colormaps;
expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments/';
expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis';
prodir = '/data/MITgcm_ASF-csi/products-hires';

%%% Read experiment data
expname_tavg = expname;
loadexp;
load([prodir '/' expname '_tavg_5yrs.mat'],'THETA','SALT','PHIHYD');
load([expdir expname '/input/setParams.mat'],'sNorth','tNorth')
drf = squeeze(rdmds([exppath,'/results/DRF']))';
drc = squeeze(rdmds([exppath,'/results/DRC']))';

%%% Vertical grid spacing matrix
DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]); 
depth = repmat(reshape(-zz,[1 1 Nr]),[Nx Ny 1]); 
depth_2D = repmat(reshape(-zz,[1 Nr]),[Nx 1]); 

%%% Diagnostic indix corresponding to instantaneous velocity
diagnum = length(diag_frequency);
%%% This needs to be set to ensure we are using the correct output frequency
diagfreq = diag_frequency(diagnum);
%%% Frequency of diagnostic output
dumpFreq = abs(diagfreq);
nDumps = round(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters >= nIter0);
nDumps = length(dumpIters);
nIters = 1166400

%%% Read snapshot
theta_inst = rdmdsWrapper(fullfile(exppath,'/results/T'),nIters);    
salt_inst = rdmdsWrapper(fullfile(exppath,'/results/S'),nIters);    
p_inst = repmat(reshape(-zz,[1 1 Nr]),[Nx Ny 1]) + rdmdsWrapper(fullfile(exppath,'/results/PH'),nIters)./1e4;    

g=gravity;
rho0=999.8;


%%
figure(1)








%% 

figure(2)
subplot(2,4,1)
expname  = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis_new80s'
loadexp;
nIter =466560
bb = rdmds([exppath,'/results/oceFWflx'],nIter);
pcolor(xx/1000,yy/1000,bb')
shading interp;colormap('redblue');colorbar
ylim([400 450])
caxis([-6 6]/1e4)
ylabel('y (km)')
xlabel('x (km)')
title([{'High res: 135-day mean (kg/m^2/s)'}, {'net surface fresh-Water flux into the ocean'}])


subplot(2,4,2)
bb = rdmds([exppath,'/results/oceSflux'],nIter);
pcolor(xx/1000,yy/1000,bb')
shading interp;colormap('redblue');colorbar
ylim([400 450])
caxis([-0.025 0.025])
ylabel('y (km)')
xlabel('x (km)')
title([{'High res: 135-day mean (g/m^2/s)'}, {'net surface salt flux into the ocean'}])


subplot(2,4,3)
bb = rdmds([exppath,'/results/oceQnet'],nIter);
pcolor(xx/1000,yy/1000,bb')
shading interp;colormap('redblue');colorbar
ylim([400 450])
caxis([-30 30])
ylabel('y (km)')
xlabel('x (km)')
title([{'High res: 135-day mean (W/m^2)'}, {'net surface heat flux into the ocean'}])

subplot(2,4,4)
nIter =513000
bb = rdmds([exppath,'/results/SIheff'],nIter);
pcolor(xx/1000,yy/1000,bb')
shading interp;colormap('redblue');colorbar
ylim([400 450])
caxis([0 1])
ylabel('y (km)')
xlabel('x (km)')
title([{'High res: daily mean (m)'}, {'ice thickness'}])


expname  = 'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2'
loadexp;
nIter =1695484
subplot(2,4,5)
bb = rdmds([exppath,'/results/oceFWflx'],nIter);
pcolor(xx/1000,yy/1000,bb')
shading interp;colormap('redblue');colorbar
ylim([400 450])
caxis([-6 6]/1e4)
ylabel('y (km)')
xlabel('x (km)')
title([{'Low res: annual mean (kg/m^2/s)'}, {'net surface fresh-Water flux into the ocean'}])



subplot(2,4,6)
bb = rdmds([exppath,'/results/oceSflux'],nIter);
pcolor(xx/1000,yy/1000,bb')
shading interp;colormap('redblue');colorbar
ylim([400 450])
caxis([-0.025 0.025])
ylabel('y (km)')
xlabel('x (km)')
title([{'Low res: annual mean (g/m^2/s)'}, {'net surface salt flux into the ocean'}])


subplot(2,4,7)
bb = rdmds([exppath,'/results/oceQnet'],nIter);
pcolor(xx/1000,yy/1000,bb')
shading interp;colormap('redblue');colorbar
ylim([400 450])
caxis([-30 30])
ylabel('y (km)')
xlabel('x (km)')
title([{'Low res: annual mean (W/m^2)'}, {'net surface heat flux into the ocean'}])

subplot(2,4,8)
bb = rdmds([exppath,'/results/SIheff'],nIter);
pcolor(xx/1000,yy/1000,bb')
shading interp;colormap('redblue');colorbar
ylim([400 450])
caxis([0 1])
ylabel('y (km)')
xlabel('x (km)')
title([{'Low res: annual mean (m)'}, {'ice thickness'}])

%%
figure(3)
   
%%%% Using gsw_Nsquared
pp=-zz;
SA_north = gsw_SA_from_SP(sNorth,pp,-12,-64);  
CT_north = gsw_CT_from_pt(SA_north,tNorth); 
[N2_north_1, pp_mid_north] = gsw_Nsquared(SA_north,CT_north,pp,-64);
semilogx(N2_north_1,pp_mid_north,'LineWidth',1.5);axis ij;
hold on;

%%%% Using densmdjwf
for nz = 1:Nr-1
    N2_north_2(nz) = g/rho0.*(densmdjwf(sNorth(nz+1),tNorth(nz+1),0.5*(pp(nz)+pp(nz+1)))...
        -densmdjwf(sNorth(nz),tNorth(nz),0.5*(pp(nz)+pp(nz+1))))./drc(nz+1);
end

semilogx(N2_north_2,pp_mid_north,'LineWidth',1.5);axis ij;
hold off;

title('Northern boundary N^2');
legend('gsw Nsquared','densmdjwf');
xlabel('N^2 (s^-^2)');
ylabel('Depth (m)');

% saveas(gcf,['bdry_stratification/N2_ref.png']);


%% Remove topography
theta_inst(theta_inst==0) = NaN;
salt_inst(theta_inst==0) = NaN;
p_inst(theta_inst==0) = NaN;
THETA(theta_inst==0) = NaN;
SALT(theta_inst==0) = NaN;
PHIHYD(theta_inst==0) = NaN;
p = repmat(reshape(-zz,[1 1 Nr]),[Nx Ny 1]) +PHIHYD*rho0/1e4;

% % bdry_idx = Ny-19:Ny;

bdry_idx = Ny:Ny

for j=bdry_idx;
%     sNorth_inst = squeeze(salt_inst(:,j,:));
%     tNorth_inst = squeeze(theta_inst(:,j,:));
%     pNorth_inst = squeeze(p_inst(:,j,:));
%     
%     SA_north_inst = gsw_SA_from_SP(sNorth_inst,pNorth_inst,-12,-64);  
%     CT_north_inst = gsw_CT_from_pt(SA_north_inst,tNorth_inst); 
% 
%     %%% Calculate Brunt-Vaisala frequency using full EOS
%     [N2_north, pp_mid_north] = gsw_Nsquared(SA_north_inst,CT_north_inst,pNorth_inst,-64);

    sNorth_tavg = squeeze(SALT(:,j,:));
    tNorth_tavg = squeeze(THETA(:,j,:));
    pNorth_tavg = squeeze(p(:,j,:));
    
    SA_north_tavg = gsw_SA_from_SP(sNorth_tavg,pNorth_tavg,-12,-64);  
    CT_north_tavg = gsw_CT_from_pt(SA_north_tavg,tNorth_tavg); 

    %%% Calculate Brunt-Vaisala frequency using full EOS
    [N2_north, pp_mid_north] = gsw_Nsquared(SA_north_tavg,CT_north_tavg,pNorth_tavg,-64);
    
    
    figure(4)
    pcolor(xx(1:end-1)/1000,-zz,N2_north')
    shading interp
    colorbar
    colormap(redblue)
    axis ij;
    caxis([-50 50]/1e7)
    ylabel('depth (m)')
    xlabel('x (km)')
    title({['j=' num2str(j)  '  Northern boundary instantaneous'],'buoyancy frequency squared (1/s^2)'})
%     saveas(gcf,['bdry_stratification/inst_' num2str(j) '.png']);

end
