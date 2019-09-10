function make_refl_directories(reflcode, cyyyy, station)
% for a given station and year, make appropriate directories
% to store the SNR files and the SNR lomb scargle results


if ~exist([reflcode '/' cyyyy])
    unix(['mkdir' reflcode '/' cyyyy])
end
if ~exist([reflcode '/' cyyyy '/snr' ])
    unix(['mkdir ' reflcode '/' cyyyy '/snr'])
end
if ~exist([reflcode '/' cyyyy '/results' ])
    unix(['mkdir ' reflcode '/' cyyyy '/results'])
end

if ~exist([reflcode '/' cyyyy '/snr/' station ])
    unix(['mkdir ' reflcode '/' cyyyy '/snr/' station])
end

if ~exist([reflcode '/' cyyyy '/results/' station ])
    unix(['mkdir ' reflcode '/' cyyyy '/results/' station])
end

end
