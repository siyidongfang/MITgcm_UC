%%%
%%% calcFcdw_MixingLength.m
%%%
%%% Calculate the transport of CDW from model output, and the prediction
%%% for CDW transport based on Mixing Length theory.
%%%


function [betat_test,betat,h_cdw_slopeavg,dhcdwdy_slopeavg,Fcdw_simulation,...
    Aslope_test,EKE_slope_total_test,tidalEKE_slope_test,EKE_slope_test,Ueddy_test,ls,lRh_test,ks_test,kRh_test,Fcdw_test_s,Fcdw_test_Rh,...
    Aslope,EKE_slope_total,tidalEKE_slope,EKE_slope,Ueddy_theory,lRh,ks,kRh,Fcdw_theory_s,Fcdw_theory_Rh]...
    = calcFcdw_MixingLength(expdir,expname,prodir,Ws,Ys)

%%% Load experiment data
%     loadexp;
    load([prodir 'tavg/' expname '_tavg_5yrs.mat'],'UVEL', 'VVEL', 'THETA', 'SALT','UVELSQ', 'VVELSQ');
    load([prodir 'moc/' expname '_MOC_rho_Aocean.mat'],'psi_z','xx','yy','zz');

    expname = 'ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2';
    loadexp;

    

%%% Grid spacing matrices
    DX = repmat(delX',[1 Ny Nr]);
    DY = repmat(delY,[Nx 1 Nr]);
    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    zzf = -[0 cumsum(delR)];

    Hs = 500; %%% Continental shelf depth
    dy = Ly/Ny;
    
    Yslope_begin = fix((Ys-Ws)/dy);
    Yslope_end = ceil((Ys+Ws)/dy);
    
    usq_eddy = UVELSQ-UVEL.^2;
    vsq_eddy = VVELSQ-VVEL.^2;
    EKE = 0.5 * ( 0.5 * (usq_eddy(1:Nx,:,:) + usq_eddy([2:Nx 1],:,:)) ...
                + 0.5 * (vsq_eddy(:,1:Ny,:) + vsq_eddy(:,[2:Ny 1],:)) );
    EKEDV = EKE.*DX.*DY.*DZ.*hFacC; 
    AslopeDV = DX.*DY.*DZ.*hFacC;

    cRh = 0.015; %%% Eddy transfer coefficient

    %%% Tidal KE
    Atide = 0.05;
    vt=Atide*H./abs(bathy);
    vt = repmat(reshape(vt,[Nx Ny 1]),[1 1 Nr]);
    tidalEKE_theory = 0.5.*vt.^2.*hFacC;
    tidalEKEDV = tidalEKE_theory.*DX.*DY.*DZ; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calc FCWD from LAYERS pkg %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%% Find upper and lower bounds of the CDW
    theta_CDWmin = -0.5; % the lowest temperature of the CDW
%     theta_CDWmin = 0;
    
    THETA(SALT==0)=NaN;
    theta_xavg = squeeze(nanmean(THETA));
    theta_v = NaN*theta_xavg;
    theta_v(2:Ny,:) = 0.5* (theta_xavg(1:Ny-1,:) + theta_xavg(2:Ny,:)); % v-grid   
    for j = 1:Ny
        theta_zzf(j,:) = interp1(zz,theta_v(j,:),zzf,'linear','extrap');
    end

    % figure(5)
    % subplot(1,2,1)
    % pcolor(yy/1000,-zzf/1000,theta_zzf');axis ij;shading interp;
    % hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
    % hold off;colorbar;
    % subplot(1,2,2)
    % pcolor(yy/1000,-zzf/1000,psi_z');axis ij;shading interp;
    % hold on;plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
    % hold off;colorbar;

    Nup=zeros(1,Ny);
    Nlow=zeros(1,Ny);
    psi_z_up=zeros(1,Ny);
    psi_z_low=zeros(1,Ny);
    h_cdw_up=zeros(1,Ny);
    h_cdw_low=zeros(1,Ny);

    for j=1:Ny
        if( ~isempty(find(theta_zzf(j,:)>theta_CDWmin)))
            Nup(j) = find(theta_zzf(j,:)>theta_CDWmin,1);
            Nlow(j)= find(theta_zzf(j,:)>theta_CDWmin,1,'last');

            psi_z_up(j) = psi_z(j,Nup(j));
            psi_z_low(j)= psi_z(j,Nlow(j));

            h_cdw_up(j) = zzf(Nup(j));
            h_cdw_low(j)= zzf(Nlow(j));
        end
    end

    Fcdw = psi_z_low - psi_z_up;
    h_cdw= h_cdw_up  - h_cdw_low;

    h_cdw_smoothed=smooth(smooth(h_cdw))';
    dhcdwdy = diff(h_cdw_smoothed)/dy;
    yy_mid  = 0.5*(yy(1:Ny-1)+yy(2:Ny));


    % hCDW_top_idx_simulation = sum(zz_f>-hCDW_top);
    % FCDW_simulation = -min(min((psi_z(Yslope_begin:Yslope_end,hCDW_top_idx_simulation+1:end))));


    Fcdw_simulation = mean(Fcdw(Yslope_begin:Yslope_end));
    h_cdw_slopeavg = mean(h_cdw(Yslope_begin:Yslope_end));
    dhcdwdy_slopeavg = mean(dhcdwdy(Yslope_begin:Yslope_end));



    


    
    
            
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Mixing length theory, using real h_cdw_slopeavg and dhcdwdy_slopeavg
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    betat_test = abs(f0)/h_cdw_slopeavg*dhcdwdy_slopeavg;
    Aslope_test=0;EKE_slope_total_test=0;
    tidalEKE_slope_test=0; 
    
    for jj=Yslope_begin:Yslope_end
        if (Nup(jj)==0)
        else
        Aslope_test = Aslope_test + sum(sum(AslopeDV(:,jj,Nup(jj)-1:Nlow(jj))));  %%% Total area of the slope
        EKE_slope_total_test = EKE_slope_total_test + sum(sum(EKEDV(:,jj,Nup(jj)-1:Nlow(jj)))); %%% Total EKE on the slope
        tidalEKE_slope_test = tidalEKE_slope_test + sum(sum(tidalEKEDV(:,jj,Nup(jj)-1:Nlow(jj)))); %%% Total EKE on the slope
        end
    end
        Aslope_test =Aslope_test/Lx;  %%% Total area of the slope
        EKE_slope_total_test =EKE_slope_total_test/Lx; %%% Total EKE on the slope
        tidalEKE_slope_test =tidalEKE_slope_test/Lx; %%% Total EKE on the slope
        
        
%     Aslope_test = sum(sum(sum(AslopeDV(:,Yslope_begin:Yslope_end,:))))/Lx;  %%% Total area of the slope
%     EKE_slope_test = sum(sum(sum(EKEDV(:,Yslope_begin:Yslope_end,:))))/Lx; %%% Total EKE on the slope

    EKE_slope_test = EKE_slope_total_test-tidalEKE_slope_test;
%     EKE_slope_test = EKE_slope_total_test;
    EKE_slope_test(EKE_slope_test<0)=0;
    Ueddy_test = sqrt(2/Aslope_test*EKE_slope_test);

    ls = 2*Ws;
    lRh_test = pi*sqrt(2*Ueddy_test/betat_test);

    ks_test = (1/8*cRh)*Ueddy_test*ls;
    kRh_test = (1/2*cRh)*Ueddy_test*lRh_test;

    Fcdw_test_s = ks_test*dhcdwdy_slopeavg*Lx/1e6; %%% Unit: Sv
    Fcdw_test_Rh = kRh_test*dhcdwdy_slopeavg*Lx/1e6;





%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Mixing length theory, using theoretical hCDW_theory and dhCDW_dy_theory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hCDW_theory = (H+Hs)/2;
    dhCDW_dy_theory = (H-Hs)/(2*Ws);

    hCDW_top = Hs/2; 
    hCDW_top_idx = sum(zz>-hCDW_top);
    hCDW_bot = Hs/2+hCDW_theory; 
    hCDW_bot_idx = sum(zz>-hCDW_bot);
    
    betat = abs(f0)/hCDW_theory*dhCDW_dy_theory;

    Aslope = sum(sum(sum(AslopeDV(:,Yslope_begin:Yslope_end,:))))/Lx;  %%% Total area of the slope
    EKE_slope_total = sum(sum(sum(EKEDV(:,Yslope_begin:Yslope_end,:))))/Lx; %%% Total EKE on the slope
    tidalEKE_slope = sum(sum(sum(tidalEKEDV(:,Yslope_begin:Yslope_end,:))))/Lx; %%% Total EKE on the slope

    EKE_slope = EKE_slope_total-tidalEKE_slope;
%     EKE_slope = EKE_slope_total;
    EKE_slope(EKE_slope<0)=0;
    Ueddy_theory = sqrt(2/Aslope*EKE_slope);

    lRh = pi*sqrt(2*Ueddy_theory/betat);

    ks = (1/8*cRh)*Ueddy_theory*ls;
    kRh = (1/2*cRh)*Ueddy_theory*lRh;

    Fcdw_theory_s = ks*dhCDW_dy_theory*Lx/1e6; %%% Unit: Sv
    Fcdw_theory_Rh = kRh*dhCDW_dy_theory*Lx/1e6;




%     figure(6)
%     clf;
%     subplot(3,2,1)
%     plot(yy/1000,-h_cdw_up/1000);hold on;plot(yy/1000,-h_cdw_low/1000);
%     plot(yy/1000,-bathy(1,:)/1000,'k--','LineWidth',1.5);plot(yy/1000,-bathy(25,:)/1000,'k','LineWidth',1.5);
%     hold off;axis ij;
%     ylabel('Depth (km)');xlabel('y (km)');title('Upper and lower CDW bounds')
%     subplot(3,2,2)
%     plot(yy/1000,psi_z_up);hold on;plot(yy/1000,psi_z_low);hold off;
%     ylabel('(Sv)');xlabel('y (km)');title('\psi at upper and lower CDW bounds')
%     subplot(3,2,3)
%     plot(yy/1000,h_cdw);hold on;
%     plot(yy/1000,h_cdw_smoothed);
%     scatter(Ys/1000,h_cdw_slopeavg,'r');
%     scatter(Ys/1000,hCDW_theory,'p','k');
%     hold off;
%     ylabel('h_{CDW}');xlabel('y (km)');title('CDW thickness')
%     l1 = legend('h_{CDW}','h_{CDW}, smoothed','mean h_{CDW} over the slope','h_{CDW}, theory',...
%         'Position',[0.3018 0.4301 0.1453 0.0481]);
%     subplot(3,2,4)
%     plot(yy/1000,Fcdw)
%     ylabel('F_{CDW} (Sv)');xlabel('y (km)');title('CDW flux')
%     subplot(3,2,5)
%     plot(yy_mid/1000,dhcdwdy);hold on;
%     scatter(Ys/1000,dhcdwdy_slopeavg,'r');
%     scatter(Ys/1000,dhCDW_dy_theory,'p','k');
%     hold off;
%     title('dh_{CDW}/dy');xlabel('y (km)');
%     l2 = legend('dh_{CDW}/dy','mean dh_{CDW}/dy over the slope','dh_{CDW}/dy, theory',...
%         'Position',[0.2829 0.2634 0.1711 0.0481]);
%     figureloc = '/data/MITgcm_ASF-csi/cross_slope_exchange/figures_mixinglength/';
% %     print('-dpng','-r150',[figureloc 'hCDW_' expname '_-0.5degC.png']);
%     


end
