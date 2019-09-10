function [ maxRH, maxRHAmp, pknoise ] = peak2noise(f,p,frange)
%this is a perfunctory piece of code that calculates
% peak to noise value.  the noise calculation includes
% the peak.
% also does the RH (meters) for the peak value and 
% its amplitude
% (volts/volts)
[maxRHAmp,ij] = max(p); % max amplitude of LSP.
maxRH = f(ij); % reflector height corresponding to max value
% now do noise value
i=find(f > frange(1) & f < frange(2));
noisey = mean(p(i));
% divide into the max amplitude
pknoise = maxRHAmp/noisey;

end

