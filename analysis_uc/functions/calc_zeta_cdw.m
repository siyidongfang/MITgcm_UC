%%% 
%%% calc_zeta_cdw.m
%%% 
%%% Calculate and plot relative vorticty zeta of the CDW layer
%%%%%%% Vertical integral of the curl




%%% Calculate relative vorticity for all depth
vort = zeros(Nx,Ny,Nr);
vort(:,1:Ny-1,:) = - (uu(:,2:Ny,:)-uu(:,1:Ny-1,:))/dy;
vort = vort + (vv([2:Nx 1],:,:)-vv)/dx;

%%% Find the CDW layer on vorticity grid
tt(tt==0)=NaN;
tt_vgrid = zeros(Nx,Ny,Nr);   %%% v-grid
tt_vgrid(:,2:Ny,:) = (tt(:,1:Ny-1,:)+tt(:,2:Ny,:))/2; %%% v-grid
tt_vgrid(tt_vgrid==0)=NaN;

tt_vorgrid = zeros(Nx,Ny,Nr); %%% vorticity grid
tt_vorgrid(1:Nx-1,:) = (tt_vgrid(1:Nx-1,:)+ tt_vgrid(2:Nx,:))/2; % vorticity-gird
tt_vorgrid(tt_vorgrid==0)=NaN;

mask_cdw_vorgrid = NaN*zeros(Nx,Ny,Nr);
mask_cdw_vorgrid(tt_vorgrid<0)=1;

%%% Integrate zeta over the CDW layer
hFacZeta = zeros(Nx,Ny,Nr);
for i=1:Nx
    for j=1:Ny
        for k=1:Nr
            hFacZeta(i,j,k) = min([hFacW(i,j,k),hFacS(i,j,k)]);
        end
    end
end

zeta_cdw_zint = sum(mask_cdw_vorgrid.*vort.*hFacZeta.*DZ,3,'omitnan');


if(showfigure)
figure(8)
clf;set(gcf,'color','w');
pcolor(xx/1000,yy/1000,zeta_cdw_zint');
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
hold off;
shading flat;colorbar;colormap(redblue);
clim([-0.01 0.01]/2)
title('Vertically integrated relative vorticity in the CDW layer','Interpreter','latex')
set(gca,'FontSize',fontsize);
ylim([0 400]);xlim([-300 300])
yticks(0:100:400);xticks(-300:100:300)
xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Vertically interpolated version
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % mask_interpolate;
    % 
    % tt_vorgridf = zeros(Nxf,Nyf,Nrf); %%% vorticity grid
    % tt_vorgridf(1:Nxf-1,:) = (tt_vgridf(1:Nxf-1,:)+ tt_vgridf(2:Nxf,:))/2; % vorticity-gird
    % tt_vorgridf(tt_vorgridf==0)=NaN;
    % 
    % mask_cdw_vorgridf = NaN*zeros(Nxf,Nyf,Nrf);
    % mask_cdw_vorgridf(tt_vorgridf<0)=1;
    % 
    % %%% Interpolate the uu and vv onto this new grid
    % vvf = zeros(Nxf,Nyf,Nrf);
    % uuf = zeros(Nxf,Nyf,Nrf);
    % 
    % %%% Piecewise-constant interpolation for uu and vv
    % for i=1:Nx
    %     i
    %     for j=1:Ny
    %         for k=1:Nr
    %             uuf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = uu(i,j,k);
    %             vvf((i-1)*ffac+1:i*ffac,(j-1)*ffac+1:j*ffac,(k-1)*ffacZ+1:k*ffacZ) = vv(i,j,k);
    %         end
    %     end
    % end
    % 
    % %%% Calculate relative vorticity for all depth
    % vortf = zeros(Nxf,Nyf,Nrf);
    % vortf(:,1:Nyf-1,:) = - (uuf(:,2:Nyf,:)-uuf(:,1:Nyf-1,:))/dyf;
    % vortf = vortf + (vvf([2:Nxf 1],:,:)-vvf)/dxf;
    % 
    % %%% Integrate zeta over the CDW layer
    % hFacZetaf = zeros(Nxf,Nyf,Nrf);
    % for i=1:Nxf
    %     for j=1:Nyf
    %         for k=1:Nrf
    %             hFacZetaf(i,j,k) = min([hFacWf(i,j,k),hFacSf(i,j,k)]);
    %         end
    %     end
    % end
    % 
    % zeta_cdw_zintf = sum(mask_cdw_vorgridf.*vortf.*hFacZetaf.*DZf,3,'omitnan');
    % 
    % 
    % figure(7)
    % clf;set(gcf,'color','w');
    % pcolor(xxf/1000,yyf/1000,zeta_cdw_zintf');
    % hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',1,'ShowText','off');% clabel(C,h,'LabelSpacing',1000);hold off;
    % hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',0.5,'ShowText','off');% clabel(C,h,'LabelSpacing',800);hold off;
    % hold off;
    % shading flat;colorbar;colormap(redblue);
    % clim([-0.01 0.01]/2)
    % title('Vertically integrated relative vorticity in the CDW layer','Interpreter','latex')
    % set(gca,'FontSize',fontsize);
    % ylim([0 400]);xlim([-300 300])
    % yticks(0:100:400);xticks(-300:100:300)
    % xlabel('Longitude, x (km)','Interpreter','latex');ylabel('Latitude, y (km)','Interpreter','latex')






