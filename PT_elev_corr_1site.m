function [ Pressure, Temperature] = PT_elev_corr_1site(station,lat,lon,hell,year,doy)
%function [ Pressure, Temperature] = PT_elev_corr_1site(station,lat,lon,hell,year,doy)
% BASED on   PT_elev_corr.m : kristine larson, January 2018
% code to correct for refraction using VMF values of pressure/temperature
% it uses the reduced pressure temp grid for  one station 
%                gpt2_1w_station.txt 
% instead of the complete world grid  gpt2_1wA.grd
% KL 2019 Oct 5, removed aerospace toolbox requirement for MJD
% -----------------------------------------------------------------
% inputs
%   station : station name usually 4 lower case 
%  lat : latitude (deg) [ -90 90] ,
%  lon:  longitude(deg) [ -180-180] or [ 0 360]  
%  hell: ellipsoidal height (m),
%  year
%  doy: day of year
%
% outputs
%     Pressure and Temperature (HPa  and Celsius)
%
%--------------------------------------------------------
% CR 18mar30
%  NB: PROBLEM CR 18mar30 if the reduced grid file
%        $PRODUCTS/station/eo/gpt2_1w_station.txt
%  does not exists or cannot be created the output will be empty
%         Pressure[] Temperature =[]
%     
%----------------------------------------------------------
nstat = 1;        % we do the calculations for nstat stations, i.e. one
% although it would make more sense to allow time variation, i have not
% had time to extensively test it.  this at least removes the large bias
% you will see at very tall sites. it will NOT have a big effect at 2-3
% meter sites.
it = 1;           % 0 means GPT2 with time variation, 1 means static
% put in time variation
%it = 0;           % 0 means GPT2 with time variation, 1 means static

%dmjd = 56141.d0; % sample

% change latitude and longitude to radians
dlat = lat*pi/180;
dlon = lon*pi/180;

% use daynum to go from doy to month and day
[a,b,c] = daynum(year, doy);
% MJD code i converted from Elliot Barlow's code (I think)
dmjd = my_mjd(year,b,c,0,0,0);
% old code that required the aerospace toolbox
% dmjd = mjuliandate(year,b,c); %modified julian date.
fprintf(1,'MJD %8.0f \n', dmjd);
% We call GPT2
% The preferred option is the one degree grid
[Pressure,Temperature,dT,Tm,e,ah,aw,lambda,undu] = ...
     gpt2_1w_1site(station, dmjd,dlat,dlon,hell,it);
%fprintf(1,'Pressure %8.2f Temperature %8.2f \n', Pressure, Temperature);


end

