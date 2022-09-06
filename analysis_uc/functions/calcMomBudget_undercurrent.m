    %%%
    %%% calcMomBudget_undercurrent.m
    %%%
    %%% Convenience script to calculate the momentum budget from momentum tendency diagnostics.
    %%%
    
    %%%% Calculate the isopycnal form stress!!!
    
    rho0 = rhoConst;
    load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext','UVEL');
    

    %%% Find (x,y,z) indices for the undercurrent
    uu_slope = uu(xidx,yidx,zidx);
    mask_uc = zeros(length(xidx),length(yidx),length(zidx)); %%% mask of the undercurrent
    mask_uc(uu_slope>0)=1;

   
    Um_dPhiX(Um_dPhiX==0)=NaN;
    Um_Advec(Um_Advec==0)=NaN;
    Um_Diss(Um_Diss==0)=NaN;
    Um_Ext(Um_Ext==0)=NaN;
    
    
    %%% U momentum tendency from Hydrostatic Pressure gradient
    Um_dPhiX_xint = squeeze(rho0.*sum(mask_uc.*Um_dPhiX(xidx,yidx,zidx).*DX(xidx,yidx,zidx),1,'omitnan'));
    Um_dPhiX_xzint = rho0.*sum(sum(mask_uc.*Um_dPhiX(xidx,yidx,zidx).*hFacW(xidx,yidx,zidx).*DZ(xidx,yidx,zidx).*DX(xidx,yidx,zidx),3,'omitnan'),1,'omitnan');
    
    %%% U momentum tendency from Advection terms
    Um_Advec_xint = squeeze(rho0.*sum(mask_uc.*Um_Advec(xidx,yidx,zidx).*DX(xidx,yidx,zidx),1,'omitnan'));
    Um_Advec_xzint = rho0.*sum(sum(mask_uc.*Um_Advec(xidx,yidx,zidx).*hFacW(xidx,yidx,zidx).*DZ(xidx,yidx,zidx).*DX(xidx,yidx,zidx),3,'omitnan'),1,'omitnan');
    
    %%% U momentum tendency from Dissipation
    Um_Diss_xzint = rho0.*sum(sum(mask_uc.*Um_Diss(xidx,yidx,zidx).*hFacW(xidx,yidx,zidx).*DZ(xidx,yidx,zidx).*DX(xidx,yidx,zidx),3,'omitnan'),1,'omitnan');
    
    %%% U momentum tendency from external forcing
    Um_Ext_xzint = rho0.*sum(sum(mask_uc.*Um_Ext(xidx,yidx,zidx).*hFacW(xidx,yidx,zidx).*DZ(xidx,yidx,zidx).*DX(xidx,yidx,zidx),3,'omitnan'),1,'omitnan');
    
    
    totalchange_tendency = Um_dPhiX_xzint+Um_Advec_xzint+Um_Diss_xzint+Um_Ext_xzint;



    
    
    if(useSEAICE)
        %%% Calculate wind stress from EXF wind speeds
        rho_a = 1.3;               %%% Air density, kg/m^3
        load ([exppath '/setParams'],'Ua','Va')
        Ua(Ua==0)=1e-8;
        uwind = [Ua:-Ua/(Ny-1):0].*ones(Nx,1); 
        vwind = [Va:-Va/(Ny-1):0].*ones(Nx,1);
        zonalWind = rho_a.*SEAICE_drag.*sqrt(uwind.^2+vwind.^2).*uwind; 
        meridWindFile = rho_a.*SEAICE_drag.*sqrt(uwind.^2+vwind.^2).*vwind;
    else 
        %%% Load surface wind stress 
        fid = fopen(fullfile(exppath,'input','zonalWindFile.bin'),'r','b');
        zonalWind = fread(fid,[Nx Ny],'real*8');
        fclose(fid);
        fid = fopen(fullfile(exppath,'input','meridWindFile.bin'),'r','b');
        meridWind = fread(fid,[Nx Ny],'real*8');
        fclose(fid);
    end
    
        windStress_xint = sum(zonalWind(xidx,yidx).*DX_xy(xidx,yidx),1);
    
        length_int = sum(DX_xy(xidx,1),1);
    
        