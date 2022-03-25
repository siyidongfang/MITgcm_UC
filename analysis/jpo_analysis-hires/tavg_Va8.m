clear;

prodir = '/data/MITgcm_ASF-csi/products-hires/';
expdir = '/run/media/csi/LaCie/MITgcm_ASF-csi/experiments/';
expname = 'hires_Ua-6Va8_Atide0.05_Hi1Ai1_Ws25_analysis';
loadexp;

expname1 = expname;
expname2 = 'hires_Ua-6Va8_Atide0.05_Hi1Ai1_Ws25_analysis_new';
expname3 = 'hires_Ua-6Va8_Atide0.05_Hi1Ai1_Ws25_analysis_new2_80s';

savename = [expname '_all_tavg_5yrs.mat']


tavg1 = [prodir expname1 '_tavg_5yrs.mat'];
tavg2 = [prodir expname2 '_tavg_5yrs.mat'];
tavg3 = [prodir expname3 '_tavg_5yrs.mat'];

%%%Calculate the weight for each data set
ndump1 = 4;
ndump2 = 6;
ndump3 = 4;
dt1 = 100;
dt2 = 100;
dt3 = 80;
wt1 = dt1*ndump1;
wt2 = dt2*ndump2;
wt3 = dt3*ndump3;
tot = wt1+wt2+wt3;
wt1 = wt1/tot;
wt2 = wt2/tot;
wt3 = wt3/tot;

for m=85:length(diag_fields)
  if (m == 1) %%% N.B. This won't work if the first field isn't one of those listed below
    flag = '';
  else    
    flag = '-append';
  end
  var_name = diag_fields{m};
  var_data = zeros(Nx,Ny,Nr);
  var_data1 = cell2mat(struct2cell(load(tavg1,var_name)));
  var_data2 = cell2mat(struct2cell(load(tavg2,var_name)));
  var_data3 = cell2mat(struct2cell(load(tavg3,var_name)));
  var_data = var_data1*wt1 + var_data2*wt2 + var_data3*wt3;

  tempStruct.(var_name) = var_data;
  save(savename,'-struct','tempStruct',var_name,flag);
end
