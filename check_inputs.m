function exitS = check_inputs(station, year, doy,freqtype,snrtype)
%function exitS = check_inputs(station, year, doy,freqtype,snrtype)
% checks that the Lomb Scargle GNSS-IR inputs are reasonable
% 
exitS = false;
if length(station) ~= 4
    disp('Station name must have 4 characters. Exiting')
    exitS = true;
end

cyyyy = sprintf('%04d', year );
if length(cyyyy) ~= 4
    disp('Year must be 4 characters long. Exiting')
    exitS = true;
end

if (doy > 366) || (doy < 1)
    disp('Day of year must be between 1 and 366. Exiting')
    exitS = true;
end
    
allowed = [50 88 66 99 77];
if ismember(snrtype, allowed)
    disp('You picked a legal SNR file type')
else
    disp(['You picked an illegal SNR file type:' num2str(snrtype)])
    disp('Allowed values are 50, 66, 88, 77, and 99')
    disp('Exiting')
    exitS = true;
end

allowed = [1 2 20 5 101 102 201 205 206 207 208 302 306 307];
if ismember(freqtype, allowed)
    disp('You picked a legal frequency')
else
    disp(['You picked an illegal frequency: ' num2str(freqtype)] )
    disp('Exiting')
    exitS = true;
end


    
