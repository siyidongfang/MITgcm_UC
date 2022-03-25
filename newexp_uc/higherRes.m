clear;

expdir = '/Volumes/si/MITgcm_ASF-csi/exps_cross_slope/';
expdir_lores = '/Volumes/si/MITgcm_ASF-csi/exps_cross_slope/';


EXPNAME_hires = {...
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_0dS'
    };

EXPNAME_lores = {...
       'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_0dS_init'
    };


EXPITER = [ ...
    129600
    ];

for i = 1:size(EXPNAME_hires,1)
    expname_lores = EXPNAME_lores{i}
    expname_hires = EXPNAME_hires{i}
    expiter = EXPITER(i);
   
    higherRes_3DuvtspIce (expdir_lores,expdir,expname_lores,expname_hires,expiter);
end






