    %%%
    %%% calcMomBudget_uc_xint.m
    %%%
    %%% Convenience script to calculate the momentum budget from momentum tendency diagnostics.
    %%%
    
    %%%% Calculate the isopycnal form stress!!!
    
    rho0 = rhoConst;
    load([prodir '/' expname '_tavg_5yrs.mat'],'Um_dPhiX','Um_Advec','Um_Diss','Um_Ext','UVEL');
    

    %%% Find (x,y,z) indices for the undercurrent
    uu_slope = uu(xidx,yidx,zidx);
    mask_uc = zeros(length(xidx),length(yidx),length(zidx)); %%% mask of the undercurrent
    mask_uc(uu_slope>0)=1;

   
    Um_dPhiX(Um_dPhiX==0)=NaN;
    Um_Advec(Um_Advec==0)=NaN;
    Um_Diss(Um_Diss==0)=NaN;
    Um_Ext(Um_Ext==0)=NaN;
    
    
    %%% U momentum tendency from Hydrostatic Pressure gradient
    Um_dPhiX_xint = squeeze(rho0.*sum(mask_uc.*Um_dPhiX(xidx,yidx,zidx).*DX(xidx,yidx,zidx),1,'omitnan'));
    Um_dPhiX_xzint = rho0.*sum(sum(mask_uc.*Um_dPhiX(xidx,yidx,zidx).*hFacW(xidx,yidx,zidx).*DZ(xidx,yidx,zidx).*DX(xidx,yidx,zidx),3,'omitnan'),1,'omitnan');
    
    %%% U momentum tendency from Advection terms
    Um_Advec_xint = squeeze(rho0.*sum(mask_uc.*Um_Advec(xidx,yidx,zidx).*DX(xidx,yidx,zidx),1,'omitnan'));
    Um_Advec_xzint = rho0.*sum(sum(mask_uc.*Um_Advec(xidx,yidx,zidx).*hFacW(xidx,yidx,zidx).*DZ(xidx,yidx,zidx).*DX(xidx,yidx,zidx),3,'omitnan'),1,'omitnan');
    
    %%% U momentum tendency from Dissipation
    Um_Diss_xzint = rho0.*sum(sum(mask_uc.*Um_Diss(xidx,yidx,zidx).*hFacW(xidx,yidx,zidx).*DZ(xidx,yidx,zidx).*DX(xidx,yidx,zidx),3,'omitnan'),1,'omitnan');
    
    %%% U momentum tendency from external forcing
    Um_Ext_xzint = rho0.*sum(sum(mask_uc.*Um_Ext(xidx,yidx,zidx).*hFacW(xidx,yidx,zidx).*DZ(xidx,yidx,zidx).*DX(xidx,yidx,zidx),3,'omitnan'),1,'omitnan');
      
    totalchange_tendency = Um_dPhiX_xzint+Um_Advec_xzint+Um_Diss_xzint+Um_Ext_xzint;



    
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
    
        windStress_xint = sum(zonalWind(xidx,yidx).*DX_xy(xidx,yidx),1);
    
        length_int = sum(DX_xy(xidx,1),1);
    
        

   
    %%%% Plot the isopycnal form stress!!!
    load_colors;
    
    yup = 0.05;
    ydown = -0.05;  
    subplotsize = [0.4 0.6];

    %%% All the momentum budget terms
    figure(3)
    clf;  
    set(gcf,'Position',[83 183 1100 600]);
    ax1 = subplot('position',[0.08 0.3 subplotsize]);

    l0 = plot(yy(yidx)/1000,-totalchange_tendency/length_int,'LineWidth',4,'color',[0.7 0.7 0.7]);
    hold on;
    l2 = plot(yy(yidx)/1000,Um_Ext_xzint/length_int,'LineWidth',2,'Color',brown);
    l3 = plot(yy(yidx)/1000,Um_Advec_xzint/length_int,'LineWidth',2,'Color',green);
    l4 = plot(yy(yidx)/1000,Um_dPhiX_xzint/length_int,'LineWidth',2,'Color',yellow);
    l5 = plot(yy(yidx)/1000,Um_Diss_xzint/length_int,'LineWidth',2,'Color',purple);
    l20 = plot(yy(yidx)/1000,zeros(1,size(yy(yidx),2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
    line([Ycoast/m1km Ycoast/m1km],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Yshelfbreak/m1km Yshelfbreak/m1km],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Ydeep/m1km Ydeep/m1km],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    hold off;
    set(gca,'fontsize',fontsize);
    xlim([Ymin Ymax]/m1km)
    ylim([ydown yup]);
    ylabel('(N/m$^2$)', 'FontSize', fontsize,'interpreter','latex');
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    grid on;grid minor;
    title('Undercurrent zonal force balance','FontSize',fontsize+2,'interpreter','latex');
    leg1 = legend([l2 l3 l4 l5 l0],...
        'Ice-ocean stress',...
        'Ocean advection',...
        'Pressure gradient force',...
        'Bottom frictional stress',...
        'Residual term', 'FontSize', fontsize-1,'interpreter','latex');
    set(leg1,'position', [0.1736 0.0305 0.1873 0.1700])
    legend boxon;


    %%% All the ageostrophic momentum budget terms
    ax2 = subplot('position',[0.58 0.3 subplotsize]);
    l0 = plot(yy(yidx)/1000,-totalchange_tendency/length_int,'LineWidth',4,'color',[0.7 0.7 0.7]);
    hold on;
    l1 = plot(yy(yidx)/1000,Um_Ext_xzint/length_int,'LineWidth',2,'Color',brown);
    l2 = plot(yy(yidx)/1000,Um_Diss_xzint/length_int,'LineWidth',2,'Color',purple);
    l3 = plot(yy(yidx)/1000,(Um_dPhiX_xzint+Um_Advec_xzint)/length_int,'LineWidth',2,'Color',green);
    l20 = plot(yy(yidx)/1000,zeros(1,size(yy(yidx),2)),':','LineWidth',0.5,'color',[0.5 0.5 0.5]);
    line([Ycoast/m1km Ycoast/m1km],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Yshelfbreak/m1km Yshelfbreak/m1km],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    line([Ydeep/m1km Ydeep/m1km],[ydown yup],'Color',[0.5 0.5 0.5],'LineStyle',':','LineWidth',0.5);
    hold off;
    set(gca,'fontsize',fontsize);
    xlim([Ymin Ymax]/m1km)
    ylim([ydown yup]/5);
    ylabel('(N/m$^2$)', 'FontSize', fontsize,'interpreter','latex');
    xlabel('Latitude, y (km)', 'FontSize', fontsize+1,'interpreter','latex');
    grid on;grid minor;
    title('Undercurrent ageostrophic zonal force balance','FontSize',fontsize+2,'interpreter','latex');
    leg2 = legend([l1 l2 l3 l0],...
        'Ice-ocean stress',...
        'Bottom frictional stress',...
        'PGF+Advection',...
        'Residual term', 'FontSize', fontsize-1,'interpreter','latex');
    set(leg2,'position', [0.6791 0.0569 0.1873 0.1372])
    legend boxon;

    if(savefigure)
    print('-dpng','-r150',[figdir expname '/uc_mom_xint.png']);
    end




