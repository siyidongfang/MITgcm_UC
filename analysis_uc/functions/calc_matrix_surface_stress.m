

    %%% Calculate the ocean surface stress (is almost ice-ocean stress)
    uo_surf = uu(xidx,yidx,1);
    vo_surf = vv(xidx,yidx,1);
    if(is_prod_run(ne))
        TAUx(ne) = mean(oceTAUX(xidx,yidx),'all');
        TAUy(ne) = mean(oceTAUY(xidx,yidx),'all');
    end
    if(useSEAICE)
        TAUx_estimate(ne) = mean(rho_o*Cio*sqrt((ui(xidx,yidx)-uo_surf).^2+(vi(xidx,yidx)-vo_surf).^2).*(ui(xidx,yidx)-uo_surf),'all');
        TAUy_estimate(ne) = mean(rho_o*Cio*sqrt((ui(xidx,yidx)-uo_surf).^2+(vi(xidx,yidx)-vo_surf).^2).*(vi(xidx,yidx)-vo_surf),'all');
    else
        if(~is_prod_run(ne))
            fid = fopen(fullfile(exppath,'input','zonalWindFile.bin'),'r','b');
            tau_zonal = fread(fid,[Nx Ny],'real*8');
            fclose(fid);
            fid = fopen(fullfile(exppath,'input','meridWindFile.bin'),'r','b');
            tau_merid = fread(fid,[Nx Ny],'real*8');
            fclose(fid);
            TAUx(ne) = mean(tau_zonal(xidx,yidx),'all');
            TAUy(ne) = mean(tau_merid(xidx,yidx),'all');
        end
        TAUx_estimate(ne)=TAUx(ne);
        TAUy_estimate(ne)=TAUy(ne);
    end


