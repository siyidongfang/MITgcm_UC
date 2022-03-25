clear;


addpath ../jpo_analysis-hires/
outdir = '/Users/csi/MITgcm_ASF-csi/cross_slope_exchange/figures_check_heatbudget/'
prodir = '/Volumes/si/MITgcm_ASF-csi/products_cross_slope/';
expdir = '/Volumes/si/MITgcm_ASF-csi/exps_cross_slope/';
expname = 'lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_0dS_prod'

% fname = {'High-res,','fresh-shelf,','595-day mean'}
fname = {'Low-res,','fresh-shelf,','5-year mean'}

loadexp;
load([prodir '/' expname '_tavg_5yrs.mat'],'UVEL','VVEL','WVEL','UVELSQ','VVELSQ');



%%%%%%%%%%%%%%%%%%%%%
%%% Calculate EKE %%%
%%%%%%%%%%%%%%%%%%%%%

    %%% Grid spacing matrices
    DX = repmat(delX',[1 Ny Nr]);
    DY = repmat(delY,[Nx 1 Nr]);
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    zzf = -[0 cumsum(delR)];

    
    usq_eddy = UVELSQ-UVEL.^2;
    vsq_eddy = VVELSQ-VVEL.^2;
    EKE_tides = 0.5 * ( 0.5 * (usq_eddy(1:Nx,:,:) + usq_eddy([2:Nx 1],:,:)) ...
                + 0.5 * (vsq_eddy(:,1:Ny,:) + vsq_eddy(:,[2:Ny 1],:)) );
    EKE_xavg = EKE_tides;
    EKE_xavg(EKE_xavg==0) = NaN;
    EKE_xavg = squeeze(nanmean(EKE_xavg));

 
            
            
%     expname = 'hires_Ua-6Va6_Atide0_Hi1Ai1_Ws25_analysis'
%     %%% Load experiment data
%     loadexp;
%     load([prodir expname '_tavg_5yrs.mat'],'UVEL', 'VVEL','UVELSQ', 'VVELSQ');
% 
%     
%     usq_eddy = UVELSQ-UVEL.^2;
%     vsq_eddy = VVELSQ-VVEL.^2;
%     EKE_notides = 0.5 * ( 0.5 * (usq_eddy(1:Nx,:,:) + usq_eddy([2:Nx 1],:,:)) ...
%              + 0.5 * (vsq_eddy(:,1:Ny,:) + vsq_eddy(:,[2:Ny 1],:)) );
%             
%          
%     tidalEKE_exp = EKE_tides-EKE_notides;
%     
%     tidalEKE_exp(tidalEKE_exp==0)=NaN;
%     tidalEKE_exp_xavg = squeeze(nanmean(tidalEKE_exp));
    
    %%
    
    tidalEKE_theory=zeros(Nx,Ny,Nr);
    Atide = 0.05;
    vt=Atide*H./abs(bathy);
    vt = repmat(reshape(vt,[Nx Ny 1]),[1 1 Nr]);
    tidalEKE_theory = vt.^2.*hFacS;
    tidalEKE_theory(tidalEKE_theory==0)=NaN;
    tidalEKE_theory_xavg = 0.5*squeeze(nanmean(tidalEKE_theory));
    
%     figure(1)
%     subplot(1,2,1)
%     pcolor(yy/1000,-zz/1000,tidalEKE_exp_xavg');shading interp;axis ij;colorbar;caxis([0 0.09]);colormap('jet')
%     hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(50,:)/1000,'k','LineWidth',1.5);
%     xlabel('y (km)');ylabel('Depth (km)');title('Tidal EKE (Tides - NoTides)')
%     subplot(1,2,2)
%     pcolor(yy/1000,-zz/1000,tidalEKE_theory_xavg');shading interp;axis ij;colorbar;caxis([0 0.09]);colormap('jet')
%     hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(50,:)/1000,'k','LineWidth',1.5);
%     xlabel('y (km)');ylabel('Depth (km)');title('Tidal EKE (theory)')    
    
    
    
    
    %%
fontsize = 12;

figure(3)
clf;
Tref = 0;
pcolor(yy/1000,-zz/1000,EKE_xavg'-tidalEKE_theory_xavg');shading interp;axis ij;
% colormap(cmocean('balance',100));
colormap('jet');
colorbar;
caxis([0 0.015]);
xlim([0 450])
hold on;
plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2.5);
plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2.5);
set(gca,'FontSize',fontsize)
xlabel('y (km)', 'FontSize', fontsize+2,'interpreter','latex');
ylabel('Depth (km)','FontSize', fontsize+2,'interpreter','latex');
title('Zonal mean EKE (theoretical TKE removed)','FontSize', fontsize+5,'interpreter','latex');
hold off;
annotation('textbox',[0.81 0.95 0.15 0.05],'String','($m^2/s^2$)','interpreter','latex','FontSize',fontsize+2,'LineStyle','None');
text(30,2.8,fname,'FontSize', fontsize+4,'interpreter','latex')
set(gcf,'OuterPosition',[91 155 599 411])

print('-dpng','-r150',[outdir expname '_EKEonly_2.png']);
    
    

%     print('-dpng','-r150',[figureloc 'tidalEKE_hires_reference.png']);