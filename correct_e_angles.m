function [ corr_el_deg ] = correct_e_angles( el_deg,Pressure,Temperature )
% inputs are elevation angles (in degrees)
% Pressure in hPa and Temperature in C.
%
% Formula sent to me by Joakim Strandberg, which originally came from
% Bennett, G. G. (1982), The Calculation of Astronomical 
% Refraction in Marine Navigation, The Journal of
% 673 Navigation, Vol. 35(02), 255-259.
% 
% outputs are corrected elevation angles (also in degrees)
% corr_el_arc_min = 510/(9/5*temp + 492) * ...
% press/1010.16 * 1/np.tan(np.deg2rad(el_deg + 7.31/(el_deg + 4.4)))
% kristine m. larson
     insideb = (pi/180)*(el_deg+7.31./(el_deg+4.4));
     % correction in minutes
     corr_el_arc_min = 510/(9/5*Temperature + 492) ...
         * Pressure/1010.16 * 1./tan(insideb);
     % correction in degrees
     correction = corr_el_arc_min/60;
     
     corr_el_deg = el_deg + correction ; 

end

