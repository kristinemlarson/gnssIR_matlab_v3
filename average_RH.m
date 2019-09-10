function  average_RH( plt_type, avg_maxRH, plot2screen )
% function average_RH( plt_type, avg_maxRH, plot2screen )
% called by main code in gnssIR_matlab_v2
% it adds a vertical line where
% the average reflector height (H_R) is.
% Author: Kristine M. Larson, 2019 Sep 6

% only for plots with all azimuths together
if plt_type == 0 
 
  mm = mean(avg_maxRH);
  cmm=sprintf('%4.2f',mm);  
  tx = ['Average H_R: ' cmm '(m)']; disp(tx)
  if plot2screen
    yy = get(gca,'Ylim');
    text(mm+0.25, yy(1)+0.8*diff(yy), tx,'Color','b')
    plot( [mm mm], yy, 'b-','linewidth',2)
  end
end
end

