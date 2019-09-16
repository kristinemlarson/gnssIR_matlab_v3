function  gpt2_1w_grid_1site(station, site_lat, site_lon)

%function  gpt2_1w_grid_1site(station, site_lat, site_lon)
% input: 4lower case station name
%         site_lat in degrees [-90 90]
%         site_lon in degrees [ 0 360] or [-180 180]
%---------------------------------------------------------------
% create the grid of temp and pressure for one station  
%---------------------------------------------------------------
% the code "code gpt2_1w.m" provided by Department of Geodesy
%  and Geoinformation Vienna University of Technology determines
% pressure, temperature ect... to estimate the slant delays in the troposphere. 
% their model is called (GPT2w). They use a global 1 degree grid.
%  This global  grid gpt2_1wA.grd is large 
%  it contains:  8 arrays of size 64800 x 5
%                2 vectors of dimension 64800.
% And takes a long time to load.
%
% For one station we can reduce the 64800 points to 4
% We reduce the grid  to  : 8 arrays of size 4x5
%                     2 vectors of dimension 4 
%---------------------------------------------------------------

% output:  gpt2_1w_station.txt ie gpt2_1w_pbay.txt
%----------------------------------------------------------------
% then use the code gpt2_1w_1site.m to estimate Temp, pressure..
%--------------------------------------------------------------------
%
%   These 4 grid points correspond to the complete world grid 
%     with indexes: indx(1:4)  (see main code gpt2_1w.m) 
%     written out in that order 
% 
%   NB: if the site is close to the poles there will be only one grid point
% 
%-----------------------------------------------------------------------------
% 
%
% NB the original  gpt2_1wA.grd is in /gispy/matlab/refraction
%     as well as the related code gpt2_1w.m
%--------------------------------------------------------------------
% SAVE the originalcomplete grid to  /gipsy/auto/metadata ---> $METADATA
% save station grid in /data/web/station/eo  ---> $PRODUCTS/station /eo
%-------------------------------------------------------------------
%
% CR 18mar29
% KL 18apr01 modified to work anywhere (i.e. the file structures on xenon are 
% ignored
% KL 19sep16 output written to $REFL_CODE/input
%-------------------------------------------------------------------




%outdir = [ getenv('PRODUCTS') '/' station '/eo/'];
% KL September 2019
outdir = [getenv('REFL_CODE') '/input/'];
 if ~exist(outdir)
  disp([  ' the dir ' outdir ' does not exist for ' station] )
  return
 end  


%------------------------------------------------------------
% station lat/lon
%-------------------------------------------------------------
% dlat:  ellipsoidal latitude in radians [-pi/2:+pi/2] (vector)
% dlon:  longitude in radians [-pi:pi] or [0:2pi] (vector)

% change to radian 
dlat = site_lat*pi/180;
dlon = site_lon*pi/180;


% initialization of new vectors
pgrid = zeros([4, 5]);
Tgrid = zeros([4, 5]);
Qgrid = zeros([4, 5]);
dTgrid = zeros([4, 5]);
u = zeros([4, 1]);
Hs = zeros([4, 1]);
ahgrid = zeros([4, 5]);
awgrid = zeros([4, 5]);
lagrid = zeros([4, 5]);
Tmgrid = zeros([4, 5]);
indx = nan(4,1);
indx_lat = nan(4,1);
indx_lon = nan(4,1);


% read VMF gridfile in mat format 
load complete_gpt2_1wA_grid
 
 

k=1; % only one station 

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
    % added by HCY
	% changed for the 1 degree grid (GP)
    if ipod == 181
        ipod = 180;
    end
	% added by GP
    if ilon == 361
		ilon = 1;
    end
    if ilon == 0
		ilon = 360;
    end

    % get the number of the corresponding line
	% changed for the 1 degree grid (GP)
    indx(1) = (ipod - 1)*360 + ilon;
   % save the lat lon of the grid points
   indx_lat(1) = 90-ipod+1;  indx_lon(1) = ilon-1 ;  % lat between [-90 ;90]  lon [0 360]
    % near the poles: nearest neighbour interpolation, otherwise: bilinear
    % with the 1 degree grid the limits are lower and upper (GP)

    bilinear = 0;
    max_ind = 1;
    if ppod > 0.5 && ppod < 179.5 
           bilinear = 1;          
    end          

   if bilinear 
   max_ind =4;

    % bilinear interpolation
    % get the other indexes 
 
        ipod1 = ipod + sign(diffpod);
        ilon1 = ilon + sign(difflon);
		% changed for the 1 degree grid (GP)
        if ilon1 == 361
            ilon1 = 1;
        end
        if ilon1 == 0
            ilon1 = 360;
        end
        
        % get the number of the line
		% changed for the 1 degree grid (GP)
        indx(2) = (ipod1 - 1)*360 + ilon;  % along same longitude
        indx(3) = (ipod  - 1)*360 + ilon1; % along same polar distance
        indx(4) = (ipod1 - 1)*360 + ilon1; % diagonal
	% save the lat lon of the grid points % lat between [-90 ;90]  lon [0 360] 
        indx_lat(2) =   90 - ipod1+sign(diffpod);    indx_lon(2) = ilon-1 ;
        indx_lat(3) =   90-ipod +1;                  indx_lon(3) =  ilon1 - sign(difflon);
        indx_lat(4) =   90 -ipod1+sign(diffpod);     indx_lon(4) = ilon1- sign(difflon);
       
    end


% extract the new grid
%--------------------
    n = [1:max_ind] ;
 Nindx = indx(1:max_ind);
 pgrid(n,1:5)  =   All_pgrid(Nindx,1:5);  % pressure in Pascal
 Tgrid(n,1:5)  =   All_Tgrid(Nindx,1:5);  % temperature in Kelvin
 Qgrid(n,1:5)  =   All_Qgrid(Nindx,1:5);  % specific humidity in kg/kg
 dTgrid(n,1:5) =   All_dTgrid(Nindx,1:5);  % temperature lapse rate in Kelvin/m
 u(n)          =   All_u(Nindx)  ;        % geoid undulation in m
 Hs(n)         =   All_Hs(Nindx) ;        % orthometric grid height in m
 ahgrid(n,1:5) =   All_ahgrid(Nindx,1:5) ;
 awgrid(n,1:5) =   All_awgrid(Nindx,1:5) ;	
 lagrid(n,1:5) =   All_lagrid(Nindx,1:5) ;
 Tmgrid(n,1:5) =   All_Tmgrid(Nindx,1:5) ; % mean temperature in Kelvin
    

    


% save the new grid to a txt file
%-------------------
comL='%';
outname = [outdir 'gpt2_1wA_' station '.txt'];
disp(['writing file out to: ' outname]);
fid=fopen(outname,'w');

%-----------------------------------------
% write header 
%-----------------------------------------
%HEADER
 %display( ['... opening  ' outname])
 fprintf(fid,'%s created on %s   using gpt2_1w_grid_1site.m \n', comL, date );
 fprintf(fid,'%s  Reduced grid gpt2_1wA.grd for  %s\n',comL , station); 
 fprintf(fid,'%s  4-grid-points of Pressure-Temperature nearest-neighbor of %s\n',comL , station); 
 fprintf(fid,'%s  %s lat %3.4f   lon %3.4f      in degrees \n', comL, station,  site_lat, site_lon);
 fprintf(fid,'%s-----------------------------------------------------------------------------\n', comL);
 fprintf(fid,'%s the code "code gpt2_1w.m" provided by Department of Geodesy\n', comL);
 fprintf(fid,'%s  and Geoinformation Vienna University of Technology determines\n', comL);
 fprintf(fid,'%s  pressure, temperature ect..to estimate the slant delays in the troposphe. \n', comL);
 fprintf(fid,'%s  their model is called (GPT2w). \n', comL);
 fprintf(fid,'%s They use a  global 1 degree grid : gpt2_1wA.grd with 64800 grid points\n', comL);
 fprintf(fid,'%s  it contains:  8 arrays of size 64800 x 5  \n', comL);
 fprintf(fid,'%s               2 vectors of dimension 64800 \n', comL);
 fprintf(fid,'%s \n', comL);
 fprintf(fid,'%s   Here we reduce it to  10 arrays of size 4 x 5 \n', comL);
 fprintf(fid,'%s   and keep only 4 grid points around the site location\n', comL);
 fprintf(fid,'%s    (also added  2 arrays of size 4x5 for the location of the grid points)\n', comL);
 fprintf(fid,'%s \n', comL);
 fprintf(fid,'%s   These 4 grid points correspond to the complete world grid \n', comL);
 fprintf(fid,'%s     with indexes: indx(1:4)  (see main code gpt2_1w.m) \n', comL);
 fprintf(fid,'%s     written out in that order \n', comL);
 fprintf(fid,'%s \n', comL);
 fprintf(fid,'%s   NB: if the site is close to the poles there will be only one grid point\n', comL);
 fprintf(fid,'%s \n', comL);
 fprintf(fid,'%s \n', comL);
 fprintf(fid,'%s  Use the code   gpt2_1w_1site.m    to read this file  \n', comL);
 fprintf(fid,'%s \n', comL);
 fprintf(fid,'%s-----------------------------------------------------------------------------\n', comL);
 fprintf(fid,'%s \n', comL);
 fprintf(fid,'%s  \n', comL);
 fprintf(fid,'%s lat    lon     Pressure      Temp      Specific     TempLapse     geoid  ',comL);

 fprintf(fid,'    orthometric    hydrostat     wet map     WV       mean_Temp \n');
 fprintf(fid,'%s                                        hunidity      rate        undulat'  ,comL);
 fprintf(fid,'       Height       map funct     funct      decrease   \n'                      );


 fprintf(fid,'%s deg    deg        (Pa)        (K)    (kg/kg)/1000   (K/m)/1000       (m)  ', comL);
 fprintf(fid,'         (m)        0.001       0.001       (nodim)      (K) \n');    
 

 fprintf(fid,'%s (1)   (2)         (3)         (4)         (5)         (6)            (7)  ',comL);
 fprintf(fid ,'         (8)          (9)         (10)       (11)        (12) \n')    ;

% end of header 
%------------------------------------

%----------------
% write grid 
%----------------
  for n = 1: max_ind
     for j=1:5
      fprintf(fid,'%4i %5i  %13.4f  %10.4f  %10.6f  %10.4f  %12.5f  %12.5f  ', indx_lat(n),...
	      indx_lon(n), pgrid(n,j),Tgrid(n,j),Qgrid(n,j)*1000,dTgrid(n,j)*1000, u(n), Hs(n));

      fprintf(fid,' %10.6f  %10.6f  %10.6f  %10.4f  \n',  ...
	      ahgrid(n,j)*1000,   awgrid(n,j)*1000 , lagrid(n,j),Tmgrid(n,j));
  end
 end 

 fclose(fid);

