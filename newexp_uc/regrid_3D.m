%%%
%%% regrid_3D.m
%%%
%%% Regrids a pickup file HORIZONTALLY and VERTICALLY onto a grid of a different size.
%%%
clear all;close all;

%%% For file I/O
addpath ../newexp_utils/
addpath ../utils/matlab

%%% Configuration
inputdir = '/Users/csi/MITgcm_ASF-csi/experiments/ws-suvice1_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25_lores2/results';
outputdir = '/Users/csi/MITgcm_ASF-csi/experiments/regrid';

% outputdir = '/Users/csi/MITgcm_ASF-csi/experiments/hires1-ref-ws_Ua-6Va6_Atide0.05_Hi0Ai0_Ws25/results';
expiter_in = 1695484;
Nr_in = 30;

% Nx_out = 396;
% Ny_out = 432;
% Nr_out = 70;
% expiter_out = 1;
% deltaT_out = 137;

Nx_out = 200;
Ny_out = 225;
Nr_out = 30;
expiter_out = 1;
deltaT_out = 279;
timeInterval_out = deltaT_out*expiter_out;
H = 4000;
pickupfiles = {'pickup','pickup_somT','pickup_somS','pickup_seaice'};
nFlds = [12 1 1 7];
nrecords_in = [273 9 9 13];
nrecords_out = [(nFlds(1)-3)*Nr_out+3 9 9 13];
nan_zeros = [true,true,true,false]; %%% Set true to replace zeros with NaNs before interpolation. 
                          %%% Usually a good idea e.g. to prevent tiny salinities when 
                          %%% interpolating near land points, but may be undesireable 
                          %%% for sea ice fields, which can be zero in non-land points.                          
write_init_files = false;

  
%%% Grid spacing increases with depth, but spacings exactly sum to H
zidx_in = 1:Nr_in;
gamma = 10;  
alpha = 10;
dz1_in = 2*H/Nr_in/(alpha+1);
dz2_in = alpha*dz1_in;
dz_in = dz1_in + ((dz2_in-dz1_in)/2)*(1+tanh((zidx_in-((Nr_in+1)/2))/gamma));
zz_in = -cumsum((dz_in+[0 dz_in(1:end-1)])/2);

zidx_out = 1:Nr_out;
gamma = 10;  
alpha = 10;
dz1_out = 2*H/Nr_out/(alpha+1);
dz2_out = alpha*dz1_out;
dz_out = dz1_out + ((dz2_out-dz1_out)/2)*(1+tanh((zidx_out-((Nr_out+1)/2))/gamma));
zz_out = -cumsum((dz_out+[0 dz_out(1:end-1)])/2);

  
%%% Formatting
ieee='b';
prec='real*8';

%%% Loop through pickup files for the specified iteration and regrid each
for m = 1:length(pickupfiles)
% for m = 2:3
  m
  %%% Load all data from pickup file
  pdata_in = rdmds(fullfile(inputdir,pickupfiles{m}),expiter_in);
  Nx_in = size(pdata_in,1);
  Ny_in = size(pdata_in,2);
  switch(pickupfiles{m})
      case 'pickup'
          NN = (size(pdata_in,3)-3)/Nr_in*Nr_out+3;
          pdata_mid = NaN*ones(Nx_in,Nx_in,NN);  %%% _mid: Regrid the pickup file vertically
          pdata_out = NaN*ones(Nx_out,Ny_out,NN);
      case 'pickup_somT'
          pdata_mid = NaN*ones(Nx_in,Nx_in,Nr_out,nrecords_in(m));
          pdata_out = NaN*ones(Nx_out,Ny_out,Nr_out,nrecords_out(m));
      case 'pickup_somS'
          pdata_mid = NaN*ones(Nx_in,Nx_in,Nr_out,nrecords_in(m));
          pdata_out = NaN*ones(Nx_out,Ny_out,Nr_out,nrecords_out(m));
      case 'pickup_seaice'
          pdata_out = NaN*ones(Nx_out,Ny_out,nrecords_in(m));
  end
  
  %%% Grids for linear interpolation (this is rather crude)
  dx_in = 1.0/Nx_in;
  dy_in = 1.0/Ny_in;
  xx_in = 0.5*dx_in:dx_in:1-0.5*dx_in;
  yy_in = 0.5*dy_in:dy_in:1-0.5*dy_in;
  dx_out = 1.0/Nx_out;
  dy_out = 1.0/Ny_out;
  xx_out = 0.5*dx_out:dx_out:1-0.5*dx_out;
  yy_out = 0.5*dy_out:dy_out:1-0.5*dy_out;
  [YY_in2D,XX_in2D] = meshgrid(yy_in,xx_in);
  [YY_out2D,XX_out2D] = meshgrid(yy_out,xx_out);
  [YY_in3D,XX_in3D,ZZ_in3D] = meshgrid(yy_in,xx_in,zz_in/H);
  [YY_out3D,XX_out3D,ZZ_out3D] = meshgrid(yy_out,xx_out,zz_out/H);
  [ZZ_inxz,XX_inxz] = meshgrid(zz_in,xx_in);
  [ZZ_outxz,XX_outxz] = meshgrid(zz_out,xx_out);
  
  %%% Interpolate vertically. Then loop through all columns of pickup data (i.e. through all vertical
  %%% levels of all variables) and interpolate horizontally
switch(pickupfiles{m})
    
  case 'pickup'
      %%% Mask land points with NaNs
      if (nan_zeros(m))
         pdata_in(pdata_in==0) = NaN;
      end
      %%% Interpolation
      for kk = 1:(nFlds(m)-3)
          pdata_out(:,:,(kk-1)*Nr_out+1:kk*Nr_out) = interp3(YY_in3D,XX_in3D,ZZ_in3D,...
                                pdata_in(:,:,(kk-1)*Nr_in+1:kk*Nr_in),YY_out3D,XX_out3D,ZZ_out3D);
          %%% Copy boundary conditions
          pdata_out(:,1,(kk-1)*Nr_out+1:kk*Nr_out)=interp2(ZZ_inxz,XX_inxz,squeeze(pdata_in(:,1,(kk-1)*Nr_in+1:kk*Nr_in)),ZZ_outxz,XX_outxz); 
          pdata_out(:,end,(kk-1)*Nr_out+1:kk*Nr_out)=interp2(ZZ_inxz,XX_inxz,squeeze(pdata_in(:,end,(kk-1)*Nr_in+1:kk*Nr_in)),ZZ_outxz,XX_outxz); 
      end     
      pdata_out(:,:,end-2)=interp2(YY_in2D,XX_in2D,pdata_in(:,:,end-2),YY_out2D,XX_out2D,'cubic'); 
      pdata_out(:,:,end-1)=interp2(YY_in2D,XX_in2D,pdata_in(:,:,end-1),YY_out2D,XX_out2D,'cubic'); 
      pdata_out(:,:,end)=interp2(YY_in2D,XX_in2D,pdata_in(:,:,end),YY_out2D,XX_out2D,'cubic');  
%       %%% Mask NaN points with 0
%       if (nan_zeros(m))
%          pdata_out(isnan(pdata_out))=0;
%       end
      %%% Extrapolation
      for k = 1:size(pdata_out,3)
          pdata_out(:,:,k) = inpaint_nans(pdata_out(:,:,k)); 
      end
%       %%% Write in data for surface and bottom boundaries
%       pdata_out(:,:,[0:nFlds(m)-4]*Nr_out+1) =  pdata_out(:,:,[0:nFlds(m)-4]*Nr_out+3);
%       pdata_out(:,:,[0:nFlds(m)-4]*Nr_out+2) =  pdata_out(:,:,[0:nFlds(m)-4]*Nr_out+3);
%       pdata_out(:,:,[1:nFlds(m)-3]*Nr_out) =  pdata_out(:,:,[1:nFlds(m)-3]*Nr_out-1);
      
  case 'pickup_somT'  
      %%% Mask land points with NaNs
      if (nan_zeros(m))
         pdata_in(pdata_in==0) = NaN;
      end
      %%% Interpolation
      for kk = 1:nrecords_in(m)
          pdata_out(:,:,:,kk) = interp3(YY_in3D,XX_in3D,ZZ_in3D,...
                                pdata_in(:,:,:,kk),YY_out3D,XX_out3D,ZZ_out3D);
          %%% Copy boundary conditions
          pdata_out(:,1,:,kk)=interp2(ZZ_inxz,XX_inxz,squeeze(pdata_in(:,1,:,kk)),ZZ_outxz,XX_outxz); 
          pdata_out(:,end,:,kk)=interp2(ZZ_inxz,XX_inxz,squeeze(pdata_in(:,end,:,kk)),ZZ_outxz,XX_outxz); 
      end     
%       %%% Mask NaN points with 0
%       if (nan_zeros(m))
%          pdata_out(isnan(pdata_out))=0;
%       end
      %%% Extrapolation
      for k = 1:size(pdata_out,3)
          for kkk = 1:size(pdata_out,4)
              pdata_out(:,:,k,kkk) = inpaint_nans(pdata_out(:,:,k,kkk)); 
          end
      end
%       %%% Write in data for surface and bottom boundaries
%       pdata_out(:,:,1,:) =  pdata_out(:,:,3,:);
%       pdata_out(:,:,2,:) =  pdata_out(:,:,3,:);
%       pdata_out(:,:,end,:) =  pdata_out(:,:,end-1,:);
      
  case 'pickup_somS'
      %%% Mask land points with NaNs
      if (nan_zeros(m))
         pdata_in(pdata_in==0) = NaN;
      end
      %%% Interpolation
      for kk = 1:nrecords_in(m)
          pdata_out(:,:,:,kk) = interp3(YY_in3D,XX_in3D,ZZ_in3D,...
                                pdata_in(:,:,:,kk),YY_out3D,XX_out3D,ZZ_out3D);
          %%% Copy boundary conditions
          pdata_out(:,1,:,kk)=interp2(ZZ_inxz,XX_inxz,squeeze(pdata_in(:,1,:,kk)),ZZ_outxz,XX_outxz); 
          pdata_out(:,end,:,kk)=interp2(ZZ_inxz,XX_inxz,squeeze(pdata_in(:,end,:,kk)),ZZ_outxz,XX_outxz); 
      end     
%       %%% Mask NaN points with 0
%       if (nan_zeros(m))
%          pdata_out(isnan(pdata_out))=0;
%       end
      %%% Extrapolation
      for k = 1:size(pdata_out,3)
          for kkk = 1:size(pdata_out,4)
              pdata_out(:,:,k,kkk) = inpaint_nans(pdata_out(:,:,k,kkk)); 
          end
      end
%       %%% Write in data for surface and bottom boundaries
%       pdata_out(:,:,1,:) =  pdata_out(:,:,3,:);
%       pdata_out(:,:,2,:) =  pdata_out(:,:,3,:);
%       pdata_out(:,:,end,:) =  pdata_out(:,:,end-1,:);

    case 'pickup_seaice'
      for k = 1:nrecords_in(m)
        %%% Interpolation
        pdata_out(:,:,k) = interp2(YY_in2D,XX_in2D,pdata_in(:,:,k),YY_out2D,XX_out2D,'cubic');  %%% Interpolation
        %%% Extrapolation
        pdata_out(:,:,k) = inpaint_nans(pdata_out(:,:,k)); 
      end 
        Negative2zero = pdata_out(:,:,1:11)<0;
        pdata_out(Negative2zero) = 0;
      
%       %%% Mask NaN points with 0
%        pdata_out(isnan(pdata_out))=0;
end

  
  %%% Write initialization .bin files
  if (write_init_files)
    %%% TODO
  %%% Write pickup.****.data file
  else
    writeDataset(pdata_out,fullfile(outputdir,[pickupfiles{m},'.',num2str(expiter_out,'%.10d'),'.data']),ieee,prec);
  end
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%% Create .meta file
  ifid = fopen(fullfile(inputdir,[pickupfiles{m},'.',num2str(expiter_in,'%.10d'),'.meta']),'r');
  ofid = fopen(fullfile(outputdir,[pickupfiles{m},'.',num2str(expiter_out,'%.10d'),'.meta']),'w');
  iline = fgetl(ifid);
  while (ischar(iline))
    if (startsWith(iline,' dimList')) %%% Update dimension list
        if(m==1|m==4)
            fprintf(ofid,'%s\n',iline);
            fprintf(ofid,'%s\n',['   ',num2str(Nx_out),',    1,  ',num2str(Nx_out),',']);
            fprintf(ofid,'%s\n',['   ',num2str(Ny_out),',    1,  ',num2str(Ny_out)]);
            fgetl(ifid); %%% Discard next two lines because we are replacing them
            fgetl(ifid);
        elseif(m==2|m==3)
            fprintf(ofid,'%s\n',iline);
            fprintf(ofid,'%s\n',['   ',num2str(Nx_out),',    1,  ',num2str(Nx_out),',']);
            fprintf(ofid,'%s\n',['   ',num2str(Ny_out),',    1,  ',num2str(Ny_out),',']);
            fprintf(ofid,'%s\n',['    ',num2str(Nr_out),',    1,   ',num2str(Nr_out)]);
            fgetl(ifid); %%% Discard next three lines because we are replacing them
            fgetl(ifid);
            fgetl(ifid);
        end
    elseif (startsWith(iline,' timeStepNumber'))     
        fprintf(ofid,'%s\n',[' timeStepNumber = [          ',num2str(expiter_out),' ];']);
    elseif (startsWith(iline,' nrecords = [        273'))
        fprintf(ofid,'%s\n',[' nrecords = [        ',num2str(nrecords_out(1)),' ];']);
    elseif (startsWith(iline,' timeInterval'))
        timeInterval_out_string = compose('%.12E',timeInterval_out);
        fprintf(ofid,'%s\n',[' timeInterval = [  ',timeInterval_out_string{1},' ];']);
    else
      fprintf(ofid,'%s\n',iline);
    end
    iline = fgetl(ifid);
  end
  fclose(ifid);
  fclose(ofid);
  
  
  
  
end