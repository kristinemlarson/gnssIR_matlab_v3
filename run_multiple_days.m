% sample code for running multiple days for a station
% author: kristine m. larson
% september 13, 2019

% required inputs
clear all
station = 'p041';
year = 2019;
% doy is in the loop
freq = 1; % frequency 
% snrtype is for RINEX translation - basically the number tells you
% which elevation angles to save
% 99 is most common (elev between 5-30).  also allow
% 66 elev < 30
% 88 all elev data
% 50 is elev < 10, for tall sites, which requires high-rate RINEX
snrtype = 99; % 
plot2screen = false;
%
% 1 is for GPS only, 2 for GNSS. Just changes the orbit type used in
% computing the orbits used when translating the contents of the RINEX 
% file.  You can use GNSS for a GPS only file/station
% GPS orbits are availalbe almost immediate. GNSS not so, a few days.
% so if you are doing real-time, you will need another solution
gps_or_gnss = 1;

% these are optional (varargin) inputs - which need to be in this order
emin =5; emax = 25;
h1=0.5; h2=6;

% if you want a refraction correction, you need to provide 
% a lat/long/ellipsoidal ht
% there are no automated values in a database - you have to take care of it
  
lat = 39.9490 ; lon=  -105.1940; hell= 1728.856;
    
% 

for doy=120:150
  gnssIR_lomb(station, year, doy,freq,snrtype,plot2screen,...
      gps_or_gnss, emin,emax,h1,h2,lat,lon,hell);
   
end