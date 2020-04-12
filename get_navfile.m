function fexist = get_navfile(cyyyy,cdoy)
%function fexist = get_navfile(cyyyy,cdoy)
% inputs are character strings for year and day of year
% which must be 4 and 3 characters long, respectively
%
% the code was modified 2020 April 12
% first look at CDDIS, then the NGS, then SOPAC
% unavco is no longer used as an archive for nav messages
%  
% returns boolean with file existence
% author: kristine larson
fexist = false;
cyy = cyyyy(3:4);
% file will always be stored with station name auto
% always lowercase
autoname = ['auto' cdoy '0.' cyy 'n'];
% executable to get files
wgetexe=getenv('WGET');

sopac =  ['ftp://garner.ucsd.edu/pub/rinex/' cyyyy '/' cdoy '/'];
unavco = ['ftp://data-out.unavco.org/pub/rinex/nav/' cyyyy '/' cdoy '/'];
cddis = ['ftp://cddis.nasa.gov/gnss/data/daily/' cyyyy '/' cdoy '/' cyy 'n/'];

bigDisk_in_MD = ['ftp://geodesy.noaa.gov/cors/rinex/' cyyyy '/' cdoy '/'];

try
     navname = ['brdc' cdoy '0.' cyy 'n'];
     url = [cddis navname '.Z'];
     unix([wgetexe ' ' url]);
     unix(['uncompress ' navname '.Z']);
     unix(['mv ' navname ' ' autoname]);
catch
  disp('prob at CDDIS')
  
  try
     navname = ['brdc' cdoy '0.' cyy 'n'];
     disp('try the big disk in maryland');
     url = [bigDisk_in_MD navname '.gz'];
     unix([wgetexe ' ' url]);
     unix(['gunzip ' navname '.gz']);
     unix(['mv ' navname ' ' autoname]);
  catch
    disp('problem with the big disk in Maryland')
  end
end 
% try sopac as last resort
if ~exist(autoname)
    disp('will look at SOPAC')
    try
      navname = autoname;
      url = [sopac navname '.Z'];
      unix([wgetexe ' ' url]);
      unix(['uncompress ' navname '.Z']);
      % don't need to move file because they use the convention I want. 
       
    catch
      disp('problem at SOPAC')
      unix(['rm -f  ' navname '.Z']);      
    end
end
if exist(autoname)
    fexist = true;
end
      
%  navname = ['sc02' cdoy '0.' cyy 'n'];
%   url = [unavco navname '.Z'];
%   unix([wgetexe ' ' url]);
%   unix(['uncompress ' navname '.Z']);
%   unix(['mv ' navname ' ' autoname]);
