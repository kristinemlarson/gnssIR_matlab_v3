function exitS = set_reflection_env_variables
%function set_reflection_env_variables
% author: kristine m. larson, september 12, 2019
% sets environment variables - hopefully we can get rid of WGET
% but for now, it is needed.  EXE, ORBITS, and REFL_CODE are 
% specific to the reflections code.
% returns exitS boolean

setenv('EXE','/Users/kristine/bin')
setenv('ORBITS', '/Users/kristine/Documents/Research/Orbits');
setenv('REFL_CODE','/Users/kristine/Documents/Research');

% workaround for getting the wget variable recognized
setenv('WGET', '/usr/local/bin/wget');


exitS = false;
% check for existence
if ~exist(getenv('REFL_CODE'))
    disp('You have not set the REFL_CODE environment variable to an existing file directory.')
    exitS = true;
end
if ~exist(getenv('ORBITS'))
    disp('You have not set the ORBITS environment variable to an existing file directory.')
    exitS = true;
end
if ~exist(getenv('EXE'))
    disp('You have not set the EXE environment variable to an existing file directory.')
    exitS = true;
end

if ~exist(getenv('WGET'))
    disp('You have not set the WGET environment variable to an existing executable')
    exitS = true;
end

end