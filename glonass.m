function [l1w,l2w]= glonass(prn);
%function [l1w,l2w]= glonass(prn);
% most of the code comes from simon williams
% kristine larson, 17nov02
% input PRN, output l1 and l2 wavelengths for glonass
% in meters
c=299792458; % speed of light
L1= 1602e6;
L2= 1246e6;
dL1= 0.5625e6;
dL2= 0.4375e6;

l1w=nan;
l2w=nan;
slot = [14;15;10;20;19;13;12;1;6;5;22;23;24;16;4;8;3;7;2;18;21;9;17;11];
channel = [-7;0;-7;2;3;-2;-1;1;-4;1;-3;3;2;-1;6;6;5;5;-4;-3;4;-2;4;0];
if prn < 25 & prn > 0
  ch = channel(slot==prn);
  l1w = c/ (L1+ch*dL1);
  l2w = c/ (L2+ch*dL2);
else
  disp('you are trying to calculate wavelength for non-GLONASS PRN')
end
