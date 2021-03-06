function testFit(fit,debug)
    if nargin < 2
        debug = 0;
    end
    
    % generate ground truth
    paramNames = fit.paramNames();
    nParams = length(paramNames);
    [x,P] = fit.testParamValues();
    y = fit.fitValues(x,P);
    
    % add some noise
    noiseLevel = 0.1 * (max(y) - min(y));
    y = y + rand(1,length(x))*noiseLevel;

    % do the fit
    Pfit = fit.fitParams(x,y,debug);
    yFit = fit.fitValues(x,Pfit);
    
    % calculate R2 of fit
    R2 = calcR2(y,yFit);
    
    % show the results
    plot(x,y,'b',x,yFit,'r');
    strParams = '';
    strFitParams = '';
    for iParam = 1:nParams
        strParams = [strParams, sprintf('%s=%.2g, ', ...
                     paramNames{iParam}, P(iParam))];
        strFitParams = [strFitParams, sprintf('%s=%.2g, ', ...
                     paramNames{iParam}, Pfit(iParam))];
    end    
    title(sprintf('Testing %s\nTruth: %s\nR2 = %.2g\nFitted: %s', fit.name(),strParams, R2, strFitParams));
    xlabel('x');
    ylabel('y');
    legend('Measured values', fit.name());
end