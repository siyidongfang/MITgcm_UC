%%%
%%% calc_BCvorticity_cdw_sw.m
%%%
%%% Calculate the baroclinic vorticity budget for the CDW layer and the
%%% surface layer.
%%% Interporate the results onto a finer grid


    load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext',...
        'Vm_dPhiY','Vm_Advec','Vm_Diss','Vm_Ext','Um_Cori','Vm_Cori',...
        'Um_AdvZ3','Um_AdvRe','Vm_AdvZ3','Vm_AdvRe');

    mask_interpolate;


    %%% Interpolate the momentum terms onto this new grid
    Um_dPhiXf = zeros(Nxf,Nyf,Nrf);
    Um_Advecf = zeros(Nxf,Nyf,Nrf);
    Um_Dissf = zeros(Nxf,Nyf,Nrf);
    Um_Extf = zeros(Nxf,Nyf,Nrf);
    Vm_dPhiYf = zeros(Nxf,Nyf,Nrf);
    Vm_Advecf = zeros(Nxf,Nyf,Nrf);
    Vm_Dissf = zeros(Nxf,Nyf,Nrf);
    Vm_Extf = zeros(Nxf,Nyf,Nrf);
    Um_Corif = zeros(Nxf,Nyf,Nrf);
    Vm_Corif = zeros(Nxf,Nyf,Nrf);
    Um_AdvZ3f = zeros(Nxf,Nyf,Nrf);
    Um_AdvRef = zeros(Nxf,Nyf,Nrf);
    Vm_AdvZ3f = zeros(Nxf,Nyf,Nrf);
    Vm_AdvRef = zeros(Nxf,Nyf,Nrf);
    vvf = zeros(Nxf,Nyf,Nrf);
    uuf = zeros(Nxf,Nyf,Nrf);

    %%% Piecewise-constant interpolation for momentum terms
for i=1:Nx
    i
    for j=1:Ny
        for k=1:Nr
            Um_dPhiXf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Um_dPhiX(i,j,k);
            Um_Advecf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Um_Advec(i,j,k);
            Um_Dissf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Um_Diss(i,j,k);
            Um_Extf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Um_Ext(i,j,k);
            Vm_dPhiYf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Vm_dPhiY(i,j,k);
            Vm_Advecf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Vm_Advec(i,j,k);
            Vm_Dissf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Vm_Diss(i,j,k);
            Vm_Extf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Vm_Ext(i,j,k);
            Um_Corif((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Um_Cori(i,j,k);
            Vm_Corif((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Vm_Cori(i,j,k);
            Um_AdvZ3f((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Um_AdvZ3(i,j,k);
            Um_AdvRef((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Um_AdvRe(i,j,k);
            Vm_AdvZ3f((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Vm_AdvZ3(i,j,k);
            Vm_AdvRef((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Vm_AdvRe(i,j,k);
            uuf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = uu(i,j,k);
            vvf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = vv(i,j,k);
        end
    end
end



%%% Vorticity budget for the CDW layer
    mask_ugrid = mask_cdw_ugridf;
    mask_vgrid = mask_cdw_vgridf;
    prodname = [prodir 'BCvorticity/' expname '_BCvorticity_cdw.mat'];
    calc_BCvorticity_cdw_sw_zint;

%%% Vorticity budget for the surface layer
    mask_ugrid = mask_sw_ugridf;
    mask_vgrid = mask_sw_vgridf;
    prodname = [prodir 'BCvorticity/' expname '_BCvorticity_sw.mat'];
    calc_BCvorticity_cdw_sw_zint;

%%% Vorticity budget for all-depth integral
    mask_ugrid = 1;
    mask_vgrid = 1;
    prodname = [prodir 'BCvorticity/' expname '_BCvorticity_AllDepth.mat'];
    calc_BCvorticity_cdw_sw_zint;





clear Um_Corif Vm_Corif
clear Um_AdvZ3f Vm_AdvZ3f
clear Um_Extf Vm_Extf
clear Um_AdvRef Vm_AdvRef
clear Um_Dissf Vm_Dissf
clear Um_Advecf Vm_Advecf
clear Um_dPhiXf Vm_dPhiYf
clear hFacWf hFacSf DZf



prodname = [prodir 'BCvorticity/' expname '_BCvorticity_AllDepth.mat'];
load(prodname,'zeta_dPhi')
zeta_BPT = zeta_dPhi; %%% Bottom pressure torque

prodname = [prodir 'BCvorticity/' expname '_BCvorticity_sw.mat'];
load(prodname,'zeta_dPhi')
zeta_IPT = - zeta_dPhi; %%% Interfacial (isopycnal) pressure torque exerted on the CDW layer

prodname = [prodir 'BCvorticity/' expname '_BCvorticity_cdw.mat'];
load(prodname,'zeta_dPhi','zeta_Advec','zeta_Diss','zeta_residual',...
    'zeta_Cori','zeta_AdvZ3','zeta_AdvRe','XXf','YYf','VV_bc','zeta_betaV','UU_bc')
zeta_BPTplusIPT = zeta_dPhi;
VV_cdw = VV_bc;
UU_cdw = UU_bc;

prodname_new = [prodir expname '_vorticity_cdw.mat'];
save(prodname_new,...
   'zeta_BPT','zeta_IPT','zeta_BPTplusIPT',...
   'zeta_Advec','zeta_Diss','zeta_residual',...
   'zeta_Cori','zeta_AdvZ3','zeta_AdvRe',...
    'XXf','YYf','Hcdw_ugridf','Hcdw_vgridf','Hcdw_tgridf','VV_cdw','zeta_betaV','UU_cdw')


