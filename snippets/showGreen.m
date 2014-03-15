function showGreen(sessionKey,parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    
    extraMask = take_from_struct(parms,'extraMask',[]);
    
    sessionDir = getSessionDataDir(sessionKey);
    baseDir = fileparts(sessionDir);

    greenFile = [baseDir, '/green.mat'];
    green = load(greenFile);
    green = mean(green.FRMpre,2);
    green(extraMask) = max(green);
    
    myfigure;
    mimg(green,100,100,'auto',0,' '); 
end
