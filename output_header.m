function output_header( fid )
%function  output_header( fid )
% input file ID for LSP results.
comL = '%';
 

% header for the output  
fprintf(fid,'%s year doy maxRH maxRHAmp meanazm sat delT  minE  maxE  pknoise freq  UTC\n', comL);
fprintf(fid,'%s           m      v/v      deg       min   deg   deg                  hr\n', comL);

end

