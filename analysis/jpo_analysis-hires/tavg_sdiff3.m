clear;

prodir = '/data/MITgcm_ASF-csi/products-hires/';
expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments/';
tavg_dir = 'sdiff3_tavg/';

expname = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_analysis_new80s';
loadexp;

expname1 = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_analysis';
expname2 = 'hires_Ua-6Va6_Atide0.05_Hi1Ai1_Ws25_sdiff3_analysis_new80s';

savename = [prodir expname1 '_tavg_5yrs.mat']


tavg1 = [prodir tavg_dir expname1 '_tavg_5yrs.mat'];
tavg2 = [prodir tavg_dir expname2 '_tavg_5yrs.mat'];

%%%Calculate the weight for each data set
wt1 = 675;
wt2 = 1150;
tot = wt1+wt2;
wt1 = wt1/tot;
wt2 = wt2/tot;

for m=1:57
  if (m == 1) %%% N.B. This won't work if the first field isn't one of those listed below
    flag = '';
  else    
    flag = '-append';
  end
  var_name = diag_fields{m};
  var_data = zeros(Nx,Ny,Nr);
  var_data1 = cell2mat(struct2cell(load(tavg1,var_name)));
  var_data2 = cell2mat(struct2cell(load(tavg2,var_name)));
  var_data = var_data1*wt1 + var_data2*wt2;

  tempStruct.(var_name) = var_data;
  save(savename,'-struct','tempStruct',var_name,flag);
end




for m=58:62 
  flag = '-append';
  
  var_name = diag_fields{m};
  var_data = cell2mat(struct2cell(load(tavg1,var_name)));

  tempStruct.(var_name) = var_data;
  save(savename,'-struct','tempStruct',var_name,flag);
end



ndump1 = 583200;
ndump2 = 1166400;
dt1 = 100;
dt2 = 80;
wt1 = dt1*ndump1;
wt2 = dt2*ndump2;
tot = wt1+wt2;
wt1 = wt1/tot;
wt2 = wt2/tot;


for m=63:82 
  flag = '-append';
  
  var_name = diag_fields{m};
  var_data = zeros(Nx,Ny,Nr);
  var_data1 = cell2mat(struct2cell(load(tavg1,var_name)));
  var_data2 = cell2mat(struct2cell(load(tavg2,var_name)));
  var_data = var_data1*wt1 + var_data2*wt2;

  tempStruct.(var_name) = var_data;
  save(savename,'-struct','tempStruct',var_name,flag);
end


