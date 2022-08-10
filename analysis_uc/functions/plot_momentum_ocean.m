

   
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
    
    yup = 0.8;
    ydown = -0.8;  
    
%%% All the momentum budget terms
    figure(1)
    clf;    
    l0 = plot(yy/1000,-totalchange_tendency/length_int,'LineWidth',4,'color',[0.7 0.7 0.7]);
    hold on;
    l2 = plot(yy/1000,Um_Ext_xzint/length_int,'LineWidth',2,'Color',brown);
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
        'Ice-ocean stress',...
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
    l1 = plot(yy/1000,Um_Ext_xzint/length_int,'LineWidth',2,'Color',brown);
    l2 = plot(yy/1000,Um_Diss_xzint/length_int,'LineWidth',2,'Color',purple);
    l3 = plot(yy/1000,(Um_dPhiX_xzint+Um_Advec_xzint)/length_int,'LineWidth',2,'Color',green);
    l20 = plot(yy/1000,zeros(1,size(yy,2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
    line([Ycoast Ycoast],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Yshelfbreak Yshelfbreak],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Ydeep Ydeep],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    text(2,0.038,'Ice shelf/continent','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(120,0.038,'Continental shelf','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(250,0.038,'Slope','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
    text(320,0.038,'Deep ocean','FontSize',fontsize-2,'Color',[0.5 0.5 0.5],'interpreter','latex');
    hold off;
    set(gca,'fontsize',fontsize);
    xlim([0 400])
    ylim([ydown yup]/20);
    ylabel('(N/m$^2$)', 'FontSize', fontsize,'interpreter','latex');
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    xticks([0 100 200 300 400])
    title('Ageostrophic ocean zonal force balance','FontSize',fontsize+2,'interpreter','latex');
    leg1 = legend([l1 l2 l3 l0],...
        'Ice-ocean stress',...
        'Bottom frictional stress',...
        'PGF+Advection',...
        'Residual term', 'FontSize', fontsize-1,'interpreter','latex');
    set(leg1,'position', [0.5011 0.1285 0.4000 0.2429])
    legend boxon;
    print('-dpng','-r180',[figdir 'oce_ageo_' expname '.png']);



    %%
    %%% Check Coriolis term
    yup = 0.8;
    ydown = -0.8; 

    figure(3)
    clf;    
    l0 = plot(yy/1000,-totalchange_tendency/length_int,'LineWidth',4,'color',[0.7 0.7 0.7]);
    hold on;
    l2 = plot(yy/1000,Um_Ext_xzint/length_int,'LineWidth',2,'Color',brown);
    l3 = plot(yy/1000,Um_Advec_xzint/length_int,'LineWidth',2,'Color',green);
    l4 = plot(yy/1000,Um_dPhiX_xzint/length_int,'LineWidth',2,'Color',yellow);
    l5 = plot(yy/1000,Um_Diss_xzint/length_int,'LineWidth',2,'Color',purple);
    l6 = plot(yy/1000,Um_Cori_xzint/length_int,'--','LineWidth',2,'Color',gold);
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
    leg1 = legend([l2 l3 l4 l5 l0 l6],...
        'Ice-ocean stress',...
        'Ocean advection',...
        'Pressure gradient force',...
        'Bottom frictional stress',...
        'Residual term',...
        'Coriolis term',...
        'FontSize', fontsize-1,'interpreter','latex');
    set(leg1,'position',[0.1296    0.1190    0.4811    0.2429])
    legend boxon;


