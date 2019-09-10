% Authors: Kristine M. Larson & Carolyn J. Roesler
% http://kristinelarson.net
% April 16, 2018
% sample_gnss_ir.m

% This code is meant to help newcomers generate "reflector heights"
% from GNSS SNR data.  Sample datafiles are provided. This code reads
% those files and generates Lomb Scargle Periodograms.

 
% Please acknowledge:
% The GPS Solutions paper that accompanies this code:
% Software Tools for GNSS Interferometric Reflectometry  
% Carolyn J. Roesler and Kristine M. Larson
% GPS Solutions, Vol 22:80, doi:10.1007/s10291-018-0744-8, 2018

% For cryosphere applications, please also cite:
% Larson, K.M., J. Wahr, and P. Kuipers Munneke, 
% Constraints on Snow Accumulation and Firn Density in Greenland 
% Using GPS Receivers, J. Glaciology, Vol. 61, No. 225, 
% doi:10.3189/2015JoG14J130, 2015


% This code should not be seen as the final word on picking 
% proper inputs for your own GNSS-IR 
% experiment. Picking the proper azimuths and elevation angles is site dependent.
% Here we start with all azimuths (0-360 in 45 degree slots) and usually 
% 5-20 for the elevation angles. This is appropriate for many Greenland 
% and Antarctica sites.

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
%  4. you don't want double peaks
%  5. you (generally) don't want a satellite track that both rises and
%        sets. 
% I have currently set a default of peak being 3.5 times larger than the 
% noise, but this is just to get you started.  This assumes you have picked
% a relevant interval to calculate the noise over. 
% 
% I strongly encourage you to look at your SNR data before
% you start automating things. This code allows you to do that.

% 19sep07 Added some code to allow access to making SNR files and 
% semi-automated processing.

clear 
close all
satlist = 1:32; % use all GPS satellites
LW = 2 ; % linewidth for quadrant plots
comL = '%';
pvf = 3; % polynomial order used to remove the direct signal.
% this can be smaller, especially for short elevation angle ranges.

% the avg_maxRH variable will store  a crude median reflector height 
% for a single day/site
avg_maxRH = [];
% you can turn off all the plots by changing this to false.
plot2screen = true; 

% pick up files
[filename, year, doy, station, outputfile,freqtype,nofile] = sample_files();
if nofile
  return
end
 

% ask if you want l2c satellites  
% note - this just selects L2C satellites. It does not mean your 
% snr file has L2C data in it.
if freqtype == 2
  ok = input('would you like only L2C ? y/n','s');
  if strmatch(ok,'y')
    satlist=[1 3 5:10  12 15 17 24:29 30:32 ];
    % this is not up to date, i.e. the recent GPS III launches
  end
end

% load the SNR data into variable x, open output file for LSP results
% nofile is a boolean that knows whether data have been found
[fid,x,nofile] = open_filesX(filename,outputfile,freqtype);

if nofile
  return
end
% pick the kind of plots you want.
disp('0. Plots for all azimuths together')
disp('1. Separate plots by azimuth bin');
plt_type = input('Plot choice: ');
 

% rule of thumb, you should not think you are correctly estimating
% RH when it is less than 2*lambda, which is 40-50 cm, depending on
% the wavelength (l1 vs l2).
minRH   = 0.4; % meters
maxArcTime = 1; % one hour 
% 
% Mininum number of points. This value could be used as QC
minPoints = 25; %it is totally arbitrary for now.   

% allow users to analyze their own files or vary defaults
idef = input('do you want to use default values for elevation cutoffs, QC, (y/n) ','s');

if strmatch(idef,'y');
 % My default elevation angles are usually 5 and 25.  
 % Often station operators use an elevation mask - which is not needed,
 % as a data analyst also sets an elevation mask. In our opinion, the mask
 % should be applied at the analysis stage, not at the data collection
 % stage.
 
 % polar sites had an elevation mask - so here we acknowledge that.
  if strmatch(station,['gls2';'rec1'])
   emin = 7; emax = 20; 
  else
   emin = 5; emax = 25; 
  end

% ediff is the elevation angle different for a given track.
% This variable is a QC metric because 
% you don't want a bunch of tiny arcs as these periodograms 
% can be very unreliable.
% If you wanted to use data between elevation angles of 
% 5 and 10 degrees, for example, you would have to change it.
  ediff = 10 ;

 
  maxHeight = 8; % (i.e. exclude reflector heights beyond this value)
  desiredPrecision = 0.005; % 5mm is a reasonable level for now. 
  frange = [0 5]; % noise range is calculated between 0 and 5 meters.
  if strmatch(station,'sg27')
      % taller monument, so different range
      frange = [2 7];
  end

else
  maxHeight = input('What is largest H_R value (m) you want to estimate');
  desiredPrecision=input('Precision of retrieval (m)');
  emin =input('Minimum elevation angle (degrees)');
  emax =input('Maximum elevation angle (degrees)');
  frange =input('Noise calculated over this range (m) e.g. [0 6]');
  
  ediff = input('What is the minimum elevation angle difference you require');
  if emax < emin
    disp('Emax has to be bigger than Emin');
    return
  end
  if maxHeight < 0
    disp('Max Reflector Height has to be positive')
    return
  end
end

% get additional QC levels and print them to the screen
[minAmp,pknoiseCrit,frange ] = quicky_QC(freqtype, maxHeight, ...
    desiredPrecision, ediff,frange);

% get wavelength factor (lambda/2) and column where data are stored (ic)
[cf,ic] = get_waveL(freqtype);
% make header for the output txt file
output_header( fid );

% checking azimuths in 45 degree bins
azrange = 45; %  
naz = round(360/azrange);
for a=1:naz
  if plt_type == 1 & plot2screen 
      % one plot per quadrant in azimuth range    
     figure
  end
  % window by these azimuths
  azim1 = (a-1)*azrange;
  azim2 = azim1 + azrange;
  % window by satellite
  for sat = satlist
    i=find(x(:,2) < emax & x(:,2) > emin & x(:,1) == sat & ...
       x(:,3) > azim1 & x(:,3) < azim2);
   % in some cases you have both ascending and descending arcs
   % in one azimuth bin that will fulfill this find statement, 
   % but for cryosphere applications
   % it probably won't hurt you too much
    
   if length(i) > minPoints
     w= x(i,:);
     elevAngles = w(:,2); % elevation angles in degrees
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
     p=polyfit(elevAngles, data,pvf);  
     pv = polyval(p, elevAngles);
% sine(elevation angles)
     sineE = sind(elevAngles);
     saveSNR = data-pv; %remove the direct signal with a polynomial
     [sortedX,j] = sort(sineE);
     % sort the data so all tracks are rising
     sortedY = saveSNR(j);
% get the oversampling factor and hifac. see code for more information
    [ofac,hifac] = get_ofac_hifac( elevAngles,cf, maxHeight, desiredPrecision);
      
% call the lomb scargle code.  Input data have been scaled so that 
% f comes out in units of reflector heights    (meters)
    [f,p,dd,dd2]=lomb(sortedX/cf, sortedY, ofac,hifac);
    [ maxRH, maxRHAmp, pknoise ] = peak2noise(f,p,frange);
%  maxRH should be more than 2*lambda, or ~40-50 cm 
% here i am restricting arcs to be < one hour.  long dt usually means  
% you have a track that goes over midnite
    maxObsE = max(elevAngles);
    minObsE = min(elevAngles);   
    if maxRHAmp > minAmp & maxRH > minRH  & dt < maxArcTime & ...
            pknoise > pknoiseCrit & (maxObsE-minObsE) > ediff;
      fprintf(fid,'%4.0f %3.0f %6.2f %6.2f %6.1f %6.0f %3.0f %6.2f %6.2f %6.2f %4.0f %5.2f\n', ...
          year,doy,maxRH,maxRHAmp,azm, sat, dt*60, minObsE, ...
          maxObsE, pknoise,freqtype,meanUTC);
      if plot2screen
        if plt_type == 1 
          subplot(2,1,1) % raw SNR data
          plot(asind(sineE), saveSNR, '-','linewidth',LW);  hold on;        
          subplot(2,1,2) % periodogram
          plot(f,p,'linewidth',LW) ; hold on;
        else
       % plot all the periodograms on top of each other in gray
         subplot(2,1,1)
         plot(f,p,'color',[0.5 0.5 0.5]); hold on;   
        
        end  
      end
      avg_maxRH = [avg_maxRH; maxRH];
     % freq units on x-axis will be reflector heights (meters) 
     % amplitude units on y-axis will be volts/volts
    else 
      fprintf(1,'%s RH %6.2f Amp %6.2f Azm %6.1f Sat %2.0f Tdiff %4.0f Emin %6.2f Emax %6.2f Peak2Noise %6.2f \n', ...
          'Fail QC',maxRH,maxRHAmp,azm, sat, dt*60, minObsE, ...
          maxObsE, pknoise);
    end % did you pass QC test loop
   end %do you have enough points loop
  end % satellite loop
  if plot2screen 
    plot_labels( plt_type, station, [azim1 azim2],freqtype)
  end
end % azimuth loop
if plot2screen & plt_type == 0
  plot_labels( plt_type, station, [0 360], freqtype)
end


% if you are making one summary plot, figure out the median RH
% and plot it as a magenta vertical line.
median_RH( plt_type, avg_maxRH, plot2screen )
fclose(fid);
