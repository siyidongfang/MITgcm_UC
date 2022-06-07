%%%
%%% plot_heat.m
%%%
%%% Plot shoreward heat transport
    
    
    clear;
%     close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;    
    addpath /Users/csi/MITgcm_UC/products_uc/;  
    figdir = '/Users/csi/MITgcm_UC/analysis_uc/figures/';

%     load heatbudget_aofd_Width100km
    load heatbudget_aofd

    fontsize = 17;


    %%
    yy=1:2:399;
    dy = 2000;
%     idx_exps = [2:8 18:20 27:28];
    idx_exps = [2:8];


    figure(1)
    clf;
    set(gcf,'Position',[141    63   685*2   825]);
    subplot(1,2,1)
    plot(yy,Fheat_adv(1,:),'LineWidth',2.5,'color','k')
    hold on;
    plot(yy,Fheat_adv(idx_exps,:),'LineWidth',1.5)
    plot(yy,Feddy_vvelth_xzint(idx_exps,:),'--','LineWidth',1.5)
    plot(yy,Feddy_vvelth_xzint(1,:),'--','LineWidth',2.5,'color','k')
    line([100 100],[-4 4],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',1);
    line([220 220],[-4 4],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',1);
    title('Shoreward heat transport, 2km resolution')
    ylabel('TW')
    xlabel('Latitude, y (km)')
    set(gca,'FontSize',fontsize);
    leg1 = legend('Ref.','Ua-2Va2','Ua-8Va8','Atide0.02','Zn450','Zsb500','dZs50','dZs200','FontSize',fontsize+3);
    set(leg1,'Position',[0.1781 0.1467 0.2628/2 0.2824])
    
    subplot(1,2,2)
    yidx = 1:round(Yshelfbreak/dy)+1;
    plot(yy(yidx),Fheat_adv(1,yidx),'LineWidth',2.5,'color','k')
    hold on;
    plot(yy(yidx),Fheat_adv(idx_exps,yidx),'LineWidth',1.5)
    plot(yy(yidx),Feddy_vvelth_xzint(idx_exps,yidx),'--','LineWidth',1.5)
    plot(yy(yidx),Feddy_vvelth_xzint(1,yidx),'--','LineWidth',2.5,'color','k')
    line([100 100],[-3 0.5],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',1);
    line([220 220],[-3 0.5],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',1);
    title('Zoom in. Solid = F_{total}, dashed = F_{eddy}')
    ylabel('TW')
    xlabel('Latitude, y (km)')
    set(gca,'FontSize',fontsize);
    legend('Ref.','Ua-2Va2','Ua-8Va8','Atide0.02','Zn450','Zsb500','dZs50','dZs200','FontSize',fontsize+3)
    print('-dpng','-r150',[figdir 'Fheat_group1.png']);



    %%

    figure(2)
    clf;
    yy=1:2:399;
    yy_5km = 2.5:5:397.5;
    yy_10km = 5:400/39:395;
    set(gcf,'Position',[141    63   685   825]);
    plot(yy,Fheat_adv(2,:),'LineWidth',2.5,'color','r')
    hold on;
    plot(yy,Fheat_adv(1,:),'LineWidth',2.5,'color','k')
    plot(yy,Fheat_adv(3,:),'LineWidth',2.5,'color','b')
    
    plot(yy_5km,Fheat_adv(9,1:80),'--','LineWidth',1.5,'color','r')
    plot(yy_5km,Fheat_adv(10,1:80),'--','LineWidth',1.5,'color','k')
    plot(yy_5km,Fheat_adv(11,1:80),'--','LineWidth',1.5,'color','b')

    plot(yy_10km,Fheat_adv(12,1:39),':','LineWidth',1.5,'color','r')
    plot(yy_10km,Fheat_adv(13,1:39),':','LineWidth',1.5,'color','k')
    plot(yy_10km,Fheat_adv(14,1:39),':','LineWidth',1.5,'color','b')
    plot(yy,zeros(1,200),':','LineWidth',1,'color','k')
    line([100 100],[-7 4],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',1);
    line([220 220],[-7 4],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',1);
    ylabel('TW')
    xlabel('Latitude, y (km)')
    set(gca,'FontSize',fontsize);
    leg1 = legend('2km, Ua-2Va2','2km, Ua-5Va5','2km, Ua-8Va8',...
        '5km, Ua-2Va2','5km, Ua-5Va5','5km, Ua-8Va8',...
        '10km, Ua-2Va2','10km, Ua-5Va5','10km, Ua-8Va8','FontSize',fontsize+3);
    title('Shoreward heat transport, with ice shelf','FontSize',fontsize+3)
    set(leg1,'Position',[0.1781 0.1467 0.2628 0.2824])

    print('-dpng','-r150',[figdir 'Fheat_group2.png']);




    %%

    figure(3)
    clf;
    yy=1:2:399;
    yy_5km = 2.5:5:397.5;
    yy_10km = 5:400/39:395;
    set(gcf,'Position',[141    63   685   825]);
    plot(yy,Fheat_adv(18,:),'LineWidth',2.5,'color','r')
    hold on;
    plot(yy,Fheat_adv(19,:),'LineWidth',2.5,'color','k')
    plot(yy,Fheat_adv(20,:),'LineWidth',2.5,'color','b')
    
    plot(yy_5km,Fheat_adv(21,1:80),'--','LineWidth',1.5,'color','r')
    plot(yy_5km,Fheat_adv(22,1:80),'--','LineWidth',1.5,'color','k')
    plot(yy_5km,Fheat_adv(23,1:80),'--','LineWidth',1.5,'color','b')

    plot(yy_10km,Fheat_adv(24,1:39),':','LineWidth',1.5,'color','r')
    plot(yy_10km,Fheat_adv(25,1:39),':','LineWidth',1.5,'color','k')
    plot(yy_10km,Fheat_adv(26,1:39),':','LineWidth',1.5,'color','b')

    plot(yy,zeros(1,200),':','LineWidth',1,'color','k')
    line([100 100],[-3 3],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',1);
    line([220 220],[-3 3],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',1);
    ylabel('TW')
    xlabel('Latitude, y (km)')
    set(gca,'FontSize',fontsize);
    leg1 = legend('2km, 4.15m/yr (76Gt/yr)','2km, 12.45m/yr (229Gt/yr)','2km, 20.75m/yr (382Gt/yr)',...
        '5km, 4.15m/yr (76Gt/yr)','5km, 12.45m/yr (229Gt/yr)','5km, 20.75m/yr (382Gt/yr)',...
        '10km, 4.15m/yr (76Gt/yr)','10km, 12.45m/yr (229Gt/yr)','10km, 20.75m/yr (382Gt/yr)','FontSize',fontsize+3);
    title('Shoreward heat transport (prescribed melt water)','FontSize',fontsize+3)
    set(leg1,'Position',[0.1460 0.6315 0.4190 0.2824])

    print('-dpng','-r150',[figdir 'Fheat_group3.png']);

