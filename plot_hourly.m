

    fname = ['/Users/ysi/MITgcm_UC/HourlyOutput/topography.nc'];
    yy = ncread(fname,'yy');
    xx = ncread(fname,'xx');
    zz = ncread(fname,'zz');

for n=1:383
% for n=1

    % fname = ['/Users/ysi/MITgcm_UC/HourlyOutput/WeakTides/WeakTides_mean_hour' num2str(n) '.nc'];
    fname = ['/Users/ysi/MITgcm_UC/HourlyOutput/StrongTides/StrongTides_mean_hour' num2str(n) '.nc'];
    uu = ncread(fname,'ww');
    uu_slice = squeeze(uu(150,:,:))';
    figure(1)
    pcolor(yy/1000,zz/1000,uu_slice);
    shading interp;colorbar;colormap(redblue);clim([-0.2 0.2]/100)

end