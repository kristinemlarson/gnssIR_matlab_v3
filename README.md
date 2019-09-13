# gnssIR_matlab_v3
This code is basd on a previous matlab library that was published in
GPS Solutions (https://link.springer.com/article/10.1007/s10291-018-0744-8) and the GPS Tool Box 
(https://www.ngs.noaa.gov/gps-toolbox/GNSS-IR.htm)
It is also hosted on this gitHub account.
Version 3 is my attempt to make code available that is better oriented towards
routine analysis and more similar to the python code.

There is no refraction correction in the code as yet. Nor is the RH dot correction done.

WARNING: These codes do not calculate soil moisture.

I am still working on this documentation

# Installing the code

You need to define three environment variables:

* EXE = where the Fortran translator executables will live. Also the code that
translates certain RINEX files is needed and will be stored in this directory.  
I do not control these codes - but they are very important modules in the GPS/GNSS communities.

* ORBITS = where the GPS/GNSS orbits will be stored 

* REFL_CODE = where the reflection code file (SNR files and results) will be stored

* Until I can figure out how to access environment variables in Matlab using bash, you also need
to define the wget executable and store that as environment variable WGET

Executables 

* My RINEX translators are on this gitHub acccount, bu if you are using Linux on a PC or MacOS,
I will be posting static executable files as soon as I get a chance. The one you need should be renamed as gpsSNR.e and gnssSNR.e
and stored in EXE.

* CRX2RNX, Compressed to Uncompressed RINEX, which you can find at http://terras.gsi.go.jp/ja/crx2rnx.html This must be stored 
in the EXE directory.


# Running the Code

Change this function to set your environment variables: set_reflection_env_variables.m

The main function call is gnssIR_lomb.m  It has both required and optional inputs.

Required:
* station name (4 characters, lowercase)
* year 
* day of year
* freqtype, for GPS this is 1, 2, or 5. Glonass, 101 or 102. Galileo, 201, 205, 206, 207, 208.
* snrtype is integer shorthand for the kinds of elevation angle data you want to save
from the RINEX file. Here are the allowed options:

99 5-30 elev.
66 < 30 elev.
88 5-90 elev.
50 < 10 elev.

* plot2screen - boolean for whether you want to see the raw data plots. You will set 
this to false once you understand your site.

* gps_or_gnss - 1 is for GPS (nav orbits) and 2 is for GNSS (sp3 orbits which include all 
constellations). This only matters if you want the code to translate the RINEX file for you.


Optional inputs (in this order):

* elevation angle minimum, degrees
* elevation angle maximum, degrees
* min Reflector Height (m)
* max Reflector Height (m)
* min Azimuth, degrees
* max Azimuth, degrees
* minimum allowed Lomb Scargle Periodogram amplitude. 

Don't ask me where version 2 went - that is a secret.
