function get_rinex(rinexfilename)
% inputs  rinex filename
% this function will look for your rinex files at SOPAC and UNAVCO.
% low rate only.
% author: kristine larson
% date: September 16, 2019
% searches only SOPAC and UNAVCO
sopac = 'ftp://garner.ucsd.edu/pub/rinex/';
unavco = 'ftp://data-out.unavco.org/pub/rinex/obs/';

% Hatanaka compression code is stored here
exe=getenv('EXE');
% can't get wget to show up when using bash (works fine with csh)
wgetexe=getenv('WGET');


cmprinexfilename = [rinexfilename(1:end-1) 'd'];
cyyyy = ['20' rinexfilename(10:11)];
cdoy = rinexfilename(5:7);

try
  url = [unavco  cyyyy  '/' cdoy '/' cmprinexfilename '.Z'];
  unix([wgetexe ' ' url]);
      % uncompress and convert to normal rinex
  if exist([cmprinexfilename '.Z'])
    unix(['uncompress ' cmprinexfilename '.Z']);
  end
  if exist(cmprinexfilename)
        unix([exe '/CRX2RNX ' cmprinexfilename]);
  end      
catch
   disp('could not get RINEX from UNAVCO')
end  

if exist(rinexfilename)
    disp('success at UNAVCO')
else
  try
    disp('look first at SOPAC')
    url = [sopac cyyyy  '/' cdoy '/' cmprinexfilename '.Z'];
    unix([wgetexe ' ' url]);
    if exist([cmprinexfilename '.Z'])
      unix(['uncompress ' cmprinexfilename '.Z']);
    end  
    if exist(cmprinexfilename)
      unix([exe '/CRX2RNX ' cmprinexfilename]);
    end
  catch
     disp('some problem getting the RINEX file from SOPAC')
  end
    
end
% remove compressed file to keep things cleaned up
if exist(cmprinexfilename)
   unix(['rm -f ' cmprinexfilename]);
end
