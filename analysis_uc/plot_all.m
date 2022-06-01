%%%
%%% plot_all.m
%%%
%%% A convenient script to make plots for all simulations


    clear;close all;

    %%% Add path
    addpath functions;
    addpath colormaps;
    addpath colormaps/cmocean/;
    

    %%% List of experiments
    expdir = '/Users/csi/MITgcm_UC/experiments/shelfice_obcsE_orlanskiW/';
    EXPNAME = {'res2km_Ua-5Va5_Atide0_Hi0Ai0_Ws30_CDWflatBot-tiltSurf_OBbalanceFacN-1_ardbeg'...
        };

    NITER = [556518 ];
    YEAR = num2str([ ]);

    useSHELFICE = true;
    useSEAICE = false;

    for nn = 1:Nexp

        expname = EXPNAME{nn}
        nIter = NITER(nn);
        year = YEAR{nn};
        loadexp;

        %%% Make plots!!
        plot_KE_EKE_T_S_series
        plot_basics
    
        if(useSHELFICE)
            plot_shelfIce
        end
    
        if(useSEAICE)
            plot_seaice
        end

    end