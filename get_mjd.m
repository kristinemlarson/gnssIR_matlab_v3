function dmjd = get_mjd(year, doy, meanUTC);
% inputs are year, day of year, and decimal hours (meanUTC)
% Note: hours are actually in GPS time, so they will be off by
% 15-20 seconds or so
% returns modified julian date
% wrote this to avoid using mjuliandate, which is in the aerospace toolbox
% kristine m. larson

% for goofy times
if meanUTC > 24 
    fprintf(1,'Bad UTC value %7.2f Setting to zero \n', meanUTC);
    meanUTC = 0;
end
if meanUTC < 0
    fprintf(1,'Bad UTC value %7.2f Setting to zero \n', meanUTC);
   meanUTC = 0;
end
% get month and day;
[yy,mm,dd] = daynum(year, doy);
        
hh=floor(meanUTC);
minutesD = 60*(meanUTC - hh); % decimal minutes
minutes = floor(60*(meanUTC - hh));
seconds = round(60*(minutesD - minutes));

%modified julian date, mostly for tide people
%this is in the aerospace toolbox, thus not accessible
%replacing with something i found online.
%dmjd = mjuliandate(year,mm,dd, hh, minutes, seconds); 
dmjd = my_mjd(year,mm,dd, hh, minutes, seconds); 

end
