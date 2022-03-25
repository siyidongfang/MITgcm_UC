%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% calcFeddy_fromNeutralDensity.m:
%%%% Calculate Eddy Form Stress from neutral density.
%%%% On C-grid mass point, model level middle.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   


    %%% Add path
    addpath /data/Software/eos80_legacy_gamma_n/;
    addpath /data/Software/eos80_legacy_gamma_n/library/;
    addpath /data/Software/gsw_matlab_v3_06_11;
    addpath /data/Software/gsw_matlab_v3_06_11/library/;
    addpath /data/Software/gsw_matlab_v3_06_11/thermodynamics_from_t/;

    %%% Grid spacing matrices    
    DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
    drc = rdmds([exppath,'/results/DRC']);

    ff = f0+beta*(yy);  % u/mass-grid
    
    yend = ystart + sloperange;
    ymin = round(ystart/delY(1));
    ymax = round(yend/delY(1));
    yidx = ymin:ymax;
    Lslope = yy(ymax)-yy(ymin);

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
    p = repmat(reshape(-zz,[1 1 Nr]),[Nx Ny 1])+PHIHYD*rho0/1e4;
    SA = gsw_SA_from_SP(SALT,p,-12,-64);  %%% Absolute Salinity from Practical Salinity
    CT = gsw_CT_from_pt(SA,THETA);        %%% Conservative Temperature from potential temperature
    Alpha = gsw_alpha(SA,CT,p);   % mass-grid
    Beta = gsw_beta(SA,CT,p);    % mass-grid  
    T_dagger = THETA - repmat(sum(THETA.*DX_xyz,1)/Lx,[Nx 1 1]);
    S_dagger = SALT - repmat(sum(SALT.*DX_xyz,1)/Lx,[Nx 1 1]);
    
    IFS_standing_Estimate = ff.*(Beta.*v_dagger_massgrid.*S_dagger ...
                         - Alpha.*v_dagger_massgrid.*T_dagger)./(Beta.*dS_dz_middle-Alpha.*dT_dz_middle);
    d_IFS_standing_Estimate_dz = -diff(IFS_standing_Estimate,1,3) ./ drc(:,:,2:end-1); 

    IFS_standing_Estimate_xavg = squeeze(sum(IFS_standing_Estimate.*DX_xyz,1)/Lx);
    IFS_standing_Estimate_slope = nansum(IFS_standing_Estimate_xavg(yidx,:).*delY(1))./Lslope;
    d_IFS_standing_Estimate_dz_xavg = squeeze(sum(d_IFS_standing_Estimate_dz.*repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr-1]),1)/Lx);
    d_IFS_standing_Estimate_dz_slope = nansum(d_IFS_standing_Estimate_dz_xavg(yidx,:).*delY(1))./Lslope;                   
                     
    
    
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

    IFS_transient_Estimate_xavg = squeeze(sum(IFS_transient_Estimate.*DX_xyz,1)/Lx);
    IFS_transient_Estimate_slope = nansum(IFS_transient_Estimate_xavg(yidx,:).*delY(1))./Lslope;
    d_IFS_transient_Estimate_dz_xavg = squeeze(sum(d_IFS_transient_Estimate_dz.*repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr-1]),1)/Lx);
    d_IFS_transient_Estimate_dz_slope = nansum(d_IFS_transient_Estimate_dz_xavg(yidx,:).*delY(1))./Lslope;                   
     
  
    
    
    save([prodir 'IFS/' expname '-IFS.mat'],...
        'IFS_standing_Estimate_xavg','IFS_transient_Estimate_xavg',...
        'IFS_standing_Estimate_slope','IFS_transient_Estimate_slope',...
        'd_IFS_standing_Estimate_dz_xavg','d_IFS_transient_Estimate_dz_xavg',...
        'd_IFS_standing_Estimate_dz_slope','d_IFS_transient_Estimate_dz_slope',...
        'yy','zz');
    





