    
    
    if(is_prod_run(n))
        load([prodir expname '_tavg_5yrs.mat'],'THETA','SALT','UVEL','VVEL','VVELTH','UVELTH','ETAN',...
                'SHIfwFlx','oceTAUX','oceTAUY');
        tt = THETA;
        ss = SALT;
        uu = UVEL;
        vv = VVEL;
        vt = VVELTH;
        ut = UVELTH;
        eta = ETAN;
        %    rho_insitu = RHOAnoma+rhoConst;
        if(useSEAICE)
            load([prodir expname '_tavg_5yrs.mat'],'SIuice','SIvice');
            ui = SIuice;
            vi = SIvice;
        end
    else
        tt = rdmds([exppath,'/results/THETA'],nIter(n));
        ss = rdmds([exppath,'/results/SALT'],nIter(n));
        uu = rdmds([exppath,'/results/UVEL'],nIter(n));
        vv = rdmds([exppath,'/results/VVEL'],nIter(n));
        vt = rdmds([exppath,'/results/VVELTH'],nIter(n));
        ut = rdmds([exppath,'/results/UVELTH'],nIter(n));
        eta = rdmds([exppath,'/results/ETAN'],nIter(n));
        SHIfwFlx = rdmds([exppath,'/results/SHIfwFlx'],nIter(n));
        if(useSEAICE)
            ui = rdmds([exppath,'/results/SIuice'],nIter(n));
            vi = rdmds([exppath,'/results/SIvice'],nIter(n));
        end
    end