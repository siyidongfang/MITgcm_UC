    clear all; close all

    addpath /data/MITgcm_ASF-csi/utils/matlab/; 
    addpath /data/MITgcm_ASF-csi/analysis/;
    addpath /data/MITgcm_ASF-csi/newexp/;
    addpath /data/MITgcm_ASF-csi/analysis/colormaps/;
    addpath  /data/MITgcm_ASF-csi/analysis/jpo_analysis;
    prodir = '/data/MITgcm_ASF-csi/products-hires/'
    expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments';

    EXPNAME = {
        'hires_Ua-6Va6_Atide0_Hi1Ai1_Ws25_analysis'
        'hires_Ua-6Va6_Atide0.025_Hi1Ai1_Ws25_analysis'
        'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
        'hires_Ua-6Va6_Atide0.075_Hi1Ai1_Ws25_analysis'
        'hires_Ua-6Va6_Atide0.1_Hi1Ai1_Ws25_analysis'

        'hires_Ua0Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
        'hires_Ua-4Va6_Atide0.05_Hi1Ai1_Ws25_analysis_new100s'
        'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
        'hires_Ua-8Va6_Atide0.05_Hi1Ai1_Ws25_analysis'

        'hires_Ua-6Va4_Atide0.05_Hi1Ai1_Ws25_analysis'
        'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
        'hires_Ua-6Va8_Atide0.05_Hi1Ai1_Ws25_analysis'
        'hires_Ua-6Va12_Atide0.05_Hi1Ai1_Ws25_analysis'

        'hires_Ua-6Va6_Atide0.05_Hi0.2Ai1_Ws25_analysis'
        'hires_Ua-6Va6_Atide0.05_Hi0.6Ai1_Ws25_analysis'
        'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
        'hires_Ua-6Va6_Atide0.05_Hi1.4Ai1_Ws25_analysis'
        'hires_Ua-6Va6_Atide0.05_Hi1.8Ai1_Ws25_analysis'
        'hires_Ua-6Va6_Atide0.05_Hi2.2Ai1_Ws25_analysis'

        'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
        'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws50_analysis'
        'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws75_analysis'
        'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws100_analysis'
        'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws125_analysis'

        'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis'
        'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33.59_analysis'
        'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
        'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff1_analysis'
        'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff2_analysis'
        'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_analysis'

        'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
        'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2'
        'res-ws1NewSuvice2_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores5'
        'res3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores10'
    };



    nExp = length(EXPNAME);


    nAtide  = 1:5;
    Atide = [0 0.025 0.05 0.075 0.1];
    nabs_ua = 6:9;
    abs_ua = [0 4 6 8]; 
    nva = 10:13;
    va = [4 6 8 12];
    nhi0 = 14:19;
    hi0  = [0.2 0.6 1 1.4 1.8 2.2];
    nws = 20:24;
    ws = [25 50 75 100 125];
    Ys = [150 175 200 225 250];
    nbuoy = 25:30;
%     buoy = [33 33.59 34.17 34.38 34.59 34.79]-34.17; 
buoy = [-1.076 -0.620 -0.207 0.000 0.204 0.409];
    nres = [31:34];
    res = [1 2 5 10];


    m1km = 1000;

    % sloperange = 100.*ones(1,nExp);
    % sloperange(20:24)=2*[25 50 75 100 125]+50; 
    % sloperange = sloperange*m1km;
    % 
    % ystart = 100.*ones(1,nExp);
    % ystart = ystart*m1km;

    SLOPERANGE = 50.*ones(1,nExp);
    SLOPERANGE(20:24)=2*[25 50 75 100 125]; 
    SLOPERANGE = SLOPERANGE*m1km;

    ystart = 125*m1km;

    Lx = 400*m1km;
    Ly = 450*m1km;
    
    Nr=70
    uo_slope_batch = zeros(nExp,Nr);
    ui_slope_batch = zeros(nExp,1);


%%
for ne = [32 33 34]
        expname = EXPNAME{ne}
        loadexp;
        load([prodir expname '_tavg_5yrs.mat'],'VVEL','SALT','THETA','PHIHYD','VVELSLT','VVELTH',...
            'UVEL','SIuice','WVEL','WU_VEL');

        sloperange = SLOPERANGE(ne);
        1
        calcFeddy_new;
        2
        calcFeddy_uw;                      
    end
    
    
 %% 
 %%
for ne = 1:30
        expname = EXPNAME{ne}
        loadexp;
        load([prodir expname '_tavg_5yrs.mat'],'UVEL','SIuice');
    sloperange = SLOPERANGE(ne);    
    %%% Grid spacing matrices    
    DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
    drc = rdmds([exppath,'/results/DRC']);

    ff = f0+beta*(yy);  % u/mass-grid
    
    yend = ystart + sloperange;
    ymin = round(ystart/delY(1));
    ymax = round(yend/delY(1));
    yidx = ymin:ymax;
    Lslope = yy(ymax)-yy(ymin);
    
        ui_slope_batch(ne) = mean(SIuice(:,yidx,1),'all');
        uo_slope_batch(ne,1:Nr) = sum(squeeze(sum(UVEL(:,yidx,:).*DX_xyz(:,yidx,:),1)/Lx)...
                                   .*delY(1),1)./Lslope;
end                           
                               
    Nr = 70
    load([prodir 'MomScalingMatrix_slope_ystart125km.mat'],'Windstress')


    IFS_standing_Estimate_slope_batch = zeros(nExp,Nr);
    IFS_transient_Estimate_slope_batch = zeros(nExp,Nr);
    
    d_IFS_standing_Estimate_dz_slope_batch = zeros(nExp,Nr-1);
    d_IFS_transient_Estimate_dz_slope_batch = zeros(nExp,Nr-1);
    
    normalized_IFS_standing_slope_batch = zeros(nExp,Nr);
    normalized_IFS_transient_slope_batch = zeros(nExp,Nr);
    
    uw_transient_slope_batch = zeros(nExp,Nr);
    uw_standing_slope_batch = zeros(nExp,Nr);
    
    standing_slope_batch = zeros(nExp,Nr);
    transient_slope_batch = zeros(nExp,Nr);
    normalized_standing_slope_batch = zeros(nExp,Nr);
    normalized_transient_slope_batch = zeros(nExp,Nr);
    
    rho0 = 999.8;
    
    for ne = 1:30
        expname = EXPNAME{ne}
        load([prodir 'IFS/' expname '-IFS.mat']);
        IFS_standing_Estimate_slope_batch(ne,:) = IFS_standing_Estimate_slope;
        IFS_transient_Estimate_slope_batch(ne,:) = IFS_transient_Estimate_slope;
        d_IFS_standing_Estimate_dz_slope_batch(ne,:) = d_IFS_standing_Estimate_dz_slope;
        d_IFS_transient_Estimate_dz_slope_batch(ne,:) = d_IFS_transient_Estimate_dz_slope;
        
        normalized_IFS_standing_slope_batch(ne,:) = IFS_standing_Estimate_slope./Windstress(ne)*rho0;
        normalized_IFS_transient_slope_batch(ne,:) = IFS_transient_Estimate_slope./Windstress(ne)*rho0;
        
        load([prodir 'IFS/' expname '-wu.mat']);
        uw_standing_slope_batch(ne,:) = uw_standing_slope;
        uw_transient_slope_batch(ne,:) = uw_transient_slope;
        
        standing_slope_batch(ne,:) = -uw_standing_slope+IFS_standing_Estimate_slope;
        transient_slope_batch(ne,:) = -uw_transient_slope+IFS_transient_Estimate_slope;
        normalized_standing_slope_batch(ne,:) = standing_slope_batch(ne,:)./Windstress(ne)*rho0;
        normalized_transient_slope_batch(ne,:) = transient_slope_batch(ne,:)./Windstress(ne)*rho0;

    end
    



    save([prodir 'IFS/calcFeddy_batch_new.mat'],'EXPNAME','zz',...
        'ui_slope_batch','uo_slope_batch',...
        'IFS_standing_Estimate_slope_batch','IFS_transient_Estimate_slope_batch',...
        'd_IFS_standing_Estimate_dz_slope_batch','d_IFS_transient_Estimate_dz_slope_batch',...
        'normalized_IFS_standing_slope_batch','normalized_IFS_transient_slope_batch',...
        'uw_standing_slope_batch','uw_transient_slope_batch',...
        'standing_slope_batch','transient_slope_batch',...
        'normalized_standing_slope_batch','normalized_transient_slope_batch');
