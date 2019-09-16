function [ Pressure, Temperature] = PT_elev_corr_1site(station,lat,lon,hell,year,doy)
%function [ Pressure, Temperature] = PT_elev_corr_1site(station,lat,lon,hell,year,doy)
% BASED on   PT_elev_corr.m : kristine larson, January 2018
% code to correct for refraction using VMF values of pressure/temperature
% it uses the reduced pressure temp grid for  one station 
%                gpt2_1w_station.txt 
% instead of the complete world grid  gpt2_1wA.grd
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
%it = 1;           % 0 means GPT2 with time variation, 1 means static
% put in time variation
it = 0;           % 0 means GPT2 with time variation, 1 means static
%dmjd = 56141.d0; % sample

% change to radians
dlat = lat*pi/180;
dlon = lon*pi/180;

% use daynum to go from doy to month and day
[a,b,c] = daynum(year, doy);
dmjd = mjuliandate(year,b,c); %modified julian date.
fprintf(1,'MJD %8.0f \n', dmjd);
% We call GPT2
% The preferred option is the one degree grid
[Pressure,Temperature,dT,Tm,e,ah,aw,lambda,undu] = ...
     gpt2_1w_1site(station, dmjd,dlat,dlon,hell,it);
fprintf(1,'Pressure %8.2f Temperature %8.2f \n', Pressure, Temperature);


end

