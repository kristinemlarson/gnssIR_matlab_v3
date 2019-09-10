function [ minAmp,pknoise,frange ] = quicky_QC(freqtype, maxHeight, ...
    desiredPrecision,ediff,frange)
%function [ minAmp,pknoise,frange ] = quicky_QC((freqtype, maxHeight,
% desiredPrecision, ediff,frange)
% Author: Kristine Larson
% I wrote this code to set up some QC levels for the GNSS-IR ToolBox.
% I strongly encourage you to think about this yourself, as 
% not all frequencies and codes have the same
% quality levels.  

% minAmp is the amplitude level of the LSP. I often use this metric
% for significance of a L1 or L2C peak, but that level won't work for L2P.

% pknoise is the ratio of the peak to background noise

% frange is the range overwhich the noise level is calculated 
% (in meters reflector height)

% ediff is required difference between maximum and minimum elevation
% angles.  You don't want tiny arcs - but this can certainly be 
% varied a bit, particularly when you only want the very lowest
% elevation angles.

% arbitrary amplitude required
% this  maxAmp is appropriate for L1 and L2C.   
 
minAmp = 15; % 

% for now allow everything. L2P has to be much smaller
% for this to work, 
minAmp = 2; % this will let you see almost everything

% for L2P data, use pknoise QC
% this says the peak hsould be at least 3.5 times bigger than
% the noise level. but it is NOT a rule.   
pknoise = 3.5;

% 
% range in reflector height use to calculate a background
% noise level.   
fprintf(1,'Frequency L%1.0f  \n', freqtype);
fprintf(1,'Maximum Refl. Ht (m) %7.3f  \n', maxHeight);
fprintf(1,'Lomb Scargle Precision (m) %6.3f  \n', desiredPrecision);
fprintf(1,'Minimum amplitude of %5.2f has been set \n', minAmp);
fprintf(1,'Peak to noise ratio of %5.2f has been set \n',pknoise);
fprintf(1,'Noise is calculated over  %5.2f to %5.2f meters \n',frange);
fprintf(1,'Difference of Max and Min elevation angles > %5.2f degrees \n',ediff);

end

