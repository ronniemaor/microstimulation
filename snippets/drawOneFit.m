function drawOneFit(mask,signal,C,W,isVertical,parms)
    if ~exist('parms','var')
        parms = make_parms();
    end
    fit = take_from_struct(parms,'fit',GaussianFit);
    ttl = take_from_struct(parms,'ttl','');
    threshold = take_from_struct(parms,'threshold',0);
    
    nBins = 2;
    [eqMeans, eqStd, eqVals] = sliceStats(signal,mask,C,W,isVertical);
    mmPerPixel = 0.1;
    distances = eqVals * mmPerPixel; % convert to mm
    eqSEM = sqrt(mean(eqStd.^2,1)/size(eqStd,1)); % estimate SEM over all trials
    
    errorbar(distances, mean(eqMeans,1), eqSEM, '.g');
    hold on
           
    [yFit,P] = crossValidationRegression(fit,distances,eqMeans,nBins);
    plot(distances, yFit);
    hold on
    if threshold > 0
        x = fit.fitArgs(threshold,P);
        plot([x x],ylim,'r--')
    end
    title(ttl);
    xlabel('Distance from center (mm)'); 
    ylabel('Relative signal');
end