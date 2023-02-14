


    clear;close all;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    
    prodir = ['/Users/csi/MITgcm_UC/products_new/' exp_group '/'];
    figdir = ['/Users/csi/MITgcm_UC/figures_uc/BCvorticity_cdw_sw/' exp_group '/'];
    useSEAICE = true;
    showfigrue = true;
    savefigure = false;

    n=1;
    expname = EXPNAME{n}
    loadexp;
    load_data;
    load_spacing;

    prodname_new = [prodir expname '_vorticity_cdw.mat'];
    load(prodname_new)

    %%
    Xeast = 400*m1km; %%% Longitude of eastern trough wall, default 400*m1km
    Xwest = 200*m1km; %%% Longitude of western trough wall, default 200*m1km
    zonal_idx = round((Xwest-10*m1km)/dx):round((Xeast+10*m1km)/dx);
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



    figure()
    plot(yy(meri_idx)/1000,BPT)
    hold on;
    plot(yy(meri_idx)/1000,IPT)
    plot(yy(meri_idx)/1000,Advec)
    plot(yy(meri_idx)/1000,Diss)
    plot(yy(meri_idx)/1000,residual)
    plot(yy(meri_idx)/1000,BPTplusIPT,':')
    plot(yy(meri_idx)/1000,Cori,'--')
    plot(yy(meri_idx)/1000,AdvRe,'--')
    plot(yy(meri_idx)/1000,AdvZ3,'--')
    legend('BPT','IPT','Advec','Diss','Residual',...
        'BPTplusIPT','Cori','AdvRe','AdvZ3')
%     ylim([-0.5 0.5]*1e4)



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

    figure()
    plot(yy(meri_idx)/1000,BPT)
    hold on;
    plot(yy(meri_idx)/1000,IPT)
    plot(yy(meri_idx)/1000,Advec)
    plot(yy(meri_idx)/1000,Diss)
    plot(yy(meri_idx)/1000,residual)
    plot(yy(meri_idx)/1000,BPTplusIPT,':')
    plot(yy(meri_idx)/1000,Cori,'--')
    legend('BPT','IPT','Advec','Diss','Residual',...
        'BPTplusIPT','Cori')
%     ylim([-0.5 0.5]*1e4)

    figure()
    plot(yy(meri_idx)/1000,Advec)
    hold on;
    plot(yy(meri_idx)/1000,Cori,'--')
    plot(yy(meri_idx)/1000,AdvRe,'--')
    plot(yy(meri_idx)/1000,AdvZ3,'--')
    plot(yy(meri_idx)/1000,Advec-Cori-AdvRe-AdvZ3,':')
    legend('Advec','Cori','AdvRe','AdvZ3','residual')


