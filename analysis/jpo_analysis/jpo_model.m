%%%
%%% jpo_model.m
%%%
%%% Plots a schematic of the model setup, plus reminders of the model state
%%%
clear all;close all;

%%% Plotting options
fontsize = 11;

%%% Initialize figure
figure(1);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.01*scrsz(3) 0.3*scrsz(4) 1200 460]);
set(gcf,'Color','w');
boxcolor = [164 176 183]/255; %[0.85 0.85 0.85]

%%% Select potential temperature surface
theta_plot = 0;


%%% Select simulation
addpath /data/MITgcm_ASF-csi/newexp/analysis;
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps;
expdir = '/home/csi/MITgcm_ASF-experiments';
% expname = 'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2';
expname = 'fresh02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25';

%%% Read experiment data
expname_tavg = expname;
loadexp;
%%% Load reference experiment
% load([exppath '/' expname '_tavg_5yrs.mat'],'THETA');
% load([exppath '/' expname '_variables.mat']);

%%% Vertical grid spacing matrix
DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
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
n = 21;  
nIters = dumpIters(n);

%%% Read snapshot
theta = rdmdsWrapper(fullfile(exppath,'/results/T'),nIters);    
salt = rdmdsWrapper(fullfile(exppath,'/results/S'),nIters);    
uvel = rdmdsWrapper(fullfile(exppath,'/results/U'),nIters);         
vvel = rdmdsWrapper(fullfile(exppath,'/results/V'),nIters);
siheff = rdmdsWrapper(fullfile(exppath,'/results/SIheff'),nIters);
tt =  (dumpIters(n)-dumpIters(1))*deltaT/86400/365;
%%% Remove topography
theta(hFacC==0) = NaN;
eta(hFacC(:,:,1)==0) = NaN;


tData_north = [-1.8700000	-1.4300519	-0.72786897	0.088539958	0.65426934	0.87777859	0.89122570	0.82607663	0.74470133	0.66434163	0.59174848	0.52290857	0.46210071	0.39260948	0.31665832	0.24166667	0.16984521	0.096355587	0.018446825	-0.051488247	-0.11894432	-0.17399499	-0.22661416	-0.27899861	-0.32964569	-0.37692049	-0.41908798	-0.45434195	-0.48082912	-0.49666849];
sData_north = [34.173645	34.334579	34.485798	34.602421	34.668755	34.693745	34.698647	34.698074	34.696529	34.694572	34.692757	34.691246	34.689335	34.686584	34.683395	34.680882	34.677929	34.675270	34.672562	34.670158	34.667984	34.666473	34.665230	34.664070	34.663013	34.662083	34.661297	34.660679	34.660252	34.660030];
tData_south_fresh = [-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000];
tData_south_dense = [-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000];
sData_south0 = 33.*ones(1,10);
sData_south1 = 33.59.*ones(1,10);
sData_south_fresh = [34.173645	34.173645	34.173645	34.173645   34.173645	34.173645	34.173645	34.173645	34.173645	34.173645];
sData_south_dense = [34.173645	34.190022	34.207546	34.226440	34.246944	34.269344	34.293945	34.321087	34.351124	34.384430];
sData_south3 = [34.1766777038574	34.3213920593262	34.4370384216309	34.5008010864258	34.5258445739746	34.5366058349609	34.5464744567871	34.5585098266602	34.5715942382813	34.5848999023438];
sData_south4 = [34.173645	34.205608	34.239815	34.276688	34.316711	34.360428	34.408447	34.461418	34.520046	34.585052];
sData_south5 = [34.173645	34.221588	34.272900	34.328209	34.388245	34.453823	34.525845	34.605305	34.693249	34.790756];


zData = zz;
%%% Bottom topography
hb = -bathy(1,:);

g_mean = squeeze(nanmean(theta(:,:,:)));
BATHY = g_mean;
idx_bathy = isnan(g_mean);
% g_mean(idx_bathy) = NaN;



%% 

[YY,XX,ZZ]=meshgrid(yy,xx,zz);
XX = XX / 1000;
YY = YY / 1000;
ZZ = ZZ / 1000;


clf;
%%% Plotting options
ax1 = subplot('position',[0.06 0.01 0.35 0.95]);
annotation('textbox',[0.06 0.2 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize,'LineStyle','None');

%%% Bathymetry
[Y,X] = meshgrid(yy,xx);  
p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,bathy(:,2:end-1)/1000);
p.FaceColor = [164 176 183]/255;
p.EdgeColor = 'none';       
hold on;
zidx = 1;

%%% Plot SSS
p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,0*X(:,2:end-1),salt(:,2:end-1,zidx));
caxis([min(min(salt(:,2:end-1,zidx)))-0.2 max(max(salt(:,2:end-1,zidx)))+0.2]);
% caxis([33.6 34.4]);
colormap(pmkmp(28,'LinearL'));
set(p,'FaceColor','texturemap','EdgeColor','none')
alpha(p,0.8);
freezeColors;


%%% Plot ocean surface current
u_surf = squeeze(uvel(:,:,zidx));
v_surf = squeeze(vvel(:,:,zidx));
svx = 17;  % Step
svy = 15;
curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:end)'/1000, ...
    u_surf(1:svx:end,1:svy:end)',v_surf(1:svx:end,1:svy:end)');
curr.Color = 'k';
curr.LineWidth = 0.9;

%%% Isopycnal
fv = isosurface(XX(:,2:end-1,:),YY(:,2:end-1,:),ZZ(:,2:end-1,:),theta(:,2:end-1,:),theta_plot);
p = patch(fv);
p.FaceColor = [87 151 246]/255;
p.EdgeColor = 'none';
alpha(p,0.5);
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
set(gca,'TickDir','out','TickLength',[0.01 0.02]);
pbaspect([Lx/Ly 1 0.75]);
handle = colorbar;
set(handle,'Position',[0.03    0.65    0.01    0.2117]);
annotation('textbox',[0.038 0.88 0.15 0.01],'String',{'Surface';'salinity';'(psu)'},'FontSize',fontsize,'LineStyle','None','interpreter','latex');
annotation('textbox',[0.28 0.55 0.15 0.01],'String',{'$0^\circ$C isotherm'},'FontSize',fontsize,'LineStyle','None','interpreter','latex');
camlight('headlight');
lightangle(50,38);
lighting gouraud;
view(ax1,120,17.3)



%%
clear ZZ YY;
[ZZ,YY] = meshgrid(zz,yy);
for j=1:Ny
  hFacC_col = squeeze(hFacC(1,j,:));  
  kmax = length(hFacC_col(hFacC_col>0));  
  zz_botface = -sum(hFacC_col.*delR');
  ZZ(j,1) = 0;
  if (kmax>0)
    ZZ(j,kmax) = zz_botface;
  end
end
 
expname = 'fresh02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25';
loadexp;
%%% Load reference experiment
load([exppath '/' expname '_tavg_5yrs.mat'],'THETA','SIheff');
load([exppath '/' expname '_variables.mat'],'zonalWind','meridionalWind');

%% Plot isopycnals and topography
ax2 = subplot('position',[0.5 0.1 0.32 0.55]);
annotation('textbox',[0.495 0.7 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize,'LineStyle','None');

% caxis([33.3 34.75]); % fresh shelf
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps/customcolormap
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});

theta0=THETA;
theta0(idx_bathy) = NaN;
theta=squeeze(nanmean(theta0,1));
theta(idx_bathy) = NaN;
pcolor(yy/1000,-zz/1000,theta');shading interp;axis ij;
colormap(ax2,mycolormap);
set(gca,'clim',[-1.88 1.88]);
set(gca,'color',boxcolor);

hold on;
text0 = text(300,2.5,'$\theta\ (^\circ C)$','FontSize',fontsize,'interpreter','latex','color','k');

[C,h]=contour(YY/1000,-ZZ/1000,g_mean,[-1.4 0 0.7],'EdgeColor','k','LineStyle','--');
clabel(C,h,'Color','k','FontSize',fontsize,'LabelSpacing',190);
plot(yy/1000,-bathy(1,:)/1000,'k-.','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
line([430 430],[0 4],'Color','w','LineStyle',':','LineWidth',2);
line([20 20],[0 0.5],'Color','w','LineStyle',':','LineWidth',2);
text(440,0.75,'RESTORING','FontSize',fontsize+1,'Rotation',270,'Color','k');
hold off;
xlabel('Offshore distance, y (km)','FontSize',fontsize,'interpreter','latex');
ylabel('Depth (km)','FontSize',fontsize,'interpreter','latex');
set(gca,'FontSize',fontsize);
set(gca,'YDir','reverse');


%% Sea ice and fluxes
% subplot('position',[0.15+.5/9 0.83 0.5-.5/9 0.02]);
% subplot('position',[0.15 0.8035 0.5 0.02]);
ax3 = subplot('position',[0.5 0.66 0.32 0.05]);
area(yy/1000,squeeze(nanmean(SIheff(:,:,1))),'FaceColor',[225 225 225]/255);
hold on
line([430 430]+1,[0 1],'Color','w','LineStyle',':','LineWidth',2);
line([20 20]-1,[0 1],'Color','w','LineStyle',':','LineWidth',2);
text(225,0.45,'Sea ice','FontSize',fontsize+1,'interpreter','latex');

box off;
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca,'Visible','off')

hold off
annotation('arrow',[0.472 0.498],[0.68 0.68],'LineWidth',1.5,'LineStyle','-','HeadStyle','cback3','color',[128 128 128]/255);
annotation('textbox',[0.43 0.677 0.2 0.05],'String',{'Prescribed';'inflow'},'interpreter','latex','FontSize',fontsize,'LineStyle','None');

%% Plot wind stress
ax4 = subplot('position',[0.5 0.8 0.32 0.15]);
annotation('textbox',[0.495 0.945 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize,'LineStyle','None');

plot(yy/1000,zonalWind(1,:));
hold on;
plot(yy/1000,meridionalWind(1,:));
hold off;
set(gca,'XLim',[0 450]);
set(gca,'FontSize',fontsize);
ylabel({'Wind';'stress';'(N/m$^2$)'},'FontSize',fontsize,'interpreter','latex','Rotation',0);
set(get(gca,'ylabel'),'Position',get(get(gca,'ylabel'),'Position')-[20 0.05 0]);
text1 = text(200,-0.06,'Zonal wind','FontSize',fontsize,'interpreter','latex','color',[0    0.4470    0.7410],'LineWidth',1.5);
text2 = text(200,0.06,'Meridional wind','FontSize',fontsize,'interpreter','latex','color',[0.8500    0.3250    0.0980],'LineWidth',1.5);


%% Relaxation profiles
ax51 = subplot('position',[0.85 0.1 0.14 0.55]);
annotation('textbox',[0.83 0.705 0.05 0.05],'String','(d)','interpreter','latex','FontSize',fontsize,'LineStyle','None');
plot(ax51,tData_north,-zData/1000,'Color',[0    0.4470    0.7410],'LineWidth',1.5);
hold on;
plot(ax51,tData_south_fresh,-zData(1:10)/1000,'-.','Color',[0    0.4470    0.7410],'LineWidth',1.5);
hold off;
ax52 = axes('Position',get(ax51,'Position'));
plot(ax52,sData_north,-zData/1000,'Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
% BreakXAxis(ax52,sData_north,-zData/1000,34.2,34.6,1)
hold on;
plot(ax52,sData_south_fresh,-zData(1:10)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
plot(ax52,sData_south_dense,-zData(1:10)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
plot(ax52,sData_south0,-zData(1:10)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
plot(ax52,sData_south1,-zData(1:10)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
% plot(ax52,sData_south3,-zData(1:10)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
plot(ax52,sData_south4,-zData(1:10)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
plot(ax52,sData_south5,-zData(1:10)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
hold off;
text3 = text(ax52,34.51,3,{'Northern';'boundary'},'FontSize',fontsize,'interpreter','latex','color','k');
text4 = text(ax52,34.12,0.8,{'Southern';'boundary'},'FontSize',fontsize,'interpreter','latex','color','k');
set(ax51,'YDir','reverse');
set(ax52,'YDir','reverse');
set(ax51,'XAxisLocation','Bottom');
set(ax52,'XAxisLocation','Top');
set(ax51,'YAxisLocation','Left')
set(ax52,'YAxisLocation','Right');
set(ax51,'XColor',[0    0.4470    0.7410]); 
set(ax52,'XColor',[0.8500    0.3250    0.0980]);
set(ax52,'YTick',[]);
set(ax51,'XLim',[-2.99 1]);
set(ax52,'XTick',[33 34.2 34.6]);
set(ax52,'XLim',[32.9 34.9]);
set(ax51,'YColor','k');
set(ax52,'YColor','k');
set(ax51,'FontSize',fontsize);
set(ax52,'FontSize',fontsize);
set(get(ax51,'XLabel'),'String','Potential temperature ($^\circ$C)','interpreter','latex','FontSize',fontsize);
set(get(ax52,'XLabel'),'String','Salinity (psu)','interpreter','latex','FontSize',fontsize);
set(ax52,'Color','none');
set(ax51,'Box','off');
set(ax52,'Box','off');
breakxaxis([33.05 34.05],0.01);
% breakxaxis([33.05 33.55],0.005);
% breakxaxis([33.6 34.15],0.005);
annotation('line',[0.85 0.99],[0.1 0.1],'LineWidth',1,'LineStyle','-','color',[0    0.4470    0.7410]);



%%
saveas(gcf,'jpo_model','epsc');
saveas(gcf,'jpo_model.png');

