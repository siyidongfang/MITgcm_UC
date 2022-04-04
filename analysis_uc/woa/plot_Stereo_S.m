
clear

addpath /Users/csi/MITgcm_ASF-csi/data_WOA18_etopo;

load ss81_winter.mat
ss=ss81_winter;

% %%% Find seafloor salinity
% [LA_ss,LO_ss] = meshgrid(double(lat),double(lon));
% ss_bot = NaN*ones(size(ss,1),size(ss,2));
% for i=1:size(ss,1)
%   for j=1:size(ss,2)
%     kmax = find(~isnan(ss(i,j,:)),1,'last');   
%     if (~isempty(kmax))
%       ss_bot(i,j) = ss(i,j,kmax);
%     end
%   end
% end



%%% Find salinity at 500m depth. If the ocean is shallower than 500m, find
%%% the seafloor salinity instead.

[LA_ss,LO_ss] = meshgrid(double(lat),double(lon));
ss_bot = NaN*ones(size(ss,1),size(ss,2));

depth_idx = 37; %%% 500m

for i=1:size(ss,1)
  for j=1:size(ss,2)
      
    if (~isnan(ss(i,j,depth_idx)))
        ss_bot(i,j) = ss(i,j,depth_idx);
    else
        kmax = find(~isnan(ss(i,j,:)),1,'last');   
        if (~isempty(kmax))
          ss_bot(i,j) = ss(i,j,kmax);
        end
    end  
    
  end
end


%%% Plotting options
fontsize = 14;
scrsz = get(0,'ScreenSize');
framepos = [scrsz(3)/8 200 800 750];
cbpos = [0.85 0.109999983800782 0.0160416565421553 0.156666682865885];
linewidth = 2;
boxcolor = 'k';

%%
figure(1);
clf;
set(gcf,'Color','w')
set(gcf,'Position',framepos);
axesm('stereo','Origin',[-90 0],'MapLatLimit',[-90 -60],'FontSize',fontsize)
axis off;
framem on;
gridm on;
mlabel on;
plabel on;
setm(gca,'MLabelParallel',[-30]) 
pcolorm(LA_ss,LO_ss,ss_bot);
% colormap(cmocean('dense'));
colormap(jet);
caxis([33.8 35]);
set(gca,'FontSize',fontsize);
mainpos = get(gca,'Position');
mainpos(1) = mainpos(1) - 0.02;
set(gca,'Position',mainpos);
handle = colorbar;
set(handle,'Position',cbpos);

% save('ss81_winter_seafloor','LA_ss','LO_ss','ss_bot');


