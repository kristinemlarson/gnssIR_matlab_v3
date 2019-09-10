function [ filename, year, doy, station, outputfile ] = pickup_snr_files( whichfile,f)
%function [ filename, year, doy, station, outputfile ] = pickup_snr_files( whichfile,f)
% this function is for the GNSS-IR software demo
% Author: Kristine Larson, February 2018
% when you convert it to a more useful function it should create the 
% filename from the station name, year, and doy.
% my RINEX translation code assumes day of year (doy) is 3 characters long
% so day 2 is 002
% also inputs frequency choice (f) so that the outputfile name includes 
% this information
% 
% default - nofile is false.
nofile = false;
if whichfile == 1
  filename = 'rec10010.10.snr99'; % Recovery Lake, Antarctica use L1.
  year = 2010; doy = 1;
elseif whichfile == 2
  filename = 'gls23650.17.snr99'; % GLISN site, to see what L2C looks like
  year = 2017; doy = 365;
elseif whichfile == 3
  filename = 'p0380010.18.snr99'; % flat site. no ice/snow
  year = 2018; doy = 1;
elseif whichfile == 4
  filename = 'gls21390.13.snr99'; % example from J. Glaciology paper
  year = 2013; doy = 139;
elseif whichfile == 5
  filename = 'gls21440.13.snr99'; % example from J. Glaciology paper
  year = 2013; doy = 144;
else
    disp('no file picked up')
    nofile = true;
    station = ''; outputfile = ''; year = 2000; doy = 1;
end
if ~nofile
  station = filename(1:4);
  cdoy = filename(5:7); cyr = num2str(year);
  % include frequency on the output file name
  outputfile = [station '_' cyr '_' cdoy '_L' num2str(f) '.txt'];
end
end

