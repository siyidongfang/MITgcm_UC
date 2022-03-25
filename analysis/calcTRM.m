

%%% Meridional grid spacings
DYF = repmat(delY',1,Nr);
DYC = zeros(Ny,Nr);
DYC(2:Ny,:) = 0.5 * (DYF(2:Ny,:) + DYF(1:Ny-1,:));
DYC(1,:) = 0.5 * (DYF(1,:) + DYF(Ny,:));

%%% Grids of actual vertical positions, accounting for partial cells
hFacC_yz = squeeze(hFacC(1,:,:));
hFacS_yz = squeeze(hFacS(1,:,:));
kbotC = sum(hFacC_yz~=0,2);
kbotS = sum(hFacS_yz~=0,2);
ZZC = zeros(Ny,Nr);
ZZS = zeros(Ny,Nr);
ZZF = zeros(Ny,Nr+1);
DZC = zeros(Ny,Nr+1);
DZS = zeros(Ny,Nr+1);
ZZC(:,1) = - delR(1)*hFacC_yz(:,1)/2;
ZZS(:,1) = - delR(1)*hFacS_yz(:,1)/2;
ZZF(:,1) = 0;
DZC(:,1) = delR(1)*hFacC_yz(:,1)/2;
DZS(:,1) = delR(1)*hFacS_yz(:,1)/2;
for k=2:Nr
  DZC(:,k) = 0.5*delR(k-1)*hFacC_yz(:,k-1) + 0.5*delR(k)*hFacC_yz(:,k);
  DZS(:,k) = 0.5*delR(k-1)*hFacS_yz(:,k-1) + 0.5*delR(k)*hFacS_yz(:,k);
  ZZC(:,k) = ZZC(:,k-1) - DZC(:,k);
  ZZS(:,k) = ZZS(:,k-1) - DZS(:,k);
  ZZF(:,k) = ZZF(:,k-1) - delR(k-1)*hFacC_yz(:,k-1);  
end       

%%% Matrices for vertical interpolation onto cell upper faces/corners
wnC = zeros(Ny,Nr);
wpC = zeros(Ny,Nr);
wnS = zeros(Ny,Nr);
wpS = zeros(Ny,Nr);
for j=1:Ny  
  for k=2:kbotC(j)             
     wnC(j,k) = (ZZC(j,k-1)-ZZF(j,k))./(ZZC(j,k-1)-ZZC(j,k));
     wpC(j,k) = 1 - wnC(j,k);
     wnS(j,k) = (ZZS(j,k-1)-ZZF(j,k))./(ZZS(j,k-1)-ZZS(j,k));
     wpS(j,k) = 1 - wnS(j,k);     
  end
end

tt(hFacC==0) = NaN;
uu(hFacC==0) = NaN;
vt(hFacC==0) = NaN;
wt(hFacC==0) = NaN;

%%% TODO THIS IS WRONG!!!
tt_avg = squeeze(nanmean(tt,1));
vv_avg = squeeze(nanmean(vv,1));
vt_eddy = squeeze(nanmean(vt,1))-vv_avg.*tt_avg;
wt_eddy = squeeze(nanmean(wt,1))-squeeze(nanmean(ww,1)).*tt_avg;


ttF = NaN*zeros(Ny,Nr+1); 
ttF(:,2:Nr) = wpC(:,2:Nr).*tt_avg(:,1:Nr-1) + wnC(:,2:Nr).*tt_avg(:,2:Nr);


%%% z-derivatives
dt_dz = NaN*zeros(Ny,Nr+1);
dt_dz(:,2:Nr) = ( wnC(:,2:Nr).^2.*(tt_avg(:,1:Nr-1)-ttF(:,2:Nr)) ...
                - wpC(:,2:Nr).^2.*(tt_avg(:,2:Nr)-ttF(:,2:Nr)) ) ./ ...
                     ( wpC(:,2:Nr).*wnC(:,2:Nr).*DZC(:,2:Nr) );
%%% y-derivatives
dt_dy = NaN*zeros(Ny+1,Nr);
dt_dy(2:Ny,:) = (tt_avg(2:Ny,:)-tt_avg(1:Ny-1,:)) ./ DYC(2:Ny,:);                   
                   
                   
vt_Q = zeros(Ny+1,Nr+1);
dt_dy_Q = zeros(Ny+1,Nr+1);
wt_Q = zeros(Ny+1,Nr+1);
dt_dz_Q = zeros(Ny+1,Nr+1);
vt_Q(2:Ny,2:Nr) = wpS(2:Ny,2:Nr).*vt_eddy(2:Ny,1:Nr-1) + wnS(2:Ny,2:Nr).*vt_eddy(2:Ny,2:Nr);
dt_dy_Q(2:Ny,2:Nr) = wpS(2:Ny,2:Nr).*dt_dy(2:Ny,1:Nr-1) + wnS(2:Ny,2:Nr).*dt_dy(2:Ny,2:Nr);
wt_Q(2:Ny,2:Nr) = 0.5 * (wt_eddy(1:Ny-1,2:Nr) + wt_eddy(2:Ny,2:Nr));
dt_dz_Q(2:Ny,2:Nr) = 0.5 * (dt_dz(1:Ny-1,2:Nr) + dt_dz(2:Ny,2:Nr));
psie_T = (vt_Q.*dt_dz_Q - wt_Q.*dt_dy_Q) ./ (dt_dy_Q.^2 + dt_dz_Q.^2);

psie_T = vt_Q ./ dt_dz_Q;

%%% Compute Eulerian-mean streamfunction
calcMeanOverturning;

makePsiGrid;
figure(1);
contourf(YY_psi,ZZ_psi,psimean+psie_T,[-1:0.05:1]);