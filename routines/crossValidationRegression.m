function [yFit, P, err, errSem, overfitR2] = ...
         crossValidationRegression(h, x, Y, nBins)
% Input:
% x - 1xN row vector with X axis values of regression points
% Y - MxN matrix. M rows of N regression target values each. 
%     Each row represents a different sample.
% h - Regression class (e.g. GaussianFit), with methods:
%     P = h.fitParams(x,y)
%     y = h.FitValues(x,P)
% nBins - number of cross validation groups. 
%         nBins <= 0 means nBins = M (AKA "leave one out"). 
%         nBins = 1 will use the whole group for both training 
%                   and testing (disables cross validation)
% Output:
% yFit - best fit trained on all data
% P - fit parameters over average of all rows.
% err - average of RMS errors on test set per cross validation training set
% errSem - standard error of mean for the RMS error
% overfitR2 - R2 computed between yFit (on all data) and the AVERAGE
%             of Y over all trials.
    [M,N] = size(Y);
    if nargin < 4
        nBins = 5;
    end
    if nBins <= 0
        nBins = N; % "leave one out"
    end
    
    errSamples = zeros(nBins,M);
    indexes = randperm(N);
    bins = divideToBins(indexes,nBins);
    for iBin = 1:nBins
        for iTrial = 1:M
            if nBins > 1
                trainingCells = bins(1:nBins ~= iBin);
                trainingCols = [trainingCells{:}];
                yTrain = Y(iTrial,trainingCols);
                xTrain = x(trainingCols);
            else
                yTrain = Y(iTrial,:);
                xTrain = x;
            end

            testCols = bins{iBin};
            yTest = Y(iTrial,testCols);
            xTest = x(testCols);

            P = h.fitParams(xTrain,yTrain,yTest);
            yFit = h.fitValues(xTest,P);
            errSamples(iBin,iTrial) = calcR2(yTest,yFit);
        end
    end
    err = mean(errSamples(:));
    errSem = std(errSamples(:)) / sqrt(nBins);
    
    % final fit with all the data
    yAll = mean(Y,1);
    P = h.fitParams(x,yAll,yAll);
    yFit = h.fitValues(x,P);
    overfitR2 = calcR2(yAll,yFit);
end
