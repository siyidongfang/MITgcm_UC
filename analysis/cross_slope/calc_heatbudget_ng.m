clear

    addpath ../jpo_analysis-hires/
    expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng';
%     expdir = '/Volumes/si/MITgcm_ASF-csi/exps_cross_slope/lowres_not_smagorinsky/';

    prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/'

    rho_o = 999.8;
    cp_o = 3994; % Unit: J/kg/degC


    m1km = 1000;
    LbandS = 50*m1km; 
    LbandN = 100*m1km; 
    
    Ln_sponge = 20*m1km;  % Northern edge of the south sponge layer
    Ln_shelf = 100*m1km;  % Northern edge of the continental shelf
    Ln_slope = 200*m1km;  % Northern edge of the continental slope
    Ls_sponge = 430*m1km; % Southeern edge of the north sponge layer

    
    
    EXPNAME = {
        'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'   
        %     'ssurf33.28_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod' 
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod' 
        'ssurf33.56_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'ssurf34.12_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'ssurf34.12_2dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        %     'ssurf34.12_2.5dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
    'ssurf34.12_2.5dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25' 
        'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        ...
        'km5_ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_noGMRedi_prod'
        'km5_ssurf33.56_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_noGMRedi_prod'
        'km5_ssurf34.12_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_noGMRedi_prod'
        'km5_ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_noGMRedi_prod'
        'km5_ssurf34.12_2dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_noGMRedi_prod'
        'km5_ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_noGMRedi_prod'
        ...
        'km5_ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'km5_ssurf33.56_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'km5_ssurf34.12_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'km5_ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'km5_ssurf34.12_2dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'km5_ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        ...
        'km10_ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_noGMRedi_prod'
        'km10_ssurf33.56_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_noGMRedi_prod'
        'km10_ssurf34.12_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_noGMRedi_prod'
        'km10_ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_noGMRedi_prod'
        'km10_ssurf34.12_2dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_noGMRedi_prod'
        'km10_ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_noGMRedi_prod'
        ...
        'km10_ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'km10_ssurf33.56_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'km10_ssurf34.12_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'km10_ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'km10_ssurf34.12_2dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'km10_ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        ...
        ...
        'ssurf33_0dS_lores_Ua-4Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        %     'ssurf33_0dS_lores_Ua-8Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        %     'ssurf33_0dS_lores_Ua-6Va4_Atide0.05_Hi1Ai1_Ws25_prod'
        %     'ssurf33_0dS_lores_Ua-6Va12_Atide0.05_Hi1Ai1_Ws25_prod'
    'ssurf33_0dS_lores_Ua-8Va6_Atide0.05_Hi1Ai1_Ws25'
    'ssurf33_0dS_lores_Ua-6Va4_Atide0.05_Hi1Ai1_Ws25'
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi0.2Ai1_Ws25_prod'
        %     'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1.8Ai1_Ws25_prod'
        %     'ssurf33_0dS_lores_Ua-6Va6_Atide0_Hi1Ai1_Ws25_prod'
    'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1.8Ai1_Ws25'
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        %     'ssurf33_0dS_lores_Ua-6Va6_Atide0.1_Hi1Ai1_Ws25_prod'
        %     'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws12.5_prod'
        %     'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws50_prod'
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        ...
        ...
        'ssurf34.12_1dS_lores_Ua-4Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        %     'ssurf34.12_1dS_lores_Ua-8Va6_Atide0.05_Hi1Ai1_Ws25_prod'
    'ssurf34.12_1dS_lores_Ua-8Va6_Atide0.05_Hi1Ai1_Ws25'
        'ssurf34.12_1dS_lores_Ua-6Va4_Atide0.05_Hi1Ai1_Ws25_prod'
        'ssurf34.12_1dS_lores_Ua-6Va12_Atide0.05_Hi1Ai1_Ws25_prod'
        'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi0.2Ai1_Ws25_prod'
        'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1.8Ai1_Ws25_prod'
        'ssurf34.12_1dS_lores_Ua-6Va6_Atide0_Hi1Ai1_Ws25_prod'
        %     'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.1_Hi1Ai1_Ws25_prod'
        %     'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws12.5_prod'
    'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.1_Hi1Ai1_Ws25'
    'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws12.5'
        'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws50_prod'
        ...
        ...
        'ssurf34.12_3dS_lores_Ua-4Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        %     'ssurf34.12_3dS_lores_Ua-8Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        %     'ssurf34.12_3dS_lores_Ua-6Va4_Atide0.05_Hi1Ai1_Ws25_prod'
        %     'ssurf34.12_3dS_lores_Ua-6Va12_Atide0.05_Hi1Ai1_Ws25_prod'
    'ssurf34.12_3dS_lores_Ua-8Va6_Atide0.05_Hi1Ai1_Ws25'
    'ssurf34.12_3dS_lores_Ua-6Va4_Atide0.05_Hi1Ai1_Ws25'
    'ssurf34.12_3dS_lores_Ua-6Va12_Atide0.05_Hi1Ai1_Ws25'
        'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi0.2Ai1_Ws25_prod'
        %     'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1.8Ai1_Ws25_prod'
        %     'ssurf34.12_3dS_lores_Ua-6Va6_Atide0_Hi1Ai1_Ws25_prod'
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
    'ssurf34.12_3dS_lores_Ua-6Va6_Atide0_Hi1Ai1_Ws25'
        'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.1_Hi1Ai1_Ws25_prod'
        %     'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws12.5_prod'
    'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws12.5'
        'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws50_prod'
        ...
'ssurf33_33.01_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25' 
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_Ttide24h'
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_TtideReal'
'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_Ttide24h'
'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_TtideReal'
'GMk10_km10_ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk10_km10_ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk10_km10_ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk50_km10_ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk50_km10_ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk50_km10_ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk500_km10_ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk500_km10_ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk500_km10_ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk1e3_km10_ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk1e3_km10_ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk1e3_km10_ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk100s0.4_km10_ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk100s0.4_km10_ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk100s0.4_km10_ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk100s10_km10_ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk100s10_km10_ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk100s10_km10_ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk10s0.4_km10_ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk10s0.4_km10_ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk10s0.4_km10_ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk10s10_km10_ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk10s10_km10_ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'GMk10s10_km10_ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
'ssurf32.9_33_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25'
        };

 nEXP = length(EXPNAME);

 
 Fheat_adv = size(nEXP,225);
 Fheat_vvelth = size(nEXP,225); 
 Fmean_vgrid_xzint = size(nEXP,225); 
 Fmean_massgrid_xzint = size(nEXP,225); 
 Feddy_adv_xzint = size(nEXP,225); 
 Feddy_vvelth_xzint = size(nEXP,225); 

for ne = nEXP-24:nEXP
    
        clear  ADVy_TH TFLUX TOTTTEND VVELTH VVEL THETA

        expname = EXPNAME{ne}
        loadexp;
        
        Fmean_vgrid = zeros(Nx,Ny,Nr);
        Fmean_massgrid = zeros(Nx,Ny,Nr);
 
        load([prodir expname '_tavg_10yrs.mat'],'TFLUX','ADVy_TH','TOTTTEND','VVELTH','VVEL','THETA');

        dy = delY(1);        
        DX_xyz = repmat(reshape(delX,[Nx 1 1]),[1 Ny Nr]);
        DY_xyz = repmat(reshape(delY,[1 Ny 1]),[Nx 1 Nr]);
        DZ_xyz = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);

        Fmean_vgrid(:,2:Ny,:) = 0.5*(THETA(:,1:Ny-1,:)+THETA(:,2:Ny,:)).*VVEL(:,2:Ny,:);
        Fmean_vgrid_xzint(ne,1:Ny) = sum(sum(Fmean_vgrid.*hFacS.*DZ_xyz.*DX_xyz,3),1)/1e12;
        
        Fmean_massgrid(:,1:Ny-1,:) = 0.5*(VVEL(:,1:Ny-1,:)+VVEL(:,2:Ny,:)).*THETA(:,1:Ny-1,:);
        Fmean_massgrid_xzint(ne,1:Ny) = sum(sum(Fmean_massgrid.*hFacC.*DZ_xyz.*DX_xyz,3),1)/1e12;
        
        Fheat_vvelth(ne,1:Ny) = squeeze(sum(sum(VVELTH.*delX(1).*DZ_xyz.*hFacS,3)))/1e12;%%% Zonally averaged, depth-integrated 
        Feddy_vvelth_xzint(ne,1:Ny) = Fheat_vvelth(ne,1:Ny)-Fmean_vgrid_xzint(ne,1:Ny);

        TFLUX = TFLUX(:,:,1);

        yidx_band = round(LbandS/dy)+1:round(LbandN/dy); 
        yidx_shelf = round(Ln_sponge/dy)+1:round(Ln_shelf/dy); 
        yidx_slope = round(Ln_shelf/dy)+1:round(Ln_slope/dy);
        yidx_deep  = round(Ln_slope/dy)+1:round(Ls_sponge/dy);

        ADVy_int = cp_o*rho_o*sum(sum(ADVy_TH,3))/1e12; % Unit: 1e12 W
        

        Fheat_adv(ne,1:Ny) = ADVy_int;
        Feddy_adv_xzint(ne,1:Ny) = Fheat_adv(ne,1:Ny)-Fmean_massgrid_xzint(ne,1:Ny);
        
        
        F_band(ne) = mean(ADVy_int(yidx_band)); 
        
        F_cavity(ne) = ADVy_int(yidx_shelf(1)); 
        F_shelf(ne) = ADVy_int(yidx_slope(1)); 
        F_slope(ne) = ADVy_int(yidx_deep(1)); 
        F_north(ne)   = ADVy_int(yidx_deep(end)); 
                      
        Fio_shelf(ne) = sum(sum(TFLUX(yidx_shelf)*delX(1))*delY(1))/1e12;
        Fio_slope(ne) = sum(sum(TFLUX(yidx_slope)*delX(1))*delY(1))/1e12;
        Fio_deep(ne)  = sum(sum(TFLUX(yidx_deep)*delX(1))*delY(1))/1e12; 
        
        Ttend =  TOTTTEND/86400; 
        Ttend_int = cp_o*rho_o*sum(sum(Ttend.*DZ_xyz.*hFacC,3)*delX(1));
        Ttend_shelf(ne) = sum(Ttend_int(yidx_shelf)*delY(1))/1e12;
        Ttend_slope(ne) = sum(Ttend_int(yidx_slope)*delY(1))/1e12;
        Ttend_deep(ne) = sum(Ttend_int(yidx_deep)*delY(1))/1e12;
         
end      
      
%%

F_band([2 36 39:42 58])=NaN;
for jjj=1:225
    Fheat_adv([2 36 39:42 58],jjj)=NaN;
end

save([prodir,'heatbudget_50km-100km_checkGM-Redi.mat'],'EXPNAME','cp_o','rho_o',...
    'Fheat_adv','Fheat_vvelth','Fmean_vgrid_xzint','Fmean_massgrid_xzint','Feddy_adv_xzint','Feddy_vvelth_xzint',...
    'Ln_sponge','Ln_shelf','Ln_slope','Ls_sponge','LbandS','LbandN',...  
    'Fio_shelf','Fio_slope','Fio_deep',...
    'Ttend_shelf','Ttend_slope','Ttend_deep',...
    'F_cavity','F_shelf','F_slope','F_north','F_band'...
  );

        
%         %%
%         fontsize = 14;
%         gray = [175 175 175]/255;
%         
%         depth_ssponge = -bathy(25,yidx_shelf(1))/1000;
%         depth_shelf_slope = -bathy(25,yidx_slope(1))/1000;
%         depth_slope_deep = -bathy(25,yidx_deep(1))/1000;
%         
%         figure(1)
%         clf;
%         plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',2.5);hold on;
%         plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',2.5);
%         axis ij;
%         xlim([0 450]);ylim([0 4])
%         xlabel('y (km)', 'FontSize', fontsize+2);
%         ylabel('Depth (km)','FontSize', fontsize+2);
%         set(gca,'FontSize',fontsize)
%         line([430 430],[0 4],'Color',gray,'LineStyle',':','LineWidth',2);  
%         line([20 20],[0 depth_ssponge],'Color',gray,'LineStyle',':','LineWidth',2);
%         line([Ln_shelf/m1km Ln_shelf/m1km],[0 depth_shelf_slope],'Color',gray,'LineStyle',':','LineWidth',2);
%         line([Ln_slope/m1km Ln_slope/m1km],[0 depth_slope_deep],'Color',gray,'LineStyle',':','LineWidth',2);
%         set(gca,'XTick',[0:100:450]);
%         set(gca,'YTick',[0 1 2 3 4]);
%         set(gcf,'Position',[70 270 680 395]);
% %         print('-dpng','-r150',[outdir 'bathymetry.png']);        

