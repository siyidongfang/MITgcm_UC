
addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires;

expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng/';
prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/';
figdir = './fig2_nature/';
figname = 'fig2_ver14_2';

expname = 'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25';
loadexp;

figure(1)
scrsz = get(0,'ScreenSize');
set(gcf,'Position',[0.1*scrsz(3) 0.3*scrsz(4) 1050 500]);
fontsize = 17;
subplotsize = [0.31 0.81];
set(gcf,'Color','w');

blue1 = '#0070C0';
blue2 = '#3D89DC';
blue3 = '#7fbeff';
blue4 = '#bbf5ff';
red1 = '#cf513d';
red2 = '#ef7564';
red3 = '#f5d3ce';

boxcolor = [0.85 0.85 0.85];
orange = [255 127 0]/255;
yellow = [0.9290 0.6940 0.1250];
black = [0 0 0];
green = [0.4660 0.6740 0.1880];
darkgray = [0.5 0.5 0.5];
gray = [0.7 0.7 0.7];

bluefill = hex2rgb('#59bfff');

mycolormap_fig2 = [...
hex2rgb(blue1)
hex2rgb(blue2)
hex2rgb(blue3)
hex2rgb(blue4)
black
hex2rgb(red3)
hex2rgb(red2)
hex2rgb(red1)];

clf
load([prodir 'heatbudget_100km-150km.mat'])
Fheat_adv = -Fheat_adv;

dS = 0.2625;
S = [33 33.28 33.56 34.12 34.12+dS 34.12+2*dS 34.12+2.5*dS 34.12+3*dS ...
    33 33.56 34.12 34.12+dS 34.12+2*dS 34.12+3*dS ...
    33 33.56 34.12 34.12+dS 34.12+2*dS 34.12+3*dS ...
    33 33.56 34.12 34.12+dS 34.12+2*dS 34.12+3*dS ...
    33 33.56 34.12 34.12+dS 34.12+2*dS 34.12+3*dS ...
    33 33 33 33 33 33 33 33 33 33 ...
    34.12+dS 34.12+dS 34.12+dS 34.12+dS 34.12+dS 34.12+dS 34.12+dS 34.12+dS 34.12+dS 34.12+dS ...
    34.12+3*dS 34.12+3*dS 34.12+3*dS 34.12+3*dS 34.12+3*dS 34.12+3*dS 34.12+3*dS 34.12+3*dS 34.12+3*dS 34.12+3*dS ...
    ];

%%
ax1 = subplot('position',[0.063 0.125 subplotsize]);
ann1 = annotation('textbox',[0.005 0.95 0.05 0.05],'String','a','FontSize',fontsize+1,'LineStyle','None','fontweight', 'bold');
rectangle('Position',[100 -0.2 50 2],'EdgeColor',[hex2rgb(red3) 0],'FaceColor',[boxcolor 0.2])
hold on;
plot(yy/1000,zeros(1,length(yy)),':','LineWidth',1,'color','k')
l2 = plot(yy/1000,Fheat_adv(2,:),'LineWidth',1.5,'color',blue2);
l3 = plot(yy/1000,Fheat_adv(3,:),'LineWidth',2,'color',blue3);
l4 = plot(yy/1000,Fheat_adv(4,:),'LineWidth',2,'color',blue4);
l5 = plot(yy/1000,Fheat_adv(5,:),'LineWidth',3,'color','k');
l6 = plot(yy/1000,Fheat_adv(6,:),'LineWidth',1.5,'color',red3);
l7 = plot(yy/1000,Fheat_adv(7,:),'LineWidth',1.5,'color',red2);
l8 = plot(yy/1000,Fheat_adv(8,:),'LineWidth',3,'color',red1);
l1 = plot(yy/1000,Fheat_adv(1,:),'LineWidth',3,'color',blue1);

set(gca,'FontSize',fontsize);

xlim([22 428])
set(gca,'XTick',[0:100:450]);
ylabel('TW','FontSize',fontsize)
xlabel('y (km)','FontSize',fontsize)
title('Shoreward heat transport','FontSize',fontsize+2,'fontweight', 'normal')

colormap(mycolormap_fig2)
handle1 = colorbar(gca,'TickLabels',[],'Ticks',[0:1/8:1]);  
set(handle1,'Position',[0.40    0.22    0.005    0.67],'TickLength',0,'AxisLocation','in','Box','on','Color',black,'LineWidth',0.5);
str1 = flip({'33' '' '33.28' '' '33.56' '' '34.12' '' '34.38' '' '34.65' '' '34.78' '' '34.91'});
str2 = '{\it S}_{shelf}^{bot} (psu)';

box on
anno1 = annotation('textbox',[0.405 0 0.05 0.87],'String',str1,'FontSize',fontsize-1,'EdgeColor','none');     
anno2 = annotation('textbox',[0.385 0.2 0.2 0.01],'String',str2,'FontSize',fontsize-1,'EdgeColor','none');     

%%


ax2 = subplot('position',[0.563 0.125 subplotsize]);
ann2 = annotation('textbox',[0.508 0.95 0.05 0.05],'String','b','FontSize',fontsize+1,'LineStyle','None','fontweight', 'bold');

sz = 70;
LineWidthsz = 1;

refF = -F_band(5);
rectangle('Position',[33 refF 34.3825-33 4],'EdgeColor',[hex2rgb(red3) 0.3],'FaceColor',[hex2rgb(red3) 0.3])
rectangle('Position',[34.3825 -1 35-34.3825 1+refF],'EdgeColor',[hex2rgb(red3) 0.3],'FaceColor',[hex2rgb(red3) 0.3])

rectangle('Position',[33 -1 34.3825-33 1+refF],'EdgeColor',[bluefill 0.1],'FaceColor',[bluefill 0.1])
rectangle('Position',[34.3825 +refF 35-34.3825 4],'EdgeColor',[bluefill 0.1],'FaceColor',[bluefill 0.1])

hold on;

plot(33:0.02:S(5),zeros(1,70),':','Color','k','LineWidth',1)
plot(S(5):0.02:35,zeros(1,31),':','Color','k','LineWidth',1)

% plot((34.12+dS)*ones(1,106),[-0.5:0.1/3:3],':','Color','k','LineWidth',1)
l5km_gmredi = plot(S(15:18),-F_band(15:18),':','Color',gray,'LineWidth',2); %% 5km, GM-Redi
l10km_gmredi = plot(S(27:30),-F_band(27:30),'--','Color',gray,'LineWidth',2);%% 10km, GM-Redi
l5km = plot(S(9:12),-F_band(9:12),':','Color',green,'LineWidth',2); %%5km, No GM-Redi
l10km = plot(S(21:24),-F_band(21:24),'--','Color',green,'LineWidth',2); %% 10km, No GM-Redi
l2km = plot(S([1 3:5]),-F_band([1 3:5]),'-','Color',green,'LineWidth',3);


plot(S(5:8),-F_band(5:8),'-','Color',gray,'LineWidth',2); %% 2km
plot(S(18:20),-F_band(18:20),':','Color',gray,'LineWidth',2); %% 5km
plot(S(30:32),-F_band(30:32),'--','Color',gray,'LineWidth',2);%% 10km

plot(S(5:8),-F_band(5:8),'-','Color',yellow,'LineWidth',3)

plot(S(12:14),-F_band(12:14),':','Color',yellow,'LineWidth',2) %%5km, No GM-Redi
plot(S(24:26),-F_band(24:26),'--','Color',yellow,'LineWidth',2) %% 10km, No GM-Redi
plot(S(5:8),-F_band(5:8),'-','Color',yellow,'LineWidth',3) %%% 2km



scatter(S(1),-F_band(1),sz,hex2rgb(blue1),'o','filled')
scatter(S(2),-F_band(2),sz,hex2rgb(blue2),'o','filled')
scatter(S(3),-F_band(3),sz,hex2rgb(blue3),'o','filled')
scatter(S(4),-F_band(4),sz,hex2rgb(blue4),'o','filled')
scatter(S(5),-F_band(5),sz,'black','o','filled')

scatter(S([9 15 21 27]),-F_band([9 15 21 27]),sz/2,hex2rgb(blue1),'o','LineWidth',1)
scatter(S([9 15 21 27]+1),-F_band([9 15 21 27]+1),sz/2,hex2rgb(blue3),'o','LineWidth',1)
scatter(S([9 15 21 27]+2),-F_band([9 15 21 27]+2),sz/2,hex2rgb(blue4),'o','LineWidth',1)
scatter(S([9 15 21 27]+3),-F_band([9 15 21 27]+3),sz/2,'k','o','LineWidth',1)


nexp = 33;
facecolor = hex2rgb(blue1);
%%% 2km, varying Ua
scatter(S(nexp),-F_band(nexp),sz*0.8,facecolor,'<','filled','MarkerEdgeColor',boxcolor); % Ua-4
scatter(S(nexp+1),-F_band(nexp+1),sz*1.3,facecolor,'<','filled','MarkerEdgeColor',boxcolor); % Ua-8
%%% 2km, varying Va
scatter(S(nexp+2),-F_band(nexp+2),sz*0.8,facecolor,'^','filled','MarkerEdgeColor',boxcolor); % Va4
% scatter(S(nexp+3),-F_band(nexp+3),sz*1.3,facecolor,'^','filled','MarkerEdgeColor',boxcolor); % Va12
%%% 2km, varying hi0
scatter(S(nexp+4),-F_band(nexp+4),sz*0.8,facecolor,'s','filled','MarkerEdgeColor',boxcolor); % Va4
scatter(S(nexp+5),-F_band(nexp+5),sz*1.3,facecolor,'s','filled','MarkerEdgeColor',boxcolor); % Va12
%%% 2km, varying Atide
% scatter(S(nexp+6),-F_band(nexp+6),sz*0.8,facecolor,'p','filled','MarkerEdgeColor',boxcolor); % Va4
% scatter(S(nexp+7),-F_band(nexp+7),sz*1.3,facecolor,'p','filled','MarkerEdgeColor',boxcolor); % Va12
%%% 2km, varying Ws
scatter(S(nexp+8),-F_band(nexp+8),sz*0.8,facecolor,'d','filled','MarkerEdgeColor',boxcolor); % Va4
scatter(S(nexp+9),-F_band(nexp+9),sz*1.3,facecolor,'d','filled','MarkerEdgeColor',boxcolor); % Va12


nexp = nexp+10;
facecolor = black;
%%% 2km, varying Ua
scatter(S(nexp),-F_band(nexp),sz*0.8,facecolor,'<','filled','MarkerEdgeColor',boxcolor); % Ua-4
lua = scatter(S(nexp+1),-F_band(nexp+1),sz*1.3,facecolor,'<','filled','MarkerEdgeColor',boxcolor); % Ua-8
%%% 2km, varying Va
scatter(S(nexp+2),-F_band(nexp+2),sz*0.8,facecolor,'^','filled','MarkerEdgeColor',boxcolor); % Va4
lva = scatter(S(nexp+3),-F_band(nexp+3),sz*1.3,facecolor,'^','filled','MarkerEdgeColor',boxcolor); % Va12
%%% 2km, varying hi0
scatter(S(nexp+4),-F_band(nexp+4),sz*0.8,facecolor,'s','filled','MarkerEdgeColor',boxcolor); % Va4
lhi = scatter(S(nexp+5),-F_band(nexp+5),sz*1.3,facecolor,'s','filled','MarkerEdgeColor',boxcolor); % Va12
%%% 2km, varying Atide
scatter(S(nexp+6),-F_band(nexp+6),sz*0.8,facecolor,'p','filled','MarkerEdgeColor',boxcolor); % Va4
ltide = scatter(S(nexp+7),-F_band(nexp+7),sz*1.3,facecolor,'p','filled','MarkerEdgeColor',boxcolor); % Va12
%%% 2km, varying Ws
scatter(S(nexp+8),-F_band(nexp+8),sz*0.8,facecolor,'d','filled','MarkerEdgeColor',boxcolor); % Va4
lws = scatter(S(nexp+9),-F_band(nexp+9),sz*1.3,facecolor,'d','filled','MarkerEdgeColor',boxcolor); % Va12


scatter(S(6),-F_band(6),sz,hex2rgb(red3),'o','filled')
scatter(S(7),-F_band(7),sz,hex2rgb(red2),'o','filled')
scatter(S(8),-F_band(8),sz,hex2rgb(red1),'o','filled')


scatter(S([9 15 21 27]+4),-F_band([9 15 21 27]+4),sz/2,hex2rgb(red3),'o','LineWidth',1)
scatter(S([9 15 21 27]+5),-F_band([9 15 21 27]+5),sz/2,hex2rgb(red1),'o','LineWidth',1)


nexp = nexp+10;
facecolor = hex2rgb(red1);
%%% 2km, varying Ua
scatter(S(nexp),-F_band(nexp),sz*0.8,facecolor,'<','filled','MarkerEdgeColor',boxcolor); % Ua-4
scatter(S(nexp+1),-F_band(nexp+1),sz*1.3,facecolor,'<','filled','MarkerEdgeColor',boxcolor); % Ua-8
%%% 2km, varying Va
scatter(S(nexp+2),-F_band(nexp+2),sz*0.8,facecolor,'^','filled','MarkerEdgeColor',boxcolor); % Va4
scatter(S(nexp+3),-F_band(nexp+3),sz*1.3,facecolor,'^','filled','MarkerEdgeColor',boxcolor); % Va12
%%% 2km, varying hi0
scatter(S(nexp+4),-F_band(nexp+4),sz*0.8,facecolor,'s','filled','MarkerEdgeColor',boxcolor); % Va4
% scatter(S(nexp+5),-F_band(nexp+5),sz*1.3,facecolor,'s','filled','MarkerEdgeColor',boxcolor); % Va12
%%% 2km, varying Atide
scatter(S(nexp+6),-F_band(nexp+6),sz*0.8,facecolor,'p','filled','MarkerEdgeColor',boxcolor); % Va4
scatter(S(nexp+7),-F_band(nexp+7),sz*1.3,facecolor,'p','filled','MarkerEdgeColor',boxcolor); % Va12
%%% 2km, varying Ws
scatter(S(nexp+8),-F_band(nexp+8),sz*0.8,facecolor,'d','filled','MarkerEdgeColor',boxcolor); % Va4
scatter(S(nexp+9),-F_band(nexp+9),sz*1.3,facecolor,'d','filled','MarkerEdgeColor',boxcolor); % Va12






ylim([-0.8 3.7])
set(gca,'FontSize',fontsize);
ylabel('TW','FontSize',fontsize)
xlabel('Shelf bottom salinity, {\it S}_{shelf}^{bot} (psu)','FontSize',fontsize)
box on;
title('{\it F}_{slope}','FontSize',fontsize+2,'fontweight', 'normal')

leg21 = legend([lua lva ltide lhi lws l2km l5km l5km_gmredi l10km l10km_gmredi],...
    'Varied U_a','Varied V_a','Varied A_{tide}','Varied h_{i0}','Varied W_S',...
    '2 km',['5 km,' newline 'no GM-Redi'],['5 km,' newline 'GM-Redi'],...
    ['10 km,' newline 'no GM-Redi'],['10 km,' newline 'GM-Redi'],...
    'FontSize', fontsize-2,'box','off');
set(leg21,'Position',  [0.7781 0.1357 0.3309 0.8000])
% grid on;
% grid minor;

% leg22 = legend([],...
%     ,...
%     'FontSize', fontsize-1,'box','off');
% set(leg22,'Position', [0.6729    0.1    0.3309    0.1400])



% 
% ann = annotation('textbox',[0.3905 0.3305 0.5071 0.1137],'String',...
%     {'Colored lines: No GM-Redi','Gray lines: GM-Redi'},'FontSize',fontsize-2,'LineStyle','None',...
%     'HorizontalAlignment', 'left');






%%

ax3 = axes('position',[0.61 0.45 0.15 0.4]);
% rectangle('Position',[33 0 34.3825-33 3],'EdgeColor',[hex2rgb(red3) 0.3],'FaceColor',[hex2rgb(red3) 0.3])
plot(S(9:12),-F_band(9:12),':','Color',green,'LineWidth',2) %%5km, No GM-Redi
hold on;
plot(S(21:24),-F_band(21:24),'--','Color',green,'LineWidth',2) %% 10km, No GM-Redi
plot(S([1 3:5]),-F_band([1 3:5]),'-','Color',green,'LineWidth',3)


scatter(S(1),-F_band(1),sz,hex2rgb(blue1),'o','filled')
scatter(S(2),-F_band(2),sz,hex2rgb(blue2),'o','filled')
scatter(S(3),-F_band(3),sz,hex2rgb(blue3),'o','filled')
scatter(S(4),-F_band(4),sz,hex2rgb(blue4),'o','filled')
scatter(S(5),-F_band(5),sz,'black','o','filled')

scatter(S([9 21]),-F_band([9 21]),sz/2,hex2rgb(blue1),'o','LineWidth',1)
scatter(S([9 21]+1),-F_band([9 21]+1),sz/2,hex2rgb(blue3),'o','LineWidth',1)
scatter(S([9 21]+2),-F_band([9 21]+2),sz/2,hex2rgb(blue4),'o','LineWidth',1)
scatter(S([9 21]+3),-F_band([9 21]+3),sz/2,'k','o','LineWidth',1)


nexp = 33;
facecolor = hex2rgb(blue1);
%%% 2km, varying Ua
scatter(S(nexp),-F_band(nexp),sz*0.8,facecolor,'<','filled','MarkerEdgeColor',boxcolor); % Ua-4
scatter(S(nexp+1),-F_band(nexp+1),sz*1.3,facecolor,'<','filled','MarkerEdgeColor',boxcolor); % Ua-8
%%% 2km, varying Va
scatter(S(nexp+2),-F_band(nexp+2),sz*0.8,facecolor,'^','filled','MarkerEdgeColor',boxcolor); % Va4
% scatter(S(nexp+3),-F_band(nexp+3),sz*1.3,facecolor,'^','filled','MarkerEdgeColor',boxcolor); % Va12
%%% 2km, varying hi0
scatter(S(nexp+4),-F_band(nexp+4),sz*0.8,facecolor,'s','filled','MarkerEdgeColor',boxcolor); % Va4
scatter(S(nexp+5),-F_band(nexp+5),sz*1.3,facecolor,'s','filled','MarkerEdgeColor',boxcolor); % Va12
%%% 2km, varying Atide
% scatter(S(nexp+6),-F_band(nexp+6),sz*0.8,facecolor,'p','filled','MarkerEdgeColor',boxcolor); % Va4
% scatter(S(nexp+7),-F_band(nexp+7),sz*1.3,facecolor,'p','filled','MarkerEdgeColor',boxcolor); % Va12
%%% 2km, varying Ws
scatter(S(nexp+8),-F_band(nexp+8),sz*0.8,facecolor,'d','filled','MarkerEdgeColor',boxcolor); % Va4
scatter(S(nexp+9),-F_band(nexp+9),sz*1.3,facecolor,'d','filled','MarkerEdgeColor',boxcolor); % Va12


nexp = nexp+10;
facecolor = black;
%%% 2km, varying Ua
scatter(S(nexp),-F_band(nexp),sz*0.8,facecolor,'<','filled','MarkerEdgeColor',boxcolor); % Ua-4
scatter(S(nexp+1),-F_band(nexp+1),sz*1.3,facecolor,'<','filled','MarkerEdgeColor',boxcolor); % Ua-8
%%% 2km, varying Va
scatter(S(nexp+2),-F_band(nexp+2),sz*0.8,facecolor,'^','filled','MarkerEdgeColor',boxcolor); % Va4
scatter(S(nexp+3),-F_band(nexp+3),sz*1.3,facecolor,'^','filled','MarkerEdgeColor',boxcolor); % Va12
%%% 2km, varying hi0
scatter(S(nexp+4),-F_band(nexp+4),sz*0.8,facecolor,'s','filled','MarkerEdgeColor',boxcolor); % Va4
scatter(S(nexp+5),-F_band(nexp+5),sz*1.3,facecolor,'s','filled','MarkerEdgeColor',boxcolor); % Va12
%%% 2km, varying Atide
scatter(S(nexp+6),-F_band(nexp+6),sz*0.8,facecolor,'p','filled','MarkerEdgeColor',boxcolor); % Va4
scatter(S(nexp+7),-F_band(nexp+7),sz*1.3,facecolor,'p','filled','MarkerEdgeColor',boxcolor); % Va12
%%% 2km, varying Ws
scatter(S(nexp+8),-F_band(nexp+8),sz*0.8,facecolor,'d','filled','MarkerEdgeColor',boxcolor); % Va4
scatter(S(nexp+9),-F_band(nexp+9),sz*1.3,facecolor,'d','filled','MarkerEdgeColor',boxcolor); % Va12
set(gca,'FontSize',fontsize-2);
ylim([-0.08 0.42])
% set(gca,'ytick',[0.05 0.1 0.15 0.2 0.25],'YColor',darkgray,'XColor',darkgray);
set(gca,'YColor',darkgray,'XColor',darkgray);
xlim([33 34.5])
% grid on;
% grid minor;
set(gca,'xaxisLocation','top')



print('-djpeg','-r300',[figdir figname '.jpeg']);