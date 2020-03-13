function  [fname,fexist] = get_gnss_sp3( year,doy )
% author: kristine larson
% retrieves GFZ sp3 orbit files which have all signals
% inputs are year, day of year  
% returns filename and existence
% 
fexist = false;
cdoy = sprintf('%03d', doy );
cyyyy = sprintf('%04d', year );
[y,m,d] = daynum(year,doy);
wgetexe=getenv('WGET');
orbits =getenv('ORBITS');

[file1,file4] = igsname(year,doy,'gbm');
% so it doesn't crash if the sp3 file does not exist, 
% you need to give fname a default value
fname = file1

file2 = [file1 '.gz'];
 
 
[GPS_wk, GPS_sec_wk] = GPSweek(y,m,d,0,0,0);
cweek=num2str(GPS_wk);
dayOfweek = num2str(round(GPS_sec_wk/86400));
file3 = [file4 '.Z'];
 

%where the files live at CDDIS
cddis = 'ftp://cddis.nasa.gov';
dirlocation = ['/gps/products/mgex/'  cweek   '/'];
url = [cddis  dirlocation  file2];  
unix([wgetexe ' ' url]);
if exist(file2)
    disp('found new file')
    unix(['gunzip ' file2]);
else
    disp('did not find new file, try old file')
    url = [cddis  dirlocation  file3];  
    unix([wgetexe ' ' url]);
    if exist(file3)
       unix(['uncompress ' file3]);
    end
end


% make sure the output directories exist
if ~exist([orbits '/' cyyyy])
     unix(['mkdir ' orbits '/' cyyyy ]);
end
if ~exist([orbits '/' cyyyy '/sp3'])
    unix(['mkdir ' orbits '/' cyyyy '/sp3']);
end
 
if exist(file1)
    fexist = true;
    fname = file1;
    unix(['mv ' file1 ' ' orbits '/' cyyyy '/sp3']);
end

if exist(file4)
   fexist = true;
   disp('it exists')
   unix(['mv ' file4 ' ' orbits '/' cyyyy '/sp3']);
   fname = file4;
end
