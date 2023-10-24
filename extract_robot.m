
clear;
addpath analysis_uc
addpath analysis_uc/functions/
addpath analysis_uc/colormaps/
addpath analysis_uc/colormaps/cmocean/

expdir = '/Users/ysi/MITgcm_UC/exps_uc/seaice_boundary/';
expname = 'res2km_Ua-5Va5_Atide0.025_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_prod_Adv7_hourly'
% expname = 'res2km_Ua-5Va5_Atide0.05_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_prod_Adv7_hourly'
loadexp;

dumpFreq = 3600;
nDumps = floor(nTimeSteps*deltaT/dumpFreq);
dumpIters = round((1:nDumps)*dumpFreq/deltaT);
dumpIters = dumpIters(dumpIters > nIter0);

N = length(dumpIters);

for n=1:N
    n
    nIter = dumpIters(n)
    uu = rdmds([exppath,'/results/UVEL'],nIter);
    vv = rdmds([exppath,'/results/VVEL'],nIter);
    ww = rdmds([exppath,'/results/WVEL'],nIter);
    tt = rdmds([exppath,'/results/THETA'],nIter);
    ss = rdmds([exppath,'/results/SALT'],nIter);
    pp_anom = rdmds([exppath,'/results/PHIHYD'],nIter);

    fname = ['/Users/ysi/MITgcm_UC/HourlyOutput/WeakTides/WeakTides_mean_hour' num2str(n) '.nc'];
    nccreate(fname,"uu","Dimensions",{"x",Nx,"y",Ny,"z",Nr},"Datatype","single","Format","classic")
    nccreate(fname,"vv","Dimensions",{"x",Nx,"y",Ny,"z",Nr},"Datatype","single","Format","classic")
    nccreate(fname,"ww","Dimensions",{"x",Nx,"y",Ny,"z",Nr},"Datatype","single","Format","classic")
    nccreate(fname,"tt","Dimensions",{"x",Nx,"y",Ny,"z",Nr},"Datatype","single","Format","classic")
    nccreate(fname,"ss","Dimensions",{"x",Nx,"y",Ny,"z",Nr},"Datatype","single","Format","classic")
    nccreate(fname,"pp_anom","Dimensions",{"x",Nx,"y",Ny,"z",Nr},"Datatype","single","Format","classic")

    ncwrite(fname,"uu",uu)
    ncwrite(fname,"vv",vv)
    ncwrite(fname,"ww",ww)
    ncwrite(fname,"tt",tt)
    ncwrite(fname,"ss",ss)
    ncwrite(fname,"pp_anom",pp_anom)
end



%%


for n=1:N
    n
    nIter = dumpIters(n)
    uu = rdmds([exppath,'/results/UVEL_inst'],nIter);
    vv = rdmds([exppath,'/results/VVEL_inst'],nIter);
    ww = rdmds([exppath,'/results/WVEL_inst'],nIter);
    tt = rdmds([exppath,'/results/THETA_inst'],nIter);
    ss = rdmds([exppath,'/results/SALT_inst'],nIter);
    pp_anom = rdmds([exppath,'/results/PHIHYD_inst'],nIter);

    fname = ['/Users/ysi/MITgcm_UC/HourlyOutput/WeakTides/WeakTides_inst_hour' num2str(n) '.nc'];
    nccreate(fname,"uu","Dimensions",{"x",Nx,"y",Ny,"z",Nr},"Datatype","single","Format","classic")
    nccreate(fname,"vv","Dimensions",{"x",Nx,"y",Ny,"z",Nr},"Datatype","single","Format","classic")
    nccreate(fname,"ww","Dimensions",{"x",Nx,"y",Ny,"z",Nr},"Datatype","single","Format","classic")
    nccreate(fname,"tt","Dimensions",{"x",Nx,"y",Ny,"z",Nr},"Datatype","single","Format","classic")
    nccreate(fname,"ss","Dimensions",{"x",Nx,"y",Ny,"z",Nr},"Datatype","single","Format","classic")
    nccreate(fname,"pp_anom","Dimensions",{"x",Nx,"y",Ny,"z",Nr},"Datatype","single","Format","classic")

    ncwrite(fname,"uu",uu)
    ncwrite(fname,"vv",vv)
    ncwrite(fname,"ww",ww)
    ncwrite(fname,"tt",tt)
    ncwrite(fname,"ss",ss)
    ncwrite(fname,"pp_anom",pp_anom)
end





%%

%%% Load bathymetry and ice draft
fid = fopen(fullfile(exppath,'input','SHELFICEtopoFile.bin'),'r','b');
icedraft = fread(fid,[Nx Ny],'real*8');
fclose(fid);

fname = '/Users/ysi/MITgcm_UC/HourlyOutput/topography.nc';
nccreate(fname,"bathy","Dimensions",{"x",Nx,"y",Ny},"Datatype","single","Format","classic")
nccreate(fname,"icedraft","Dimensions",{"x",Nx,"y",Ny},"Datatype","single","Format","classic")
nccreate(fname,"xx","Dimensions",{"x",Nx},"Datatype","single","Format","classic")
nccreate(fname,"yy","Dimensions",{"y",Ny},"Datatype","single","Format","classic")
nccreate(fname,"zz","Dimensions",{"z",Nr},"Datatype","single","Format","classic")
nccreate(fname,"delX","Dimensions",{"x",Nx},"Datatype","single","Format","classic")
nccreate(fname,"delY","Dimensions",{"y",Ny},"Datatype","single","Format","classic")
nccreate(fname,"delR","Dimensions",{"z",Nr},"Datatype","single","Format","classic")
nccreate(fname,"f0","Datatype","single","Format","classic")
nccreate(fname,"beta","Datatype","single","Format","classic")
nccreate(fname,"gravity","Datatype","single","Format","classic")
nccreate(fname,"Lx","Datatype","single","Format","classic")
nccreate(fname,"Ly","Datatype","single","Format","classic")
nccreate(fname,"Nx","Datatype","single","Format","classic")
nccreate(fname,"Ny","Datatype","single","Format","classic")
nccreate(fname,"Nr","Datatype","single","Format","classic")

ncwrite(fname,"bathy",bathy)
ncwrite(fname,"icedraft",icedraft)
ncwrite(fname,"xx",xx)
ncwrite(fname,"yy",yy)
ncwrite(fname,"zz",zz)
ncwrite(fname,"delX",delX)
ncwrite(fname,"delY",delY)
ncwrite(fname,"delR",delR)
ncwrite(fname,"f0",f0)
ncwrite(fname,"beta",beta)
ncwrite(fname,"gravity",gravity)
ncwrite(fname,"Lx",Lx)
ncwrite(fname,"Ly",Ly)
ncwrite(fname,"Nx",Nx)
ncwrite(fname,"Ny",Ny)
ncwrite(fname,"Nr",Nr)

