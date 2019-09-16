function gnssIR_lomb(station, year, doy,freqtype,snrtype, plot2screen,gps_or_gnss,varargin);
%function gnssIR_lomb(station, year, doy,freqtype,plot2screen,varargin);
% REQUIRED INPUTS:
% station name.  must be 4 character
% year
% doy - day of year
% freqtype = 1, 2, or 5 (need to add glonass)
% snrtype  
%    99 5-30 elev.
%    66 < 30 elev.
%    88 5-90 elev.
%    50 < 10 elev (useful for very tall sites)

% plot2screen - boolean for whether you want to see the raw data plots
% the code will compute results in 8 azimuth bins, 0-45, 45-90 and so on.
% if you want that computation set, use one of the variable inputs below.

% gps_or_gnss is 1 for gps and 2 for gnss.  These options are only for
% translating the RINEX file.  If you already have a SNR file stored, this
% input does not matter. 1 means you will use a nav file to compute the GPS
% orbits.  If you pick 2, it will use a sp3 file. The latter can have 
% multi-GNSS signals in it.

% VARIABLE INPUTS
% elevation angle minimum, degrees
% elevation angle maximum, degrees
% min RH (m)
% max RH (m)
% latitude (deg)
% longitude (deg)
% ellipsoidal height (m)
% minimum allowed lomb scargle amplitude. this depends on frequency
% min azimuth, degrees
% max azimuth, degrees

%  
% 
% The main outputs of this code are REFLECTOR 
% HEIGHTS, or RH, in meters. RH is the vertical distance between the GPS
% phase center and the ice/snow surface.  If you have field measurements
% of GPS antenna height, please remember that the GPS phase center is not 
% in the same place as the ground plane that most people use for field
% measurements of antenna height.

% Please also keep in mind that you can always pick a peak value 
% for a periodogram, but that doesn't mean it is significant. It is 
% your job to determine if your peak is meaningful. I have used different
% ways to do this.  Possible Quality control measures: 
%  1. amplitude of the LSP peak.
%  2. amptliude of LSP peak relative to a noise level
%  3. width of LSP peak (but this depends on sample interval, so that is
%     no implemented her).
%     do not use it here).
%  4. you don't want double peaks. You see these sometimes with L2P SNR data
%  5. you (generally) don't want a satellite track that both rises and
%        sets. 
% I have currently set a default of peak being 2.7 times larger than the 
% noise, but this is just to get you started.  This assumes you have picked
% a relevant interval to calculate the noise over. You can change it below.
% 
% I strongly encourage you to look at your SNR data before
% you start automating things. This code allows you to do that.

% This is based on the original codes distributed by 
% Carolyn J. Roesler and Kristine M. Larson for the GPS Tool Box.
% These newer codes provide more direct access to the 
% RINEX files. 
%  
% Please acknowledge:
% The GPS Solutions paper that accompanies the original code:
% Software Tools for GNSS Interferometric Reflectometry  
% Carolyn J. Roesler and Kristine M. Larson
% GPS Solutions, Vol 22:80, doi:10.1007/s10291-018-0744-8, 2018

% For cryosphere applications, please also cite:
% Larson, K.M., J. Wahr, and P. Kuipers Munneke, 
% Constraints on Snow Accumulation and Firn Density in Greenland 
% Using GPS Receivers, J. Glaciology, Vol. 61, No. 225, 
% doi:10.3189/2015JoG14J130, 2015

% September 2019
% KL Added Beidou, Galileo, and Glonass

%
% set up environment variables
% IMPORTANT
set_reflection_env_variables
snrc = snrtype;
% make directories for the outputs (SNR files and LSP files)
cyyyy = sprintf('%04d', year );
reflcode=getenv('REFL_CODE');
make_refl_directories(reflcode, cyyyy, station)
addpath Refraction-FirstWay
% assume you want to make the refraction correction
refraction = true;
%refraction = false;

% defaults if the user dos not provide
emin =5;
emax =25;
maxRH = 6;
minRH = 0.5;
minAmp = 7;
pknoiseCrit = 2.7;
emaxpoly = 30;
eminpoly = 5;
% set these to zero in case someone tries to use refraction correction
% but forgets to submit location for the site
lat = 0;
lon = 0;
hell = 0;

% these are the defaults checking azimuths in 45 degree bins
% user can also limit it using varagin
azrange = 45; %  
naz = round(360/azrange);

 
% if you want to vary some of these parameters:
if length(varargin)>0  
  emin = varargin{1};
  emax = varargin{2};
end
  
if length(varargin)>2
  minRH = varargin{3};
  maxRH= varargin{4};
end

if length(varargin)>4
  lat = varargin{5};
  lon = varargin{6};
  hell = varargin{7};
end

if length(varargin)>7
  minAmp = varargin{8};
end

if length(varargin)>8
  naz = 1; % only one azimuth range
  azim1 = varargin{9};
  azim2 = varargin{10};
end


if refraction
  
% only call this once at the top of your Lomb Scargle code.
 % this makes the grid for the station.  only needs to be done once 
   if exist(['gpt2_1wA_' station '.txt'])
      disp('refraction file already exists')
      [Pressure, Temperature] = PT_elev_corr_1site(station,lat,lon,hell,year,doy);
   else
     disp('will attempt to make refraction file for this site')
     if lat == 0 && lon == 0
       disp('no coordinates were provided, so you cannot use the refraction correction')
       refraction = false;
     else
       gpt2_1w_grid_1site(station, lat, lon);
       [Pressure, Temperature] = PT_elev_corr_1site(station,lat,lon,hell,year,doy);
     end
   end
end


fprintf(1,'Using emin: %6.1f \n', emin)
fprintf(1,'Using emax: %6.1f \n', emax)
fprintf(1,'Min RH (m): %6.1f \n', minRH );
fprintf(1,'Max RH (m): %6.1f \n', maxRH );
fprintf(1,'Req RH Amp: %6.1f \n', minAmp);
if refraction 
  fprintf(1,'Simple refraction correction applied \n');
  RefIndex = 1;
else
  fprintf(1,'Refraction correction is not applied \n');
  RefIndex = 0;
end

if naz == 1
    fprintf(1,'Azim Range: %6.1f %6.1f \n', azim1, azim2);
end

satlist = get_satlist(freqtype);

pvf = 3; % polynomial order used to remove the direct signal.
% should be 4 to be consistent with python.
% this can be smaller, especially for short elevation angle ranges.

% the avg_maxRH variable will store  a crude average reflector height 
% for a single day/site
avg_maxRH = [];

% start with the default;
%snrc = 99; % 5-30 degrees
%gps_or_gnss = 1; % 2 would be for multi-GNSS
% makes file for you if you don't have it online
[snrfile, nofile] = make_snr_file(year,doy,station,snrc,gps_or_gnss);
 
if nofile
  disp('SNR file does not exist. Exiting')
 return
end
outputfile = LSP_outputfile(reflcode,station,year,doy,freqtype);  
 
% load the SNR data into variable x, open output file for LSP results
% nofile is a boolean that knows whether data have been found
[fid,x,nofile,fid_reject] = open_filesX(snrfile,outputfile,freqtype);
plt_type = 1; % this value provides a new plot for each azimuth bin
 

% rule of thumb, you should not think you are correctly estimating
% RH when it is less than 2*lambda, which is 40-50 cm, depending on
% the wavelength (l1 vs l2).
 
maxArcTime = 1.25; % one hour and 15 minutes
% 
% Mininum number of points. This value could be used as QC
minPoints = 25; %it is totally arbitrary for now.   
ediff = 2 ; % QC value - different than version 1 
 
desiredPrecision = 0.01; % 1 cm is a reasonable level for now. 
% noise range is calculated between these values.  Currently set to
% RH range - but could be different.
frange = [minRH maxRH]; % this could be input.
   
% make header for the output txt file
output_header(fid);

for a=1:naz
  if plt_type == 1 & plot2screen 
      % one plot per quadrant in azimuth range    
     figure
  end
  % window by these azimuths
  if naz ~= 1  
    azim1 = (a-1)*azrange; azim2 = azim1 + azrange;
  end
  % window by satellite
  for sat = satlist
   % fprintf(1,'Satellite %3.0f Azimuths %3.0f %3.0f\n', sat, azim1, azim2)
    i=find(x(:,2) < emax & x(:,2) > emin & x(:,1) == sat & ...
       x(:,3) > azim1 & x(:,3) < azim2);
   % for the polyfit you use a larger range.
    k=find(x(:,2) < emaxpoly & x(:,2) > eminpoly & x(:,1) == sat & ...
       x(:,3) > azim1 & x(:,3) < azim2);
    % get wavelength factor and column number for SNR data  
   [cf,ic] = get_gnss_freq_scales_v3(freqtype,sat);
   [nr,nc]=size(x);
   % make sure there are enough columns for the frequency you requested
   if length(i) > minPoints & ic <= nc
     w= x(i,:);
     wpoly = x(k,:);
     elevAngles = w(:,2); % elevation angles in degrees
     if refraction
         %changing elevation angles
         [corr_el_deg] = correct_e_angles(elevAngles,Pressure,Temperature);
         elevAngles = corr_el_deg;
     end
     % change SNR data from dB-Hz to linear units
     data = 10.^(w(:,ic)/20);
%    these are UTC hours
     time = w(:,4)/3600;
     meanUTC = mean(time);
     % time span of track in hours
     dt = time(end) - time(1);
%    average azimuth for a track, in degrees
     azm = mean(w(:,3));    
     % remove direct signal. polyfit value does not need to 
     % be as large as this for some arcs.
     elevAnglesPoly = wpoly(:,2);
     dataPoly = 10.^(wpoly(:,ic)/20);      
     p=polyfit(elevAnglesPoly, dataPoly,pvf);
     %
     %p=polyfit(elevAngles, data,pvf);  
     %pv = polyval(p, elevAngles);
     % use the polyfit estimate and apply to restricted elevAngles
     pv = polyval(p,elevAngles);
% sine(elevation angles)
     sineE = sind(elevAngles);
     saveSNR = data-pv; %remove the direct signal with a polynomial
     [sortedX,j] = sort(sineE);
     % sort the data so all tracks are rising
     sortedY = saveSNR(j);
% get the oversampling factor and hifac. see code for more information
    [ofac,hifac] = get_ofac_hifac( elevAngles,cf, maxRH, desiredPrecision);
      
% call the lomb scargle code.  Input data have been scaled so that 
% f comes out in units of RH (reflector heights) in meters
    [f,p,dd,dd2]=lomb(sortedX/cf, sortedY, ofac,hifac);
    % restrict RH by user inputs
    j=find(f > minRH); f=f(j); p = p(j);
    [ RHestimated, maxRHAmp, pknoise ] = peak2noise(f,p,frange);
%  maxRH should be more than 2*lambda, or ~40-50 cm 
% here i am restricting arcs to be < one hour.  long dt usually means  
% you have a track that goes over midnite
    maxObsE = max(elevAngles);
    minObsE = min(elevAngles);   
    if maxRHAmp > minAmp  & dt < maxArcTime & ...
         pknoise > pknoiseCrit & maxObsE > (emax-ediff) & minObsE < (emin+ediff) 
     % changed order of output to be more consistent with python code
     % fprintf(fid,'%4.0f %3.0f %7.3f %6.2f %6.1f %6.0f %3.0f %6.2f %6.2f %6.2f %4.0f %7.3f\n', ...
      %  year,doy,RHestimated,maxRHAmp,azm, sat, dt*60, minObsE, ...
       %   maxObsE, pknoise,freqtype,meanUTC);
      riseSet = 0;      EdotF = 0;  
      dmjd = get_mjd(year,doy,meanUTC);
      fprintf(fid,'%4.0f %3.0f %7.3f %3.0f %6.3f %6.1f %5.1f %5.2f %5.2f %6.0f %3.0f %2.0f %2.0f %7.2f %5.2f %13.6f %1.0f\n', ...
        year,doy,RHestimated,sat, meanUTC, azm, maxRHAmp, minObsE, maxObsE,  ...
        length(data),freqtype, riseSet, EdotF, pknoise,dt*60,dmjd,RefIndex);
    
      simple_plots(plot2screen, plt_type, sineE, saveSNR,f,p);
      % save the values if needed for the summary plot
      avg_maxRH = [avg_maxRH; RHestimated];
     
    else 
      fprintf(fid_reject,'%s RH %6.2f Amp %6.2f Azm %6.1f Sat %2.0f Tdiff %4.0f Emin %6.2f Emax %6.2f Peak2Noise %6.2f \n', ...
       'Fail QC',RHestimated,maxRHAmp,azm, sat, dt*60, minObsE, ...
        maxObsE, pknoise);
     
    end % did you pass QC test loop
   end %do you have enough points loop
  end % satellite loop
  if plot2screen 
    plot_labels( plt_type, station, [azim1 azim2],freqtype);
  end
end % azimuth loop
fclose(fid); fclose(fid_reject);


