%%%
%%% calc_IceShelfPressureTorque.m
%%%
%%% Calculate the pressure torque exerted from the ice shelf to the CDW
%%% layer or the surface layer

    % clear;close all;
% 
%     %%% Add path
%     addpath /Users/csi/MITgcm_UC/analysis_uc/functions/;    
%     addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/;
%     addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
%     addpath /Users/csi/Software/eos80_legacy_gamma_n/;
%     addpath /Users/csi/Software/gsw_matlab_v3_06_11/;
%     addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;
% 
%     %%% Load experiment and data
%     EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
%     exp_group = EXP_GROUP{2}
%     list_exps_new;
%     load_colors;
% 
% for ne =1:4
    clear xx yy zz tt Nr Nx Ny DXG DYF RAZ Um_dPhiX Vm_dPhiY zeta_ISdPhi diff_idx expname isb_surf isb_bot

        ne
        expname = EXPNAME{ne}
        loadexp;
        load_constants;
        load_data;
        load_spacing;

        load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Vm_dPhiY');
    
        tt(tt==0)=NaN;
    
        DXG = rdmds(fullfile(resultspath,'DXG'));
        DYF = rdmds(fullfile(resultspath,'DYF'));
        RAZ = rdmds(fullfile(resultspath,'RAZ'));  
    
    
        %%% plot temperature at the tilted surface of the ice shelf
        tt_isbs = zeros(Nx,Ny);
        tt_isbb = zeros(Nx,Ny);
    
        isb_surf = zeros(Nx,Ny);
        isb_bot = zeros(Nx,Ny);
    
        zz_surf = zeros(Nx,Ny);
        zz_bot = zeros(Nx,Ny);
    
        for i=1:Nx
            for j=1:Ny
                kkk = find(~isnan(tt(i,j,:)),1);
                if(~isempty(kkk))
                    tt_isbs(i,j) = tt(i,j,kkk);
                    isb_surf(i,j)= kkk;
                end
            end
        end
    
        for i=1:Nx
            for j=1:Ny
                kkk = find(~isnan(tt(i,j,:)));
                if(~isempty(kkk))
                    tt_isbb(i,j) = tt(i,j,kkk(end));
                    isb_bot(i,j)=kkk(end);
                end
            end
        end
    
        isb_surf(isb_surf==0)=NaN;
        isb_surf(isb_surf==1)=NaN;
    
        isb_bot(isb_bot==0)=NaN;
        isb_bot(isb_bot==Nr)=NaN;
    
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
    
        % figure(2)
        % subplot(3,2,1);pcolor(xx/1000,yy/1000,tt_isbs');shading flat;colorbar;colormap(redblue);clim([-2 2]);ylim([0 120])
        % subplot(3,2,2);pcolor(xx/1000,yy/1000,isb_surf');shading flat;colorbar;colormap(redblue);ylim([0 120]);title('z index of the top wet cell in the ice shelf cavity')
        % subplot(3,2,3);pcolor(xx/1000,yy/1000,tt_isbb');shading flat;colorbar;colormap(redblue);clim([-2 2]);ylim([0 120])
        % subplot(3,2,4);pcolor(xx/1000,yy/1000,isb_bot');shading flat;colorbar;colormap(redblue);ylim([0 120]);title('z index of the bottom wet cell in the ice shelf cavity')
        % subplot(3,2,5);pcolor(xx/1000,yy/1000,zz_surf');shading flat;colorbar;colormap(redblue);ylim([0 120])
        % subplot(3,2,6);pcolor(xx/1000,yy/1000,zz_bot');shading flat;colorbar;colormap(redblue);ylim([0 120])
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Calculate the ice-shelf pressure torque %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    zeta_ISdPhi = zeros(Nx,Ny);
    
    for i = 2:Nx
        for j = 2:Ny
            clear zidx_int

            if (diff_idx(i,j)==2 || diff_idx(i,j)==1)
                nnz = 0;
            elseif (diff_idx(i,j)>2)
                nnz = 1;
            end
            % nnz=0;
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
    
                %%% It is impossible to distangle bottom pressure torque and ice-shelf pressure torque 
                %%% for the column with only one wet point in the vertical direction in the cavity.
                %%% So, for these column, simply assume that
                %%% bottom pressure torque = ice-shelf pressure torque = half of the total pressure torque
                if(diff_idx(i,j)==1)
                    zeta_ISdPhi(i,j) = zeta_ISdPhi(i,j)/2;
                end
            end
    
        end
    end
    
    zeta_ISdPhi(zeta_ISdPhi==0)=NaN;
    
    prodname = [prodir '/BCvorticity/' expname '_IceShelfPT'];
    save(prodname,'expname','zeta_ISdPhi','xx','yy','diff_idx','isb_surf','isb_bot','tt_isbs','tt_isbb','zz_surf','zz_bot')
    
    figure(5)
    clf;
    pcolor(xx/1000,yy/1000,zeta_ISdPhi');shading flat;colorbar;colormap(redblue);
    ylim([0 110]);xlim([-120 120])
    clim([-1 1]/1e5);
    title('Ice Shelf Pressure Torque')
    set(gca,'fontsize',fontsize)

   
% end

