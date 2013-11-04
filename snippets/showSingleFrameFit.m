function showSingleFrameFit(data,parms)
    if ~exist('parms','var')
        parms = make_parms();
    end

    isVertical_list = take_from_struct(parms,'isVertical',[0,1]);
    frame = take_from_struct(parms,'frame',-1);
    if frame == -1
        data = findPeak(data);
        frame = data.peakFrame;
    end    

    for isVertical = isVertical_list
        % compute the fit
        nBins = 2;
        W = 9;    
        signal = relativeSignal(data.blank, data.stims,frame);
        [eqMeans, eqStd, eqVals] = sliceStats(signal,data.mask,data.C,W,isVertical);
        mmPerPixel = 0.1;
        distances = eqVals * mmPerPixel; % convert to mm
        eqSEM = sqrt(mean(eqStd.^2,1)/size(eqStd,1)); % estimate SEM over all trials
        meanActivations = mean(eqMeans,1);

        % draw it
        myfigure(add_parms(parms,'FontSize',18))
        errorbar(distances, meanActivations, eqSEM, '.g');
        hold on           
        fit = GaussianFit;
        yFit = crossValidationRegression(fit,distances,eqMeans,nBins);
        plot(distances, yFit);
        title(sprintf('%s %s @ %d msec',data.sessionKey, sliceName(isVertical), 10*(frame-25)));
        xlabel('Distance from center (mm)'); 
        ylabel('Relative signal');
        ylim([0 1.05*max(meanActivations+eqSEM)])
        xlim([0 1.05*max(distances)])
    end
end
