
% clear;close all

    addpath /data/MITgcm_ASF-csi/utils/matlab/; 
    addpath /data/MITgcm_ASF-csi/analysis/;
    addpath /data/MITgcm_ASF-csi/newexp/;
    addpath /data/MITgcm_ASF-csi/analysis/colormaps/;
    addpath  /data/MITgcm_ASF-csi/analysis/jpo_analysis;
    prodir = '/data/MITgcm_ASF-csi/products-hires/'
    expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments';
    

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
    darkgray = [150 150 150]/255;

    nbuoy = 25:30;
    buoy = [-1.076 -0.620 -0.207 0.000 0.204 0.409];

    load([prodir 'IFS/calcFeddy_batch_new.mat']);

    
%%
    %%% Initialize figure
    figure(1);
    clf;
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 1200 530]);
    set(gcf,'Color','w');

    fontsize = 13;
    lw = 1.5;
    sz = 35;

        
    panelwidth = 0.28;
    panelbottom = 0.09;
    
ax1 = subplot('position',[0.055 panelbottom panelwidth 0.715]);
annotation('textbox',[0.05 panelbottom 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize,'LineStyle','None');
    p1 = plot(normalized_transient_slope_batch(27,:),-zz,'color','k','LineWidth',lw);
    hold on;
    p2 = plot(normalized_transient_slope_batch(25,:),-zz,'color',blue,'LineWidth',lw);
    p3 = plot(normalized_transient_slope_batch(26,:),-zz,'color',green,'LineWidth',lw);
    p4 = plot(normalized_transient_slope_batch(28,:),-zz,'color',yellow,'LineWidth',lw);
    p5 = plot(normalized_transient_slope_batch(29,:),-zz,'color',orange,'LineWidth',lw);
    p6 = plot(normalized_transient_slope_batch(30,:),-zz,'color',brown,'LineWidth',lw);

    hold off;
    ylim([100 845]); 
    xlim([-0.8 0.6])
    axis ij;
    annotation('textbox',[0.085 0.985 panelwidth 0.01],'String',{'Normalized transient eddy','  vertical momentum flux'},'FontSize',fontsize+2,'LineStyle','None','interpreter','latex');
    ylabel('Depth (m)','FontSize', fontsize,'interpreter','latex');
    title( '$\Big<\rho_0\big(f\frac{\beta\overline{v^{\prime}S^{\prime}}-\alpha\overline{v^{\prime}\theta^{\prime}}}{\beta\partial_z \overline{S} - \alpha\partial_z \overline{T}}-\overline{u^\prime w^\prime}\big)\big/\overline{\tau_\mathrm{ai}^x}\Big>$',...
        'FontSize', fontsize+2,'interpreter','latex')


       
ax2 = subplot('position',[0.38 panelbottom panelwidth 0.715]);
annotation('textbox',[0.375 panelbottom 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize,'LineStyle','None');
  
    p1 = plot(normalized_standing_slope_batch(27,:),-zz,'color','k','LineWidth',lw);
    hold on;
    p2 = plot(normalized_standing_slope_batch(25,:),-zz,'color',blue,'LineWidth',lw);
    p3 = plot(normalized_standing_slope_batch(26,:),-zz,'color',green,'LineWidth',lw);
    p4 = plot(normalized_standing_slope_batch(28,:),-zz,'color',yellow,'LineWidth',lw);
    p5 = plot(normalized_standing_slope_batch(29,:),-zz,'color',orange,'LineWidth',lw);
    p6 = plot(normalized_standing_slope_batch(30,:),-zz,'color',brown,'LineWidth',lw);
    hold off;
    ylim([100 845]); 
    xlim([-0.2 0.1])
    axis ij;
    annotation('textbox',[0.41 0.985 panelwidth 0.01],'String',{'Normalized standing eddy','  vertical momentum flux'},'FontSize',fontsize+2,'LineStyle','None','interpreter','latex');
    title( '$\Big<\rho_0\big(f\frac{\beta v^\dagger S^\dagger - \alpha v^\dagger \theta^\dagger}{\beta\partial_z \overline{S} - \alpha\partial_z \overline{T}}- u^\dagger w^\dagger\big)\big/\overline{\tau_\mathrm{ai}^x}\Big>$',...
            'FontSize', fontsize+2,'interpreter','latex')

ax3 = subplot('position',[0.705 panelbottom panelwidth 0.8]);
annotation('textbox',[0.7 panelbottom 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize,'LineStyle','None');
    p1 = plot(uo_slope_batch(27,:),-zz,'color','k','LineWidth',lw);
    hold on;
    p2 = plot(uo_slope_batch(25,:),-zz,'color',blue,'LineWidth',lw);
    p3 = plot(uo_slope_batch(26,:),-zz,'color',green,'LineWidth',lw);
    p4 = plot(uo_slope_batch(28,:),-zz,'color',yellow,'LineWidth',lw);
    p5 = plot(uo_slope_batch(29,:),-zz,'color',orange,'LineWidth',lw);
    p6 = plot(uo_slope_batch(30,:),-zz,'color',brown,'LineWidth',lw);
    s1 = plot(ui_slope_batch(27).*ones(1,70),-zz,'--','color','k','LineWidth',lw);
    s2 = plot(ui_slope_batch(25).*ones(1,70),-zz,'--','color',blue,'LineWidth',lw);
    s3 = plot(ui_slope_batch(26).*ones(1,70),-zz,'--','color',green,'LineWidth',lw);
    s4 = plot(ui_slope_batch(28).*ones(1,70),-zz,'--','color',yellow,'LineWidth',lw);
    s5 = plot(ui_slope_batch(29).*ones(1,70),-zz,'--','color',orange,'LineWidth',lw);
    s6 = plot(ui_slope_batch(30).*ones(1,70),-zz,'--','color',brown,'LineWidth',lw);
    z_ui = zeros(30,1);
    s1 = scatter(ui_slope_batch(27),z_ui(27),sz,'k','o','filled'); 
    s1 = scatter(ui_slope_batch(25),z_ui(25),sz,blue,'o','filled'); 
    s1 = scatter(ui_slope_batch(26),z_ui(26),sz,green,'o','filled'); 
    s1 = scatter(ui_slope_batch(28),z_ui(28),sz,yellow,'o','filled'); 
    s1 = scatter(ui_slope_batch(29),z_ui(29),sz,orange,'o','filled'); 
    s1 = scatter(ui_slope_batch(30),z_ui(30),sz,brown,'o','filled'); 
    hold off;
    ylim([0 890]); 
    xlim([-0.35 0.08])
    axis ij;
    title('Zonal velocities $\Big<u_\mathrm{o}\Big>$ and $\Big<u_\mathrm{i}\Big>$','FontSize', fontsize+2,'interpreter','latex');
    xlabel( '$(m/s)$',...
            'FontSize', fontsize,'interpreter','latex')

leg1 = legend([p2 p3 p1 p4 p5 p6],...
    '$\Delta\sigma_4$=--1.076 $\mathrm{kg/m^3}$',...
    '$\Delta\sigma_4$=--0.620 $\mathrm{kg/m^3}$',...
    '$\Delta\sigma_4$=--0.207 $\mathrm{kg/m^3}$(Ref.)',...
    '$\Delta\sigma_4$=0.000 $\mathrm{kg/m^3}$',...
    '$\Delta\sigma_4$=0.204 $\mathrm{kg/m^3}$',...
    '$\Delta\sigma_4$=0.409 $\mathrm{kg/m^3}$','FontSize', fontsize-2,'interpreter','latex');
set(leg1,'position',[0.3834 0.5811 0.1771 0.2115])
legend boxoff                
        

print('-dpng','-r150','Feddy_ifs_deltaS_normalized.png');
       
        
%         %%
%         
% %%% Initialize figure
%     figure(2);
%     clf;
%     scrsz = get(0,'ScreenSize');
%     set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 1200 530]);
%     set(gcf,'Color','w');
% 
%     fontsize = 13;
%     lw = 1.5;
%     sz = 35;
% 
%         
%     panelwidth = 0.28;
%     panelbottom = 0.09;
%     
% ax1 = subplot('position',[0.05 panelbottom panelwidth 0.715]);
% annotation('textbox',[0.05 panelbottom 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize,'LineStyle','None');
%     p1 = plot(-uw_transient_slope_batch(20,:),-zz,'color','k','LineWidth',lw);
%     hold on;
%     p2 = plot(-uw_transient_slope_batch(21,:),-zz,'color',blue,'LineWidth',lw);
%     p3 = plot(-uw_transient_slope_batch(22,:),-zz,'color',green,'LineWidth',lw);
%     p4 = plot(-uw_transient_slope_batch(23,:),-zz,'color',yellow,'LineWidth',lw);
%     p5 = plot(-uw_transient_slope_batch(24,:),-zz,'color',orange,'LineWidth',lw);
%     hold off;
%     ylim([100 890]); 
%     axis ij;
%     title('$\Big<-\overline{u^\prime w^\prime}\Big>$',...
%             'FontSize', fontsize+2,'interpreter','latex');
%     ylabel('Depth (m)','FontSize', fontsize,'interpreter','latex');
% 
% leg1 = legend([p1 p2 p3 p4 p5],...
%     '$W_s=50$ km (Ref.)',...
%     '$W_s=100$ km',...
%     '$W_s=150$ km',...
%     '$W_s=200$ km',...
%     '$W_s=250$ km', 'FontSize', fontsize-1,'interpreter','latex');
% set(leg1,'position',[0.0639 0.6006 0.1522 0.1925])
% legend boxoff                
% 
% 
%        
% ax2 = subplot('position',[0.375 panelbottom panelwidth 0.715]);
% annotation('textbox',[0.375 panelbottom 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize,'LineStyle','None');
%   
%     p1 = plot(-uw_standing_slope_batch(20,:),-zz,'color','k','LineWidth',lw);
%     hold on;
%     p2 = plot(-uw_standing_slope_batch(21,:),-zz,'color',blue,'LineWidth',lw);
%     p3 = plot(-uw_standing_slope_batch(22,:),-zz,'color',green,'LineWidth',lw);
%     p4 = plot(-uw_standing_slope_batch(23,:),-zz,'color',yellow,'LineWidth',lw);
%     p5 = plot(-uw_standing_slope_batch(24,:),-zz,'color',orange,'LineWidth',lw);
%     hold off;
%     ylim([100 890]); 
%     axis ij;
%     title('$\Big<- u^\dagger w^\dagger\Big>$',...
%         'FontSize', fontsize+1,'interpreter','latex');
% % 
% % ax3 = subplot('position',[0.7 panelbottom panelwidth 0.8]);
% % annotation('textbox',[0.7 panelbottom 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize,'LineStyle','None');
% %     p1 = plot(uo_slope_batch(20,:),-zz,'color','k','LineWidth',lw);
% %     hold on;
% %     p2 = plot(uo_slope_batch(21,:),-zz,'color',blue,'LineWidth',lw);
% %     p3 = plot(uo_slope_batch(22,:),-zz,'color',green,'LineWidth',lw);
% %     p4 = plot(uo_slope_batch(23,:),-zz,'color',yellow,'LineWidth',lw);
% %     p5 = plot(uo_slope_batch(24,:),-zz,'color',orange,'LineWidth',lw);
% %     s1 = plot(ui_slope_batch(20).*ones(1,70),-zz,'--','color','k','LineWidth',lw);
% %     s2 = plot(ui_slope_batch(21).*ones(1,70),-zz,'--','color',blue,'LineWidth',lw);
% %     s3 = plot(ui_slope_batch(22).*ones(1,70),-zz,'--','color',green,'LineWidth',lw);
% %     s4 = plot(ui_slope_batch(23).*ones(1,70),-zz,'--','color',yellow,'LineWidth',lw);
% %     s5 = plot(ui_slope_batch(24).*ones(1,70),-zz,'--','color',orange,'LineWidth',lw);
% %     z_ui = zeros(30,1);
% %     s1 = scatter(ui_slope_batch(20),z_ui(20),sz,'k','o','filled'); 
% %     s1 = scatter(ui_slope_batch(21),z_ui(21),sz,blue,'o','filled'); 
% %     s1 = scatter(ui_slope_batch(22),z_ui(22),sz,green,'o','filled'); 
% %     s1 = scatter(ui_slope_batch(23),z_ui(23),sz,yellow,'o','filled'); 
% %     s1 = scatter(ui_slope_batch(24),z_ui(24),sz,orange,'o','filled'); 
% %     hold off;
% %     ylim([0 890]); 
% %     axis ij;
% %     title('Zonal velocities $\Big<u_\mathrm{o}\Big>$ and $\Big<u_\mathrm{i}\Big>$','FontSize', fontsize+2,'interpreter','latex');
% %     xlabel( '$(m/s)$',...
% %             'FontSize', fontsize,'interpreter','latex')
% % 
% % 
% %         
%         %%
%         
%     %%% Initialize figure
%     figure(3);
%     clf;
%     scrsz = get(0,'ScreenSize');
%     set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 1200 530]);
%     set(gcf,'Color','w');
% 
%     fontsize = 13;
%     lw = 1.5;
%     sz = 35;
% 
%         
%     panelwidth = 0.28;
%     panelbottom = 0.09;
%     
% ax1 = subplot('position',[0.05 panelbottom panelwidth 0.715]);
% annotation('textbox',[0.05 panelbottom 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize,'LineStyle','None');
%     p1 = plot(IFS_transient_Estimate_slope_batch(20,:),-zz,'color','k','LineWidth',lw);
%     hold on;
%     p2 = plot(IFS_transient_Estimate_slope_batch(21,:),-zz,'color',blue,'LineWidth',lw);
%     p3 = plot(IFS_transient_Estimate_slope_batch(22,:),-zz,'color',green,'LineWidth',lw);
%     p4 = plot(IFS_transient_Estimate_slope_batch(23,:),-zz,'color',yellow,'LineWidth',lw);
%     p5 = plot(IFS_transient_Estimate_slope_batch(24,:),-zz,'color',orange,'LineWidth',lw);
%     hold off;
%     ylim([100 890]); 
%     axis ij;
%     annotation('textbox',[0.085 0.985 panelwidth 0.01],'String',{'Transient eddy form stress'},'FontSize',fontsize+2,'LineStyle','None','interpreter','latex');
%     title('$\Big<f\frac{{\displaystyle\rho_0(\beta\overline{v^{\prime}S^{\prime}}-\alpha\overline{v^{\prime}\theta^{\prime}})}}{{\displaystyle\partial_z \overline{\gamma}^t}}\Big>$',...
%             'FontSize', fontsize+2,'interpreter','latex');
%     ylabel('Depth (m)','FontSize', fontsize,'interpreter','latex');
%     xlabel( '$(m^2/s^2)$','FontSize', fontsize,'interpreter','latex')
% leg1 = legend([p1 p2 p3 p4 p5],...
%     '$W_s=50$ km (Ref.)',...
%     '$W_s=100$ km',...
%     '$W_s=150$ km',...
%     '$W_s=200$ km',...
%     '$W_s=250$ km', 'FontSize', fontsize-1,'interpreter','latex');
% set(leg1,'position',[0.0639 0.6006 0.1522 0.1925])
% legend boxoff                
% 
% 
%        
% ax2 = subplot('position',[0.375 panelbottom panelwidth 0.715]);
% annotation('textbox',[0.375 panelbottom 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize,'LineStyle','None');
%   
%     p1 = plot(IFS_standing_Estimate_slope_batch(20,:),-zz,'color','k','LineWidth',lw);
%     hold on;
%     p2 = plot(IFS_standing_Estimate_slope_batch(21,:),-zz,'color',blue,'LineWidth',lw);
%     p3 = plot(IFS_standing_Estimate_slope_batch(22,:),-zz,'color',green,'LineWidth',lw);
%     p4 = plot(IFS_standing_Estimate_slope_batch(23,:),-zz,'color',yellow,'LineWidth',lw);
%     p5 = plot(IFS_standing_Estimate_slope_batch(24,:),-zz,'color',orange,'LineWidth',lw);
%     hold off;
%     ylim([100 890]); 
%     axis ij;
%         annotation('textbox',[0.41 0.985 panelwidth 0.01],'String',{'Standing eddy form stress'},'FontSize',fontsize+2,'LineStyle','None','interpreter','latex');
%     title('$\Big<f\frac{{\displaystyle\rho_0(\beta v^\dagger S^\dagger - \alpha v^\dagger \theta^\dagger)}}{{\displaystyle\partial_z \overline{\gamma}^t}} \Big>$',...
%         'FontSize', fontsize+1,'interpreter','latex');
%     xlabel( '$(m^2/s^2)$','FontSize', fontsize,'interpreter','latex')
% % 
% % ax3 = subplot('position',[0.7 panelbottom panelwidth 0.8]);
% % annotation('textbox',[0.7 panelbottom 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize,'LineStyle','None');
% %     p1 = plot(uo_slope_batch(20,:),-zz,'color','k','LineWidth',lw);
% %     hold on;
% %     p2 = plot(uo_slope_batch(21,:),-zz,'color',blue,'LineWidth',lw);
% %     p3 = plot(uo_slope_batch(22,:),-zz,'color',green,'LineWidth',lw);
% %     p4 = plot(uo_slope_batch(23,:),-zz,'color',yellow,'LineWidth',lw);
% %     p5 = plot(uo_slope_batch(24,:),-zz,'color',orange,'LineWidth',lw);
% %     s1 = plot(ui_slope_batch(20).*ones(1,70),-zz,'--','color','k','LineWidth',lw);
% %     s2 = plot(ui_slope_batch(21).*ones(1,70),-zz,'--','color',blue,'LineWidth',lw);
% %     s3 = plot(ui_slope_batch(22).*ones(1,70),-zz,'--','color',green,'LineWidth',lw);
% %     s4 = plot(ui_slope_batch(23).*ones(1,70),-zz,'--','color',yellow,'LineWidth',lw);
% %     s5 = plot(ui_slope_batch(24).*ones(1,70),-zz,'--','color',orange,'LineWidth',lw);
% %     z_ui = zeros(30,1);
% %     s1 = scatter(ui_slope_batch(20),z_ui(20),sz,'k','o','filled'); 
% %     s1 = scatter(ui_slope_batch(21),z_ui(21),sz,blue,'o','filled'); 
% %     s1 = scatter(ui_slope_batch(22),z_ui(22),sz,green,'o','filled'); 
% %     s1 = scatter(ui_slope_batch(23),z_ui(23),sz,yellow,'o','filled'); 
% %     s1 = scatter(ui_slope_batch(24),z_ui(24),sz,orange,'o','filled'); 
% %     hold off;
% %     ylim([0 890]); 
% %     axis ij;
% %     title('Zonal velocities $\Big<u_\mathrm{o}\Big>$ and $\Big<u_\mathrm{i}\Big>$','FontSize', fontsize+2,'interpreter','latex');
% %     xlabel( '$(m/s)$','FontSize', fontsize,'interpreter','latex')
% % 
% %     
%     %%
%     %%% Initialize figure
%     figure(4);
%     clf;
%     scrsz = get(0,'ScreenSize');
%     set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 1200 530]);
%     set(gcf,'Color','w');
% 
%     fontsize = 13;
%     lw = 1.5;
%     sz = 35;
% 
%         
%     panelwidth = 0.28;
%     panelbottom = 0.09;
%     
% ax1 = subplot('position',[0.05 panelbottom panelwidth 0.715]);
% annotation('textbox',[0.05 panelbottom 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize,'LineStyle','None');
%     p1 = plot(transient_slope_batch(20,:),-zz,'color','k','LineWidth',lw);
%     hold on;
%     p2 = plot(transient_slope_batch(21,:),-zz,'color',blue,'LineWidth',lw);
%     p3 = plot(transient_slope_batch(22,:),-zz,'color',green,'LineWidth',lw);
%     p4 = plot(transient_slope_batch(23,:),-zz,'color',yellow,'LineWidth',lw);
%     p5 = plot(transient_slope_batch(24,:),-zz,'color',orange,'LineWidth',lw);
%     hold off;
%     ylim([100 890]); 
%     axis ij;
%     annotation('textbox',[0.085 0.985 panelwidth 0.01],'String',{'$\ \ \ \ \ \ \ $Transient eddy','  vertical momentum flux'},'FontSize',fontsize+2,'LineStyle','None','interpreter','latex');
%     title('$\Big<f\frac{{\displaystyle\rho_0(\beta\overline{v^{\prime}S^{\prime}}-\alpha\overline{v^{\prime}\theta^{\prime}})}}{{\displaystyle\partial_z \overline{\gamma}^t}}-\overline{u^\prime w^\prime}\Big>$',...
%             'FontSize', fontsize+2,'interpreter','latex');
%     ylabel('Depth (m)','FontSize', fontsize,'interpreter','latex');
%     xlabel( '$(m^2/s^2)$','FontSize', fontsize,'interpreter','latex')
% 
% 
% 
%        
% ax2 = subplot('position',[0.375 panelbottom panelwidth 0.715]);
% annotation('textbox',[0.375 panelbottom 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize,'LineStyle','None');
%   
%     p1 = plot(standing_slope_batch(20,:),-zz,'color','k','LineWidth',lw);
%     hold on;
%     p2 = plot(standing_slope_batch(21,:),-zz,'color',blue,'LineWidth',lw);
%     p3 = plot(standing_slope_batch(22,:),-zz,'color',green,'LineWidth',lw);
%     p4 = plot(standing_slope_batch(23,:),-zz,'color',yellow,'LineWidth',lw);
%     p5 = plot(standing_slope_batch(24,:),-zz,'color',orange,'LineWidth',lw);
%     hold off;
%     ylim([100 890]); 
%     axis ij;
%     annotation('textbox',[0.41 0.985 panelwidth 0.01],'String',{'$\ \ \ \ \ \ \ $Standing eddy','  vertical momentum flux'},'FontSize',fontsize+2,'LineStyle','None','interpreter','latex');
%     title('$\Big<f\frac{{\displaystyle\rho_0(\beta v^\dagger S^\dagger - \alpha v^\dagger \theta^\dagger)}}{{\displaystyle\partial_z \overline{\gamma}^t}}- u^\dagger w^\dagger\Big>$',...
%         'FontSize', fontsize+1,'interpreter','latex');
%     xlabel( '$(m^2/s^2)$','FontSize', fontsize,'interpreter','latex')
% 
% leg1 = legend([p1 p2 p3 p4 p5],...
%     '$W_s=50$ km',...
%     '$W_s=100$ km',...
%     '$W_s=150$ km',...
%     '$W_s=200$ km',...
%     '$W_s=250$ km', 'FontSize', fontsize-1,'interpreter','latex');
% set(leg1,'position',[0.3656 0.2723 0.1522 0.1925])
% legend boxoff                
% 
% % 
% % ax3 = subplot('position',[0.7 panelbottom panelwidth 0.8]);
% % annotation('textbox',[0.7 panelbottom 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize,'LineStyle','None');
% %     p1 = plot(uo_slope_batch(20,:),-zz,'color','k','LineWidth',lw);
% %     hold on;
% %     p2 = plot(uo_slope_batch(21,:),-zz,'color',blue,'LineWidth',lw);
% %     p3 = plot(uo_slope_batch(22,:),-zz,'color',green,'LineWidth',lw);
% %     p4 = plot(uo_slope_batch(23,:),-zz,'color',yellow,'LineWidth',lw);
% %     p5 = plot(uo_slope_batch(24,:),-zz,'color',orange,'LineWidth',lw);
% %     s1 = plot(ui_slope_batch(20).*ones(1,70),-zz,'--','color','k','LineWidth',lw);
% %     s2 = plot(ui_slope_batch(21).*ones(1,70),-zz,'--','color',blue,'LineWidth',lw);
% %     s3 = plot(ui_slope_batch(22).*ones(1,70),-zz,'--','color',green,'LineWidth',lw);
% %     s4 = plot(ui_slope_batch(23).*ones(1,70),-zz,'--','color',yellow,'LineWidth',lw);
% %     s5 = plot(ui_slope_batch(24).*ones(1,70),-zz,'--','color',orange,'LineWidth',lw);
% %     z_ui = zeros(30,1);
% %     s1 = scatter(ui_slope_batch(20),z_ui(20),sz,'k','o','filled'); 
% %     s1 = scatter(ui_slope_batch(21),z_ui(21),sz,blue,'o','filled'); 
% %     s1 = scatter(ui_slope_batch(22),z_ui(22),sz,green,'o','filled'); 
% %     s1 = scatter(ui_slope_batch(23),z_ui(23),sz,yellow,'o','filled'); 
% %     s1 = scatter(ui_slope_batch(24),z_ui(24),sz,orange,'o','filled'); 
% %     hold off;
% %     ylim([0 890]); 
% %     axis ij;
% %     title('Zonal velocities $\Big<u_\mathrm{o}\Big>$ and $\Big<u_\mathrm{i}\Big>$','FontSize', fontsize+2,'interpreter','latex');
% %     xlabel( '$(m/s)$',...
% %             'FontSize', fontsize,'interpreter','latex')
% % 
% % 
% %         
% %       %%

%%
    %%% Initialize figure
    figure(5);
    clf;
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.25*scrsz(3) 0.15*scrsz(4) 600 530]);
    set(gcf,'Color','w');

    fontsize = 13;
    lw = 1.5;
    sz = 35;

        
    panelwidth = 0.55;
    panelbottom = 0.09;
    
ax1 = subplot('position',[0.105 panelbottom panelwidth 0.715]);
annotation('textbox',[0.1 panelbottom 0.05 0.05],'String','(a)','interpreter','latex','FontSize',fontsize,'LineStyle','None');
    p1 = plot(normalized_transient_slope_batch(20,:)+normalized_standing_slope_batch(20,:),-zz,'color','k','LineWidth',lw);
    hold on;
    p2 = plot(normalized_transient_slope_batch(21,:)+normalized_standing_slope_batch(21,:),-zz,'color',blue,'LineWidth',lw);
    p3 = plot(normalized_transient_slope_batch(22,:)+normalized_standing_slope_batch(22,:),-zz,'color',green,'LineWidth',lw);
    p4 = plot(normalized_transient_slope_batch(23,:)+normalized_standing_slope_batch(23,:),-zz,'color',yellow,'LineWidth',lw);
    p5 = plot(normalized_transient_slope_batch(24,:)+normalized_standing_slope_batch(24,:),-zz,'color',orange,'LineWidth',lw);
    hold off;
    ylim([100 845]); 
    axis ij;
%     annotation('textbox',[0.085 0.985 panelwidth 0.01],'String',{'Standing+transient: IFS and -uw'},'FontSize',fontsize+2,'LineStyle','None','interpreter','latex');
%     title('$\Big<f\frac{{\displaystyle\rho_0(\beta\overline{v^{\prime}S^{\prime}}-\alpha\overline{v^{\prime}\theta^{\prime}})}}{{\displaystyle\partial_z \overline{\gamma}^t}}-\overline{u^\prime w^\prime}\Big>$',...
%             'FontSize', fontsize+2,'interpreter','latex');
    title({'Normalized vertical momentum flux:', 'transient eddy + standing eddy'},'FontSize', fontsize+2,'interpreter','latex')
    ylabel('Depth (m)','FontSize', fontsize,'interpreter','latex');

leg1 = legend([p1 p2 p3 p4 p5],...
    '$W_s=50$ km (Ref.)',...
    '$W_s=100$ km',...
    '$W_s=150$ km',...
    '$W_s=200$ km',...
    '$W_s=250$ km', 'FontSize', fontsize-1,'interpreter','latex');
set(leg1,'position', [0.6650 0.1195 0.3401 0.2151])
legend boxoff                

% print('-dpng','-r150','Feddy_standing+transient.png');

% % 
% % 
% %        
% % ax2 = subplot('position',[0.375 panelbottom panelwidth 0.715]);
% % annotation('textbox',[0.375 panelbottom 0.05 0.05],'String','(b)','interpreter','latex','FontSize',fontsize,'LineStyle','None');
% %   
% %     p1 = plot(IFS_transient_Estimate_slope_batch(20,:)+IFS_standing_Estimate_slope_batch(20,:),-zz,'color','k','LineWidth',lw);
% %     hold on;
% %     p2 = plot(IFS_transient_Estimate_slope_batch(21,:)+IFS_standing_Estimate_slope_batch(21,:),-zz,'color',blue,'LineWidth',lw);
% %     p3 = plot(IFS_transient_Estimate_slope_batch(22,:)+IFS_standing_Estimate_slope_batch(22,:),-zz,'color',green,'LineWidth',lw);
% %     p4 = plot(IFS_transient_Estimate_slope_batch(23,:)+IFS_standing_Estimate_slope_batch(23,:),-zz,'color',yellow,'LineWidth',lw);
% %     p5 = plot(IFS_transient_Estimate_slope_batch(24,:)+IFS_standing_Estimate_slope_batch(24,:),-zz,'color',orange,'LineWidth',lw);
% %     hold off;
% %     ylim([100 890]); 
% %     axis ij;
% %     annotation('textbox',[0.41 0.985 panelwidth 0.01],'String',{'Standing + transient: IFS only'},'FontSize',fontsize+2,'LineStyle','None','interpreter','latex');
% % %     title('$\Big<f\frac{{\displaystyle\rho_0(\beta v^\dagger S^\dagger - \alpha v^\dagger \theta^\dagger)}}{{\displaystyle\partial_z \overline{\gamma}^t}}- u^\dagger w^\dagger\Big>$',...
% % %         'FontSize', fontsize+1,'interpreter','latex');
% % 
% % ax3 = subplot('position',[0.7 panelbottom panelwidth 0.8]);
% % annotation('textbox',[0.7 panelbottom 0.05 0.05],'String','(c)','interpreter','latex','FontSize',fontsize,'LineStyle','None');
% %     p1 = plot(uo_slope_batch(20,:),-zz,'color','k','LineWidth',lw);
% %     hold on;
% %     p2 = plot(uo_slope_batch(21,:),-zz,'color',blue,'LineWidth',lw);
% %     p3 = plot(uo_slope_batch(22,:),-zz,'color',green,'LineWidth',lw);
% %     p4 = plot(uo_slope_batch(23,:),-zz,'color',yellow,'LineWidth',lw);
% %     p5 = plot(uo_slope_batch(24,:),-zz,'color',orange,'LineWidth',lw);
% %     s1 = plot(ui_slope_batch(20).*ones(1,70),-zz,'--','color','k','LineWidth',lw);
% %     s2 = plot(ui_slope_batch(21).*ones(1,70),-zz,'--','color',blue,'LineWidth',lw);
% %     s3 = plot(ui_slope_batch(22).*ones(1,70),-zz,'--','color',green,'LineWidth',lw);
% %     s4 = plot(ui_slope_batch(23).*ones(1,70),-zz,'--','color',yellow,'LineWidth',lw);
% %     s5 = plot(ui_slope_batch(24).*ones(1,70),-zz,'--','color',orange,'LineWidth',lw);
% %     z_ui = zeros(30,1);
% %     s1 = scatter(ui_slope_batch(20),z_ui(20),sz,'k','o','filled'); 
% %     s1 = scatter(ui_slope_batch(21),z_ui(21),sz,blue,'o','filled'); 
% %     s1 = scatter(ui_slope_batch(22),z_ui(22),sz,green,'o','filled'); 
% %     s1 = scatter(ui_slope_batch(23),z_ui(23),sz,yellow,'o','filled'); 
% %     s1 = scatter(ui_slope_batch(24),z_ui(24),sz,orange,'o','filled'); 
% %     hold off;
% %     ylim([0 890]); 
% %     axis ij;
% %     title('Zonal velocities $\Big<u_\mathrm{o}\Big>$ and $\Big<u_\mathrm{i}\Big>$','FontSize', fontsize+2,'interpreter','latex');
% %     xlabel( '$(m/s)$',...
% %             'FontSize', fontsize,'interpreter','latex')
% % 
% % 
% %               
% %         
% %      