
%%%
%%% calc_AreaWeightedHT_BTstfnCoor.m
%%%
%%% Calculate area-weighted onshore heat transport in Barotropic
%%% streamfunction coordinate, following Eqs. (11)-(13) of Stewart et al (2019).

    clear; 
    close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/customcolormap/;

    expdir = '/Users/csi/MITgcm_UC/exps_uc/seaice_boundary/';
    prodir = '/Users/csi/MITgcm_UC/products_uc/seaice_boundary/';
    expname = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_prod'
    figdir = '/Users/csi/MITgcm_UC/figures_uc/heat_along_BTstreamfunc/seaice_boundary/';

    loadexp;

    rho_o =1000;
    cp_o = 3994; % Unit: J/kg/degC

    load([prodir '/' expname '_tavg_5yrs.mat'],'UVEL','VVELTH');
    uu = UVEL;
    vt = VVELTH;
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    UU = sum(uu.*DZ.*hFacW,3); %%% u-grid
    UU(:,Ny) = 0;

    %%% Calculate depth-averaged onshore heat flux
    VT_vgrid = sum(vt.*DZ.*hFacS,3); %%% v-grid
    VT_vorgrid = zeros(Nx,Ny);  % vorticity-gird
    VT_vorgrid(1:Nx-1,:) = (VT_vgrid(1:Nx-1,:)+ VT_vgrid(2:Nx,:))/2; % vorticity-gird
    VT_vorgrid(Nx,:) = (VT_vgrid(Nx,:)+0)/2;
    VT = zeros(Nx,Ny); %%% u-grid
    VT(:,1:Ny-1) = (VT_vorgrid(:,1:Ny-1)+VT_vorgrid(:,2:Ny))/2;   
    
    DRC = rdmds(fullfile(resultspath,'DRC'));
    DZC = repmat(reshape(DRC(1:end-1),[1 1 Nr]),[Nx Ny 1]);

    %%% Create a finer horizontal grid
    ffac = 10;
    Nxf = ffac*Nx;
    Nyf = ffac*Ny;
    delXf = zeros(1,Nxf); 
    delYf = zeros(1,Nyf); 
    for n=1:Nx
        for m=1:ffac
            delXf((n-1)*ffac+m) = delX(n)/ffac;
        end
    end
    for n=1:Ny
        for m=1:ffac
            delYf((n-1)*ffac+m) = delY(n)/ffac;
        end
    end

    dxf = delXf(1); dyf = delYf(1);
    xx  = cumsum((delX +  [0 delX(1:Nx-1)])/2)  -Lx/2;
    xxf= cumsum((delXf + [0 delXf(1:Nxf-1)])/2)-Lx/2;
    
    yy  = cumsum((delY +  [0 delY(1:Ny-1)])/2);
    yyf= cumsum((delYf + [0 delYf(1:Nyf-1)])/2);

    [YY,XX] = meshgrid(yy,xx);
    [YYf,XXf] = meshgrid(yyf,xxf);
    
    %%% Interpolate streamfunction and heat flux onto this new grid
    VTf = interp2(YY,XX,VT,YYf,XXf,'linear');
    UUf = interp2(YY,XX,UU,YYf,XXf,'linear');

    UUf_vgrid = zeros(Nxf,Nyf);
    UUf_vgrid(1,:) = 0;
    UUf_vgrid(2:Nxf,:) = (UUf(1:Nxf-1,:)+UUf(2:Nxf,:))/2; %%% mass-grid
    UUf_vgrid(:,1) = 0;
    UUf_vgrid(:,2:Nyf) = (UUf_vgrid(:,1:Nyf-1)+UUf_vgrid(:,2:Nyf))/2; %%% v-grid

    %%% Calculate the barotropic streamfunction using UUf
    Psif = flip(cumsum(flip(UUf_vgrid.*delYf(1),2),2,'omitnan'),2); %%% on v-grid
    %%% Fill the zeros at the zonal boundaries
    for i = 1:find(Psif(:,1)~=0,1,'first')-1
        Psif(i,:)=Psif(find(Psif(:,1)~=0,1,'first'),:);
    end
    for i = find(Psif(:,1)~=0,1,'last'):Nxf
        Psif(i,:)=Psif(find(Psif(:,1)~=0,1,'last'),:);
    end

    Psif(VTf==0)=NaN;
    Psif(isnan(VTf))=NaN;

    %%% Plot BT streamfunction
    plot_BTStreamfunc

    Sv=1e6;
    min_stfn = min(min(Psif))/Sv;
    max_stfn = max(max(Psif))/Sv;
    stfn = [min_stfn:0.035:max_stfn max_stfn];
    Nsf = length(stfn);
    A = zeros(1,Nsf); %%% Area, defined by Eq. (12) of Stewart et al 2019.
    HT_Aint = zeros(1,Nsf); %%% Area integrated onshore heat transport
    HT = zeros(1,Nsf-1); %%% Area weighted onshore heat transport HT = d HT_Aint ./ d A

    for ns = 1:Nsf
        clear Psi0
        Psi0 = Psif;
        st = stfn(ns)*Sv;
        Psi0(Psi0>=st)=NaN;
        A(ns) = sum(Psi0./Psi0*dxf*dyf,'all','omitnan');
        HT_Aint(ns) = sum(-cp_o*rho_o*VTf.*Psi0./Psi0*dxf*dyf,'all','omitnan');
    end

    HT = (HT_Aint(2:Nsf)-HT_Aint(1:Nsf-1))./ (A(2:Nsf)-A(1:Nsf-1));
    m1km = 1000;
    ystar = A/Lx/m1km;

    figure(1)
    plot(ystar,stfn,'LineWidth',2)
    grid on;
    set(gca,'FontSize',fontsize);
    xlabel('Pseudo-offshore distance y* (km)','FontSize',fontsize+2,'interpreter','latex');
    ylabel('Barotropic streamline (Sv)','FontSize',fontsize+2,'interpreter','latex');
    

    figure(2)
    plot(ystar,HT_Aint./Lx/1e12,'LineWidth',2)
    grid on;
    set(gca,'FontSize',fontsize);
    xlabel('Pseudo-offshore distance y* (km)','FontSize',fontsize+2,'interpreter','latex');
    ylabel('(TW)','FontSize',fontsize+2,'interpreter','latex');
    title('Onshore heat transport $\frac{1}{L_y}\big[c_p\rho_o\int_{z=-\eta_{\,b}}^{z=0}\overline{v\theta}^t dz\big]_\Psi$','FontSize',fontsize+3,'interpreter','latex');

    figure(3)
    plot(ystar(2:Nsf),HT/1e6,'LineWidth',2)
    grid on;
    set(gca,'FontSize',fontsize);
    xlabel('Pseudo-offshore distance y* (km)','FontSize',fontsize+2,'interpreter','latex');
    ylabel('($10^6 \ \mathrm{W/m}$)','FontSize',fontsize+2,'interpreter','latex');
    title('Onshore heat flux $\frac{d}{dA}\big[c_p\rho_o\int_{z=-\eta_{b}}^{z=0}\overline{v\theta}^t dz\big]_\Psi$','FontSize',fontsize+3,'interpreter','latex');


    ns = 2
    clear Psi0
    Psi0 = Psif;
    st = stfn(ns)*Sv;
    Psi0(Psi0>=st)=NaN;

    figure(4)
    pcolor(Psi0)
    shading flat;colorbar;colormap;






