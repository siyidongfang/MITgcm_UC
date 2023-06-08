    
    clear

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions/;    
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;

    expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng';
    prodir = '/Volumes/si/MITgcm_ASF-csi/products_new/';

    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};

    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_colors;

    ne=1;
    expname = EXPNAME{ne};
    loadexp;
    load_constants;
    load_spacing;
    load([prodir expname '_tavg_5yrs.mat'],'TFLUX','ADVy_TH','TOTTTEND','VVELTH','VVEL','THETA','SALT'...
            ,'ADVr_TH','DFyE_TH','DFrI_TH','DFrE_TH','KPPg_TH','WTHMASS','SIheff','oceQnet','oceFWflx','oceSflux');




    figure(10)
    clf;
    pcolor(yy/1000,xx/1000,oceFWflx)
    shading flat;
    colorbar;colormap(redblue);
    clim([-10 10]/1e5)


    figure(12)
    clf;
    pcolor(yy/1000,xx/1000,oceSflux)
    shading flat;
    colorbar;colormap(redblue);
    clim([-10 10]/1e4)
    sum(sum(oceSflux))


    
    %%
    dy = delY(1);        
    DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
    DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
    DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

    xidx = [20:137];
    ADVy_int = cp_o*rho_o*sum(sum(ADVy_TH(xidx,:,:),3)); % Unit:  W
    Ttend_int = cp_o*rho_o*sum(sum(TOTTTEND(xidx,:,:)/86400.*DZ_xyz(xidx,:,:).*hFacC(xidx,:,:),3)*delX(1));  % Unit:  W/m

    y1= 50*m1km;
    y2= 150*m1km;
    y1idx = round(y1/dy);
    y2idx = round(y2/dy);
    
    adv1 =  ADVy_int(y1idx)/1e12 %%% Advective heat flux across y1=50km
    adv2 =  ADVy_int(y2idx)/1e12 %%% Advective heat flux across y2=150km
    %  IceOcean = sum(sum(TFLUX(xidx,y1idx:y2idx)*delX(1))*delY(1))/1e12 %%% Ice-ocean heat flux, positive downward
    IceOcean = sum(sum(oceQnet(xidx,y1idx:y2idx)*delX(1))*delY(1))/1e12 %%% Ice-ocean heat flux, positive downward
    tendency = sum(Ttend_int(y1idx:y2idx))/1e12 %%% Heat content tendency
    
    Residual = abs(adv2) + IceOcean - abs(adv1) - tendency %%% in TW
  
%%

TFLUX_int = sum(oceQnet(xidx,:)*delX(1));
% TFLUX_int = sum(TFLUX(xidx,:)*delX(1));
dADVdy = (ADVy_int(1:end-1)-ADVy_int(2:end))./delY(1);


figure(1)
clf
% L1 = plot((yy(1:end-1)+yy(2:end))/2/1000,(TFLUX_int(1:end-1)+dADVdy-Ttend_int(1:end-1))/1e6...
    % ,'Color',[0.9 0.9 0.9],'LineWidth',6);
% ylim([-26 26])
xlim([50 428])
hold on;
L2 = plot(yy/1000,Ttend_int/1e6,'LineWidth',2);
L3 = plot(yy/1000,TFLUX_int/1e6,'--','LineWidth',2);
% L4 = plot((yy(1:end-1)+yy(2:end))/2/1000,dADVdy/1e6,'--','LineWidth',2);
L5 = plot(yy/1000,zeros(1,Ny),':','Color',[0.8 0.8 0.8],'LineWidth',2);
fontsize = 15;
set(gca,'FontSize',fontsize)
%  $\partial (\mathrm{ADVy\_TH})/\partial y$
% leg1=legend([L2,L4,L3,L1],'Heat content tendency',... %%% When this curve is positive, heat content increases
leg1=legend([L2,L3],'Heat content tendency',... %%% When this curve is positive, heat content increases
...% 'Advective heat flux convergence',...  %%% When this curve is positive, ocean temperature increases due to advective heat flux convergence
    'Surface heat flux',... %%% When this curve is positive, ocean temperature increases due to ice-ocean heat flux
    ...% 'Residual term',...
    'FontSize', fontsize,...
    'Position',[0.1495 0.7867 0.5902 0.13],'interpreter','latex');
hold off;
% title('Fresh-shelf, 7-year mean, Atide = 0.1 m/s','FontSize',fontsize+2,'interpreter','latex')
% fname = {'Large tides'};
% text(200,20,fname,'FontSize', fontsize+10,'interpreter','latex')
xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('(10$^{6}$ W/m)','FontSize', fontsize+2,'interpreter','latex');
set(gcf,'OuterPosition',[91 155 599 700])



% figure(3)
% pcolor(SIheff')
% shading interp;axis ij;colormap('redblue');colorbar;
% caxis([1 1.4])
% meanHI = mean(SIheff(:,11:end-11),'all')


    
save([prodir expname '_heatbudget_xzint.mat'],'yy','Ttend_int','TFLUX_int','dADVdy')




% figure(1)
% clf
% plot(yy/1000,-Ttend_cum/1e12,'LineWidth',4)
% hold on;
% plot(yy/1000,heatbudget_total2/1e12,'LineWidth',3)
% plot(yy/1000,Tflx_cum/1e12,'--','LineWidth',2)
% plot(yy/1000,ADVy_int/1e12,'--','LineWidth',1.5)
% plot(yy/1000,zeros(1,Ny),':','Color',[0.8 0.8 0.8],'LineWidth',2)
% ylim([-4 0.5])
% fontsize = 13;
% set(gca,'FontSize',fontsize)
% leg1=legend('Integrated temperature tendency',...
%     'Surface heat + Advec. heat (TFLUX+ADVy\_TH)',...
%     'Surface heat exchange (TFLUX)',...
%     'Advective heat transport (ADVy\_TH)','FontSize', fontsize,...
%     'Position',[0.1495 0.7867 0.5902 0.2198]);
% hold off;
% fname = {'Low-res,','fresh-shelf,','5-year mean'};
% text(20,-1,fname,'FontSize', fontsize+4,'interpreter','latex')
% xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
% ylabel('(10$^{12}$ W)','FontSize', fontsize+2,'interpreter','latex');
% set(gcf,'OuterPosition',[91 155 599 700])



    
