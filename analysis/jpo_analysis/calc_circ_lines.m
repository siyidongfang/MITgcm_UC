addpath /data/MITgcm_ASF-csi/utils/matlab/; 
addpath /data/MITgcm_ASF-csi/newexp/analysis/;
addpath /data/MITgcm_ASF-csi/newexp/;
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps/;
addpath  /data/MITgcm_ASF-csi/newexp/jpo_analysis;
outdir = '/data/MITgcm_ASF-csi/experiments/products/';
expdir = '~/MITgcm_ASF-experiments/';

% EXPNAME = { ...
%   'fresh02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
%   'lores_Ua-6Va6_Atide0.025_Hi1Ai1_Ws25_Nr30',...
%   'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2',...
%   'fresh02-td4_atide0.075Umax1.5Ua-6Va6Hi1Ai1_2kmNr30Ws25',...  
%   'fresh02-td3umax2_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
%   'fresh02-td5_atide0.125Umax1.75Ua-6Va6Hi1Ai1_2kmNr30Ws25',...
%   ...
%   'fresh02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
%   'fresh02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
%   'lores_Ua-6Va6_Atide0.05_Hi1.4Ai1_Ws25_Nr30',...
%   'fresh02-ice4_Hi1.8Ai1Ua-6Va6atide0.05_2kmNr30Ws25-NewSuviceLWDOWN',...
%   'lores_Ua-6Va6_Atide0.05_Hi2.2Ai1_Ws25_Nr30',...
%   };

EXPNAME = {...
  'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',...
  'ssurf33.5868_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws25',... 
  'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2',... 
  'den02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'sdiff2_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',... 
  'sdiff2.5_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25',... 
  'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'... 
  ...
  'fresh02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  'fresh02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  ...
  'fresh02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...   
  'fresh02-td4_atide0.075Umax1.5Ua-6Va6Hi1Ai1_2kmNr30Ws25',... 
  'fresh02-td3umax2_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  ...
  'fresh02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  ...
  'den02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'den02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  'den02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25',...
  ...
  'dense_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'dense-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  'dense-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25',...
  ...
  'ws3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws75_lores2',...  
  'ws5_Ua-6Va6_Atide0.05_Hi0Ai0_Ws125_lores2',... 
  ...
  'fresh02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  'fresh02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  ...
  'res-ws1NewSuvice2_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores5',...
  'res3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores10'...   
  };


nExp = size(EXPNAME,2);
sloperange = 100.*ones(1,nExp); % 100km~200km
sloperange(27)=200; % 100km~300km
sloperange(28)=300; % 100km~400km


expname = EXPNAME{3};
loadexp;
dy = delY(1).*ones(1,nExp);
dy(nExp-1) = 5000;
dy(nExp) = 10000;

load([outdir '/' expname '_tavg_5yrs.mat'],'UVEL');
    UVEL(UVEL==0)=NaN;
    idx_bottom = isnan(UVEL);
    idxb = 30-sum(idx_bottom,3);
    idxb3D = zeros(Nx,Ny,Nr);
    DYxy = repmat(delY,[Nx 1]);
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

nn=1;

for ne = 1:nExp-2
           
    expname = EXPNAME{ne};
    load([outdir '/' expname '_tavg_5yrs.mat'],'UVEL');

    %%% Maximum westward speed over the slope
    u_mean = squeeze(mean(UVEL,1));
    ystart = 100*1000;
    yend = ystart + sloperange(ne).*1000;
    umax(nn) = abs(min(min(u_mean(ystart/dy(ne):yend/dy(ne),:)))); 
    
    UVEL(UVEL==0)=NaN;
    u_bottom = zeros(Nx,Ny);
    for i = 1:Nx
        for j = 2:Ny-1
           u_bottom(i,j) = UVEL(i,j,idxb(i,j));
        end
    end
    %%% Maximum bottom westward speed over the slope
    u_bottom_mean = mean(u_bottom,1);
    ubotmax(nn) = abs(min(u_bottom_mean(ystart/dy(ne):yend/dy(ne))));
%     ubotmax(nn) = abs(min(min(u_bottom(:,10:Ny-10,:))));
    

    Nsponge = 20*1000/delY(1);
    spy = Nsponge+1:Ny-Nsponge;
    Ldomain = size(spy,2)*dy(nn);
    
    %%% Westward barotropic transport, Sv
    Tbt_all(nn) = abs(mean(nansum(u_bottom(:,spy).*abs(bathy(:,spy)).*DYxy(:,spy),2))/1e6);
    
    %%% Total westward transport, Sv
    Ttot_all(nn) = abs(mean(nansum(nansum(UVEL(:,spy,:).*DZ(:,spy,:).*hFacW(:,spy,:),3).*DYxy(:,spy,:),2)/1e6));

    %%% Westward baroclinic transport, Sv
    Tbc_all(nn) = Ttot_all(nn) - Tbt_all(nn);
    
    
    SPY = ystart/delY(1):yend/delY(1);
    Lslope = size(SPY,2)*delY(1)./1000;
    %%% Westward barotropic transport over the slope per unit length, Sv/km
    Tbt_slope(nn) = abs(mean(nansum(u_bottom(:,SPY).*abs(bathy(:,SPY)).*DYxy(:,SPY),2))/1e6)./Lslope;
    
    %%% Total westward transport over the slope per unit length, Sv/km
    Ttot_slope(nn) = abs(mean(nansum(nansum(UVEL(:,SPY,:).*DZ(:,SPY,:).*hFacW(:,SPY,:),3).*DYxy(:,SPY,:),2)/1e6))./Lslope;

    %%% Westward baroclinic transport over the slope per unit length, Sv/km
    Tbc_slope(nn) = Ttot_slope(nn) - Tbt_slope(nn);
    
    
    nn = nn+1;
end


%%
for   ne = nExp-1:nExp
       
    expname = EXPNAME{ne};
    loadexp;

    load([outdir '/' expname '_tavg_5yrs.mat'],'UVEL');
    UVEL(UVEL==0)=NaN;
    idx_bottom = isnan(UVEL);
    idxb = 30-sum(idx_bottom,3);
    idxb3D = zeros(Nx,Ny,Nr);
    DYxy = repmat(delY,[Nx 1]);
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

    %%% Maximum westward speed over the slope
    u_mean = squeeze(mean(UVEL,1));
    ystart = 100*1000;
    yend = ystart + sloperange(ne).*1000;
    umax(nn) = abs(min(min(u_mean(ystart/dy(ne):yend/dy(ne),:)))); 
    
    UVEL(UVEL==0)=NaN;
    u_bottom = zeros(Nx,Ny);
    for i = 1:Nx
        for j = 2:Ny-1
           u_bottom(i,j) = UVEL(i,j,idxb(i,j));
        end
    end
    %%% Maximum bottom westward speed over the slope
    u_bottom_mean = mean(u_bottom,1);
    ubotmax(nn) = abs(min(u_bottom_mean(ystart/dy(ne):yend/dy(ne))));
%     ubotmax(nn) = abs(min(min(u_bottom(:,10:Ny-10,:))));
    

    Nsponge = 20*1000/delY(1);
    spy = Nsponge+1:Ny-Nsponge;
    Ldomain = size(spy,2)*dy(nn);
    
    %%% Westward barotropic transport, Sv
    Tbt_all(nn) = abs(mean(nansum(u_bottom(:,spy).*abs(bathy(:,spy)).*DYxy(:,spy),2))/1e6);
    
    %%% Total westward transport, Sv
    Ttot_all(nn) = abs(mean(nansum(nansum(UVEL(:,spy,:).*DZ(:,spy,:).*hFacW(:,spy,:),3).*DYxy(:,spy,:),2)/1e6));

    %%% Westward baroclinic transport, Sv
    Tbc_all(nn) = Ttot_all(nn) - Tbt_all(nn);
    
    
    SPY = ystart/delY(1):yend/delY(1);
    Lslope = size(SPY,2)*delY(1)./1000;
    %%% Westward barotropic transport over the slope per unit length, Sv/km
    Tbt_slope(nn) = abs(mean(nansum(u_bottom(:,SPY).*abs(bathy(:,SPY)).*DYxy(:,SPY),2))/1e6)./Lslope;
    
    %%% Total westward transport over the slope per unit length, Sv/km
    Ttot_slope(nn) = abs(mean(nansum(nansum(UVEL(:,SPY,:).*DZ(:,SPY,:).*hFacW(:,SPY,:),3).*DYxy(:,SPY,:),2)/1e6))./Lslope;

    %%% Westward baroclinic transport over the slope per unit length, Sv/km
    Tbc_slope(nn) = Ttot_slope(nn) - Tbt_slope(nn);
    
    
    nn = nn+1;
end


save([outdir '/alongslopcirc.mat'],'EXPNAME','umax','ubotmax',...
    'Tbt_all','Tbc_all','Ttot_all','sloperange',...
    'Tbt_slope','Tbc_slope','Ttot_slope');

