clear all;

addpath /data/Software/gsw_matlab_v3_06_11/;
addpath /data/Software/gsw_matlab_v3_06_11/library/;
addpath /data/Software/gsw_matlab_v3_06_11/thermodynamics_from_t;
addpath /data/MITgcm_ASF-csi/newexp/;
addpath /data/MITgcm_ASF-csi/newexp/analysis/;
addpath /data/MITgcm_ASF-csi/newexp/analysis/colormaps/;
addpath ../jpo_analysis/
prodir = '/data/MITgcm_ASF-csi/experiments/products/';
expdir = '/home/csi/MITgcm_ASF-experiments/';

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
  'fresh02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25',...
  ...  
  'ws3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws75_lores2',...  
  'ws5_Ua-6Va6_Atide0.05_Hi0Ai0_Ws125_lores2',...
  ...
  'res-ws1NewSuvice2_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores5',...
  'res3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores10'...   
  };
nExp = size(EXPNAME,2);

expname = EXPNAME{3};
loadexp;

YSlopeBegin = round(125/2)-1;
YSlopeEnd   = round(175/2)+1;
Sponge = 20/2;

for ne = 1:nExp-4
expname = EXPNAME{ne}
NE{ne} = expname;

%%% Read experiment data
load([prodir '/' expname '_tavg_5yrs.mat'],'UVEL','VVEL','WVEL',...
    'UV_VEL_Z','WU_VEL','SALT','THETA','PHIHYD','VRHOMASS','VVELSLT','VVELTH');
calcFeddy;

uw_tran_eddy_shelf(ne) = mean(uw_tran_eddy_xzint(Sponge+1:YSlopeBegin-1));
uw_tran_eddy_slope(ne) = mean(uw_tran_eddy_xzint(YSlopeBegin:YSlopeEnd));
uw_tran_eddy_deep(ne)  = mean(uw_tran_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

fs_tran_eddy_shelf(ne) = mean(fs_tran_eddy_xzint(Sponge+1:YSlopeBegin-1));
fs_tran_eddy_slope(ne) = mean(fs_tran_eddy_xzint(YSlopeBegin:YSlopeEnd));
fs_tran_eddy_deep(ne)  = mean(fs_tran_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

uv_tran_eddy_shelf(ne) = mean(uv_tran_eddy_xzint(Sponge+1:YSlopeBegin-1));
uv_tran_eddy_slope(ne) = mean(uv_tran_eddy_xzint(YSlopeBegin:YSlopeEnd));
uv_tran_eddy_deep(ne)  = mean(uv_tran_eddy_xzint(YSlopeEnd-1:Ny-Sponge));


uw_std_eddy_shelf(ne) = mean(uw_std_eddy_xzint(Sponge+1:YSlopeBegin-1));
uw_std_eddy_slope(ne) = mean(uw_std_eddy_xzint(YSlopeBegin:YSlopeEnd));
uw_std_eddy_deep(ne)  = mean(uw_std_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

fs_std_eddy_shelf(ne) = mean(fs_std_eddy_xzint(Sponge+1:YSlopeBegin-1));
fs_std_eddy_slope(ne) = mean(fs_std_eddy_xzint(YSlopeBegin:YSlopeEnd));
fs_std_eddy_deep(ne)  = mean(fs_std_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

uv_std_eddy_shelf(ne) = mean(uv_std_eddy_xzint(Sponge+1:YSlopeBegin-1));
uv_std_eddy_slope(ne) = mean(uv_std_eddy_xzint(YSlopeBegin:YSlopeEnd));
uv_std_eddy_deep(ne)  = mean(uv_std_eddy_xzint(YSlopeEnd-1:Ny-Sponge));


end

%% 

for ne = nExp-3:nExp-3
expname = EXPNAME{ne}
NE{ne} = expname;

YSlopeBegin = round(125/2)-1;
YSlopeEnd   = round(275/2)+1;
Sponge = 20/2;
loadexp
%%% Read experiment data
load([prodir '/' expname '_tavg_5yrs.mat'],'UVEL','VVEL','WVEL',...
    'UV_VEL_Z','WU_VEL','SALT','THETA','PHIHYD','VRHOMASS','VVELSLT','VVELTH');
calcFeddy;

uw_tran_eddy_shelf(ne) = mean(uw_tran_eddy_xzint(Sponge+1:YSlopeBegin-1));
uw_tran_eddy_slope(ne) = mean(uw_tran_eddy_xzint(YSlopeBegin:YSlopeEnd));
uw_tran_eddy_deep(ne)  = mean(uw_tran_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

fs_tran_eddy_shelf(ne) = mean(fs_tran_eddy_xzint(Sponge+1:YSlopeBegin-1));
fs_tran_eddy_slope(ne) = mean(fs_tran_eddy_xzint(YSlopeBegin:YSlopeEnd));
fs_tran_eddy_deep(ne)  = mean(fs_tran_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

uv_tran_eddy_shelf(ne) = mean(uv_tran_eddy_xzint(Sponge+1:YSlopeBegin-1));
uv_tran_eddy_slope(ne) = mean(uv_tran_eddy_xzint(YSlopeBegin:YSlopeEnd));
uv_tran_eddy_deep(ne)  = mean(uv_tran_eddy_xzint(YSlopeEnd-1:Ny-Sponge));



uw_std_eddy_shelf(ne) = mean(uw_std_eddy_xzint(Sponge+1:YSlopeBegin-1));
uw_std_eddy_slope(ne) = mean(uw_std_eddy_xzint(YSlopeBegin:YSlopeEnd));
uw_std_eddy_deep(ne)  = mean(uw_std_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

fs_std_eddy_shelf(ne) = mean(fs_std_eddy_xzint(Sponge+1:YSlopeBegin-1));
fs_std_eddy_slope(ne) = mean(fs_std_eddy_xzint(YSlopeBegin:YSlopeEnd));
fs_std_eddy_deep(ne)  = mean(fs_std_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

uv_std_eddy_shelf(ne) = mean(uv_std_eddy_xzint(Sponge+1:YSlopeBegin-1));
uv_std_eddy_slope(ne) = mean(uv_std_eddy_xzint(YSlopeBegin:YSlopeEnd));
uv_std_eddy_deep(ne)  = mean(uv_std_eddy_xzint(YSlopeEnd-1:Ny-Sponge));


end


for ne = nExp-2:nExp-2
expname = EXPNAME{ne}
NE{ne} = expname;

YSlopeBegin = round(125/2)-1;
YSlopeEnd   = round(375/2)+1;
Sponge = 20/2;
loadexp

%%% Read experiment data
load([prodir '/' expname '_tavg_5yrs.mat'],'UVEL','VVEL','WVEL',...
    'UV_VEL_Z','WU_VEL','SALT','THETA','PHIHYD','VRHOMASS','VVELSLT','VVELTH');
calcFeddy;


uw_tran_eddy_shelf(ne) = mean(uw_tran_eddy_xzint(Sponge+1:YSlopeBegin-1));
uw_tran_eddy_slope(ne) = mean(uw_tran_eddy_xzint(YSlopeBegin:YSlopeEnd));
uw_tran_eddy_deep(ne)  = mean(uw_tran_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

fs_tran_eddy_shelf(ne) = mean(fs_tran_eddy_xzint(Sponge+1:YSlopeBegin-1));
fs_tran_eddy_slope(ne) = mean(fs_tran_eddy_xzint(YSlopeBegin:YSlopeEnd));
fs_tran_eddy_deep(ne)  = mean(fs_tran_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

uv_tran_eddy_shelf(ne) = mean(uv_tran_eddy_xzint(Sponge+1:YSlopeBegin-1));
uv_tran_eddy_slope(ne) = mean(uv_tran_eddy_xzint(YSlopeBegin:YSlopeEnd));
uv_tran_eddy_deep(ne)  = mean(uv_tran_eddy_xzint(YSlopeEnd-1:Ny-Sponge));


uw_std_eddy_shelf(ne) = mean(uw_std_eddy_xzint(Sponge+1:YSlopeBegin-1));
uw_std_eddy_slope(ne) = mean(uw_std_eddy_xzint(YSlopeBegin:YSlopeEnd));
uw_std_eddy_deep(ne)  = mean(uw_std_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

fs_std_eddy_shelf(ne) = mean(fs_std_eddy_xzint(Sponge+1:YSlopeBegin-1));
fs_std_eddy_slope(ne) = mean(fs_std_eddy_xzint(YSlopeBegin:YSlopeEnd));
fs_std_eddy_deep(ne)  = mean(fs_std_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

uv_std_eddy_shelf(ne) = mean(uv_std_eddy_xzint(Sponge+1:YSlopeBegin-1));
uv_std_eddy_slope(ne) = mean(uv_std_eddy_xzint(YSlopeBegin:YSlopeEnd));
uv_std_eddy_deep(ne)  = mean(uv_std_eddy_xzint(YSlopeEnd-1:Ny-Sponge));


end

%%
for ne = nExp-1:nExp-1
expname = EXPNAME{ne}
NE{ne} = expname;

YSlopeBegin = round(125/5);
YSlopeEnd   = round(175/5);
Sponge = 20/5;

loadexp;
clear uvel vvel wvel uvel_vorgrid vvel_vorgrid wu u_zonal3D_vorgrid v_zonal3D_vorgrid...
    dS_dz dTheta_dz vvel_tgrid vvelslt vvelth vs_tran vt_tran v_zonal3D_tgrid
%%% Read experiment data
load([prodir '/' expname '_tavg_5yrs.mat'],'UVEL','VVEL','WVEL',...
    'UV_VEL_Z','WU_VEL','SALT','THETA','PHIHYD','VRHOMASS','VVELSLT','VVELTH');
calcFeddy;


uw_tran_eddy_shelf(ne) = mean(uw_tran_eddy_xzint(Sponge+1:YSlopeBegin-1));
uw_tran_eddy_slope(ne) = mean(uw_tran_eddy_xzint(YSlopeBegin:YSlopeEnd));
uw_tran_eddy_deep(ne)  = mean(uw_tran_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

fs_tran_eddy_shelf(ne) = mean(fs_tran_eddy_xzint(Sponge+1:YSlopeBegin-1));
fs_tran_eddy_slope(ne) = mean(fs_tran_eddy_xzint(YSlopeBegin:YSlopeEnd));
fs_tran_eddy_deep(ne)  = mean(fs_tran_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

uv_tran_eddy_shelf(ne) = mean(uv_tran_eddy_xzint(Sponge+1:YSlopeBegin-1));
uv_tran_eddy_slope(ne) = mean(uv_tran_eddy_xzint(YSlopeBegin:YSlopeEnd));
uv_tran_eddy_deep(ne)  = mean(uv_tran_eddy_xzint(YSlopeEnd-1:Ny-Sponge));


uw_std_eddy_shelf(ne) = mean(uw_std_eddy_xzint(Sponge+1:YSlopeBegin-1));
uw_std_eddy_slope(ne) = mean(uw_std_eddy_xzint(YSlopeBegin:YSlopeEnd));
uw_std_eddy_deep(ne)  = mean(uw_std_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

fs_std_eddy_shelf(ne) = mean(fs_std_eddy_xzint(Sponge+1:YSlopeBegin-1));
fs_std_eddy_slope(ne) = mean(fs_std_eddy_xzint(YSlopeBegin:YSlopeEnd));
fs_std_eddy_deep(ne)  = mean(fs_std_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

uv_std_eddy_shelf(ne) = mean(uv_std_eddy_xzint(Sponge+1:YSlopeBegin-1));
uv_std_eddy_slope(ne) = mean(uv_std_eddy_xzint(YSlopeBegin:YSlopeEnd));
uv_std_eddy_deep(ne)  = mean(uv_std_eddy_xzint(YSlopeEnd-1:Ny-Sponge));


end


for ne = nExp:nExp
expname = EXPNAME{ne}
NE{ne} = expname;

YSlopeBegin = round(125/10)-1;
YSlopeEnd   = round(175/10)+1;
Sponge = 20/10;

loadexp;
clear uvel vvel wvel uvel_vorgrid vvel_vorgrid wu u_zonal3D_vorgrid v_zonal3D_vorgrid...
    dS_dz dTheta_dz vvel_tgrid vvelslt vvelth vs_tran vt_tran v_zonal3D_tgrid
%%% Read experiment data
load([prodir '/' expname '_tavg_5yrs.mat'],'UVEL','VVEL','WVEL',...
    'UV_VEL_Z','WU_VEL','SALT','THETA','PHIHYD','VRHOMASS','VVELSLT','VVELTH');
calcFeddy;


uw_tran_eddy_shelf(ne) = mean(uw_tran_eddy_xzint(Sponge+1:YSlopeBegin-1));
uw_tran_eddy_slope(ne) = mean(uw_tran_eddy_xzint(YSlopeBegin:YSlopeEnd));
uw_tran_eddy_deep(ne)  = mean(uw_tran_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

fs_tran_eddy_shelf(ne) = mean(fs_tran_eddy_xzint(Sponge+1:YSlopeBegin-1));
fs_tran_eddy_slope(ne) = mean(fs_tran_eddy_xzint(YSlopeBegin:YSlopeEnd));
fs_tran_eddy_deep(ne)  = mean(fs_tran_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

uv_tran_eddy_shelf(ne) = mean(uv_tran_eddy_xzint(Sponge+1:YSlopeBegin-1));
uv_tran_eddy_slope(ne) = mean(uv_tran_eddy_xzint(YSlopeBegin:YSlopeEnd));
uv_tran_eddy_deep(ne)  = mean(uv_tran_eddy_xzint(YSlopeEnd-1:Ny-Sponge));


uw_std_eddy_shelf(ne) = mean(uw_std_eddy_xzint(Sponge+1:YSlopeBegin-1));
uw_std_eddy_slope(ne) = mean(uw_std_eddy_xzint(YSlopeBegin:YSlopeEnd));
uw_std_eddy_deep(ne)  = mean(uw_std_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

fs_std_eddy_shelf(ne) = mean(fs_std_eddy_xzint(Sponge+1:YSlopeBegin-1));
fs_std_eddy_slope(ne) = mean(fs_std_eddy_xzint(YSlopeBegin:YSlopeEnd));
fs_std_eddy_deep(ne)  = mean(fs_std_eddy_xzint(YSlopeEnd-1:Ny-Sponge));

uv_std_eddy_shelf(ne) = mean(uv_std_eddy_xzint(Sponge+1:YSlopeBegin-1));
uv_std_eddy_slope(ne) = mean(uv_std_eddy_xzint(YSlopeBegin:YSlopeEnd));
uv_std_eddy_deep(ne)  = mean(uv_std_eddy_xzint(YSlopeEnd-1:Ny-Sponge));


end


uw_tran_eddy_shelf = uw_tran_eddy_shelf/Lx;
uw_tran_eddy_slope = uw_tran_eddy_slope/Lx;
uw_tran_eddy_deep  = uw_tran_eddy_deep/Lx;

fs_tran_eddy_shelf = fs_tran_eddy_shelf/Lx;
fs_tran_eddy_slope = fs_tran_eddy_slope/Lx;
fs_tran_eddy_deep  = fs_tran_eddy_deep/Lx;

uv_tran_eddy_shelf = uv_tran_eddy_shelf/Lx;
uv_tran_eddy_slope = uv_tran_eddy_slope/Lx;
uv_tran_eddy_deep  = uv_tran_eddy_deep/Lx;


uw_std_eddy_shelf = uw_std_eddy_shelf/Lx;
uw_std_eddy_slope = uw_std_eddy_slope/Lx;
uw_std_eddy_deep  = uw_std_eddy_deep/Lx;

fs_std_eddy_shelf = fs_std_eddy_shelf/Lx;
fs_std_eddy_slope = fs_std_eddy_slope/Lx;
fs_std_eddy_deep  = fs_std_eddy_deep/Lx;

uv_std_eddy_shelf = uv_std_eddy_shelf/Lx;
uv_std_eddy_slope = uv_std_eddy_slope/Lx;
uv_std_eddy_deep  = uv_std_eddy_deep/Lx;

save([prodir '/calcFeddy_batch.mat'],'EXPNAME','NE',...
    'uw_tran_eddy_shelf','uw_tran_eddy_slope','uw_tran_eddy_deep',...
    'fs_tran_eddy_shelf','fs_tran_eddy_slope','fs_tran_eddy_deep',...
    'uv_tran_eddy_shelf','uv_tran_eddy_slope','uv_tran_eddy_deep',...
    'uw_std_eddy_shelf','uw_std_eddy_slope','uw_std_eddy_deep',...
    'fs_std_eddy_shelf','fs_std_eddy_slope','fs_std_eddy_deep',...
    'uv_std_eddy_shelf','uv_std_eddy_slope','uv_std_eddy_deep');
