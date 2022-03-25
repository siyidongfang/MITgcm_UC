
close all;clear all;

addpath /Users/csi/Documents/MITgcm_ASF-csi/utils/matlab;
addpath /Users/csi/Documents/MITgcm_ASF-csi/newexp/analysis;


basedir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp/analysis/';
expdir = '/Users/csi/Documents/MITgcm_ASF-csi/newexp/';
expname = 'ardbeg2_obcsmktide_wind_noice'
% loadexp;


exppath = fullfile(expdir,expname);
finame=[exppath,'/input/OBNph.obcs']
fip=fopen(finame,'rb');
[dat,num]=fread(fip,[2000,1],'real*8',0,'b');
data = reshape(dat,200,10);
fclose(fip);