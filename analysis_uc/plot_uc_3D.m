



    clear;close all;
    addpath functions/;

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    
    prodir = ['/Users/csi/MITgcm_UC/products_uc/' exp_group '/'];
    figdir = ['/Users/csi/MITgcm_UC/figures_uc/vorticity/' exp_group '/'];
    useSEAICE = true;
    savefigure = false;


    n=1;
    expname = EXPNAME{n}
    loadexp;
    load_data;
    load_spacing;
    load_colors;


    %%% Find (x,y,z) indices for the undercurrent
    uu_slope = uu(xidx,yidx,zidx);
    mask_uc = zeros(length(xidx),length(yidx),length(zidx)); %%% mask of the undercurrent
    mask_uc(uu_slope>0)=1;

    x_uc = zeros(sum(mask_uc==1,'all'),1);
    y_uc = zeros(sum(mask_uc==1,'all'),1);
    z_uc = zeros(sum(mask_uc==1,'all'),1);
    u_uc = zeros(sum(mask_uc==1,'all'),1);

    n=0;
    for i = 1:length(xidx)
        for j = 1:length(yidx)
            for k = 1:length(zidx)
                if(mask_uc(i,j,k)~=0)
                    n=n+1;
                    x_uc(n)=xx(xidx(i));
                    y_uc(n)=yy(yidx(j));
                    z_uc(n)=zz(zidx(k));
                    u_uc(n)=uu(xidx(i),yidx(j),zidx(k));
                end
            end
        end
    end

    YLIM = [Ymin-5*m1km Ymax+3*m1km]/1000;
    ZLIM = [0 2500]/1000;
    [Y,X] = meshgrid(yy/1000,xx/1000);
    [YY,XX,ZZ]=meshgrid(yy/1000,xx/1000,zz/1000);


    figure(1)
    clf;
    fontsize = 15;
    set(gcf,'color','w');
    
    %%% Bathymetry  
    p = surface(X(:,2:end-1),Y(:,2:end-1),-bathy(:,2:end-1)/1000);
    bathycolor = hex2rgb('#bcb099');
    p.FaceColor = bathycolor;
    p.EdgeColor = 'none';

    hold on;
    scatter3(x_uc/1000,y_uc/1000,-z_uc/1000,20,u_uc)
    colormap(cmocean('balance'))
    caxis([-0.12 0.12])
    colorbar;

%     p = surface(X,Y,-z_uc_top/1000);
%     p.FaceColor = pink;
%     p.EdgeColor = 'none';
% 
%     p = surface(X,Y,-z_uc_bot/1000);
%     p.FaceColor = gray;
%     p.EdgeColor = 'none';

    %%% Decorations
    hold off;
%     view(-219,47);
    view(-223,16);
    xlabel('x (km)');
    ylabel('y (km)');
    zlabel('Depth (km)');
    set(gca,'FontSize',fontsize);
    set(gca,'ZTick',[0:1:4]);
    set(gca,'YTick',[0:10:400]);
    set(gca, 'ZDir','reverse')
    axis tight;
    pbaspect([Lx/Ly 1 1]);
    camlight('right');
    lightangle(10,-34); 
%     lighting flat;
    ylim(YLIM)
    zlim(ZLIM)


    
    
    

