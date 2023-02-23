


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

    prodir_vorticity = '/Users/csi/MITgcm_UC/products_vorticity/';
    prodname_new = [prodir_vorticity expname '_vorticity_cdw.mat'];
    load(prodname_new)

  

    %%% Create a pseudo-latitude coordinate
    figure(1)
    clf;set(gcf,'color','w');
    [Cslope,h]=contour(XX,YY,bathy,[-3000 3000],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    hold on;[Cwall,h]=contour(XX,YY,bathy,[0 0],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
    hold off;
    shading flat;colorbar;colormap(redblue);
    clim([-5 5]/1e5)
    title('Bathymetry','Interpreter','latex')
    set(gca,'FontSize',fontsize);
    ylim([0 400]);xlim([-300 300])
    yticks(0:100:400);xticks(-300:100:300)
    xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')


    %%% Initialze the coordinate matrix and reference coordinate values
    eta_slope = mean(Cslope(2,:));
    eta_wall = 50*m1km;
    Nslope = size(Cslope,2);
    Nwall = size(Cwall,2);

    ETA = NaN*ones(Nx,Ny);
    F = scatteredInterpolant(...
        [Cwall(1,:) Cslope(1,:)]',...
        [Cwall(2,:) Cslope(2,:)]',...
        [eta_wall*ones(1,Nwall) eta_slope*ones(1,Nslope)]',...
      'natural','linear');
    ETA = F(XX,YY);



    figure()
    pcolor(XX/1000,YY/1000,ETA);shading flat;
    colorbar;clim([-4000 0])


%     ETA = NaN*ones(Nx,Ny);
%     eta_gl = mean(cntr_gl(2,:));
%     eta_if = mean(cntr_if(2,:));
%     eta_sb = mean(cntr_sb(2,:));
%     eta_nb = -50;
% 
%     F = scatteredInterpolant(...
%       [cntr_if(1,:) cntr_sb(1,:) XC(:,end)' XC(:,end)' ]', ...
%       [cntr_if(2,:) cntr_sb(2,:) YC(:,end)' (-90*ones(1,Nx)) ]', ...
%       [eta_if*ones(1,Nif) eta_sb*ones(1,Nsb) YC(:,end)' (-90*ones(1,Nx)) ]', ...
%       'natural','linear');
%     ETA = F(XC,YC);





    fontsize = 17;

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


