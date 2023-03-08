


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

    prodname_new = [prodir expname '_vorticity_cdw.mat'];
    load(prodname_new)

    %%
    Xeast = 400*m1km; %%% Longitude of eastern trough wall, default 400*m1km
    Xwest = 200*m1km; %%% Longitude of western trough wall, default 200*m1km
%     zonal_idx = round((Xwest-10*m1km)/dx):round((Xeast+10*m1km)/dx);
    zonal_idx = round((250*m1km)/dx):round((350*m1km)/dx);
    meri_idx = 51:Ny;

    %%% Calculate area-integrated vorticity budget
    dA = dx*dy;

    BPT = cumsum(sum(zeta_BPT(zonal_idx,meri_idx),'omitnan')).*dA;
    IPT = cumsum(sum(zeta_IPT(zonal_idx,meri_idx),'omitnan')).*dA;
    Advec = cumsum(sum(zeta_Advec(zonal_idx,meri_idx),'omitnan')).*dA;
    Diss = cumsum(sum(zeta_Diss(zonal_idx,meri_idx),'omitnan')).*dA;
    residual = cumsum(sum(zeta_residual(zonal_idx,meri_idx),'omitnan')).*dA;
    BPTplusIPT = cumsum(sum(zeta_BPTplusIPT(zonal_idx,meri_idx),'omitnan')).*dA;
    Cori = cumsum(sum(zeta_Cori(zonal_idx,meri_idx),'omitnan')).*dA;
    AdvRe = cumsum(sum(zeta_AdvRe(zonal_idx,meri_idx),'omitnan')).*dA;
    AdvZ3 = cumsum(sum(zeta_AdvZ3(zonal_idx,meri_idx),'omitnan')).*dA;



    fontsize = 17;
    figure(1)
%     plot(yy(meri_idx)/1000,BPT,'-.','LineWidth',2)
    plot(yy(meri_idx)/1000,Advec,'LineWidth',2)
    hold on;
%     plot(yy(meri_idx)/1000,IPT,'-.','LineWidth',2)
    plot(yy(meri_idx)/1000,Diss,'LineWidth',2)
    plot(yy(meri_idx)/1000,residual,'LineWidth',2)
    plot(yy(meri_idx)/1000,BPTplusIPT,'LineWidth',2)
%     plot(yy(meri_idx)/1000,Cori,'--','LineWidth',2)
%     plot(yy(meri_idx)/1000,AdvRe,'--','LineWidth',2)
%     plot(yy(meri_idx)/1000,AdvZ3,'--','LineWidth',2)
    legend('Total advecion','Dissipation','Residual',...
        'BPT + IPT')

%     legend('Bottom pressure torque (BPT)','Isopycnal pressure torque (IPT)','Total advecion','Dissipation','Residual',...
%         'BPT + IPT','Coriolis term','Vertical Advection (Explicit part)','Vorticity advection')
%     ylim([-0.5 0.5]*1e4)
    set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');
    xlabel('Latitude, y (km)')
    ylabel('Area-intergated vorticity budget (m^3/s^2)')

    


    meri_idx = 1:Ny;
    BPT = cumsum(sum(zeta_BPT(zonal_idx,meri_idx),'omitnan')).*dA;
    IPT = cumsum(sum(zeta_IPT(zonal_idx,meri_idx),'omitnan')).*dA;
    Advec = cumsum(sum(zeta_Advec(zonal_idx,meri_idx),'omitnan')).*dA;
    Diss = cumsum(sum(zeta_Diss(zonal_idx,meri_idx),'omitnan')).*dA;
    residual = cumsum(sum(zeta_residual(zonal_idx,meri_idx),'omitnan')).*dA;
    BPTplusIPT = cumsum(sum(zeta_BPTplusIPT(zonal_idx,meri_idx),'omitnan')).*dA;
    Cori = cumsum(sum(zeta_Cori(zonal_idx,meri_idx),'omitnan')).*dA;
    AdvRe = cumsum(sum(zeta_AdvRe(zonal_idx,meri_idx),'omitnan')).*dA;
    AdvZ3 = cumsum(sum(zeta_AdvZ3(zonal_idx,meri_idx),'omitnan')).*dA;

    figure(2)
    plot(yy(meri_idx)/1000,BPT,'-.','LineWidth',2)
    hold on;
    plot(yy(meri_idx)/1000,IPT,'-.','LineWidth',2)
    plot(yy(meri_idx)/1000,Advec,'LineWidth',2)
    plot(yy(meri_idx)/1000,Diss,'LineWidth',2)
    plot(yy(meri_idx)/1000,residual,'LineWidth',2)
    plot(yy(meri_idx)/1000,BPTplusIPT,'LineWidth',2)
    plot(yy(meri_idx)/1000,Cori,'--','LineWidth',2)
    legend('Bottom pressure torque (BPT) + Ice shelf pressure torque (ISPT, y<=30km)',...
        'Isopycnal pressure torque (IPT) + Ice shelf pressure torque (ISPT, 30km<y<=100km)',...
        'Total advecion','Dissipation','Residual',...
        'BPT + IPT','Coriolis term')
    set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');
    xlabel('Latitude, y (km)');
    ylabel('Area-intergated vorticity budget (m^3/s^2)')


%      
%     ylim([-0.5 0.5]*1e4)

    figure(3)
    plot(yy(meri_idx)/1000,Advec,'LineWidth',2)
    hold on;
    plot(yy(meri_idx)/1000,Cori,'--','LineWidth',2)
    plot(yy(meri_idx)/1000,AdvRe,'--','LineWidth',2)
    plot(yy(meri_idx)/1000,AdvZ3,'--','LineWidth',2)
    plot(yy(meri_idx)/1000,Advec-Cori-AdvRe-AdvZ3,':','LineWidth',2)
    legend('Total advection','Coriolis term','Vertical Advection (Explicit part)','Vorticity advection','residual')
    set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');
    xlabel('Latitude, y (km)')
    ylabel('Area-intergated vorticity budget (m^3/s^2)')


