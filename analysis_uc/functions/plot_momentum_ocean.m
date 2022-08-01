

    
%%% All the momentum budget terms
    figure(1)
    clf;    
    l0 = plot(yy/1000,-totalchange_tendency/length_int,'LineWidth',4,'color',[0.7 0.7 0.7]);
    hold on;
    l2 = plot(yy/1000,Um_Ext_xzint/length_int,'LineWidth',2,'Color',blue);
    l3 = plot(yy/1000,Um_Advec_xzint/length_int,'LineWidth',2,'Color',green);
    l4 = plot(yy/1000,Um_dPhiX_xzint/length_int,'LineWidth',2,'Color',yellow);
    l5 = plot(yy/1000,Um_Diss_xzint/length_int,'LineWidth',2,'Color',purple);
    l20 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
    line([Ycoast Ycoast],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Yshelfbreak Yshelfbreak],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Ydeep Ydeep],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    text(2,yup-0.05,'Ice shelf/continent','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(120,yup-0.05,'Continental shelf','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(250,yup-0.05,'Slope','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(320,yup-0.05,'Deep ocean','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
    hold off;
    set(gca,'fontsize',fontsize);
    xlim([0 400])
    ylim([ydown yup]);
    ylabel('(N/m$^2$)', 'FontSize', fontsize,'interpreter','latex');
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    xticks([0 100 200 300 400])
    title('Ocean zonal force balance','FontSize',fontsize+2,'interpreter','latex');
    leg1 = legend([l2 l3 l4 l5 l0],...
        'Surface stress (wind or ice shelf)',...
        'Ocean advection',...
        'Pressure gradient force',...
        'Bottom frictional stress',...
        'Residual term', 'FontSize', fontsize-1,'interpreter','latex');
    set(leg1,'position',[0.1296    0.1190    0.4811    0.2429])
    legend boxon;
    print('-dpng','-r180',[figdir 'oce_' expname '.png']);


%%% All the ageostrophic momentum budget terms
    figure(2)
    clf;    
    l0 = plot(yy/1000,-totalchange_tendency/length_int,'LineWidth',4,'color',[0.7 0.7 0.7]);
    hold on;
    l1 = plot(yy/1000,Um_Ext_xzint/length_int,'LineWidth',2,'Color',blue);
    l2 = plot(yy/1000,Um_Diss_xzint/length_int,'LineWidth',2,'Color',purple);
    l3 = plot(yy/1000,(Um_dPhiX_xzint+Um_Advec_xzint)/length_int,'LineWidth',2,'Color',green);
    l20 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
    line([Ycoast Ycoast],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Yshelfbreak Yshelfbreak],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Ydeep Ydeep],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    text(2,0.027,'Ice shelf/continent','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(120,0.027,'Continental shelf','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(250,0.027,'Slope','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(320,0.027,'Deep ocean','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
    hold off;
    set(gca,'fontsize',fontsize);
    xlim([0 400])
    ylim([ydown yup]/20);
    ylabel('(N/m$^2$)', 'FontSize', fontsize,'interpreter','latex');
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    xticks([0 100 200 300 400])
    title('Ageostrophic ocean zonal force balance','FontSize',fontsize+2,'interpreter','latex');
    leg1 = legend([l1 l2 l3 l0],...
        'Surface stress (wind or ice shelf)',...
        'Bottom frictional stress',...
        'PGF+Advection',...
        'Residual term', 'FontSize', fontsize-1,'interpreter','latex');
    set(leg1,'position',[0.1296    0.1190    0.4811    0.2429])
    legend boxon;
    print('-dpng','-r180',[figdir 'oce_ageo_' expname '.png']);



