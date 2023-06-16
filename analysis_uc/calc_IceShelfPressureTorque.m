%%%
%%% calc_IceShelfPressureTorque.m
%%%
%%% Calculate the pressure torque exerted from the ice shelf to the CDW
%%% layer

    clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions/;    
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;

    %%% Load experiment and data
    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_colors;
    ne =1;
    expname = EXPNAME{ne}
    loadexp;
    load_constants;
    load_data;
    load_spacing;


    load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Vm_dPhiY');
    mask_interpolate;

    %%% Interpolate the momentum terms onto this new grid
    Um_dPhiXf = zeros(Nxf,Nyf,Nrf);
    Vm_dPhiYf = zeros(Nxf,Nyf,Nrf);

    %%% Piecewise-constant interpolation for momentum terms
    for i=1:Nx
        i
        for j=1:Ny
            for k=1:Nr
                Um_dPhiXf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Um_dPhiX(i,j,k);
                Vm_dPhiYf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = Vm_dPhiY(i,j,k);
            end
        end
    end


%%

    %%% plot temperature at the tilted surface of the ice shelf
    tt_isbs = zeros(Nxf,Nyf);
    tt_isbb = zeros(Nxf,Nyf);

    isb_surf = zeros(Nxf,Nyf);
    isb_bot = zeros(Nxf,Nyf);

    isb_surf_ugrid = zeros(Nxf,Nyf);
    isb_bot_ugrid = zeros(Nxf,Nyf);

    isb_surf_vgrid = zeros(Nxf,Nyf);
    isb_bot_vgrid = zeros(Nxf,Nyf);


    zz_surf = zeros(Nxf,Nyf);
    zz_bot = zeros(Nxf,Nyf);

    for i=1:Nxf
        for j=1:Nyf
            kkk = find(~isnan(ttf(i,j,:)),1);
            if(~isempty(kkk))
                tt_isbs(i,j) = ttf(i,j,kkk);
                isb_surf(i,j)= kkk;
            end
            kkk_ugrid = find(~isnan(tt_ugridf(i,j,:)),1);
            if(~isempty(kkk_ugrid))
                isb_surf_ugrid(i,j)= kkk_ugrid;
            end
            kkk_vgrid = find(~isnan(tt_vgridf(i,j,:)),1);
            if(~isempty(kkk_vgrid))
                isb_surf_vgrid(i,j)= kkk_vgrid;
            end
        end
    end

    for i=1:Nxf
        for j=1:Nyf
            kkk = find(~isnan(ttf(i,j,:)));
            if(~isempty(kkk))
                tt_isbb(i,j) = ttf(i,j,kkk(end));
                isb_bot(i,j)=kkk(end);
            end
            kkk_ugrid = find(~isnan(tt_ugridf(i,j,:)));
            if(~isempty(kkk_ugrid))
                isb_bot_ugrid(i,j)= kkk_ugrid(end);
            end
            kkk_vgrid = find(~isnan(tt_vgridf(i,j,:)));
            if(~isempty(kkk_vgrid))
                isb_bot_vgrid(i,j)= kkk_vgrid(end);
            end

        end
    end

    isb_surf(isb_surf==0)=NaN;
    isb_surf(isb_surf==1)=NaN;

    isb_surf_ugrid(isb_surf_ugrid==0)=NaN;
    isb_surf_ugrid(isb_surf_ugrid==1)=NaN;

    isb_surf_vgrid(isb_surf_vgrid==0)=NaN;
    isb_surf_vgrid(isb_surf_vgrid==1)=NaN;

    isb_bot(isb_bot==0)=NaN;
    isb_bot(isb_bot==Nr)=NaN;

    isb_bot_ugrid(isb_bot_ugrid==0)=NaN;
    isb_bot_ugrid(isb_bot_ugrid==Nr)=NaN;
    isb_bot_vgrid(isb_bot_vgrid==0)=NaN;
    isb_bot_vgrid(isb_bot_vgrid==Nr)=NaN;

    isb_bot(YY>=100000)=NaN;
    isb_bot(XX<=-150000)=NaN;

    for i=1:Nxf
        for j=1:Nyf
            if(~isnan(isb_surf(i,j)))
            zz_surf(i,j) = zzf(isb_surf(i,j));
            end
            if(~isnan(isb_bot(i,j)))
            zz_bot(i,j)  = zzf(isb_bot(i,j));
            end
        end
    end

    zz_surf(zz_surf==0)=NaN;
    zz_bot(zz_bot==0)=NaN;
    isb_surf(isb_surf==0)=NaN;

    diff_idx = isb_bot-isb_surf;
    diff_idx_ugrid = isb_bot_ugrid-isb_surf_ugrid;
    diff_idx_vgrid = isb_bot_vgrid-isb_surf_vgrid;

    figure(2)
    subplot(3,2,1);pcolor(xxf/1000,yyf/1000,tt_isbs');shading flat;colorbar;colormap(redblue);clim([-2 2]);ylim([0 120])
    subplot(3,2,2);pcolor(xxf/1000,yyf/1000,isb_surf');shading flat;colorbar;colormap(redblue);ylim([0 120]);title('z index of the top wet cell in the ice shelf cavity')
    subplot(3,2,3);pcolor(xxf/1000,yyf/1000,tt_isbb');shading flat;colorbar;colormap(redblue);clim([-2 2]);ylim([0 120])
    subplot(3,2,4);pcolor(xxf/1000,yyf/1000,isb_bot');shading flat;colorbar;colormap(redblue);ylim([0 120]);title('z index of the bottom wet cell in the ice shelf cavity')
    subplot(3,2,5);pcolor(xxf/1000,yyf/1000,zz_surf');shading flat;colorbar;colormap(redblue);ylim([0 120])
    subplot(3,2,6);pcolor(xxf/1000,yyf/1000,zz_bot');shading flat;colorbar;colormap(redblue);ylim([0 120])


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate the ice-shelf pressure torque %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Exclude the column with only one wet point in the vertical direction in
%%% the cavity, because it is impossible to distangle bottom pressure
%%% torque and ice-shelf pressure torque for these points.

zeta_ISdPhi_old = zeros(Nxf,Nyf);
zeta_ISdPhi = zeros(Nxf,Nyf);

for i = 2:Nxf
    for j = 2:Nyf

        nnz = 10;
        %%% Use ugrid and vgrid to calculate the vertically integrated
        %%% momentum budget for U and V, respectively
        if(~isnan(isb_surf_ugrid(i,j)) && ~isnan(isb_surf_vgrid(i,j)))
            zidx_int_ugrid = isb_surf_ugrid(i,j):isb_surf_ugrid(i,j)+nnz;
            zidx_int_vgrid = isb_surf_vgrid(i,j):isb_surf_vgrid(i,j)+nnz;
            %%% Vertically integrate the momentum tendency from hydrostatic
            %%% pressure gradient over a flat surface
            Um_dPhiX_zint1 = rho0.*sum(Um_dPhiXf(i,j-1,zidx_int_ugrid).*hFacWf(i,j-1,zidx_int_ugrid).*DZf(i,j-1,zidx_int_ugrid),3,'omitnan');
            Um_dPhiX_zint2 = rho0.*sum(Um_dPhiXf(i,j,zidx_int_ugrid).*hFacWf(i,j,zidx_int_ugrid).*DZf(i,j,zidx_int_ugrid),3,'omitnan');
    
            Vm_dPhiY_zint1 = rho0.*sum(Vm_dPhiYf(i-1,j,zidx_int_vgrid).*hFacSf(i-1,j,zidx_int_vgrid).*DZf(i-1,j,zidx_int_vgrid),3,'omitnan');
            Vm_dPhiY_zint2 = rho0.*sum(Vm_dPhiYf(i,j,zidx_int_vgrid).*hFacSf(i,j,zidx_int_vgrid).*DZf(i,j,zidx_int_vgrid),3,'omitnan');
    
            %%% Ice-shelf pressure torque
            zeta_ISdPhi(i,j) = ( Um_dPhiX_zint1*DXGf(i,j-1) + Vm_dPhiY_zint2*DYFf(i,j) ...
                               - Um_dPhiX_zint2*DXGf(i,j)   - Vm_dPhiY_zint1*DYFf(i-1,j) ) ./RAZf(i,j); 
        end

        %%% Using tgrid to calculate pressure torque -- not ideal
        if(~isnan(isb_surf(i,j)))
            zidx_int = isb_surf(i,j):isb_surf(i,j)+nnz;

            %%% Vertically integrate the momentum tendency from hydrostatic
            %%% pressure gradient over a flat surface
            Um_dPhiX_zint1 = rho0.*sum(Um_dPhiXf(i,j-1,zidx_int).*hFacWf(i,j-1,zidx_int).*DZf(i,j-1,zidx_int),3,'omitnan');
            Um_dPhiX_zint2 = rho0.*sum(Um_dPhiXf(i,j,zidx_int).*hFacWf(i,j,zidx_int).*DZf(i,j,zidx_int),3,'omitnan');
    
            Vm_dPhiY_zint1 = rho0.*sum(Vm_dPhiYf(i-1,j,zidx_int).*hFacSf(i-1,j,zidx_int).*DZf(i-1,j,zidx_int),3,'omitnan');
            Vm_dPhiY_zint2 = rho0.*sum(Vm_dPhiYf(i,j,zidx_int).*hFacSf(i,j,zidx_int).*DZf(i,j,zidx_int),3,'omitnan');
    
            %%% Ice-shelf pressure torque
            zeta_ISdPhi_old(i,j) = ( Um_dPhiX_zint1*DXGf(i,j-1) + Vm_dPhiY_zint2*DYFf(i,j) ...
                               - Um_dPhiX_zint2*DXGf(i,j)   - Vm_dPhiY_zint1*DYFf(i-1,j) ) ./RAZf(i,j); 
        end


    end
end

zeta_ISdPhi(zeta_ISdPhi==0)=NaN;
zeta_ISdPhi_old(zeta_ISdPhi_old==0)=NaN;


% prodname = [prodir '/BCvorticity/' expname '_IceShelfPT']
% save(prodname,...
%     'zeta_ISdPhi','zeta_ISdPhi_old','XXf','YYf','xxf','yyf')

figure(4)
pcolor(xxf/1000,yyf/1000,zeta_ISdPhi_old');shading flat;colorbar;colormap(redblue);ylim([0 120])
clim([-1 1]/1e5)

figure(5)
pcolor(xxf/1000,yyf/1000,zeta_ISdPhi');shading flat;colorbar;colormap(redblue);ylim([0 120])
clim([-1 1]/1e5)

figure(6) %%% Check the difference -- negligible 
pcolor(xxf/1000,yyf/1000,zeta_ISdPhi'-zeta_ISdPhi_old');shading flat;colorbar;colormap(redblue);ylim([0 120])
clim([-1 1]/1e5)
  