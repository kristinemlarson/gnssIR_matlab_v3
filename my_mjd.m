function mjd = my_mjd(y,m,d,hour,minute,second);
%function mjd = my_mjd(y,m,d,hour,minute,second);
%  inputs: year, month, day, hour, minute,second
%  output: modified julian day
%  
% First get the Julian date, using Vallado's equation-
% this is based on ellliot barlow's version
% restore the inputs as a vector
date(1) = y;
date(2) = m;
date(3) = d;
date(4) = hour;
date(5) = minute;
date(6) = second;
sec_count = 60; % leap second not being used here, so it is 60

jd = date(1)*367 - floor((7*(date(1) + floor((date(2)+9)/12)))/4) + ...
    floor(275 * date(2)/9) ...
    + date(3) + ...
    1721013.5 + ...
    ((((date(6)/60) + date(5))/sec_count)+date(4))/24;

mjd = jd - 2400000.5;
 

end