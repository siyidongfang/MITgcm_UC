%%%
%%% calc_BCvorticity_ISPT.m
%%% 
%%% Re-calculate the decomposition of the pressure torque in the vorticity budget, 
%%% including ice-shelf pressure torque

clear Um_Corif Vm_Corif
clear Um_AdvZ3f Vm_AdvZ3f
clear Um_Extf Vm_Extf
clear Um_AdvRef Vm_AdvRef
clear Um_Dissf Vm_Dissf
clear Um_Advecf Vm_Advecf
clear Um_dPhiXf Vm_dPhiYf
clear hFacWf hFacSf DZf

prodname = [prodir '/BCvorticity/' expname '_IceShelfPT'];
load(prodname,'zeta_ISdPhi','diff_idx','isb_surf','isb_bot','tt_isbs','tt_isbb','zz_surf','zz_bot')

tt_isbs(tt_isbs==0)=NaN;

zeta_ISPTcdw = NaN.*zeros(Nx,Ny);
zeta_ISPTsw = NaN.*zeros(Nx,Ny);
for i=1:Nx
    for j=1:Ny
        if(tt_isbs(i,j)>=0) %%% temperature at the tilted surface of the ice shelf>=0 means that the CDW is directly connected to the ice shelf
            zeta_ISPTcdw(i,j) = zeta_ISdPhi(i,j); %%% The ice-shelf pressure torque of the CDW layer
        elseif(tt_isbs(i,j)<0)
            zeta_ISPTsw(i,j) = zeta_ISdPhi(i,j);  %%% The ice-shelf pressure torque of the surface layer
        end
    end
end

prodname = [prodir 'BCvorticity/' expname '_BCvorticity_AllDepth.mat'];
load(prodname,'zeta_dPhi')
zeta_BPTplusISPT = zeta_dPhi; %%% Bottom pressure torque (plus ice-shelf pressure torque)

zeta_BPTplusISPT(isnan(zeta_BPTplusISPT))=0;
zeta_ISdPhi(isnan(zeta_ISdPhi))=0;

zeta_BPT = zeta_BPTplusISPT-zeta_ISdPhi;
zeta_BPT(zeta_BPT==0)=NaN;

prodname = [prodir 'BCvorticity/' expname '_BCvorticity_sw.mat'];
load(prodname,'zeta_dPhi')
zeta_IPTplusISPT = - zeta_dPhi; %%% Interfacial (isopycnal) pressure torque exerted on the CDW layer (plus ice-shelf pressure torque)

zeta_IPTplusISPT(isnan(zeta_IPTplusISPT))=0;
zeta_IPT = zeta_IPTplusISPT;

for i=1:Nx
    for j=1:Ny
        if(tt_isbs(i,j)>=0) %%% In the inner cavity, the CDW layer is directly connected to the ice shelf, so the interfacial pressure torque is zero.
            zeta_IPT(i,j) = 0;
        elseif(tt_isbs(i,j)<0) %%% In the outter cavity, IPT of the CDW layer =  - (total PT of the surface layer) + ISPT
            zeta_IPT(i,j) = zeta_IPTplusISPT(i,j)+zeta_ISdPhi(i,j);
        end
    end
end

zeta_IPT(zeta_IPT==0)=NaN;


prodname = [prodir 'BCvorticity/' expname '_BCvorticity_cdw.mat'];
load(prodname,'zeta_dPhi','zeta_Advec','zeta_Diss','zeta_residual',...
    'zeta_Cori','zeta_AdvZ3','zeta_AdvRe','XXf','YYf','VV_bc','zeta_betaV','UU_bc','xxf','yyf')
% prodname = [prodir 'BCvorticity/' expname '_BCvorticity_cdw.mat'];
% load(prodname)
zeta_TPT = zeta_dPhi; %%% Total PT: BPT plus IPT plus ice-shelf pressure torque in the inner cavity
VV_cdwf = VV_bc;
UU_cdwf = UU_bc;

prodname_new = [prodir expname '_vorticity_cdw_ISPT.mat'];
save(prodname_new,...
   'zeta_TPT','zeta_BPT','zeta_IPT','zeta_ISPTcdw','zeta_ISPTsw',...
   'zeta_Advec','zeta_Diss','zeta_residual',...
   'zeta_Cori','zeta_AdvZ3','zeta_AdvRe',...
   'XXf','YYf','zeta_betaV','UU_cdwf','VV_cdwf','xxf','yyf')


figure(6)
subplot(1,3,1);pcolor(zeta_ISdPhi');shading flat;colorbar;colormap(cmocean('balance'));clim([-1 1]/1e5);
subplot(1,3,2);pcolor(zeta_ISPTcdw');shading flat;colorbar;colormap(cmocean('balance'));clim([-1 1]/1e5);
subplot(1,3,3);pcolor(zeta_ISPTsw');shading flat;colorbar;colormap(cmocean('balance'));clim([-1 1]/1e5);

figure(7)
subplot(2,2,1);pcolor(zeta_TPT');shading flat;colorbar;colormap(cmocean('balance'));clim([-1 1]/1e5);
subplot(2,2,2);pcolor(zeta_BPT');shading flat;colorbar;colormap(cmocean('balance'));clim([-1 1]/1e5);
subplot(2,2,3);pcolor(zeta_IPT');shading flat;colorbar;colormap(cmocean('balance'));clim([-1 1]/1e5);
subplot(2,2,4);pcolor(zeta_ISPTcdw');shading flat;colorbar;colormap(cmocean('balance'));clim([-1 1]/1e5);

zeta_IPT(isnan(zeta_IPT))=0;
zeta_ISPTcdw(isnan(zeta_ISPTcdw))=0;
zeta_BPT(isnan(zeta_BPT))=0;
zeta_TPT(isnan(zeta_TPT))=0;

%%
figure(8)
pcolor(zeta_TPT'-zeta_BPT'-zeta_IPT'-zeta_ISPTcdw');shading flat;colorbar;colormap(cmocean('balance'));clim([-1 1]/1e5);
% pcolor(zeta_TPT'-zeta_BPT'-zeta_IPTplusISPT');shading flat;colorbar;colormap(cmocean('balance'));clim([-1 1]/1e5);



