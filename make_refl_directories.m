function make_refl_directories(reflcode, cyyyy, station)
% for a given reflection code directory (reflcode), 
% station and year (string), make appropriate directories
% to store the SNR files and the SNR lomb scargle results
% 
% Kristine M. Larson, September 2019.
% added input directory
% added orbit directories September 2019

orbits=getenv('ORBITS');

% make the orbit directories
if ~exist([orbits '/' cyyyy])
    unix(['mkdir ' orbits '/' cyyyy])
end

if ~exist([orbits '/' cyyyy '/nav'])
    unix(['mkdir ' orbits '/' cyyyy '/nav'])
end

if ~exist([orbits '/' cyyyy '/sp3'])
    unix(['mkdir ' orbits '/' cyyyy '/sp3'])
end


navfiledir = [orbits '/' cyyyy '/nav/'];


if ~exist([reflcode '/input'])
    unix(['mkdir ' reflcode '/input'])
end

if ~exist([reflcode '/' cyyyy])
    unix(['mkdir ' reflcode '/' cyyyy])
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
