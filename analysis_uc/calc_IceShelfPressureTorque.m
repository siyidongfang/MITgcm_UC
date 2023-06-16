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


    tt(tt==0)=NaN;

    tt_vgrid = tt;
    tt_ugrid = tt;
    
    tt_vgrid(:,2:Ny,:) = (tt(:,1:Ny-1,:)+tt(:,2:Ny,:))/2; %%% v-grid
    tt_ugrid(2:Nx,:,:) = 0.5.*(tt(1:Nx-1,:,:)+tt(2:Nx,:,:)); %%% u-grid
    

    DXG = rdmds(fullfile(resultspath,'DXG'));
    DYF = rdmds(fullfile(resultspath,'DYF'));
    RAZ = rdmds(fullfile(resultspath,'RAZ'));  



%%

    %%% plot temperature at the tilted surface of the ice shelf
    tt_isbs = zeros(Nx,Ny);
    tt_isbb = zeros(Nx,Ny);

    isb_surf = zeros(Nx,Ny);
    isb_bot = zeros(Nx,Ny);

    % isb_surf_ugrid = zeros(Nx,Ny);
    % isb_bot_ugrid = zeros(Nx,Ny);
    % 
    % isb_surf_vgrid = zeros(Nx,Ny);
    % isb_bot_vgrid = zeros(Nx,Ny);


    zz_surf = zeros(Nx,Ny);
    zz_bot = zeros(Nx,Ny);

    for i=1:Nx
        for j=1:Ny
            kkk = find(~isnan(tt(i,j,:)),1);
            if(~isempty(kkk))
                tt_isbs(i,j) = tt(i,j,kkk);
                isb_surf(i,j)= kkk;
            end
            % kkk_ugrid = find(~isnan(tt_ugrid(i,j,:)),1);
            % if(~isempty(kkk_ugrid))
            %     isb_surf_ugrid(i,j)= kkk_ugrid;
            % end
            % kkk_vgrid = find(~isnan(tt_vgrid(i,j,:)),1);
            % if(~isempty(kkk_vgrid))
            %     isb_surf_vgrid(i,j)= kkk_vgrid;
            % end
        end
    end

    for i=1:Nx
        for j=1:Ny
            kkk = find(~isnan(tt(i,j,:)));
            if(~isempty(kkk))
                tt_isbb(i,j) = tt(i,j,kkk(end));
                isb_bot(i,j)=kkk(end);
            end
            % kkk_ugrid = find(~isnan(tt_ugrid(i,j,:)));
            % if(~isempty(kkk_ugrid))
            %     isb_bot_ugrid(i,j)= kkk_ugrid(end);
            % end
            % kkk_vgrid = find(~isnan(tt_vgrid(i,j,:)));
            % if(~isempty(kkk_vgrid))
            %     isb_bot_vgrid(i,j)= kkk_vgrid(end);
            % end

        end
    end

    isb_surf(isb_surf==0)=NaN;
    isb_surf(isb_surf==1)=NaN;

    % isb_surf_ugrid(isb_surf_ugrid==0)=NaN;
    % isb_surf_ugrid(isb_surf_ugrid==1)=NaN;
    % 
    % isb_surf_vgrid(isb_surf_vgrid==0)=NaN;
    % isb_surf_vgrid(isb_surf_vgrid==1)=NaN;

    isb_bot(isb_bot==0)=NaN;
    isb_bot(isb_bot==Nr)=NaN;

    % isb_bot_ugrid(isb_bot_ugrid==0)=NaN;
    % isb_bot_ugrid(isb_bot_ugrid==Nr)=NaN;
    % isb_bot_vgrid(isb_bot_vgrid==0)=NaN;
    % isb_bot_vgrid(isb_bot_vgrid==Nr)=NaN;

    isb_bot(YY>=100000)=NaN;
    isb_bot(XX<=-150000)=NaN;

    for i=1:Nx
        for j=1:Ny
            if(~isnan(isb_surf(i,j)))
            zz_surf(i,j) = zz(isb_surf(i,j));
            end
            if(~isnan(isb_bot(i,j)))
            zz_bot(i,j)  = zz(isb_bot(i,j));
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
    subplot(3,2,1);pcolor(xx/1000,yy/1000,tt_isbs');shading flat;colorbar;colormap(redblue);clim([-2 2]);ylim([0 120])
    subplot(3,2,2);pcolor(xx/1000,yy/1000,isb_surf');shading flat;colorbar;colormap(redblue);ylim([0 120]);title('z index of the top wet cell in the ice shelf cavity')
    subplot(3,2,3);pcolor(xx/1000,yy/1000,tt_isbb');shading flat;colorbar;colormap(redblue);clim([-2 2]);ylim([0 120])
    subplot(3,2,4);pcolor(xx/1000,yy/1000,isb_bot');shading flat;colorbar;colormap(redblue);ylim([0 120]);title('z index of the bottom wet cell in the ice shelf cavity')
    subplot(3,2,5);pcolor(xx/1000,yy/1000,zz_surf');shading flat;colorbar;colormap(redblue);ylim([0 120])
    subplot(3,2,6);pcolor(xx/1000,yy/1000,zz_bot');shading flat;colorbar;colormap(redblue);ylim([0 120])


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate the ice-shelf pressure torque %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Exclude the column with only one wet point in the vertical direction in
%%% the cavity, because it is impossible to distangle bottom pressure
%%% torque and ice-shelf pressure torque for these points.

zeta_ISdPhi = zeros(Nx,Ny);

for i = 2:Nx
    for j = 2:Ny
        %%% Using tgrid to calculate pressure torque -- not ideal
        if(~isnan(isb_surf(i,j)))
            zidx_int = isb_surf(i,j):isb_surf(i,j)+nnz;

            %%% Vertically integrate the momentum tendency from hydrostatic
            %%% pressure gradient over a flat surface
            Um_dPhiX_zint1 = rho0.*sum(Um_dPhiX(i,j-1,zidx_int).*hFacW(i,j-1,zidx_int).*DZ(i,j-1,zidx_int),3,'omitnan');
            Um_dPhiX_zint2 = rho0.*sum(Um_dPhiX(i,j,zidx_int).*hFacW(i,j,zidx_int).*DZ(i,j,zidx_int),3,'omitnan');
    
            Vm_dPhiY_zint1 = rho0.*sum(Vm_dPhiY(i-1,j,zidx_int).*hFacS(i-1,j,zidx_int).*DZ(i-1,j,zidx_int),3,'omitnan');
            Vm_dPhiY_zint2 = rho0.*sum(Vm_dPhiY(i,j,zidx_int).*hFacS(i,j,zidx_int).*DZ(i,j,zidx_int),3,'omitnan');
    
            %%% Ice-shelf pressure torque
            zeta_ISdPhi(i,j) = ( Um_dPhiX_zint1*DXG(i,j-1) + Vm_dPhiY_zint2*DYF(i,j) ...
                               - Um_dPhiX_zint2*DXG(i,j)   - Vm_dPhiY_zint1*DYF(i-1,j) ) ./RAZ(i,j); 
        end

    end
end

zeta_ISdPhi(zeta_ISdPhi==0)=NaN;

% prodname = [prodir '/BCvorticity/' expname '_IceShelfPT']
% save(prodname,'zeta_ISdPhi','zeta_ISdPhi_old','xx','yy')



figure(5)
pcolor(xx/1000,yy/1000,zeta_ISdPhi');shading flat;colorbar;colormap(redblue);ylim([0 120])
clim([-1 1]/1e5)



        % zeta_ISdPhi_old(zeta_ISdPhi_old==0)=NaN;
    
        % figure(4)
        % pcolor(xx/1000,yy/1000,zeta_ISdPhi_old');shading flat;colorbar;colormap(redblue);ylim([0 120])
        % clim([-1 1]/1e5)
        
        % figure(6) %%% Check the difference
        % pcolor(xx/1000,yy/1000,zeta_ISdPhi'-zeta_ISdPhi_old');shading flat;colorbar;colormap(redblue);ylim([0 120])
        % clim([-1 1]/1e5)


        % nnz = 4;
        % Um_dPhiX_zint1 = 0;
        % Um_dPhiX_zint2 = 0;
        % Vm_dPhiY_zint1 = 0;
        % Vm_dPhiY_zint2 = 0;
        % %%% Use ugrid and vgrid to calculate the vertically integrated
        % %%% momentum budget for U and V, respectively
        % if(~isnan(isb_surf_ugrid(i,j)) && isnan(isb_surf_vgrid(i,j)))
        %     a=a+1;
        % end
        % if(isnan(isb_surf_ugrid(i,j)) && ~isnan(isb_surf_vgrid(i,j)))
        %     b=b+1;
        % end
        % if(isnan(isb_surf_ugrid(i,j)) && isnan(isb_surf_vgrid(i,j)))
        %     c=c+1;
        % end
        % % if(~isnan(isb_surf_ugrid(i,j)))
        % %     zidx_int_ugrid = isb_surf_ugrid(i,j):isb_surf_ugrid(i,j)+nnz;
        % %     %%% Vertically integrate the momentum tendency from hydrostatic
        % %     %%% pressure gradient over a flat surface
        % %     Um_dPhiX_zint1 = rho0.*sum(Um_dPhiX(i,j-1,zidx_int_ugrid).*hFacW(i,j-1,zidx_int_ugrid).*DZ(i,j-1,zidx_int_ugrid),3,'omitnan');
        % %     Um_dPhiX_zint2 = rho0.*sum(Um_dPhiX(i,j,zidx_int_ugrid).*hFacW(i,j,zidx_int_ugrid).*DZ(i,j,zidx_int_ugrid),3,'omitnan');
        % % end
        % % if (~isnan(isb_surf_vgrid(i,j)))
        % %     zidx_int_vgrid = isb_surf_vgrid(i,j):isb_surf_vgrid(i,j)+nnz;
        % %     Vm_dPhiY_zint1 = rho0.*sum(Vm_dPhiY(i-1,j,zidx_int_vgrid).*hFacS(i-1,j,zidx_int_vgrid).*DZ(i-1,j,zidx_int_vgrid),3,'omitnan');
        % %     Vm_dPhiY_zint2 = rho0.*sum(Vm_dPhiY(i,j,zidx_int_vgrid).*hFacS(i,j,zidx_int_vgrid).*DZ(i,j,zidx_int_vgrid),3,'omitnan');
        % % end
        % 
        % if(~isnan(isb_surf_ugrid(i,j)) && ~isnan(isb_surf_vgrid(i,j)))
        %     zidx_int_ugrid = isb_surf_ugrid(i,j):isb_surf_ugrid(i,j)+nnz;
        %     zidx_int_vgrid = isb_surf_vgrid(i,j):isb_surf_vgrid(i,j)+nnz;
        %     %%% Vertically integrate the momentum tendency from hydrostatic
        %     %%% pressure gradient over a flat surface
        %     Um_dPhiX_zint1 = rho0.*sum(Um_dPhiX(i,j-1,zidx_int_ugrid).*hFacW(i,j-1,zidx_int_ugrid).*DZ(i,j-1,zidx_int_ugrid),3,'omitnan');
        %     Um_dPhiX_zint2 = rho0.*sum(Um_dPhiX(i,j,zidx_int_ugrid).*hFacW(i,j,zidx_int_ugrid).*DZ(i,j,zidx_int_ugrid),3,'omitnan');
        % 
        %     Vm_dPhiY_zint1 = rho0.*sum(Vm_dPhiY(i-1,j,zidx_int_vgrid).*hFacS(i-1,j,zidx_int_vgrid).*DZ(i-1,j,zidx_int_vgrid),3,'omitnan');
        %     Vm_dPhiY_zint2 = rho0.*sum(Vm_dPhiY(i,j,zidx_int_vgrid).*hFacS(i,j,zidx_int_vgrid).*DZ(i,j,zidx_int_vgrid),3,'omitnan');
        % end
        % 
        % %%% Ice-shelf pressure torque
        %     zeta_ISdPhi(i,j) = ( Um_dPhiX_zint1*DXG(i,j-1) + Vm_dPhiY_zint2*DYF(i,j) ...
        %                        - Um_dPhiX_zint2*DXG(i,j)   - Vm_dPhiY_zint1*DYF(i-1,j) ) ./RAZ(i,j); 

  