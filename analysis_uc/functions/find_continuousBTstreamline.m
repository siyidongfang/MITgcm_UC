
%%%%%% Function called by calc_heat_along_BTStreamlines.m
%     %%% Select one streamline: e.g, -1.45 Sv
%     %%% The qualified streamlines must connect the eastern and western boundaries across the domain.
%     Sv=1e6;
%     Phi_value_estimate = -1.45*Sv;
%     find_continuousBTstreamline; 
%     %%% The code is unable to find a continuous BT streamline that accross the domain (connecting the eastern boundary 
%     %%% with the western boundary) when this streamline encounters with standing eddies. 


    useSMOOTH = false;

    %%% Find the (x,y) indices of this streamline in Psif
    nidx=1; %%% number of index along the streamline, start from the eastern boundary
    [c idx] = min(abs(Phi_value_estimate-Psif(Nxf,:)));
    Phi_value(nidx) = Psif(Nxf,idx);
    loc = [Nxf idx];

    loc(2,1) = loc(1,1)-1;
    loc(2,2) = loc(1,2);
%     loc(3,1) = loc(1,1)-2;
%     loc(3,2) = loc(1,2);
%     loc(4,1) = loc(1,1)-3;
%     loc(4,2) = loc(1,2);

    for n=3:Nxf*2
        clear Psif_possible
        xo = loc(n-1,1); %%% xidx_old
        yo = loc(n-1,2); %%% yidx_old

        if( (xo-1<1)||(yo-1<1)||(xo+1>Nxf)||(yo+1>Nyf))
            break
        end
        %%% 8 grid points around the point (xo,yo)
        loc_possible = [[xo-1 yo+1];[xo yo+1];[xo+1 yo+1];...
                        [xo-1 yo];            [xo+1 yo];...
                        [xo-1 yo-1];[xo yo-1];[xo+1 yo-1]]; 

        %%% Exclude former point loc(n-2,:)
        xoo2 = loc(n-2,1); yoo2 = loc(n-2,2);
        for k=1:length(loc_possible)
            if((loc_possible(k,1)==xoo2) && (loc_possible(k,2)==yoo2))
                loc_possible(k,:)=[];
                break
            end
        end

        %%% Exclude more former points 
        if(n>200)
            for o=n-190:n
                for k=1:length(loc_possible)
                    if((loc_possible(k,1)==loc(o-3,1)) && (loc_possible(k,2)==loc(o-3,2)))
                        loc_possible(k,:)=NaN;
                    end
                end
            end
        end

        isnanidx = ~isnan(loc_possible);
        loc_possible = reshape(loc_possible(isnanidx),sum(isnanidx(:,1)),2);


        for k=1:size(loc_possible,1)
            Psif_possible(k) = Psif(loc_possible(k,1),loc_possible(k,2));
        end

        [c idx7] = min(abs(Phi_value(1)-Psif_possible));

        nidx = nidx+1;
        Phi_value(nidx) = Psif_possible(idx7);
        loc = [loc;[loc_possible(idx7,1) loc_possible(idx7,2)]];
    end



    lon = xxf(loc(:,1))/1000; %%% in km, from the east to the west
    lat = yyf(loc(:,2))/1000; %%% in km

    [YY,XX] = meshgrid(yy,xx);
    handle = figure(1);set(handle,'Position',framepos);clf;set(gcf,'color','w');
    [C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',2,'ShowText','on');clabel(C,h,'LabelSpacing',1000);
    hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',800);
    plot(lon,lat,'LineWidth',3); xlim([-300 300]);ylim([0 400]); hold off;
    xlabel('Longitude, x (km)');
    ylabel('Latitude, y (km)');
    set(gca,'FontSize',fontsize);
    title(['Barotropic streamline \Psi = ' num2str(stfn(ns),'%.2f') ' Sv'],'FontSize',fontsize+3);
    print('-djpeg','-r200', [figdir expname '/BTstfn_' num2str(stfn(ns),'%.2f') 'Sv.jpg'])

    if(useSMOOTH)
        lat = smooth(lat,100)';
        lon = smooth(lon,100)';

        handle = figure(2);set(handle,'Position',framepos);clf;set(gcf,'color','w');
        [C,h]=contour(XX/1000,YY/1000,bathy,[-900:100:0],'k:','LineWidth',2,'ShowText','on');clabel(C,h,'LabelSpacing',1000);
        hold on;[C,h]=contour(XX/1000,YY/1000,bathy,[-4000:500:-500],'k--','LineWidth',1.5,'ShowText','on');clabel(C,h,'LabelSpacing',800);
        plot(lon,lat,'LineWidth',3); xlim([-300 300]);ylim([0 400]); hold off;
        xlabel('Longitude, x (km)');
        ylabel('Latitude, y (km)');
        set(gca,'FontSize',fontsize);
    end
    


%%% Find the angles between the x-axis and this streamline    
%%% angle>0 onshore; angle<0 offshore; 
%%% angle=0 westward; angle = 180 eastward; angle=90 southward; angle=-90 northward
%     Ns = length(loc);
%     angle = zeros(1,Ns);
%     angle(1) = 0; %%% at the eastern boundary
%     angle(Ns) =  angle(Ns-1); %%% at the western boundary
%     %%% Centered Difference Formula for calculating the angle
%     for na = 2:Ns-1
%         lat3 = lat(na+1); lon3 = lon(na+1);
%         lat1 = lat(na-1); lon1 = lon(na-1);
% 
%         tan_angle = (lat3-lat1)/(lon3-lon1);
%         angle(na) = atand(tan_angle);
% 
%         if(((lat3-lat1)>0) && ((lon3-lon1)>0))
%             angle(na) = angle(na)-180;
%         end
% 
%         if(((lat3-lat1)<0) && ((lon3-lon1)>0))
%             angle(na) = angle(na)+180;
%         end
%     end
%     
% 
%     if(useSMOOTH)
%         angle = smooth(angle,20)';
%     end
% 
%     handle = figure(5);set(handle,'Position',framepos);clf;set(gcf,'color','w');
%     plot(lon,angle,'LineWidth',3); xlim([-300 300]); ylim([-180 180]);
%     xlabel('Longitude, x (km)');
%     ylabel('Angle (degree)');grid on;
%     set(gca,'FontSize',fontsize);
%     text(100,150,'\phi > 0: shoreward','FontSize',fontsize+2);
%     text(100,130,'\phi < 0: offshore','FontSize',fontsize+2);
% 
%     title(['Angle (\phi) between the streamline \Psi = ' num2str(stfn(ns),'%.2f') ' Sv and the x-axis'],'FontSize',fontsize+3);






    % Plot and check the interpolation
    % figure();subplot(1,2,1);pcolor(VT);shading flat;colorbar;colormap(redblue);caxis([-80 80]);
    %          subplot(1,2,2);pcolor(VTf);shading flat;colorbar;colormap(redblue);caxis([-80 80]);
    % figure();subplot(1,2,1);pcolor(UT);shading flat;colorbar;colormap(redblue);caxis([-80 80]);
    %          subplot(1,2,2);pcolor(UTf);shading flat;colorbar;colormap(redblue);caxis([-80 80]);
    % figure();subplot(1,2,1);pcolor(UU);shading flat;colorbar;colormap(redblue);caxis([-180 180]);
    %          subplot(1,2,2);pcolor(UUf);shading flat;colorbar;colormap(redblue);caxis([-180 180]);

