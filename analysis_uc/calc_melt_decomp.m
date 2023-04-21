%%%
%%% calc_melt_decomp.m
%%% 
%%% Calculate the dynamic-thermodynamic decomposition of ice-shelf melt
%%% rate, following Richter et al. (2022b).


    clear;close all;
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions/;

    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    load_colors;
    figdir = 'fig_utstar/';


    for ne=1:21
    expname = EXPNAME{ne}
    loadexp;
    load_data;
    load_spacing;

    
    %%% Calculate the friction velocity u*
    % Convert SHI_TauX and SHI_TauY to mass grid
    SHI_TauX_massgrid = 0.5*(SHI_TauX+ SHI_TauX([2:Nx 1],:,:));
    SHI_TauY_massgrid = zeros(Nx,Ny);
    SHI_TauY_massgrid(:,1:Ny-1) = 0.5*(SHI_TauY(:,1:Ny-1,:)+SHI_TauY(:,2:Ny,:));

    ustar = sqrt((SHI_TauX_massgrid.^2+SHI_TauY_massgrid.^2)/rho0.^2); %%% on mass grid

    %%% Calculate the thermal driving T*
    load([prodir expname '_tavg_5yrs.mat'],'PHIHYD');
    ZZ = repmat(reshape(zz,[1 1 Nr]),[Nx Ny 1]);
    pp = rhoConst*(-gravity*ZZ + PHIHYD)/1e4; %%% unit: dbar

    %%% Find the top wet cell
    zidxtop = zeros(Nx,Ny); %%% vertical index of the top wet cell
    TM = zeros(Nx,Ny); %%% temperature in the top wet cell
    SM = zeros(Nx,Ny); %%% salinity in the top wet cell
    pB = zeros(Nx,Ny); %%% pressure at the ice shelf base [dbar]

    for ii=1:Nx
        for jj=1:Ny
            if(find(ss(ii,jj,:)>0,1)>0)
                kkk=find(ss(ii,jj,:)>0,1);
                zidxtop(ii,jj) = kkk;
                TM(ii,jj) = tt(ii,jj,kkk);
                SM(ii,jj) = ss(ii,jj,kkk);
                pB(ii,jj) = pp(ii,jj,kkk);
            end
        end
    end

    a = -5.73*1e-2; %%% Slope of liquidus for seawater [degC/psu]
    b = 9.39*1e-2;  %%% Offset of liquidus for seawater [degC]
    c = -7.61*1e-4; %%% change in freezing temperature with pressure [degC/dbar]

    Tstar = TM - (a*SM + b + c*pB);
    uTstar = ustar.*Tstar;
    Tstar(ustar==0)=NaN;
    uTstar(ustar==0)=NaN;
    ustar(ustar==0)=NaN;

    meltrate =-SHIfwFlx*t1year/rho_i;
    meltrate(meltrate==0)=NaN;


    RAC = rdmds([exppath,'/results/RAC']);
    RAC (SHIfwFlx==0)=NaN;
    SHIfwFlx (SHIfwFlx==0)=NaN;
    meltAvg = -sum(SHIfwFlx.*RAC,'all','omitnan')*t1year/rho_i/sum(RAC,'all','omitnan'); %%% m/yr
    uTstarAvg = sum(uTstar.*RAC,'all','omitnan')/sum(RAC,'all','omitnan');
    MeltConst = meltAvg/t1year/uTstarAvg

    % MeltConst = 0.0280


    fontsize = 17;
    figure(1)
    set(gcf,'Position',[118 286 942 606])
    clf;set(gcf,'Color','w')
    subplot(2,2,1)
    pcolor(xx/1000,yy/1000,ustar');shading flat;colorbar;
    colormap(WhiteBlueGreenYellowRed(6));
    clim([0 5]/1e5);
    xlim([-120 120]);ylim([0 120]);
    hold on;
    [C,h]=contour(XX(:,230/2:250/2)/1000,YY(:,230/2:250/2)/1000,bathy(:,230/2:250/2),[-2000 -1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);
    [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-950:100:-450],'k:','LineWidth',1.5,'ShowText','off');
    [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-900:100:-600],'k:','LineWidth',1.5,'ShowText','on');
    [C,h]=contour(XX/1000,YY/1000,bathy,[-300 -300],'k','LineWidth',1.5,'ShowText','on');
    set(gca,'FontSize',fontsize);
    title('Friction velocity $\overline{u^*}$ (m/s)','Interpreter','latex')
    % xlabel('Longitude x (km)');
    ylabel('Latitude y (km)')
    yticks(0:20:100)

    subplot(2,2,2)
    pcolor(xx/1000,yy/1000,Tstar');shading flat;colorbar;
    colormap(WhiteBlueGreenYellowRed(6));
    clim([-0.1 4]);
    xlim([-120 120]);ylim([0 120]);
    hold on;
    [C,h]=contour(XX(:,230/2:250/2)/1000,YY(:,230/2:250/2)/1000,bathy(:,230/2:250/2),[-2000 -1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);
    [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-950:100:-450],'k:','LineWidth',1.5,'ShowText','off');
    [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-900:100:-600],'k:','LineWidth',1.5,'ShowText','on');
    [C,h]=contour(XX/1000,YY/1000,bathy,[-300 -300],'k','LineWidth',1.5,'ShowText','on');
    set(gca,'FontSize',fontsize);
    title('Thermal driving $\overline{T^*}\ (^\circ\mathrm{C})$','Interpreter','latex')
    % xlabel('Longitude x (km)');
    ylabel('Latitude y (km)')
    yticks(0:20:100)


    subplot(2,2,3)    
    pcolor(xx/1000,yy/1000,t1year*MeltConst*uTstar');shading flat;colorbar;
    colormap(WhiteBlueGreenYellowRed(6));
    % clim([-1e-7 0.7e-4]);
    clim([0 40]);
    xlim([-120 120]);ylim([0 120]);
    hold on;
    [C,h]=contour(XX(:,230/2:250/2)/1000,YY(:,230/2:250/2)/1000,bathy(:,230/2:250/2),[-2000 -1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);
    [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-950:100:-450],'k:','LineWidth',1.5,'ShowText','off');
    [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-900:100:-600],'k:','LineWidth',1.5,'ShowText','on');
    [C,h]=contour(XX/1000,YY/1000,bathy,[-300 -300],'k','LineWidth',1.5,'ShowText','on');
    set(gca,'FontSize',fontsize);
    title(['$C_m\times \overline{u^*} \times \overline{T^*}$ (m/yr), $C_m = t_\mathrm{1yr}\times$' num2str(MeltConst,'%.3f') '$^\circ\mathrm{C}^{-1}$'],'Interpreter','latex')
    xlabel('Longitude x (km)');ylabel('Latitude y (km)')
    yticks(0:20:100)


    subplot(2,2,4)
    pcolor(xx/1000,yy/1000,meltrate');shading flat;colorbar;
    colormap(WhiteBlueGreenYellowRed(6));
    clim([0 40]);
    xlim([-120 120]);ylim([0 120]);
    hold on;
    [C,h]=contour(XX(:,230/2:250/2)/1000,YY(:,230/2:250/2)/1000,bathy(:,230/2:250/2),[-2000 -1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);
    [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-950:100:-450],'k:','LineWidth',1.5,'ShowText','off');
    [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-900:100:-600],'k:','LineWidth',1.5,'ShowText','on');
    [C,h]=contour(XX/1000,YY/1000,bathy,[-300 -300],'k','LineWidth',1.5,'ShowText','on');
    set(gca,'FontSize',fontsize);
    title('Melt rate (m/yr)','Interpreter','latex')
    xlabel('Longitude x (km)');ylabel('Latitude y (km)')
    yticks(0:20:100)

    print('-dpng','-r150',[figdir expname '_utstar.png']);

    end

%%
    for ne=21

        CLIM = [-40 40];
            
        clear RAC SHI_TauX SHI_TauY PHIHYD ZZ pp ss tt pB

        expname = EXPNAME{ne}
        loadexp;
        load_data;
        load_spacing;
    
        %%% Calculate the friction velocity u*
        % Convert SHI_TauX and SHI_TauY to mass grid
        SHI_TauX_massgrid = 0.5*(SHI_TauX+ SHI_TauX([2:Nx 1],:,:));
        SHI_TauY_massgrid = zeros(Nx,Ny);
        SHI_TauY_massgrid(:,1:Ny-1) = 0.5*(SHI_TauY(:,1:Ny-1,:)+SHI_TauY(:,2:Ny,:));
    
        ustar2 = sqrt((SHI_TauX_massgrid.^2+SHI_TauY_massgrid.^2)/rho0.^2); %%% on mass grid
    
        %%% Calculate the thermal driving T*
        load([prodir expname '_tavg_5yrs.mat'],'PHIHYD');
        ZZ = repmat(reshape(zz,[1 1 Nr]),[Nx Ny 1]);
        pp = rhoConst*(-gravity*ZZ + PHIHYD)/1e4; %%% unit: dbar
    
        %%% Find the top wet cell
        zidxtop = zeros(Nx,Ny); %%% vertical index of the top wet cell
        TM = zeros(Nx,Ny); %%% temperature in the top wet cell
        SM = zeros(Nx,Ny); %%% salinity in the top wet cell
        pB = zeros(Nx,Ny); %%% pressure at the ice shelf base [dbar]
    
        for ii=1:Nx
            for jj=1:Ny
                if(find(ss(ii,jj,:)>0,1)>0)
                    kkk=find(ss(ii,jj,:)>0,1);
                    zidxtop(ii,jj) = kkk;
                    TM(ii,jj) = tt(ii,jj,kkk);
                    SM(ii,jj) = ss(ii,jj,kkk);
                    pB(ii,jj) = pp(ii,jj,kkk);
                end
            end
        end
    
        a = -5.73*1e-2; %%% Slope of liquidus for seawater [degC/psu]
        b = 9.39*1e-2;  %%% Offset of liquidus for seawater [degC]
        c = -7.61*1e-4; %%% change in freezing temperature with pressure [degC/dbar]
    
        Tstar2 = TM - (a*SM + b + c*pB);
        uTstar2 = ustar2.*Tstar2;
        Tstar2(ustar2==0)=NaN;
        uTstar2(ustar2==0)=NaN;
        ustar2(ustar2==0)=NaN;
    
        meltrate2 =-SHIfwFlx*t1year/rho_i;
        meltrate2(meltrate2==0)=NaN;
    
    
        RAC = rdmds([exppath,'/results/RAC']);
        RAC (SHIfwFlx==0)=NaN;
        SHIfwFlx (SHIfwFlx==0)=NaN;
        meltAvg = -sum(SHIfwFlx.*RAC,'all','omitnan')*t1year/rho_i/sum(RAC,'all','omitnan'); %%% m/yr
        uTstarAvg = sum(uTstar.*RAC,'all','omitnan')/sum(RAC,'all','omitnan');
        MeltConst2 = meltAvg/t1year/uTstarAvg;

        % Cm = t1year.*(MeltConst+MeltConst2)/2 %%% Mean melt constant times t1year;
        % Cm = t1year.*MeltConst;
        


        um = 0.5*(ustar+ustar2);
        Tm = 0.5*(Tstar+Tstar2);
        du = ustar2-ustar;
        dT = Tstar2-Tstar;

        meltdiff = meltrate2-meltrate;
        Cm = sum(meltdiff.*RAC,'all','omitnan')/sum((um.*dT+Tm.*du).*RAC,'all','omitnan')/t1year;

        thermo = t1year*Cm*um.*dT;
        dyna = t1year*Cm*Tm.*du;




        figure(2)
        set(gcf,'Position',[118 286 942 606])
        clf;set(gcf,'Color','w')
        subplot(2,2,1)
        pcolor(xx/1000,yy/1000,meltrate2'-meltrate');shading flat;colorbar;
        colormap(cmocean('balance'));
        clim(CLIM);
        xlim([-120 120]);ylim([0 120]);
        hold on;
        [C,h]=contour(XX(:,230/2:250/2)/1000,YY(:,230/2:250/2)/1000,bathy(:,230/2:250/2),[-2000 -1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);
        [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-950:100:-450],'k:','LineWidth',1.5,'ShowText','off');
        [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-900:100:-600],'k:','LineWidth',1.5,'ShowText','on');
        [C,h]=contour(XX/1000,YY/1000,bathy,[-300 -300],'k','LineWidth',1.5,'ShowText','on');
        set(gca,'FontSize',fontsize);
        title('$\mathrm{Melt} - \mathrm{Melt}\,_\mathrm{ref}$ (m/yr)','Interpreter','latex')
        % xlabel('Longitude x (km)');
        ylabel('Latitude y (km)')
        yticks(0:20:100)
    
        subplot(2,2,2)
        pcolor(xx/1000,yy/1000,thermo'+dyna');shading flat;colorbar;
        colormap(cmocean('balance'));
        clim(CLIM);
        xlim([-120 120]);ylim([0 120]);
        hold on;
        [C,h]=contour(XX(:,230/2:250/2)/1000,YY(:,230/2:250/2)/1000,bathy(:,230/2:250/2),[-2000 -1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);
        [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-950:100:-450],'k:','LineWidth',1.5,'ShowText','off');
        [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-900:100:-600],'k:','LineWidth',1.5,'ShowText','on');
        [C,h]=contour(XX/1000,YY/1000,bathy,[-300 -300],'k','LineWidth',1.5,'ShowText','on');
        set(gca,'FontSize',fontsize);
        title(['$C_m \times (\overline{u_m^*} \times \Delta \overline{T^*} + \Delta \overline{u^*} \times \overline{T_m^*}), C_m = t_\mathrm{1yr}\times$' num2str(Cm,'%.3f') '$^\circ\mathrm{C}^{-1}$'],'Interpreter','latex')
        % xlabel('Longitude x (km)');
        ylabel('Latitude y (km)')
        yticks(0:20:100)
    
    
        subplot(2,2,3)    
        pcolor(xx/1000,yy/1000,thermo');shading flat;colorbar;
        colormap(cmocean('balance'));
        clim(CLIM);
        xlim([-120 120]);ylim([0 120]);
        hold on;
        [C,h]=contour(XX(:,230/2:250/2)/1000,YY(:,230/2:250/2)/1000,bathy(:,230/2:250/2),[-2000 -1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);
        [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-950:100:-450],'k:','LineWidth',1.5,'ShowText','off');
        [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-900:100:-600],'k:','LineWidth',1.5,'ShowText','on');
        [C,h]=contour(XX/1000,YY/1000,bathy,[-300 -300],'k','LineWidth',1.5,'ShowText','on');
        set(gca,'FontSize',fontsize);
        title(['Thermodynamical, $C_m\times \overline{u_m^*}\times\Delta \overline{T^*}$ (m/yr)'],'Interpreter','latex')
        xlabel('Longitude x (km)');ylabel('Latitude y (km)')
        yticks(0:20:100)
    
    
        subplot(2,2,4)
        pcolor(xx/1000,yy/1000,dyna');shading flat;colorbar;
        colormap(cmocean('balance'));
        clim(CLIM);
        xlim([-120 120]);ylim([0 120]);
        hold on;
        [C,h]=contour(XX(:,230/2:250/2)/1000,YY(:,230/2:250/2)/1000,bathy(:,230/2:250/2),[-2000 -1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);
        [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-950:100:-450],'k:','LineWidth',1.5,'ShowText','off');
        [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-900:100:-600],'k:','LineWidth',1.5,'ShowText','on');
        [C,h]=contour(XX/1000,YY/1000,bathy,[-300 -300],'k','LineWidth',1.5,'ShowText','on');
        set(gca,'FontSize',fontsize);
        title(['Dynamical, $C_m \times \Delta \overline{u^*} \times \overline{T_m^*}$ (m/yr)'],'Interpreter','latex')
        xlabel('Longitude x (km)');ylabel('Latitude y (km)')
        yticks(0:20:100)

        print('-dpng','-r150',[figdir expname '_diff.png']);

    end

  









