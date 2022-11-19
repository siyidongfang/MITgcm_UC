%%%
%%% calc_IntVorticity_FoverH
%%%
%%% Integrate the vorticity budget terms over closed f/h contours.
%%% This script should be run after calc_BTvorticity_curl_int


%%% Calculate f/h
    ff = f0+beta*YY;
    fh = -ff./abs(bathy);
    bathy(bathy==0)=NaN;
    
%%% Find closed f/h contours

    min_fh = min(min(fh));
    max_fh = max(max(fh));

%%% plot f/h contours 
    figure(20)
    contour(fh,(0:0.05:3)*1e-7)
    shading flat;
    colorbar
    colormap(jet)

%%% Select f/h contours  over the shelf and slope
    fh_select = (0:0.05:3)*1e-7;
    LL = length(fh_select);

%%% Interpolate the vorticity budget terms onto finer horizontal grid


%%% Calculate the area integral

zeta_dPhi_fhint = zeros(1,LL);
zeta_Advec_fhint = zeros(1,LL);
zeta_Diss_fhint = zeros(1,LL);
zeta_Ext_fhint = zeros(1,LL);
zeta_residual_fhint = zeros(1,LL);

for n=1:LL-1
    fh_a = fh_select(n);
    fh_b = fh_select(n+1);
    for i=1:Nx
        for j=1:Ny
            if (fh(i,j)<=fh_b) && (fh(i,j)>=fh_a) 
% %                 zeta_dPhi_fhint(n) = zeta_dPhi
%                 zeta_Advec_fhint(n) = zeta_Advec
%                 zeta_Diss
%                 zeta_Ext
%                 zeta_residual
            end
        end
    end

end




