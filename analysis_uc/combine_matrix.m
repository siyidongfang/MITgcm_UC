

    clear;close all;
    
    %%% Add path
    addpath /Users/csi/MITgcm_UC/analysis_uc/functions;  

    EXP_GROUP = {'seaice_boundary';'shelfice_seaice';'pseudo_shelfice_seaice';'no_seaice'};
    
    exp_group = EXP_GROUP{1}
    prodir = ['/Users/csi/MITgcm_UC/products_uc/' exp_group '/'];
    a1 = load([prodir 'matrix_' exp_group '.mat']);
    f1=fieldnames(a1);

    exp_group = EXP_GROUP{2}
    prodir = ['/Users/csi/MITgcm_UC/products_uc/' exp_group '/'];
    a2 = load([prodir 'matrix_' exp_group '.mat']);
    f2=fieldnames(a2);

    exp_group = EXP_GROUP{3}
    prodir = ['/Users/csi/MITgcm_UC/products_uc/' exp_group '/'];
    a3 = load([prodir 'matrix_' exp_group '.mat']);
    f3=fieldnames(a3);

    exp_group = EXP_GROUP{4}
    prodir = ['/Users/csi/MITgcm_UC/products_uc/' exp_group '/'];
    a4 = load([prodir 'matrix_' exp_group '.mat']);
    f4=fieldnames(a4);


a1.(f1{1})=[a1.(f1{1});a2.(f2{1});a3.(f3{1});a4.(f4{1})];

matrix=a1;

for nn=2:length(f1)
    matrix.(f1{nn})=[a1.(f1{nn}) a2.(f2{nn}) a3.(f3{nn}) a4.(f4{nn})];
end

save '/Users/csi/MITgcm_UC/products_uc/matrix_combined.mat' '-struct' matrix


