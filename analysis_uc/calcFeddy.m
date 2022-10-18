%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% calcFeddy.m:
%%%% Calculate Eddy Form Stress from neutral density.
%%%% On C-grid mass point, model level middle.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   

    %%% Grid spacing matrices    
    DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
    DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
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
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate the IFS for zonal momentum balance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
    % p = repmat(reshape(-zz,[1 1 Nr]),[Nx Ny 1])+PHIHYD*rho0/1e4;
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
     
    IFS_transient_Estimate_slope(IFS_transient_Estimate_slope==0)=NaN;
    
    % calcFeddy_uw;
    % zonal_mean_transient = rho0*(IFS_transient_Estimate_xavg'-uw_transient_xavg');
    % zonal_mean_standing = rho0*(IFS_standing_Estimate_xavg'-uw_standing_xavg');


    xIFS_tran = rho0*IFS_transient_Estimate;
    xIFS_stan = rho0*IFS_standing_Estimate;
    %%% IFS on the upper bound of the CDW layer
    tt = THETA;
    for i=1:Nx
        for j=1:Ny
            idx = find(tt(i,j,:)>=0,1);
            if(idx>0)
                widx(i,j)=idx;
                xIFS_tran_cdw(i,j) = xIFS_tran(i,j,widx(i,j)); 
                xIFS_stan_cdw(i,j) = xIFS_stan(i,j,widx(i,j)); 
            end
        end
    end


    xIFS_tran_cdw(xIFS_tran_cdw==0)=NaN;
    xIFS_stan_cdw(xIFS_stan_cdw==0)=NaN;

    %%% Plotting options
    scrsz = get(0,'ScreenSize');
    fontsize = 17;
    framepos = [0 scrsz(4)/2 900 550];
    plotloc = [0.15 0.15 0.7 0.75];

    %%% Make the plot
    handle = figure(1);
    set(handle,'Position',framepos);
    clf;
    set(gcf,'color','w');
    pcolor(xx/1000,yy/1000,xIFS_tran_cdw');colorbar;shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','off');hold off;
    caxis([-0.1 0.1]/2);
    colormap(flip(cmocean('balance')))
    %     colormap(redblue);
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    set(gca,'FontSize',fontsize);
    title('Estimated transient-eddy IFS at the upper CDW bound (Pa, zonal)','FontSize',fontsize+3)
    set(gca,'Position',plotloc);
    ylim([0 400]);xlim([-300 300])
    xticks([-300:100:300]); yticks([0:100:400])

    handle = figure(2);
    set(handle,'Position',framepos);
    clf;
    set(gcf,'color','w');
    pcolor(xx/1000,yy/1000,xIFS_stan_cdw');colorbar;shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','off');hold off;
    caxis([-0.15 0.15]);
    colormap(flip(cmocean('balance')))
    %     colormap(redblue);
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    set(gca,'FontSize',fontsize);
    title('Estimated standing-eddy IFS at the upper CDW bound (Pa, zonal)','FontSize',fontsize+3)
    set(gca,'Position',plotloc);
    ylim([0 400]);xlim([-300 300])
    xticks([-300:100:300]); yticks([0:100:400])




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate the IFS for meridional momentum balance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Standing eddy form stress %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%% Calculate the numerator of the standing eddy form stress from the
    %%% neutral density.
    u_dagger = UVEL - repmat(sum(UVEL.*DY_xyz,2)/Ly,[1 Ny 1]);
    u_dagger_massgrid = (u_dagger+u_dagger([2:Nx 1],:,:))/2;
    
    
    %%% Estimate the numerator of the standing eddy form stress from
    %%% potential temperature and salinity.
    T_dagger = THETA - repmat(sum(THETA.*DY_xyz,2)/Ly,[1 Ny 1]);
    S_dagger = SALT - repmat(sum(SALT.*DY_xyz,2)/Ly,[1 Ny 1]);
    
    yIFS_standing_Estimate = - ff.*(Beta.*u_dagger_massgrid.*S_dagger ...
                         - Alpha.*u_dagger_massgrid.*T_dagger)./(Beta.*dS_dz_middle-Alpha.*dT_dz_middle);

       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Transient eddy form stress %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    uvel_massgrid = (UVEL+UVEL([2:Nx 1],:,:))/2;
    uvelslt_massgrid = (UVELSLT+UVELSLT([2:Nx 1],:,:))/2;
    uvelth_massgrid = (UVELTH+UVELTH([2:Nx 1],:,:))/2;

    ytransient = Beta.*(uvelslt_massgrid - uvel_massgrid.*SALT) ...
                - Alpha.*(uvelth_massgrid - uvel_massgrid.*THETA); % mass-grid
    yIFS_transient_Estimate = -ff.*ytransient./(Beta.*dS_dz_middle-Alpha.*dT_dz_middle);

    yIFS_tran = rho0*yIFS_transient_Estimate;
    yIFS_stan = rho0*yIFS_standing_Estimate;
    %%% IFS on the upper bound of the CDW layer
    for i=1:Nx
        for j=1:Ny
            idx = find(tt(i,j,:)>=0,1);
            if(idx>0)
                widx(i,j)=idx;
                yIFS_tran_cdw(i,j) = yIFS_tran(i,j,widx(i,j)); 
                yIFS_stan_cdw(i,j) = yIFS_stan(i,j,widx(i,j)); 
            end
        end
    end

    yIFS_tran_cdw(yIFS_tran_cdw==0)=NaN;
    yIFS_stan_cdw(yIFS_stan_cdw==0)=NaN;



    %%% Make the plot
    handle = figure(3);
    set(handle,'Position',framepos);
    clf;
    set(gcf,'color','w');
    pcolor(xx/1000,yy/1000,yIFS_tran_cdw');colorbar;shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','off');hold off;
    caxis([-0.1 0.1]/2);
    colormap(flip(cmocean('balance')))
    %     colormap(redblue);
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    set(gca,'FontSize',fontsize);
    title('Estimated transient-eddy IFS at the upper CDW bound (Pa, meridional)','FontSize',fontsize+3)
    set(gca,'Position',plotloc);
    ylim([0 400]);xlim([-300 300])
    xticks([-300:100:300]); yticks([0:100:400])

    handle = figure(4);
    set(handle,'Position',framepos);
    clf;
    set(gcf,'color','w');
    pcolor(xx/1000,yy/1000,yIFS_stan_cdw');colorbar;shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','off');hold off;
    caxis([-50 50]);
    colormap(flip(cmocean('balance')))
    %     colormap(redblue);
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    set(gca,'FontSize',fontsize);
    title('Estimated standing-eddy IFS at the upper CDW bound (Pa, meridional)','FontSize',fontsize+3)
    set(gca,'Position',plotloc);
    ylim([0 400]);xlim([-300 300])
    xticks([-300:100:300]); yticks([0:100:400])



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate the curl of the IFS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    DXG = rdmds(fullfile(resultspath,'DXG'));
    DYF = rdmds(fullfile(resultspath,'DYF'));
    RAZ = rdmds(fullfile(resultspath,'RAZ'));

    curl_IFS_tran_cdw = zeros(Nx,Ny);
    curl_IFS_stan_cdw = zeros(Nx,Ny);
    for i = 2:Nx
        for j = 2:Ny
            %%% Pressure torque
            curl_IFS_tran_cdw(i,j) = ( xIFS_tran_cdw(i,j-1)*DXG(i,j-1) + yIFS_tran_cdw(i,j)*DYF(i,j) ...
                                     - xIFS_tran_cdw(i,j)*DXG(i,j)     - yIFS_tran_cdw(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j); 
            curl_IFS_stan_cdw(i,j) = ( xIFS_stan_cdw(i,j-1)*DXG(i,j-1) + yIFS_stan_cdw(i,j)*DYF(i,j) ...
                                     - xIFS_stan_cdw(i,j)*DXG(i,j)     - yIFS_stan_cdw(i-1,j)*DYF(i-1,j) ) ./RAZ(i,j);
        end
    end



    %%% Make the plot
    handle = figure(5);
    set(handle,'Position',framepos);
    clf;
    set(gcf,'color','w');
    pcolor(xx/1000,yy/1000,curl_IFS_tran_cdw');colorbar;shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','off');hold off;
    caxis([-0.1 0.1]/100000);
    colormap(flip(cmocean('balance')))
    %     colormap(redblue);
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    set(gca,'FontSize',fontsize);
    title('Curl of the transient-eddy IFS at the upper CDW bound (Pa/m)','FontSize',fontsize+3)
    set(gca,'Position',plotloc);
    ylim([0 400]);xlim([-300 300])
    xticks([-300:100:300]); yticks([0:100:400])

    handle = figure(6);
    set(handle,'Position',framepos);
    clf;
    set(gcf,'color','w');
    pcolor(xx/1000,yy/1000,curl_IFS_stan_cdw');colorbar;shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','off');hold off;
    caxis([-0.1 0.1]/100);
    colormap(flip(cmocean('balance')))
    %     colormap(redblue);
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    set(gca,'FontSize',fontsize);
    title('Curl of the standing-eddy IFS at the upper CDW bound (Pa/m)','FontSize',fontsize+3)
    set(gca,'Position',plotloc);
    ylim([0 400]);xlim([-300 300])
    xticks([-300:100:300]); yticks([0:100:400])






% CLIM = [-0.015 0.015];
% 
% figure(3)
% clf;set(gcf,'color','w');
% subplot(1,2,1)
% pcolor(yy/1000,-zz/1000,zonal_mean_transient);
% shading flat;colorbar;colormap('redblue');
% hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
% axis ij;caxis(CLIM);
% ylabel('Depth (km)','interpreter','latex');xlabel('y (km)','interpreter','latex')
% set(gca,'XTick',[0:100:300 round(Ly/1000)]);
% set(gca,'YTick',[0:1:4]);ylim([0 4])
% set(gca,'FontSize',fontsize);
% title( {'Transient eddy vertical momentum flux (zonal mean)',...
%     '$\Big<\rho_0\big(f\frac{\beta\overline{v^{\prime}S^{\prime}}-\alpha\overline{v^{\prime}\theta^{\prime}}}{\beta\partial_z \overline{S} - \alpha\partial_z \overline{T}}-\overline{u^\prime w^\prime}\big)\Big>$'},...
%         'FontSize', fontsize+4,'interpreter','latex')
% subplot(1,2,2)
% pcolor(yy/1000,-zz/1000,zonal_mean_standing);
% shading flat;colorbar;colormap('redblue');
% hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
% axis ij;caxis(CLIM);
% ylabel('Depth (km)','interpreter','latex');xlabel('y (km)','interpreter','latex')
% set(gca,'XTick',[0:100:300 round(Ly/1000)]);
% set(gca,'YTick',[0:1:4]);ylim([0 4])
% set(gca,'FontSize',fontsize);
% title( {'Standing eddy vertical momentum flux (zonal mean)',...
%     '$\Big<\rho_0\big(f\frac{\beta v^\dagger S^\dagger - \alpha v^\dagger \theta^\dagger}{\beta\partial_z \overline{S} - \alpha\partial_z \overline{T}}- u^\dagger w^\dagger\big)\Big>$'},...
%         'FontSize', fontsize+4,'interpreter','latex')
% 
% Xmax_west = 300*m1km;
% Xmin_west = 150*m1km;
% xidx_west = round(Xmin_west/dx):round(Xmax_west/dx); 
% Xrange_west = Xmax_west-Xmin_west;
% IFS_transient_Estimate_west = squeeze(sum(IFS_transient_Estimate(xidx_west,:,:).*DX_xyz(xidx_west,:,:),1,'omitnan')/Xrange_west);
% uw_transient_west = squeeze(sum(uw_transient(xidx_west,:,:).*DX_xyz(xidx_west,:,:),1,'omitnan')/Xrange_west);
% west_mean_transient = rho0*(IFS_transient_Estimate_west'-uw_transient_west');
% 
% IFS_standing_Estimate_west = squeeze(sum(IFS_standing_Estimate(xidx_west,:,:).*DX_xyz(xidx_west,:,:),1,'omitnan')/Xrange_west);
% uw_standing_west = squeeze(sum(uw_standing(xidx_west,:,:).*DX_xyz(xidx_west,:,:),1,'omitnan')/Xrange_west);
% west_mean_standing = rho0*(IFS_standing_Estimate_west'-uw_standing_west');
% 
% figure(4)
% clf;set(gcf,'color','w');
% subplot(1,2,1)
% pcolor(yy/1000,-zz/1000,west_mean_transient);
% shading flat;colorbar;colormap('redblue');
% hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
% axis ij;caxis(CLIM);
% ylabel('Depth (km)','interpreter','latex');xlabel('y (km)','interpreter','latex')
% set(gca,'XTick',[0:100:300 round(Ly/1000)]);
% set(gca,'YTick',[0:1:4]);ylim([0 4])
% set(gca,'FontSize',fontsize);
% title( {'Transient eddy vertical momentum flux (150km $\leq$ x $\leq$ 300km)',...
%     '$\Big<\rho_0\big(f\frac{\beta\overline{v^{\prime}S^{\prime}}-\alpha\overline{v^{\prime}\theta^{\prime}}}{\beta\partial_z \overline{S} - \alpha\partial_z \overline{T}}-\overline{u^\prime w^\prime}\big)\Big>$'},...
%         'FontSize', fontsize+4,'interpreter','latex')
% 
% subplot(1,2,2)
% pcolor(yy/1000,-zz/1000,west_mean_standing);
% shading flat;colorbar;colormap('redblue');
% hold on;plot(yy/1000,-bathy(1,:)/1000,'k','LineWidth',2);plot(yy/1000,-bathy(round(Nx/2),:)/1000,'k--','LineWidth',2);hold off;
% axis ij;caxis(CLIM);
% ylabel('Depth (km)','interpreter','latex');xlabel('y (km)','interpreter','latex')
% set(gca,'XTick',[0:100:300 round(Ly/1000)]);
% set(gca,'YTick',[0:1:4]);ylim([0 4])
% set(gca,'FontSize',fontsize);
% title( {'Standing eddy vertical momentum flux (150km $\leq$ x $\leq$ 300km)',...
%     '$\Big<\rho_0\big(f\frac{\beta v^\dagger S^\dagger - \alpha v^\dagger \theta^\dagger}{\beta\partial_z \overline{S} - \alpha\partial_z \overline{T}}- u^\dagger w^\dagger\big)\Big>$'},...
%         'FontSize', fontsize+4,'interpreter','latex')



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








