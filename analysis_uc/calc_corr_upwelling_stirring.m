

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

% ww_all = zeros(1,26);
% Cori_all = zeros(1,26);
% IPT_all = zeros(1,26);
% stir_all = zeros(1,26);
% 
% for n=group_adv7
% % for n=1
%     if(is_prod_run(n))
%         close all
%         expname = EXPNAME{n}
%         loadexp;
%         load_data;
%         load_spacing;
%         
%         prodname = [prodir_vorticity expname '_ww_cdw.mat'];
%         load(prodname)
%         prodname = [prodir_vorticity expname '_vorticity_cdw.mat'];
%         load(prodname)
% 
%         Yiceshelf = 100*m1km;
%         zonal_idx = round((30*m1km)/dx):round((Lx-30*m1km)/dx);%%% exclude sponge layers
%         meri_idx = 1:find(yy<Yiceshelf,1,'last');
%         ww_all(n) = sum(ww_cdw(zonal_idx,meri_idx)*dx*dy,'all','omitnan');
%         Cori_all(n) = sum(zeta_Cori(zonal_idx,meri_idx)*dx*dy,'all','omitnan');
%         IPT_all(n) = sum(zeta_IPT(zonal_idx,meri_idx)*dx*dy,'all','omitnan');
%         Adv_all(n) = sum(zeta_Advec(zonal_idx,meri_idx)*dx*dy,'all','omitnan');
% %         stir_all(n) = 
% 
%     end
% end
% 
% 
% for n=group_noAdv7
%     if(is_prod_run(n))
%         close all
%         expname = EXPNAME{n}
%         prodir = '/Users/csi/MITgcm_UC/products_uc/seaice_boundary/';
%         loadexp;
%         load_data;
%         load_spacing;
% 
%         ww_all(n) = sum(ww_cdw(zonal_idx,meri_idx)*dx*dy,'all','omitnan');
%         Cori_all(n) = sum(zeta_Cori(zonal_idx,meri_idx)*dx*dy,'all','omitnan');
%         IPT_all(n) = sum(zeta_IPT(zonal_idx,meri_idx)*dx*dy,'all','omitnan');
%         Adv_all(n) = sum(zeta_Advec(zonal_idx,meri_idx)*dx*dy,'all','omitnan');
% 
%     end
% end
% 
% save([prodir_vorticity 'matrix_vorticity.mat'],'ww_all','Cori_all','IPT_all','Adv_all','EXPNAME')



load([prodir_vorticity 'matrix_seaice_boundary-allLx.mat'])
load([prodir_vorticity 'matrix_vorticity.mat'])

ww_all = ww_all/1e6;

% group = group_adv7;
group = 1:12
% group = 1:26;
% group = group_noAdv7;

fontsize = 16;



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


