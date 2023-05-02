%%%
%%% Check the ice shelf-ocean boundary properties 
%%%
%%% Compute TB and SB using the three equations in Holland & Jenkins 1999


    clear;
    % close all;

    addpath /Users/csi/MITgcm_UC/analysis_uc/functions/;

    EXP_GROUP = {'seaice_boundary';'pseudo_shelfice_seaice'};
    exp_group = EXP_GROUP{1}
    list_exps_new;
    load_constants;
    load_colors;
    
    figdir = ['/Users/csi/MITgcm_UC/figures/BCvorticity_cdw_sw/' exp_group '/'];
    useSEAICE = true;
    showfigure = true;
    savefigure = false;

    ne=1;
    expname = EXPNAME{ne}
    loadexp;
    % load_data;
    load_spacing;

    load([prodir '/' expname '_tavg_5yrs.mat'],'THETA','SALT')
    % load([prodir '/' expname '_tavg_5yrs.mat'],'SHIfwFlx','SHIhtFlx','SHI_TauX','SHI_TauY','SHIForcT','SHIForcS');
    % plot_shelfIce


    %%% plot the temperature and salinity of shelf ice-ocean interface
    interidx = zeros(Nx,Ny);
    ss_int = zeros(Nx,Ny);
    tt_int = zeros(Nx,Ny);
    for i=1:Nx
        for j=1:Ny
            if(~isempty(find(SALT(i,j,:)>0,1)))
                interidx(i,j) = find(SALT(i,j,:)>0,1);
                ss_int(i,j) = SALT(i,j,interidx(i,j));
                tt_int(i,j) = THETA(i,j,interidx(i,j));
            end
        end
    end


    ss_int(ss_int==0)=NaN;
    tt_int(tt_int==0)=NaN;
    ss_int(YY>100*m1km)=NaN;
    tt_int(YY>100*m1km)=NaN;


    figure(14)
    subplot(1,2,1)
    pcolor(xx/1000,yy/1000,ss_int');shading flat;colorbar;
    xlim([-110 110]);ylim([0 110]);
    clim([32.8 34.65])


    subplot(1,2,2)
    pcolor(xx/1000,yy/1000,tt_int');shading flat;colorbar;
    xlim([-110 110]);ylim([0 110]);
    mean(tt_int,'all','omitnan')







