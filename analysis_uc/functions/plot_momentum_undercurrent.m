    %%%
    %%% plot_momentum_undercurrent.m
    %%%

   
    %%%% Plot the isopycnal form stress!!!


    load_colors;
    
    yup = 0.05;
    ydown = -0.05;  
    subplotsize = [0.4 0.6];

    %%% All the momentum budget terms
    figure(1)
    clf;  
    set(gcf,'Position',[83 183 1100 600]);
    ax1 = subplot('position',[0.08 0.3 subplotsize]);

    l0 = plot(yy(yidx)/1000,-totalchange_tendency/length_int,'LineWidth',4,'color',[0.7 0.7 0.7]);
    hold on;
    l2 = plot(yy(yidx)/1000,Um_Ext_xzint/length_int,'LineWidth',2,'Color',brown);
    l3 = plot(yy(yidx)/1000,Um_Advec_xzint/length_int,'LineWidth',2,'Color',green);
    l4 = plot(yy(yidx)/1000,Um_dPhiX_xzint/length_int,'LineWidth',2,'Color',yellow);
    l5 = plot(yy(yidx)/1000,Um_Diss_xzint/length_int,'LineWidth',2,'Color',purple);
    l20 = plot(yy(yidx)/1000,zeros(1,size(yy(yidx),2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
    line([Ycoast/m1km Ycoast/m1km],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Yshelfbreak/m1km Yshelfbreak/m1km],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Ydeep/m1km Ydeep/m1km],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    hold off;
    set(gca,'fontsize',fontsize);
    xlim([Ymin Ymax]/m1km)
    ylim([ydown yup]);
    ylabel('(N/m$^2$)', 'FontSize', fontsize,'interpreter','latex');
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    grid on;grid minor;
    title('Undercurrent zonal force balance','FontSize',fontsize+2,'interpreter','latex');
    leg1 = legend([l2 l3 l4 l5 l0],...
        'Ice-ocean stress',...
        'Ocean advection',...
        'Pressure gradient force',...
        'Bottom frictional stress',...
        'Residual term', 'FontSize', fontsize-1,'interpreter','latex');
    set(leg1,'position', [0.1736 0.0305 0.1873 0.1700])
    legend boxon;


    %%% All the ageostrophic momentum budget terms
    ax2 = subplot('position',[0.58 0.3 subplotsize]);
    l0 = plot(yy(yidx)/1000,-totalchange_tendency/length_int,'LineWidth',4,'color',[0.7 0.7 0.7]);
    hold on;
    l1 = plot(yy(yidx)/1000,Um_Ext_xzint/length_int,'LineWidth',2,'Color',brown);
    l2 = plot(yy(yidx)/1000,Um_Diss_xzint/length_int,'LineWidth',2,'Color',purple);
    l3 = plot(yy(yidx)/1000,(Um_dPhiX_xzint+Um_Advec_xzint)/length_int,'LineWidth',2,'Color',green);
    l20 = plot(yy(yidx)/1000,zeros(1,size(yy(yidx),2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
    line([Ycoast/m1km Ycoast/m1km],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Yshelfbreak/m1km Yshelfbreak/m1km],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Ydeep/m1km Ydeep/m1km],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    hold off;
    set(gca,'fontsize',fontsize);
    xlim([Ymin Ymax]/m1km)
    ylim([ydown yup]/5);
    ylabel('(N/m$^2$)', 'FontSize', fontsize,'interpreter','latex');
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    grid on;grid minor;
    title('Undercurrent ageostrophic zonal force balance','FontSize',fontsize+2,'interpreter','latex');
    leg2 = legend([l1 l2 l3 l0],...
        'Ice-ocean stress',...
        'Bottom frictional stress',...
        'PGF+Advection',...
        'Residual term', 'FontSize', fontsize-1,'interpreter','latex');
    set(leg2,'position', [0.6791 0.0569 0.1873 0.1372])
    legend boxon;


