function [p,T,dT,Tm,e,ah,aw,la,undu] = gpt2_1w_1site(station,dmjd,dlat,dlon,hell,it)

%function [p,T,dT,Tm,e,ah,aw,la,undu] = ...
%                      gpt2_1w_1site(station,dmjd,dlat,dlon,hell,it)
% input parameters:
% station :  station name 
% dmjd:  modified Julian date (scalar, only one epoch per call is possible)
% dlat:  ellipsoidal latitude in radians [-pi/2:+pi/2] (vector)
% dlon:  longitude in radians [-pi:pi] or [0:2pi] (vector)
% hell:  ellipsoidal height in m (vector)
% it:    case 1: no time variation but static quantities
%        case 0: with time variation (annual and semiannual terms)
%
% output parameters:
%
% p:    pressure in hPa 
% T:    temperature in degrees Celsius 
% dT:   temperature lapse rate in degrees per km 
% Tm:   mean temperature of the water vapor in degrees Kelvin 
% e:    water vapor pressure in hPa 
% ah:   hydrostatic mapping function coefficient at zero height (VMF1) 
% aw:   wet mapping function coefficient (VMF1) 
% la:   water vapor decrease factor 
% undu: geoid undulation in m 
%
% output file : 
%        If the reduced grid does not exists it tries to creates  
%         gpt2_1w_station.txt in the dir $PRODUCTS/station/eo 
%  
%------------------------------------------------------------------------
% NB: CR 18mar30: ISSUE
%      if the reduced grid cannot be created 
%          the outputs are empty  !!!
%--------------------------------------------------------------------------
% Same as gpt2_1w.m  but reads the reduced Temp-Pressure-grid for one site
%   gpt2_1w_station.txt in the dir $PRODUCTS/station/eo 
%  
%   instead of the complete grid $METADATA/gpt2_1wA.grd
%
% -----------------------------------------------------------------
%     gpt2_1w.m is in /gipsy/matlab/refraction
%---------------------------------------------------------------------------
% BASED ON 
%function [p,T,dT,Tm,e,ah,aw,la,undu] = gpt2_1w (dmjd,dlat,dlon,hell,nstat,it)
%
% (c) Department of Geodesy and Geoinformation, Vienna University of
% Technology, 2013
%
% The copyright in this document is vested in the Department of Geodesy and
% Geoinformation (GEO), Vienna University of Technology, Austria. This document
% may only be reproduced in whole or in part, or stored in a retrieval
% system, or transmitted in any form, or by any means electronic,
% mechanical, photocopying or otherwise, either with the prior permission
% of GEO or in accordance with the terms of ESTEC Contract No.
% 4000107329/12/NL/LvH.
% ---
%
% This subroutine determines pressure, temperature, temperature lapse rate, 
% mean temperature of the water vapor, water vapor pressure, hydrostatic 
% and wet mapping function coefficients ah and aw, water vapour decrease
% factor and geoid undulation for specific sites near the Earth surface.
% It is based on a 1 x 1 degree external grid file ('gpt2_1wA.grd') with mean
% values as well as sine and cosine amplitudes for the annual and
% semiannual variation of the coefficients.
%
% c Reference:
% J. Böhm, G. Möller, M. Schindelegger, G. Pain, R. Weber, Development of an 
% improved blind model for slant delays in the troposphere (GPT2w),
% GPS Solutions, 2014, doi:10.1007/s10291-014-0403-7
%
% input parameters:
%
% dmjd:  modified Julian date (scalar, only one epoch per call is possible)
% dlat:  ellipsoidal latitude in radians [-pi/2:+pi/2] (vector)
% dlon:  longitude in radians [-pi:pi] or [0:2pi] (vector)
% hell:  ellipsoidal height in m (vector)
% nstat: number of stations in dlat, dlon, and hell
%        maximum possible: not relevant for Matlab version
% it:    case 1: no time variation but static quantities
%        case 0: with time variation (annual and semiannual terms)
% 
% output parameters:
%
% p:    pressure in hPa (vector of length nstat) 
% T:    temperature in degrees Celsius (vector of length nstat)
% dT:   temperature lapse rate in degrees per km (vector of length nstat)
% Tm:   mean temperature of the water vapor in degrees Kelvin (vector of length nstat)
% e:    water vapor pressure in hPa (vector of length nstat)
% ah:   hydrostatic mapping function coefficient at zero height (VMF1) 
%       (vector of length nstat)
% aw:   wet mapping function coefficient (VMF1) (vector of length nstat)
% la:   water vapor decrease factor (vector of length nstat)
% undu: geoid undulation in m (vector of length nstat)
%
% The hydrostatic mapping function coefficients have to be used with the
% height dependent Vienna Mapping Function 1 (vmf_ht.f) because the
% coefficients refer to zero height.
%
% Example 1 (Vienna, 2 August 2012, with time variation,grid file 'gpt2_1wA.grd):
%
% dmjd = 56141.d0
% dlat(1) = 48.20d0*pi/180.d0
% dlon(1) = 16.37d0*pi/180.d0
% hell(1) = 156.d0
% nstat = 1
% it = 0
%
% output:
% p = 1002.788 hPa
% T = 22.060 deg Celsius
% dT = -6.230 deg / km
% Tm = 281.304 K
% e = 16.742 hPa
% ah = 0.0012646
% aw = 0.0005752
% la = 2.6530
% undu = 45.76 m
%
% Example 2 (Vienna, 2 August 2012, without time variation, i.e. constant values):
%
% dmjd = 56141.d0
% dlat(1) = 48.20d0*pi/180.d0
% dlon(1) = 16.37d0*pi/180.d0
% hell(1) = 156.d0
% nstat = 1
% it = 1
%
% output:
% p = 1003.709 hPa
% T = 11.79 deg Celsius
% dT = -5.49 deg / km
% Tm = 273.22 K
% e = 10.26 hPa
% ah = 0.0012396
% aw = 0.0005753
% la = 2.6358
% undu = 45.76 m
%
%
% Klemens Lagler, 2 August 2012
% Johannes Boehm, 6 August 2012, revision
% Klemens Lagler, 21 August 2012, epoch change to January 1 2000
% Johannes Boehm, 23 August 2012, adding possibility to determine constant field
% Johannes Boehm, 27 December 2012, reference added
% Johannes Boehm, 10 January 2013, correction for dlat = -90 degrees
%                                  (problem found by Changyong He)
% Johannes Boehm, 21 May 2013, bug with dmjd removed (input parameter dmjd was replaced
%                 unintentionally; problem found by Dennis Ferguson)
% Gregory Pain,   17 June 2013, adding water vapor decrease factor la 
% Gregory Pain,   21 June 2013, using the 1 degree grid : better for calculating zenith wet delays (la)
% Gregory Pain,   01 July 2013, adding mean temperature of the water vapor Tm
% Gregory Pain,   30 July 2013, changing the method to calculate the water vapor partial pressure (e)
% Gregory Pain,   31 July 2013, correction for (dlat = -90 degrees, dlon = 360 degrees)
% Johannes Boehm, 27 December 2013, copyright notice added 
% Johannes Boehm, 25 August 2014, default input file changed to
%                 gpt2_1wA.grd (slightly different humidity values) 
% Johannes Boehm, 25 August 2014, reference changed to Boehm et al. in GPS
%                 Solutions
% 
%-------------------------------------------------------------------
%
% CR  18Mar29 created gpt2_1w_1site.m
% KL fixed various bugs - this version assumes all files are in the same directories where
% you are doing the analysis.  Would be better to have a separate file structure, but this is
% most transparent
%--------------------------------------------------------------------

nsta=1; % only doing one station at a time


% initialisation 

    p=[];T=[]; dT=[]; Tm=[];
    e =[]; ah =[]; aw = []; la =[]; undu=[];
% KL - one of these was missed.

% change the reference epoch to January 1 2000
dmjd1 = dmjd-51544.5;

% mean gravity in m/s**2
gm = 9.80665;
% molar mass of dry air in kg/mol
dMtr = 28.965*10^-3;
% universal gas constant in J/K/mol
Rg = 8.3143;

% factors for amplitudes
if (it==1) % then  constant parameters
    cosfy = 0;
    coshy = 0;
    sinfy = 0;
    sinhy = 0;
else 
    cosfy = cos(dmjd1/365.25*2*pi);
    coshy = cos(dmjd1/365.25*4*pi);
    sinfy = sin(dmjd1/365.25*2*pi);
    sinhy = sin(dmjd1/365.25*4*pi);
end

% read gridfile
% KL change to have no directory structure
outdir = '';
% outdir = [ getenv('PRODUCTS') '/' station '/eo/'];
 gridfile = [outdir 'gpt2_1wA_' station '.txt'];
 
if ~exist( gridfile) 
 disp([ ' ... try to create  ' gridfile ]) 
  % create the grid file 
  site_lat = dlat * 180/pi; % in deg
  site_lon = dlon*180/pi;     % in deg
  gpt2_1w_grid_1site(station, site_lat, site_lon);
end
if ~exist( gridfile) 
  disp(['no '  gridfile ' exiting']) 
  return
end

% load file 
    [x, empty]= load_file_nocrash(gridfile);
  if empty
    disp(['no '  gridfile ' exiting']) 
    return
  end 

% assign variables 
%--------------------
    nb_data = size(x,1);
    max_ind = nb_data/5;
  if floor( max_ind) ~= max_ind
    disp([' problem with the size of ' gridfile])
    return
  end 

%initialization
    pgrid = zeros(max_ind,5);
    Tgrid = zeros(max_ind,5);
    Qgrid = zeros(max_ind,5);
    dTgrid = zeros(max_ind,5);
    u = zeros(max_ind,1);
    Hs = zeros(max_ind,1);
    ahgrid = zeros(max_ind,5);
    awgrid = zeros(max_ind,5);
    lagrid = zeros(max_ind,5);
    Tmgrid = zeros(max_ind,5);


for n=1: max_ind
% read mean values and amplitudes
    ind = [(n-1)*5+1: n*5];
    pgrid(n,1:5)  = x(ind,3) ;        % pressure in Pascal
    Tgrid(n,1:5)  = x(ind,4);         % temperature in Kelvin
    Qgrid(n,1:5)  = x(ind,5)./1000;  % specific humidity in kg/kg
    dTgrid(n,1:5) = x(ind,6)./1000;  % temperature lapse rate in Kelvin/m
    u(n)          = x(ind(1),7);           % geoid undulation in m
    Hs(n)         = x(ind(1),8);           % orthometric grid height in m
    ahgrid(n,1:5) = x(ind,9)./1000;  % hydrostatic mapping function coefficient, dimensionless
    awgrid(n,1:5) = x(ind,10)./1000;  % wet mapping function coefficient, dimensionless
    lagrid(n,1:5) = x(ind,11);    	   % water vapor decrease factor, dimensionless
    Tmgrid(n,1:5) = x(ind,12);    % mean temperature in Kelvin   
end
    

if max_ind==1
  % We are close to the poles
  % use nearest neighbour interpolation,
  bilinear = 0;
elseif  max_ind ==4
  % case of bilinear interpolation
  bilinear = 1;
else
  disp([' problem: you should have 1 or 4 grid points : you have ',...
           num2str(max_ind) ' grid points'])
  return
end 


% initialization of new vectors
p =  0;
T =  0;
dT = 0;
Tm = 0;
e =  0;
ah = 0;
aw = 0;
la = 0;
undu = 0;

k=1 ; % only one station 


 % case of nearest neighborhood
    if bilinear == 0

        ix = 1;
        
        % transforming ellipsoidal height to orthometric height
        undu(k) = u(ix);
        hgt = hell(k)-undu(k);
            
        % pressure, temperature at the height of the grid
        T0 = Tgrid(ix,1) + ...
             Tgrid(ix,2)*cosfy + Tgrid(ix,3)*sinfy + ...
             Tgrid(ix,4)*coshy + Tgrid(ix,5)*sinhy;
        p0 = pgrid(ix,1) + ...
             pgrid(ix,2)*cosfy + pgrid(ix,3)*sinfy+ ...
             pgrid(ix,4)*coshy + pgrid(ix,5)*sinhy;
         
        % specific humidity
        Q = Qgrid(ix,1) + ...
            Qgrid(ix,2)*cosfy + Qgrid(ix,3)*sinfy+ ...
            Qgrid(ix,4)*coshy + Qgrid(ix,5)*sinhy;
            
        % lapse rate of the temperature
        dT(k) = dTgrid(ix,1) + ...
                dTgrid(ix,2)*cosfy + dTgrid(ix,3)*sinfy+ ...
                dTgrid(ix,4)*coshy + dTgrid(ix,5)*sinhy; 

        % station height - grid height
        redh = hgt - Hs(ix);

        % temperature at station height in Celsius
        T(k) = T0 + dT(k)*redh - 273.15;
        
        % temperature lapse rate in degrees / km
        dT(k) = dT(k)*1000;

        % virtual temperature in Kelvin
        Tv = T0*(1+0.6077*Q);
        
        c = gm*dMtr/(Rg*Tv);
        
        % pressure in hPa
        p(k) = (p0*exp(-c*redh))/100;
            
        % hydrostatic coefficient ah 
        ah(k) = ahgrid(ix,1) + ...
                ahgrid(ix,2)*cosfy + ahgrid(ix,3)*sinfy+ ...
                ahgrid(ix,4)*coshy + ahgrid(ix,5)*sinhy;
            
        % wet coefficient aw
        aw(k) = awgrid(ix,1) + ...
                awgrid(ix,2)*cosfy + awgrid(ix,3)*sinfy + ...
                awgrid(ix,4)*coshy + awgrid(ix,5)*sinhy;
		
		% water vapour decrease factor la - added by GP
        la(k) = lagrid(ix,1) + ...
                lagrid(ix,2)*cosfy + lagrid(ix,3)*sinfy + ...
                lagrid(ix,4)*coshy + lagrid(ix,5)*sinhy;

		% mean temperature of the water vapor Tm - added by GP
        Tm(k) = Tmgrid(ix,1) + ...
                Tmgrid(ix,2)*cosfy + Tmgrid(ix,3)*sinfy + ...
                Tmgrid(ix,4)*coshy + Tmgrid(ix,5)*sinhy;
		
		% water vapor pressure in hPa - changed by GP
		e0 = Q*p0/(0.622+0.378*Q)/100; % on the grid
		e(k) = e0*(100*p(k)/p0)^(la(k)+1);   % on the station height - (14) Askne and Nordius, 1987
		
    else % bilinear interpolation          
       indx= [1:max_ind]; % use the 4 grid points 
      %-------------------------------
      % need to find diffpod and difflon
      % only positive longitude in degrees
      if dlon(k) < 0
        plon = (dlon(k) + 2*pi)*180/pi;
       else
         plon = dlon(k)*180/pi;
       end
       % transform to polar distance in degrees
        ppod = (-dlat(k) + pi/2)*180/pi; 

       % find the index (line in the grid file) of the nearest point
  	  % changed for the 1 degree grid (GP)
       ipod = floor((ppod+1)); 
       ilon = floor((plon+1));
    
       % normalized (to one) differences, can be positive or negative
	% changed for the 1 degree grid (GP)
        diffpod = (ppod - (ipod - 0.5));
        difflon = (plon - (ilon - 0.5));
       %------------------------------------------
           for l = 1:4     % use the 4 grid points 
              
            % transforming ellipsoidal height to orthometric height:
            % Hortho = -N + Hell
            undul(l) = u(indx(l));
            hgt = hell(k)-undul(l);
        
            % pressure, temperature at the height of the grid
            T0 = Tgrid(indx(l),1) + ...
                 Tgrid(indx(l),2)*cosfy + Tgrid(indx(l),3)*sinfy + ...
                 Tgrid(indx(l),4)*coshy + Tgrid(indx(l),5)*sinhy;
            p0 = pgrid(indx(l),1) + ...
                 pgrid(indx(l),2)*cosfy + pgrid(indx(l),3)*sinfy + ...
                 pgrid(indx(l),4)*coshy + pgrid(indx(l),5)*sinhy;
 
            % humidity 
            Ql(l) = Qgrid(indx(l),1) + ...
                    Qgrid(indx(l),2)*cosfy + Qgrid(indx(l),3)*sinfy + ...
                    Qgrid(indx(l),4)*coshy + Qgrid(indx(l),5)*sinhy;
 
            % reduction = stationheight - gridheight
            Hs1 = Hs(indx(l));    
            redh = hgt - Hs1;

            % lapse rate of the temperature in degree / m
            dTl(l) = dTgrid(indx(l),1) + ...
                     dTgrid(indx(l),2)*cosfy + dTgrid(indx(l),3)*sinfy + ...
                     dTgrid(indx(l),4)*coshy + dTgrid(indx(l),5)*sinhy;

   
            % temperature reduction to station height
            Tl(l) = T0 + dTl(l)*redh - 273.15;

            % virtual temperature
            Tv = T0*(1+0.6077*Ql(l));  
            c = gm*dMtr/(Rg*Tv);
            
            % pressure in hPa
            pl(l) = (p0*exp(-c*redh))/100;
            
            % hydrostatic coefficient ah
            ahl(l) = ahgrid(indx(l),1) + ...
                     ahgrid(indx(l),2)*cosfy + ahgrid(indx(l),3)*sinfy + ...
                     ahgrid(indx(l),4)*coshy + ahgrid(indx(l),5)*sinhy;
            
            % wet coefficient aw
            awl(l) = awgrid(indx(l),1) + ...
                     awgrid(indx(l),2)*cosfy + awgrid(indx(l),3)*sinfy + ...
                     awgrid(indx(l),4)*coshy + awgrid(indx(l),5)*sinhy;
					 
	   % water vapor decrease factor la - added by GP
	   lal(l) = lagrid(indx(l),1) + ...
		    lagrid(indx(l),2)*cosfy + lagrid(indx(l),3)*sinfy + ...
		    lagrid(indx(l),4)*coshy + lagrid(indx(l),5)*sinhy;
					 
	   % mean temperature of the water vapor Tm - added by GP
	  Tml(l) = Tmgrid(indx(l),1) + ...
		   Tmgrid(indx(l),2)*cosfy + Tmgrid(indx(l),3)*sinfy + ...
		   Tmgrid(indx(l),4)*coshy + Tmgrid(indx(l),5)*sinhy;
					 		 
	   % water vapor pressure in hPa - changed by GP
           e0 = Ql(l)*p0/(0.622+0.378*Ql(l))/100; % on the grid
	   el(l) = e0*(100*pl(l)/p0)^(lal(l)+1);  % on the station height - (14) Askne and Nordius, 1987
            
        end
           
        dnpod1 = abs(diffpod); % distance nearer point
        dnpod2 = 1 - dnpod1;   % distance to distant point
        dnlon1 = abs(difflon);
        dnlon2 = 1 - dnlon1;
        
        % pressure
        R1 = dnpod2*pl(1)+dnpod1*pl(2);
        R2 = dnpod2*pl(3)+dnpod1*pl(4);
        p(k) = dnlon2*R1+dnlon1*R2;
            
        % temperature
        R1 = dnpod2*Tl(1)+dnpod1*Tl(2);
        R2 = dnpod2*Tl(3)+dnpod1*Tl(4);
        T(k) = dnlon2*R1+dnlon1*R2;
        
        % temperature in degree per km
        R1 = dnpod2*dTl(1)+dnpod1*dTl(2);
        R2 = dnpod2*dTl(3)+dnpod1*dTl(4);
        dT(k) = (dnlon2*R1+dnlon1*R2)*1000;
            
        % water vapor pressure in hPa - changed by GP
		R1 = dnpod2*el(1)+dnpod1*el(2);
        R2 = dnpod2*el(3)+dnpod1*el(4);
        e(k) = dnlon2*R1+dnlon1*R2;
            
        % hydrostatic
        R1 = dnpod2*ahl(1)+dnpod1*ahl(2);
        R2 = dnpod2*ahl(3)+dnpod1*ahl(4);
        ah(k) = dnlon2*R1+dnlon1*R2;
           
        % wet
        R1 = dnpod2*awl(1)+dnpod1*awl(2);
        R2 = dnpod2*awl(3)+dnpod1*awl(4);
        aw(k) = dnlon2*R1+dnlon1*R2;
        
        % undulation
        R1 = dnpod2*undul(1)+dnpod1*undul(2);
        R2 = dnpod2*undul(3)+dnpod1*undul(4);
        undu(k) = dnlon2*R1+dnlon1*R2;
		
	% water vapor decrease factor la - added by GP
        R1 = dnpod2*lal(1)+dnpod1*lal(2);
        R2 = dnpod2*lal(3)+dnpod1*lal(4);
        la(k) = dnlon2*R1+dnlon1*R2;
		
	% mean temperature of the water vapor Tm - added by GP
        R1 = dnpod2*Tml(1)+dnpod1*Tml(2);
        R2 = dnpod2*Tml(3)+dnpod1*Tml(4);
        Tm(k) = dnlon2*R1+dnlon1*R2;
                    
    end 
end
