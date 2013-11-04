function paperSpeeds(sessionKey)
    figure;
    for isVertical = 0:1
        subplot(1,2,isVertical+1);
        parms = make_parms( ...
            'thresholds', 2.5E-4, ...
            'minFrameForFit', 25, ...
            'maxFrameForFit', 36, ...
            'newFigure', 0, ...
            'showLegend', 0, ...
            'showParamsInTitle', 0, ...
            'onlyShowFittedPoints', 1 ...
        );
        activationBoundaryFits(sessionKey,isVertical,parms);
    end
end
