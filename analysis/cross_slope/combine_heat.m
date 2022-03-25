wt1=475/1825;
% wt1=1285/1825;

wt2=1-wt1;

load('hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis_new80s_heat_475days.mat')
% load('hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis_new80s_heat_1285days.mat')

Fmean1 =  Fmean;          
Fmean_xint1 =  Fmean_xint; 
Fmean_xzint1 =  Fmean_xzint; 
Fmean_zint1 =  Fmean_zint; 

Feddy1 =  Feddy;          
Feddy_xint1 =  Feddy_xint; 
Feddy_xzint1 =  Feddy_xzint; 
Feddy_zint1 =  Feddy_zint; 

Ftide1 =  Ftide;          
Ftide_xint1 =  Ftide_xint; 
Ftide_xzint1 =  Ftide_xzint; 
Ftide_zint1 =  Ftide_zint; 

G1 =  G;          
G_xint1 =  G_xint; 
G_xzint1 =  G_xzint; 
G_zint1 =  G_zint; 

load('hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis_heat_1350days.mat')
% load('hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis_heat_540days.mat')


Fmean2 =  Fmean;          
Fmean_xint2 =  Fmean_xint;
Fmean_xzint2 =  Fmean_xzint;
Fmean_zint2 =  Fmean_zint;

Feddy2 =  Feddy;          
Feddy_xint2 =  Feddy_xint;
Feddy_xzint2 =  Feddy_xzint;
Feddy_zint2 =  Feddy_zint;

Ftide2 =  Ftide;          
Ftide_xint2 =  Ftide_xint;
Ftide_xzint2 =  Ftide_xzint;
Ftide_zint2 =  Ftide_zint;

G2 =  G;          
G_xint2 =  G_xint;
G_xzint2 =  G_xzint;
G_zint2 =  G_zint;



Fmean = wt1 * Fmean1 + wt2* Fmean2;              
Fmean_xint = wt1 * Fmean_xint1 + wt2* Fmean_xint2;              
Fmean_xzint = wt1 * Fmean_xzint1 + wt2* Fmean_xzint2;              
Fmean_zint = wt1 * Fmean_zint1 + wt2* Fmean_zint2;              


Feddy = wt1 * Feddy1 + wt2* Feddy2;              
Feddy_xint = wt1 * Feddy_xint1 + wt2* Feddy_xint2;              
Feddy_xzint = wt1 * Feddy_xzint1 + wt2* Feddy_xzint2;              
Feddy_zint = wt1 * Feddy_zint1 + wt2* Feddy_zint2;     

Ftide = wt1 * Ftide1 + wt2* Ftide2;              
Ftide_xint = wt1 * Ftide_xint1 + wt2* Ftide_xint2;              
Ftide_xzint = wt1 * Ftide_xzint1 + wt2* Ftide_xzint2;              
Ftide_zint = wt1 * Ftide_zint1 + wt2* Ftide_zint2;     

G = wt1 * G1 + wt2* G2;              
G_xint = wt1 * G_xint1 + wt2* G_xint2;              
G_xzint = wt1 * G_xzint1 + wt2* G_xzint2;              
G_zint = wt1 * G_zint1 + wt2* G_zint2;     

save('hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_analysis_heat_1825days.mat','yy',...
    'Fmean','Fmean_xint','Fmean_xzint','Fmean_zint',...
    'Feddy','Feddy_xint','Feddy_xzint','Feddy_zint',...
    'Ftide','Ftide_xint','Ftide_xzint','Ftide_zint',...
    'G','G_xint','G_xzint','G_zint');