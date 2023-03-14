

    %%% Calculate ice-shelf melt rate
    RAC = rdmds([exppath,'/results/RAC']);
    RAC (SHIfwFlx==0)=NaN;
    SHIfwFlx (SHIfwFlx==0)=NaN;
    MeltRate_Gt(ne) = -sum(SHIfwFlx.*RAC,'all','omitnan')*t1year/1e12; %%% Gt/yr
    MeltRate_m(ne) = -sum(SHIfwFlx.*RAC,'all','omitnan')*t1year/rho_i/sum(RAC,'all','omitnan'); %%% m/yr
