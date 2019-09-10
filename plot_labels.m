function plot_labels( plt_type, station, azims,freqtype )
%function plot_labels( plt_type, station, azims, freqtype)
% Author: kristine m. larson, labels for lomb scargle plots
% used in the GNSS-IR Tool Box
% inputs 
%   plt_type - 1 is by quadrant, 0 is all together
%   station is 4 character station name
%   azims is azimuth limits [0 45], etc.
%   freqtype is 1,2,or 5

 if plt_type == 1
    aa = [' Azimuths ' num2str(azims(1)) '-' num2str(azims(2))];
    subplot(2,1,1)
    title([station aa ' L' num2str(freqtype) ' frequency'],'FontWeight','normal'); 
    xlabel('Elevation Angle(deg)'); ylabel('SNR-volts/volts');
    subplot(2,1,2)
    grid on; 
    xlabel('H_{R}, Reflector Ht.(m)'); ylabel('volts/volts');
 else
    title(['GPS Station ' station ' L' num2str(freqtype) ' frequency'],'FontWeight','normal')
    grid on; 
    xlabel('H_{R}, Reflector Ht.(m)'); ylabel('volts/volts');
 end

end

