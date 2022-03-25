%%%
%%% calcPE_ZKE_TS.m
%%%
%%% Convenience function to calculate conversion from PE to time/zonal mean
%%% KE.
%%%
function PE_ZKE_xyint = calcPE_ZKE_TS(hFacC,DX,DY,w_xavg,t_xavg,s_xavg,psiE,yy,gravity,tAlpha,sBeta)

  Nx = size(hFacC,1);
  Ny = size(hFacC,2);
  Nr = size(hFacC,3);

  PE_ZKE = zeros(Ny,Nr+1);
  PE_ZKE(:,2:Nr) = gravity*tAlpha * w_xavg(:,2:Nr) .* (0.5*(t_xavg(:,1:Nr-1)+t_xavg(:,2:Nr))) ...
                  -gravity* sBeta * w_xavg(:,2:Nr) .* (0.5*(s_xavg(:,1:Nr-1)+s_xavg(:,2:Nr)));
  PE_ZKE = 0.5 * (PE_ZKE(:,1:Nr) + PE_ZKE(:,2:Nr+1));
  PE_ZKE = repmat(reshape(PE_ZKE,[1 Ny Nr]),[Nx 1 1]);
  PE_ZKE(hFacC==0) = 0;
  
  %%% Integrate horizontally, starting from the southern edge of the
  %%% Eulerian-mean streamfunction
  PE_ZKE_xyint = zeros(Nr,1);
  for k=1:Nr
    psiE_k = 0.25*(psiE(1:Ny,k)+psiE(2:Ny+1,k)+psiE(1:Ny,k+1)+psiE(2:Ny+1,k+1));
    jrange = (yy>5e5) | (yy>4e5 & psiE_k'>0);
    PE_ZKE_xyint(k) = squeeze(sum(sum(PE_ZKE(:,jrange,k).*DX(:,jrange,k).*DY(:,jrange,k),1),2));
  end

end

