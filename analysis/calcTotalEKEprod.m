%%%
%%% calcTotalEKEprod.m
%%%
%%% Integrates EKE production over the whole domain.
%%%

%%% Set true to include AABW formation region
include_AABW = false;

%%% Compute energy budget terms
calcEnergyBudget;

%%% Calculate total EKE production
PE_EKE_DV = PE_EKE.*DX.*DY.*DZ.*hFacC;
MKE_EKE_DV = MKE_EKE.*DX.*DY.*DZ.*hFacC;
if (include_AABW)
  startidx = 1;
else
  startidx = 126; %%% y=500km
end
PE_EKE_tot = sum(sum(sum(PE_EKE_DV(:,startidx:end,:))));
MKE_EKE_tot = sum(sum(sum(MKE_EKE_DV(:,startidx:end,:))));