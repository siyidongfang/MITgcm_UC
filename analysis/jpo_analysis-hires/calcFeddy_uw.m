%%% Calculate u'w', u^\dagger w^\dagger, on C-grid mass point, model level
%%% middle
     

    yend = ystart + sloperange;
    ymin = round(ystart/delY(1));
    ymax = round(yend/delY(1));
    yidx = ymin:ymax;
    Lslope = yy(ymax)-yy(ymin);

    
    w_middle = zeros(Nx,Ny,Nr);
    wu_ugrid_middle = zeros(Nx,Ny,Nr);
    
    u_massgrid = UVEL+ UVEL([2:Nx 1],:,:);
    w_middle(:,:,1) = 0.5*(0+WVEL(:,:,1));
    w_middle(:,:,2:Nr) = 0.5*(WVEL(:,:,1:Nr-1)+WVEL(:,:,2:Nr)); 
    wu_ugrid_middle(:,:,1) = 0.5*(0+WU_VEL(:,:,1));
    wu_ugrid_middle(:,:,2:Nr) = 0.5*(WU_VEL(:,:,1:Nr-1)+WU_VEL(:,:,2:Nr));
    wu_massgrid_middle = 0.5*(wu_ugrid_middle + wu_ugrid_middle([Nx 1:Nx-1],:,:));

    
    
    %%%%% Transient eddy 
    uw_transient =  wu_massgrid_middle - u_massgrid.*w_middle;  % u-grid, middle-level

    uw_transient_xavg = squeeze(sum(uw_transient.*DX_xyz,1)/Lx);
    uw_transient_slope = nansum(uw_transient_xavg(yidx,:).*delY(1))./Lslope;


    %%%%% Standing eddy 
    u_dagger_massgrid = u_massgrid - repmat(sum(u_massgrid.*DX_xyz,1)/Lx,[Nx 1 1]);
    w_dagger_middle =  w_middle - repmat(sum(w_middle.*DX_xyz,1)/Lx,[Nx 1 1]);
    
    uw_standing =  u_dagger_massgrid.*w_dagger_middle;

    uw_standing_xavg = squeeze(sum(uw_standing.*DX_xyz,1)/Lx);
    uw_standing_slope = nansum(uw_standing_xavg(yidx,:).*delY(1))./Lslope;


    
    save([prodir 'IFS/' expname '-wu.mat'],...
        'uw_standing_xavg','uw_standing_slope','uw_transient_xavg','uw_transient_slope');