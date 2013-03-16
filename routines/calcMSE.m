function err = calcMSE(yTest,yFit)
% Compute MSE between test data and given fit
% Input:
%   yFit: (1 x nPoints) row vector of fit values
%   yTest: (nTrials x nPoints) rows of test data values
% Output:
%   res: MSE value
    nTrials = size(yTest,1);
    yFitDuplicated = yFit(ones(1,nTrials),:);
    squareFitDiffs = (yTest - yFitDuplicated) .^ 2;
    err = mean(squareFitDiffs(:));
end
