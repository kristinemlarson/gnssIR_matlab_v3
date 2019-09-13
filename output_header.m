function output_header( fid )
%function  output_header( fid )
% input: file ID
% writes the header for the outputfile used for LSP results.
% author: kristine m. larson, september 13, 2019
% need to add MJD and refraction, etc.
comL = '%';
 

% header for the output  
fprintf(fid,'%s year doy maxRH maxRHAmp meanazm sat delT  minE  maxE  pknoise freq  UTC\n', comL);
fprintf(fid,'%s           m      v/v      deg       min   deg   deg                  hr\n', comL);

end

