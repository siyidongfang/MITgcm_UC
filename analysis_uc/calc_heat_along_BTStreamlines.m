%%%
%%% calc_heat_along_BTStreamfunc.m
%%%
%%% Calculate heat flux along the time-mean barotropic streamfunction.
%%%

    clear; close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/customcolormap/;

    expdir = '/Users/csi/MITgcm_UC/exps_uc/seaice_boundary/';
    prodir = '/Users/csi/MITgcm_UC/products_uc/seaice_boundary/';
    expname = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_prod'
    loadexp;

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

    %%% Calculate the barotropic streamfunction using UUf
    Psif = flip(cumsum(flip(UUf.*delYf(1),2),2,'omitnan'),2);
    %%% Fill the zeros at the zonal boundaries
    for i = 1:find(Psif(:,1)~=0,1,'first')-1
        Psif(i,:)=Psif(find(Psif(:,1)~=0,1,'first'),:);
    end
    for i = find(Psif(:,1)~=0,1,'last'):Nxf
        Psif(i,:)=Psif(find(Psif(:,1)~=0,1,'last'),:);
    end
    %%% Plot BT streamfunction
    plot_BTStreamfunc

    %%% Calculate heat transport along the streamlines

    %%% Start a loop
 
    %%% Select one streamline: e.g, -1.45 Sv
    %%% The qualified streamlines must connect the eastern and western boundaries across the domain.
    Sv=1e6;
    Phi_value_estimate = -1.45*Sv;
    find_continuousBTstreamline; 
    %%% The code is unable to find a continuous BT streamline that accross the domain (connecting the eastern boundary 
    %%% with the western boundary) when this streamline encounters with standing eddies. 

    %%% Find the corresponding values of VTf and UTf along this streamline
    for n=1:length(loc)
        vt_along(n) = VTf(loc(n,1),loc(n,2));
        ut_along(n) = UTf(loc(n,1),loc(n,2));
    end

    figure(3)
    plot(vt_along)
    figure(4)
    plot(ut_along)

    %%% Find the angles between the x-axis and this streamline
    xloc = flip(xxf(loc(:,1))/1000+Lx/2/1000); %%% in km, start from the west
    yloc = flip(yyf(loc(:,2))/1000);           %%% in km
    %%% angle>0 onshore; angle<0 offshore; 
    %%% angle=0 westward; angle = 180 eastward; angle=90 southward; angle=-90 northward
    for n=1:length(loc)
       angle(n) =
    end
    %%% Integrate heat flux along this streamline


    %%% End the loop





    %%% Decompose the heat transport towards the ice shelf cavity into
    %%% (1) heat carried by onshore CDW flow through the trough, and 
    %%% (2) heat carried by westward coastal boundary current along the continent





