
%%%%%% Function called by calc_heat_along_BTStreamlines.m
%     %%% Select one streamline: e.g, -1.45 Sv
%     %%% The qualified streamlines must connect the eastern and western boundaries across the domain.
%     Sv=1e6;
%     Phi_value_estimate = -1.45*Sv;
%     find_continuousBTstreamline; 
%     %%% The code is unable to find a continuous BT streamline that accross the domain (connecting the eastern boundary 
%     %%% with the western boundary) when this streamline encounters with standing eddies. 


    %%% Find the (x,y) indices of this streamline in Psif
    nidx=1; %%% number of index along the streamline, start from the eastern boundary
    [c idx] = min(abs(Phi_value_estimate-Psif(Nxf,:)));
    Phi_value(nidx) = Psif(Nxf,idx);
    loc = [Nxf idx];

    loc(2,1) = loc(1,1)-1;
    loc(2,2) = loc(1,2);

    for n=3:Nxf*2
        xo = loc(n-1,1); %%% xidx_old
        yo = loc(n-1,2); %%% yidx_old

        if( (xo-1<1)||(yo-1<1)||(xo+1>Nxf)||(yo+1>Nyf))
            break
        end
        %%% 8 grid points around the point (xo,yo)
        loc_possible = [[xo-1 yo+1];[xo yo+1];[xo+1 yo+1];...
                        [xo-1 yo];            [xo+1 yo];...
                        [xo-1 yo-1];[xo yo-1];[xo+1 yo-1]]; 

        %%% Exclude the point loc(n-2,:)
        xoo = loc(n-2,1); yoo = loc(n-2,2);
        for k=1:8
            if((loc_possible(k,1)==xoo) && (loc_possible(k,2)==yoo))
                loc_possible(k,:)=[];
                break
            end
        end

        for k=1:7
            Psif_possible(k) = Psif(loc_possible(k,1),loc_possible(k,2));
        end
        [c idx7] = min(abs(Phi_value(1)-Psif_possible));

        nidx = nidx+1;
        Phi_value(nidx) = Psif_possible(idx7);
        loc = [loc;[loc_possible(idx7,1) loc_possible(idx7,2)]];

    end



    [YY,XX] = meshgrid(yy,xx);
    handle = figure(1);set(handle,'Position',framepos);clf;set(gcf,'color','w');
    [C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',2,'ShowText','on');clabel(C,h,'LabelSpacing',1000);
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',800);
    plot(xxf(loc(:,1))/1000,yyf(loc(:,2))/1000,'LineWidth',3); xlim([-300 300]);ylim([0 400]); hold off;
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);


    figure(2)
    plot(loc)





    % Plot and check the interpolation
    % figure();subplot(1,2,1);pcolor(VT);shading flat;colorbar;colormap(redblue);caxis([-80 80]);
    %          subplot(1,2,2);pcolor(VTf);shading flat;colorbar;colormap(redblue);caxis([-80 80]);
    % figure();subplot(1,2,1);pcolor(UT);shading flat;colorbar;colormap(redblue);caxis([-80 80]);
    %          subplot(1,2,2);pcolor(UTf);shading flat;colorbar;colormap(redblue);caxis([-80 80]);
    % figure();subplot(1,2,1);pcolor(UU);shading flat;colorbar;colormap(redblue);caxis([-180 180]);
    %          subplot(1,2,2);pcolor(UUf);shading flat;colorbar;colormap(redblue);caxis([-180 180]);

