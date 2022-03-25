wt1=1285/1825;
wt2=1-wt1;

load('hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis_new80s_tidalEddyMeanAdvec_exact_1285days.mat')

G_xzint1 =  G_xzint;          
eddyAdvec_xzint1 =  eddyAdvec_xzint;          
totalAdvec_csi_xzint1 =  totalAdvec_csi_xzint;     
KE_avg_xzint1 =  KE_avg_xzint;             
half_dKEdx_avg_xzint1 =  half_dKEdx_avg_xzint;     
vz_avg_xzint1 =  vz_avg_xzint;             
KE_m_xzint1 =  KE_m_xzint;               
half_dKEdx_m_xzint1 =  half_dKEdx_m_xzint;       
vz_m_xzint1 =  vz_m_xzint;               
dKEdx_tot_xzint1 =  dKEdx_tot_xzint;          
meanAdvec_xzint1 =  meanAdvec_xzint;          
wdu_dz_avg_xzint1 =  wdu_dz_avg_xzint;         
duv_mdy_xzint1 =  duv_mdy_xzint ;           
tidalAdvec_MITgcm_xzint1 =  tidalAdvec_MITgcm_xzint;  
wdu_dz_m_xzint1 =  wdu_dz_m_xzint;           
duw_mdz_xzint1 =  duw_mdz_xzint;            
tidalAdvec_csi_xzint1 =  tidalAdvec_csi_xzint    ;                      
dvv_mdx_xzint1 =  dvv_mdx_xzint  ;          
totalAdvec_MITgcm_xzint1 =  totalAdvec_MITgcm_xzint  ;



load('hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis_tidalEddyMeanAdvec_exact_540days.mat')


G_xzint2 =  G_xzint;          
eddyAdvec_xzint2 =  eddyAdvec_xzint;          
totalAdvec_csi_xzint2 =  totalAdvec_csi_xzint;     
KE_avg_xzint2 =  KE_avg_xzint;             
half_dKEdx_avg_xzint2 =  half_dKEdx_avg_xzint;     
vz_avg_xzint2 =  vz_avg_xzint;             
KE_m_xzint2 =  KE_m_xzint;               
half_dKEdx_m_xzint2 =  half_dKEdx_m_xzint;       
vz_m_xzint2 =  vz_m_xzint;               
dKEdx_tot_xzint2 =  dKEdx_tot_xzint;          
meanAdvec_xzint2 =  meanAdvec_xzint;          
wdu_dz_avg_xzint2 =  wdu_dz_avg_xzint;         
duv_mdy_xzint2 =  duv_mdy_xzint ;           
tidalAdvec_MITgcm_xzint2 =  tidalAdvec_MITgcm_xzint;  
wdu_dz_m_xzint2 =  wdu_dz_m_xzint;           
duw_mdz_xzint2 =  duw_mdz_xzint;            
tidalAdvec_csi_xzint2 =  tidalAdvec_csi_xzint    ;                      
dvv_mdx_xzint2 =  dvv_mdx_xzint  ;          
totalAdvec_MITgcm_xzint2 =  totalAdvec_MITgcm_xzint  ;




G_xzint= wt1 * G_xzint1 + wt2* G_xzint2;              
eddyAdvec_xzint=wt1 * eddyAdvec_xzint1 + wt2* eddyAdvec_xzint2 ;               
totalAdvec_csi_xzint =wt1 * totalAdvec_csi_xzint1 + wt2* totalAdvec_csi_xzint2 ;          
KE_avg_xzint     =wt1 * KE_avg_xzint1 + wt2* KE_avg_xzint2 ;           
half_dKEdx_avg_xzint  =wt1 * half_dKEdx_avg_xzint1 + wt2* half_dKEdx_avg_xzint2 ;      
vz_avg_xzint       =wt1 * vz_avg_xzint1 + wt2* vz_avg_xzint2 ;         
KE_m_xzint    =wt1 * KE_m_xzint1 + wt2* KE_m_xzint2 ;              
half_dKEdx_m_xzint   =wt1 *half_dKEdx_m_xzint1  + wt2* half_dKEdx_m_xzint2 ;       
vz_m_xzint    =wt1 * vz_m_xzint1 + wt2* vz_m_xzint2 ;              
dKEdx_tot_xzint   =wt1 * dKEdx_tot_xzint1 + wt2*dKEdx_tot_xzint2  ;          
meanAdvec_xzint   =wt1 *meanAdvec_xzint1  + wt2* meanAdvec_xzint2 ;          
wdu_dz_avg_xzint     =wt1 *wdu_dz_avg_xzint1  + wt2*wdu_dz_avg_xzint2  ;       
duv_mdy_xzint       =wt1 *duv_mdy_xzint1  + wt2*duv_mdy_xzint2  ;        
tidalAdvec_MITgcm_xzint   =wt1 *tidalAdvec_MITgcm_xzint1  + wt2* tidalAdvec_MITgcm_xzint2 ;  
wdu_dz_m_xzint    =wt1 *wdu_dz_m_xzint1  + wt2* wdu_dz_m_xzint2 ;          
duw_mdz_xzint     =wt1 *duw_mdz_xzint1  + wt2*duw_mdz_xzint2  ;          
tidalAdvec_csi_xzint    =wt1 * tidalAdvec_csi_xzint1 + wt2*tidalAdvec_csi_xzint2 ;                       
dvv_mdx_xzint      =wt1 * dvv_mdx_xzint1 + wt2* dvv_mdx_xzint2 ;         
totalAdvec_MITgcm_xzint   =wt1 * totalAdvec_MITgcm_xzint1 + wt2*totalAdvec_MITgcm_xzint2  ;  



save('hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_ssurf33_analysis_tidalEddyMeanAdvec_exact_1825days.mat'...
        ,'G_xzint'                  ,'eddyAdvec_xzint'          ,'totalAdvec_csi_xzint'  ...  
        ,'KE_avg_xzint'             ,'half_dKEdx_avg_xzint'     ,'vz_avg_xzint'          ...   
        ,'KE_m_xzint'               ,'half_dKEdx_m_xzint'       ,'vz_m_xzint'            ...   
        ,'dKEdx_tot_xzint'          ,'meanAdvec_xzint'          ,'wdu_dz_avg_xzint'      ...   
        ,'duv_mdy_xzint'            ,'tidalAdvec_MITgcm_xzint'  ,'wdu_dz_m_xzint'        ...   
        ,'duw_mdz_xzint'            ,'tidalAdvec_csi_xzint'     ,'yy'                    ...   
        ,'dvv_mdx_xzint'            ,'totalAdvec_MITgcm_xzint');  
