function quickLook(station,year,doy,freq);
%function quickLook(station,year,doy,freq);
% analogous to python code - will do a quick and dirty asessment
% of a site's reflection characteristics in 45 degree azimuth bins.
% inputs are station name, year, day of year, and frequency (freq)
 
% author: kristine m. larson
% september 16, 2019

% this file type restricts you to 5-30 degrees
snrtype = 99; % 
plot2screen = true;

%GPS only for quickLook
gps_or_gnss = 1;

% the defaults for elevation angle limits and reflector heights
emin =5; emax = 25;
h1=0.5; h2=6;

gnssIR_lomb(station, year, doy,freq,snrtype,plot2screen,...
      gps_or_gnss, emin,emax,h1,h2);
   
