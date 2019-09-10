function fexist = get_navfile(cyyyy,cdoy)
% usd to get this file from sopac, but htye have been
% storing corrupted files, so now it looks at unavco first
% returns boolean with file existence
fexist = false;
cyy = cyyyy(3:4);
autoname = ['auto' cdoy '0.' cyy 'n'];
% executable to get files
wgetexe=getenv('WGET');

sopac =  ['ftp://garner.ucsd.edu/pub/rinex/' cyyyy '/' cdoy '/'];
unavco = ['ftp://data-out.unavco.org/pub/rinex/nav/' cyyyy '/' cdoy '/'];

try
   navname = ['sc02' cdoy '0.' cyy 'n'];
   url = [unavco navname '.Z'];
   unix([wgetexe ' ' url]);
   unix(['uncompress ' navname '.Z']);
   unix(['mv ' navname ' ' autoname]);
catch
    disp('prob at unavco')
end
% should put CDDIS here
% try sopac
if ~exist(autoname)
    try
      navname = autoname;
      url = [sopac navname '.Z'];
      unix([wgetexe ' ' url]);
      unix(['uncompress ' navname '.Z']);
       
    catch
      disp('prob at SOPAC')
      unix(['rm -f  ' navname '.Z']);      
    end
end
if exist(autoname)
    fexist = true;
end
      
