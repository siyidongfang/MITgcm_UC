%%%
%%% plot_wdia_IFS.m
%%% 
%%% Plot the diapycnal velocity and isopycnal form stress at the upper bound of the CDW layer

    clear;close all;
    addpath functions/;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    
    prodir = ['/Users/csi/MITgcm_UC/products_uc/' exp_group '/'];
    figdir = ['/Users/csi/MITgcm_UC/figures_uc/ww/' exp_group '/'];
    useSEAICE = true;
    savefigure = false;

    n=1
    expname = EXPNAME{n}
    loadexp;
    load_data;
    load_spacing;
    load_colors;
    [YY,XX] = meshgrid(yy,xx);

    load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Vm_dPhiY');


    %%% Calculate potential density with a surface reference pressure 0
    lon_sec = -115;
    lat_sec = -71;
    SA = zeros(Nx,Ny,Nr);
    CT = zeros(Nx,Ny,Nr);
    pd = zeros(Nx,Ny,Nr);

    ss_nan = ss;
    tt_nan = tt;
    ss_nan(ss==0)=NaN;
    tt_nan(tt==0)=NaN;

    [ZZ_yz,YY_yz] = meshgrid(zz,yy);

    for i = 1:Nx
        [SA(i,:,:), in_ocean] = gsw_SA_from_SP(squeeze(ss_nan(i,:,:)),-ZZ_yz,lon_sec,lat_sec);
        CT(i,:,:) = gsw_CT_from_pt(squeeze(SA(i,:,:)),squeeze(tt_nan(i,:,:)));
        pd(i,:,:) = gsw_rho(squeeze(SA(i,:,:)),squeeze(CT(i,:,:)),0);
    end


    %%% Find the vertical index of the selected potential density layer 
    rho_selected = 1027.35;
    pd_selected = zeros(Nx,Ny);
    widx = zeros(Nx,Ny);
    UU = zeros(Nx,Ny);
    VV = zeros(Nx,Ny);
    umdphix = zeros(Nx,Ny);
    vmdphiy = zeros(Nx,Ny);

    for i=1:Nx
        for j=1:Ny
% idx = find(pd(i,j,:)>=rho_selected,1);
            idx = find(tt(i,j,:)>=0,1);
            if(idx>0)
                widx(i,j)=idx;
                pd_selected(i,j)=pd(i,j,idx);
                UU(i,j) = sum(uu(i,j,widx(i,j):Nr).*DZ(i,j,widx(i,j):Nr).*hFacW(i,j,widx(i,j):Nr),3); %%% u-grid
                VV(i,j) = sum(vv(i,j,widx(i,j):Nr).*DZ(i,j,widx(i,j):Nr).*hFacS(i,j,widx(i,j):Nr),3); %%% v-grid
                umdphix(i,j) = sum(Um_dPhiX(i,j,1:widx(i,j)).*DZ(i,j,1:widx(i,j)).*hFacW(i,j,1:widx(i,j)),3); 
                vmdphiy(i,j) = sum(Vm_dPhiY(i,j,1:widx(i,j)).*DZ(i,j,1:widx(i,j)).*hFacS(i,j,1:widx(i,j)),3); 
            end
        end
    end
    pd_selected(pd_selected==0)=NaN;

    figure(2)
    pcolor(pd_selected)
    shading flat
%     caxis([1027.26 1027.35])
    caxis([1027.32 1027.4])
    colorbar


    %%% Calculate diapycnal velocity wdia
    dUdx = diff(UU)/dx;
    dVdy = diff(VV,1,2)/dy;
    div=zeros(Nx,Ny);
    div(1:Nx-1,1:Ny-1) = dUdx(:,1:Ny-1) + dVdy(1:Nx-1,:);
    wdia = -div;
    wdia(wdia==0)=NaN;


   %%% Calculate IFS



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
    pcolor(xx/1000,yy/1000,wdia');colorbar;shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','off');hold off;
    caxis([-5 5]/1e5);
    colormap(flip(cmocean('balance')))
%     colormap(redblue);
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    set(gca,'FontSize',fontsize);
    title('Diapycnal velocity at the upper bound of the CDW layer (m/s)','FontSize',fontsize+3)
    set(gca,'Position',plotloc);
    ylim([0 400]);xlim([-300 300])
    xticks([-300:100:300]); yticks([0:100:400])

    if(savefigure)
    print('-dpng','-r150',[figdir expname '_wdia.png']);
    end

    %%% Make the plot
    handle = figure(2);
    set(handle,'Position',framepos);
    clf;
    set(gcf,'color','w');
    pcolor(xx/1000,yy/1000,umdphix');colorbar;shading flat;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1.5,'ShowText','off');hold off;
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','ShowText','off');hold off;
    caxis([-3 3]/1000);
    colormap(flip(cmocean('balance')))
%     colormap(redblue);
    xlabel('Longitude (km)');ylabel('Latitude (km)');
    set(gca,'FontSize',fontsize);
    title('IFS at the upper bound of the CDW layer','FontSize',fontsize+3)
    set(gca,'Position',plotloc);
    ylim([0 400]);xlim([-300 300])
    xticks([-300:100:300]); yticks([0:100:400])

    if(savefigure)
    print('-dpng','-r150',[figdir expname '_IFS.png']);
    end




