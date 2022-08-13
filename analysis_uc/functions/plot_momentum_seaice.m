


blue = [0 0.4470 0.7410];
orange = [0.8500 0.3250 0.0980];
coral = [255 127 80]/255;
yellow = [0.9290 0.6940 0.1250];
gold = [255 215 0]/255;
lightblue = [0.3010 0.7450 0.9330];
purple = [0.4940 0.1840 0.5560];
green = [0.4660 0.6740 0.1880];
red = [0.6350 0.0780 0.1840];
gray = [225 225 225]/255;
pink = [255 153 204]/255;
brown = [153 102 51]/255;
olive = [107 142 35]/255;
lightred = [249 102 102]/255;
seagreen = [46 139 87]/255;

int = 10;
Ny_int = floor(Ny/int)+1;
% scale_sig12 = mean(abs(sig12_xavg(3,:)));
yy_mid = 0.5*(yy(1:end-1)+yy(2:end));

subplotsize = [0.4 0.4];

figure(1)
set(gcf,'Position',[83 183 1100 750]);
ax3 = subplot('position',[0.08 0.06 subplotsize]);

l2 = plot(yy/1000,TAUoi_xint/1e4,'LineWidth',2,'Color',brown);
hold on;
l0 = plot(yy/1000,-totalchange/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l3 = plot(yy/1000,coriolisforce/1e4,'LineWidth',2,'Color',orange);
l1 = plot(yy/1000,TAUai_xint/1e4,'LineWidth',2,'Color',blue);
% l4 = plot(yy/1000,iceResidual/1e4,'LineWidth',1.5,'Color',olive);
l4 = plot(yy/1000,internal_xint/1e4,'LineWidth',2,'Color',olive);
l8 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
yup = 12;
ydown = -12;
ylim([ydown yup]);
line([Ycoast Ycoast],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([Yshelfbreak Yshelfbreak],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([Ydeep Ydeep],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(2,yup-1,'Ice shelf/continent','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(120,yup-1,'Continental shelf','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(250,yup-1,'Slope','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(320,yup-1,'Deep ocean','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
% quiver(yy(1:int:end)/1000,5*ones(1,Ny_int),...
%     sig12_xavg(3,1:int:end)/scale_sig12,zeros(1,Ny_int),0.4,'-','filled','Color',olive,'LineWidth',0.5)
hold off;
set(gca,'fontsize',fontsize);
xlim([0 400])
xticks([0 100 200 300 400])
xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
title('Sea ice zonal force balance','FontSize',fontsize+2,'interpreter','latex');
ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
leg3=legend([l1 l2 l4 l3 l0],'Wind stress','Ocean-ice stress',...
    'Sea ice internal stress divergence','Coriolis force','Residual term',...
    'interpreter','latex', 'FontSize', fontsize-1);
set(leg3,'position',[0.2661 0.0253 0.2457 0.1360])



ax4 = subplot('position',[0.58 0.06 subplotsize]);
l2 = plot(yy/1000,TAUoi_xint/1e4,'LineWidth',2,'Color',brown);
hold on;
% l0 = plot(yy/1000,-totalchange/1e4,'LineWidth',3,'color',[0.7 0.7 0.7]);
l3 = plot(yy/1000,coriolisforce/1e4,'LineWidth',2,'Color',orange);
l1 = plot(yy/1000,TAUai_xint/1e4,'LineWidth',2,'Color',blue);
l4 = plot(yy/1000,(internal_xint-totalchange)/1e4,'LineWidth',2,'Color',olive);
l8 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
yup = 12/2;
ydown = -12/2;
ylim([ydown yup]);
line([Ycoast Ycoast],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([Yshelfbreak Yshelfbreak],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
line([Ydeep Ydeep],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
text(2,yup-0.5,'Ice shelf/continent','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(120,yup-0.5,'Continental shelf','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(250,yup-0.5,'Slope','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
text(320,yup-0.5,'Deep ocean','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
% quiver(yy(1:int:end)/1000,5*ones(1,Ny_int),...
%     sig12_xavg(3,1:int:end)/scale_sig12,zeros(1,Ny_int),0.4,'-','filled','Color',olive,'LineWidth',0.5)
hold off;
set(gca,'fontsize',fontsize);
xlim([0 400])
xticks([0 100 200 300 400])
xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
title('Sea ice zonal force balance','FontSize',fontsize+2,'interpreter','latex');
ylabel('(10$^4$ N/m)', 'FontSize', fontsize,'interpreter','latex');
leg4=legend([l1 l2 l4 l3],'Wind stress','Ocean-ice stress',...
    'Internal stress divergence + Residual term','Coriolis force',...
    'interpreter','latex', 'FontSize', fontsize-1);
set(leg4,'position', [0.6695 0.3596 0.3087 0.1097])

print('-dpng','-r180',[figdir expname '.png']);
