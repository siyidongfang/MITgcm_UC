%%%
%%% calc_BTVorticity_streamfunc_int
%%%
%%% Integrate the vorticity budget terms along barotropic streamfunction 
%%% This script should be run after calc_BTvorticity_curl_int


    %%% Calculate the barotropic streamfunction
    

    %%% Create a finer horizontal grid
    ffac = 7;
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

    %%% Interpolate the vorticity terms onto this new grid
    zeta_dPhif = interp2(YY,XX,zeta_dPhi,YYf,XXf,'linear');
    zeta_Advecf = interp2(YY,XX,zeta_Advec,YYf,XXf,'linear');
    zeta_Dissf = interp2(YY,XX,zeta_Diss,YYf,XXf,'linear');
    zeta_Extf = interp2(YY,XX,zeta_Ext,YYf,XXf,'linear');
    zeta_residualf = interp2(YY,XX,zeta_residual,YYf,XXf,'linear');
    zeta_Corif = interp2(YY,XX,zeta_Cori,YYf,XXf,'linear');
    zeta_AdvZ3f = interp2(YY,XX,zeta_AdvZ3,YYf,XXf,'linear');
    zeta_AdvRef = interp2(YY,XX,zeta_AdvRe,YYf,XXf,'linear');

    %%% Calculate the area integral
    zeta_dPhi_fhint = zeros(1,LL-1);
    zeta_Advec_fhint = zeros(1,LL-1);
    zeta_Diss_fhint = zeros(1,LL-1);
    zeta_Ext_fhint = zeros(1,LL-1);
    zeta_residual_fhint = zeros(1,LL-1);

    zeta_Cori_fhint = zeros(1,LL-1);
    zeta_AdvZ3_fhint = zeros(1,LL-1);
    zeta_AdvRe_fhint = zeros(1,LL-1);

