% DAYNUM - Daynumber and date calculation
% [nday] = daynum returns the current daynumber
% [nday] = daynum(xdate) returns the daynumber for serial date xdate
% [nday] = daynum(YR,MO,DD) returns the daynumber
% [YR MO DD] = daynum(YEAR,DAYNUMBER) returns the date 
function [y1,y2,y3]= daynum(x1,x2,x3);

% No inputs; return current daynumber
if nargin == 0
   x = datevec(now);
   y1 = datenum(x(1),x(2),x(3)) - datenum(x(1),0,0);
% 1 Input: serial datenumber; compute daynumber
elseif nargin == 1
   x = datevec(x1);
   y1 = datenum(x(1),x(2),x(3)) - datenum(x(1),0,0);
% 2 Inputs: year-daynumber; compute year-month-day
elseif nargin == 2
	xdate = datenum(x1,0,0) + x2;
   [y1 y2 y3 hr mi s] = datevec(xdate);   
% 3 Inputs: year-month-day; compute daynumber
elseif nargin==3   
   y1 = datenum(x1,x2,x3)- datenum(x1,zeros(size(x2)),zeros(size(x2)));
   y2 = []; 
   y3 = [];
end

