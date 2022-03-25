clear all;
% close all

basedir = '/data/MITgcm_ASF-csi/newexp/analysis/';
addpath /data/MITgcm_ASF-csi/utils/matlab; 
addpath /data/MITgcm_ASF-csi/newexp/analysis;
addpath /data/MITgcm_ASF-csi/experiments/products;
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps;
expdir = '/data/MITgcm_ASF-csi/experiments/';
outdir = '/data/MITgcm_ASF-csi/experiments/products';




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

load([outdir '/scalingMatrix/MomScalingMatrix.mat']);


position = {'shelf','slope','openocean'};
ntitle = {'Continental shelf','Continental slope','Open ocean'};

j=2; %%% Plot the momentum scaling matrix on the shelf





%% Ice thickness

subplotsize = [0.43 0.17];

clf;

    igroup = [15 16 1];
    hice = [0.2 0.6 1];
    ocnadv = pOCN_AdvCor(igroup,j)';
    iceinternal = pSIinternal(igroup,j)';
    dissp = pDissipation(igroup,j)';
    sicor = pSI_cor(igroup,j)';
    topogform = pTopogform(igroup,j)';
    tauoi = -pTAUoi(igroup,j)';
    
ax1 = subplot('position',[0.05 0.795 subplotsize]);
annotation('textbox',[0.05 0.785 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
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
    xlabel('$ h_{i0}\ (m)$', 'FontSize', fontsize+1,'interpreter','latex');
    ylim([-1.1 1.1])

ax2 = subplot('position',[0.55 0.795 subplotsize]);
annotation('textbox',[0.55 0.785 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
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
    ylim([-1.1 1.1])
    title('Normalized sea ice zonal force balance', 'FontSize', fontsize+2,'interpreter','latex'); %(normalized by zonal wind stress)
    xlabel('$ h_{i0}\ (m)$', 'FontSize', fontsize+1,'interpreter','latex');



%% Meridional wind
    igroup = [19 1 20];
    Va = [4 6 8];
    ocnadv = pOCN_AdvCor(igroup,j)';
    iceinternal = pSIinternal(igroup,j)';
    dissp = pDissipation(igroup,j)';
    sicor = pSI_cor(igroup,j)';
    topogform = pTopogform(igroup,j)';
    tauoi = -pTAUoi(igroup,j)';

ax3 = subplot('position',[0.05 0.54 subplotsize]);
annotation('textbox',[0.05 0.53 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');    
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
    ylim([-1.1 1.1])
    xlim([min(Va) max(Va)])
    xlabel('$V_{a0} \ (m/s)$', 'FontSize', fontsize,'interpreter','latex');

ax4 = subplot('position',[0.55 0.54 subplotsize]);
annotation('textbox',[0.55 0.53 0.05 0.05],'String','(d)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
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
    ylim([-1.1 1.1])
    xlim([min(Va) max(Va)])
    xlabel('$V_{a0} \ (m/s)$', 'FontSize', fontsize,'interpreter','latex');

%% Zonal wind 
    igroup = [17 1 18];
    Ua = [4 6 8];
    ocnadv = pOCN_AdvCor(igroup,j)';
    iceinternal = pSIinternal(igroup,j)';
    dissp = pDissipation(igroup,j)';
    sicor = pSI_cor(igroup,j)';
    topogform = pTopogform(igroup,j)';
    tauoi = -pTAUoi(igroup,j)';
    
ax5 = subplot('position',[0.05 0.2 subplotsize(1) subplotsize(2)*3.3/2.2]);
annotation('textbox',[0.05 0.19 0.05 0.05],'String','(e)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');    
    plot(Ua,zeros(size(Ua)),':','Color',gray,'LineWidth',1.5);
    hold on

    l1 = plot(Ua,ocnadv,'o-','Color',green,'LineWidth',1.5);
    scatter(Ua(2),ocnadv(2),'filled','o','MarkerFaceColor',[0 0 0]);
    l2 = plot(Ua,dissp,'^-','Color',purple,'LineWidth',1.5);
    scatter(Ua(2),dissp(2),'filled','^','MarkerFaceColor',[0 0 0]);
    l3 = plot(Ua,topogform,'v-','Color',yellow,'LineWidth',1.5);
    scatter(Ua(2),topogform(2),'filled','v','MarkerFaceColor',[0 0 0]);
    l6 = plot(Ua,tauoi,'d-','Color',brown,'LineWidth',1.5);
    scatter(Ua(2),tauoi(2),'filled','d','MarkerFaceColor',[0 0 0]);
    
    
    hold off
    set(gca,'fontsize',fontsize);
    ylim([-2.1 1.1])
    xlim([min(Ua) max(Ua)])
    xlabel('$|U_{a0}| \ (m/s)$', 'FontSize', fontsize,'interpreter','latex');
    Leg1 = legend([l1 l2 l3 l6],{'Ocean advection','Bottom friction',...
    'Topographic form stress','Ice-ocean stress'},'FontSize', fontsize,'interpreter','latex');
    set(Leg1,'position',[0.1204    0.01    0.2877    0.1129])

ax6 = subplot('position',[0.55 0.2 subplotsize(1) subplotsize(2)*3.3/2.2]);
annotation('textbox',[0.55 0.19 0.05 0.05],'String','(f)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
    plot(Ua,zeros(size(Ua)),':','Color',gray,'LineWidth',1.5);
    hold on    
    
    l0 = plot(Ua,ones(size(Ua)),'o-','Color',blue,'LineWidth',1.5);
    scatter(Ua(2),1,'filled','o','MarkerFaceColor',[0 0 0]);
    l4 = plot(Ua,iceinternal,'s-','Color',olive,'LineWidth',1.5);
    scatter(Ua(2),iceinternal(2),'filled','s','MarkerFaceColor',[0 0 0]);
    l5 = plot(Ua,sicor,'^-','Color',orange,'LineWidth',1.5);
    scatter(Ua(2),sicor(2),'filled','^','MarkerFaceColor',[0 0 0]);
    l6 = plot(Ua,-tauoi,'d-','Color',brown,'LineWidth',1.5);
    scatter(Ua(2),-tauoi(2),'filled','d','MarkerFaceColor',[0 0 0]);
    
    hold off
    set(gca,'fontsize',fontsize);
    ylim([-2.1 1.1])
    xlim([min(Ua) max(Ua)])
    xlabel('$|U_{a0}| \ (m/s)$', 'FontSize', fontsize,'interpreter','latex');
    Leg2 = legend([l0 l4 l5 l6],{'Wind stress','Sea ice internal stress divergence',...
    'Sea ice Coriolis force','Ocean-ice stress'},'FontSize', fontsize,'interpreter','latex');
    set(Leg2,'position',[0.5959    0.01    0.3656    0.1129])

    %%
% print('-dpng','-r150','jpo_momentum_sensitivity2.png');


