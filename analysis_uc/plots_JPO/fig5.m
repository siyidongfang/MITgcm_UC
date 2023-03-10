%%%
%%% fig5.m
%%%
%%% Area-integrated vorticity budget
%%%

 clear;close all;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    
    prodir = ['/Users/csi/MITgcm_UC/products/' exp_group '/'];
    useSEAICE = true;
    showfigrue = true;
    savefigure = false;

    ne=1;
    expname = EXPNAME{ne}
    loadexp;
    load_data;
    load_spacing;
    load_colors;

    prodname_new = [prodir expname '_vorticity_cdw.mat'];
    load(prodname_new)

    %%% Calculate potential vorticity
    ff_vorgrid = f0+beta*(YY-1*m1km); %%% f on vorticity grid
    Hcdw_vorgrid = zeros(Nx,Ny);
    Hcdw_vorgrid(1:Nx-1,:) = (Hcdw_vgridf(1:Nx-1,:)+ Hcdw_vgridf(2:Nx,:))/2;  %%% CDW thickness on vorticity grid

    uu_cdw_zavg = UU_cdw./Hcdw_ugridf;
    vv_cdw_zavg = VV_cdw./Hcdw_vgridf;

    zeta = zeros(Nx,Ny);
    zeta(:,1:Ny-1) = - (uu_cdw_zavg(:,2:Ny)-uu_cdw_zavg(:,1:Ny-1))/dy;
    zeta = zeta + (vv_cdw_zavg([2:Nx 1],:)-vv_cdw_zavg)/dx;

    PV = (ff_vorgrid + zeta) ./Hcdw_vorgrid; %%% potential vorticity

    maxpv = max(max(PV)); minpv = min(min(PV));


    %%% plot selected contours 
    Wmin = -3.5e-7;
    Wmax = -1e-7;

    %%% Create a finer horizontal grid
    ffac = 7;
    Nxf = ffac*Nx;
    Nyf = ffac*Ny;
    delXf = zeros(1,Nxf); 
    delYf = zeros(1,Nyf); 
    for n=1:Nx
        for m=1:ffac
            delXf((n-1)*ffac+m) = delX(n)/ffac;
        end
    end
    for n=1:Ny
        for m=1:ffac
            delYf((n-1)*ffac+m) = delY(n)/ffac;
        end
    end

    dxf = delXf(1); dyf = delYf(1);
    xx  = cumsum((delX +  [0 delX(1:Nx-1)])/2)  -Lx/2;
    xxf= cumsum((delXf + [0 delXf(1:Nxf-1)])/2)-Lx/2;
    
    yy  = cumsum((delY +  [0 delY(1:Ny-1)])/2);
    yyf= cumsum((delYf + [0 delYf(1:Nyf-1)])/2);

    [YY,XX] = meshgrid(yy,xx);
    [YYf,XXf] = meshgrid(yyf,xxf);

    %%% Interpolate the vorticity terms onto this new grid
    pvf = interp2(YY,XX,PV,YYf,XXf,'linear');
    zeta_BPTplusIPTf = interp2(YY,XX,zeta_BPTplusIPT,YYf,XXf,'linear');
    zeta_BPTf = interp2(YY,XX,zeta_BPT,YYf,XXf,'linear');
    zeta_IPTf = interp2(YY,XX,zeta_IPT,YYf,XXf,'linear');
    zeta_Advecf = interp2(YY,XX,zeta_Advec,YYf,XXf,'linear');
    zeta_Dissf = interp2(YY,XX,zeta_Diss,YYf,XXf,'linear');
    zeta_residualf = interp2(YY,XX,zeta_residual,YYf,XXf,'linear');

    zeta_Corif = interp2(YY,XX,zeta_Cori,YYf,XXf,'linear');
    zeta_AdvZ3f = interp2(YY,XX,zeta_AdvZ3,YYf,XXf,'linear');
    zeta_AdvRef = interp2(YY,XX,zeta_AdvRe,YYf,XXf,'linear');

    bathyf = interp2(YY,XX,bathy,YYf,XXf,'linear');

    %%% Select f/hcdw contours  over the shelf and slope
    pv_select = Wmin:0.1e-7:Wmax;
    LL = length(pv_select);
    pv_select_mid = 0.5*(pv_select(1:end-1)+pv_select(2:end));
    mask_pv = ones(Nxf,Nyf);
    mask_pv(XXf<-120.*m1km)=NaN;
    mask_pv(XXf>70*m1km)=NaN;

    pvf(pvf<Wmin)=NaN;
    pvf(pvf>Wmax)=NaN;

    Amaskf = NaN.*zeros(Nxf,Nyf);
    for ii=1:Nxf
        for jj=1:Nyf
            if(~isnan(pvf(ii,jj)))
                Amaskf(ii,jj)=bathyf(ii,jj);
            end
            if XXf(ii,jj)<=-100*m1km ...
               || (XXf(ii,jj)>=40*m1km && YYf(ii,jj)>=220*m1km)
                Amaskf(ii,jj)=NaN;
            end
        end
    end
    
    Amaskf(~isnan(Amaskf))=1;

    BPTplusIPT_Aint = cumsum(sum(zeta_BPTplusIPTf.*Amaskf*dxf*dyf,'omitnan'));
    BPT_Aint = cumsum(sum(zeta_BPTf.*Amaskf*dxf*dyf,'omitnan'));
    IPT_Aint = cumsum(sum(zeta_IPTf.*Amaskf*dxf*dyf,'omitnan'));
    Advec_Aint = cumsum(sum(zeta_Advecf.*Amaskf*dxf*dyf,'omitnan'));
    Diss_Aint = cumsum(sum(zeta_Dissf.*Amaskf*dxf*dyf,'omitnan'));
    residual_Aint = cumsum(sum(zeta_residualf.*Amaskf*dxf*dyf,'omitnan'));

    Cori_Aint = cumsum(sum(zeta_Corif.*Amaskf*dxf*dyf,'omitnan'));
    AdvZ3f_Aint = cumsum(sum(zeta_AdvZ3f.*Amaskf*dxf*dyf,'omitnan'));
    AdvRef_Aint = cumsum(sum(zeta_AdvRef.*Amaskf*dxf*dyf,'omitnan'));

    for kkk = 500:length(BPT_Aint)-1
        if(BPT_Aint(kkk+1)==BPT_Aint(kkk))
            BPTplusIPT_Aint(kkk+1:end)=NaN; 
            BPT_Aint(kkk+1:end)=NaN;
            IPT_Aint(kkk+1:end)=NaN;
            Advec_Aint(kkk+1:end)=NaN;
            Diss_Aint(kkk+1:end)=NaN;
            residual_Aint(kkk+1:end)=NaN;
            Cori_Aint(kkk+1:end)=NaN;
            AdvZ3f_Aint(kkk+1:end)=NaN;
            AdvRef_Aint(kkk+1:end)=NaN; 
        end
    end

    for kkk = 1:500
        if(BPT_Aint(kkk)==0)
            BPTplusIPT_Aint(kkk)=NaN; 
            BPT_Aint(kkk)=NaN; 
            IPT_Aint(kkk)=NaN; 
            Advec_Aint(kkk)=NaN; 
            Diss_Aint(kkk)=NaN; 
            residual_Aint(kkk)=NaN; 
            Cori_Aint(kkk)=NaN; 
            AdvZ3f_Aint(kkk)=NaN; 
            AdvRef_Aint(kkk)=NaN; 
        end
    end


    fontsize = 18;

    %%


    bathy2=bathy;
    bathy2(YY>150*m1km)=NaN;


    figure(1)
    clf;set(gcf,'color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 600 800]);

    ax1 = subplot('position',[0.105 0.585 0.85 0.38]);
    annotation('textbox',[0.095 0.995 0.15 0.01],'String','(a)','FontSize',fontsize+2,'LineStyle','None');
    contour(XX/1000,YY/1000,PV,(-20:0.1:0)*1e-7,'Color',gray)
    hold on;
    contour(XXf/1000,YYf/1000,pvf.*Amaskf,Wmin:1e-8:Wmax,'LineWidth',1.2)
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-600 -600],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-800:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-3500:1000:-1500],'k--','LineWidth',0.5,'ShowText','on');% clabel(C,h,'LabelSpacing',800);hold off;
%     hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:1000:-1000],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy2,[-800 -800],'k:','LineWidth',1,'ShowText','on');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold off;
    colorbar; colormap(WhiteBlueGreenYellowRed(5));
    clim([-4 -1]*1e-7);
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);
    title('CDW potential vorticity ','FontSize',fontsize+3)
    box on;
    annotation('textbox',[0.87 0.55 0.15 0.01],'String','(m^{-1}s^{-1})','FontSize',fontsize,'LineStyle','None');


    ax2 = subplot('position',[0.105 0.07 0.85 0.38]);
    annotation('textbox',[0.095 0.48 0.15 0.01],'String','(b)','FontSize',fontsize+2,'LineStyle','None');
    lres =plot(yyf/1000,residual_Aint/1000,'LineWidth',4,'Color',boxcolor);
    hold on;
    ldis = plot(yyf/1000,Diss_Aint/1000,'LineWidth',3,'Color',yellow);
    lbpt = plot(yyf/1000,BPT_Aint/1000,':','LineWidth',1.5,'Color',blue);
    lipt = plot(yyf/1000,IPT_Aint/1000,'--','LineWidth',1,'Color',blue);
    lpt =plot(yyf/1000,BPTplusIPT_Aint/1000,'LineWidth',3,'Color',blue);
%     plot(yyf/1000,BPT_Aint+IPT_Aint,'LineWidth',2)
    ladv = plot(yyf/1000,Advec_Aint/1000,'LineWidth',3,'Color',green);
    lcori = plot(yyf/1000,Cori_Aint/1000,':','LineWidth',1.5,'Color',green);
    lvortadv = plot(yyf/1000,AdvZ3f_Aint/1000,'--','LineWidth',1,'Color',green);
    lvertadv = plot(yyf/1000,AdvRef_Aint/1000,'-.','LineWidth',1,'Color',green);
    set(gca,'FontSize',fontsize);
    leg1  = legend([lpt ladv ldis lres],...
    'Total pressure torque','Total advection','Dissipation','Residual','FontSize',fontsize);
    legend boxoff;
    set(leg1,'Position', [0.11 0.3319 0.3650 0.1169])  
    xlabel('Latitude, y (km)');
    ylabel('(10^3 m^3/s^2)');
    title('Cummulatively integrated vorticity budget');
    xlim([50 250])
    grid on;grid minor;

    ah=axes('position',get(ax2,'position'),'visible','off');
    leg2 = legend(ah,[lbpt lipt],...
        'Bottom pressure torque','Interfacial pressure torque',...
        'FontSize',fontsize-0.5);
    legend boxoff;
    set(leg2,'Position', [0.11 0.0950 0.4200 0.0606])  

    ah2=axes('position',get(ax2,'position'),'visible','off');
    leg3 = legend(ah2,[lcori lvortadv lvertadv],...
        'Coriolis term','Vorticity advection','Vertical advection','FontSize',fontsize-0.5);
    legend boxoff;
    set(leg3,'Position', [0.5467 0.0750 0.3183 0.0887])  


     figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots_JPO/fig5/';
     print('-dpng','-r200',[figdir 'fig5.png']);















    

