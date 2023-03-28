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

    figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots_JPO/fig7/';

    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{2};
    list_exps_new;
    load_constants;
    load_colors;
    ne =14; 
    expname = 'bathy_for_fig7';
    loadexp;
    load_spacing;

    load_colors;
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

    %%% bathymetry and icedraft
    Hicefront = 200; %%% Depth of ice shelf frace
    h=bathy;
    fid = fopen(fullfile(exppath,'input','SHELFICEtopoFile.bin'),'r','b');
    icedraft = fread(fid,[Nx Ny],'real*8');
   
    %%% Grid
    [Y,X] = meshgrid(yy/1000,xx/1000);
    [YY,XX,ZZ]=meshgrid(yy/1000,xx/1000,zz/1000);
    [ZZZ,YYY] = meshgrid(zz/1000,yy/1000);


    %%

    figure(1)
    clf;   
    set(gcf,'Color','w');
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.03*scrsz(3) 0.3*scrsz(4) 800 700]);

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
    % alpha(p,1);
    % p = surface(X(:,2:end-1),Y(:,2:end-1),-icetop_plot(:,2:end-1)/1000);
    % p.FaceColor = icetopcolor;
    % p.EdgeColor = 'none';
    % alpha(p,1);

  
    %%% Decorations
    hold off;
    view(-249.5098,15.6776);
    % view(-223,16);
    xlabel('');
    ylabel('');
    zlabel('');
    set(gca,'FontSize',fontsize);
    set(gca,'ZTick',[]);
    set(gca,'YTick',[]);
    set(gca,'XTick',[]);

    axis tight;
    pbaspect([Lx/Ly 3 1]);
    camlight('headlight');
    lightangle(270,270);
    lighting flat;
    set(gca,'zdir','reverse')

    zlim([0 2])
    xlim([-85 85])
    ylim([15 270])
    % box on;

    figdir = '/Users/csi/MITgcm_UC/analysis_uc/plots_JPO/fig7/';
    print('-dpng','-r300',[figdir 'fig7_base.png']);



