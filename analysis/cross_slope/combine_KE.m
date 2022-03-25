% wt1=475/1825;
wt1=1285/1825;

wt2=1-wt1;

% load('hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis_new80s_KE_475days.mat')
load('hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis_new80s_KE_1285days.mat')

  
KE_zavg1 =  KE_zavg;          
KEuv_xzavg1 =  KEuv_xzavg; 
KEw_xzavg1 =  KEw_xzavg; 
KE_xzavg1 =  KE_xzavg; 

TKE_zavg1 =  TKE_zavg;          
TKEuv_xzavg1 =  TKEuv_xzavg; 
TKEw_xzavg1 =  TKEw_xzavg; 
TKE_xzavg1 =  TKE_xzavg; 

EKE_zavg1 =  EKE_zavg;          
EKEuv_xzavg1 =  EKEuv_xzavg; 
EKEw_xzavg1 =  EKEw_xzavg; 
EKE_xzavg1 =  EKE_xzavg; 

MKE_zavg1 =  MKE_zavg;          
MKEuv_xzavg1 =  MKEuv_xzavg; 
MKEw_xzavg1 =  MKEw_xzavg; 
MKE_xzavg1 =  MKE_xzavg; 

G_zavg1 = G_zavg;
Guv_xzavg1 = Guv_xzavg;
Gw_xzavg1 = Gw_xzavg;
G_xzavg1 = G_xzavg;


% load('hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis_KE_1350days.mat')
load('hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis_KE_540days.mat')


KE_zavg2 =  KE_zavg;          
KEuv_xzavg2 =  KEuv_xzavg; 
KEw_xzavg2 =  KEw_xzavg; 
KE_xzavg2 =  KE_xzavg; 

TKE_zavg2 =  TKE_zavg;          
TKEuv_xzavg2 =  TKEuv_xzavg; 
TKEw_xzavg2 =  TKEw_xzavg; 
TKE_xzavg2 =  TKE_xzavg; 

EKE_zavg2 =  EKE_zavg;          
EKEuv_xzavg2 =  EKEuv_xzavg; 
EKEw_xzavg2 =  EKEw_xzavg; 
EKE_xzavg2 =  EKE_xzavg; 

MKE_zavg2 =  MKE_zavg;          
MKEuv_xzavg2 =  MKEuv_xzavg; 
MKEw_xzavg2 =  MKEw_xzavg; 
MKE_xzavg2 =  MKE_xzavg; 

G_zavg2 = G_zavg;
Guv_xzavg2 = Guv_xzavg;
Gw_xzavg2 = Gw_xzavg;
G_xzavg2 = G_xzavg;






KE_zavg = wt1 * KE_zavg1 + wt2* KE_zavg2;              
KEuv_xzavg = wt1 * KEuv_xzavg1 + wt2* KEuv_xzavg2;              
KEw_xzavg = wt1 * KEw_xzavg1 + wt2* KEw_xzavg2;              
KE_xzavg = wt1 * KE_xzavg1 + wt2* KE_xzavg2;             

TKE_zavg = wt1 * TKE_zavg1 + wt2* TKE_zavg2;              
TKEuv_xzavg = wt1 * TKEuv_xzavg1 + wt2* TKEuv_xzavg2;              
TKEw_xzavg = wt1 * TKEw_xzavg1 + wt2* TKEw_xzavg2;              
TKE_xzavg = wt1 * TKE_xzavg1 + wt2* TKE_xzavg2;     

EKE_zavg = wt1 * EKE_zavg1 + wt2* EKE_zavg2;              
EKEuv_xzavg = wt1 * EKEuv_xzavg1 + wt2* EKEuv_xzavg2;              
EKEw_xzavg = wt1 * EKEw_xzavg1 + wt2* EKEw_xzavg2;              
EKE_xzavg = wt1 * EKE_xzavg1 + wt2* EKE_xzavg2;     

MKE_zavg = wt1 * MKE_zavg1 + wt2* MKE_zavg2;              
MKEuv_xzavg = wt1 * MKEuv_xzavg1 + wt2* MKEuv_xzavg2;              
MKEw_xzavg = wt1 * MKEw_xzavg1 + wt2* MKEw_xzavg2;              
MKE_xzavg = wt1 * MKE_xzavg1 + wt2* MKE_xzavg2;     

G_zavg = wt1 * G_zavg1 + wt2* G_zavg2;              
Guv_xzavg = wt1 * Guv_xzavg1 + wt2* Guv_xzavg2;              
Gw_xzavg = wt1 * Gw_xzavg1 + wt2* Gw_xzavg2;              
G_xzavg = wt1 * G_xzavg1 + wt2* G_xzavg2;   

save('hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurff33_analysis_KE_1825days.mat','yy','xx',...
  'KE_zavg', 'KEuv_xzavg', 'KEw_xzavg', 'KE_xzavg',...
  'TKE_zavg','TKEuv_xzavg','TKEw_xzavg','TKE_xzavg',...
  'EKE_zavg','EKEuv_xzavg','EKEw_xzavg','EKE_xzavg',...
  'MKE_zavg','MKEuv_xzavg','MKEw_xzavg','MKE_xzavg',...
  'G_zavg',  'Guv_xzavg',  'Gw_xzavg',  'G_xzavg'...
  );
