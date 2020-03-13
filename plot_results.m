function plot_results(station, years,OutlierC)
% function plot_results(station, years,OutlierC)
% very very simple code that will apply median filter to RH
% results.
% inputs are station name and vectors of years to be analyzed
% outlierC is used for the median filter.  0.2-0.3 meters is appropriate
% at most sites
% author: kristine m. larson
% 
disp('THIS CODE IS NOT FOR TIDES. HERE WE ARE MAKING A DAILY AVERAGE')
savedData = [];
close all
set_reflection_env_variables;
% number of values needed to make an average
% you can make this bigger or smaller depending on your site.
% 
reqV = 20;

% put in try so it won't crash
try
  reflcode=getenv('REFL_CODE');
  ddd= ['cat ' reflcode '/*/results/' station '/*L*.txt > tmp.txt'];
  unix(ddd); 
  x=load('tmp.txt');
  unix('rm -f tmp.txt');
  allData = [];
  for year = years
    for doy = 1:366
      i=find(x(:,2) == doy & x(:,1) == year);
      if length(i) > reqV
        medianVal = median(x(i,3));
        RH = x(i,3);
        y=x(i,1); d=x(i,2);
        j=find(abs(RH - medianVal) < OutlierC);
        allData = [allData; y(j) d(j) RH(j)];
        savedData = [savedData; year doy mean(RH(j))];
      end
    end
  end
%savedData 
  figure
  y=savedData;
  gray = [0.5 0.5 0.5];
  plot(allData(:,1)+allData(:,2)/365.25, allData(:,3),'.','Color',gray); hold on;
  plot(y(:,1) +y(:,2)/365.25, y(:,3), 'bo','markerfaceColor','b'); 
  legend('all tracks','average')
  set(gca,'Ydir','Reverse')
  xlabel('year'); ylabel('reflector height (meters)')
  grid on;
  title(['station: ' station],'Fontweight','normal')
catch
	disp('something did not work')
end
