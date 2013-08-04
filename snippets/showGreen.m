function showGreen(sessionKey)
    sessionDir = getSessionDataDir(sessionKey);
    baseDir = fileparts(sessionDir);

%     greenFig = [baseDir, '/green.fig'];
%     uiopen(greenFig,1)
    
    figure;
    greenFile = [baseDir, '/green.mat'];
    green = load(greenFile);
    green = mean(green.FRMpre,2);
    mimg(green,100,100,'auto',0,' '); 
end
