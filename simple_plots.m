 function simple_plots(plot2screen, plt_type, sineE, saveSNR,f,p, LW);
 % freq units on x-axis will be reflector heights (meters) 
     % amplitude units on y-axis will be volts/volts
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
 