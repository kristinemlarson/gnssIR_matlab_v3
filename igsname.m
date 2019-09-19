function [file1,file2] = igsname(year,doy,analysisCtr)
cdoy = sprintf('%03d', doy );
cyyyy = sprintf('%04d', year );
[y,m,d] = daynum(year,doy);

file1 = ['GFZ0MGXRAP_'  cyyyy cdoy '0000_01D_05M_ORB.SP3'];
 
[GPS_wk, GPS_sec_wk] = GPSweek(y,m,d,0,0,0);
cweek=num2str(GPS_wk);
dayOfweek = num2str(round(GPS_sec_wk/86400));
file2 = [analysisCtr cweek dayOfweek '.sp3'];
end
