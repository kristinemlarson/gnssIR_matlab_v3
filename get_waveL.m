function [ cf,ic ] = get_waveL( freqtype )
% function [ cf,ic ] = get_waveL( freqtype )
% author: kristine Larson
% input frequency (1,2,or 5) and returns wavelength factor
% (lambda/2) and column number (using snr format)
if freqtype == 1
  cf  = 0.1902936/2; ic = 7; % L1 is column 7
% L2 data
elseif freqtype == 2
  cf = 0.2442102134245683/2; ic = 8; % L2 is in column 8
elseif freqtype == 5
  cf = 0.254828048/2; ic = 9; % L5 is in column 9,
  % but not tracked many places
end

end

