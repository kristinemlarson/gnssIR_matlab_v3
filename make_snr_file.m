function [finalsnr, nofile] = make_snr_file(year,doy,station,snrc,gps_or_gnss);
%function [finalsnr, nofile] = make_snr_file(year,doy,station,snrc,gps_or_gnss);
% inputs:
% year, day of year (doy), station name (4 char)
% snr_choices allowed are 99, 66, 88, or 10
% gps_or_gnss = 1 is GPS and 2 is GNSS
%
% author: kristine larson, 2019 Sep 6
% assume it fails
nofile = true;
% compute character versions of year and day of year. useful for file names
cdoy = sprintf('%03d', doy );
cyyyy = sprintf('%04d', year );
cyy = sprintf('%02d', year-2000 );


% this will allow access to gpsSNR.e and gnssSNR.e
exe=getenv('EXE');
% store the orbits for future use
orbits=getenv('ORBITS');
% store the snr files for future use
reflcode=getenv('REFL_CODE');
% can't get wget to show up when using bash (works fine with csh)
wgetexe=getenv('WGET');

sopac = 'ftp://garner.ucsd.edu';
% output - assume they will be in your main directory for now
snrfilename = [station cdoy '0.' cyy '.snr' num2str(snrc)];
snrdirname = [reflcode '/' cyyyy '/snr/' station];


% make directories for the outputs (SNR files and LSP files)
% a bit redundant as also called from main code
make_refl_directories(reflcode, cyyyy, station)
 
% name of rinex and compressed rinex 
rinexfilename = [station cdoy '0.' cyy 'o'];
cmprinexfilename = [station cdoy '0.' cyy 'd'];

% where the orbits shall live
navfiledir = [orbits '/' cyyyy '/nav/'];
navname = ['auto' cdoy '0.' cyy 'n'];
navfile = [navfiledir navname];
finalsnr = [snrdirname '/' snrfilename];

if ~exist(finalsnr)
  disp('The SNR file does not exist. Will try to make it')
  if exist(rinexfilename)
    disp('found rinex')
    disp(rinexfilename)
  else
    disp('will try to download rinex')
    get_rinex(rinexfilename)
  end
  if gps_or_gnss == 1
    if exist([navfiledir '/' navname])
      disp('found the nav file')
    else
      disp('will try to find the navfile')
      navexist = get_navfile(cyyyy,cdoy);
      if navexist
        unix(['mv ' navname ' ' navfiledir]);
      end
    end
  else
    filedir = [orbits '/' cyyyy '/sp3/'];
    file1 = [filedir 'GFZ0MGXRAP_'  cyyyy cdoy '0000_01D_05M_ORB.SP3'];
    if ~exist(file1)
      fexist = get_gnss_sp3( year,doy );
    end
        
  end
  
  if exist(rinexfilename)
      if gps_or_gnss == 2
        if exist(file1)  
          dd = [exe '/gnssSNR.e ' rinexfilename ' ' finalsnr  ' ' file1 ' ' num2str(snrc) ];
          unix(dd);
        end
      else
        if exist(navfile)
          dd = [exe '/gpsSNR.e ' rinexfilename ' ' finalsnr ' ' navfile ' ' num2str(snrc) ];
          unix(dd);
        end
      end  
      % clean up after yourself and rm the rinex files (both kinds)
      unix(['rm -f ' rinexfilename]);
  else
      disp('rinex file does not exist')
  end
end

% return boolean to main code as to file existence.
if exist(finalsnr)
    nofile = false;
end

 
