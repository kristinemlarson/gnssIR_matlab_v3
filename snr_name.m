function [snrfilename,fexist] = snr_name(station,year,doy,typ,reflcodearea)
% inputs are
%   station name (4 char)
%   year (integer)
%   doy  (integer)
%   snrfiletype (e.g. 99)
%   directory for the reflection area - which is defined by the REFL_CODE environment variable
% author: kristine larson
% outputs are snrfilename and boolean existence
% defaults
snrfilename = '';
fexist = false;
cdoy = sprintf('%03d', doy );
cyyyy = sprintf('%04d', year );
cyy = sprintf('%02d', year-2000 );

snrfilename = [reflcodearea  '/' cyyyy '/snr/' station '/' station cdoy '0.' cyy '.snr' num2str(typ)];
if exist(snrfilename)
  fexist = true;
end

end
