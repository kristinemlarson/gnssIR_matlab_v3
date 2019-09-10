# gnssIR_matlab_v2
This code is basd on a previous matlab library that was published in
GPS Solutions and the GPS Tool Box. It is also hosted on my gitHub account.
Version 2 is my attempt to make code available that is better oriented towards
routine analysis and parallel to the python code.

There is no refraction error as yet. Nor is the RH dot correction done.

WARNING: These codes do not calculate soil moisture.

# Installing the code

You need to define three environment variables:

* EXE = where the Fortran translator executables will live. Also the code that
translates certain RINEX files is needed and will be stored in this directory.  
I do not control these codes - but they are very important modules in the GPS/GNSS communities.

* ORBITS = where the GPS/GNSS orbits will be stored 

* REFL_CODE = where the reflection code file (SNR files and results) will be stored

* Until I can figure out how to access environment variables in Matlab using bash, you need
to define the wget executable and store that as environment variable WGET


Executables 

* My RINEX translators are on this gitHub acccount, bu if you are using Linux on a PC or MacOS,
I do have static executable files. The one you need should be renamed as gpsSNR.e and gnssSNR.e
and stored in EXE.


* CRX2RNX, Compressed to Uncompressed RINEX, http://terras.gsi.go.jp/ja/crx2rnx.html This must be stored 
in the EXE directory.


Still working on this
