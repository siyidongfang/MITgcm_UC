
clear

% load ss81_winter.mat
% ss=ss81_winter;
% load tt81_winter.mat
% tt=tt81_winter;

% load ss81_summer.mat
% ss=ss81_summer;
% load tt81_summer.mat
% tt=tt81_summer;

% load ss81_annual.mat
% ss=ss81_annual;
load tt91_annual.mat
tt=tt91_annual;


%%% Find seafloor salinity
[LA_ss,LO_ss] = meshgrid(double(lat),double(lon));
% ss_bot = NaN*ones(size(ss,1),size(ss,2));
tt_bot = NaN*ones(size(tt,1),size(tt,2));
for i=1:size(tt,1)
  for j=1:size(tt,2)
    kmax = find(~isnan(tt(i,j,:)),1,'last');   
    if (~isempty(kmax))
%       ss_bot(i,j) = ss(i,j,kmax);
      tt_bot(i,j) = tt(i,j,kmax);
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

% %%
% figure(1)
% clf;
% set(gcf,'Color','w')
% set(gcf,'Position',framepos);
% axesm('stereo','Origin',[-90 0],'MapLatLimit',[-90 -50],'FontSize',fontsize)
% axis off;
% framem on;
% gridm on;
% mlabel on;
% plabel on;
% setm(gca,'MLabelParallel',[-30]) 
% pcolorm(LA_ss,LO_ss,ss_bot);
% % colormap(cmocean('dense'));
% colormap(jet);
% caxis([33.9 35]);
% % title('Bottom salinity (psu), annual-mean climatology')
% % title('Bottom salinity (psu), winter climatology')
% title('Bottom salinity (psu), summer climatology')
% set(gca,'FontSize',fontsize);
% mainpos = get(gca,'Position');
% mainpos(1) = mainpos(1) - 0.02;
% set(gca,'Position',mainpos);
% handle = colorbar;
% set(handle,'Position',cbpos);
% 
% % print('-djpeg','-r250','ss81_annual_bottomS.jpeg');
% % print('-djpeg','-r250','ss81_winter_bottomS.jpeg');
% % print('-djpeg','-r250','ss81_summer_bottomS.jpeg');
% 

figure(2)
clf;
set(gcf,'Color','w')
set(gcf,'Position',framepos);
axesm('stereo','Origin',[-90 0],'MapLatLimit',[-90 -50],'FontSize',fontsize)
axis off;
framem on;
gridm on;
mlabel on;
plabel on;
setm(gca,'MLabelParallel',[-30]) 
pcolorm(LA_ss,LO_ss,tt_bot);
% colormap(cmocean('dense'));
colormap(jet);
caxis([-3 2]);
title('Bottom temperature (^oC), annual-mean climatology')
% title('Bottom temperature (^oC), winter climatology')
% title('Bottom temperature (^oC), summer climatology')
set(gca,'FontSize',fontsize);
mainpos = get(gca,'Position');
mainpos(1) = mainpos(1) - 0.02;
set(gca,'Position',mainpos);
handle = colorbar;
set(handle,'Position',cbpos);

% print('-djpeg','-r250','ss81_annual_bottomT.jpeg');
% print('-djpeg','-r250','ss81_winter_bottomT.jpeg');
% print('-djpeg','-r250','ss81_summer_bottomT.jpeg');

% save('ss81_winter_bottom','LA_ss','LO_ss','ss_bot');


