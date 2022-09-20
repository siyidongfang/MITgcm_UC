%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% calcFeddy.m:
%%%% Calculate Eddy Form Stress from neutral density.
%%%% On C-grid mass point, model level middle.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   

    %%% Grid spacing matrices    
    DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
    drc = rdmds([exppath,'/results/DRC']);
    ff = f0+beta*(yy);  % u/mass-grid
   
    Lslope = Ymax-Ymin;
    Xrange = Xmax-Xmin;

    %%% Calculate the denominator
    dS_dz = -diff(SALT,1,3) ./ drc(:,:,2:end-1); 
    dT_dz = -diff(THETA,1,3) ./ drc(:,:,2:end-1); 
    zz_dS_dz = 0.5*( zz(1:end-1)+zz(2:end) );
    
    %%% Linear intepolation
    dS_dz_middle = zeros(Nx,Ny,Nr);
    dS_dz_middle(:,:,2:end-1)=0.5*(dS_dz(:,:,1:end-1)+dS_dz(:,:,2:end));
    dS_dz_middle(:,:,1) = dS_dz_middle(:,:,2);
    dS_dz_middle(:,:,end) = dS_dz_middle(:,:,end-1);
    
    dT_dz_middle = zeros(Nx,Ny,Nr);
    dT_dz_middle(:,:,2:end-1)=0.5*(dT_dz(:,:,1:end-1)+dT_dz(:,:,2:end));
    dT_dz_middle(:,:,1) = dT_dz_middle(:,:,2);
    dT_dz_middle(:,:,end) = dT_dz_middle(:,:,end-1);
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Standing eddy form stress %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% Calculate the numerator of the standing eddy form stress from the
    %%% neutral density.
    v_dagger = VVEL - repmat(sum(VVEL.*DX_xyz,1)/Lx,[Nx 1 1]);
    v_dagger_massgrid = zeros(size(VVEL));
    v_dagger_massgrid(:,1:Ny-1,:) = 0.5*(v_dagger(:,1:Ny-1,:)+v_dagger(:,2:Ny,:));
    
    %%% Estimate the numerator of the standing eddy form stress from
    %%% potential temperature and salinity.
%     p = repmat(reshape(-zz,[1 1 Nr]),[Nx Ny 1])+PHIHYD*rho0/1e4;
    p = repmat(reshape(-zz,[1 1 Nr]),[Nx Ny 1]);

    SA = gsw_SA_from_SP(SALT,p,-12,-64);  %%% Absolute Salinity from Practical Salinity
    CT = gsw_CT_from_pt(SA,THETA);        %%% Conservative Temperature from potential temperature
    Alpha = gsw_alpha(SA,CT,p);   % mass-grid
    Beta = gsw_beta(SA,CT,p);    % mass-grid  
    T_dagger = THETA - repmat(sum(THETA.*DX_xyz,1)/Lx,[Nx 1 1]);
    S_dagger = SALT - repmat(sum(SALT.*DX_xyz,1)/Lx,[Nx 1 1]);
    
    IFS_standing_Estimate = ff.*(Beta.*v_dagger_massgrid.*S_dagger ...
                         - Alpha.*v_dagger_massgrid.*T_dagger)./(Beta.*dS_dz_middle-Alpha.*dT_dz_middle);
    d_IFS_standing_Estimate_dz = -diff(IFS_standing_Estimate,1,3) ./ drc(:,:,2:end-1); 

%     IFS_standing_Estimate(IFS_standing_Estimate==Inf)=NaN;
%     IFS_standing_Estimate(IFS_standing_Estimate==-Inf)=NaN;
    IFS_standing_Estimate_xavg = squeeze(sum(IFS_standing_Estimate(xidx,:,:).*DX_xyz(xidx,:,:),1,'omitnan')/Xrange);
    IFS_standing_Estimate_slope = sum(IFS_standing_Estimate_xavg(yidx,:).*delY(1),'omitnan')./Lslope;
    d_IFS_standing_Estimate_dz_xavg = squeeze(sum(d_IFS_standing_Estimate_dz.*repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr-1]),1,'omitnan')/Lx);
    d_IFS_standing_Estimate_dz_slope = sum(d_IFS_standing_Estimate_dz_xavg(yidx,:).*delY(1),'omitnan')./Lslope;                   
                     
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Transient eddy form stress %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    vvel_massgrid = zeros(size(VVEL));
    vvelslt_massgrid = zeros(size(VVELSLT));
    vvelth_massgrid = zeros(size(VVELTH));
    vvel_massgrid(:,1:Ny-1,:) = 0.5*(VVEL(:,1:Ny-1,:)+VVEL(:,2:Ny,:));
    vvelslt_massgrid(:,1:Ny-1,:) = 0.5*(VVELSLT(:,1:Ny-1,:)+VVELSLT(:,2:Ny,:));
    vvelth_massgrid(:,1:Ny-1,:) = 0.5*(VVELTH(:,1:Ny-1,:)+VVELTH(:,2:Ny,:)); 

    transient = Beta.*(vvelslt_massgrid - vvel_massgrid.*SALT) ...
                - Alpha.*(vvelth_massgrid - vvel_massgrid.*THETA); % mass-grid
    IFS_transient_Estimate = ff.*transient./(Beta.*dS_dz_middle-Alpha.*dT_dz_middle);
    d_IFS_transient_Estimate_dz = -diff(IFS_transient_Estimate,1,3) ./ drc(:,:,2:end-1); 

    IFS_transient_Estimate_xavg = squeeze(sum(IFS_transient_Estimate(xidx,:,:).*DX_xyz(xidx,:,:),1,'omitnan')/Xrange);
    IFS_transient_Estimate_slope = sum(IFS_transient_Estimate_xavg(yidx,:).*delY(1),'omitnan')./Lslope;
    d_IFS_transient_Estimate_dz_xavg = squeeze(sum(d_IFS_transient_Estimate_dz.*repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr-1]),1,'omitnan')/Lx);
    d_IFS_transient_Estimate_dz_slope = sum(d_IFS_transient_Estimate_dz_xavg(yidx,:).*delY(1),'omitnan')./Lslope;                   
     

   
%     save([prodir 'IFS/' expname '-IFS.mat'],...
%         'IFS_standing_Estimate_xavg','IFS_transient_Estimate_xavg',...
%         'IFS_standing_Estimate_slope','IFS_transient_Estimate_slope',...
%         'd_IFS_standing_Estimate_dz_xavg','d_IFS_transient_Estimate_dz_xavg',...
%         'd_IFS_standing_Estimate_dz_slope','d_IFS_transient_Estimate_dz_slope',...
%         'yy','zz');
    
IFS_transient_Estimate_slope(IFS_transient_Estimate_slope==0)=NaN;


calcFeddy_uw;




zonal_mean_transient = rho0*(IFS_transient_Estimate_xavg'-uw_transient_xavg');
zonal_mean_standing = rho0*(IFS_standing_Estimate_xavg'-uw_standing_xavg');

CLIM = [-0.015 0.015];

figure(3)
clf;set(gcf,'color','w');
subplot(1,2,1)
pcolor(yy/1000,-zz/1000,zonal_mean_transient);
shading flat;colorbar;colormap('redblue');
hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
axis ij;caxis(CLIM);
ylabel('Depth (km)','interpreter','latex');xlabel('y (km)','interpreter','latex')
set(gca,'XTick',[0:100:300 round(Ly/1000)]);
set(gca,'YTick',[0:1:4]);ylim([0 4])
set(gca,'FontSize',fontsize);
title( {'Transient eddy vertical momentum flux (zonal mean)',...
    '$\Big<\rho_0\big(f\frac{\beta\overline{v^{\prime}S^{\prime}}-\alpha\overline{v^{\prime}\theta^{\prime}}}{\beta\partial_z \overline{S} - \alpha\partial_z \overline{T}}-\overline{u^\prime w^\prime}\big)\Big>$'},...
        'FontSize', fontsize+4,'interpreter','latex')
subplot(1,2,2)
pcolor(yy/1000,-zz/1000,zonal_mean_standing);
shading flat;colorbar;colormap('redblue');
hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
axis ij;caxis(CLIM);
ylabel('Depth (km)','interpreter','latex');xlabel('y (km)','interpreter','latex')
set(gca,'XTick',[0:100:300 round(Ly/1000)]);
set(gca,'YTick',[0:1:4]);ylim([0 4])
set(gca,'FontSize',fontsize);
title( {'Standing eddy vertical momentum flux (zonal mean)',...
    '$\Big<\rho_0\big(f\frac{\beta v^\dagger S^\dagger - \alpha v^\dagger \theta^\dagger}{\beta\partial_z \overline{S} - \alpha\partial_z \overline{T}}- u^\dagger w^\dagger\big)\Big>$'},...
        'FontSize', fontsize+4,'interpreter','latex')

Xmax_west = 300*m1km;
Xmin_west = 150*m1km;
xidx_west = round(Xmin_west/dx):round(Xmax_west/dx); 
Xrange_west = Xmax_west-Xmin_west;
IFS_transient_Estimate_west = squeeze(sum(IFS_transient_Estimate(xidx_west,:,:).*DX_xyz(xidx_west,:,:),1,'omitnan')/Xrange_west);
uw_transient_west = squeeze(sum(uw_transient(xidx_west,:,:).*DX_xyz(xidx_west,:,:),1,'omitnan')/Xrange_west);
west_mean_transient = rho0*(IFS_transient_Estimate_west'-uw_transient_west');

IFS_standing_Estimate_west = squeeze(sum(IFS_standing_Estimate(xidx_west,:,:).*DX_xyz(xidx_west,:,:),1,'omitnan')/Xrange_west);
uw_standing_west = squeeze(sum(uw_standing(xidx_west,:,:).*DX_xyz(xidx_west,:,:),1,'omitnan')/Xrange_west);
west_mean_standing = rho0*(IFS_standing_Estimate_west'-uw_standing_west');

figure(4)
clf;set(gcf,'color','w');
subplot(1,2,1)
pcolor(yy/1000,-zz/1000,west_mean_transient);
shading flat;colorbar;colormap('redblue');
hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
axis ij;caxis(CLIM);
ylabel('Depth (km)','interpreter','latex');xlabel('y (km)','interpreter','latex')
set(gca,'XTick',[0:100:300 round(Ly/1000)]);
set(gca,'YTick',[0:1:4]);ylim([0 4])
set(gca,'FontSize',fontsize);
title( {'Transient eddy vertical momentum flux (150km $\leq$ x $\leq$ 300km)',...
    '$\Big<\rho_0\big(f\frac{\beta\overline{v^{\prime}S^{\prime}}-\alpha\overline{v^{\prime}\theta^{\prime}}}{\beta\partial_z \overline{S} - \alpha\partial_z \overline{T}}-\overline{u^\prime w^\prime}\big)\Big>$'},...
        'FontSize', fontsize+4,'interpreter','latex')

subplot(1,2,2)
pcolor(yy/1000,-zz/1000,west_mean_standing);
shading flat;colorbar;colormap('redblue');
hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
axis ij;caxis(CLIM);
ylabel('Depth (km)','interpreter','latex');xlabel('y (km)','interpreter','latex')
set(gca,'XTick',[0:100:300 round(Ly/1000)]);
set(gca,'YTick',[0:1:4]);ylim([0 4])
set(gca,'FontSize',fontsize);
title( {'Standing eddy vertical momentum flux (150km $\leq$ x $\leq$ 300km)',...
    '$\Big<\rho_0\big(f\frac{\beta v^\dagger S^\dagger - \alpha v^\dagger \theta^\dagger}{\beta\partial_z \overline{S} - \alpha\partial_z \overline{T}}- u^\dagger w^\dagger\big)\Big>$'},...
        'FontSize', fontsize+4,'interpreter','latex')



% figure(1)
% clf;set(gcf,'color','w');
% plot(IFS_transient_Estimate_slope,-zz,'color','k','LineWidth',2);
% axis ij;
% ylim([100 2000]); 
% 
% figure(2)
% clf;set(gcf,'color','w');
% plot(IFS_standing_Estimate_slope,-zz,'color','k','LineWidth',2);
% axis ij;
% ylim([100 2000]); 
