%%%
%%% calcMomBudgetFromTendency_xint.m
%%%
%%% Convenience script to calculate the momentum budget from momentum tendency diagnostics.
%%%

rho0 = 999.8;

loadexp;
load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext',...
    'Vm_dPhiY','Vm_Advec','Vm_Diss','Vm_Ext');
% load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext',...
% 'Um_Cori','Um_%%%
%%% calcMomBudget_xy.m
%%%
%%% Convenience script to calculate the momentum budget from momentum tendency diagnostics.
%%%

rho0 = 999.8;

loadexp;
load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext',...
    'Vm_dPhiY','Vm_Advec','Vm_Diss','Vm_Ext');
% load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext',...
% 'Um_Cori','Um_AdvZ3','Um_AdvRe');

%%% Grid spacing matrices

Um_dPhiX(Um_dPhiX==0)=NaN;
Um_Advec(Um_Advec==0)=NaN;
Um_Diss(Um_Diss==0)=NaN;
Um_Ext(Um_Ext==0)=NaN;

Vm_dPhiY(Vm_dPhiY==0)=NaN;
Vm_Advec(Vm_Advec==0)=NaN;
Vm_Diss(Vm_Diss==0)=NaN;
Vm_Ext(Vm_Ext==0)=NaN;


%%% momentum tendency from Hydrostatic Pressure gradient
Um_dPhiX_zint = rho0.*sum(Um_dPhiX.*hFacW.*DZ,3,'omitnan');
Vm_dPhiX_zint = rho0.*sum(Vm_dPhiY.*hFacS.*DZ,3,'omitnan');

%%% momentum tendency from Advection terms
Um_Advec_zint = rho0.*sum(Um_Advec.*hFacW.*DZ,3,'omitnan');
Vm_Advec_zint = rho0.*sum(Vm_Advec.*hFacS.*DZ,3,'omitnan');

%%% momentum tendency from Dissipation
Um_Diss_zint = rho0.*sum(Um_Diss.*hFacW.*DZ,3,'omitnan');
Vm_Diss_zint = rho0.*sum(Vm_Diss.*hFacS.*DZ,3,'omitnan');

%%% momentum tendency from external forcing
Um_Ext_zint = rho0.*sum(Um_Ext.*hFacW.*DZ,3,'omitnan');
Vm_Ext_zint = rho0.*sum(Vm_Ext.*hFacS.*DZ,3,'omitnan');


%%% TODO: Implicit vertical viscosity tendency (Vertical Viscous Flux of U momentum (Implicit part))

% %%% U momentum tendency from Vorticity Advection
% Um_AdvZ3_xzint = rho0.*sum(sum(Um_AdvZ3(xidx,:,:).*hFacW(xidx,:,:).*DZ(xidx,:,:).*DX(xidx,:,:),3,'omitnan'),1,'omitnan');
% 
% %%% U momentum tendency from vertical Advection (Explicit part)
% Um_AdvRe_xzint = rho0.*sum(sum(Um_AdvRe(xidx,:,:).*hFacW(xidx,:,:).*DZ(xidx,:,:).*DX(xidx,:,:),3,'omitnan'),1,'omitnan');
% 
%%% momentum tendency from Coriolis term
Um_Cori_zint = rho0.*sum(Um_Cori.*hFacW.*DZ,3,'omitnan');
Vm_Cori_zint = rho0.*sum(Vm_Cori.*hFacS.*DZ,3,'omitnan');

% totalchange_tendency = Um_dPhiX_zint+Um_Advec_zint+Um_Diss_zint+Um_Ext_zint+AB_gU_zint;
totalchange_tendencyU = Um_dPhiX_zint+Um_Advec_zint+Um_Diss_zint+Um_Ext_zint;
totalchange_tendencyV = Vm_dPhiX_zint+Vm_Advec_zint+Vm_Diss_zint+Vm_Ext_zint;



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





fontsize = 18;
load_colors;
figure(1)
clf;
subplot(3,3,1)
pcolor(XX/1000,YY/1000,Um_dPhiX_zint+Um_Advec_zint)
shading flat;colorbar;colormap(redblue);
caxis([-1 1]/10);
title('Um_dPhiX_zint+Um_Advec_zint')
set(gca,'FontSize',fontsize);

subplot(3,3,2)
pcolor(XX/1000,YY/1000,Um_Advec_zint-Um_Cori_zint)
shading flat;colorbar;colormap(redblue);
title('Um_Advec_zint-Um_Cori_zint')
caxis([-1 1]/10);
set(gca,'FontSize',fontsize);

subplot(3,3,3)
pcolor(XX/1000,YY/1000,Um_Diss_zint)
shading flat;colorbar;colormap(redblue);
title('Um_Diss_zint')
caxis([-1 1]/100);
set(gca,'FontSize',fontsize);

subplot(3,3,4)
pcolor(XX/1000,YY/1000,Um_Ext_zint)
shading flat;colorbar;colormap(redblue);
title('Um_Ext_zint')
caxis([-1 1]/10);
set(gca,'FontSize',fontsize);

subplot(3,3,5)
pcolor(XX/1000,YY/1000,totalchange_tendencyU)
shading flat;colorbar;colormap(redblue);
title('totalchange_tendency')
caxis([-1 1]/1000);
set(gca,'FontSize',fontsize);

% savefigure = false;
% if(savefigure)
% print('-dpng','-r150',[figdir expname '_momentum_xy.png']);
% end




figure(2)
clf;
subplot(3,3,1)
pcolor(XX/1000,YY/1000,Vm_dPhiX_zint+Vm_Advec_zint)
shading flat;colorbar;colormap(redblue);
caxis([-1 1]/10);
title('Vm_dPhiX_zint+Vm_Advec_zint')
set(gca,'FontSize',fontsize);

subplot(3,3,2)
pcolor(XX/1000,YY/1000,Vm_Advec_zint-Vm_Cori_zint)
shading flat;colorbar;colormap(redblue);
title('Vm_Advec_zint-Vm_Cori_zint')
caxis([-1 1]/10);
set(gca,'FontSize',fontsize);

subplot(3,3,3)
pcolor(XX/1000,YY/1000,Vm_Diss_zint)
shading flat;colorbar;colormap(redblue);
title('Vm_Diss_zint')
caxis([-1 1]/100);
set(gca,'FontSize',fontsize);

subplot(3,3,4)
pcolor(XX/1000,YY/1000,Vm_Ext_zint)
shading flat;colorbar;colormap(redblue);
title('Vm_Ext_zint')
caxis([-1 1]/10);
set(gca,'FontSize',fontsize);

subplot(3,3,5)
pcolor(XX/1000,YY/1000,totalchange_tendencyV)
shading flat;colorbar;colormap(redblue);
title('totalchange_tendency')
caxis([-1 1]/1000);
set(gca,'FontSize',fontsize);


    AdvZ3','Um_AdvRe');

%%% Grid spacing matrices

Um_dPhiX(Um_dPhiX==0)=NaN;
Um_Advec(Um_Advec==0)=NaN;
Um_Diss(Um_Diss==0)=NaN;
Um_Ext(Um_Ext==0)=NaN;

Vm_dPhiY(Vm_dPhiY==0)=NaN;
Vm_Advec(Vm_Advec==0)=NaN;
Vm_Diss(Vm_Diss==0)=NaN;
Vm_Ext(Vm_Ext==0)=NaN;


%%% momentum tendency from Hydrostatic Pressure gradient
Um_dPhiX_zint = rho0.*sum(Um_dPhiX.*hFacW.*DZ,3,'omitnan');
Vm_dPhiX_zint = rho0.*sum(Vm_dPhiY.*hFacS.*DZ,3,'omitnan');

%%% momentum tendency from Advection terms
Um_Advec_zint = rho0.*sum(Um_Advec.*hFacW.*DZ,3,'omitnan');
Vm_Advec_zint = rho0.*sum(Vm_Advec.*hFacS.*DZ,3,'omitnan');

%%% momentum tendency from Dissipation
Um_Diss_zint = rho0.*sum(Um_Diss.*hFacW.*DZ,3,'omitnan');
Vm_Diss_zint = rho0.*sum(Vm_Diss.*hFacS.*DZ,3,'omitnan');

%%% momentum tendency from external forcing
Um_Ext_zint = rho0.*sum(Um_Ext.*hFacW.*DZ,3,'omitnan');
Vm_Ext_zint = rho0.*sum(Vm_Ext.*hFacS.*DZ,3,'omitnan');


%%% TODO: Implicit vertical viscosity tendency (Vertical Viscous Flux of U momentum (Implicit part))

% %%% U momentum tendency from Vorticity Advection
% Um_AdvZ3_xzint = rho0.*sum(sum(Um_AdvZ3(xidx,:,:).*hFacW(xidx,:,:).*DZ(xidx,:,:).*DX(xidx,:,:),3,'omitnan'),1,'omitnan');
% 
% %%% U momentum tendency from vertical Advection (Explicit part)
% Um_AdvRe_xzint = rho0.*sum(sum(Um_AdvRe(xidx,:,:).*hFacW(xidx,:,:).*DZ(xidx,:,:).*DX(xidx,:,:),3,'omitnan'),1,'omitnan');
% 
%%% momentum tendency from Coriolis term
Um_Cori_zint = rho0.*sum(Um_Cori.*hFacW.*DZ,3,'omitnan');
Vm_Cori_zint = rho0.*sum(Vm_Cori.*hFacS.*DZ,3,'omitnan');

% totalchange_tendency = Um_dPhiX_zint+Um_Advec_zint+Um_Diss_zint+Um_Ext_zint+AB_gU_zint;
totalchange_tendencyU = Um_dPhiX_zint+Um_Advec_zint+Um_Diss_zint+Um_Ext_zint;
totalchange_tendencyV = Vm_dPhiX_zint+Vm_Advec_zint+Vm_Diss_zint+Vm_Ext_zint;



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





fontsize = 18;
load_colors;
figure(1)
clf;
subplot(3,3,1)
pcolor(XX/1000,YY/1000,Um_dPhiX_zint+Um_Advec_zint)
shading flat;colorbar;colormap(redblue);
caxis([-1 1]/10);
title('Um_dPhiX_zint+Um_Advec_zint')
set(gca,'FontSize',fontsize);

subplot(3,3,2)
pcolor(XX/1000,YY/1000,Um_Advec_zint-Um_Cori_zint)
shading flat;colorbar;colormap(redblue);
title('Um_Advec_zint-Um_Cori_zint')
caxis([-1 1]/10);
set(gca,'FontSize',fontsize);

subplot(3,3,3)
pcolor(XX/1000,YY/1000,Um_Diss_zint)
shading flat;colorbar;colormap(redblue);
title('Um_Diss_zint')
caxis([-1 1]/100);
set(gca,'FontSize',fontsize);

subplot(3,3,4)
pcolor(XX/1000,YY/1000,Um_Ext_zint)
shading flat;colorbar;colormap(redblue);
title('Um_Ext_zint')
caxis([-1 1]/10);
set(gca,'FontSize',fontsize);

subplot(3,3,5)
pcolor(XX/1000,YY/1000,totalchange_tendencyU)
shading flat;colorbar;colormap(redblue);
title('totalchange_tendency')
caxis([-1 1]/1000);
set(gca,'FontSize',fontsize);

% savefigure = false;
% if(savefigure)
% print('-dpng','-r150',[figdir expname '_momentum_xy.png']);
% end




figure(2)
clf;
subplot(3,3,1)
pcolor(XX/1000,YY/1000,Vm_dPhiX_zint+Vm_Advec_zint)
shading flat;colorbar;colormap(redblue);
caxis([-1 1]/10);
title('Um_dPhiX_zint+Um_Advec_zint')
set(gca,'FontSize',fontsize);

subplot(3,3,2)
pcolor(XX/1000,YY/1000,Vm_Advec_zint-Vm_Cori_zint)
shading flat;colorbar;colormap(redblue);
title('Um_Advec_zint-Um_Cori_zint')
caxis([-1 1]/10);
set(gca,'FontSize',fontsize);

subplot(3,3,3)
pcolor(XX/1000,YY/1000,Vm_Diss_zint)
shading flat;colorbar;colormap(redblue);
title('Um_Diss_zint')
caxis([-1 1]/100);
set(gca,'FontSize',fontsize);

subplot(3,3,4)
pcolor(XX/1000,YY/1000,Vm_Ext_zint)
shading flat;colorbar;colormap(redblue);
title('Um_Ext_zint')
caxis([-1 1]/10);
set(gca,'FontSize',fontsize);

subplot(3,3,5)
pcolor(XX/1000,YY/1000,totalchange_tendencyV)
shading flat;colorbar;colormap(redblue);
title('totalchange_tendency')
caxis([-1 1]/1000);
set(gca,'FontSize',fontsize);


    