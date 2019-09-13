function set_reflection_env_variables
%function set_reflection_env_variables
% author: kristine m. larson, september 12, 2019
% sets environment variables - hopefully we can get rid of WGET
% but for now, it is needed.  EXE, ORBITS, and REFL_CODE are 
% specific to the reflections code.

setenv('EXE','/Users/kristine/bin')
setenv('ORBITS', '/Users/kristine/Documents/Research/Orbits');
setenv('REFL_CODE','/Users/kristine/Documents/Research');

setenv('WGET', '/usr/local/bin/wget');

end