%%%
%%% calc_heat_along_BTStreamfunc.m
%%%
%%% Calculate heat flux along the time-mean barotropic streamfunction.
%%%

    clear;
%     close all;

    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/cmocean/;
    addpath /Users/csi/MITgcm_UC/analysis_uc/colormaps/customcolormap/;

    expdir = '/Users/csi/MITgcm_UC/exps_uc/seaice_boundary/';
    prodir = '/Users/csi/MITgcm_UC/products_uc/seaice_boundary/';
    expname = 'res2km_Ua-5Va5_Atide0_Hi1Ai1_Ws30_Hbed300Htr200_Zn350Zsb550dZs150_prod'
    loadexp;

    load([prodir '/' expname '_tavg_5yrs.mat'],'UVEL','VVELTH','UVELTH','WVELTH');
    uu = UVEL;
    vt = VVELTH;
    ut = UVELTH;
    wt = WVELTH;

    DZ = repmat(reshape(delR,[1 1 Nr]),[Nx Ny 1]);
    UU = sum(uu.*DZ.*hFacW,3); %%% u-grid
    UU(:,Ny) = 0;

    %%% Calculate depth-averaged onshore heat flux
    VT_vgrid = sum(vt.*DZ.*hFacS,3); %%% v-grid
    VT_vorgrid = zeros(Nx,Ny);  % vorticity-gird
    VT_vorgrid(1:Nx-1,:) = (VT_vgrid(1:Nx-1,:)+ VT_vgrid(2:Nx,:))/2; % vorticity-gird
    VT_vorgrid(Nx,:) = (VT_vgrid(Nx,:)+0)/2;
    VT = zeros(Nx,Ny); %%% u-grid
    VT(:,1:Ny-1) = (VT_vorgrid(:,1:Ny-1)+VT_vorgrid(:,2:Ny))/2;   
    
    UT = sum(ut.*DZ.*hFacW,3); %%% u-grid

    DRC = rdmds(fullfile(resultspath,'DRC'));
    DZC = repmat(reshape(DRC(1:end-1),[1 1 Nr]),[Nx Ny 1]);
    WT = sum(wt.*DZ.*hFacC,3); %%% mass-grid  WT is much smaller than VT

    %%% Create a finer horizontal grid
    ffac = 10;
    Nxf = ffac*Nx;
    Nyf = ffac*Ny;
    delXf = zeros(1,Nxf); 
    delYf = zeros(1,Nyf); 
    for n=1:Nx
        for m=1:ffac
            delXf((n-1)*ffac+m) = delX(n)/ffac;
        end
    end
    for n=1:Ny
        for m=1:ffac
            delYf((n-1)*ffac+m) = delY(n)/ffac;
        end
    end

    xx  = cumsum((delX +  [0 delX(1:Nx-1)])/2)  -Lx/2;
    xxf= cumsum((delXf + [0 delXf(1:Nxf-1)])/2)-Lx/2;
    
    yy  = cumsum((delY +  [0 delY(1:Ny-1)])/2);
    yyf= cumsum((delYf + [0 delYf(1:Nyf-1)])/2);

    [YY,XX] = meshgrid(yy,xx);
    [YYf,XXf] = meshgrid(yyf,xxf);
    
    %%% Interpolate streamfunction and heat flux onto this new grid
    VTf = interp2(YY,XX,VT,YYf,XXf,'linear');
    UTf = interp2(YY,XX,UT,YYf,XXf,'linear');
    UUf = interp2(YY,XX,UU,YYf,XXf,'linear');

    % Plot and check the interpolation
    % figure();subplot(1,2,1);pcolor(VT);shading flat;colorbar;colormap(redblue);caxis([-80 80]);
    %          subplot(1,2,2);pcolor(VTf);shading flat;colorbar;colormap(redblue);caxis([-80 80]);
    % figure();subplot(1,2,1);pcolor(UT);shading flat;colorbar;colormap(redblue);caxis([-80 80]);
    %          subplot(1,2,2);pcolor(UTf);shading flat;colorbar;colormap(redblue);caxis([-80 80]);
    % figure();subplot(1,2,1);pcolor(UU);shading flat;colorbar;colormap(redblue);caxis([-180 180]);
    %          subplot(1,2,2);pcolor(UUf);shading flat;colorbar;colormap(redblue);caxis([-180 180]);

    %%% Calculate the barotropic streamfunction using UUf
    Psif = flip(cumsum(flip(UUf.*delYf(1),2),2,'omitnan'),2);
    %%% Fill the zeros at the zonal boundaries
    for i = 1:find(Psif(:,1)~=0,1,'first')-1
        Psif(i,:)=Psif(find(Psif(:,1)~=0,1,'first'),:);
    end
    for i = find(Psif(:,1)~=0,1,'last'):Nxf
        Psif(i,:)=Psif(find(Psif(:,1)~=0,1,'last'),:);
    end
    %%% Plot BT streamfunction
    plot_BTStreamfunc

    %%% Calculate heat transport along the streamlines

    %%% Start a loop
%%
 
    %%% Select one streamline: Phi=-1 Sv
    Sv=1e6;
    Phi_value_estimate = -1.45*Sv;

    %%% Find the (x,y) indices of this streamline in Psif
    nidx=1; %%% number of index along the streamline, start from the eastern boundary
    [c idx] = min(abs(Phi_value_estimate-Psif(Nxf,:)));
    Phi_value(nidx) = Psif(Nxf,idx);
    loc = [Nxf idx];

%     for n = Nxf-1:-1:1 %%% Loop from east to west
%         [c idx] = min(abs(Phi_value(1)-Psif(n,:)));
%         if(abs(idx-loc(nidx,2))>1) 
%             [c idx] = min(abs(Phi_value(nidx)-Psif(n,:)));
%             if(abs(idx-loc(nidx,2))>1) 
% 
%                 if(abs(idx-loc(nidx,2))>1) 
%                     break %%% Break the loop when the y index of the streamline is non-monotonic 
%                 end
%             end
%         end
% 
%         nidx = nidx+1;
%         Phi_value(nidx) = Psif(n,idx);
%         loc = [loc;[n idx]];
%     end


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




%     Ntransient = n-1; %%% The transient point is n
%     
%     for n= Ntransient:1:Nxf %%% Restart the loop, from west to east
%         [c idx] = min(abs(Phi_value(1)-Psif(n,:)));
%         if(abs(idx-loc(nidx,2))>2)
%             break
%         end
%         nidx = nidx+1;
%         Phi_value(nidx) = Psif(n,idx);
%         loc = [loc;[n idx]];
%     end
%                 [c idx] = min(abs(Phi_value_estimate-Psif(n,:)));

%             [c idx] = min(abs(Phi_value(1)-Psif(n,[1:idx-1 idx+1:Nyf])));
%                 if(abs(idx-loc(nidx,2))>2) 
%                     break
%                 end
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
    %%% Exclude closed streamlines (the streamlines of standing eddies). 
    %%% The qualified streamlines must connect the eastern and western boundaries across the domain.

    %%% Find the corresponding values in VTf and UTf

    %%% Find the angles between x-axis and this streamline

    %%% Integrate heat flux along this streamline


    %%% End the loop





    %%% Decompose the heat transport towards the ice shelf cavity into
    %%% (1) heat carried by onshore CDW flow through the trough, and 
    %%% (2) heat carried by westward coastal boundary current along the continent





