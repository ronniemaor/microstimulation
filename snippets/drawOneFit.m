function drawOneFit(mask,signal,C,W,isVertical,fit,strTitle)
    nBins = 2;
    [eqMeans, eqStd, eqVals] = sliceStats(signal,mask,C,W,isVertical);
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    eqSEM = sqrt(mean(eqStd.^2,1)/size(eqStd,1)); % estimate SEM over all trials
    
    errorbar(distances, mean(eqMeans,1), eqSEM, '.g');
    hold on
           
    yFit = crossValidationRegression(fit,distances,eqMeans,nBins);
    plot(distances, yFit);
    title(strTitle);
    xlabel('Distance from center (mm)'); 
    ylabel('Relative signal');
end