function [ y,emptyfile ] = load_file_nocrash(filename);
%function [y,emptyfile] = =load_file_nocrash(filename);
% given filename, checks for existence before loading
% into the returned variable. Also checks to see if the
% file exists, but
% should check for existence of filename

% input - filename - assumes it can be read with the load command
% i.e. all numbers in columns
%
% output y - the contents of the file
%            emptyfile is a boolean
% Author Kristine Larson
 

%set default outputs
emptyfile = true;
y=[];
try
  y = load(filename);
  [nr,nc]=size(y);
  if nr > 0
    emptyfile = false;
  end
catch
end
