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
    figdir = 'fig_utstar/'

    for ne =1
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
    title('Friction velocity u* (m/s)','FontWeight','normal')
    xlabel('Longitude x (km)');ylabel('Latitude y (km)')

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
    title('Thermal driving T* (degC)','FontWeight','normal')
    xlabel('Longitude x (km)');ylabel('Latitude y (km)')


    subplot(2,2,3)    
    pcolor(xx/1000,yy/1000,uTstar');shading flat;colorbar;
    colormap(WhiteBlueGreenYellowRed(6));
    clim([-1e-7 0.7e-4]);
    xlim([-120 120]);ylim([0 120]);
    hold on;
    [C,h]=contour(XX(:,230/2:250/2)/1000,YY(:,230/2:250/2)/1000,bathy(:,230/2:250/2),[-2000 -1000],'k--','ShowText','on');clabel(C,h,'LabelSpacing',800);
    [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-950:100:-450],'k:','LineWidth',1.5,'ShowText','off');
    [C,h]=contour(XX(:,1:230/2)/1000,YY(:,1:230/2)/1000,bathy(:,1:230/2),[-900:100:-600],'k:','LineWidth',1.5,'ShowText','on');
    [C,h]=contour(XX/1000,YY/1000,bathy,[-300 -300],'k','LineWidth',1.5,'ShowText','on');
    set(gca,'FontSize',fontsize);

    title('u*T* (degC m/s)','FontWeight','normal')
    xlabel('Longitude x (km)');ylabel('Latitude y (km)')


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
    title('Melt rate (m/yr)','FontWeight','normal')
    xlabel('Longitude x (km)');ylabel('Latitude y (km)')

    print('-dpng','-r150',[figdir expname '_utstar.png']);

    end

  









