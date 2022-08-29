%%%
%%% calc_heat_along_BTStreamfunc.m
%%%
%%% Calculate heat flux along the time-mean barotropic streamfunction.
%%%

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

    %%% Plotting options
    scrsz = get(0,'ScreenSize');
    fontsize = 17;
    framepos = [0 scrsz(4)/2 900 550];
    plotloc = [0.15 0.15 0.7 0.75];


    load([prodir '/' expname '_tavg_5yrs.mat'],'UVEL','VVELTH','UVELTH','WVELTH');
    uu = UVEL;
    vt = VVELTH;
    ut = UVELTH;
    wt = WVELTH;

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
    
    UT = sum(ut.*DZ.*hFacW,3); %%% u-grid

    DRC = rdmds(fullfile(resultspath,'DRC'));
    DZC = repmat(reshape(DRC(1:end-1),[1 1 Nr]),[Nx Ny 1]);
    WT = sum(wt.*DZ.*hFacC,3); %%% mass-grid  WT is much smaller than VT

    %%% Create a finer horizontal grid
    ffac = 20;
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

    xx  = cumsum((delX +  [0 delX(1:Nx-1)])/2)  -Lx/2;
    xxf= cumsum((delXf + [0 delXf(1:Nxf-1)])/2)-Lx/2;
    
    yy  = cumsum((delY +  [0 delY(1:Ny-1)])/2);
    yyf= cumsum((delYf + [0 delYf(1:Nyf-1)])/2);

    [YY,XX] = meshgrid(yy,xx);
    [YYf,XXf] = meshgrid(yyf,xxf);
    
    %%% Interpolate streamfunction and heat flux onto this new grid
    VTf = interp2(YY,XX,VT,YYf,XXf,'linear');
    UTf = interp2(YY,XX,UT,YYf,XXf,'linear');
    UUf = interp2(YY,XX,UU,YYf,XXf,'linear');

    UUf_vgrid = zeros(Nxf,Nyf);
    UUf_vgrid(1,:) = 0;
    UUf_vgrid(2:Nxf,:) = (UUf(1:Nxf-1,:)+UUf(2:Nxf,:))/2; %%% mass-grid
    UUf_vgrid(:,1) = 0;
    UUf_vgrid(:,2:Nyf) = (UUf_vgrid(:,1:Nyf-1)+UUf_vgrid(:,2:Nyf))/2; %%% v-grid
   
    UTf_vgrid = zeros(Nxf,Nyf);
    UTf_vgrid(1,:) = 0;
    UTf_vgrid(2:Nxf,:) = (UTf(1:Nxf-1,:)+UTf(2:Nxf,:))/2; %%% mass-grid
    UTf_vgrid(:,1) = 0;
    UTf_vgrid(:,2:Nyf) = (UTf_vgrid(:,1:Nyf-1)+UTf_vgrid(:,2:Nyf))/2; %%% v-grid
   

    %%% Calculate the barotropic streamfunction using UUf
    Psif = flip(cumsum(flip(UUf_vgrid.*delYf(1),2),2,'omitnan'),2); %%% on v-grid
    %%% Fill the zeros at the zonal boundaries
    for i = 1:find(Psif(:,1)~=0,1,'first')-1
        Psif(i,:)=Psif(find(Psif(:,1)~=0,1,'first'),:);
    end
    for i = find(Psif(:,1)~=0,1,'last'):Nxf
        Psif(i,:)=Psif(find(Psif(:,1)~=0,1,'last'),:);
    end


    %%% Plot BT streamfunction
%     plot_BTStreamfunc

    %%% Calculate heat transport along the streamlines

    %%% Start a loop
    Sv=1e6;
    min_stfn = min(min(Psif))/Sv;
    stfn = [min_stfn:0.05:0 0];
    
for ns = 1:length(stfn)
% for ns = 2
    clear HT Phi_value loc ut_along vt_along angle
    %%% Select one streamline: e.g, -1.45 Sv
    %%% The qualified streamlines must connect the eastern and western boundaries across the domain.
    Phi_value_estimate = stfn(ns)*Sv;
    find_continuousBTstreamline; 
    %%% The code is unable to find a continuous BT streamline that accross the domain (connecting the eastern boundary 
    %%% with the western boundary) when this streamline encounters with standing eddies. 
    Phi_value_real(ns) = Phi_value(1);
    std_stfn(ns) = std(Phi_value-Phi_value(1))/Sv; %%% Unit: Sv

    Ns = length(loc);
    %%% Find the corresponding values of VTf and UTf along this streamline
    for n=1:Ns
        vt_along(n) = VTf(loc(n,1),loc(n,2));  %%% from east to west
        ut_along(n) = UTf_vgrid(loc(n,1),loc(n,2));  %%% from east to west
    end

    %%% Integrated heat transport along this streamline from east to west
    %   HT = cumsum(ut_along.*cosd(angle)+vt_along.*sind(angle),'omitnan');
    ddist = [0 sqrt((lat(2:Ns)-lat(1:Ns-1)).^2+(lon(2:Ns)-lon(1:Ns-1)).^2)];
    VHT = cp_o*rho_o*cumsum(-vt_along.*ddist,'omitnan')/1e9; %%% positive shoreward, in 1e9 W
    UHT = cp_o*rho_o*flip(cumsum(flip(ut_along.*ddist),'omitnan'))/1e9; %%% positive shoreward, in 1e9 W

    handle = figure(6);set(handle,'Position',[656 151 900 811]);clf;set(gcf,'color','w');
    plot(lon,zeros(1,Ns),'k--')
    hold on;
    plot(lon,VHT,'LineWidth',3); 
    xlim([-300 300]);
    ylim([-4 8]);
    hold off;
    xlabel('Longitude, x (km)');
    ylabel('Onshore Heat transport (GW)');
    grid on;
    set(gca,'FontSize',fontsize);
    text(-280, 6.2,'Positive: onshore heat transport','FontSize',fontsize+3);
    text(-280, 5.5,'Integrated from \it east to west','FontSize',fontsize+3);
    title(['Cumulative eastward heat transport along the streamline \Psi = ' num2str(stfn(ns),'%.2f') ' Sv'],'FontSize',fontsize+3);
    print('-djpeg','-r200', [figdir expname '/VHT_' num2str(stfn(ns),'%.2f') 'Sv.jpg'])


    handle = figure(7);set(handle,'Position',[656 151 900 811]);clf;set(gcf,'color','w');
    plot(lon,zeros(1,Ns),'k--')
    hold on;
    plot(lon,UHT,'b','LineWidth',3); 
    xlim([-300 300]);
    ylim([-50 60]);
    hold off;
    xlabel('Longitude, x (km)');
    ylabel('Eastward Heat transport (GW)');
    grid on;
    set(gca,'FontSize',fontsize);
    text(-280, 53,'Positive: eastward heat transport','FontSize',fontsize+3);
    text(-280, 45,'Integrated from \it west to east','FontSize',fontsize+3);
    title(['Cumulative eastward heat transport along the streamline \Psi = ' num2str(stfn(ns),'%.2f') ' Sv'],'FontSize',fontsize+3);
    print('-djpeg','-r200', [figdir expname '/UHT_' num2str(stfn(ns),'%.2f') 'Sv.jpg'])
end

    %%% End the loop





    %%% Decompose the heat transport towards the ice shelf cavity into
    %%% (1) heat carried by onshore CDW flow through the trough, and 
    %%% (2) heat carried by westward coastal boundary current along the continent





