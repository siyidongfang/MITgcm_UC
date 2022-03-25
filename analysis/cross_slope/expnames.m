expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments';
prodir = '/data/MITgcm_ASF-csi/products-hires'

EXPNAME = {
    'hires_Ua-6Va6_Atide0_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.025_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.075_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.1_Hi1Ai1_Ws25_analysis'

    'hires_Ua0Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-4Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-8Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    
    'hires_Ua-6Va4_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va8_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va12_Atide0.05_Hi1Ai1_Ws25_analysis'
    
    'hires_Ua-6Va6_Atide0.05_Hi0.2Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi0.6Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1.4Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1.8Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi2.2Ai1_Ws25_analysis'
    
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws50_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws75_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws100_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws125_analysis'
    
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33.59_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff1_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff2_analysis'
    'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_analysis'
};




if ne==4 % 'hires_Ua-6Va6_Atide0.1_Hi1Ai1_Ws25_analysis' 
    dumpIters = [124200 248400 372600 496800 621000 648000 756000 864000 972000 ...
        1080000 1188000 1296000 1404000 1512000 1620000 1728000 1836000 1944000];
    nDumps = length(dumpIters)
elseif ne==5 % 'hires_Ua0Va6_Atide0.05_Hi1Ai1_Ws25_analysis'
    dumpIters = [123552 247104 370656 494208 617760 741312 864864 988416 ...
        1111968 1235520 1359072];
    nDumps = length(dumpIters)
elseif ne==8 % 'hires_Ua-6Va8_Atide0.05_Hi1Ai1_Ws25_analysis'
    dumpIters = [116640 233280 349920 466560];
    nDumps = length(dumpIters)
elseif ne==11 % 'hires_Ua-6Va6_Atide0.05_Hi0.6Ai1_Ws25_analysis'
    dumpIters = [121824 233280 349920 466560 583200 699840 816480 933120 ...
        1049760 1166400 1283040 1399680 1516320];
    nDumps = length(dumpIters)
elseif ne==16 % 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws75_analysis'
    dumpIters = [121824 233280 349920 466560 583200 699840 816480 933120 ...
        1049760 1166400 1283040 1399680 1516320];
    nDumps = length(dumpIters)
end






% : No layer output
%%% : need to calculate MOC
  
  ['ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2'
  'ws3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws75_lores2' 
  'ws5_Ua-6Va6_Atide0.05_Hi0Ai0_Ws125_lores2'
%   'res-ws1NewSuvice2_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores5'
%   'res3_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores10'
  ...
  ...
  'ssurf33_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
  'ssurf33.5868_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws25'
  'den02uniformS_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Ws2'
  'sdiff2_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25' 
  'sdiff2.5_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
  'sdiff3_Ua-6Va6atide0.05Hi1Ai1_2kmNr30NWs25'
  ...
  ...
  
  ...
  'fresh02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
  'fresh02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
%   'fresh02-td4_atide0.075Umax1.5Ua-6Va6Hi1Ai1_2kmNr30Ws25'
% % %   'fresh02-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
  'fresh02-td3umax2_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
% % %   'fresh02-td5_atide0.125Umax1.75Ua-6Va6Hi1Ai1_2kmNr30Ws25'
  ...
  'fresh02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  'fresh02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  'fresh02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
%   'fresh02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  ...
% % %   'fresh02-ice5_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Ws25-NewSuviceLWDOWN'
  'fresh02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
  'fresh02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
% % %   'fresh02-ice4_Hi1.8Ai1Ua-6Va6atide0.05_2kmNr30Ws25-NewSuviceLWDOWN'
  ...
% % %   'fresh02-bumps4depth600-Hi1Ai1Ua-6Va6atide0.05_2kmNr30Ws25-NewSuvice'
% % %   'fresh02-bumps8depth300-Hi1Ai1Ua-6Va6atide0.05_2kmNr30Ws25-NewSuvice'
  ...
  ...
  ...
  'den02-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
  'den02_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  'den02-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
  ...
  'den02-wd2_Ua-4Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  'den02-wd3_Ua-8Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  'den02-wd4_Ua-6Va4atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  'den02-wd5_Ua-6Va8atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  ...
  'den02-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
  'den02-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
  ...
  ...
  ...
  'dense-td2_notideUa-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
  'dense_Ua-6Va6atide0.05Hi1Ai1_2kmNr30Nly36Ws25'
  'dense-td3_atide0.1Ua-6Va6Hi1Ai1_2kmNr30Nly36Ws25'
  ...
% % %   'dense-wd2_Ua-4Va6Hi1Ai1atide0.05_2kmNr30Nly36Ws25'
% % %   'dense-wd3_Ua-8Va6Hi1Ai1atide0.05_2kmNr30Nly36Ws25'
% % %   'dense-wd4_Ua-6Va4Hi1Ai1atide0.05_2kmNr30Nly36Ws25'
% % %   ...
% % %   'dense-ice3_Hi0.2Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
% % %   'dense-ice2_Hi0.6Ai1Ua-6Va6atide0.05_2kmNr30Nly36Ws25'
]



