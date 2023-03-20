%%%
%%% plot_iceBC.m
%%%
%%% plot the zonal sea ice boundary conditions for cases with varying winds

    clear;close all;
    addpath /Users/csi/MITgcm_UC/analysis_uc
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions/

    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    load_colors;
    fontsize = 19;




%     figure(2)
%     subplot(1,2,1)
%     pcolor(uice);shading flat;colorbar
%     subplot(1,2,2)
%     pcolor(vice);shading flat;colorbar



    figure(1)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 1200 350]);
    panelsize = [0.26 0.75];

    ne =2; 
    expname = EXPNAME{ne}
    loadexp;
    fid = fopen(fullfile(exppath,'input','uIceFile.bin'),'r','b');
    uice = fread(fid,[Nx Ny],'real*8');
    fid = fopen(fullfile(exppath,'input','vIceFile.bin'),'r','b');
    vice = fread(fid,[Nx Ny],'real*8');
    fid = fopen(fullfile(exppath,'input','OBEuFile.bin'),'r','b');
    uEast = fread(fid,[Ny Nr],'real*8');
    obuice = uice(1,:);
    obvice = vice(1,:);
    ystartidx = find(obuice~=0,1);

    ax1 = subplot('position',[0.065 0.16 panelsize]);
    l1=plot(yy(ystartidx:end)/1000,obuice(ystartidx:end),'LineWidth',2);
    hold on;
    l2=plot(yy(ystartidx:end)/1000,uEast(ystartidx:end,1),'LineWidth',2);
    l3=plot(yy(ystartidx:end)/1000,obuice(ystartidx:end)-(uEast(ystartidx:end,1))','LineWidth',2);
    plot(yy(ystartidx:end)/1000,0*uEast(ystartidx:end,1),'--','LineWidth',1,'Color',darkgray)
    xlim([yy(ystartidx)/1000 400])
    ylim([-0.16 0.02])
    set(gca,'fontsize',fontsize);
    xlabel('Latitude, y (km)','Fontsize',fontsize)
    ylabel('(m/s)','Fontsize',fontsize)
    title('Weak winds','Fontsize',fontsize+2,'FontWeight','normal')
    ax1.YGrid = 'on';
    ax1.GridLineStyle = '-';
    yup = 1;
    ydown = -1;
    line([220 220],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([310 310],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    hold off;
    text(150,0.01,'Shelf','FontSize',fontsize-2,'Color',[0.5 0.5 0.5]);
    text(245,0.01,'Slope','FontSize',fontsize-2,'Color',[0.5 0.5 0.5]);
    text(315,0.01,'Deep ocean','FontSize',fontsize-2,'Color',[0.5 0.5 0.5]);
%     leg1 = legend([l1 l2 l3],'u_i','u_o^s','u_i-u_o^s','Fontsize',fontsize);
%     set(leg1,'Position',[0.2467 0.2029 0.0692 0.3171]);
    leg1 = legend([l1 l2 l3],'Sea ice zonal velocity','Ocean surface zonal velocity','Ice-ocean velocity shear','Fontsize',fontsize);
    set(leg1,'Position',[0.0800 0.2386 0.2375 0.2114]);
    text(375,-0.15,{'(a)'},'FontSize',fontsize+2,'FontWeight','normal')


    ne =1; 
    expname = EXPNAME{ne}
    loadexp;
    fid = fopen(fullfile(exppath,'input','uIceFile.bin'),'r','b');
    uice = fread(fid,[Nx Ny],'real*8');
    fid = fopen(fullfile(exppath,'input','vIceFile.bin'),'r','b');
    vice = fread(fid,[Nx Ny],'real*8');
    fid = fopen(fullfile(exppath,'input','OBEuFile.bin'),'r','b');
    uEast = fread(fid,[Ny Nr],'real*8');
    obuice = uice(1,:);
    obvice = vice(1,:);
    ystartidx = find(obuice~=0,1);

    ax2 = subplot('position',[0.395 0.16 panelsize]);
    plot(yy(ystartidx:end)/1000,obuice(ystartidx:end),'LineWidth',2)
    hold on;
    plot(yy(ystartidx:end)/1000,uEast(ystartidx:end,1),'LineWidth',2)
    plot(yy(ystartidx:end)/1000,obuice(ystartidx:end)-(uEast(ystartidx:end,1))','LineWidth',2)
    plot(yy(ystartidx:end)/1000,0*uEast(ystartidx:end,1),'--','LineWidth',1,'Color',darkgray)
    xlim([yy(ystartidx)/1000 400])
    ylim([-0.16 0.02])
    set(gca,'fontsize',fontsize);
    xlabel('Latitude, y (km)','Fontsize',fontsize)
    ylabel('(m/s)','Fontsize',fontsize)
    title('Reference','Fontsize',fontsize+2,'FontWeight','normal')
    ax2.YGrid = 'on';
    ax2.GridLineStyle = '-';
    yup = 1;
    ydown = -1;
    line([220 220],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([310 310],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    hold off;
    text(150,0.01,'Shelf','FontSize',fontsize-2,'Color',[0.5 0.5 0.5]);
    text(245,0.01,'Slope','FontSize',fontsize-2,'Color',[0.5 0.5 0.5]);
    text(315,0.01,'Deep ocean','FontSize',fontsize-2,'Color',[0.5 0.5 0.5]);
    text(375,-0.15,{'(b)'},'FontSize',fontsize+2,'FontWeight','normal')

    ne =3; 
    expname = EXPNAME{ne}
    loadexp;
    fid = fopen(fullfile(exppath,'input','uIceFile.bin'),'r','b');
    uice = fread(fid,[Nx Ny],'real*8');
    fid = fopen(fullfile(exppath,'input','vIceFile.bin'),'r','b');
    vice = fread(fid,[Nx Ny],'real*8');
    fid = fopen(fullfile(exppath,'input','OBEuFile.bin'),'r','b');
    uEast = fread(fid,[Ny Nr],'real*8');
    obuice = uice(1,:);
    obvice = vice(1,:);
    ystartidx = find(obuice~=0,1);

    ax3 = subplot('position',[0.725 0.16 panelsize]);
    plot(yy(ystartidx:end)/1000,obuice(ystartidx:end),'LineWidth',2)
    hold on;
    plot(yy(ystartidx:end)/1000,uEast(ystartidx:end,1),'LineWidth',2)
    plot(yy(ystartidx:end)/1000,obuice(ystartidx:end)-(uEast(ystartidx:end,1))','LineWidth',2)
    plot(yy(ystartidx:end)/1000,0*uEast(ystartidx:end,1),'--','LineWidth',1,'Color',darkgray)
    xlim([yy(ystartidx)/1000 400])
    ylim([-0.16 0.02])
    set(gca,'fontsize',fontsize);
    xlabel('Latitude, y (km)','Fontsize',fontsize)
    ylabel('(m/s)','Fontsize',fontsize)
    title('Strong winds','Fontsize',fontsize+2,'FontWeight','normal')
    ax3.YGrid = 'on';
    ax3.GridLineStyle = '-';
    yup = 1;
    ydown = -1;
    line([220 220],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([310 310],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    hold off;
    text(150,0.01,'Shelf','FontSize',fontsize-2,'Color',[0.5 0.5 0.5]);
    text(245,0.01,'Slope','FontSize',fontsize-2,'Color',[0.5 0.5 0.5]);
    text(315,0.01,'Deep ocean','FontSize',fontsize-2,'Color',[0.5 0.5 0.5]);
    text(375,-0.15,{'(c)'},'FontSize',fontsize+2,'FontWeight','normal')
    
    figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots_JPO/fig_supp/';
    print('-dpng','-r200',[figdir 'figS1.png']);