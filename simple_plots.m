 function simple_plots(plot2screen, plt_type, sineE, saveSNR,f,p);
% function simple_plots(plot2screen, plt_type, sineE, saveSNR,f,p);
% called from gnssIR_lomb.m
% inputs are boolean plot2screen and what plt_type (hardwired for now)
% variables to be plotted (sineE is sine of elevation angle and 
% saveSNR is the windowed SNR data with the direct signal removed)
% the remaining inputs are the periodogram
% data, which are in f and p (frequency and power).
% f units are meters (reflector height) and p is really amplitude 
% volts/volts

% author: kristine m. larson, september 2019

 LW = 2 ; % linewidth for quadrant plots
 if plot2screen
   if plt_type == 1 
     subplot(2,1,1) % raw SNR data
     plot(asind(sineE), saveSNR, '-','linewidth',LW);  hold on;        
     subplot(2,1,2) % periodogram
     plot(f,p,'linewidth',LW) ; hold on;
   else
 % plot all the periodograms on top of each other in gray
     subplot(2,1,1)
     plot(f,p,'color',[0.5 0.5 0.5]); hold on;   
   end  
 end
 