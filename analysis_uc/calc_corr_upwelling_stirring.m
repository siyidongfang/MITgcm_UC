

    clear;close all;
    addpath functions/;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    
    prodir = ['/Users/csi/MITgcm_UC/products_new/' exp_group '/'];
    figdir = ['/Users/csi/MITgcm_UC/figures_uc/BCvorticity_cdw_sw/' exp_group '/'];
    useSEAICE = true;
    showfigrue = false;
    savefigure = true;

    prodir_vorticity = '/Users/csi/MITgcm_UC/products_vorticity/';
    group_adv7 = [1:13 23 25 26];
    group_noAdv7 = [14:22 24];

    ww_all = zeros(1,26);
    Adv_all = zeros(1,26);
    Cori_all = zeros(1,26);
    IPT_all = zeros(1,26);
    BPTplusIPT_sb = zeros(1,26);
    BPT_sb = zeros(1,26);
    IPT_sb = zeros(1,26);
    zeta_cdw_tr = zeros(1,26);
    zeta_cdw_sbtr_min = zeros(1,26);
    w_dia_is = zeros(1,26);



for n=group_adv7
% for n=1
    expname = EXPNAME{n}
    loadexp;
    load_data;
    load_spacing;
    
    prodname = [prodir_vorticity expname '_ww_cdw.mat'];
    load(prodname)
    prodname = [prodir_vorticity expname '_vorticity_cdw.mat'];
    load(prodname)

    Yiceshelf = 100*m1km;
    iceshelfx_idx = round((30*m1km)/dx):round((Lx-30*m1km)/dx);%%% exclude sponge layers
    iceshelfy_idx = 1:find(yy<Yiceshelf,1,'last');

    calc_w_layers;
    w_dia_is(n) = sum(w_cdw_dia(iceshelfx_idx,iceshelfy_idx)*dx*dy,'all','omitnan');

    sbx_idx = round((250*m1km)/dx):round((300*m1km)/dx); %%% shelfbreak indices
    sby_idx = round(Ymin/dy):round(Ymax/dy); %%% shelfbreak indices

    ww_all(n) = sum(ww_cdw(iceshelfx_idx,iceshelfy_idx)*dx*dy,'all','omitnan');
    Cori_all(n) = sum(zeta_Cori(iceshelfx_idx,iceshelfy_idx)*dx*dy,'all','omitnan');
    IPT_all(n) = sum(zeta_IPT(iceshelfx_idx,iceshelfy_idx)*dx*dy,'all','omitnan');
    Adv_all(n) = sum(zeta_Advec(iceshelfx_idx,iceshelfy_idx)*dx*dy,'all','omitnan');
    BPTplusIPT_sb(n) = sum(zeta_BPTplusIPT(sbx_idx,sby_idx)*dx*dy,'all','omitnan');
    BPT_sb(n) = sum(zeta_BPT(sbx_idx,sby_idx)*dx*dy,'all','omitnan');
    IPT_sb(n) = sum(zeta_IPT(sbx_idx,sby_idx)*dx*dy,'all','omitnan');

    %%% Calculate integrated zeta in the trough
    trough_xidx = round((290*m1km)/dx):round((310*m1km)/dx);
    trough_yidx = round(150*m1km/dy):round(220*m1km/dy); 
    calc_zeta_cdw;
    zeta_cdw_tr(n) = sum(zeta_cdw_zint(trough_xidx,trough_yidx)*dx*dy,'all','omitnan');
    
    sbtrx_idx = round((230*m1km)/dx):round((370*m1km)/dx); 
    sbtry_idx = round((150*m1km)/dx):round(Ymax/dy); 
    zeta_cdw_sbtr_min(n) = min(min(zeta_cdw_zint(sbtrx_idx,sbtry_idx))); %%% minimum vertically integrated CDW vorticity in the trough

end

% for n=group_noAdv7
%         expname = EXPNAME{n}
%         prodir = '/Users/csi/MITgcm_UC/products_uc/seaice_boundary/';
%         loadexp;
%         load_data;
%         load_spacing;
% 
%         Yiceshelf = 100*m1km;
%         iceshelfx_idx = round((30*m1km)/dx):round((Lx-30*m1km)/dx);%%% exclude sponge layers
%         iceshelfy_idx = 1:find(yy<Yiceshelf,1,'last');
%         sbx_idx = round((250*m1km)/dx):round((320*m1km)/dx);
%         sby_idx = round((200*m1km)/dy):round((240*m1km)/dy);
%         ww_all(n) = sum(ww_cdw(iceshelfx_idx,iceshelfy_idx)*dx*dy,'all','omitnan');
%         Cori_all(n) = sum(zeta_Cori(iceshelfx_idx,iceshelfy_idx)*dx*dy,'all','omitnan');
%         IPT_all(n) = sum(zeta_IPT(iceshelfx_idx,iceshelfy_idx)*dx*dy,'all','omitnan');
%         Adv_all(n) = sum(zeta_Advec(iceshelfx_idx,iceshelfy_idx)*dx*dy,'all','omitnan');
%         BPTplusIPT_sb(n) = sum(zeta_BPTplusIPT(sbx_idx,sby_idx)*dx*dy,'all','omitnan');
%         BPT_sb(n) = sum(zeta_BPT(sbx_idx,sby_idx)*dx*dy,'all','omitnan');
%         IPT_sb(n) = sum(zeta_IPT(sbx_idx,sby_idx)*dx*dy,'all','omitnan');
% end

save([prodir_vorticity 'matrix_vorticity.mat'],...
    'ww_all','Cori_all','IPT_all','Adv_all',...
    'BPTplusIPT_sb','BPT_sb','IPT_sb','zeta_cdw_tr','zeta_cdw_sbtr_min','w_dia_is',...
    'EXPNAME')

%%

load([prodir_vorticity 'matrix_seaice_boundary-allLx.mat'])
load([prodir_vorticity 'matrix_vorticity.mat'])

ww_all = ww_all/1e6; %%% convert to Sv
w_dia_is = w_dia_is/1e6; %%% convert to Sv

% group = group_adv7;
group = 1:12
% group = 1:26;
% group = group_noAdv7;
fontsize = 16;


corrcoef(Cori_all(group),BPTplusIPT_sb(group)) %%% 0.73
corrcoef(w_dia_is(group),BPTplusIPT_sb(group)) %%% 0.7
corrcoef(ww_all(group),BPTplusIPT_sb(group)) %%% 0.67


corrcoef(Cori_all(group),MeltRate_m(group)) %%% 0.97
corrcoef(w_dia_is(group),MeltRate_m(group)) %%% 0.97
corrcoef(ww_all(group),MeltRate_m(group)) %%% 0.93


figure()
scatter(w_dia_is(group),MeltRate_m(group))
xlabel('Diapycnal upwelling in the cavity (Sv)')
ylabel('Ice shelf melt rate (m/yr)')
title({'Diapycnal upwelling in the cavity v.s.','Ice shelf melt rate'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');




figure(9)
scatter(Cori_all(group),BPTplusIPT_sb(group))
% xlabel('Coriolis term (m^3/s^2)')
% ylabel('BPTplusIPT')
% title({'Area-integrated Coriolis term in the cavity v.s.','Offshore buoyancy gradient'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');


corrcoef(Cori_all(group),Ueast_transportweighted(group)) %%% 0.75
corrcoef(BPTplusIPT_sb(group),Ueast_transportweighted(group)) %%% 0.96
corrcoef(BPT_sb(group),Cori_all(group)) %%% 0.70

corrcoef(zeta_cdw_tr(group),BPTplusIPT_sb(group)) %%% 0.71
corrcoef(zeta_cdw_tr(group),IPT_sb(group)) %%% 0.85
corrcoef(zeta_cdw_tr(group),ww_all(group)) %%% 0.2
corrcoef(zeta_cdw_sbtr_min(group),ww_all(group)) %%% 0.55
corrcoef(zeta_cdw_sbtr_min(group),Cori_all(group)) %%% 0.58

figure()
scatter(zeta_cdw_sbtr_min(group),Cori_all(group))
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');


figure(1)
scatter(ww_all(group),Cori_all(group))
xlabel('Total upwelling in the cavity (Sv)')
ylabel('Coriolis term (m^3/s^2)')
title({'Total upwelling in the cavity v.s.','Area-integrated Coriolis term in the cavity'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');

figure(2)
scatter(ww_all(group),IPT_all(group))
xlabel('Total upwelling in the cavity (Sv)')
ylabel('Interfacial pressure torque (m^3/s^2)')
title({'Total upwelling in the cavity v.s.','Area-integrated Interfacial pressure torque in the cavity'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');

figure(3)
scatter(Cori_all(group),IPT_all(group))
xlabel('Coriolis term (m^3/s^2)')
ylabel('Interfacial pressure torque (m^3/s^2)')
title({'Area-integrated Coriolis term in the cavity v.s.','Area-integrated Interfacial pressure torque in the cavity'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');

figure(6)
scatter(Cori_all(group),Ueast_transportweighted(group))
xlabel('Coriolis term (m^3/s^2)')
ylabel('Undercurrent strength (m/s)')
title({'Area-integrated Coriolis term in the cavity v.s.','Transport-weighted undercurrent strength'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');


figure(4)
scatter(ww_all(group),MeltRate_m(group))
xlabel('Total upwelling in the cavity (Sv)')
ylabel('Ice shelf melt rate (m/yr)')
title({'Total upwelling in the cavity v.s.','Ice shelf melt rate'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');


figure(5)
scatter(ww_all(1:24),MeltRate_m(1:24))
xlabel('Total upwelling in the cavity (Sv)')
ylabel('Ice shelf melt rate (m/yr)')
title({'(Including Exps. not using Adv7) Total upwelling in the cavity v.s.','Ice shelf melt rate'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');


% figure(7)
% scatter(Cori_all(group),MeltRate_m(group))

figure(8)
scatter(Cori_all(group),Ug_east_transportweighted(group))
xlabel('Coriolis term (m^3/s^2)')
ylabel('Transport weighted thermal-wind velocity (m/s)')
title({'Area-integrated Coriolis term in the cavity v.s.','Offshore buoyancy gradient'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');



% scatter(U_east_avg,MeltRate_m)



figure(10)
scatter(ww_all(group),BPT_sb(group))
xlabel('Coriolis term (m^3/s^2)')
ylabel('BPT')
% title({'Area-integrated Coriolis term in the cavity v.s.','Offshore buoyancy gradient'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');

figure(11)
scatter(ww_all(group),IPT_sb(group))
xlabel('Coriolis term (m^3/s^2)')
ylabel('IPT')
% title({'Area-integrated Coriolis term in the cavity v.s.','Offshore buoyancy gradient'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');






