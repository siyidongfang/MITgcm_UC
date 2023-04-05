%%%
%%% fig1.m
%%%
%%% Plot the model configuration for the undercurrent project 
%%%
%%% TO DO: add salinity contours to panel (a)


    clear;close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/;
    addpath /Users/csi/Software/eos80_legacy_gamma_n/library/;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11;
    addpath /Users/csi/Software/gsw_matlab_v3_06_11/library/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/plots_JPO/cbarrow;

    figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots_JPO/fig1/';

    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    load_colors;
    ne =1; % Load the reference experiment
    expname = EXPNAME{ne}
    loadexp;
    load_data;
    load_spacing;


    fontsize = 19;
    ncolor=250; % Number of color contours
    m1km = 1000;

    % bathycolor = hex2rgb('#958872');
    bathycolor = hex2rgb('#bcb099');
    icedraftcolor = hex2rgb('#7ba1d2');
    icetopcolor = hex2rgb('#7ba1d2');
    boxcolor = [0.85 0.85 0.85];
    % isothermcolor = [87 151 246]/255;
    isothermcolor = hex2rgb('#6756BE');

    nIter = 1298541;
    uvel_inst = rdmdsWrapper(fullfile(exppath,'/results/U'),nIter);    

    %%% bathymetry and icedraft
    Hicefront = 200; %%% Depth of ice shelf frace
    h=bathy;
    fid = fopen(fullfile(exppath,'input','SHELFICEtopoFile.bin'),'r','b');
    icedraft = fread(fid,[Nx Ny],'real*8');
   
    %%% Grid
    [Y,X] = meshgrid(yy/1000,xx/1000);
    [YY,XX,ZZ]=meshgrid(yy/1000,xx/1000,zz/1000);
    [ZZZ,YYY] = meshgrid(zz/1000,yy/1000);

    %%% Extract zonal boundary values
    idx_1 = 1;
    BC_u = squeeze(uu(idx_1,:,:));
    BC_u(BC_u==0) = NaN;
    BC_t = squeeze(tt(idx_1,:,:));
    BC_s = squeeze(ss(idx_1,:,:));

    % calcFig1_bc;
    
    theta_inst = rdmdsWrapper(fullfile(exppath,'/results/T'),nIter); 
    for i=[1:98 Nx-103:Nx]
        for j=1:Ny
            for k=1:Nr
                if(hFacC(i,j,k)==0)
                    theta_inst(i,j,k)=NaN;
                end
            end
        end
    end

    for i=1:Nx
        for j=50:Ny
            for k=1:Nr
                if(hFacC(i,j,k)==0)
                    theta_inst(i,j,k)=NaN;
                end
            end
        end
    end
    % theta_inst(hFacC==0) = NaN;


    %%
    figure(1)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 1400 600]);


%%%%%%%%%%%%%%%%%%%
%%% panel (a) %%%%%
%%%%%%%%%%%%%%%%%%%
    %%% Plotting options
    ax1 = subplot('position',[0.03 0.055 0.49 0.95]);
    % annotation('textbox',[0.025 0.88 0.15 0.01],'String','(a)','FontSize',fontsize+2,'LineStyle','None');

    %%% Bathymetry  
    p = surface(X(:,2:end-1),Y(:,2:end-1),-h(:,2:end-1)/1000);
    p.FaceColor = [11*16+9 9*16+12 6*16+11]/255;
    p.FaceColor = bathycolor;
    p.EdgeColor = 'none';
    
    %%% Modified ice draft to look good in the plot
    icedraft_plot = icedraft;
    icedraft_plot(icedraft==0) = NaN;
    icetop_plot = 0*icedraft_plot;
    for i=1:Nx
    j = find(~isnan(icetop_plot(i,:)),1,'last');
    if (isempty(j))
    continue;
    else
    icetop_plot(i,j+1) = max(-Hicefront,h(i,j+1));
    end
    end
    
    % %%% Plot ice
    % hold on;
    % p = surface(X(:,2:end-1),Y(:,2:end-1),-icedraft_plot(:,2:end-1)/1000);
    % p.FaceColor = icedraftcolor;
    % p.EdgeColor = 'none';
    % alpha(p,0.3);
    % p = surface(X(:,2:end-1),Y(:,2:end-1),-icetop_plot(:,2:end-1)/1000);
    % p.FaceColor = icetopcolor;
    % p.EdgeColor = 'none';
    % alpha(p,0.3);


    theta_plot = 0;

    % % Plot the  temperature
    % ZZZ(:,end)=-4;
    % % p_bct = surface(ax1,xx(74)/1000*ones(size(YYY)),YYY,-ZZZ,BC_t);
    % p_bct = surface(ax1,xx(74)/1000*ones(size(YYY)),YYY,-ZZZ,squeeze(theta_inst(74,:,:)));
    % colormap(cmocean('balance'))
    % % colormap(cmocean('diff'))
    % clim([-2.3 2.3]);
    % p_bct.FaceColor = 'texturemap';
    % p_bct.EdgeColor = 'none';         
    % alpha(p_bct,1);
    % freezeColors;

   % colormap(ax1,cmocean('diff'))
   %  handle_tt = colorbar(ax1);
   %  set(handle_tt,'TickLabels', [ ],'Ticks', [ ]);
   %  set(handle_tt,'Position',[0.48    0.3    0.0045    0.15]);
   %  annotation('textbox',[0.33 0.425 0.15 0.01],'String',{'Restoring';'temperature';['(' char(176) 'C)']},'FontSize',fontsize-1,'LineStyle','None','horizontalAlignment','right');
   %  anno51 = annotation('textbox',[0.485 0.36 0.03 0.1],'String',{'\fontsize{15}2','\fontsize{3}','\fontsize{15}0','\fontsize{3}','\fontsize{15}-2'},'EdgeColor','none');     



    %%% Isopycnal
    clear XX YY ZZ
    [YY,XX,ZZ]=meshgrid(yy,xx,zz);
    XX = XX / 1000;
    YY = YY / 1000;
    ZZ = ZZ / 1000;


    fv = isosurface(XX(:,2:end-1,:),YY(:,2:end-1,:),-ZZ(:,2:end-1,:),theta_inst(:,2:end-1,:),theta_plot);
    p = patch(fv);
    % p.FaceColor = [87 151 246]/255;
    p.FaceColor =lightred;
    % p.FaceColor = [82 65 63]/255;
    % p.FaceColor = boxcolor;
    p.EdgeColor = 'none';
    alpha(p,0.5);
    hold off;

    %%% Decorations
    hold off;
    %     view(-219,47);
    % view(-223,16);
    view(-204.4052  , 30.3805)
    % view(129.6065,   11.9668)
    xlabel('x (km)');
    ylabel('y (km)');
    zlabel('Depth (km)');
    set(gca,'FontSize',fontsize);
    set(gca,'XTick',[-300:100:300],'fontsize',fontsize-1);
    set(gca, 'ZDir','reverse')
    set(gca,'TickLength',[0.1, 0.015])
    axis tight;
    pbaspect([Lx/Ly 1 1]);
    camlight('headlight');
    lightangle(140,-34);
    lighting flat;

    set(gca,'YLim',[0 220]);
    set(gca,'ZLim',[0 1.1]);
    set(gca,'ZTick',[0:1:2 2.8],'fontsize',fontsize-1);
    set(gca,'YTick',[0:100:200 250],'fontsize',fontsize-1);
    set(gca,'XLim',[-150 150]);

    view(129.6065,   11.9668)


    box on;


     % print('-dpng','-r200',[figdir 'IPT_BPT_aos270_5.png']);
    

set(gcf, 'color', 'none');    
set(gca, 'color', 'none');
exportgraphics(gcf,'transparent.eps',...   % since R2020a
    'ContentType','vector',...
    'BackgroundColor','none')
