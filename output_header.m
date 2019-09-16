function output_header( fid )
%function  output_header( fid )
% input: file ID
% writes the header for the outputfile used for LSP results.
% author: kristine m. larson, september 13, 2019
% need to add MJD and refraction, etc.
% KL September 16, 2019
% changed order of output to agree with python
comL = '%';
 % year,doy,RHestimated,sat, meanUTC, azm, maxRHAmp, minObsE, maxObsE,  ...
  %      length(data),freqtype, riseSet, EdotF, pknoise,dt*60,mjd,RefIndex);

% header for the output  
fprintf(fid,'%s year doy maxRH sat   meanUTC  Azim  maxRHAmp minE  maxE  Ndat  freq  riseSet EdotF pkNoise delT    MJD   Refraction\n', comL);
fprintf(fid,'%s           m            hrs    deg     v/v     deg   deg                                     hr            1 is yes \n', comL);
fprintf(fid,'%s (1)  (2) (3)   (4)     (5)    (6)    (7)      (8)    (9) (10)  (11)   (12)    (13)  (14)   (15)    (16)   (17)   \n', comL);


end

