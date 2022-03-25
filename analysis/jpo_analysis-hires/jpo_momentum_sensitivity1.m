clear; close all

addpath /Users/csi/MITgcm_ASF-csi/utils/matlab; 
addpath /Users/csi/MITgcm_ASF-csi/analysis;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps;
expdir = '/Users/csi/MITgcm_ASF-csi/experiments/';
prodir = '/Volumes/si/MITgcm_ASF-csi/products-hires';




%%% Plotting options
fontsize = 14;

%%% Initialize figure
figure(1);
clf;
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 800 880]);
set(gcf,'Color','w');
legpos = [0.4 0.01 0.2 0.03];

%%% colormap
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps/customcolormap
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

load([prodir '/MomScalingMatrix_slope_ystart125km_new.mat']);


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
% buoy = [33 33.59 34.17 34.38 34.59 34.79]-34.17; 
buoy = [-1.076 -0.620 -0.207 0.000 0.204 0.409];



%% Tide

subplotsize = [0.43 0.195];

clf;

    igroup = nAtide;
    atide = Atide;
    nref = 3;
    ocnadv = pOCN_AdvCor(igroup);
    iceinternal = pSIinternal(igroup);
    dissp = pDissipation(igroup);
    sicor = pSI_cor(igroup);
    topogform = pTopogform(igroup);
    tauoi = -pTAUoi(igroup);
    
ax1 = subplot('position',[0.05 0.775 subplotsize]);
annotation('textbox',[0.05 0.76 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
    plot(atide,zeros(size(atide)),':','Color',gray,'LineWidth',1.5);
    hold on    
    l1 = plot(atide,ocnadv,'o-','Color',green,'LineWidth',1.5);
%     scatter(atide,ocnadv,'filled','o','MarkerFaceColor',[0 0 0]);
    scatter(atide(nref),ocnadv(nref),'filled','o','MarkerFaceColor',[0 0 0]);
    l2 = plot(atide,dissp,'^-','Color',purple,'LineWidth',1.5);
%     scatter(atide,dissp,'filled','^','MarkerFaceColor',[0 0 0]);
    scatter(atide(nref),dissp(nref),'filled','^','MarkerFaceColor',[0 0 0]);
    l3 = plot(atide,topogform,'v-','Color',yellow,'LineWidth',1.5);
%     scatter(atide,topogform,'filled','v','MarkerFaceColor',[0 0 0]);
    scatter(atide(nref),topogform(nref),'filled','v','MarkerFaceColor',[0 0 0]);
    l6 = plot(atide,tauoi,'d-','Color',brown,'LineWidth',1.5);
%     scatter(atide,tauoi,'filled','d','MarkerFaceColor',[0 0 0]);
    scatter(atide(nref),tauoi(nref),'filled','d','MarkerFaceColor',[0 0 0]);
    
    hold off
    set(gca,'fontsize',fontsize);
%     set(gca,'xticklabel',[])
    title('Normalized ocean zonal force balance', 'FontSize', fontsize+2,'interpreter','latex'); %(normalized by zonal wind stress)
    xlabel('$A_\mathrm{tide}\ \rm (m/s)$', 'FontSize', fontsize+1,'interpreter','latex');
    ylim([-1.7 1.7])

ax2 = subplot('position',[0.55 0.775 subplotsize]);
annotation('textbox',[0.55 0.76 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
    plot(atide,zeros(size(atide)),':','Color',gray,'LineWidth',1.5);
    hold on
    l0 = plot(atide,ones(size(atide)),'o-','Color',blue,'LineWidth',1.5);
    scatter(atide(nref),1,'filled','o','MarkerFaceColor',[0 0 0]);
    l4 = plot(atide,iceinternal,'s-','Color',olive,'LineWidth',1.5);
    scatter(atide(nref),iceinternal(nref),'filled','s','MarkerFaceColor',[0 0 0]);
    l5 = plot(atide,sicor,'^-','Color',orange,'LineWidth',1.5);
    scatter(atide(nref),sicor(nref),'filled','^','MarkerFaceColor',[0 0 0]);
    l6 = plot(atide,-tauoi,'d-','Color',brown,'LineWidth',1.5);
    scatter(atide(nref),-tauoi(nref),'filled','d','MarkerFaceColor',[0 0 0]);
    hold off
    set(gca,'fontsize',fontsize);
    ylim([-1.7 1.7])
    title('Normalized sea ice zonal force balance', 'FontSize', fontsize+2,'interpreter','latex'); %(normalized by zonal wind stress)
    xlabel('$A_\mathrm{tide}\ \rm (m/s)$', 'FontSize', fontsize+1,'interpreter','latex');



%% Slope half-width
    igroup = nws;
    ws = ws;
    ocnadv = pOCN_AdvCor(igroup)';
    iceinternal = pSIinternal(igroup)';
    dissp = pDissipation(igroup)';
    sicor = pSI_cor(igroup)';
    topogform = pTopogform(igroup)';
    tauoi = -pTAUoi(igroup)';

ax3 = subplot('position',[0.05 0.51 subplotsize]);
annotation('textbox',[0.05 0.495 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');    
    plot(ws,zeros(size(ws)),':','Color',gray,'LineWidth',1.5);
    hold on

    l1 = plot(ws,ocnadv,'o-','Color',green,'LineWidth',1.5);
    scatter(ws(1),ocnadv(1),'filled','o','MarkerFaceColor',[0 0 0]);
    l2 = plot(ws,dissp,'^-','Color',purple,'LineWidth',1.5);
    scatter(ws(1),dissp(1),'filled','^','MarkerFaceColor',[0 0 0]);
    l3 = plot(ws,topogform,'v-','Color',yellow,'LineWidth',1.5);
    scatter(ws(1),topogform(1),'filled','v','MarkerFaceColor',[0 0 0]);
    l6 = plot(ws,tauoi,'d-','Color',brown,'LineWidth',1.5);
    scatter(ws(1),tauoi(1),'filled','d','MarkerFaceColor',[0 0 0]);
    
    hold off
    set(gca,'fontsize',fontsize);
    ylim([-1.7 1.7])
    xlim([min(ws) max(ws)])
    xlabel('$W_S \ \rm (km)$', 'FontSize', fontsize,'interpreter','latex');

ax4 = subplot('position',[0.55 0.51 subplotsize]);
annotation('textbox',[0.55 0.495 0.05 0.05],'String','(d)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
    plot(ws,zeros(size(ws)),':','Color',gray,'LineWidth',1.5);
    hold on
    l0 = plot(ws,ones(size(ws)),'o-','Color',blue,'LineWidth',1.5);
    scatter(ws(1),1,'filled','o','MarkerFaceColor',[0 0 0]);
    l4 = plot(ws,iceinternal,'s-','Color',olive,'LineWidth',1.5);
    scatter(ws(1),iceinternal(1),'filled','s','MarkerFaceColor',[0 0 0]);
    l5 = plot(ws,sicor,'^-','Color',orange,'LineWidth',1.5);
    scatter(ws(1),sicor(1),'filled','^','MarkerFaceColor',[0 0 0]);
    l6 = plot(ws,-tauoi,'d-','Color',brown,'LineWidth',1.5);
    scatter(ws(1),-tauoi(1),'filled','d','MarkerFaceColor',[0 0 0]);
    
    hold off
    set(gca,'fontsize',fontsize);
    ylim([-1.7 1.7])
    xlim([min(ws) max(ws)])
    xlabel('$W_S \ \rm (km)$', 'FontSize', fontsize,'interpreter','latex');

    %% Buoyancy gradient

    igroup = nbuoy;
    buoy = buoy; 
    ocnadv = pOCN_AdvCor(igroup);
    iceinternal = pSIinternal(igroup);
    dissp = pDissipation(igroup);
    sicor = pSI_cor(igroup);
    topogform = pTopogform(igroup);
    tauoi = -pTAUoi(igroup);
    
ax5 = subplot('position',[0.05 0.05 subplotsize(1) subplotsize(2)*2.0144]);
annotation('textbox',[0.05 0.035 0.05 0.05],'String','(e)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');    
    plot(buoy,zeros(size(buoy)),':','Color',gray,'LineWidth',1.5);
    hold on

    l1 = plot(buoy,ocnadv,'o-','Color',green,'LineWidth',1.5);
    scatter(buoy(3),ocnadv(3),'filled','o','MarkerFaceColor',[0 0 0]);
    l2 = plot(buoy,dissp,'^-','Color',purple,'LineWidth',1.5);
    scatter(buoy(3),dissp(3),'filled','^','MarkerFaceColor',[0 0 0]);
    l3 = plot(buoy,topogform,'v-','Color',yellow,'LineWidth',1.5);
    scatter(buoy(3),topogform(3),'filled','v','MarkerFaceColor',[0 0 0]);
    l6 = plot(buoy,tauoi,'d-','Color',brown,'LineWidth',1.5);
    scatter(buoy(3),tauoi(3),'filled','d','MarkerFaceColor',[0 0 0]);
    
    hold off
    set(gca,'fontsize',fontsize);
    ylim([-4.2 2.5])
    xlim([min(buoy) max(buoy)])
    xlabel('$\Delta\sigma_4\ (\mathrm{kg\ m^{-3}})$', 'FontSize', fontsize+1,'interpreter','latex');
    Leg1 = legend([l1 l2 l3 l6],{'Ocean advection','Bottom friction',...
    'Topographic form stress','Ice-ocean stress'},'FontSize', fontsize,'interpreter','latex');
    set(Leg1,'position',[0.1097    0.0657    0.27    0.0964])

ax6 = subplot('position',[0.55 0.05 subplotsize(1) subplotsize(2)*2.0144]);
annotation('textbox',[0.55 0.035 0.05 0.05],'String','(f)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
    plot(buoy,zeros(size(buoy)),':','Color',gray,'LineWidth',1.5);
    hold on    
    l0 = plot(buoy,ones(size(buoy)),'o-','Color',blue,'LineWidth',1.5);
    scatter(buoy(3),1,'filled','o','MarkerFaceColor',[0 0 0]);
    l4 = plot(buoy,iceinternal,'s-','Color',olive,'LineWidth',1.5);
    scatter(buoy(3),iceinternal(3),'filled','s','MarkerFaceColor',[0 0 0]);
    l5 = plot(buoy,sicor,'^-','Color',orange,'LineWidth',1.5);
    scatter(buoy(3),sicor(3),'filled','^','MarkerFaceColor',[0 0 0]);
    l6 = plot(buoy,-tauoi,'d-','Color',brown,'LineWidth',1.5);
    scatter(buoy(3),-tauoi(3),'filled','d','MarkerFaceColor',[0 0 0]);
    hold off
    set(gca,'fontsize',fontsize);
    ylim([-4.2 2.5])
    xlim([min(buoy) max(buoy)])
    xlabel('$\Delta\sigma_4\ (\mathrm{kg\ m^{-3}})$', 'FontSize', fontsize+1,'interpreter','latex');
    Leg2 = legend([l0 l4 l5 l6],{'Wind stress','Sea ice internal stress divergence',...
    'Sea ice Coriolis force','Ocean-ice stress'},'FontSize', fontsize,'interpreter','latex');
    set(Leg2,'position',[0.6106    0.0657    0.32    0.0964])

    
    
    set(gcf,'InnerPosition',[-9 67 714 772])

    %%
print('-dpng','-r200','jpo_momentum_sensitivity1.png');


