clear all;
% close all

addpath /data/MITgcm_ASF-csi/utils/matlab; 
addpath /data/MITgcm_ASF-csi/analysis;
addpath /data/MITgcm_ASF-csi/analysis/colormaps;
expdir = '/data/MITgcm_ASF-csi/experiments/';
prodir = '/data/MITgcm_ASF-csi/products-hires/';




%%% Plotting options
fontsize = 11;

%%% Initialize figure
figure(2);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 800 750]);
set(gcf,'Color','w');
legpos = [0.4 0.01 0.2 0.03];

%%% colormap
addpath /data/MITgcm_ASF-csi/analysis/colormaps
addpath /data/MITgcm_ASF-csi/analysis/colormaps/customcolormap
mycolormap = customcolormap(linspace(0,1,11), {'#68011d','#b5172f','#d75f4e','#f7a580','#fedbc9','#f5f9f3','#d5e2f0','#93c5dc','#4295c1','#2265ad','#062e61'});
blue = [0 0.4470 0.7410];
orange = [0.8500 0.3250 0.0980];
% orange = [230 45 34]/255;
yellow = [0.9290 0.6940 0.1250];
lightblue = [0.3010 0.7450 0.9330];
purple = [0.4940 0.1840 0.5560];
green = [0.4660 0.6740 0.1880];
red = [0.6350 0.0780 0.1840];
gray = [225 225 225]/255;
pink = [255 153 204]/255;
brown = [153 102 51]/255;
gray2 = [249 249 249]/255;
olive = [107 142 35]/255;

load([prodir '/MomScalingMatrix_slope_ystart125km.mat']);


position = {'shelf','slope','openocean'};
ntitle = {'Continental shelf','Continental slope','Open ocean'};


nAtide  = 1:5;
Atide = [0 0.025 0.05 0.075 0.1];
nabs_ua = 6:9;
abs_ua = [0 4 6 8]; 
nva = 10:13;
va = [4 6 8 12];
nhi0 = 14:19;
hi0  = [0.2 0.6 1 1.4 1.8 2.2];
nws = 20:24;
ws = [25 50 75 100 125];
Ys = [150 175 200 225 250];
nbuoy = 25:30;
buoy = [33 33.59 34.17 34.38 34.59 34.79]-34.17; 

%% Ice thickness

subplotsize = [0.43 0.17/1.75*2.05];

clf;

    igroup = nhi0;
    hice = hi0;
    ocnadv = pOCN_AdvCor(igroup)';
    iceinternal = pSIinternal(igroup)';
    dissp = pDissipation(igroup)';
    sicor = pSI_cor(igroup)';
    topogform = pTopogform(igroup)';
    tauoi = -pTAUoi(igroup)';
    
ax1 = subplot('position',[0.05 0.765 subplotsize]);
annotation('textbox',[0.05 0.755 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
    plot(hice,zeros(size(hice)),':','Color',gray,'LineWidth',1.5);
    hold on    

    l1 = plot(hice,ocnadv,'o-','Color',green,'LineWidth',1.5);
    scatter(hice(3),ocnadv(3),'filled','o','MarkerFaceColor',[0 0 0]);
    l2 = plot(hice,dissp,'^-','Color',purple,'LineWidth',1.5);
    scatter(hice(3),dissp(3),'filled','^','MarkerFaceColor',[0 0 0]);
    l3 = plot(hice,topogform,'v-','Color',yellow,'LineWidth',1.5);
    scatter(hice(3),topogform(3),'filled','v','MarkerFaceColor',[0 0 0]);
    l6 = plot(hice,tauoi,'d-','Color',brown,'LineWidth',1.5);
    scatter(hice(3),tauoi(3),'filled','d','MarkerFaceColor',[0 0 0]);
    
    hold off
    set(gca,'fontsize',fontsize);
%     set(gca,'xticklabel',[])
    title('Normalized ocean zonal force balance', 'FontSize', fontsize+2,'interpreter','latex'); %(normalized by zonal wind stress)
    xlabel('$ h_\mathrm{i0}\ \rm (m)$', 'FontSize', fontsize+1,'interpreter','latex');
    ylim([-1.5 1.5])
    xlim([min(hice) max(hice)])

ax2 = subplot('position',[0.55 0.765 subplotsize]);
annotation('textbox',[0.55 0.755 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
    plot(hice,zeros(size(hice)),':','Color',gray,'LineWidth',1.5);
    hold on

    l0 = plot(hice,ones(size(hice)),'o-','Color',blue,'LineWidth',1.5);
    scatter(hice(3),1,'filled','o','MarkerFaceColor',[0 0 0]);
    l4 = plot(hice,iceinternal,'s-','Color',olive,'LineWidth',1.5);
    scatter(hice(3),iceinternal(3),'filled','s','MarkerFaceColor',[0 0 0]);
    l5 = plot(hice,sicor,'^-','Color',orange,'LineWidth',1.5);
    scatter(hice(3),sicor(3),'filled','^','MarkerFaceColor',[0 0 0]);
    l6 = plot(hice,-tauoi,'d-','Color',brown,'LineWidth',1.5);
    scatter(hice(3),-tauoi(3),'filled','d','MarkerFaceColor',[0 0 0]);
    
    hold off
    set(gca,'fontsize',fontsize);
    ylim([-1.5 1.5])
    xlim([min(hice) max(hice)])
    title('Normalized sea ice zonal force balance', 'FontSize', fontsize+2,'interpreter','latex'); %(normalized by zonal wind stress)
    xlabel('$ h_\mathrm{i0}\ \rm (m)$', 'FontSize', fontsize+1,'interpreter','latex');



%% Meridional wind
    igroup = nva;
    Va = va;
    ocnadv = pOCN_AdvCor(igroup)';
    iceinternal = pSIinternal(igroup)';
    dissp = pDissipation(igroup)';
    sicor = pSI_cor(igroup)';
    topogform = pTopogform(igroup)';
    tauoi = -pTAUoi(igroup)';

ax3 = subplot('position',[0.05 0.485 subplotsize]);
annotation('textbox',[0.05 0.475 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');    
    plot(Va,zeros(size(Va)),':','Color',gray,'LineWidth',1.5);
    hold on
    
    l1 = plot(Va,ocnadv,'o-','Color',green,'LineWidth',1.5);
    scatter(Va(2),ocnadv(2),'filled','o','MarkerFaceColor',[0 0 0]);
    l2 = plot(Va,dissp,'^-','Color',purple,'LineWidth',1.5);
    scatter(Va(2),dissp(2),'filled','^','MarkerFaceColor',[0 0 0]);
    l3 = plot(Va,topogform,'v-','Color',yellow,'LineWidth',1.5);
    scatter(Va(2),topogform(2),'filled','v','MarkerFaceColor',[0 0 0]);
    l6 = plot(Va,tauoi,'d-','Color',brown,'LineWidth',1.5);
    scatter(Va(2),tauoi(2),'filled','d','MarkerFaceColor',[0 0 0]);
    
    hold off
    set(gca,'fontsize',fontsize);
    ylim([-1.5 1.5])
    xlim([min(Va) max(Va)])
    xlabel('$V_\mathrm{a0} \ \rm (m/s)$', 'FontSize', fontsize,'interpreter','latex');

ax4 = subplot('position',[0.55 0.485 subplotsize]);
annotation('textbox',[0.55 0.475 0.05 0.05],'String','(d)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
    plot(Va,zeros(size(Va)),':','Color',gray,'LineWidth',1.5);
    hold on

    l0 = plot(Va,ones(size(Va)),'o-','Color',blue,'LineWidth',1.5);
    scatter(Va(2),1,'filled','o','MarkerFaceColor',[0 0 0]);
    l4 = plot(Va,iceinternal,'s-','Color',olive,'LineWidth',1.5);
    scatter(Va(2),iceinternal(2),'filled','s','MarkerFaceColor',[0 0 0]);
    l5 = plot(Va,sicor,'^-','Color',orange,'LineWidth',1.5);
    scatter(Va(2),sicor(2),'filled','^','MarkerFaceColor',[0 0 0]);
    l6 = plot(Va,-tauoi,'d-','Color',brown,'LineWidth',1.5);
    scatter(Va(2),-tauoi(2),'filled','d','MarkerFaceColor',[0 0 0]);
    
    hold off
    set(gca,'fontsize',fontsize);
    ylim([-1.5 1.5])
    xlim([min(Va) max(Va)])
    xlabel('$V_\mathrm{a0} \ \rm (m/s)$', 'FontSize', fontsize,'interpreter','latex');

%% Zonal wind 
    igroup = nabs_ua;
    Ua = abs_ua;
    ocnadv = pOCN_AdvCor(igroup)';
    iceinternal = pSIinternal(igroup)';
    dissp = pDissipation(igroup)';
    sicor = pSI_cor(igroup)';
    topogform = pTopogform(igroup)';
    tauoi = -pTAUoi(igroup)';
    tauai = pWindstress(igroup)';
    
%%
    
    
    
    
    
    
    
ax5 = subplot('position',[0.05 0.2 subplotsize(1) subplotsize(2)]);
annotation('textbox',[0.05 0.19 0.05 0.05],'String','(e)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');    
    plot(Ua,zeros(size(Ua)),':','Color',gray,'LineWidth',1.5);
    hold on

    l1 = plot(Ua,ocnadv,'o-','Color',green,'LineWidth',1.5);
    scatter(Ua(3),ocnadv(3),'filled','o','MarkerFaceColor',[0 0 0]);
    l2 = plot(Ua,dissp,'^-','Color',purple,'LineWidth',1.5);
    scatter(Ua(3),dissp(3),'filled','^','MarkerFaceColor',[0 0 0]);
    l3 = plot(Ua,topogform,'v-','Color',yellow,'LineWidth',1.5);
    scatter(Ua(3),topogform(3),'filled','v','MarkerFaceColor',[0 0 0]);
    l6 = plot(Ua,tauoi,'d-','Color',brown,'LineWidth',1.5);
    scatter(Ua(3),tauoi(3),'filled','d','MarkerFaceColor',[0 0 0]);
    
    
    hold off
    set(gca,'fontsize',fontsize);
    ylim([-1.5 1.5])
    xlim([min(Ua) max(Ua)])
    xlabel('$|U_\mathrm{a0}| \ \rm (m/s)$', 'FontSize', fontsize,'interpreter','latex');
    Leg1 = legend([l1 l2 l3 l6],{'Ocean advection','Bottom friction',...
    'Topographic form stress','Ice-ocean stress'},'FontSize', fontsize,'interpreter','latex');
    set(Leg1,'position',[0.1204    0.01    0.2877    0.1129])

    
ax6 = subplot('position',[0.55 0.2 subplotsize(1) subplotsize(2)]);
annotation('textbox',[0.55 0.19 0.05 0.05],'String','(f)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
    plot(Ua,zeros(size(Ua)),':','Color',gray,'LineWidth',1.5);
    hold on    
    
    l0 = plot(Ua,tauai,'o-','Color',blue,'LineWidth',1.5);
    scatter(Ua(3),tauai(3),'filled','o','MarkerFaceColor',[0 0 0]);
    l4 = plot(Ua,iceinternal,'s-','Color',olive,'LineWidth',1.5);
    scatter(Ua(3),iceinternal(3),'filled','s','MarkerFaceColor',[0 0 0]);
    l5 = plot(Ua,sicor,'^-','Color',orange,'LineWidth',1.5);
    scatter(Ua(3),sicor(3),'filled','^','MarkerFaceColor',[0 0 0]);
    l6 = plot(Ua,-tauoi,'d-','Color',brown,'LineWidth',1.5);
    scatter(Ua(3),-tauoi(3),'filled','d','MarkerFaceColor',[0 0 0]);
    
    hold off
    set(gca,'fontsize',fontsize);
    ylim([-1.5 1.5])
    xlim([min(Ua) max(Ua)])
    xlabel('$|U_\mathrm{a0}| \ \rm (m/s)$', 'FontSize', fontsize,'interpreter','latex');
    Leg2 = legend([l0 l4 l5 l6],{'Wind stress','Sea ice internal stress divergence',...
    'Sea ice Coriolis force','Ocean-ice stress'},'FontSize', fontsize,'interpreter','latex');
    set(Leg2,'position',[0.5959    0.01    0.3656    0.1129])

    %%
print('-dpng','-r200','jpo_momentum_sensitivity2.png');


