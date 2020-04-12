# gnssIR_matlab_v3

Update: April 11, 2020
I have updated get_navfile.m. This removes a previous poor choice of nav archive (UNAVCO),
and provides two new and better ones: CDDIS and NGS. As before, it also checks SOPAC.

This code is basd on a previous matlab library that was published in
GPS Solutions (https://link.springer.com/article/10.1007/s10291-018-0744-8) and the GPS Tool Box 
(https://www.ngs.noaa.gov/gps-toolbox/GNSS-IR.htm)
That version is also hosted on this gitHub account.
Version 3 is my attempt to make code available that is better oriented towards
routine analysis and more similar to the python code.

There is no RH dot correction as yet.  There is a simple refraction correction that you 
can turn on/off in the main code.


WARNING: These codes do not calculate soil moisture.


# Installing the code

You need to define three environment variables:

* EXE = where the non-matlab executables will live. 

* ORBITS = where the GPS/GNSS orbits will be stored 

* REFL_CODE = where the reflection code file (SNR files and results) will be stored

* Until I can figure out how to access environment variables in Matlab using bash, you also need
to define the wget executable and store that as environment variable WGET

Executables 

* My RINEX translators are on this gitHub acccount, bu if you are using Linux on a PC or MacOS,
I will be posting static executable files as soon as I get a chance. The ones you need 
must be named gpsSNR.e and gnssSNR.e and stored in EXE.

* CRX2RNX, Compressed to Uncompressed RINEX, which you can find at http://terras.gsi.go.jp/ja/crx2rnx.html 
This must be stored in the EXE directory.


# Running the Code

Change this function to set your environment variables: set_reflection_env_variables.m

The main function call is gnssIR_lomb.m  It has both required and optional inputs.
The function run_mulitple_days.m gives you an idea of how it could be called and used in a loop (i.e. through multiple
days and years). I have also provided testcase_cryosphere.m for a site in Antarctica. 

Required:
* station name (4 characters, lowercase)
* year 
* day of year
* freqtype, for GPS this is 1, 2, or 5. Glonass, 101 or 102. Galileo, 201, 205, 206, 207, 208.
* snrtype is integer shorthand for the kinds of elevation angle data you want to save
from the RINEX file. Here are the allowed options:


* 99 5-30 elev.
* 66 < 30 elev.
* 88 5-90 elev.
* 50 < 10 elev.

* plot2screen - boolean for whether you want to see the raw data plots. You will set 
this to false once you understand your site.

* gps_or_gnss - 1 is for GPS (nav orbits) and 2 is for GNSS (sp3 orbits which include all 
constellations). 


Optional inputs (in this order):

* elevation angle minimum, degrees - default is set to 0.5
* elevation angle maximum, degrees - default is set to 6
* min Reflector Height (m) - default is set to 0.5
* max Reflector Height (m) - default is set to 6
* min Azimuth, degrees - default checks 8 quadrants - 45 degrees each
* max Azimuth, degrees
* minimum allowed Lomb Scargle Periodogram amplitude - 8

Don't ask me where version 2 went - that is a secret.

Kristine M. Larson
https://kristinelarson.net
