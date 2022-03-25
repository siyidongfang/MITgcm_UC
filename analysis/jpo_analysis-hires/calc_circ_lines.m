clear all;

addpath /Users/csi/MITgcm_ASF-csi/utils/matlab/; 
addpath /Users/csi/MITgcm_ASF-csi/analysis/;
addpath /Users/csi/MITgcm_ASF-csi/newexp/;
addpath /Users/csi/MITgcm_ASF-csi/analysis/colormaps/;
addpath  /Users/csi/MITgcm_ASF-csi/analysis/jpo_analysis;
prodir = '/Volumes/si/MITgcm_ASF-csi/products-hires'
expdir = '/Users/csi/MITgcm_ASF-csi/experiments';


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
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod'
    
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
buoy = [33 33.59 34.17 34.38 34.59 34.79]-34.17; 

m1km = 1000;

% sloperange = 100.*ones(1,nExp);
% sloperange(20:24)=2*[25 50 75 100 125]+50; 
% sloperange = sloperange*m1km;
% 
% ystart = 100.*ones(1,nExp);
% ystart = ystart*m1km;

sloperange = 50.*ones(1,nExp);
sloperange(20:24)=2*[25 50 75 100 125]; 
sloperange = sloperange*m1km;

ystart = 125.*ones(1,nExp);
ystart = ystart*m1km;


Lx = 400*m1km;
Ly = 450*m1km;


load([prodir '/alongslopcirc_ystart125km_new.mat'])
EXPNAME{30}='hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_prod';

% for ne = 1:length(EXPNAME)
for ne =30:30
    clear Nx Ny Nr yy hydrogTheta;
    expname = EXPNAME{ne}


    load([prodir '/' expname '_tavg_5yrs.mat'],'UVEL');
    Nr = size(UVEL,3);
    Ny = size(UVEL,2);
    Nx = size(UVEL,1);
    dy = Ly/Ny;
    
    loadexp;

    yend = ystart(ne) + sloperange(ne);
    ymin = round(ystart(ne)/dy);
    ymax = round(yend/dy);
    yidx = ymin:ymax;  % Slope index
    Lslope = yy(ymax)-yy(ymin);
  
    UVEL(UVEL==0)=NaN;
    idx_bottom = isnan(UVEL);
    seaflooridx_2D = Nr-sum(idx_bottom,3);
    DYxy = repmat(delY,[Nx 1]);
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    

    %%% Maximum westward speed over the slope
    u_xavg = squeeze(nanmean(UVEL,1)); % Zonal average
    seaflooridx = Nr-sum(double(isnan(u_xavg))'); 
    seaflooridx(1) = seaflooridx(2);
    seaflooridx(Ny) = seaflooridx(Ny-1);
    
    umax(ne) = abs(min(min(u_xavg(yidx,:)))); 
    
    UVEL(UVEL==0)=NaN;
    u_bottom = zeros(Nx,Ny);
    for i = 1:Nx
        for j = 2:Ny-1
           u_bottom(i,j) = UVEL(i,j,seaflooridx_2D(i,j));
        end
    end
    %%% Maximum bottom westward speed over the slope
    u_bottom_xavg = nanmean(u_bottom,1); % Zonal average
    ubotmax(ne) = abs(min(u_bottom_xavg(yidx)));
    
    %%% Maximum sea surface westward speed over the slope
    u_surf_xavg = nanmean(UVEL(:,:,1),1); % Zonal average
    usurfmax(ne) = abs(min(u_surf_xavg(yidx)));

    Nsponge = round(20*m1km/dy);
    spy = Nsponge+1:Ny-Nsponge;
    Ldomain = yy(Ny-Nsponge)-yy(Nsponge+1);
    
    %%% Westward barotropic transport, Sv
    Tbt_all(ne) = abs(nanmean(nansum(u_bottom(:,spy).*abs(bathy(:,spy)).*DYxy(:,spy),2))/1e6);
    
    %%% Total westward transport, Sv
    Ttot_all(ne) = abs(nanmean(nansum(nansum(UVEL(:,spy,:).*DZ(:,spy,:).*hFacW(:,spy,:),3).*DYxy(:,spy,:),2)/1e6));

    %%% Westward baroclinic transport, Sv
    Tbc_all(ne) = Ttot_all(ne) - Tbt_all(ne);
    
    
    %%% Westward barotropic transport over the slope per unit length,
    %%% Sv/kmssssssss
    Tbt_slope(ne) = abs(nanmean(nansum(u_bottom(:,yidx).*abs(bathy(:,yidx)).*DYxy(:,yidx),2))/1e6)./(Lslope/m1km);
    
    %%% Total westward transport over the slope per unit length, Sv/km
    Ttot_slope(ne) = abs(nanmean(nansum(nansum(UVEL(:,yidx,:).*DZ(:,yidx,:).*hFacW(:,yidx,:),3).*DYxy(:,yidx,:),2)/1e6))./(Lslope/m1km);

    %%% Westward baroclinic transport over the slope per unit length, Sv/km
    Tbc_slope(ne) = Ttot_slope(ne) - Tbt_slope(ne);


%%%%%%%%
%%%%%%%% Calculate the mean velocity for the upper layer and the lower
%%%%%%%% layer, then calculate the maximum velocities of the upper and the
%%%%%%%% lower layers, and the Tbc, Tbt over the continental slope.
%%%%%%%%
    ho = min(-bathy);   %%% Find the upper bound of the bathymetry.
    ifs_depth = -ho/2;  %%% The depth of the isopycnal interface between the upper and the lower layer
    for i = 1:Ny
        [~, ifs_depth_idx(i)]=min(abs(ifs_depth(i)-zz)); %%% Find the vertical index of the isopycnal layer in between
        hh_os_3D(i) = sum(delR(1:ifs_depth_idx(i)-1)); %%% Upper layer thickness
        hh_ob_3D(i) = sum(delR(ifs_depth_idx(i):seaflooridx(i))); %%% Lower layer thickness
        us_3D(i) = sum(u_xavg(i,1:ifs_depth_idx(i)-1).*delR(1:ifs_depth_idx(i)-1))./hh_os_3D(i); %%% Upper layer mean density, as a function of latitude
        ub_3D(i) = sum(u_xavg(i,ifs_depth_idx(i):seaflooridx(i)).*delR(ifs_depth_idx(i):seaflooridx(i)))./hh_ob_3D(i); %%% Lower layer mean density, as a function of latitude
    end
    umax_upper(ne) = abs(min(us_3D(yidx)));
    umax_lower(ne) = abs(min(ub_3D(yidx)));
    Tbt_slope_2layer(ne) = - sum(ub_3D(yidx).*ho(yidx)*dy)/1e6./sloperange(ne)*m1km; % Sv/km
    Ttotal_slope_2layer(ne) = - sum(us_3D(yidx).*hh_os_3D(yidx)*dy)/1e6./sloperange(ne)*m1km ...
        - sum(ub_3D(yidx).*hh_ob_3D(yidx)*dy)/1e6./sloperange(ne)*m1km;
    Tbc_slope_2layer(ne) = Ttotal_slope_2layer(ne) - Tbt_slope_2layer(ne);
    
end




%%

save([prodir '/alongslopcirc_ystart125km_new2.mat'],'EXPNAME','umax','ubotmax',...
    'usurfmax',...
    'Tbt_all','Tbc_all','Ttot_all','sloperange',...
    'Tbt_slope','Tbc_slope','Ttot_slope',...
    'umax_upper','umax_lower','Tbt_slope_2layer','Tbc_slope_2layer','Ttotal_slope_2layer',...
    'ystart','yend','sloperange');

