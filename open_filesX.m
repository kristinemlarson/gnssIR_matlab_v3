function [fid, x, nofile,fid_reject] = open_filesX(inputfile,outputfile,freqtype )
%function [fid,x,nofile] = open_filesX(inputfile,outputfile, freqtype)
% Author: Kristine M. Larson
% February 24, 2018
% inputs:
%   inputfile - name of the file with the SNR data
%   outputfile - name of the txt file where the LSP results will go
%   freqtype - 1, 2, or 5
% outputs
%   fid - file ID for the outputfile
%   variable x, contains the SNR data.
%   nofile = boolean for whether the inputfile existed or not
%   fid_reject - for the rejected arcs
% 
% set defaults
nofile = false;
x= [];
fid_reject = fopen('reject.txt','w');


fid=fopen(outputfile,'w');
if fid < 0
   disp('problem with your output txt file');
   nofile = true;
   return
end
% file exists, read it
if exist(inputfile)
  x=load(inputfile);
  [nr,nc]= size(x);
  fprintf(1,'Rows %2.0f Columns %2.0f \n', nr,nc);
  % L5 would be in column 9 if it existed
  if nc < 9 & freqtype == 5
     disp('there are no S5 data in this file');
     nofile = true;
     return
  end
  if freqtype == 5 & nc>=9
      % additionally check that there are any non-zero S5 data
      i=find(x(:,9) ~= 0);
      if length(i) == 0
        disp('there are no S5 data in this file')
        nofile = true;
        return
      end
  end
else
  disp('Your file did not exist');
  nofile = true;
  return
end
if nr == 0
    nofile == true;
    disp('Your file was empty')
end

