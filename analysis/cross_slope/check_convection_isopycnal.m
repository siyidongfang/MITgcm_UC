    %%
    %%% plot_model.m
    %%%
    %%% Plot a schematic of the model setup, plus reminders of the model state
    %%% In Nature Geoscience format
    %%%
    
    clear;close all;

    %%% Plotting options
    fontsize = 14;

    %%% Select simulation
    addpath /Users/csi/Software/gsw_matlab_v3_06_11;
    addpath /Users/csi/MITgcm_ASF-csi/analysis;
    addpath /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis-hires;
    addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps;
    addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps/customcolormap;
%     addpath /Volumes/si/MITgcm_ASF-csi/products_cross_slope
%     addpath /Volumes/si/MITgcm_ASF-csi/products-hires

    expdir='/Volumes/si/MITgcm_ASF-csi/exps_ng/';
%     expdir='/Users/csi/MITgcm_ASF-csi/exps_fix_northern_bdry/';
%     expdir='/Volumes/si/MITgcm_ASF-csi/exps_cross_slope';
%     expname = 'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_0dS_iceN_init'
    expname='ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25';
%     expname='hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod';
%     expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_0dS_prod_60s';
    loadexp;

    %%% Vertical grid spacing matrix
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]); 
    %%% Diagnostic indix corresponding to instantaneous velocity
    diagnum = length(diag_frequency);
    %%% This needs to be set to ensure we are using the correct output frequency
    diagfreq = diag_frequency(diagnum);
    %%% Frequency of diagnostic output
    dumpFreq = abs(diagfreq);
    nDumps = round(nTimeSteps*deltaT/dumpFreq);
    dumpIters = round((1:nDumps)*dumpFreq/deltaT);
    dumpIters = dumpIters(dumpIters >= nIter0);
    nDumps = length(dumpIters);
    nIters = 2200187;

    %%% Read snapshot
    theta_inst = rdmdsWrapper(fullfile(exppath,'/results/T'),nIters);    
    salt_inst = rdmdsWrapper(fullfile(exppath,'/results/S'),nIters);    
    uvel_inst = rdmdsWrapper(fullfile(exppath,'/results/U'),nIters);         
    vvel_inst = rdmdsWrapper(fullfile(exppath,'/results/V'),nIters);
    siheff_inst = rdmdsWrapper(fullfile(exppath,'/results/HEFF'),nIters);
    %%% Remove topography
    theta_inst(hFacC==0) = NaN;
    eta(hFacC(:,:,1)==0) = NaN;

    
%     ref_pres_surf=0;
%     pp = - zz;
%     for yidx = 180:180
%         Tnorth_exp = squeeze(theta_inst(:,yidx,:));
%         Snorth_exp = squeeze(salt_inst(:,yidx,:));
% 
% 
%         %%% Check Brunt-Vaisala frequency using full EOS
%         SA_north_exp = gsw_SA_from_SP(Snorth_exp,ref_pres_surf,-12,-64);  
%         CT_north_exp = gsw_CT_from_pt(SA_north_exp,Tnorth_exp); 
% 
%         for ii = 1:Nx
%            [N2_north_exp(ii,:), pp_mid_north] = gsw_Nsquared(SA_north_exp(ii,:),CT_north_exp(ii,:),pp,-64);
%         end
% 
% %         pcolor(N2_north_exp);colorbar;
% %         find(N2_north_exp<0)
%     end

 

%%
 
    %%% Initialize figure
    figure(12);
    clf;
    scrsz = get(0,'ScreenSize');
    set(gcf,'Position',[0.01*scrsz(3) 0.3*scrsz(4) 1200 460]);
    set(gcf,'Color','w');
    boxcolor = [0.85 0.85 0.85];

    %%% Select potential temperature surface
    theta_plot=0;

    
    
    
    %%% Bottom topography
    hb = -bathy(1,:);

    g_mean = squeeze(nanmean(theta_inst(:,:,:)));
    BATHY = g_mean;
    idx_bathy = isnan(g_mean);
    % g_mean(idx_bathy) = NaN;



    %% 

    
    
    
    [YY,XX,ZZ]=meshgrid(yy,xx,zz);
    XX = XX / 1000;
    YY = YY / 1000;
    ZZ = ZZ / 1000;


    clf;
    %%% Plotting options
    ax1 = subplot('position',[0.06 0.01 0.35 0.95]);
    ann1 = annotation('textbox',[0.01 0.88 0.05 0.05],'String','a','FontSize',fontsize,'LineStyle','None','fontweight', 'bold');

    %%% Bathymetry
    [Y,X] = meshgrid(yy,xx);  
    p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,bathy(:,2:end-1)/1000);
    p.FaceColor = [164 176 183]/255;
    p.EdgeColor = 'none';       
    hold on;
    zidx = 1;

    %%% Plot SSS
    p = surface(X(:,2:end-1)/1000,Y(:,2:end-1)/1000,0*X(:,2:end-1),salt_inst(:,2:end-1,zidx));
    caxis([min(min(salt_inst(:,2:end-1,zidx)))-0.2 max(max(salt_inst(:,2:end-1,zidx)))+0.2]);
    caxis([32.7 33.5]);
%     caxis([33.65 34.15]);
    colormap(pmkmp(28,'LinearL'));
    set(p,'FaceColor','texturemap','EdgeColor','none')
    alpha(p,0.8);
    freezeColors;


    %%% Plot ocean surface current
    u_surf = squeeze(uvel_inst(:,:,zidx));
    v_surf = squeeze(vvel_inst(:,:,zidx));
    svx = 25;  % Step
    svy = 20;
    curr = quiver(xx(1:svx:end)'/1000,yy(1:svy:end)'/1000, ...
        u_surf(1:svx:end,1:svy:end)',v_surf(1:svx:end,1:svy:end)');
    curr.Color = 'k';
    curr.LineWidth = 0.4;

    %%% Isopycnal
    fv = isosurface(XX(:,2:end-1,:),YY(:,2:end-1,:),ZZ(:,2:end-1,:),theta_inst(:,2:end-1,:),theta_plot);
    p = patch(fv);
    p.FaceColor = [87 151 246]/255;
    p.EdgeColor = 'none';
    alpha(p,0.5);
    hold off;

    %%% Decorations
    view(50,38);
    axis tight;
    xlabel('x (km)');
    ylabel('y (km)');
    zlabel('z (km)');
    set(gca,'XLim',[-200 200]);
    set(gca,'XTick',[-200:100:200]);
    set(gca,'YLim',[0 450]);
    set(gca,'YTick',[0:100:450]);
    set(gca,'ZLim',[-4 0]);
    set(gca,'ZTick',[-4:2:0]);
    set(gca,'FontSize',fontsize);
    set(gca,'TickDir','out','TickLength',[0.01 0.02]);
    pbaspect([Lx/Ly 1 0.75]);
    handle = colorbar;
    set(handle,'Position',[0.03    0.65    0.01    0.2117]);
    annotation('textbox',[0.038 0.88 0.15 0.01],'String',{'Surface';'salinity';'(psu)'},'FontSize',fontsize,'LineStyle','None');
%     annotation('textbox',[0.26 0.55 0.15 0.01],'String',{'$0^\circ$ C isotherms'},'FontSize',fontsize,'LineStyle','None','interpreter','latex');
    annotation('textbox',[0.25 0.54 0.15 0.01],'String',['0' char(176) 'C isotherms'],'FontSize',fontsize,'LineStyle','None');
    camlight('headlight');
    lightangle(50,38);
    lighting gouraud;
    view(ax1,[115.3500 13.8761])

%     ylim([0 420])
    set(gca, 'FontName', 'Helvetica')
