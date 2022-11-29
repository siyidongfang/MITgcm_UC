%%%
%%% calc_BTvorticity_Aint.m
%%%
%%% Calculate area-integrated barotropic vorticity


    %%% Cumulatively integrate the vorticity terms from south to north
    zeta_dPhi_Aint = zeros(1,Ny);
    zeta_Advec_Aint = zeros(1,Ny);
    zeta_Diss_Aint = zeros(1,Ny);
    zeta_Ext_Aint = zeros(1,Ny);
    zeta_residual_Aint = zeros(1,Ny);

    zeta_Cori_Aint = zeros(1,Ny);
    zeta_AdvZ3_Aint = zeros(1,Ny);
    zeta_AdvRe_Aint = zeros(1,Ny);

    xidx = 11:Nx-10;

    for j=2:Ny
        zeta_dPhi_Aint(j) = zeta_dPhi_Aint(j-1)+sum(zeta_dPhi(xidx,j)*dx);
        zeta_Advec_Aint(j) = zeta_Advec_Aint(j-1)+sum(zeta_Advec(xidx,j)*dx);
        zeta_Diss_Aint(j) = zeta_Diss_Aint(j-1)+sum(zeta_Diss(xidx,j)*dx);
        zeta_Ext_Aint(j) = zeta_Ext_Aint(j-1)+sum(zeta_Ext(xidx,j)*dx);
        zeta_residual_Aint(j) = zeta_residual_Aint(j-1)+sum(zeta_residual(xidx,j)*dx);
    end

    figure(10)
    clf;set(gcf,'color','w');
    plot(zeta_dPhi_Aint,'LineWidth',2)
    hold on;
    plot(zeta_Advec_Aint,'LineWidth',2)
    plot(zeta_Diss_Aint,'LineWidth',2)
    plot(zeta_Ext_Aint,'LineWidth',2)
    plot(zeta_residual_Aint,'--','LineWidth',2,'Color',gray)
    grid on;
    leg1  = legend('Pressure torque','Advection','Dissipation','External','Residual');
    set(leg1,'Position', [0.4108 0.2215 0.2804 0.2524])
    set(gca,'FontSize',fontsize);
    title('Cumulatively integrated vorticity budget')
    ylabel('(m^3/s^2)')
    xlabel('Latitude (km)')










