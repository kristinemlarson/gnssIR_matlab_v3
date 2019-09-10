%running multiple days for a station

% required inputs
station = 'p038';
year = 2019;
% doy is in the loop
freq = 1; % frequency
snrtype = 99;
plot2screen = true;

% these are optional (varargin) inputs - which need to be in this order
emin =5; emax = 25;
h1=0.5; h2=6;
azim1 = 45;
azim2 = 90; 
minAmp = 8;


for doy=62:62
  gnssIR_lomb(station, year, doy,freq,snrtype,plot2screen,emin,emax,h1,h2);
   
end