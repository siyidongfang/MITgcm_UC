%%%
%%% compareSurfFormStress.m
%%%
%%% Compares the "surface" form stress between experiments.
%%%


%%% Define experiments
basedir = '/Volumes/LaCie/UCLA/Projects/MITgcm_FS/experiments';
expdir = basedir;
expnames = { ...
  'FS_taue0.15_tauw0_Q10_res8km_ridge_kpp_noaabw', ...  
  'FS_taue0.15_tauw0_Q10_res8km_ridge_kpp_FF50', ...  
  'FS_taue0.15_tauw0_Q10_res8km_ridge_kpp_FF100', ... 
  'FS_taue0.15_tauw0_Q10_res8km_ridge_kpp_FF150', ...
  'FS_taue0.15_tauw0.05_Q10_res8km_ridge_kpp', ...
  'FS_taue0.075_tauw0.05_Q10_res8km_ridge_kpp', ...
  'FS_taue0.15_tauw0_Q10_res8km_bump_kpp_noaabw', ...
  'FS_taue0.15_tauw0.05_Q10_res8km_bump_kpp', ...
  'FS_taue0.075_tauw0.05_Q10_res8km_bump_kpp'};
legnames = { ...
  'RIDGE\_noAABW', ...  
  'RIDGE, Q_0=50 W/m^2', ...  
  'RIDGE, Q_0=100 W/m^2', ...  
  'RIDGE, Q_0=150 W/m^2', ...  
  'RIDGE\_reference', ...
  'RIDGE\_weakSAM', ...
  'BUMP\_noAABW', ...
  'BUMP\_reference', ...
  'BUMP\_weakSAM'};
markers = {...
  '+', ...
  'o', ...
  '*', ...
  'x', ...
  's', ...
  'd', ...
  '^', ...
  'v', ...
  'p'};
colors = {...
  [0    0.4470    0.7410], ...
  [0    0.4470    0.7410], ...
  [0    0.4470    0.7410], ...
  [0    0.4470    0.7410], ...
  [0.8500    0.3250    0.0980], ...
  [0.8500    0.3250    0.0980], ...
  [0.4660    0.6740    0.1880], ...
  [0.4660    0.6740    0.1880], ...
  [0.4660    0.6740    0.1880]};
Nexp = length(expnames);
fontsize = 14;

%%% Load an experiment to get things started
expname = expnames{1};
loadexp;

%%% Minimum latitude from which to calculate total form stress
ymin = 5e5;

%%% Range of latitudinal indices over which to calculate lower cell
%%% strength
exp_startidx = 13;
% exp_startidx = 63;
% exp_startidx = 101;
exp_endidx = 238;
exp_startidx_e = 63;

%%% Calculate MOC and form stress for each experiment
exp_formStress_zint = zeros(Nexp,Ny);
exp_formStress_tot = zeros(Nexp,1);
exp_psi_lower = zeros(Nexp,1);
exp_psim_lower = zeros(Nexp,1);
exp_psim_lower2 = zeros(Nexp,1);
exp_psi_upper = zeros(Nexp,1);
exp_psie_lower = zeros(Nexp,1);
exp_EKE = zeros(Nexp,1);
for n=1:Nexp
  
  expname = expnames{n};
  
  %%% "Surface" form stress
  calcSurfFormStress;
  exp_formStress_zint(n,:) = formStress_zint;
  exp_formStress_tot(n) = sum(formStress_zint(yy>ymin)*delY(1));

  %%% MOC
  load([expname,'_MOC_pt.mat'],'psi_pt','psim_pt','psie_pt');  
  exp_psi_lower(n) = -max(min(psi_pt(exp_startidx:exp_endidx,:),[],2));
  exp_psim_lower(n) = -max(min(psim_pt(exp_startidx:exp_endidx,:),[],2));
  exp_psim_lower2(n) = -min(min(psim_pt(exp_startidx:exp_endidx,:),[],2));
  exp_psi_upper(n) = max(max(psi_pt(:,:),[],2));
  exp_psie_lower(n) = -min(min(psie_pt(exp_startidx_e:exp_endidx,:),[],2));
  
  %%% EKE
  calcTotalEKE;
  exp_EKE(n) = EKEtot;
  
end



%%% Plot form stress profiles
figure(10);
clf;
for n=1:Nexp
  plot(yy/1000,exp_formStress_zint(n,:));
  hold on;
end
hold off;
legend(expnames,'interpreter','none');
xlabel('y (km)');
ylabel('Surface form stress (N/m)');



%%% Plotting options
scrsz = get(0,'ScreenSize');
framepos = [0.25*scrsz(3) 0.15*scrsz(4) 900 350];
ax1_pos = [0.06 0.14 0.34 0.8];
ax2_pos = [0.46 0.14 0.34 0.8];
lab_size = [0.05 0.03];
legpos = [0.82 0.32 0.16 0.44];

%%% Set up the frame
figure(11);
clf; 
set(gcf,'Position',framepos);
set(gcf,'Color','w');

%%% Plot total form stress vs MOC
axes('Position',ax1_pos);
for n=1:Nexp
  plot(exp_psi_lower(n),-exp_formStress_tot(n)/1e12,markers{n},'MarkerSize',10,'Color',colors{n},'LineWidth',1.5);
  hold on;
end
plot(exp_psi_lower(1:4),-exp_formStress_tot(1:4)/1e12,'-','Color',colors{1},'LineWidth',1.5);
% plot(exp_psim_lower2(5:6),-exp_formStress_tot(5:6)/1e12,'-','Color',colors{5});
% plot(exp_psim_lower2(8:9),-exp_formStress_tot(8:9)/1e12,'-','Color',colors{8});
hold off;
% plot(exp_psim_lower2,-exp_formStress_tot,'-o');
xlabel('AABW export T_A (Sv)');
ylabel('Surface-induced form stress F_s_u_r_f (TN)');
set(gca,'FontSize',fontsize);
axis([0 2.5 0 4]);

%%% Plot EKE vs MOC
axes('Position',ax2_pos);
for n=1:Nexp
  plot(exp_psie_lower(n),rho0*exp_EKE(n)/1e15,markers{n},'MarkerSize',10,'Color',colors{n},'LineWidth',1.5);
  hold on;
end
plot(exp_psie_lower(1:4),rho0*exp_EKE(1:4)/1e15,'-','Color',colors{1},'LineWidth',1.5);
% plot(exp_psi_lower(5:6),rho0*exp_EKE(5:6)/1e15,'-','Color',colors{5});
% plot(exp_psi_lower(8:9),rho0*exp_EKE(8:9)/1e15,'-','Color',colors{8});
hold off;
xlabel('Eddy MOC strength (Sv)');
ylabel('Total EKE (PJ)');
axis([0 2 0 25]);
set(gca,'FontSize',fontsize);

handle = legend(legnames);
set(handle,'Position',legpos);

%%% Labels
annotation('textbox',[ax1_pos(1)-0.05 ax1_pos(2)-0.08 lab_size],'String','(a)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
annotation('textbox',[ax2_pos(1)-0.05 ax2_pos(2)-0.08 lab_size],'String','(b)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');

