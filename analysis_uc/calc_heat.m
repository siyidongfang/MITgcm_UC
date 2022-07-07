%%%
%%% calc_heat.m
%%%
%%% Calculate shoreward heat transport
    
    
    clear;
    close all;
    
    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;    
%     prodir = '/Users/csi/MITgcm_UC/products_uc/';
    expdir = '/Users/csi/MITgcm_UC/exps_aofd/seaice_boundary/';
    expname = 'res2km_Ua-8Va8_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_prod'
    prodir = [expdir expname '/'];

    
    %%% Load the list of the experiments
    list_exps;
    
    %%% Constants
    rho_o = 999.8;
    cp_o = 3994; % Unit: J/kg/degC
    m1km = 1000;

    Xwest = 200*m1km; %%% Longitude of western trough wall
    Xeast = 400*m1km; %%% Longitude of eastern trough wall
    YcavityS = 20*m1km;     %%% Southern edge of the ice shelf cavity (i.e., inner edge of the southern sponge layer)
    Yicefront = 100*m1km;   %%% Latitude of ice shelf face
    Yshelfbreak = 220*m1km; %%% Latitude of shelf break
    YslopeN = 310*m1km;     %%% Northern edge of the slope

    %%% Define variables
    Fheat_adv = size(nEXP,225);
    Fheat_vvelth = size(nEXP,225); 
    Fmean_vgrid_xzint = size(nEXP,225); 
    Fmean_massgrid_xzint = size(nEXP,225); 
    Feddy_adv_xzint = size(nEXP,225); 
    Feddy_vvelth_xzint = size(nEXP,225); 


    %%% Calculate heat transport
    for nn = 1:nEXP
        clear  ADVy_TH TFLUX TOTTTEND VVELTH VVEL THETA
        expdir = EXPDIR{nn};
        expname = EXPNAME{nn}
        nIter = NITER(nn);
        loadexp;

        dy = delY(1);    
        dx = delX(1);
        xidx = round(Xwest/dx)+1:round(Xeast/dx)-1;
        yidx_cavity = round(YcavityS/dy)+1:round(Yicefront/dy);
        yidx_shelf  = round(Yicefront/dy)+1:round(Yshelfbreak/dy); 
        yidx_slope  = round(Yshelfbreak/dy)+1:round(YslopeN/dy);

        DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
        DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
        DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

        THETA    = rdmds([exppath,'/results/THETA'],nIter);
        VVEL     = rdmds([exppath,'/results/VVEL'],nIter);
        ADVy_TH  = rdmds([exppath,'/results/ADVy_TH'],nIter);
        TOTTTEND = rdmds([exppath,'/results/TOTTTEND'],nIter);
        VVELTH   = rdmds([exppath,'/results/VVELTH'],nIter);
        TFLUX    = rdmds([exppath,'/results/TFLUX'],nIter);
        %         load([prodir expname '_tavg_10yrs.mat'],'TFLUX','ADVy_TH','TOTTTEND','VVELTH','VVEL','THETA');


        %%% Total advective heat 
        ADVy_int = cp_o*rho_o*sum(sum(ADVy_TH(xidx,:,:),3))/1e12; % Unit: 1e12 W, on v-grid
        Fheat_adv(nn,1:Ny) = ADVy_int;
        
        F_cavityS(nn) = ADVy_int(round(YcavityS/dy)+1); 
        F_icefront(nn) = ADVy_int(round(Yicefront/dy)); 
        F_shelfbreak(nn) = ADVy_int(round(Yshelfbreak/dy)); 
        Fheat_cavity(nn) = mean(ADVy_int(yidx_cavity)); 
        Fheat_shelf(nn) = mean(ADVy_int(yidx_shelf)); 
        Fheat_slope(nn) = mean(ADVy_int(yidx_slope)); 
   
        %%% Eddy/mean decomposition
        Fmean_vgrid = zeros(Nx,Ny,Nr);
        Fmean_vgrid(:,2:Ny,:) = 0.5*(THETA(:,1:Ny-1,:)+THETA(:,2:Ny,:)).*VVEL(:,2:Ny,:);
        Fmean_vgrid_xzint(nn,1:Ny) = cp_o*rho_o*sum(sum(Fmean_vgrid(xidx,:,:).*hFacS(xidx,:,:).*DZ_xyz(xidx,:,:).*DX_xyz(xidx,:,:),3),1)/1e12;
        
        Feddy_adv_xzint(nn,1:Ny) = Fheat_adv(nn,1:Ny)-Fmean_vgrid_xzint(nn,1:Ny);
        
        Fheat_vvelth(nn,1:Ny) = cp_o*rho_o*squeeze(sum(sum(VVELTH(xidx,:,:).*delX(1).*DZ_xyz(xidx,:,:).*hFacS(xidx,:,:),3)))/1e12;%%% Zonally averaged, depth-integrated 
        Feddy_vvelth_xzint(nn,1:Ny) = Fheat_vvelth(nn,1:Ny)-Fmean_vgrid_xzint(nn,1:Ny);
        
        F_cavityS_mean(nn) = Fmean_vgrid_xzint(round(YcavityS/dy)+1); 
        F_icefront_mean(nn) = Fmean_vgrid_xzint(round(Yicefront/dy)); 
        F_shelfbreak_mean(nn) = Fmean_vgrid_xzint(round(Yshelfbreak/dy)); 
        Fheat_cavity_mean(nn) = mean(Fmean_vgrid_xzint(yidx_cavity)); 
        Fheat_shelf_mean(nn) = mean(Fmean_vgrid_xzint(yidx_shelf)); 
        Fheat_slope_mean(nn) = mean(Fmean_vgrid_xzint(yidx_slope)); 
       
        F_cavityS_eddy(nn) = Feddy_adv_xzint(round(YcavityS/dy)+1); 
        F_icefront_eddy(nn) = Feddy_adv_xzint(round(Yicefront/dy)); 
        F_shelfbreak_eddy(nn) = Feddy_adv_xzint(round(Yshelfbreak/dy)); 
        Fheat_cavity_eddy(nn) = mean(Feddy_adv_xzint(yidx_cavity)); 
        Fheat_shelf_eddy(nn) = mean(Feddy_adv_xzint(yidx_shelf)); 
        Fheat_slope_eddy(nn) = mean(Feddy_adv_xzint(yidx_slope)); 

        %%% Ice-ocean heat flux
        Fio_cavity(nn) = sum(TFLUX(xidx,yidx_cavity)*delX(1)*delY(1),'all')/1e12;
        Fio_shelf(nn) = sum(TFLUX(xidx,yidx_shelf)*delX(1)*delY(1),'all')/1e12;
        Fio_slope(nn) = sum(TFLUX(xidx,yidx_slope)*delX(1)*delY(1),'all')/1e12;

        %%% Temperature tendency
        Ttend =  TOTTTEND/86400; 
        Ttend_int = cp_o*rho_o*sum(sum(Ttend(xidx,:,:).*DZ_xyz(xidx,:,:).*hFacC(xidx,:,:),3)*delX(1));     
        Ttend_cavity(nn) = sum(Ttend_int(yidx_cavity)*delY(1))/1e12;
        Ttend_shelf(nn) = sum(Ttend_int(yidx_shelf)*delY(1))/1e12;
        Ttend_slope(nn) = sum(Ttend_int(yidx_slope)*delY(1))/1e12;

    end
    

    %%% Save the products
    save([prodir,'heatbudget.mat'],'EXPDIR','EXPNAME','cp_o','rho_o',...
    'YcavityS','Yicefront','Yshelfbreak','YslopeN',...
    'Fheat_adv','Fheat_vvelth','Fmean_vgrid_xzint','Feddy_adv_xzint','Feddy_vvelth_xzint',...
    'F_cavityS',     'F_icefront',     'F_shelfbreak',...
    'F_cavityS_mean','F_icefront_mean','F_shelfbreak_mean',...
    'F_cavityS_eddy','F_icefront_eddy','F_shelfbreak_eddy',...
    'Fheat_cavity',     'Fheat_shelf',     'Fheat_slope',...
    'Fheat_cavity_mean','Fheat_shelf_mean','Fheat_slope_mean',...
    'Fheat_cavity_eddy','Fheat_shelf_eddy','Fheat_slope_eddy',...
    'Fio_cavity','Fio_shelf','Fio_slope',...
    'Ttend_cavity','Ttend_shelf','Ttend_slope'...
     );

