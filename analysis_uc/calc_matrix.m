%%%
%%% calc_matrix.m
%%%
%%% Calculate the following quantities:
%%%
%%% Tot_uc: total eastward transport
%%% Vol_uc: total ocean volume with eastward velocity
%%% Umean_uc = Tot_uc/Vol_uc: mean undercurrent strength
%%% Ub_east_max: maximum eastward seafloor velocity
%%% Ub_east_avg: mean eastward seafloor velocity
%%% U_east_max: maximum eastward velocity
%%% U_west_max: strongest westward velocity (negative) 
%%% Tot_west: total westward transport (negative) 
%%% Tot = Tot_west + Tot_uc: total zonal ocean transport (negative) 
%%% H_cdw: shoreward CDW heat transport
%%% H_tot: shoreward total heat transport
%%% Huc_east: eastward heat transport associated with the undercurrent
%%% R_is: ice shelf melting rate

%%% Correlation coefficient between (1) total eastward transport, (2) mean
%%% undercurrent strength, (3) maximum undercurrent strength, (4) eastward
%%% heat transport associated with the undercurrent along the shelf break,
%%% (5) maximum eastward seafloor velocity 
%%% with (1) ice shelf melt rate, (2) shoreward CDW transport, (3) total
%%% westward ocean transport
%%%


prodir = 
save([prodir 'matrix.mat'],'EXPNAME',...
    'Tot_uc','Vol_uc','Umean_uc'...
    'Ub_east_max','Ub_east_avg','U_east_max','U_west_max',...
    'Tot_west','Tot',...
    'H_cdw','H_tot','Huc_east','R_is')


