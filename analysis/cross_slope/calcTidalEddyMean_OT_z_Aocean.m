clear;
addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps/;

expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng';
prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/';

expname =   'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod';
loadexp;

G = zeros(Ny,71);
nEND = 3650;
for nI=1:nEND
    load([prodir 'MOC_ssurf33_0dS/' expname '_psim_pt_' num2str(nI) 'days.mat'],'psim_pt')
    G = G + psim_pt/nEND;
end
clear psim_pt
%%%%% Interpolate tidal MOC from potential density space to z space.


load([prodir expname '_MOC_rho_Aocean.mat']);
% load([prodir '/' expname,'_tidalMOC_3650days.mat']);

psi_tide_pt = psi_pt-G;
psi_eddy_pt = G-psim_pt; 

ptlevs = flip(layers_bounds(:,1));
Npt = length(ptlevs)-1;

%%% Calculate time-averaged isopycnal flux, density and velocity 
load([prodir expname '_tavg_10yrs.mat'],'LaHs1RHO');
h_pt_tavg = flip(LaHs1RHO,3);   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% CALCULATE ISOPYCNAL DEPTHS %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    Aocean = zeros(Ny,Nr+1);
    Aisop = zeros(Ny,Npt+1);

    %%% Grid spacing matrices
    DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
    DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    DX_xypt = repmat(reshape(delX,[Nx 1 1]),[1 Ny Npt]);


    Aocean_xint = squeeze(sum(DX_xyz.*DZ_xyz.*hFacS,1)); %%% Integrate the ocean area in the x-direction, on v-grid
    Aocean(:,1:Nr) = cumsum(Aocean_xint,2,'reverse'); %%% Integrate the ocean area in the z-direction from bottom to top

    Aisop_xint = squeeze(nansum(DX_xypt.*h_pt_tavg,1));
    Aisop(:,2:Npt+1) = cumsum(Aisop_xint,2);
    zzf = -[0 cumsum(delR)];

    figure(30)
    YLIM = [37 37.25];
    subplot(1,2,1)
    pcolor(yy/1000,zzf,Aocean'/Lx);
    shading interp;colormap('default');colorbar;
    xlabel('y (km)');ylabel('z (m)');
    title('Aocean/Lx (m)')
    subplot(1,2,2)
    pcolor(yy/1000,ptlevs(1:Npt+1),Aisop'/Lx);
    shading interp;colormap('default');colorbar;
    xlabel('y (km)');ylabel('Potential density (kg/m^3)');
    title('Aisop/Lx (m)');
%     ylim([35.5 37.2]);
    ylim(YLIM);
    axis ij
    
    
    %%

    %%% The maximum of Aisop should be approximately the same as Aocean
    diff_Aocean_Aisop = (Aocean(:,1)-Aisop(:,end))/Lx; 
    psi_tide_z = zeros(Ny,Nr+1);
    psi_eddy_z = zeros(Ny,Nr+1);

    Zisop = zeros(Ny,Npt+1);
    
    for j = 1:Ny
        %%% No ocean here so can't interpolate
        if (Aocean(j,1)==0) 
            continue;
        end
        %%% Truncate Aisop and psi_pt vectors to remove repeated entries at the ends
        %%% of the Aisop vector
        [Aisop_trunc,idx] = unique(Aisop(j,:));
        psi_tide_pt_trunc = psi_tide_pt(j,idx);
        psi_eddy_pt_trunc = psi_eddy_pt(j,idx);
        %%% Interpolate vertically. Note that Aisop(k) is the total area over
        %%% density bins 1 through k, i.e. it corresponds to the density level
        %%% k+1/2.
        psi_tide_z(j,:) = interp1(Aisop_trunc,psi_tide_pt_trunc,Aocean(j,:),'linear','extrap');
        psi_eddy_z(j,:) = interp1(Aisop_trunc,psi_eddy_pt_trunc,Aocean(j,:),'linear','extrap');
        
        
        %%% Truncate Aocean and zzf vectors to remove repeated entries at the ends
        %%% of the Aocean vector
        [Aocean_trunc,idx_aocean] = unique(Aocean(j,:));
        zzf_trunc = zzf(idx_aocean);       
        Zisop(j,:) = interp1(Aocean_trunc,zzf_trunc,Aisop(j,:),'linear','extrap');
    end
    
    [DD,LL] = meshgrid(ptlevs,yy);

    figure(32)
    PSIlim=[-1.5 1.5];
    subplot(2,3,1)
    pcolor(yy/1000,ptlevs,psi_tide_pt');
    shading interp;colormap('redblue');colorbar;caxis(PSIlim);
    ylim(YLIM);
    xlabel('y (km)');ylabel('Potential density (kg/m^3)');
    title('\psi_{tide} (Sv) in PT space')
    subplot(2,3,2)
    pcolor(yy/1000,zzf,psi_tide_z');
    shading interp;colormap('redblue');colorbar;caxis(PSIlim);
    xlabel('y (km)');ylabel('z (m)');
    title('\psi_{tide} (Sv), interpolating the streamfunction')
    subplot(2,3,3)
    pcolor(yy/1000,zzf,psi_eddy_z');
    shading interp;colormap('redblue');colorbar;caxis(PSIlim);
    xlabel('y (km)');ylabel('z (m)');
    title('\psi_{eddy} (Sv), interpolating the streamfunction')
    subplot(2,3,4)
    pcolor(LL/1000,Zisop,psi_eddy_pt);
    shading interp;colormap('redblue');colorbar;caxis(PSIlim);
    hold on;
    contour(LL/1000,Zisop,DD,[37:0.05:37.25],'EdgeColor','w');
    hold off;
    xlabel('y (km)');ylabel('z (m)');
    title('\psi_{eddy} (Sv), interpolating Zisop (with isotherms)')
%     subplot(2,3,5)
%     pcolor(LL/1000,Zisop,psim_pt);
%     shading interp;colormap('redblue');colorbar;caxis(PSIlim);
%     xlabel('y (km)');ylabel('z (m)');
%     title('\psi_{mean} (Sv), interpolating Zisop')
    subplot(2,3,6)
    pcolor(LL/1000,Zisop,psie_pt);
    shading interp;colormap('redblue');colorbar;caxis(PSIlim);
    xlabel('y (km)');ylabel('z (m)');
    title('\psi_{eddy} (Sv), interpolating Zisop')
    
    
    save([prodir '/' expname,'_tidalMOCz_3650days.mat'],...
        'psi_eddy_pt','psi_eddy_z','psi_tide_pt','psi_tide_z',...
        'Zisop','DD','LL','ptlevs','zzf','yy')
