function [ofac, hifac] = get_ofac_hifac( elevAngles, cf, maxH, desiredPrecision)
% function [ofac, hifac] = get_ofac_hifac(elevAngles,cf,maxH,desiredPrecision)
%
% Authors: Kristine M. Larson and Carolyn Roesler, March 10, 2018
%
% This function computes two factors - ofac and hifac - that are inputs to the
% Lomb-Scargle Periodogram code lomb.m. The ofac (oversampling factor) and
% hifac (high frequency factor) define the LSP frequency grid spacing 
% and maximum frequency.
% We follow the terminology and discussion from Press et al. (1992)
% in their LSP algorithm description.
%----------------------------------------------------------------------------
% INPUT
%    elevAngles:  vector of satellite elevation angles in degrees 
%    cf:      (L-band wavelength/2 ) in meters    
%    maxH:    maximum LSP grid frequency in meters
%               i.e. how far you want the reflector height to be estimated
%    desiredPrecision:  the LSP frequency grid spacing in meters
%              i.e. how precise you want he LSP reflector height
%                   to be estimated
% ---------------------------------------------------------------------------
% OUPUT
%             ofac: oversampling factor
%             hifac: high-frequency factor
%----------------------------------------------------------------------------
%
% For the GNSS_-IR application, we can write:  SNR = A.cos( 2.pi.H.X)
% The SNR data points are sampled with the variable
%       X= ( 2.sin(elevAngles)/ wavelength ), in units of inverse meters
%  so that their  spectral content H is expressed in meters.
%
% 
% The oversampling factor (ofac) defines the grid spacing between the
% frequencies H in order to find the top of the spectral peak to
% a desired precision. 
% For N data observed during a rectangular window of length:
%                  W  =  Xmax - Xmin
%  the frequency peaks have a characteristic width 1/W and we oversample 
%  each peak by (ofac) using a grid spacing of 1/(ofac.W) (in meters)
% 
% NB: don't be surprised if (ofac) is much larger than the typical
%          4-10 given in   the literature.
%
% The (hifac) factor defines the frequency grid maximum frequency Hmax, 
% relative to the averaged-Nyquist frequency (fc) i.e. the Nyquist
% frequency if all the N  data samples were evenly spaced over the 
% span W of the observing window : 
%                fc = N/(2*W) and  hifac = maxH/fc; 
%
% NB: don't be surprised if (hifac) is much less than the typical
%          5 >= given in the literature 
%
% NB: (fc) is only a reference frequency. For non-uniformly sampled data this 
% averaged-Nyquist frequency (fc) may  have  nothing to do with the real 
% pseudo- Nyquist or Nyquist-like frequency limit that exists in the data
%  ( see VanderPlas, 2017)
%-------------------------------------------------------------------------------

% SNR expressed as a function of X
    X= sind(elevAngles)/cf;    % in units of inverse meters

 % number of observations
    N = length( X);

% observing Window length (or span)
     W = max(X) - min(X);        % units of inverse meters

% characteristic peak width
    characteristic_peak_width= 1/W;            % in meters

% oversampling factor
     ofac = characteristic_peak_width/desiredPrecision;

% Nyquist frequency if the N observed data samples were evenly spaced
% over the observing window span W
    fc = N/(2*W);               % in meters 

% The high-frequency factor is defined relative to fc
    hifac = maxH/fc; 



