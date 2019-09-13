function [sc_fac,ic] = get_gnss_freq_scales(frq)
% this function should get a mapping for all
% known GNSS satellite wavelength scale factors
% using in GNSS-IR, i.e. lambda/2. 
% originally was GPS and Glonass only
% added Galileo and Beidou September 2019
% numbering is as follows
% 1-99 is for GPS
% 101-199 is for Glonass
% 201-299 is for Galileo
% 301-399 is for Beidou
% author: kristine m. larson
%
% ic is the column number in the SNR file
%  
c= 299792458 ; % speed of light m/sec
maxGPS = 32;
maxGlonass = 24;
maxGalileo = 50; % don't know what they have so bigger than needed.
maxBeidou = 50; % don't know what they have so bigger than needed.


%
sc_fac = zeros(400,1);
% GPS frequencies first
% should really use the frequencies rather than wavelengths
if frq ==1
  sc_fac(1:maxGPS,1) = 0.1902936/2;  %half the frequency of L1
  ic = 7;
elseif frq == 2
  ic = 8;
  sc_fac(1:maxGPS,1) = 0.244210213/2;  %half the frequency of L2 
% make believe for L2C
elseif frq == 20
  ic = 8;
  sc_fac(1:maxGPS,1) = 0.244210213/2;  %half the frequency of L2C
elseif frq == 5
  sc_fac(1:maxGPS,1) = 0.254828048/2;
  ic = 9;
else
%  fprintf(1,'%s \n', 'I do not know about this GPS frequency')
end


gal_L1 = 1575.420;
gal_L5 = 1176.450;
gal_L6 = 1278.700;
gal_L7 = 1207.140;
gal_L8 = 1191.795;
    
%galileo
ss = 200 + [1:maxGalileo];
if frq == 201
  sc_fac(ss,1) = c/(gal_L1*1e6)/2;
  ic =7;
elseif frq == 205
  sc_fac(ss,1) = c/(gal_L5*1e6)/2;
  ic=9;
elseif frq == 206
  sc_fac(ss,1)= c/(gal_L6*1e6)/2;
  ic = 6;
elseif frq == 207
  sc_fac(ss,1) = c/(gal_L7*1e6)/2;
  ic = 10;
elseif frq == 208
  sc_fac(ss,1) = c/(gal_L8*1e6)/2;
  ic = 11;
end

% beidou frequencies and wavelengths
bei_L2 = 1561.098;
bei_L7 = 1207.14;
bei_L6 = 1268.52;
wbL2 = c/(bei_L2*1e6);
ic=8;
wbL6 = c/(bei_L6*1e6);
ic=6;
wbL7 = c/(bei_L7*1e6);
ic=10;
    
ss = 300 + [1:maxBeidou];
if frq == 302
  sc_fac(ss,1) = wbL2/2;
elseif frq == 306
  sc_fac(ss,1) = wbL6/2;
elseif frq == 307
  sc_fac(ss,1) = wbL7/2;
end

% Glonass next
for prn=1:maxGlonass
  [l1w,l2w]= glonass(prn);
  if frq==1
    sc_fac(100+prn,1) = l1w/2;
    ic=7;
  elseif frq == 2
    ic=8;
    sc_fac(100+prn,1) = l2w/2;
  else
%    fprintf(1,'%s \n', 'I do not know about this GLONASS frequency')
  end
end

 
