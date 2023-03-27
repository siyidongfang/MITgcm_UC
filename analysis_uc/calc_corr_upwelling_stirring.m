

    clear;close all;
    addpath functions/;

    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    
    prodir = ['/Users/csi/MITgcm_UC/products/' exp_group '/'];
    figdir = ['/Users/csi/MITgcm_UC/figures_uc/BCvorticity_cdw_sw/' exp_group '/'];

    prodir_vorticity = [prodir 'BCvorticity/'];
    group_adv7 = 1:20;

    ww_all = zeros(1,20);
    Adv_all = zeros(1,20);
    Cori_all = zeros(1,20);
    IPT_all = zeros(1,20);
    BPTplusIPT_sb = zeros(1,20);
    BPT_sb = zeros(1,20);
    IPT_sb = zeros(1,20);
    zeta_cdw_tr = zeros(1,20);
    zeta_cdw_sbtr_min = zeros(1,20);
    w_dia_is = zeros(1,20);


for ne=group_adv7
% for ne=1
    ne
    expname = EXPNAME{ne};
    loadexp;
    load_data;
    load_spacing;
    
    prodname = [prodir expname '_vorticity_cdw.mat'];
    load(prodname)

    Yiceshelf = 100*m1km;
    iceshelfx_idx = round((30*m1km)/dx):round((Lx-30*m1km)/dx);%%% exclude sponge layers
    iceshelfy_idx = 1:find(yy<Yiceshelf,1,'last');

    calc_w_layers;
    w_dia_is(ne) = sum(w_cdw_dia(iceshelfx_idx,iceshelfy_idx)*dx*dy,'all','omitnan');


    sbx_idx = round(Xsbmin/dx):round(Xsbmax/dx); %%% shelfbreak indices
    sby_idx = round(Ymin/dy):round(Ymax/dy); %%% shelfbreak indices

    Cori_all(ne) = sum(zeta_Cori(iceshelfx_idx,iceshelfy_idx)*dx*dy,'all','omitnan');
    IPT_all(ne) = sum(zeta_IPT(iceshelfx_idx,iceshelfy_idx)*dx*dy,'all','omitnan');
    Adv_all(ne) = sum(zeta_Advec(iceshelfx_idx,iceshelfy_idx)*dx*dy,'all','omitnan');
    BPTplusIPT_sb(ne) = sum(zeta_BPTplusIPT(sbx_idx,sby_idx)*dx*dy,'all','omitnan');
    BPT_sb(ne) = sum(zeta_BPT(sbx_idx,sby_idx)*dx*dy,'all','omitnan');
    IPT_sb(ne) = sum(zeta_IPT(sbx_idx,sby_idx)*dx*dy,'all','omitnan');

    %%% Calculate integrated zeta in the trough
    trough_xidx = round((290*m1km)/dx):round((310*m1km)/dx);
    trough_yidx = round(130*m1km/dy):round(220*m1km/dy); 
    calc_zeta_cdw;
    zeta_cdw_tr(ne) = sum(zeta_cdw_zint(trough_xidx,trough_yidx)*dx*dy,'all','omitnan');
    
    sbtrx_idx = round((230*m1km)/dx):round((370*m1km)/dx); 
    sbtry_idx = round((130*m1km)/dy):round(Ymax/dy); 
    zeta_cdw_sbtr_min(ne) = min(min(zeta_cdw_zint(sbtrx_idx,sbtry_idx))); %%% minimum vertically integrated CDW vorticity in the trough


    prodname = [prodir expname '_vortPVint-v2.mat'];
    load(prodname)

    yyf_if = find(yyf<Yiceshelf,1,'last');
    Adv_if_Aint(ne) = Advec_Aint(yyf_if);
    Cori_if_Aint(ne) = Cori_Aint(yyf_if);
    BPT_if_Aint(ne) = BPT_Aint(yyf_if);
    IPT_if_Aint(ne) = IPT_Aint(yyf_if);
    PT_if_Aint(ne) = BPTplusIPT_Aint(yyf_if);

    yyf_sb1 = find(yyf<Ymin,1,'last');
    yyf_sb2 = find(yyf<Ymax,1,'last');
    PT_sb_Aint(ne) = BPTplusIPT_Aint(yyf_sb1)-BPTplusIPT_Aint(yyf_sb2);
    BPT_sb_Aint(ne) = BPT_Aint(yyf_sb1)-BPT_Aint(yyf_sb2);
    IPT_sb_Aint(ne) = IPT_Aint(yyf_sb1)-IPT_Aint(yyf_sb2);
end


save('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary_vorticity',...
    'Cori_all','IPT_all','Adv_all',...
    'BPTplusIPT_sb','BPT_sb','IPT_sb','zeta_cdw_tr','zeta_cdw_sbtr_min','w_dia_is',...
    'Adv_if_Aint','Cori_if_Aint','BPT_if_Aint','IPT_if_Aint','PT_if_Aint',...
    'PT_sb_Aint','BPT_sb_Aint','IPT_sb_Aint',...
    'EXPNAME')

%%

load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary_vorticity.mat')
load('/Users/csi/MITgcm_UC/products/matrix_seaice_boundary.mat')

w_dia_is = w_dia_is/1e6; %%% convert to Sv

group = 1:20;

group1 = [1:14 17 18];  %%% exclude cases with Htr0
% group2 = [1:8 12:14 17]; %%% exclude cases with varying thermocline depth and Htr0
 group2 = [1:8 13:14 17]; %%% exclude cases with varying thermocline depth and Htr0

fontsize = 16;

corrcoef(Adv_if_Aint(group2),PT_sb_Aint(group2))


corrcoef(w_dia_is(group),Ug_east_transportweighted(group))
corrcoef(w_dia_is(group2),Ug_east_transportweighted(group2))


corrcoef(w_dia_is(group),Ueast_transportweighted(group)) 
corrcoef(w_dia_is(group2),Ueast_transportweighted(group2)) 


corrcoef(w_dia_is(group),Tot_Sv(group)) 


% corrcoef(Cori_all(group2),zeta_cdw_tr(group2)) 
corrcoef(Cori_all(group2),zeta_cdw_sbtr_min(group2)) 

corrcoef(w_dia_is(group),BPTplusIPT_sb(group)) %%% 0.7
corrcoef(w_dia_is(group2),BPTplusIPT_sb(group2)) %%% 0.7



corrcoef(Adv_all(group),Cori_all(group)) 

corrcoef(w_dia_is(group),Cori_all(group)) %%% 0.97

corrcoef(Cori_all(group),MeltRate_m(group)) %%% 0.97
corrcoef(w_dia_is(group),MeltRate_m(group)) %%% 0.97


corrcoef(Cori_all(group),Ueast_transportweighted(group)) %%% 0.75


corrcoef(BPTplusIPT_sb(group),Ueast_transportweighted(group)) 
corrcoef(BPTplusIPT_sb(group2),Ueast_transportweighted(group2)) %%% 0.8

corrcoef(BPT_sb(group),Cori_all(group)) %%% 0.70

corrcoef(zeta_cdw_tr(group),BPTplusIPT_sb(group)) %%% 0.71
corrcoef(zeta_cdw_tr(group),IPT_sb(group)) %%% 0.85
corrcoef(zeta_cdw_tr(group),w_dia_is(group)) %%% 0.2
corrcoef(zeta_cdw_sbtr_min(group),w_dia_is(group)) %%% 0.55
corrcoef(zeta_cdw_sbtr_min(group),Cori_all(group)) %%% 0.58



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

figure(14)
scatter(w_dia_is(group),BPTplusIPT_sb(group))
xlabel('Total upwelling in the cavity (Sv)')
ylabel('BPTplusIPT')
% title({'Area-integrated Coriolis term in the cavity v.s.','Offshore buoyancy gradient'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');




figure()
scatter(zeta_cdw_sbtr_min(group),Cori_all(group))
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');


figure(1)
scatter(w_dia_is(group),Cori_all(group))
xlabel('Total upwelling in the cavity (Sv)')
ylabel('Coriolis term (m^3/s^2)')
title({'Total upwelling in the cavity v.s.','Area-integrated Coriolis term in the cavity'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');

figure(2)
scatter(w_dia_is(group),IPT_all(group))
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
scatter(Cori_all(group1),Ueast_transportweighted(group1))
xlabel('Coriolis term (m^3/s^2)')
ylabel('Undercurrent strength (m/s)')
title({'Area-integrated Coriolis term in the cavity v.s.','Transport-weighted undercurrent strength'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');


figure(4)
scatter(w_dia_is(group),MeltRate_m(group))
xlabel('Total upwelling in the cavity (Sv)')
ylabel('Ice shelf melt rate (m/yr)')
title({'Total upwelling in the cavity v.s.','Ice shelf melt rate'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');


% figure(5)
% scatter(w_dia_is(1:24),MeltRate_m(1:24))
% xlabel('Total upwelling in the cavity (Sv)')
% ylabel('Ice shelf melt rate (m/yr)')
% title({'(Including Exps. not using Adv7) Total upwelling in the cavity v.s.','Ice shelf melt rate'})
% set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');


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
scatter(w_dia_is(group1),BPT_sb(group1))
xlabel('Coriolis term (m^3/s^2)')
ylabel('BPT')
% title({'Area-integrated Coriolis term in the cavity v.s.','Offshore buoyancy gradient'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');

figure(11)
scatter(w_dia_is(group),IPT_sb(group))
xlabel('Coriolis term (m^3/s^2)')
ylabel('IPT')
% title({'Area-integrated Coriolis term in the cavity v.s.','Offshore buoyancy gradient'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');


figure(11)
scatter(w_dia_is(group),BPTplusIPT_sb(group))
xlabel('Coriolis term (m^3/s^2)')
ylabel('IPT')
% title({'Area-integrated Coriolis term in the cavity v.s.','Offshore buoyancy gradient'})
set(gca,'FontSize',fontsize);grid on;set(gcf,'color','w');





