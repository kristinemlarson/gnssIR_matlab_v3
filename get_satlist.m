function satlist = get_satlist(freqtype);
% for a given frequency, return the allowed satellite list
% f=20 is a fake frequency which only returns current list of L2C
% satellites
% author: kristine m. larson
if freqtype < 6
  satlist = 1:32; % use all GPS satellites, f=5 is less than this list
elseif freqtype == 20 % L2C satellites - 
    % 4 is the most first GPS III, but it has not been set healthy, so
    % it is not listed here.
  satlist=[1 3 5:10  12 15 17 24:29 30:32 ];
elseif freqtype > 100 & freqtype < 200 % glonass
  satlist=101:124; % i think there are only 24 legal glonass satellites
elseif freqtype > 200 & freqtype < 299 % galileo
  satlist=201:250;
elseif freqtype > 300 & freqtype < 399 % beidou
  satlist=301:350;  
end
