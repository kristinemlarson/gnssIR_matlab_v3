function outfile = LSP_outputfile(reflcode,station,year,doy,fr);
%function LSP_outputfile(station,cyyyy,cdoy,fr);
% figures out the name of the output file name for LSP calculations
% inputs are the main reflection directory, station, year, day of year, 
% and frequency (integer)
% kristine m. larson september 2019
cyyyy = sprintf('%04d', year );
cdoy = sprintf('%04d', doy );
cyy = cyyyy(3:4);
% output filename
ss = [station '_' cyy '_' cdoy '_L' num2str(fr) '.txt'];
% output filename with directory
outfile = [reflcode '/' cyyyy '/results/' station '/' ss];
end