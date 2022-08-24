

    %%% Calculate the ocean surface stress (is almost ice-ocean stress)
    uo_surf = uu(xidx,yidx,1);
    vo_surf = vv(xidx,yidx,1);
    if(is_prod_run(n))
        TAUx(n) = mean(oceTAUX(xidx,yidx),'all');
        TAUy(n) = mean(oceTAUY(xidx,yidx),'all');
    end
    if(useSEAICE)
        TAUx_estimate(n) = mean(rho_o*Cio*sqrt((ui(xidx,yidx)-uo_surf).^2+(vi(xidx,yidx)-vo_surf).^2).*(ui(xidx,yidx)-uo_surf),'all');
        TAUy_estimate(n) = mean(rho_o*Cio*sqrt((ui(xidx,yidx)-uo_surf).^2+(vi(xidx,yidx)-vo_surf).^2).*(vi(xidx,yidx)-vo_surf),'all');
    else
        if(~is_prod_run(n))
            fid = fopen(fullfile(exppath,'input','zonalWindFile.bin'),'r','b');
            tau_zonal = fread(fid,[Nx Ny],'real*8');
            fclose(fid);
            fid = fopen(fullfile(exppath,'input','meridWindFile.bin'),'r','b');
            tau_merid = fread(fid,[Nx Ny],'real*8');
            fclose(fid);
            TAUx(n) = mean(tau_zonal(xidx,yidx),'all');
            TAUy(n) = mean(tau_merid(xidx,yidx),'all');
        end
        TAUx_estimate(n)=TAUx(n);
        TAUy_estimate(n)=TAUy(n);
    end


