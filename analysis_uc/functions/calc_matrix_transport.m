


    %%% Find bottom velocity
    uu_bottom = zeros(Nx,Ny);   % bottom velocity
    uu(uu==0) = NaN;            % make the topography (where tt==0) NaN values
    idx_topog = isnan(uu);      % The dry grids (topography): 1, wet grids: 0
    idxb = Nr-sum(idx_topog,3); % Find the vertical grid of bottom velocity
    for i = 1:Nx
        for j = 2:Ny-1
            if(idxb(i,j)~=0)
               uu_bottom(i,j) = uu(i,j,idxb(i,j));
            end
        end
    end
    uu_bottom(uu_bottom==0) = NaN;
    
    uu_slope = uu(xidx,yidx,:);
    vt_slope = vt(xidx,yidx,:);
    tt_slope = tt(xidx,yidx,:);
    ub_slope = uu_bottom(xidx,yidx);
    
    uu_east = uu_slope;
    uu_east(uu_slope<=0)=NaN;
    hFacW_east = hFacW(xidx,yidx,:);
    hFacW_east(uu_slope<=0)=NaN;
    ub_east = ub_slope;
    ub_east(ub_slope<=0)=NaN;
    
    uu_west = uu_slope;
    uu_west(uu_slope>=0)=NaN;
    hFacW_west = hFacW(xidx,yidx,:);
    hFacW_west(uu_slope>=0)=NaN;
    ub_west = ub_slope;
    ub_west(ub_slope>=0)=NaN;
  
    %%% Calculate velocities
    Ub_east_max(ne) = max(ub_east,[],'all','omitnan');
    Ub_east_avg(ne) = mean(ub_east,'all','omitnan');
    Ub_west_min(ne) = min(ub_west,[],'all','omitnan');
    Ub_west_avg(ne) = mean(ub_west,'all','omitnan');
    Ub_avg(ne) = mean(ub_slope,'all','omitnan');


    %%% Calculate transports
    Tot_east = sum(uu_east.*hFacW(xidx,yidx,:).*DX(xidx,yidx,:).*DY(xidx,yidx,:).*DZ(xidx,yidx,:),'all','omitnan');
    Vol_east = sum(hFacW_east.*DX(xidx,yidx,:).*DY(xidx,yidx,:).*DZ(xidx,yidx,:),'all','omitnan');
    U_east_avg(ne) = Tot_east/Vol_east;
    
    Tot_west = sum(uu_west.*hFacW(xidx,yidx,:).*DX(xidx,yidx,:).*DY(xidx,yidx,:).*DZ(xidx,yidx,:),'all','omitnan');
    Vol_west = sum(hFacW_west.*DX(xidx,yidx,:).*DY(xidx,yidx,:).*DZ(xidx,yidx,:),'all','omitnan');
    U_west_avg(ne) = Tot_west/Vol_west;
    
    Lx_xidx = xx(xidx(end))-xx(xidx(1))+dx;
    Tot_east_Sv(ne) = Tot_east/Lx_xidx/1e6;
    Tot_west_Sv(ne) = Tot_west/Lx_xidx/1e6;
    Tot_Sv(ne) = Tot_east_Sv(ne)+Tot_west_Sv(ne);

    Umin(ne) = min(uu_slope,[],'all','omitnan');
    Umax(ne) = max(uu_slope,[],'all','omitnan');

    uu_slope(uu_slope==0)=NaN;
    u_xmean = squeeze(mean(uu_slope,'omitnan'));
    u_xmean_max(ne) = max(u_xmean,[],'all','omitnan');

    %%% Calculate upper ocean velocity and transport

    zupper = 1:sum(zz>=-500);

    Tot_west_upper(ne) = sum(uu_west(:,:,zupper).*hFacW(xidx,yidx,zupper).*DX(xidx,yidx,zupper).*DY(xidx,yidx,zupper).*DZ(xidx,yidx,zupper),'all','omitnan');
    Vol_west_upper(ne) = sum(hFacW_west(:,:,zupper).*DX(xidx,yidx,zupper).*DY(xidx,yidx,zupper).*DZ(xidx,yidx,zupper),'all','omitnan');
    U_west_avg_upper(ne) = Tot_west_upper(ne)/Vol_west_upper(ne);



    %%% Calculate transport weighted velocity
    Tot_east_weighted = sum(uu_east.^2.*hFacW(xidx,yidx,:).*DX(xidx,yidx,:).*DY(xidx,yidx,:).*DZ(xidx,yidx,:),'all','omitnan');
    Tot_weight = sum(uu_east.^1.*hFacW(xidx,yidx,:).*DX(xidx,yidx,:).*DY(xidx,yidx,:).*DZ(xidx,yidx,:),'all','omitnan');
    Ueast_transportweighted(ne) = Tot_east_weighted/Tot_weight;


    %%% Calculate southward transport in the trough



