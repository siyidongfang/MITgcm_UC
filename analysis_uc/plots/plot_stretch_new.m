%%% Plot the vertical stretch of the CDW layer

    clear;close all;
    addpath /Users/ysi/MITgcm_UC/analysis_uc
    addpath /Users/ysi/MITgcm_UC/analysis_uc/functions/

    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    load_colors;
    fontsize = 17;

    ne =1; 
    expname = EXPNAME{ne}
    loadexp;
    load_data;
    load_spacing;

    mask_interpolate;

    wwf = zeros(Nx,Ny,Nrf);
    for i=1:Nx
        for j=1:Ny   
            wwf(i,j,:) = interp1(zz,squeeze(ww(i,j,:))',zzf,'linear','extrap');
            clear vertical_cdwidx;
            vertical_cdwidx = find(mask_cdw_tgridf(i,j,:)==1);
            if(~isnan(vertical_cdwidx))
                interf_idx(i,j) = vertical_cdwidx(1);%%% vertical index of the interface
            else
                interf_idx(i,j) = NaN;
            end
        end
    end

    f = f0+beta*YY;

%%
    ww_interf = zeros(Nx,Ny); %%% interfacial vertical velocity
    ww_bot = zeros(Nx,Ny); %%% bottom vertical velocity
    for i = 1:Nx
        for j = 1:Ny
            idxb = find(ss(i,j,:)~=0,1,'last'); % Find the vertical grid of bottom pressure
            if(idxb~=0)
               ww_bot(i,j) = ww(i,j,idxb);
            end
            if(~isnan(interf_idx(i,j)))
                ww_interf(i,j) = wwf(i,j,interf_idx(i,j));
            else
                ww_interf(i,j) = NaN;
            end
        end
    end
    ww_bot(ww_bot==0) = NaN;
    

%     save('fig_supp/figS2.mat','ww_bot','ww_interf','XX','YY')

    calc_w_layers;

%%
    load('fig_supp/figS2.mat')
    bathy2=bathy;
    bathy2(YY>150*m1km)=NaN;

    
    YLIM = [0 250];

    figure(1)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 600 850]);
    panelsize = [0.75 0.225];

    ax1 = subplot('position',[0.1 0.725 panelsize]);
    pcolor(XX/1000,YY/1000,-rhoConst.*f.*ww_bot)
    shading interp;colormap(cmocean('balance'));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3000:1000:-1000],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-1500 -1500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    clim([-1 1]/1e5)
    set(gca,'FontSize',fontsize);
    title('Estimated bottom pressure torque, \it - \rho_0 f w_{b}','FontSize',fontsize+4,'FontWeight','normal')
    ylim(YLIM);xlim([-300 300])
    yticks(0:50:400);xticks(-300:100:300)
    ylabel('Latitude, y (km)')
    box on;
    % text(ax1,-295,18,{'(a)'},'FontSize',fontsize+2);
    annotation('textbox',[0.005 0.99 0.15 0.01],'String','A','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');



    ax2 = subplot('position',[0.1 0.39 panelsize]);
    pcolor(XX/1000,YY/1000,rhoConst.*f.*(ww_interf-w_cdw_dia))
    shading interp;colormap(cmocean('balance'));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3000:1000:-1000],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-1500 -1500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    clim([-1 1]/1e5)
    set(gca,'FontSize',fontsize);
    title('Estimated interfacial pressure torque, \it \rho_0 f (w_{iso}-\omega^{dia})','FontSize',fontsize+4,'FontWeight','normal')
    ylim(YLIM);xlim([-300 300])
    yticks(0:50:400);xticks(-300:100:300)
    ylabel('Latitude, y (km)')
    box on;
    % text(ax2,-295,18,{'(b)'},'FontSize',fontsize+2);
    annotation('textbox',[0.005 0.655 0.15 0.01],'String','B','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');


    ax3 = subplot('position',[0.1 0.06 panelsize]);
    box on;
    pcolor(XX/1000,YY/1000,rhoConst.*f.*(ww_interf-ww_bot-w_cdw_dia))
    shading interp;colormap(cmocean('balance'));
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-700 -500:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3000:1000:-1000],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-1500 -1500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    clim([-1 1]/1e5)
    set(gca,'FontSize',fontsize);
    title({'Estimated total pressure torque, \it \rho_0 f (w_{iso}- w_{b}-\omega^{dia})'},'FontSize',fontsize+4,'FontWeight','normal')
    ylim(YLIM);xlim([-300 300])
    yticks(0:50:400);xticks(-300:100:300)
    xlabel('Longitude, x (km)');ylabel('Latitude, y (km)')
    % text(ax3,-295,18,{'(c)'},'FontSize',fontsize+2);
    annotation('textbox',[0.005 0.325 0.15 0.01],'String','C','FontSize',fontsize+2,'fontweight','bold','LineStyle','None');

    handle=colorbar;set(handle,'position',[0.914 0.25 0.015 0.5]);
    annotation('textbox',[0.9 0.755 0.05 0.05],'String','(Pa/m)','FontSize',fontsize,'LineStyle','None');


    figdir = '/Users/ysi/MITgcm_UC/analysis_uc/plots/fig_supp/';
    print('-dpng','-r300',[figdir 'figS1.png']);
    % print('-dpng','-r300',[figdir 'stretch_nomelt.png']);
    % print('-dpng','-r300',[figdir 'stretch_new.png']);

