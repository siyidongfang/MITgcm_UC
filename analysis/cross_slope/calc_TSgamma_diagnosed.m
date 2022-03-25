%%%%%
%%%%% Calculate the diagnosed T, S, and gamma_n (neutral density), compared
%%%%% with the imposed T, S, and gamma_n
%%%%%

clear

    addpath ../jpo_analysis-hires/
    expdir = '/Volumes/si/MITgcm_ASF-csi/exps_ng';

    prodir = '/Volumes/si/MITgcm_ASF-csi/products_ng/';
    
    
    m1km = 1000;
    
    Ln_imposed = 0*m1km;
    Ln_diagnosed = 20*m1km;
    Ls_diagnosed = 430*m1km;
    Ls_imposed = 450*m1km;

 NANidx = [2 7 34:36 38:42 44 50:51 54:56 58:59 61]

    EXPNAME = {
        'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'   
        %     'ssurf33.28_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod' 
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'  
        'ssurf33.56_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'ssurf34.12_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'ssurf34.12_2dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        %     'ssurf34.12_2.5dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'  
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
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'  
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'  
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'  
        'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi0.2Ai1_Ws25_prod'
        %     'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1.8Ai1_Ws25_prod'
        %     'ssurf33_0dS_lores_Ua-6Va6_Atide0_Hi1Ai1_Ws25_prod'
        %     'ssurf33_0dS_lores_Ua-6Va6_Atide0.1_Hi1Ai1_Ws25_prod'
        %     'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws12.5_prod'
        %     'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws50_prod'
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'  
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'  
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod' 
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'  
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod' 
        ...
        ...
        'ssurf34.12_1dS_lores_Ua-4Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        %     'ssurf34.12_1dS_lores_Ua-8Va6_Atide0.05_Hi1Ai1_Ws25_prod'
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'       
        'ssurf34.12_1dS_lores_Ua-6Va4_Atide0.05_Hi1Ai1_Ws25_prod'
        'ssurf34.12_1dS_lores_Ua-6Va12_Atide0.05_Hi1Ai1_Ws25_prod'
        'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi0.2Ai1_Ws25_prod'
        'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1.8Ai1_Ws25_prod'
        'ssurf34.12_1dS_lores_Ua-6Va6_Atide0_Hi1Ai1_Ws25_prod'
        %     'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.1_Hi1Ai1_Ws25_prod'
        %     'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws12.5_prod'
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'  
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod' 
        'ssurf34.12_1dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws50_prod'
        ...
        ...
        'ssurf34.12_3dS_lores_Ua-4Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        %     'ssurf34.12_3dS_lores_Ua-8Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        %     'ssurf34.12_3dS_lores_Ua-6Va4_Atide0.05_Hi1Ai1_Ws25_prod'
        %     'ssurf34.12_3dS_lores_Ua-6Va12_Atide0.05_Hi1Ai1_Ws25_prod'
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod' 
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'  
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod' 
        'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi0.2Ai1_Ws25_prod'
        %     'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1.8Ai1_Ws25_prod'
        %     'ssurf34.12_3dS_lores_Ua-6Va6_Atide0_Hi1Ai1_Ws25_prod'
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'  
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.1_Hi1Ai1_Ws25_prod'
        %     'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws12.5_prod'
'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_prod'
        'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws50_prod'
        ...
% 'ssurf33_33.01_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25' 
% 'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_Ttide24h'
% 'ssurf33_0dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_TtideReal'
% 'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_Ttide24h'
% 'ssurf34.12_3dS_lores_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_TtideReal'
        };

 nEXP = length(EXPNAME);
 

 
 for ne = 1:nEXP
    
        clear SALT THETA gamma_n

        expname = EXPNAME{ne}
        loadexp;
    
        load([prodir expname '_tavg_10yrs.mat'],'SALT','THETA');
        load([prodir expname '_gamma_n.mat']);
        
        dy = delY(1); 
        yn_imposed = round(Ln_imposed/dy)+1; %1
        yn_diagnosed = round(Ln_diagnosed/dy)+1; 
        ys_diagnosed = round(Ls_diagnosed/dy);
        ys_imposed = round(Ls_imposed/dy); %Ny
  
        Nz_shelf = 31;
        
        Ssouth_imposed(ne)=mean(SALT(:,yn_imposed,Nz_shelf));
        Snorth_imposed(ne)=mean(SALT(:,ys_imposed,Nz_shelf));
        Sdiff_imposed(ne)=Snorth_imposed(ne)-Ssouth_imposed(ne);
        
        Tsouth_imposed(ne)=mean(THETA(:,yn_imposed,Nz_shelf));
        Tnorth_imposed(ne)=mean(THETA(:,ys_imposed,Nz_shelf));
        Tdiff_imposed(ne)=Tnorth_imposed(ne)-Tsouth_imposed(ne);
        
        GAMMAsouth_imposed(ne)=mean(gamma_n(:,yn_imposed,Nz_shelf));
        GAMMAnorth_imposed(ne)=mean(gamma_n(:,ys_imposed,Nz_shelf));
        GAMMAdiff_imposed(ne)=GAMMAnorth_imposed(ne)-GAMMAsouth_imposed(ne);
        
        Ssouth_diagnosed(ne)=mean(SALT(:,yn_diagnosed,Nz_shelf));
        Snorth_diagnosed(ne)=mean(SALT(:,ys_diagnosed,Nz_shelf));
        Sdiff_diagnosed(ne)=Snorth_diagnosed(ne)-Ssouth_diagnosed(ne);
        
        Tsouth_diagnosed(ne)=mean(THETA(:,yn_diagnosed,Nz_shelf));
        Tnorth_diagnosed(ne)=mean(THETA(:,ys_diagnosed,Nz_shelf));
        Tdiff_diagnosed(ne)=Tnorth_diagnosed(ne)-Tsouth_diagnosed(ne);
           
        GAMMAsouth_diagnosed(ne)=mean(gamma_n(:,yn_diagnosed,Nz_shelf));
        GAMMAnorth_diagnosed(ne)=mean(gamma_n(:,ys_diagnosed,Nz_shelf));
        GAMMAdiff_diagnosed(ne)=GAMMAnorth_diagnosed(ne)-GAMMAsouth_diagnosed(ne);

 end
 
 
        Ssouth_imposed(NANidx)=NaN;
        Snorth_imposed(NANidx)=NaN;
        Sdiff_imposed(NANidx)=NaN;
        
        Tsouth_imposed(NANidx)=NaN;
        Tnorth_imposed(NANidx)=NaN;
        Tdiff_imposed(NANidx)=NaN;
        
        GAMMAsouth_imposed(NANidx)=NaN;
        GAMMAnorth_imposed(NANidx)=NaN;
        GAMMAdiff_imposed(NANidx)=NaN;
        
        Ssouth_diagnosed(NANidx)=NaN;
        Snorth_diagnosed(NANidx)=NaN;
        Sdiff_diagnosed(NANidx)=NaN;
        
        Tsouth_diagnosed(NANidx)=NaN;
        Tnorth_diagnosed(NANidx)=NaN;
        Tdiff_diagnosed(NANidx)=NaN;
           
        GAMMAsouth_diagnosed(NANidx)=NaN;
        GAMMAnorth_diagnosed(NANidx)=NaN;
        GAMMAdiff_diagnosed(NANidx)=NaN;
 
 
 save([prodir,'TSgamma_diagnosed.mat'],'EXPNAME',...
     'Ln_imposed','Ln_diagnosed','Ls_diagnosed','Ls_imposed','Nz_shelf',...
     'Ssouth_imposed','Snorth_imposed','Sdiff_imposed',...
     'Tsouth_imposed','Tnorth_imposed','Tdiff_imposed',...
     'GAMMAsouth_imposed','GAMMAnorth_imposed','GAMMAdiff_imposed',...
     'Ssouth_diagnosed','Snorth_diagnosed','Sdiff_diagnosed',...
     'Tsouth_diagnosed','Tnorth_diagnosed','Tdiff_diagnosed',...
     'GAMMAsouth_diagnosed','GAMMAnorth_diagnosed','GAMMAdiff_diagnosed'...    
  );


