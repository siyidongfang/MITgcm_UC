

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
        TAUx_estimate(n)=NaN;TAUy_estimate(n)=NaN;
    end
