function  fexist = get_gnss_sp3( year,doy )
% author: kristine larson
% retrieves GFZ sp3 orbit files which have all signals
% inputs are year, day of year   
% 
fexist = false;
cdoy = sprintf('%03d', doy );
cyyyy = sprintf('%04d', year );
[y,m,d] = daynum(year,doy);
wgetexe=getenv('WGET');
orbits =getenv('ORBITS');

file2 = ['GFZ0MGXRAP_'  cyyyy cdoy '0000_01D_05M_ORB.SP3.gz'];
file1 = ['GFZ0MGXRAP_'  cyyyy cdoy '0000_01D_05M_ORB.SP3'];

[GPS_wk, GPS_sec_wk] = GPSweek(y,m,d,0,0,0);
cweek=num2str(GPS_wk);
%where the files live at CDDIS
cddis = 'ftp://cddis.nasa.gov';
dirlocation = ['/gps/products/mgex/'  cweek   '/'];
url = [cddis  dirlocation  file2];  
unix([wgetexe ' ' url]);
if exist(file2)
    unix(['gunzip ' file2]);
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
    unix(['mv ' file1 ' ' orbits '/' cyyyy '/sp3']);
end