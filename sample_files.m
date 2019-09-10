function [ filename, year, doy, station, outputfile,freqtype,nofile] = sample_files( )
% function [ filename, year, doy, station, outputfile,freqtype,nofile ] = sample_files( )
% user for the tutorial either uses a provided sample file or inputs
% information for their own files.
% outputs are filename (SNR)
% year 
% doy
% outputfile is a txt file to save the LSP outputs
% freqtype is 1,2,or 5
% 
% Author: Kristine M. Larson

nofile = false;
% dummy values:
outputfile = ''; freqtype = 0; year = 0; doy = 0; station = ''; 
filename = '';

fprintf(1,'input files to test (input the number)\n');
fprintf(1,'1: Antarctica, Recovery Lake, REC1, only use L1 \n');
fprintf(1,'2. Greenland, GLS2, use L1 or L2C  \n');
fprintf(1,'3. New Mexico, P038, Favorite flat site, Recommend using L2C \n') ;
fprintf(1,'4. Greenland, GLS2 May 19, 2013, only use L1, J. Glaciology, Fig. 2 \n') ;
fprintf(1,'5. Greenland, GLS2 May 24, 2013, only use L1, J. Glaciology, Fig. 2 \n') ;
fprintf(1,'6. Barrow Alaska, SG27 January 1, 2018, only use L1 \n') ;
fprintf(1,'7. My own file \n') ;
whichfile = input('Make a file choice: ');
if whichfile > 7 | whichfile < 1
    disp('Illegal file input');
    return
end


if whichfile == 1
  % REcovery Lake, Antarctica
  station = 'rec1'; year = 2010; doy = 1;
elseif whichfile == 2
  % GLISN site, to see what L2C data look like
  station = 'gls2'; year = 2017; doy = 365;
elseif whichfile == 3
  % flat site, no ice/snow, use L2C
  station = 'p038'; year = 2018; doy = 1;
elseif whichfile == 4
   % example from J. Glaciology paper, Figure 2
  station = 'gls2'; year = 2013; doy = 139;
elseif whichfile == 5
  % example from J. Glaciology paper, Figure 2
  station = 'gls2';year = 2013; doy = 144;
elseif whichfile == 6
  % Barrow Alaska
  station = 'sg27';year = 2018; doy = 1;
else
  % input your own site
  station = input('station','s');
  year = input('year');
  doy = input('day of year');
end
% create station name using my convention.  You can add a directory
% structure if you prefer
% this assumes snr99 files - but you can modify to allow different
% ones
cdoy = sprintf('%03d', doy );
cyr = sprintf('%04d', year );
cyr2 = sprintf('%02d', year-2000 );


filename = [station cdoy '0.' cyr2 '.snr99'];

if ~exist(filename)
  disp('SNR file does not exist. Exiting.')
   outputfile = ''; freqtype = 0; % return dummy values
   nofile = true;
  return
else
  fprintf(1,'SNR data should be in : %s \n', filename);

  freqtype = input('frequency (1,2,and 5 are allowed) \n');
  if ~ismember(freqtype, [1 2 5])
    disp(['Illegal frequency type: ' num2str(freqtype) ' Exiting'])
    nofile = true;
    return
  end 
  outputfile = [station '_' cyr '_' cdoy '_L' num2str(freqtype) '.txt'];
  fprintf(1,'LSP Output will go to : %s \n', outputfile);

end
