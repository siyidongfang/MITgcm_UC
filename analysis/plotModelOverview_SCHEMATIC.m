%%%
%%% plotModelOverview_SCHEMATIC.m
%%%
%%% Plots a schematic of the model setup, plus reminders of the model state
%%% and overturning circulation
%%%
addpath /Users/csi/MITgcm_ASF-csi/newexp/analysis

%%% Plotting options
fontsize = 15;

%%% Initialize figure
figure(2);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 900 765]);
set(gcf,'Color','w');

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% SCHEMATIC PANEL %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Load reference experiment
expname = 'fresh02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25';
expdir = '/Users/csi/MITgcm_ASF-csi/newexp';
loadexp;

load([exppath '/' expname '_tavg_5yrs.mat']);
% load([exppath '/' expname '_MOC_pt.mat']);
load([exppath '/' expname '_variables.mat']);
% load([exppath '/setParams.mat']);

tData_north = [-1.8700000	-1.4300519	-0.72786897	0.088539958	0.65426934	0.87777859	0.89122570	0.82607663	0.74470133	0.66434163	0.59174848	0.52290857	0.46210071	0.39260948	0.31665832	0.24166667	0.16984521	0.096355587	0.018446825	-0.051488247	-0.11894432	-0.17399499	-0.22661416	-0.27899861	-0.32964569	-0.37692049	-0.41908798	-0.45434195	-0.48082912	-0.49666849];
sData_north = [34.173645	34.334579	34.485798	34.602421	34.668755	34.693745	34.698647	34.698074	34.696529	34.694572	34.692757	34.691246	34.689335	34.686584	34.683395	34.680882	34.677929	34.675270	34.672562	34.670158	34.667984	34.666473	34.665230	34.664070	34.663013	34.662083	34.661297	34.660679	34.660252	34.660030];

tData_south_fresh = [-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000];
tData_south_dense = [-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000	-1.8700000];

sData_south0 = 33.*ones(1,10);
sData_south_fresh = [34.173645	34.173645	34.173645	34.173645   34.173645	34.173645	34.173645	34.173645	34.173645	34.173645];
sData_south_dense = [34.173645	34.190022	34.207546	34.226440	34.246944	34.269344	34.293945	34.321087	34.351124	34.384430];
sData_south3 = [34.1766777038574	34.3213920593262	34.4370384216309	34.5008010864258	34.5258445739746	34.5366058349609	34.5464744567871	34.5585098266602	34.5715942382813	34.5848999023438];
sData_south4 = [34.173645	34.205608	34.239815	34.276688	34.316711	34.360428	34.408447	34.461418	34.520046	34.585052];
sData_south5 = [34.173645	34.221588	34.272900	34.328209	34.388245	34.453823	34.525845	34.605305	34.693249	34.790756];

zData = zz;
%%% Bottom topography
hb = -bathy(1,:);

%%% Create mesh grid with vertical positions adjusted to sit on the bottom
%%% topography and at the surface
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

% %%% Remove topography
% tt_plot = tt_avg;
% tt_plot(tt_plot==0) = NaN;
 
g_mean = squeeze(nanmean(THETA(:,:,:)));
BATHY = g_mean;
idx_bathy = (g_mean==0);
g_mean(idx_bathy) = NaN;

%%% Plot isopycnals and topography
ax1 = subplot('position',[0.15 0.5 0.5 0.3]);
% [C,h]=contourf(YY/1000,-ZZ/1000,g_mean,[-1.8 0 0.5],'EdgeColor','k');
% clabel(C,h,'Color','k','FontSize',fontsize,'LabelSpacing',190);
% colormap(ax1,[[.3 .3 1];[1 .3 .3];[0.23 0.66 1]]);
caxis([33.3 34.75]); % fresh shelf
addpath /Users/csi/MITgcm_ASF-csi/newexp/analysis/colormaps/customcolormap
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});

theta0=THETA;
theta0(idx_bathy) = NaN;
theta=squeeze(nanmean(theta0,1));
theta(idx_bathy) = NaN;
pcolor(yy/1000,-zz/1000,theta');shading interp;axis ij;colormap(mycolormap);
set(gca,'clim',[-1.88 1.88]);

hold on;
% contour(yy/1000,-zz,theta','LineColor','w');
text0 = text(300,2.5,'$\theta\ (^\circ C)$','FontSize',fontsize,'interpreter','latex','color','k');

[C,h]=contour(YY/1000,-ZZ/1000,g_mean,[-1.4 0 0.7],'EdgeColor','k','LineStyle','--');
clabel(C,h,'Color','k','FontSize',fontsize,'LabelSpacing',190);
% plot(yy/1000,hb/1000,'k','LineWidth',2);  
plot(yy/1000,-bathy(1,:)/1000,'k-.','LineWidth',2);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2);
line([430 430],[0 4],'Color','w','LineStyle',':','LineWidth',2);
line([20 20],[0 0.5],'Color','w','LineStyle',':','LineWidth',2);
text(440,0.75,'RESTORING','FontSize',fontsize+2,'Rotation',270,'Color','k');
hold off;
xlabel('Offshore distance (km)','FontSize',fontsize,'interpreter','latex');
ylabel('Depth (km)','FontSize',fontsize,'interpreter','latex');
set(gca,'FontSize',fontsize);
set(gca,'YDir','reverse');
% annotation('textbox',[0.05 0.45 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
% 
% %%% Water masses
% text(250,1.5,'CDW','FontSize',fontsize,'interpreter','latex','Color','w');
% text(300,2.8,'AABW','FontSize',fontsize,'interpreter','latex','Color','w');
% text(150,0.25,'AASW','FontSize',fontsize,'interpreter','latex','Color','w');

%%% Plot wind stress
subplot('position',[0.15 0.9 0.5 0.08]);
plot(yy/1000,zonalWind(1,:));
hold on;
plot(yy/1000,meridionalWind(1,:));
% plot([225 225],[-0.1 0],'k--','LineWidth',0.5);
% plot([50 50],[-0.1 0],'k--','LineWidth',0.5);
hold off;
set(gca,'XLim',[0 450]);
set(gca,'FontSize',fontsize);
ylabel({'Wind';'stress';'(N/m$^2$)'},'FontSize',fontsize,'interpreter','latex','Rotation',0);
set(get(gca,'ylabel'),'Position',get(get(gca,'ylabel'),'Position')-[20 0.05 0]);
% text(230,-0.04,'$y=Y_w$','FontSize',fontsize,'interpreter','latex');
% text(55,-0.08,'$y=L_p$','FontSize',fontsize,'interpreter','latex');
text1 = text(200,-0.06,'Zonal wind','FontSize',fontsize,'interpreter','latex','color',[0    0.4470    0.7410],'LineWidth',1.5);
text2 = text(200,0.06,'Meridional wind','FontSize',fontsize,'interpreter','latex','color',[0.8500    0.3250    0.0980],'LineWidth',1.5);

%%% Relaxation profiles
ax2 = subplot('position',[0.7 0.5 0.15 0.3]);
plot(ax2,tData_north,-zData/1000,'Color',[0    0.4470    0.7410],'LineWidth',1.5);
hold on;
plot(ax2,tData_south_fresh,-zData(1:10)/1000,'-.','Color',[0    0.4470    0.7410],'LineWidth',1.5);
% plot(ax2,tData_south_dense,-zData(1:10)/1000,'*','Color',[0    0.4470    0.7410],'LineWidth',0.5);
hold off;
ax3 = axes('Position',get(ax2,'Position'));
plot(ax3,sData_north,-zData/1000,'Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
hold on;
plot(ax3,sData_south_fresh,-zData(1:10)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
plot(ax3,sData_south_dense,-zData(1:10)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
plot(ax3,sData_south0,-zData(1:10)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
% plot(ax3,sData_south3,-zData(1:10)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
plot(ax3,sData_south4,-zData(1:10)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
plot(ax3,sData_south5,-zData(1:10)/1000,'-.','Color',[ 0.8500    0.3250    0.0980],'LineWidth',1.5);
hold off;
text3 = text(34.46,3,{'Northern';'boundary'},'FontSize',fontsize,'interpreter','latex','color','k');
text4 = text(34.12,0.7,{'Shelf'},'FontSize',fontsize,'interpreter','latex','color','k');
% text4 = text(34.12,0.8,{'Fresh';'shelf'},'FontSize',fontsize,'interpreter','latex','color',[0.8500    0.3250    0.0980]);
% text5 = text(34.34,0.82,{'Dense';'shelf'},'FontSize',fontsize,'interpreter','latex','color',[0.8500    0.3250    0.0980]);
set(ax2,'YDir','reverse');
set(ax3,'YDir','reverse');
set(ax2,'XAxisLocation','Bottom');
set(ax3,'XAxisLocation','Top');
set(ax2,'YAxisLocation','Left')
set(ax3,'YAxisLocation','Right');
set(ax2,'XColor',[0    0.4470    0.7410]); 
set(ax3,'XColor',[0.8500    0.3250    0.0980]);
set(ax3,'YTick',[]);
set(ax2,'XLim',[min(tData_north)-1 max(tData_north)+0.2]);
% set(ax3,'XLim',[min(sData_south_fresh)-0.1 max(sData_south5)]);
set(ax3,'XTick',[33 34.2 34.6]);
set(ax3,'XLim',[33-0.04 max(sData_south5)]);
set(ax2,'YColor','k');
set(ax3,'YColor','k');
set(ax2,'FontSize',fontsize);
set(ax3,'FontSize',fontsize);
set(get(ax2,'XLabel'),'String','Potential temperature ($^\circ$C)','interpreter','latex','FontSize',fontsize);
set(get(ax3,'XLabel'),'String','Salinity (psu)','interpreter','latex','FontSize',fontsize);
set(ax3,'Color','none');
set(ax2,'Box','off');
set(ax3,'Box','off');
breakxaxis([33.05 34.05]);



%%% Sea ice and fluxes
% subplot('position',[0.15+.5/9 0.83 0.5-.5/9 0.02]);
subplot('position',[0.15 0.8035 0.5 0.02]);
area(yy/1000,squeeze(nanmean(SIheff(:,:,1))),'FaceColor',[192 192 192]/255);
hold on
line([430 430]+1,[0 1],'Color','w','LineStyle',':','LineWidth',2);
line([20 20]-1,[0 1],'Color','w','LineStyle',':','LineWidth',2);
text(225,0.45,'Sea ice','FontSize',fontsize+1,'interpreter','latex');

box off;
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca,'Visible','off')
% set(gca,'Color',[0.8 0.8 0.8]);
% axis([0 1 0 1]);
hold off
% annotation('doublearrow',[0.225 0.225],[0.83 0.8],'LineWidth',1,'LineStyle',':','HeadStyle','vback3');
% annotation('doublearrow',[0.325 0.325],[0.83 0.8],'LineWidth',1,'LineStyle',':','HeadStyle','vback3');
% annotation('doublearrow',[0.425 0.425],[0.83 0.8],'LineWidth',1,'LineStyle',':','HeadStyle','vback3');
% annotation('doublearrow',[0.525 0.525],[0.83 0.8],'LineWidth',1,'LineStyle',':','HeadStyle','vback3');
% annotation('doublearrow',[0.625 0.625],[0.83 0.8],'LineWidth',1,'LineStyle',':','HeadStyle','vback3');

%%% Indicate salt flux
% annotation('arrow',[0.16 0.16],[0.83 0.8],'LineWidth',1,'LineStyle',':','HeadStyle','vback3');
% annotation('arrow',[0.175 0.175],[0.83 0.8],'LineWidth',1,'LineStyle',':','HeadStyle','vback3');
% annotation('arrow',[0.19 0.19],[0.83 0.8],'LineWidth',1,'LineStyle',':','HeadStyle','vback3');
% annotation('textbox',[0.05 0.8 0.2 0.05],'String','Fixed salt flux','interpreter','latex','FontSize',fontsize,'LineStyle','None');
annotation('arrow',[0.115 0.145],[0.815 0.815],'LineWidth',1.5,'LineStyle','-','HeadStyle','cback3','color',[128 128 128]/255);
annotation('textbox',[0.04 0.795 0.2 0.05],'String',{'Prescribed';'inflow'},'interpreter','latex','FontSize',fontsize,'LineStyle','None');




saveas(gcf,[expdir '/data_poster/SCHEMATIC.png']);
saveas(gcf,[expdir '/data_poster/SCHEMATIC.fig']);







